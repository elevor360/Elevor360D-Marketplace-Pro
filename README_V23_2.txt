Elevor360D Marketplace Pro V23.2 — Tablet and navigation fix

1. Back up existing app data and CSV records.
2. Copy your working marketplace-config.js into this folder.
3. Upload ALL files to your GitHub Pages repository, including sw.js, index.html and accessibility-v23.js.
4. Wait for GitHub Pages deployment, then open the site and refresh.
5. On tablet: close the installed app completely and reopen it. If the old screen persists, open the website in the tablet browser and refresh twice, then relaunch the installed app. Avoid clearing site storage, which may delete locally saved records.

The Browse label next to Menu has been removed. Use Menu > Browse to switch pages. The navigation starts collapsed on every screen size.
The service worker now tries the network first, falling back to cache when offline. No new Supabase SQL required.
