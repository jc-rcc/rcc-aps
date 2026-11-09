'use strict';
const { isSchoolEmail } = require('../school-identity');
function planAdminUpdate(state, password) {
  if (typeof password !== 'string' || password.trim() !== password || password.length < 6 || Buffer.byteLength(password,'utf8') > 72) {
    throw new Error('Use a password of 6-72 UTF-8 bytes without leading or trailing spaces.');
  }
  const admin = state.users.find(user => user.id === 1);
  const account = Object.values(state.auth).find(auth => auth.id === 1);
  if (!admin || !account || account.role !== 'admin' || account.status !== 'Active' || !isSchoolEmail(admin.email)) {
    throw new Error('The expected active System Admin account was not found. No accounts were changed.');
  }
  const demos = new Map([[2,'demo.finance@rcc.edu.ph'],[3,'demo.employee@rcc.edu.ph']]);
  for (const user of state.users) {
    if (user.id !== 1 && demos.get(user.id) !== user.email.toLowerCase()) {
      throw new Error('An account outside the original demo accounts exists. No accounts were changed.');
    }
  }
  return {
    users: [{ ...admin, first: 'System', last: 'Admin', email: 'admin@rcc.edu.ph', role: 'System Admin', status: 'Active', department: 'Administration' }],
    auth: { 1: { id: 1, pass: password } },
    stateRevision: state.stateRevision
  };
}
async function updateSystemAdmin(password) {
  const db = require('../db');
  const state = await db.assembleState();
  // Existing state validation, bcrypt hashing, history protections, database
  // locking, revision checks, and transaction handling are reused unchanged.
  await db.saveClientState(planAdminUpdate(state,password), { id: 1 });
  const updated = await db.assembleState();
  if (updated.users.length !== 1 || Object.values(updated.auth).length !== 1 || updated.auth[1].role !== 'admin') {
    throw new Error('System Admin verification failed.');
  }
  return { users: 1, username: 'admin', displayName: 'System Admin' };
}
module.exports = { planAdminUpdate, updateSystemAdmin };
async function verifyAdmin(password) {
  const response = await fetch('http://127.0.0.1:3000/api/auth/login', {
    method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({email:'admin',password}),signal:AbortSignal.timeout(10000)
  });
  const data = await response.json();
  if (!response.ok || data.user?.id !== 1 || data.user?.role !== 'admin') throw new Error('The new System Admin login could not be verified.');
  const state = await require('../db').assembleState();
  if (state.users.length !== 1 || state.users[0].first + ' ' + state.users[0].last !== 'System Admin') throw new Error('The sole System Admin display name could not be verified.');
  return { verified:true,username:'admin',displayName:'System Admin',users:1 };
}
if (require.main === module) {
  let input = '';
  process.stdin.setEncoding('utf8');
  process.stdin.on('data', chunk => { input += chunk; if (input.length > 2048) process.exit(1); });
  process.stdin.on('end', async () => {
    try {
      const payload = JSON.parse(input.replace(/^\uFEFF/,''));
      input = '';
      console.log(JSON.stringify(await (process.argv.includes('--verify') ? verifyAdmin(payload.password) : updateSystemAdmin(payload.password))));
      process.exit(0);
    } catch (error) { console.error(error.message); process.exit(1); }
  });
}
