'use strict';
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const root = process.argv[2] ? path.resolve(process.argv[2]) : path.resolve(__dirname, '..');
const secret = () => crypto.randomBytes(32).toString('hex');
const content = [
  '# Host-only configuration. Never commit or share this file.',
  `DB_PASSWORD=${secret()}`,
  `MYSQL_ROOT_PASSWORD=${secret()}`,
  `JWT_SECRET=${secret()}`,
  `DB_SEED_PASSWORD=${secret()}`,
  'CLOUDFLARE_TUNNEL_TOKEN=',
  'HRIS_API_URL=',
  'HRIS_API_KEY=',
  ''
].join('\n');
try {
  fs.writeFileSync(path.join(root, '.env'), content, { flag: 'wx', mode: 0o600 });
  console.log('Created .env with random secrets. Credentials were not printed.');
  console.log('Initial account: System Admin. Username: admin.');
  console.log('Its initial password is DB_SEED_PASSWORD in your local .env.');
} catch (error) {
  if (error.code !== 'EEXIST') throw error;
  console.error('.env already exists; left it unchanged.');
  process.exitCode = 1;
}
