'use strict';
const { isSchoolEmail } = require('./school-identity');
// HRIS credentials are consumed only on the server, never sent to the browser.
function hrisSubmission(current, data, actor) {
  const submitted = { stateRevision:current.stateRevision, users:structuredClone(current.users), auth:{}, leaveTypes:structuredClone(current.leaveTypes), leaveRecords:structuredClone(current.leaveRecords), attendance:structuredClone(current.attendance) };
  const counts = { added:0, updated:0, skipped:0, leaves:0 };
  let nextUser = current.nextUserId, nextLeave = current.nextLeaveRecordId, nextType = current.nextLeaveTypeId;
  for (const entry of data.employees || []) {
    const email = String(entry.email || '').toLowerCase();
    if (!isSchoolEmail(email)) { counts.skipped++; continue; }
    let user = submitted.users.find(user => user.email.toLowerCase() === email);
    if (actor.role === 'admin') {
      if (!user) {
        if (!entry.password || entry.password.length < 6) { counts.skipped++; continue; }
        user = { id:nextUser++ }; submitted.users.push(user);
        submitted.auth[user.id] = {id:user.id,pass:entry.password}; counts.added++;
      } else counts.updated++;
      for (const key of ['first','last','email','role','status','department','classification','hireDate','schoolLevel']) if (entry[key] !== undefined) user[key] = entry[key];
      if (!user.date) user.date = new Date().toISOString().slice(0,10);
    } else if (user) {
      for (const key of ['salary','hourlyRate']) if (entry[key] !== undefined) user[key] = entry[key];
      counts.updated++;
    } else counts.skipped++;
  }
  if (actor.role === 'finance') {
    for (const entry of data.leaveRecords || []) {
      const user = current.users.find(user => user.email.toLowerCase() === String(entry.employee_email || '').toLowerCase());
      if (!user) continue;
      const name = entry.leave_type || 'Other Leave';
      let type = submitted.leaveTypes.find(type => type.name.toLowerCase() === name.toLowerCase());
      if (!type) { type={id:nextType++,name,isPaid:false};submitted.leaveTypes.push(type); }
      if (!submitted.leaveRecords.some(row => row.empId===user.id && row.typeId===type.id && row.startDate===entry.start_date && row.endDate===entry.end_date)) {
        submitted.leaveRecords.push({id:nextLeave++,empId:user.id,typeId:type.id,startDate:entry.start_date,endDate:entry.end_date,days:entry.days || 1});counts.leaves++;
      }
    }
  }
  return { submitted, counts };
}
module.exports = { hrisSubmission };
