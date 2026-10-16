// V20: Private transaction records. No checkout, payment verification, or shared orders.
'use strict';
(()=>{
 const KEY='elevor360d-transaction-records-v20';
 const $=id=>document.getElementById(id);
 const el=(tag,value)=>{const n=document.createElement(tag);if(value!==undefined)n.textContent=value;return n};
 let records=[];
 try{const a=JSON.parse(localStorage.getItem(KEY)||'[]');if(Array.isArray(a))records=a.filter(x=>x&&typeof x.id==='string').slice(0,500)}catch{}
 const save=()=>{try{localStorage.setItem(KEY,JSON.stringify(records));return true}catch{alert('Storage full. Export your CSV before adding more records.');return false}};
 const money=n=>Number(n||0).toFixed(2);
 const statuses=['Enquiry','Agreed','Awaiting collection/delivery','Completed (manually recorded)','Cancelled'];
 function render(){const root=$('transactionList');if(!root)return;root.replaceChildren();const count=$('transactionCount');count.textContent=records.length+' records · '+records.filter(x=>x.status===statuses[3]).length+' marked completed (not verified)';
 if(!records.length)root.append(el('p','No transaction records yet. Open a cloud or local product and select Record Arrangement.'));
 for(const x of records){const card=el('article');card.className='enquiry-entry';card.append(el('h3',x.title),el('p','Reference: '+x.ref+' · Created: '+new Date(x.created).toLocaleDateString()));
 const amount=el('input');amount.type='number';amount.min='0';amount.step='0.01';amount.max='100000000';amount.value=x.amount;
 const status=el('select');for(const s of statuses){const o=el('option',s);o.value=s;status.append(o)}status.value=x.status;
 const method=el('select');for(const s of ['Not agreed','Cash on collection','Bank transfer arranged privately','Other method agreed privately']){const o=el('option',s);o.value=s;method.append(o)}method.value=x.method;
 const notes=el('textarea');notes.maxLength=1000;notes.value=x.notes||'';notes.placeholder='Collection/delivery notes. Avoid sensitive personal or financial information.';
 for(const [label,node] of [['Agreed price (£)',amount],['Arrangement status',status],['Payment method (self-reported)',method],['Private notes',notes]]){card.append(el('label',label),node)}
 const controls=el('div');controls.className='toolbar';const update=el('button','Save Changes');update.onclick=()=>{const value=Number(amount.value);if(!Number.isFinite(value)||value<0||value>100000000){alert('Enter a valid amount.');return}Object.assign(x,{amount:value,status:status.value,method:method.value,notes:notes.value,updated:new Date().toISOString()});if(save()){render();alert('Record saved on this device. No payment or order was sent.')}};
 const del=el('button','Delete Record');del.className='secondary';del.onclick=()=>{if(confirm('Delete this private record?')){records=records.filter(r=>r.id!==x.id);save();render()}};controls.append(update,del);card.append(controls);root.append(card)} }
 function add(item){if(item.status==='sold'){alert('This item is already marked sold.');return}const id=crypto.randomUUID?crypto.randomUUID():String(Date.now())+'-'+Math.random();const x={id,ref:'TX-'+Date.now().toString(36).toUpperCase(),listingId:item.id,title:item.name,amount:Number(item.price||0),status:'Enquiry',method:'Not agreed',notes:'',created:new Date().toISOString()};records.unshift(x);records=records.slice(0,500);if(!save())return;render();$('itemDialog').close();show('transactions')}
 const prior=openDetail;openDetail=function(id){prior(id);const item=[...listings,...cloudListings].find(x=>x.id===id);if(!item)return;const actions=$('detailBody').querySelector('.detail-actions');if(!actions)return;const btn=el('button','Record Arrangement');btn.type='button';btn.onclick=()=>add(item);actions.append(btn)};
 $('exportTransactions').onclick=()=>{const rows=[['Reference','Product','Listing ID','Agreed Price GBP','Status','Method','Created','Updated','Notes'],...records.map(x=>[x.ref,x.title,x.listingId,x.amount,x.status,x.method,x.created,x.updated||'',x.notes])];const csv=rows.map(r=>r.map(v=>'"'+String(v??'').replace(/"/g,'""')+'"').join(',')).join('\r\n');const blob=new Blob(['\ufeff'+csv],{type:'text/csv;charset=utf-8'});const url=URL.createObjectURL(blob);const a=el('a');a.href=url;a.download='marketplace-transaction-records-v20.csv';a.click();setTimeout(()=>URL.revokeObjectURL(url),1000)};
 $('clearTransactions').onclick=()=>{if(confirm('Delete ALL transaction records from this device? Export CSV first.')){records=[];save();render()}};
 render();
})();
