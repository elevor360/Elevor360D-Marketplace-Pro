# V25 release acceptance checklist

Test on desktop and tablet, using two separate non-admin accounts and one admin account.

- [ ] Both devices show **V25** and the compact **Menu** opens/closes correctly.
- [ ] Browse, search, filter and product detail screens work.
- [ ] Supabase sign-up/sign-in/sign-out and email confirmation work.
- [ ] A seller can publish, edit and manage their own online listing.
- [ ] Another seller cannot edit or delete that listing (RLS enforced).
- [ ] Buyer and seller can exchange messages; other accounts cannot read them.
- [ ] Seller profile/review features work and permissions are correct.
- [ ] Reports reach administrator; moderation block/unblock works.
- [ ] Non-admin accounts cannot access administrator operations.
- [ ] Direct payment arrangements and transaction notes work without collecting payments.
- [ ] Fee planning records remain manual; CSV export works.
- [ ] Notification centre works while app is open; no push alerts are promised.
- [ ] Local listing backup/restore works on test data.
- [ ] Transaction and fee CSV files export independently.
- [ ] App Health check runs and service worker reports correctly.
- [ ] Website refreshes to the newest version on desktop and tablet.
- [ ] Offline app shell opens; cloud features correctly require internet.
- [ ] Public privacy notice, contact information and online data deletion process are in place.
- [ ] Supabase RLS/security and authentication redirects have been independently reviewed.

Do not test destructive deletion on valuable data; use disposable records and backups.
