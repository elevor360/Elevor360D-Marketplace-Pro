Elevor360D Marketplace Pro V21 — Notification Centre

1. Export your V20 local listings backup and transaction CSV.
2. Copy your configured marketplace-config.js from V20 into this folder. Never add Supabase secret/service_role keys.
3. Upload all files to the SAME GitHub Pages repository and refresh/reopen the PWA.
4. Open Notifications and select Check Updates. Sign in to see incoming private messages.
5. Mark Messages as Read stores read state per account on this device.

No new Supabase SQL is required. Private messages are fetched through the existing RLS policies. Notifications require opening the app; no push notifications are sent when closed. Recent listings are public activity, not personalised alerts.
