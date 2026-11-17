'use strict';
const fs = require('node:fs');
const vm = require('node:vm');
const assert = require('node:assert/strict');
const source = fs.readFileSync(__dirname+'/../public/js/payroll.js','utf8');
const html = fs.readFileSync(__dirname+'/../public/index.html','utf8');
const elements = Object.fromEntries([...html.matchAll(/\bid="([^"]+)"/g)].map(m=>[m[1],{value:'',innerHTML:'',textContent:'',style:{},dataset:{}}]));
const rows = [];
const prefills = [];
function row(subject, hours, rate, type='subject') {
  const fields = {
    input:{value:subject},'.calc-qty':{value:String(hours)},'.calc-rate':{value:String(rate)},
    '.calc-days':{value:'M,W,F'},'.calc-dept':{value:'HS'},'.calc-level-sel':{value:'High School'},
    '.calc-workloads':{textContent:''},'.calc-amt':{textContent:''}
  };
  return {dataset:{type},querySelector:selector=>fields[selector]||null,fields};
}
elements.calcSubjectBody.querySelectorAll=()=>rows;
Object.defineProperty(elements.calcSubjectBody,'innerHTML',{get:()=>'',set:()=>{rows.length=0;}});
elements.calcEmp.value='3';elements.payPeriod.value='November 2026';
elements.calcSemester.value='1st';elements.calcSchoolYear.value='2026-2027';
const employee={id:3,first:'Sample',last:'Teacher',classification:'Teaching',schoolLevel:'High School',role:'Employee',rankName:'HS Rank',rankRate:1300};
const context=vm.createContext({
  _savedDemo:{},WORK_DAYS:22,HOURS_PER_WORKLOAD:3,users:[employee],currentCalcTab:'High School',lastCalc:null,
  MONTHS:['January','February','March','April','May','June','July','August','September','October','November','December'],
  fmt:n=>'P'+Number(n).toFixed(2),esc:s=>String(s??''),displayName:u=>u.first+' '+u.last,teacherRate:u=>u.rankRate,
  document:{getElementById:id=>elements[id]||null,querySelectorAll:selector=>selector==='#calcSubjectBody tr'?rows:[],addEventListener(){}},
  periodHasData:()=>false,syncCalcTeachingYears(){},renderCalcCustomInputs(){},getEmpCashAdvance:()=>0,
  updateCalcStatusBadge(){},renderLeaveBreakdown(){},activeBonusTypes:()=>[],periodEndDate:()=>new Date(),
  splitBonuses:()=>({deMinimisSum:0,taxableSum:0}),thirteenthEligibility:()=>({eligible:false}),
  splitBonusTaxable:()=>({taxable13:0,exempt13:0}),collectCustomOverrides:()=>({}),BONUS_EXEMPTION_LIMIT:90000,
  thirteenthTaxSplit:()=>({annualTax:0}),computeDeductions:(gross,cash)=>({net:gross-cash,sss:0,phil:0,pag:0,bir:0,cash,custom:[],customTotal:0})
});
vm.runInContext(fs.readFileSync(__dirname+'/../public/js/teachingload.js','utf8'),context);
for(const name of ['calcHoursPerWorkload','formatCalcQty','calcSubjectNumbers','syncCalcRankRates','recomputeCalcTotals','calcScheduledMonthHours','latestTeachingLoads','renderCalcTeachingReference','calcAbsenceWorkDays','loadEmployeeData','computePayroll']) {
  const fn=source.match(new RegExp('function '+name+'\\([^]*?\\n}'));
  assert.ok(fn,'Missing function '+name);vm.runInContext(fn[0],context);
}
context.addCalcSubject=p=>{prefills.push(p);rows.push(row(p.subject,p.qty,p.rate));};
vm.runInContext(`teachingLoadRecords=[{id:1,empId:3,semester:'1st',schoolYear:'2026-2027'}];
  teachingLoadClasses=['Math','English','AP'].map(subject=>({recordId:1,subject,level:'High School',deptCode:'HS',days:'M,W,F',timeStart:'8:00 AM',timeEnd:'9:00 AM',hoursPerWeek:3}));`,context);
const teachingBefore=vm.runInContext('JSON.stringify({teachingLoadRecords,teachingLoadClasses})',context);
vm.runInContext('loadEmployeeData()',context);
assert.equal(prefills.length,3);
assert.ok(prefills.every(p=>p.qty===''&&p.fromTeachingLoad),'Finance hours must start blank, not import calendar hours/workloads');
assert.match(elements.calcTeachingLoadReference.innerHTML,/Math/);
assert.match(elements.calcTeachingLoadReference.innerHTML,/8:00 AM/);
assert.equal(context.lastCalc,null,'Blank actual hours must block payroll release');
for(const [index,hours] of [5,4,4].entries())rows[index].fields['.calc-qty'].value=String(hours);
vm.runInContext('computePayroll()',context);
assert.equal(context.lastCalc.gross,5633.33);
assert.equal(elements.calcTotalHours.textContent,'13');
assert.equal(elements.calcTotalQty.textContent,'4.333333');
assert.equal(rows[0].fields['.calc-workloads'].textContent,'1.666667');
const saved=JSON.parse(JSON.stringify(context.lastCalc));
assert.equal(saved.subjectBreakdown[0].totalHours,5);
assert.equal(saved.subjectBreakdown[0].hoursPerWorkload,3);
assert.equal(saved.subjectBreakdown[0].qty,5/3);
assert.equal(saved.subjectBreakdown[0].amount,2166.67);
assert.equal(saved.subjectBreakdown[1].amount,1733.33);
assert.equal(teachingBefore,vm.runInContext('JSON.stringify({teachingLoadRecords,teachingLoadClasses})',context),'Finance entry must not modify the employee Teaching Load');
for(const value of ['','-1','bad','Infinity']) {
  rows[0].fields['.calc-qty'].value=value;vm.runInContext('computePayroll()',context);
  assert.equal(context.lastCalc,null,'Invalid hours must clear the previous calculation: '+value);
  assert.equal(elements.calcSubjectHoursErr.style.display,'block');
}
rows[0].fields['.calc-qty'].value='0';vm.runInContext('computePayroll()',context);assert.ok(context.lastCalc,'Explicit zero hours are allowed');
rows[0].fields['.calc-qty'].value='5';rows.push(row('',2,50,'increment'));
vm.runInContext('computePayroll()',context);
assert.equal(context.lastCalc.gross,5733.33);
assert.equal(elements.calcTotalQty.textContent,'4.333333','Increment quantities are not teaching workloads');
assert.equal(context.lastCalc.subjectBreakdown[3].qty,2);
assert.equal(context.lastCalc.subjectBreakdown[3].totalHours,undefined);
context.HOURS_PER_WORKLOAD=4;vm.runInContext('computePayroll()',context);assert.equal(context.lastCalc.gross,4325);
context.HOURS_PER_WORKLOAD=3;
context.currentCalcTab='College / Graduate';employee.schoolLevel='College';employee.rankRate=190;
vm.runInContext('computePayroll()',context);assert.equal(context.lastCalc.gross,2570);
assert.equal(context.lastCalc.subjectBreakdown[0].qty,5);assert.equal(context.lastCalc.subjectBreakdown[0].totalHours,undefined);
employee.schoolLevel='Graduate School';employee.rankRate=230;
vm.runInContext('computePayroll()',context);assert.equal(context.lastCalc.gross,3090);
employee.schoolLevel='High School';employee.rankRate=1300;

// A released HS payroll must show its saved workload/pay, not current profile estimates.
elements.payrollSummaryBody={innerHTML:'',closest:()=>null};
context.users[0].status='Active';context.payrollRecords=[saved];context.empGrossPay=()=>99999;
context.EMP_CLASS={Teaching:{badge:'teaching'}};
vm.runInContext(source.match(/function renderPayrollSummary\([^]*?\n}/)[0],context);
vm.runInContext('renderPayrollSummary()',context);
assert.match(elements.payrollSummaryBody.innerHTML,/4\.333333 wl/);
assert.match(elements.payrollSummaryBody.innerHTML,/P5633\.33/);
assert.doesNotMatch(elements.payrollSummaryBody.innerHTML,/99999/);

// Verify the generated UI makes imported schedule metadata read-only while hours remain editable.
let generated;
const ui=vm.createContext({currentCalcTab:'High School',esc:s=>String(s),calcLevelOpts:()=>'',recomputeCalcTotals(){},
  document:{getElementById:()=>({appendChild:tr=>{generated=tr.innerHTML;}}),createElement:()=>({dataset:{},innerHTML:''})}});
vm.runInContext(source.match(/function addCalcSubject\([^]*?\n}/)[0],ui);
vm.runInContext("addCalcSubject({subject:'Math',qty:'',fromTeachingLoad:true})",ui);
assert.match(generated,/readonly/);assert.match(generated,/<output class="calc-workloads"/);
assert.doesNotMatch(generated.match(/<input[^>]*class="fi calc-qty"[^>]*>/)[0],/readonly|disabled/);

// Server-side validation accepts the new saved detail and rejects tampered conversions.
(async()=>{
  const state=structuredClone(require('../server/db/demo-seed.json'));
  state.users.push({id:2,first:'Finance',last:'Test',email:'finance.test@rcc.edu.ph',role:'Finance Officer',status:'Active'},employee);
  state.auth[2]={id:2,role:'finance',status:'Active'};
  const {mergeState}=require('../server/state-access');
  const merged=await mergeState(state,{payrollRecords:[saved]},state.auth[2]);
  assert.equal(merged.payrollRecords[0].subjectBreakdown[0].totalHours,5);
  assert.equal(merged.payrollRecords[0].subjectBreakdown[0].qty,5/3);
  const invalid=structuredClone(saved);invalid.subjectBreakdown[0].qty=5;
  await assert.rejects(mergeState(state,{payrollRecords:[invalid]},state.auth[2]),/hours and workload amounts/);
  invalid.subjectBreakdown[0].totalHours=-1;
  await assert.rejects(mergeState(state,{payrollRecords:[invalid]},state.auth[2]),/Invalid High School subject hours/);
  const legacy=structuredClone(saved);for(const entry of legacy.subjectBreakdown){delete entry.totalHours;delete entry.hoursPerWorkload;delete entry.quantityUnit;}
  const old=await mergeState(state,{payrollRecords:[legacy]},state.auth[2]);
  assert.equal(old.payrollRecords[0].subjectBreakdown[0].qty,5/3,'Existing workload-only payrolls must not be reinterpreted');
  console.log('PASS: manual HS hours, 5+4+4 example, full-precision workloads, immutable Teaching Load reference, blank/invalid-hour guards, increments, College/Graduate rates, and saved-detail validation.');
})().catch(error=>{console.error(error);process.exitCode=1;});
