'use strict';
const fs = require('node:fs'), vm = require('node:vm'), assert = require('node:assert/strict');
const read = file => fs.readFileSync(__dirname+'/../public/'+file,'utf8');
const html = read('index.html');
const elements = Object.fromEntries([...html.matchAll(/\bid="([^"]+)"/g)].map(m => [m[1],{value:'',innerHTML:'',textContent:'',style:{},dataset:{},scrollIntoView(){}}]));
const levels = ['Non-Teaching','Elementary','High School','College','Graduate School'];
const users = levels.map((level,i) => ({id:i+1,first:'Person'+i,last:'Test',role:'Employee',classification:i?'Teaching':'Non-Teaching',schoolLevel:i?level:'',salary:0,status:i===4?'Inactive':'Active'}));
const payrollRecords = users.map(u => ({empId:u.id,month:11,year:2026,gross:u.id*1000,net:u.id*900,sss:10,phil:20,pag:30,bir:40,name:u.first,date:'Nov 19, 2026',absenceRecords:[{date:'2026-11-18',description:'Missed class',amount:25.50}]}));
let printed=0;
const pages=[];
const context = vm.createContext({users,payrollRecords,loggedInUser:{id:99,role:'finance'},
  MONTHS:['January','February','March','April','May','June','July','August','September','October','November','December'],
  ROLE_PAGE:{Employee:'empPage'},EMP_CLASS:{Teaching:{badge:'teach'},'Non-Teaching':{badge:'nt'}},
  document:{getElementById:id=>elements[id]||null},fmt:n=>'P'+Number(n).toFixed(2),esc:s=>String(s),displayName:u=>u.first+' '+u.last,
  showToast(){},showFinPage:id=>pages.push(id),printPayslip:()=>printed++});
vm.runInContext(read('js/reports.js'),context);
const payroll=read('js/payroll.js');
for(const name of ['getPayrollRecords','reportMonthsFor','showMonthReport','showYearReport']) vm.runInContext(payroll.match(new RegExp('function '+name+'\\([^]*?\\n}'))[0],context);
const auth=read('js/auth.js');
vm.runInContext(auth.slice(auth.indexOf('function viewPayslipDetail('),auth.indexOf('\nfunction printPayslip(')),context);
for(const [i,level] of levels.entries()) {
  elements.employeePsLevel.value=elements.govLevel.value=elements.rptLevel.value=level;
  vm.runInContext('renderEmployeePayslips(); renderGovReport(11,2026); showMonthReport(11,2026,"November")',context);
  for(const id of ['employeePsBody','govBody','rptBody']) {
    assert.match(elements[id].innerHTML,new RegExp('Person'+i));
    for(let j=0;j<5;j++) if(i!==j) assert.doesNotMatch(elements[id].innerHTML,new RegExp('Person'+j));
  }
  assert.match(elements.reportTitle.textContent,new RegExp(level));
  assert.match(elements.govReportTitle.textContent,new RegExp(level));
  vm.runInContext('showYearReport(2026)',context);
  assert.match(elements.rptBody.innerHTML,new RegExp('Person'+i));
  assert.match(elements.rptTotals.innerHTML,new RegExp('P'+((i+1)*900)+'.00'));
}
elements.employeePsLevel.value='';vm.runInContext('renderEmployeePayslips()',context);
assert.equal(elements.employeePsCount.textContent,'5 released payslip(s)');
elements.employeePsSearch.value='person2';vm.runInContext('renderEmployeePayslips()',context);
assert.equal(elements.employeePsCount.textContent,'1 released payslip(s)');
elements.employeePsMonth.value='10';vm.runInContext('renderEmployeePayslips()',context);
assert.match(elements.employeePsBody.innerHTML,/No released payslips/);
vm.runInContext('openEmployeePayslip(3,11,2026,true)',context);
assert.equal(printed,1);assert.equal(pages.at(-1),'finPayslipDetail');
assert.match(elements.finPsDoc.innerHTML,/Person2 Test/);
assert.match(elements.finPsDoc.innerHTML,/Missed class/);
assert.match(elements.finPsDoc.innerHTML,/P2700.00/);
assert.equal(elements.psDoc.innerHTML,'','Finance must render the employee document inside Finance, not the hidden employee dashboard');
elements.finPsBackBtn.onclick();assert.equal(pages.at(-1),'finReports');
context.loggedInUser.role='employee';
vm.runInContext('openEmployeePayslip(4,11,2026,true)',context);
assert.equal(printed,1,'Employee role cannot open Finance reports');
assert.match(elements.finPsDoc.innerHTML,/Person2 Test/);
console.log('PASS: five report levels, salary-zero/inactive released records, monthly and yearly reports, name/period filters, Finance employee payslip view/download/back navigation, and role guard.');
