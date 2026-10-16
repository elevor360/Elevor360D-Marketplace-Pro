Elevor360D Marketplace Pro — Version 19 of 25

1. Back up Version 18 listings and retain your existing configured marketplace-config.js.
2. Run SUPABASE_V19_SETUP.sql in a NEW query in the same Supabase project.
3. Copy your working marketplace-config.js into this V19 folder, replacing the placeholder.
4. Upload the V19 files to your existing GitHub Pages repository. Refresh/reopen the PWA.
5. Sign in as the existing administrator. Open Seller Management. Test seller counts.
6. Test saving proposed fee amounts and manual bookkeeping records; export CSV.

No real fees are collected or enforced. Seller overview is administrator-only and read-only. Manual fee records and proposed fee settings live only in the administrator browser, not in Supabase, and are not included in listing backups. Do not store private financial account information in notes.

Keep marketplace-config.js publishable/anon key only. NEVER use a service-role key in the public app.
