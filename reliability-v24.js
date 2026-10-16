/* V24: non-destructive diagnostics and update checks. */
(()=>{'use strict';
const $=id=>document.getElementById(id);
const report=$('healthResults'),status=$('healthUpdateStatus');
function line(label,value){const p=document.createElement('p');const b=document.createElement('strong');b.textContent=label+': ';p.append(b,document.createTextNode(value));return p;}
async function health(){report.replaceChildren();report.append(line('App version','24'),line('Connection',navigator.onLine?'Online (browser indication)':'Offline'),line('Secure page',location.protocol==='https:'?'Yes':'No'),line('Local storage',(()=>{try{const k='__elevor360d_health__';localStorage.setItem(k,'ok');localStorage.removeItem(k);return 'Available';}catch(e){return 'Unavailable: '+e.name;}})()));
if('serviceWorker' in navigator){const r=await navigator.serviceWorker.getRegistration().catch(()=>null);report.append(line('Offline service worker',r?.active?'Active':r?.installing?'Installing':r?.waiting?'Waiting to activate':'Not active'));}else report.append(line('Offline service worker','Unsupported'));
if(navigator.storage?.estimate){try{const q=await navigator.storage.estimate();report.append(line('Approximate device storage used',Math.round((q.usage||0)/1024/1024)+' MB'));}catch(e){}}
report.append(line('Supabase settings',(()=>{const c=window.MARKETPLACE_CONFIG||window.marketplaceConfig;return c?'Configuration object detected (does not test database permissions)':'Check Cloud Listings for connection status';})()));}
$('healthCheck').addEventListener('click',()=>{health().catch(e=>status.textContent='Health check failed: '+e.message)});
$('checkAppUpdate').addEventListener('click',async()=>{status.textContent='Checking for an update…';if(!navigator.onLine){status.textContent='Offline: reconnect before checking.';return;}try{if(!('serviceWorker' in navigator))throw Error('Service workers are not supported in this browser.');const r=await navigator.serviceWorker.getRegistration();if(!r)throw Error('No installed service worker was found. Open the site using HTTPS.');await r.update();if(r.waiting){status.textContent='An update is ready. Close and reopen the app to activate it.';}else{status.textContent='Update check finished. If a newer version was uploaded, close and reopen the app. This does not guarantee that a new release exists.';}await health();}catch(e){status.textContent='Could not check updates: '+e.message;}});
document.querySelector('[data-page="reliability"]')?.addEventListener('click',()=>health().catch(()=>{}));
window.addEventListener('online',()=>{if(!$('reliability').hidden)health().catch(()=>{});});window.addEventListener('offline',()=>{if(!$('reliability').hidden)health().catch(()=>{});});
})();
