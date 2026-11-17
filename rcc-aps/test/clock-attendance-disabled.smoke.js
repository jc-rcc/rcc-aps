'use strict';
const fs=require('node:fs'),vm=require('node:vm'),assert=require('node:assert/strict');
const payroll=fs.readFileSync(__dirname+'/../public/js/payroll.js','utf8');
const html=fs.readFileSync(__dirname+'/../public/index.html','utf8');
assert.doesNotMatch(html,/attendanceList|hrisAttSyncBtn|Clock In|Clock Out|clock-in/i);
const context=vm.createContext({ATTENDANCE:[{empId:3,date:'2026-11-02',hours:8}],LEAVE_RECORDS:[],LEAVE_TYPES:[{id:1,name:'Unpaid',isPaid:false},{id:2,name:'Paid',isPaid:true}]});
for(const name of ['getLeaveBreakdown','getTotalUnpaidDaysAll','periodHasData']) {
 const fn=payroll.match(new RegExp('function '+name+'\\([^]*?\\n}'));assert.ok(fn);vm.runInContext(fn[0],context);
}
assert.equal(vm.runInContext('periodHasData(3,11,2026)',context),false);
assert.equal(vm.runInContext('getTotalUnpaidDaysAll(3,11,2026)',context),0,'Historical clocks must not create missing-clock deductions');
context.LEAVE_RECORDS.push({empId:3,typeId:1,startDate:'2026-11-03',endDate:'2026-11-04',days:2},{empId:3,typeId:2,startDate:'2026-11-05',endDate:'2026-11-05',days:1});
assert.equal(vm.runInContext('periodHasData(3,11,2026)',context),true);
assert.equal(vm.runInContext('getTotalUnpaidDaysAll(3,11,2026)',context),2,'Only unpaid leave counts');
const {hrisSubmission}=require('../server/hris-sync');
const {mergeState}=require('../server/state-access');
(async()=>{
 const state=structuredClone(require('../server/db/demo-seed.json'));
 state.users.push({id:3,first:'Finance',last:'Test',email:'finance.test@rcc.edu.ph',role:'Finance Officer',status:'Active',salary:10000,hourlyRate:100,hoursWorked:5,absenceDays:1});
 const actor={id:3,role:'finance',status:'Active'};state.auth[3]=actor;
 state.attendance=[{empId:3,date:'2026-11-02',hours:8,clockInAt:'08:00',clockOutAt:'16:00'}];
 const before=structuredClone(state.attendance);
 const {submitted,counts}=hrisSubmission(state,{employees:[{email:'finance.test@rcc.edu.ph',salary:12000,hourlyRate:120,hoursWorked:999,absenceDays:22}],attendance:[{employeeEmail:'finance.test@rcc.edu.ph',date:'2026-11-02',clockInAt:'00:00',clockOutAt:'23:00'}],leaveRecords:[{employee_email:'finance.test@rcc.edu.ph',leave_type:'Test Leave',start_date:'2026-11-03',end_date:'2026-11-03',days:1}]},actor);
 assert.equal(submitted.users.at(-1).hoursWorked,5);assert.equal(submitted.users.at(-1).absenceDays,1);assert.equal(submitted.users.at(-1).salary,12000);assert.equal(counts.leaves,1);assert.deepEqual(submitted.attendance,before);
 for(const attendance of [[],[{empId:3,date:'2026-11-02',hours:23}]]) {
  const merged=await mergeState(state,{attendance},actor);assert.deepEqual(merged.attendance,before,'Stale clients cannot change attendance history');
 }
 const server=fs.readFileSync(__dirname+'/../server/server.js','utf8');
 const requests=[];const api=vm.createContext({HRIS_API_URL:'https://hris.test',HRIS_API_KEY:'',console,mapHrisEmployee:e=>e,fetch:async url=>{requests.push(url);return {ok:true,json:async()=>[]};}});
 vm.runInContext(server.match(/async function fetchHrisData\([^]*?\n}/)[0],api);
 await api.fetchHrisData();assert.deepEqual(requests,['https://hris.test/employees','https://hris.test/leave-requests']);
 console.log('PASS: clock UI/import disabled, historical attendance protected, no missing-clock deductions, paid/unpaid leave and compensation sync preserved.');
})().catch(e=>{console.error(e);process.exitCode=1;});
