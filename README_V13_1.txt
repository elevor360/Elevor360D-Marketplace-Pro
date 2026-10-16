Elevor360D Marketplace Pro — Version 13.1 (fix, not a new numbered milestone)

WHAT CHANGED
Visitors can view published products without entering Supabase details. Seller authentication and existing cloud listings are retained.

OWNER SETUP (REQUIRED ONCE)
1. Open marketplace-config.js with Notepad (do not edit the other JavaScript files).
2. Replace PASTE_YOUR_SUPABASE_PROJECT_URL_HERE with your actual Supabase Project URL (https://xxxx.supabase.co).
3. Replace PASTE_YOUR_SUPABASE_PUBLISHABLE_KEY_HERE with your public publishable key (sb_publishable_...) or legacy anon key.
4. Keep the quotation marks. Do NOT use a service_role key or sb_secret_ key.
5. Save the file, then upload ALL files to your existing GitHub Pages repository, including marketplace-config.js.
6. Refresh GitHub Pages and test Cloud Listings on another device in a private browser without signing in.

No new SQL is required if V13 database setup already succeeded.
Your public URL: https://elevor360.github.io/Elevor360D-Marketplace-Pro/

IMPORTANT
Public keys are designed to be visible in website code. Security relies on Supabase RLS rules from V13, not secrecy of this key. Never publish a secret/service_role key.
Backup your local listings before updating. Cloud products stay in your Supabase project.
If your previous browser already had saved connection settings, it may still connect before the new config is completed, but NEW visitors will not. Finish the config file before sharing.
