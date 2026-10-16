Elevor360D Marketplace Pro V25.7 — cloud photo cleanup

1. Back up local data and CSV exports.
2. Run SUPABASE_V25_7_PHOTO_CLEANUP.sql in your Supabase SQL Editor.
3. Copy your existing configured marketplace-config.js into this folder.
4. Upload all files to GitHub Pages, including app.js and sw.js.
5. Refresh the browser and installed PWA on each device.
6. Sign in as the owner of a TEST listing with a new uploaded photo.
7. Delete via Cloud Listings > My Cloud Listings > Delete Cloud Listing.
8. Confirm both the listing and image are gone in Supabase.

Security: only photos stored under the authenticated user's UUID path are eligible. External image links are never deleted.
This is best-effort client-side cleanup: the listing is deleted first and photo removal follows. If the network fails, the app warns you; manual cleanup may be necessary. It does not clean old orphaned photos.
