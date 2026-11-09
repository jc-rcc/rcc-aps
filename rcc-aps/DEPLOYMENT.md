# RCC-APS deployment: Docker, Cloudflare Tunnel, and GitHub Actions

## Decision and architecture

RCC-APS uses static HTML/CSS/JavaScript, Node.js 22 with Express, and a MySQL database. Express already serves both the frontend and API, so the application can run as one persistent container without a frontend build step.

The selected host is the team's existing always-on Windows computer. Docker Desktop runs Linux containers through WSL2. Docker Compose manages:

- `app`: Node.js/Express on private port 3000, running as a non-root user.
- `db`: MySQL 8.4, using a named volume for persistent data and a database-scoped application account.
- `cloudflared`: a named, remotely managed Cloudflare Tunnel publishing the app through an HTTPS hostname.

Request path: browser -> Cloudflare HTTPS -> cloudflared -> app -> MySQL. Only cloudflared and app share the web network. MySQL is on a separate internal network. Production does not publish host ports for either the application or database.

CI/CD uses GitHub-hosted runners. A temporary Tailscale connection lets the deployment job reach Windows OpenSSH privately. Tailscale carries deployment traffic; Cloudflare Tunnel carries application traffic. No production Actions runner is installed on this public repository's host.

## Cost, scaling, and limitations

Existing hardware avoids renting an application server, but electricity, connectivity, domain registration, backup storage, and applicable provider quotas still have costs. Record the actual domain and any paid plans before submitting. Do not describe this as guaranteed free hosting.

The initial setup uses one app container and one database. Capacity is bounded by this computer's CPU, memory, storage, and upload speed; Compose does not provide automatic multi-host scaling or zero-downtime releases. More traffic would require measured capacity planning, a stronger host, and potentially a managed database. Google sign-in challenges are currently stored in memory, so multiple app replicas would require shared challenge storage or affinity.

The computer must stay powered on, awake, online, and running Docker Desktop. Restart policies restart containers when the Docker engine runs; they do not start Docker Desktop before Windows sign-in. Verify recovery after a reboot. A volume protects data during container replacement, but not against disk failure or volume deletion. Backups must also be copied off this computer.

Cloudflare Tunnel provides public routing, not compute or database storage. A stable published application requires a domain on Cloudflare. A temporary Quick Tunnel is not the final submission URL. See [Cloudflare prerequisites](https://developers.cloudflare.com/tunnel/get-started/).

## Alternatives considered

| Option | Reason it was not selected |
| --- | --- |
| Vercel / Netlify | Convenient managed deployment, but the team selected a persistent Express process and local database under its control. RCC-APS already has a Vercel adapter, so Vercel is a viable alternative rather than an incompatible platform. |
| Cloudflare Pages / Workers | Pages suits static assets; moving this conventional Express/MySQL server to Workers would require additional runtime and database integration work. Tunnel preserves the existing server. |
| Docker on AWS ECS or a VPS | Better separation from a personal workstation and potentially better availability, but adds hosting costs and infrastructure administration for this assignment. |
| LAN-only / XAMPP | Useful for local development but does not provide the stable public HTTPS URL required for the submission. Docker plus Tunnel makes this on-premise host publicly reachable. |

Existing `api/index.js` and `vercel.json` are unused by this deployment. Disconnect any previous Vercel auto-deploy integration in its dashboard when switching production; repository files cannot disable an external account's integration.

## Clean demonstration database

This deployment initializes a NEW MySQL volume from `server/db/demo-seed.json`:

- Three synthetic accounts: `demo.admin@rcc.edu.ph`, `demo.finance@rcc.edu.ph`, and `demo.employee@rcc.edu.ph`.
- Initial password: the randomly generated `DB_SEED_PASSWORD` in the host-only `.env` file. It is hashed before storage. Change each account's password before sharing the public demo.
- No existing payroll, attendance, leave records, personal profiles, photographs, or teaching-load records.
- Existing application tax tables, contribution settings, leave types, and rank configuration are retained as sample configuration, not certified as current payroll rules.

The original seed and HRIS fixture are excluded from the Docker build context. The image uses a synthetic HRIS fixture so pressing Sync does not import the original records. The original repository's fixtures and SQL dump remain in source control; this setup does not purge repository history or sanitize those source files.

Seeding only initializes an empty users table. Editing the seed or changing `DB_SEED_PASSWORD` does not overwrite an existing database or reset existing passwords. Do not delete a volume to refresh demo data without first reviewing and backing it up.

Google sign-in is disabled initially. Demo addresses are synthetic and are intended for password login. Enable Google sign-in only for real, authorized, pre-registered school accounts and configure the final HTTPS origin in the Google OAuth web client.

## Local preview on Windows

From the repository root in PowerShell, with Docker Desktop running Linux containers:

```powershell
node scripts/configure-demo.cjs
docker build --tag rcc-aps:local ./rcc-aps
docker compose -f compose.yaml -f compose.local.yaml up -d --wait --wait-timeout 240 db app
```

Open `http://localhost:3000`. Read the initial password from your local `.env`; do not paste it into chat or a repository. The helper refuses to overwrite existing secrets. The local override binds the preview port only to loopback and uses the separate `rcc-aps-preview` project/volume. It is not used in production.

## One-time Windows host setup

1. Start Docker Desktop with the WSL2 Linux backend. Confirm `docker version` shows a server and `docker compose version` works. Keep Windows signed in and disable automatic sleep while hosting.
2. Run the host preparation helper from the repository root:

   ```powershell
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File scripts/Setup-WindowsHost.ps1
   ```

   It creates `%USERPROFILE%\rcc-aps-production` and a fresh `.env`, preserving an existing one. This is separate from the repository's local preview `.env`. The SSH account must be this same Windows user so Docker Desktop access and the production directory match.
3. Install and sign in to Tailscale on this PC. Record its Tailscale IPv4 address or DNS name. Create an OAuth client with `auth_keys` write scope and ownership of `tag:ci`. In the tailnet policy, permit `tag:ci` to reach only this host's SSH port. See the [official Actions integration](https://github.com/tailscale/github-action).
4. Install/enable Windows OpenSSH Server, configure key authentication, and test that the deployment account can run `docker version` through SSH. Generate a dedicated CI SSH key; place only its public key in the server's authorized keys. Administrator accounts use `%ProgramData%\ssh\administrators_authorized_keys` with Microsoft's required ACLs; standard accounts use their own `.ssh\authorized_keys`. Follow [Microsoft installation](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse) and [key management](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_keymanagement).
5. Restrict the Windows SSH firewall rule to the Tailscale interface/address and test access over Tailscale. Do not forward router ports. Verify the Windows SSH host key locally before adding it to GitHub's `DEPLOY_KNOWN_HOSTS` secret.
6. Acquire/use a domain, add it to Cloudflare, and create a named tunnel. Route the chosen public hostname to `http://app:3000` (not localhost: cloudflared is a separate container). Store its connector token only as `CLOUDFLARE_TUNNEL_TOKEN` in the production `.env`.
7. Keep production `.env` and backup files readable only by the hosting account and administrators. Do not upload them. Ensure Docker Desktop is accessible from the SSH account before enabling automated deployment.
8. GitHub Container Registry packages are initially private. After the first publish, either configure authenticated pulls on the host using a token with `read:packages`, or deliberately make this cleaned demo image public. Do not paste registry tokens into chat. See [GitHub registry authentication](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry).

Windows SSH user names in this workflow must be simple local account names containing letters, numbers, dots, underscores, or hyphens. Domain/Entra accounts require adapting the connection configuration.

## GitHub settings

Create a `production` environment, restricted to `main`. To meet the automatic deployment requirement, do not require manual approval on every successful merge. Add repository-level Actions variables (so job conditions can see them):

| Variable | Value |
| --- | --- |
| `DEPLOY_ENABLED` | Set to `true` only after host/domain/secrets are ready. Leave unset during preparation. |
| `PUBLIC_URL` | Final HTTPS origin, e.g. `https://aps.example.com`. No path. |
| `DEPLOY_PORT` | `22` unless using a different SSH port. |

Add these secrets in the `production` environment:

| Secret | Purpose |
| --- | --- |
| `DEPLOY_HOST` | This PC's Tailscale IPv4 address or DNS name. |
| `DEPLOY_USER` | Windows SSH account used for Docker Desktop and the production folder. |
| `DEPLOY_SSH_KEY` | Dedicated CI private SSH key; its public half is installed on Windows. |
| `DEPLOY_KNOWN_HOSTS` | Verified OpenSSH known_hosts line, e.g. `100.x.y.z ssh-ed25519 <public-host-key>`; for non-default ports use `[host]:port`. |
| `TS_OAUTH_CLIENT_ID` | Tailscale OAuth client ID. |
| `TS_OAUTH_SECRET` | Tailscale OAuth secret for the tagged ephemeral CI connection. |

Database passwords, JWT secret, demo bootstrap password, tunnel token, and optional Google/HRIS configuration live on the Windows host in `.env`. The workflow does not copy application secrets from GitHub. It uses the automatically issued `GITHUB_TOKEN` to publish images.

Protect `main` and require successful `smoke-tests` and `container-tests` checks before merging. Workflow file: [`.github/workflows/ci.yml`](../.github/workflows/ci.yml).

## CI/CD pipeline

1. Pushes to `main` or `deployment/**`, and pull requests to `main`, trigger validation. An optional manual rerun is also available.
2. GitHub installs Node.js 22 dependencies with `npm ci` and runs all smoke-test scripts via `npm test`.
3. Container validation builds the production image, ensures original fixtures are absent, starts fresh MySQL/app containers, checks readiness and cleaned records, and runs the existing database and Google sign-in integration suites against isolated test databases. CI's elevated test user is confined to that disposable CI database server.
4. Only a successful run on `main` publishes a commit-tagged image to GHCR. Deployment references its immutable SHA-256 digest.
5. Once `DEPLOY_ENABLED=true`, a GitHub-hosted runner joins Tailscale, verifies the SSH host key, uploads the Compose/scripts bundle, and invokes Windows PowerShell on this PC. No untrusted pull-request job receives production secrets.
6. The host pulls the image, waits for MySQL, takes a SQL backup, replaces the application/tunnel containers, and waits for application readiness. It records the previous successful app image and Compose file. The workflow then checks the public HTTPS readiness endpoint through Cloudflare. Failure fails the job; it does not silently report success.

The `DEPLOY_ENABLED` switch is a one-time commissioning control, not a per-release upload step. With it unset this is CI/image publishing only and the assignment's CD requirement is not yet complete. After enabling it, every successful main merge deploys automatically.

## Backups and rollback

Each automated deployment creates a SQL dump under `%USERPROFILE%\rcc-aps-production\backups` before app startup/migrations. Copy backups off the PC and practice restoration into a separate test database. No retention deletion is automated; monitor disk usage. A dump of an initially empty database is expected on the first deployment.

To take a backup between releases, run `scripts/Backup.ps1` from your source checkout. It uses the active production Compose file by default. To restart the recorded active release manually:

```powershell
$root = Join-Path $env:USERPROFILE 'rcc-aps-production'
docker compose --project-directory $root --env-file "$root/.env" --env-file "$root/.release.env" -f "$root/compose.yaml" --profile tunnel up -d --no-build --wait
```

`scripts/Rollback.ps1` restores the previous application image/configuration after you review database migration compatibility. It does not reverse database migrations or restore database contents. Do not automatically roll back the database: restoration must be deliberate and validated. A failed rollout may leave the new app unhealthy; the script stops and records a failed Actions job rather than guessing whether an older app is safe against the changed schema.

## Submission and verification status

Submit these after commissioning:

- Live URL: **pending domain and first verified public deployment**.
- Workflow: `https://github.com/jc-rcc/rcc-aps/blob/main/.github/workflows/ci.yml` after merging these files.
- Architecture document: `https://github.com/jc-rcc/rcc-aps/blob/main/rcc-aps/DEPLOYMENT.md` after merging these files.
- Evidence: successful Actions run, live login, role-scoped access, saving a demo record, and data surviving container recreation.

Preparation checks passed locally: 14 smoke-test scripts, workflow validation with actionlint, Compose configuration validation, and PowerShell syntax checks. Docker image execution and database integration checks have not yet run on this PC because the session could not access the Docker engine. The workflow includes those checks and must pass before claiming a successful deployment. No public deployment or uptime claim is made yet.
