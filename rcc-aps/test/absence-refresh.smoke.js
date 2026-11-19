'use strict';
const fs = require('node:fs');
const vm = require('node:vm');
const assert = require('node:assert/strict');
const absence = [{ date:'2026-11-19', description:'Missed morning class', amount:250.55 }];
let stored;
let nativeJson = false;
const connection = {
  beginTransaction:async()=>{}, commit:async()=>{}, rollback:async()=>{}, release(){},
  query:async(sql, params=[]) => {
    if (sql.startsWith('SELECT * FROM `payroll_records`')) return [[...(stored ? [stored] : [])]];
    if (sql.startsWith('INSERT INTO `payroll_records`')) {
      const columns = sql.match(/\(([^)]+)\)/)[1].split(',').map(s=>s.replaceAll('`',''));
      stored = Object.fromEntries(columns.map((column,i)=>[column,params[i]]));
    }
    return [[]];
  }
};
const pool = {
  getConnection:async()=>connection,
  execute:async sql => {
    if (/FROM payroll_records/.test(sql) && stored) {
      const row=structuredClone(stored);
      if (nativeJson) for (const key of ['absenceRecords','bonuses','subjectBreakdown','customDeds']) row[key]=JSON.parse(row[key]);
      return [[row]];
    }
    return [[]];
  }
};
function freshBackend() {
  const ctx=vm.createContext({module:{exports:{}},require:name=>name==='mysql2/promise'?{createPool:()=>pool}:name==='./db/state-writer'?require('../server/db/state-writer'):{},process:{env:{}},console});
  vm.runInContext(fs.readFileSync(__dirname+'/../server/db.js','utf8'),ctx);
  return ctx.module.exports;
}
const payrollSource=fs.readFileSync(__dirname+'/../public/js/payroll.js','utf8');
const authSource=fs.readFileSync(__dirname+'/../public/js/auth.js','utf8');
const render=authSource.slice(authSource.indexOf('function viewPayslipDetail('),authSource.indexOf('\nfunction printPayslip('));
const html=fs.readFileSync(__dirname+'/../public/index.html','utf8');
const MONTHS=['January','February','March','April','May','June','July','August','September','October','November','December'];
(async()=>{
  await freshBackend().persistState({payrollRecords:[{empId:3,name:'Test Employee',month:11,monthName:'November',year:2026,period:'November 2026',gross:20000,net:19000,absenceRecords:absence}]});
  assert.equal(stored.absenceRecords,JSON.stringify(absence));
  for (nativeJson of [false,true]) {
    // Discard the submitted object and reload exclusively from database values.
    const state=await freshBackend().assembleState();
    assert.equal(JSON.stringify(state.payrollRecords[0].absenceRecords),JSON.stringify(absence));
    for (const level of ['Non-Teaching','Elementary','High School','College','Graduate School']) {
      const elements=Object.fromEntries([...html.matchAll(/\bid="([^"]+)"/g)].map(m=>[m[1],{innerHTML:'',style:{}}]));
      const ctx=vm.createContext({payrollRecords:state.payrollRecords,MONTHS,users:[{id:3,role:'Employee',first:'Test',last:'Employee',classification:level==='Non-Teaching'?'Non-Teaching':'Teaching',schoolLevel:level}],ROLE_PAGE:{Employee:'empPage'},document:{getElementById:id=>elements[id]||null},fmt:n=>'P'+Number(n).toFixed(2),esc:String,displayName:u=>u.first+' '+u.last,showToast:()=>assert.fail('Saved payslip missing')});
      vm.runInContext(payrollSource.match(/function payslipRecordsFor[\s\S]*?\n}/)[0],ctx);
      assert.equal(vm.runInContext('payslipRecordsFor(3,2026)[0].absenceRecords[0].amount',ctx),250.55);
      vm.runInContext(render,ctx);
      vm.runInContext("viewPayslipDetail('November 2026',3)",ctx);
      assert.match(elements.psDoc.innerHTML,/2026-11-19/);
      assert.match(elements.psDoc.innerHTML,/Missed morning class/);
      assert.match(elements.psDoc.innerHTML,/P250.55/);
      assert.match(elements.psDoc.innerHTML,/class="ps-net">P19000.00/);
    }
  }
  console.log('PASS: saved absence date, description and decimal amount survive a fresh database load and payslip rendering across five levels, for TEXT and native JSON columns; totals remain unchanged.');
})().catch(error=>{console.error(error);process.exitCode=1;});
