'use strict';
const assert = require('node:assert/strict');
const { upgradeSchema } = require('../server/db/upgrade-schema');
(async () => {
  let exists = false;
  const mutations = [];
  const connection = { async query(sql) {
    if (sql.includes("COLUMN_NAME='absenceRecords'")) return [exists ? [{COLUMN_NAME:'absenceRecords'}] : []];
    if (sql.startsWith('ALTER TABLE')) { mutations.push(sql); exists = true; return [[]]; }
    if (sql.includes("cfg_key='schemaVersion'")) return [[{cfg_value:'2'}]];
    throw new Error('Unexpected migration query: ' + sql);
  }};
  await upgradeSchema(connection);
  await upgradeSchema(connection);
  assert.deepEqual(mutations,['ALTER TABLE payroll_records ADD COLUMN absenceRecords MEDIUMTEXT NULL']);
  console.log('PASS: existing v2 database receives absence-record column once, without rewriting payroll amounts.');
})().catch(error => { console.error(error); process.exitCode = 1; });
