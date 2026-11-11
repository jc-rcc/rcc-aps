'use strict';
const fs = require('node:fs');
const path = require('node:path');
const { spawnSync } = require('node:child_process');
const root = path.resolve(__dirname, '..');
const files = fs.readdirSync(path.join(root, 'test')).filter(file => file.endsWith('.smoke.js')).sort();
for (const file of files) {
  console.log(`Running ${file}`);
  const result = spawnSync(process.execPath, [path.join(root, 'test', file)], {
    cwd: root, stdio: 'inherit', timeout: 60000,
    env: { ...process.env, JWT_SECRET: process.env.JWT_SECRET || 'test-only-smoke-signing-secret' }
  });
  if (result.error) console.error(result.error.message);
  if (result.status !== 0) process.exit(result.status || 1);
}
console.log(`PASS: ${files.length} smoke-test scripts.`);
