'use strict';
const assert = require('node:assert/strict');
const mysql = require('mysql2/promise');
const database = 'rcc_aps_admin_validation_' + Date.now();
process.env.DB_NAME = database;
process.env.DB_SEED_FILE = require('path').resolve(__dirname,'../server/db/demo-seed.json');
process.env.DB_SEED_PASSWORD = 'test-only-original-admin-password';
process.env.DEMO_DATA_ONLY = 'true';
let root, server;
async function run() {
  root = await mysql.createConnection({host:process.env.DB_HOST||'localhost',port:Number(process.env.DB_PORT||3306),user:process.env.DB_USER||'root',password:process.env.DB_PASSWORD||''});
  await require('../server/db/init').init();
  const db = require('../server/db');
  const initial = await db.assembleState();
  assert.equal(initial.users.length,1);
  assert.equal(initial.auth[1].role,'admin');
  initial.users[0].email='demo.admin@rcc.edu.ph';initial.auth[1].email='demo.admin@rcc.edu.ph';
  for (const [id,name,label] of [[2,'finance','Finance Officer'],[3,'employee','Employee']]) {
    initial.users.push({id,first:'Demo',last:name,email:`demo.${name}@rcc.edu.ph`,role:label,status:'Active',classification:'Non-Teaching'});
    initial.auth[id]={id,email:`demo.${name}@rcc.edu.ph`,role:name,status:'Active',pass:initial.auth[1].pass,label,page:name==='finance'?'financePage':'empPage'};
  }
  await db.persistState(initial);
  const nextPassword='test-only-updated-admin-password';
  await require('../server/db/system-admin').updateSystemAdmin(nextPassword);
  const updated=await db.assembleState();
  assert.equal(updated.users.length,1);assert.equal(Object.keys(updated.auth).length,1);
  assert.equal(updated.users[0].first+' '+updated.users[0].last,'System Admin');
  assert.ok(await require('bcryptjs').compare(nextPassword,updated.auth[1].pass));
  server=require('../server/server').app.listen(0,'127.0.0.1');
  await new Promise(resolve=>server.once('listening',resolve));
  const login=async(email,password)=>fetch(`http://127.0.0.1:${server.address().port}/api/auth/login`,{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({email,password})});
  let response=await login('admin',nextPassword);assert.equal(response.status,200);assert.equal((await response.json()).user.role,'admin');
  assert.equal((await login('ADMIN',nextPassword)).status,200);
  assert.equal((await login('admin',process.env.DB_SEED_PASSWORD)).status,401);
  assert.equal((await login('demo.finance@rcc.edu.ph',process.env.DB_SEED_PASSWORD)).status,401);
  assert.equal((await login('demo.employee@rcc.edu.ph',process.env.DB_SEED_PASSWORD)).status,401);
  const unexpected=await db.assembleState();
  unexpected.users.push({id:4,first:'Real',last:'Account',email:'real.account@rcc.edu.ph',role:'Employee',status:'Active'});
  unexpected.auth[4]={id:4,email:'real.account@rcc.edu.ph',pass:updated.auth[1].pass,role:'employee',status:'Active',label:'Employee',page:'empPage'};
  await db.persistState(unexpected);
  await assert.rejects(require('../server/db/system-admin').updateSystemAdmin(nextPassword),/outside the original demo/);
  assert.equal((await db.assembleState()).users.length,2);
  await root.query('UPDATE `'+database+'`.auth SET role=\'employee\' WHERE id=1');
  assert.equal((await login('admin',nextPassword)).status,401,'The admin username must never resolve to a non-admin account');
  console.log('PASS: fresh admin-only seed, live demo cleanup, password hashing, admin username login, removed credentials denied, and unknown-account preservation.');
}
run().catch(error=>{console.error(error);process.exitCode=1;}).finally(async()=>{
  if(server)await new Promise(resolve=>server.close(resolve));
  if(root){
    if(!/^rcc_aps_admin_validation_\d+$/.test(database))throw Error('Unsafe test cleanup');
    await root.query('DROP DATABASE IF EXISTS `'+database+'`');await root.end();
  }
  process.exit(process.exitCode||0);
});
