Elevor360D Marketplace Pro V16 — Administrator Dashboard

1. Export a local backup in V15.
2. In Supabase SQL Editor, create a NEW query and run SUPABASE_V16_SETUP.sql.
3. Supabase Dashboard > Authentication > Users: copy YOUR OWN account UUID.
4. In a NEW SQL query, run:
   insert into public.marketplace_admins(user_id) values ('YOUR-ACCOUNT-UUID') on conflict do nothing;
   Replace YOUR-ACCOUNT-UUID with your real UUID. Do not add customers.
5. Copy your configured marketplace-config.js from V15 into this V16 folder, replacing the placeholder. Only public key allowed.
6. Upload index.html, app.js, sw.js, manifest.webmanifest, marketplace-config.js and both icons to GitHub Pages.
7. Refresh/relaunch the installed app; sign in as your administrator account. Admin Panel appears.
8. Test statistics and unpublishing a test listing. Verify a normal customer account cannot see the Admin Panel or call admin RPCs.

Caution: Admin unpublish changes the listing to draft, and its owner can republish it. Stronger moderation and reports arrive in V17. No admin access to private messages or user passwords.
