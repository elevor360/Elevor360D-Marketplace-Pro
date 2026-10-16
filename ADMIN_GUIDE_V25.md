# Administrator guide — Marketplace Pro V25

**Admin access:** Use a Supabase account authorised in the `marketplace_admins` table according to the V16 setup guide. Do not rely on hiding buttons alone; enforce permissions with Supabase Row Level Security.

**Moderation:** Review **Admin Panel** and reports, investigate complaints, and block or unblock listings using the controls provided. Test with a non-admin account to verify permissions.

**Sellers:** **Seller Management** shows seller/listing overview and manual proposed fee records. Fee settings and records are local bookkeeping, not enforced billing or automatic payments. Export fee CSV regularly.

**Payment policy:** Transactions are direct seller–buyer arrangements. The marketplace does not hold funds, charge commissions automatically, guarantee transactions or verify payment.

**Operations:** Maintain a published privacy notice, terms, contact channel, account/data deletion procedure, moderation policy and incident response process before inviting the public. Check your jurisdiction's obligations.

**Security:** Never commit service-role/secret keys, admin passwords or private API credentials. Review all Supabase policies, authentication redirects and SQL permissions before production use. Keep separate backups of Supabase data and local exports.

**Releases:** Upload the entire release including `sw.js`, preserve the configured public `marketplace-config.js`, and verify the displayed version on each device. Do not clear site data without backups.
