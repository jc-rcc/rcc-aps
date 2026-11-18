'use strict';
const fs = require('node:fs');
const vm = require('node:vm');
const assert = require('node:assert/strict');
const source = fs.readFileSync(__dirname + '/../public/js/payroll.js', 'utf8');
const elements = {};
const element = id => elements[id] ||= {value:'',style:{},dataset:{},textContent:'',innerHTML:''};
element('calcEmp').value = '8';
element('payPeriod').value = 'November 2026';
element('calcSemester').value = '2nd';
element('calcSchoolYear').value = '2026-2027';
const employee = {id:8,classification:'Teaching',schoolLevel:'Elementary',salary:18000};
const context = vm.createContext({
  currentCalcTab:'Elementary',payrollRecords:[],users:[employee],WORK_DAYS:22,
  MONTHS:['January','February','March','April','May','June','July','August','September','October','November','December'],
  teachingLoadRecords:[{id:1,empId:8,semester:'2nd',schoolYear:'2026-2027'}],
  teachingLoadClasses:[{recordId:1,subject:'Elementary Math',level:'Elementary',days:'M,W',hoursPerWeek:2,timeStart:'8:00 AM',timeEnd:'9:00 AM'}],
  document:{getElementById:element,querySelectorAll:()=>[]},esc:s=>String(s || ''),displayName:()=> 'Test Teacher',
  periodHasData:()=>false,teacherRate:()=>999,renderCalcCustomInputs(){},syncCalcTeachingYears(){},
  tlDaysParse:()=>['M','W'],tlParseTimeRange:()=>({hours:1}),
  getEmpCashAdvance:()=>0,computePayroll(){},updateCalcStatusBadge(){},renderLeaveBreakdown(){}
});
for (const name of ['calcHoursPerWorkload','syncCalcTabUI','formatCalcQty','calcScheduledMonthHours','latestTeachingLoads','renderCalcTeachingReference','loadEmployeeData']) {
  vm.runInContext(source.match(new RegExp('function '+name+'\\([^]*?\\n}'))[0],context);
}
vm.runInContext('syncCalcTabUI(); loadEmployeeData()',context);
assert.equal(element('calcTeachingLoadSection').style.display,'block');
assert.equal(element('calcExplanationRow').style.display,'none');
assert.match(element('calcTeachingLoadReference').innerHTML,/Elementary Math/);
assert.match(element('calcTeachingLoadReference').innerHTML,/monthly salary and absences/);
assert.equal(element('calcSalary').value,18000);
element('calcSemester').value='1st';
vm.runInContext('loadEmployeeData()',context);
assert.equal(element('calcTeachingLoadReference').style.display,'none');
assert.match(element('calcTeachingTermStatus').textContent,/No saved Teaching Load/);
assert.equal(element('calcSalary').value,18000);
console.log('PASS: Elementary schedule reference loads by selected term, clears missing terms, and retains monthly salary computation inputs.');
