Elevor360D Marketplace Pro V17 — Reporting and moderation

1. Back up V16 local data.
2. Supabase SQL Editor > New Query: run SUPABASE_V17_SETUP.sql in your existing project.
3. Copy your configured marketplace-config.js from V16 into this folder. Never add secret/service_role keys.
4. Upload all app files to your existing GitHub Pages repository.
5. Refresh the site, test reports with a buyer account and moderation with your admin account.
6. Test that a blocked seller cannot republish their listing.

Notes: reports require login; duplicate reports from the same account on one listing are prevented. Blocking hides a listing and prevents edits until restored. This release does not scan content automatically.
