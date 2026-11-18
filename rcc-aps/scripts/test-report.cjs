'use strict';
// Each integration script creates and removes its own uniquely named test database.
const fs = require('node:fs');
const path = require('node:path');
const { spawnSync } = require('node:child_process');
const root = path.resolve(__dirname, '..');
const args = process.argv.slice(2);
if (args.some(arg => !['--integration', '--windows'].includes(arg))) {
  console.error('Usage: npm run test:report -- [--integration] [--windows]');
  process.exit(2);
}
const files = fs.readdirSync(path.join(root, 'test')).filter(f => f.endsWith('.smoke.js')).sort();
if (args.includes('--integration')) files.push('database-upgrade.integration.js', 'system-admin.integration.js');
if (args.includes('--windows')) {
  if (process.platform !== 'win32') { console.error('--windows requires Windows.'); process.exit(2); }
  files.push('windows-launcher.integration.js');
}
const startedAt = new Date().toISOString();
const out = path.join(root, 'tmp', 'test-reports', startedAt.replace(/[:.]/g, '-'));
fs.mkdirSync(out, { recursive: true });
const suites = [];
for (const file of files) {
  const start = Date.now();
  const result = spawnSync(process.execPath, [path.join(root, 'test', file)], {
    cwd: root, encoding: 'utf8', timeout: 180000, maxBuffer: 8 * 1024 * 1024,
    env: { ...process.env, JWT_SECRET: 'test-only-report-signing-secret' }
  });
  const status = result.error?.code === 'ETIMEDOUT' ? 'TIMEOUT' : result.status === 0 && !result.error ? 'PASS' : 'FAIL';
  const log = [result.stdout, result.stderr, result.error?.message].filter(Boolean).join('\n');
  fs.writeFileSync(path.join(out, file + '.log'), log);
  suites.push({ file, status, durationMs: Date.now() - start, exitCode: result.status, signal: result.signal });
  console.log(`${status} ${file} (${suites.at(-1).durationMs} ms)`);
}
const git = spawnSync('git', ['rev-parse', 'HEAD'], { cwd: root, encoding: 'utf8' });
const report = { startedAt, finishedAt: new Date().toISOString(), node: process.version,
  platform: process.platform, commit: git.status === 0 ? git.stdout.trim() : 'unknown',
  scope: 'Local automated suites only; manual acceptance cases and school deployment are not verified.',
  suites, passed: suites.filter(s => s.status === 'PASS').length, total: suites.length };
fs.writeFileSync(path.join(out, 'results.json'), JSON.stringify(report, null, 2));
const escape = value => String(value).replace(/[&<>"']/g, c => ({ '&':'&amp;', '<':'&lt;', '>':'&gt;', '"':'&quot;', "'":'&#39;' })[c]);
fs.writeFileSync(path.join(out, 'report.html'), `<!doctype html><html lang="en"><meta charset="utf-8"><title>RCC APS Test Results</title><style>body{font:16px system-ui;max-width:1000px;margin:40px auto;padding:20px}table{border-collapse:collapse;width:100%}td,th{border:1px solid #ddd;padding:10px;text-align:left}th{background:#eee}</style><h1>RCC APS Test Results</h1><p>${report.passed}/${report.total} suites passed. Started ${escape(startedAt)}</p><p>${escape(report.scope)}</p><p>Commit ${escape(report.commit)} | Node ${escape(report.node)}</p><table><tr><th>Suite</th><th>Status</th><th>Duration ms</th></tr>${suites.map(s=>`<tr><td><a href="${encodeURIComponent(s.file + '.log')}">${escape(s.file)}</a></td><td>${s.status}</td><td>${s.durationMs}</td></tr>`).join('')}</table></html>`);
console.log(`Report: ${path.join(out, 'report.html')}`);
process.exitCode = report.passed === report.total ? 0 : 1;
