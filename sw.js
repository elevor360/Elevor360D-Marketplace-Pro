// V23.2: network-first updates; offline cache fallback.
const CACHE='elevor360d-marketplace-v23-2-cache-1';
const ASSETS=['./','./index.html','./app.js','./marketplace-config.js','./manifest.webmanifest','./icon-192.png','./icon-512.png','./payments-v18.js','./seller-management-v19.js','./transactions-v20.js','./notifications-v21.js','./privacy-v22.js','./accessibility-v23.js'];
self.addEventListener('install',event=>{event.waitUntil(caches.open(CACHE).then(cache=>cache.addAll(ASSETS)).then(()=>self.skipWaiting()))});
self.addEventListener('activate',event=>{event.waitUntil(caches.keys().then(keys=>Promise.all(keys.filter(key=>key.startsWith('elevor360d-marketplace-')&&key!==CACHE).map(key=>caches.delete(key)))).then(()=>self.clients.claim()))});
self.addEventListener('fetch',event=>{const request=event.request;if(request.method!=='GET'||new URL(request.url).origin!==self.location.origin)return;event.respondWith(fetch(request).then(response=>{if(response.ok){const copy=response.clone();event.waitUntil(caches.open(CACHE).then(cache=>cache.put(request,copy)));}return response;}).catch(()=>caches.match(request).then(hit=>hit||Response.error())))});
