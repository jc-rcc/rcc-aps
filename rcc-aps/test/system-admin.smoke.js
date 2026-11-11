'use strict';
const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const { planAdminUpdate } = require('../server/db/system-admin');
const { mergeState } = require('../server/state-access');
async function run() {
  const state = structuredClone(require('../server/db/demo-seed.json'));
  const originalAdmin = state.auth[1];
  state.auth[1] = { ...originalAdmin, pass: await require('bcryptjs').hash('previous-test-password',10) };
  for (const [id,name,role] of [[2,'finance','Finance Officer'],[3,'employee','Employee']]) {
    state.users.push({ id,first:'Demo',last:name,email:`demo.${name}@rcc.edu.ph`,role,status:'Active' });
    state.auth[id] = {id,email:`demo.${name}@rcc.edu.ph`,role:name,status:'Active',pass:state.auth[1].pass};
  }
  const password = 'test-only-new-admin-password';
  const merged = await mergeState(state,planAdminUpdate(state,password),state.auth[1]);
  assert.equal(merged.users.length,1);
  assert.equal(merged.users[0].first + ' ' + merged.users[0].last,'System Admin');
  assert.equal(merged.auth[1].role,'admin');
  assert.equal(Object.keys(merged.auth).length,1);
  assert.ok(await require('bcryptjs').compare(password,merged.auth[1].pass));
  assert.deepEqual(merged.teacherRanks,state.teacherRanks);
  assert.equal(state.users.length,3,'Planning and merging must not mutate the original state');
  const unknown = structuredClone(state);unknown.users[1].email='real.person@rcc.edu.ph';
  assert.throws(()=>planAdminUpdate(unknown,password),/outside the original demo/);
  const history = structuredClone(state);history.attendance=[{empId:2,date:'2026-01-01',hours:1}];
  await assert.rejects(mergeState(history,planAdminUpdate(history,password),history.auth[1]),/must be deactivated/);

  let errorShown=false;
  const elements = {emailInp:{value:'admin'},passInp:{value:password},errBox:{classList:{remove(){errorShown=false;},add(){errorShown=true;}}},errText:{textContent:''}};
  let submitted, completed;
  const context = vm.createContext({document:{getElementById:id=>elements[id],addEventListener(){}},setInterval(){}});
  vm.runInContext(fs.readFileSync(__dirname+'/../public/js/auth.js','utf8'),context);
  let cleared=false;
  context.syncDemo=async()=>false;
  context.clearAuthToken=()=>{cleared=true;};
  await vm.runInContext('completeLogin({id:1,role:"admin"})',context);
  assert.equal(cleared,true);assert.equal(errorShown,true);
  assert.match(elements.errText.textContent,/Unable to load/);
  context.checkLogin = async (email,pass) => {submitted={email,pass};return {ok:true,user:{id:1,role:'admin'}};};
  context.completeLogin = async user => {completed=user;};
  await vm.runInContext('handleLogin()',context);
  assert.equal(submitted.email,'admin');assert.equal(completed.role,'admin');assert.equal(errorShown,false);
  console.log('PASS: sole generic System Admin, hashed password, known-demo removal, history/unknown-account protection, and frontend username login.');
}
run().catch(error=>{console.error(error);process.exitCode=1;});
