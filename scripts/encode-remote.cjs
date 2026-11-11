'use strict';
const fs = require('node:fs');
const path = require('node:path');
const sha = process.env.RELEASE_SHA || '';
const image = process.env.RELEASE_IMAGE || '';
if (!/^[a-f0-9]{40}$/.test(sha) || !/^ghcr\.io\/[a-z0-9._/-]+@sha256:[a-f0-9]{64}$/.test(image)) {
  throw new Error('Invalid release SHA or immutable image digest.');
}
const script = fs.readFileSync(path.join(__dirname, 'remote-deploy.ps1'), 'utf8')
  .replaceAll('__SHA__', sha).replaceAll('__IMAGE__', image);
process.stdout.write(Buffer.from(script, 'utf16le').toString('base64'));
