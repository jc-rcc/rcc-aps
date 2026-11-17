'use strict';
const assert = require('node:assert/strict');
const mysql = require('mysql2/promise');
const database = 'rcc_aps_hs_validation_' + Date.now();
process.env.DB_NAME = database;
process.env.DB_SEED_FILE = require('path').resolve(__dirname,'../server/db/demo-seed.json');
process.env.DB_SEED_PASSWORD = 'test-only-hs-bootstrap-password';
let root,server;
async function run() {
  root=await mysql.createConnection({host:process.env.DB_HOST||'localhost',port:Number(process.env.DB_PORT||3306),user:process.env.DB_USER||'root',password:process.env.DB_PASSWORD||''});
  await require('../server/db/init').init();
  const db=require('../server/db');
  const initial=await db.assembleState();
  const password='test-only-finance-and-employee-password';
  const hash=await require('bcryptjs').hash(password,10);
  for(const [id,role,label] of [[2,'finance','Finance Officer'],[3,'employee','Employee']]) {
    initial.users.push({id,first:'HS',last:role,email:role+'.hs.test@rcc.edu.ph',role:label,status:'Active',classification:id===3?'Teaching':'Non-Teaching',schoolLevel:id===3?'High School':'',hourlyRate:id===3?1300:0});
    initial.auth[id]={id,email:role+'.hs.test@rcc.edu.ph',role,label,status:'Active',page:id===2?'financePage':'empPage',pass:hash};
  }
  initial.teachingLoadRecords=[{id:1,empId:3,semester:'1st',schoolYear:'2026-2027',classification:'Teaching',level:'High School',rate:1300,rateUnit:'per Workload',workloadType:'hours',workloadValue:9,computedPay:17160}];
  initial.teachingLoadClasses=['Math','English','AP'].map((subject,index)=>({id:index+1,recordId:1,subject,level:'High School',deptCode:'HS',days:'M,W,F',timeStart:'8:00 AM',timeEnd:'9:00 AM',hoursPerWeek:3,sortOrder:index}));
  await db.persistState(initial);
  const reference=await db.assembleState();
  server=require('../server/server').app.listen(0,'127.0.0.1');
  await new Promise(resolve=>server.once('listening',resolve));
  const base='http://127.0.0.1:'+server.address().port;
  async function request(route,token,body) {
    const response=await fetch(base+route,{method:body?'POST':'GET',headers:{...(token?{Authorization:'Bearer '+token}:{}),...(body?{'Content-Type':'application/json'}:{})},body:body?JSON.stringify(body):undefined});
    return {status:response.status,data:await response.json()};
  }
  const finance=await request('/api/auth/login',null,{email:'finance.hs.test@rcc.edu.ph',password});assert.equal(finance.status,200);
  const token=finance.data.token;
  const loaded=(await request('/api/data',token)).data;
  const record={empId:3,name:'HS employee',month:11,monthName:'November',year:2026,period:'November 2026',date:'2026-11-17',gross:5633.33,net:5633.33,sss:0,phil:0,pag:0,bir:0,cash:0,bonuses:[],customDeds:[],teachingSemester:'1st',teachingSchoolYear:'2026-2027',subjectBreakdown:[5,4,4].map((hours,index)=>({type:'subject',subject:['Math','English','AP'][index],level:'High School',deptCode:'HS',days:'M,W,F',totalHours:hours,hoursPerWorkload:3,quantityUnit:'workloads',qty:hours/3,rate:1300,amount:Number((hours/3*1300).toFixed(2))}))};
  const saved=await request('/api/data',token,{...loaded,payrollRecords:[record]});assert.equal(saved.status,200,JSON.stringify(saved.data));
  const [stored]=await db.q('SELECT subjectBreakdown FROM payroll_records WHERE empId=? AND month=?',[3,11]);
  const details=JSON.parse(stored.subjectBreakdown);
  assert.equal(details[0].totalHours,5);assert.equal(details[0].qty,5/3);assert.equal(details[0].amount,2166.67);
  const employee=await request('/api/auth/login',null,{email:'employee.hs.test@rcc.edu.ph',password});assert.equal(employee.status,200);
  const payslip=(await request('/api/data',employee.data.token)).data.payrollRecords[0];
  assert.equal(payslip.subjectBreakdown[1].totalHours,4);assert.equal(payslip.subjectBreakdown[1].hoursPerWorkload,3);
  const bad=structuredClone(record);bad.subjectBreakdown[0].qty=5;bad.subjectBreakdown[0].amount=6500;
  const rejected=await request('/api/data',token,{...saved.data.state,payrollRecords:[bad]});assert.equal(rejected.status,400);assert.match(rejected.data.error,/hours and workload amounts/);
  const fresh=(await request('/api/data',token)).data;
  const historical={...structuredClone(record),month:10,monthName:'October',period:'October 2026',gross:9100,net:9100,subjectBreakdown:[{type:'subject',subject:'Older workload entry',qty:7,rate:1300,amount:9100}]};
  const legacy=await request('/api/data',token,{...fresh,payrollRecords:[record,historical]});assert.equal(legacy.status,200,JSON.stringify(legacy.data));
  const after=await db.assembleState();
  assert.equal(after.payrollRecords.find(r=>r.month===10).subjectBreakdown[0].qty,7);
  assert.equal(after.payrollRecords.find(r=>r.month===11).subjectBreakdown[0].qty,5/3);
  assert.deepEqual(after.teachingLoadRecords,reference.teachingLoadRecords);
  assert.deepEqual(after.teachingLoadClasses,reference.teachingLoadClasses);
  console.log('PASS: real Finance API saves HS hours/workloads without rounding loss, employee reads saved payslip detail, invalid conversions are rejected, legacy quantities and Teaching Load records stay unchanged.');
}
run().catch(error=>{console.error(error);process.exitCode=1;}).finally(async()=>{
  if(server)await new Promise(resolve=>server.close(resolve));
  if(root){
    if(!/^rcc_aps_hs_validation_\d+$/.test(database))throw Error('Unsafe test cleanup');
    await root.query('DROP DATABASE IF EXISTS `'+database+'`');await root.end();
  }
  process.exit(process.exitCode||0);
});
