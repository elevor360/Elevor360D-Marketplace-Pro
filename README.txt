Elevor360D Marketplace Pro V11 — GitHub Pages + Supabase (public read-only cloud browse)

1. Back up your V10 data before replacing files.
2. Upload index.html, app.js, sw.js, manifest.webmanifest, icon-192.png, icon-512.png to your existing GitHub Pages site.
3. Create a Supabase project; open SQL Editor and run SUPABASE_SETUP.sql.
4. In Supabase Project Settings > API (or Connect > API keys), copy the Project URL and publishable key (or legacy anon key). NEVER use a secret or service_role key.
5. Open app > Cloud Listings; paste URL and public key; Save Connection; Refresh Listings.
6. With no published listings, the cloud tab correctly shows 0. New seller registration/upload comes in V12.
7. Local V10 listings remain on the device and are NOT uploaded or shared. Do not delete them.
8. GitHub Pages must be HTTPS. Supabase REST requests require internet; local PWA continues to work offline.
9. Public listings should not contain private seller contact data. Cloud listing fields deliberately exclude email and phone.
10. Do not enable anonymous INSERT/UPDATE/DELETE policies. V12 will add auth.uid() ownership policies.

The app caches its shell; if the old version appears, reload the page or close/reopen the installed app.
