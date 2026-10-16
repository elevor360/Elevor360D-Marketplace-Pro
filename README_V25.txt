ELEVOR360D MARKETPLACE PRO — VERSION 25 (FINAL PLANNED RELEASE)

This package contains the complete V24 app with final-release labels, documentation, and a fresh offline cache version. It does not introduce new database tables or payment processing.

UPGRADE FROM YOUR WORKING V24
1. Back up local listings in the app. Export transaction and fee CSV records separately.
2. Unzip this package. Copy your WORKING marketplace-config.js from V24 into this folder, replacing the placeholder file.
3. Upload ALL files from this folder to the root of your existing GitHub repository, including sw.js, index.html, manifest.webmanifest and all .js files.
4. Wait for GitHub Pages deployment. Open https://elevor360.github.io/Elevor360D-Marketplace-Pro/ and refresh; close and reopen installed PWAs.
5. Verify V25 is displayed on BOTH computer and tablet. Do not clear browser storage or uninstall until backups are safe.
6. Open Menu > App Health & Updates and test all important features.

No new Supabase SQL is required when upgrading from working V24. Do not run old setup SQL again without reviewing it.
Never place a Supabase secret/service_role key in marketplace-config.js. Only use public URL and publishable/anon key with verified Row Level Security.

Read INSTALLATION_GUIDE_V25.md, CUSTOMER_GUIDE_V25.md, ADMIN_GUIDE_V25.md and FINAL_TEST_CHECKLIST_V25.md.

LIMITATIONS
- Buyer and seller arrange payment directly; the site never collects or verifies payment.
- Local device records are not automatically synced and may not be included in listing backups.
- Notifications are in-app only, not background push alerts.
- Before public launch, establish a privacy notice, operator contact, data deletion process and legal terms.
- Static syntax/ZIP checks do not replace live Supabase, security or multi-device testing.
