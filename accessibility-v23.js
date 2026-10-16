/* V23: progressive mobile navigation and keyboard improvements. */
(()=>{'use strict';
const menu=document.getElementById('mobileMenuToggle');
const nav=document.getElementById('mainNavigation');

if(!menu||!nav)return;
document.body.classList.add('js-nav');
function setOpen(open){nav.classList.toggle('open',open);menu.setAttribute('aria-expanded',String(open));menu.textContent=open?'✕ Close menu':'☰ Menu';}
menu.addEventListener('click',()=>setOpen(!nav.classList.contains('open')));
nav.addEventListener('click',event=>{const button=event.target.closest('button[data-page]');if(!button)return;setOpen(false);});
document.addEventListener('keydown',event=>{if(event.key==='Escape'&&nav.classList.contains('open')){setOpen(false);menu.focus();}});
const dialog=document.getElementById('itemDialog');
if(dialog){dialog.addEventListener('click',event=>{if(event.target===dialog)dialog.close();});}
})();
