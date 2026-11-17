'use strict';
const fs=require('node:fs'),vm=require('node:vm'),assert=require('node:assert/strict');
const auth=fs.readFileSync(__dirname+'/../public/js/auth.js','utf8');
const rolePages={admin:'adminPage',finance:'financePage',employee:'empPage'};
function fixture({role='employee',status=200,offline=false,sync=true,token='saved-token'}={}) {
 const storage=new Map(token?[['rcc_aps_jwt_token',token]]:[]),elements={},events={},calls=[];
 for(const id of ['loginBtn','btnText','loginPage','errText','errBox',...Object.values(rolePages)]) {
  const classes=new Set();elements[id]={value:'',style:{},classList:{add:c=>classes.add(c),contains:c=>classes.has(c),remove:c=>classes.delete(c)}};
 }
 const ctx=vm.createContext({ROLE_PAGE:{'System Admin':'adminPage','Finance Officer':'financePage',Employee:'empPage'},ROLE_ICON:{},DEMO_KEY:'rcc_aps_demo_v1',localStorage:{getItem:k=>storage.get(k)||null,setItem:(k,v)=>storage.set(k,v),removeItem:k=>storage.delete(k)},document:{getElementById:id=>elements[id]||null,addEventListener:(event,cb)=>events[event]=cb},setInterval(){},syncDemo:async()=>{calls.push('sync');return sync;},fetch:async(url,options)=>{calls.push(url);assert.equal(options.headers.Authorization,'Bearer saved-token');assert.equal(options.cache,'no-store');if(offline)throw Error('offline');return {status,ok:status===200,json:async()=>({user:{id:3,role,status:'Active',page:'adminPage'}})};}});
 vm.runInContext(auth,ctx);ctx.initPage=page=>calls.push(page);
 return {ctx,elements,events,calls,storage};
}
(async()=>{
 for(const role of Object.keys(rolePages)) {
  const f=fixture({role});assert.equal(await f.events.DOMContentLoaded(),true);
  assert.equal(vm.runInContext('loggedInUser.page',f.ctx),rolePages[role],'Verified role controls dashboard, ignoring stale page claims');
  assert.equal(f.elements.loginPage.style.display,'none');assert.ok(f.elements[rolePages[role]].classList.contains('show'));
  assert.deepEqual(f.calls,['/api/auth/me','sync',rolePages[role]]);assert.equal(f.storage.get('rcc_aps_jwt_token'),'saved-token');assert.equal(f.elements.loginBtn.disabled,false);
 }
 for(const options of [{status:401},{status:503},{offline:true},{sync:false},{token:null}]) {
  const f=fixture(options);assert.equal(await f.events.DOMContentLoaded(),false);assert.equal(vm.runInContext('loggedInUser',f.ctx),null);
  for(const page of Object.values(rolePages))assert.equal(f.elements[page].classList.contains('show'),false,'Never expose cached dashboard before authenticated data loads');
  if(options.status===401)assert.equal(f.storage.has('rcc_aps_jwt_token'),false);
  else if(options.token!==null)assert.equal(f.storage.get('rcc_aps_jwt_token'),'saved-token','Transient failures preserve a retryable session');
 }
 const f=fixture();let resolve;f.ctx.fetch=()=>new Promise(r=>resolve=r);const pending=f.ctx.restoreSession();vm.runInContext('clearAuthToken()',f.ctx);resolve({status:200,ok:true,json:async()=>({user:{id:3,role:'employee',status:'Active'}})});assert.equal(await pending,false,'Logout during restoration must not reopen the account');
 console.log('PASS: refresh restores verified Admin/Finance/Employee sessions; stale roles ignored; expired/revoked tokens and unavailable data never expose dashboards; transient failures retain retry; logout race protected.');
})().catch(e=>{console.error(e);process.exitCode=1;});
