# Elevor360D Marketplace Pro — installation and upgrades

## Existing V24 site
1. Export a listing backup from **My Listings** and separately export transaction/fee CSV records.
2. Extract V25 and copy your **existing configured** `marketplace-config.js` from V24 over the placeholder. The config must contain only the **public** Supabase URL and publishable/anon key.
3. Upload all V25 files into the existing GitHub Pages repository `Elevor360D-Marketplace-Pro` (same directory as the current `index.html`). Commit and wait for Pages to deploy.
4. Visit https://elevor360.github.io/Elevor360D-Marketplace-Pro/ . Refresh the browser and reopen the installed app on each device. The header should say V25.
5. In **Menu → App Health & Updates**, run the health check and check updates. Test account sign-in, cloud listings, messages and seller/admin permissions.

## Fresh setup
- Publish the files on an HTTPS host with service worker support (GitHub Pages is suitable).
- Create a Supabase project and review the included SQL setup scripts in version order. These scripts may assume preceding schema; review carefully before running.
- Configure Supabase authentication site URL and allowed redirect URLs to match your actual deployed HTTPS address.
- Place only public Supabase credentials in `marketplace-config.js`. Never expose service-role/secret keys. Verify database Row Level Security for each table and operation before public use.
- Set up an administrator using the instructions in `README_V16.txt`; do not expose admin credentials.
- Install via the browser's **Install App** option when available, or **Add to Home Screen** on supported devices.

## Offline and updates
The PWA caches its application shell. Internet access is required for Supabase accounts, cloud listings, messages and moderation. Local-only records may work offline. After updates, old app windows may continue using cached files until refreshed/reopened. Do **not** clear site data or uninstall without exporting all local records.

## Important limitations
This is not a hosted payment processor or escrow service. Buyer/seller payment arrangements are made outside the app. There is no automatic fee collection. Live production testing, privacy/legal compliance, and a security review remain the owner's responsibility.
