'use strict';
// The deployed demo must not reintroduce the original HRIS fixture on sync.
module.exports = {
  employees: require('./db/demo-seed.json').users.map(user => ({
    employee_id: 'DEMO-' + user.id,
    first_name: user.first,
    last_name: user.last,
    email: user.email,
    role: user.role,
    status: user.status,
    department: user.department,
    classification: user.classification,
    salary: user.salary,
    hire_date: user.hireDate
  })),
  attendance: [],
  leaveRecords: []
};
