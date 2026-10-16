Elevor360D Marketplace Pro V14 — Private Messaging

1. Back up local data from V13.1.
2. Supabase Dashboard > SQL Editor > New Query: run SUPABASE_V14_SETUP.sql.
3. KEEP your configured marketplace-config.js from V13.1! Replace the placeholder file in this ZIP with your working configured file BEFORE uploading. Do not use secret/service-role keys.
4. Upload all app files to your existing GitHub Pages repository.
5. Refresh both devices (close/reopen installed PWA if necessary).
6. Buyer signs in, opens Cloud Listings > published item > View Details > Message Seller in App; writes message and sends.
7. Seller signs in on another device > Messages > Refresh Messages > reply.
8. Only signed-in conversation participants can read messages. No realtime push notifications; select Refresh Messages to fetch new messages. Messages require an internet connection.

Notes: V14 does not migrate local enquiries to online messaging. Seller cannot initiate conversations with buyers. SQL assumes V13 marketplace_listings.id and owner_id are UUID and status values published/draft/sold.
