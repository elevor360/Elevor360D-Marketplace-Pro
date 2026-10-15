Elevor360D Marketplace Pro V12

1. Export a backup from V11.
2. Run SUPABASE_V12_SETUP.sql in your existing Supabase SQL Editor (after V11 setup).
3. In Supabase Authentication > Providers > Email, enable email authentication and preferably email confirmation.
4. In Authentication > URL Configuration, set your exact GitHub Pages site URL and permitted redirect URLs.
5. Upload the app files to the same GitHub Pages repo. Do not upload SQL files to a public repository if you do not want to publish your schema (the SQL contains no secrets).
6. Refresh the app, check Cloud Listings connection, then open My Account to sign up, verify email, sign in and save display name.
7. Test sign out and sign in. Your local listings are unchanged.

Security: browser uses only publishable/anon key. Auth token stored in sessionStorage; no password saved. Profiles are private via RLS. Cloud listing writes remain disabled until V13.
