Elevor360D Marketplace Pro V25.6 — Cloud listing deletion fix

1. Back up any local data and export separate CSVs.
2. Supabase Dashboard > SQL Editor: run SUPABASE_V25_6_DELETE_FIX.sql once.
3. Copy your existing working marketplace-config.js into this folder.
4. Upload all files to GitHub Pages, including app.js and sw.js.
5. Refresh the browser and installed app.
6. Sign in as the listing owner. Cloud Listings > My Cloud Listings > Refresh > Delete Cloud Listing.
7. Confirm the listing disappears after refresh and is absent from public Online Marketplace.

This corrects a BEFORE DELETE database trigger that previously returned NULL and silently cancelled deletions. The app now verifies a deleted record was returned before reporting success. Blocked listings still require administrator moderation.

Photos of deleted listings are not automatically removed from Supabase Storage.
