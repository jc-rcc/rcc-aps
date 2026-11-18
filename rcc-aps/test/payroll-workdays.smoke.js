const fs = require('fs'), vm = require('vm'), assert = require('assert/strict');
const src = fs.readFileSync(__dirname + '/../public/js/payroll.js', 'utf8');
const input = { value: '26' };
const ctx = vm.createContext({ document: { getElementById: () => input }, WORK_DAYS: 22 });
vm.runInContext(src.match(/function calcAbsenceWorkDays[\s\S]*?\n}/)[0], ctx);
for (const [value, expected] of [['26',26],['22',22],['20.5',20.5],['',null],['0',null],['32',null],['bad',null]]) {
  input.value = value;
  assert.equal(vm.runInContext('calcAbsenceWorkDays()',ctx),expected);
}
// Exercise both monthly-paid branches from the calculator with a local divisor.
const compute = src.slice(src.indexOf('function computePayroll()'));
const start = compute.indexOf('  } else if (isTeaching) {');
const end = compute.indexOf("  const noteEl",start);
const branch = 'if (false) {' + compute.slice(start,end);
for (const isTeaching of [true,false]) {
  const monthly = vm.createContext({isTeaching, rateEl:{value:'26000'},attEl:{value:'2'},workDays:26,WORK_DAYS:22,fmt:n=>String(n),gross:0,meta:''});
  vm.runInContext(branch,monthly);
  assert.equal(monthly.gross,24000);
  assert.equal(monthly.WORK_DAYS,22);
  assert.match(monthly.meta,/2 ÷ 26/);
}
for (const isTeaching of [true,false]) {
  const monthly = vm.createContext({isTeaching,rateEl:{value:'26080'},attEl:{value:'1'},workDays:26.08,WORK_DAYS:26.08,fmt:n=>String(n),gross:0,meta:''});
  vm.runInContext(branch,monthly);
  assert.equal(monthly.gross,25080,'One absence at a 26.08 divisor deducts exactly 1000 from 26080');
  assert.match(monthly.meta,/1 ÷ 26.08/);
}
console.log('PASS: divisor validation, local overrides, and 26.08 decimal absence calculations for Elementary and Non-Teaching.');
