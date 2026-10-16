ELEVOR360D MARKETPLACE PRO V24 — RELIABILITY UPDATE

WHAT IS NEW
- App Health & Updates screen: connection, HTTPS, local storage, service worker, approximate storage.
- Manual update check that does not delete local data.
- Updated version labels and service worker cache name for V24.

UPGRADE
1. Export a listing backup and separate transaction/fee CSV files.
2. Copy your WORKING marketplace-config.js from V23.2 into this folder. Never publish Supabase secret/service-role keys.
3. Upload all files (including sw.js and reliability-v24.js) to your existing GitHub Pages repository.
4. Wait for deployment, open the website, reload, close and reopen the installed PWA.
5. Open Menu > App Health & Updates > Run Health Check.
6. Test browsing, cloud listings, messages, seller admin controls, and manual update check on computer and tablet.

No new Supabase SQL. No automatic data deletion or cache clearing.
This release has static syntax/ZIP checks; browser and live Supabase behaviour require your testing.
