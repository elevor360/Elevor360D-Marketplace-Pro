// V21 Notification Centre: no new database tables or secret keys.
// Private messages are read through the existing authenticated Supabase RLS endpoint.
(()=>{'use strict';
const byId=id=>document.getElementById(id);
const status=t=>{byId('notificationsStatus').textContent=t};
const node=(tag,text,cls)=>{const n=document.createElement(tag);if(text!==undefined)n.textContent=text;if(cls)n.className=cls;return n};
let busy=false;
const keyFor=id=>'elevor360d-v21-read-messages-'+id;
const getRead=id=>{try{const a=JSON.parse(localStorage.getItem(keyFor(id))||'[]');return new Set(Array.isArray(a)?a.filter(x=>typeof x==='string').slice(-2000):[])}catch{return new Set()}};
let currentMessages=[],currentUserId=null;
async function update(){if(busy)return;busy=true;byId('checkNotifications').disabled=true;
const msg=byId('notificationMessages'),listing=byId('notificationListings');msg.replaceChildren();listing.replaceChildren();status('Checking marketplace activity…');
try{
  if(!cloudConfig.url||!cloudConfig.key)throw Error('The marketplace connection is not configured.');
  let newCount=0;currentMessages=[];currentUserId=null;
  try{
    const auth=await ensureAuth();currentUserId=auth.user.id;
    const rows=await cloudRequest('GET','marketplace_messages?select=id,listing_id,sender_id,recipient_id,body,created_at&recipient_id=eq.'+encodeURIComponent(currentUserId)+'&order=created_at.desc&limit=100');
    const read=getRead(currentUserId);currentMessages=Array.isArray(rows)?rows:[];
    for(const m of currentMessages){if(!read.has(m.id))newCount++;const card=node('div',undefined,'enquiry-entry');card.append(node('strong',read.has(m.id)?'Message':'New message'),node('p',new Date(m.created_at).toLocaleString('en-GB'),'muted'),node('p',String(m.body||'').slice(0,300)));
      const btn=node('button','Open Messages');btn.type='button';btn.addEventListener('click',()=>document.querySelector('button[data-page="messages"]').click());card.append(btn);msg.append(card)}
    if(!currentMessages.length)msg.append(node('p','No incoming messages yet.','muted'));
  }catch(err){msg.append(node('p','Sign in to see private messages: '+err.message,'muted'))}
  byId('notificationCount').textContent=newCount?'('+newCount+')':'';
  const recent=await cloudRequest('GET','marketplace_listings?select=id,title,price,created_at&status=eq.published&order=created_at.desc&limit=10');
  if(!Array.isArray(recent)||!recent.length)listing.append(node('p','No published listings found.','muted'));
  else for(const item of recent){const card=node('div',undefined,'enquiry-entry');card.append(node('strong',String(item.title||'Item')),node('p','£'+Number(item.price||0).toFixed(2)+' · '+new Date(item.created_at).toLocaleDateString('en-GB'),'muted'));const btn=node('button','Browse Cloud Listings');btn.type='button';btn.addEventListener('click',()=>document.querySelector('button[data-page="cloud"]').click());card.append(btn);listing.append(card)}
  status('Updated. '+newCount+' unread message(s) on this device.');
}catch(err){status('Unable to check activity: '+err.message)}finally{busy=false;byId('checkNotifications').disabled=false}}
byId('checkNotifications').addEventListener('click',update);
byId('markNotificationsRead').addEventListener('click',()=>{if(!currentUserId){status('Sign in and check updates first.');return}const read=getRead(currentUserId);for(const m of currentMessages)read.add(m.id);try{localStorage.setItem(keyFor(currentUserId),JSON.stringify([...read].slice(-2000)))}catch(e){status('Unable to save read status: '+e.message);return}byId('notificationCount').textContent='';status('Incoming messages marked read on this device.');update()});
document.querySelector('button[data-page="notifications"]').addEventListener('click',update);
})();
