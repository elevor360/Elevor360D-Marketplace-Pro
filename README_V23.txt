Elevor360D Marketplace Pro — Version 23 of 25

WHAT IS NEW
- Compact, collapsible two-column navigation on phones (no change to desktop navigation).
- Improved touch target sizes, visible keyboard focus and skip-to-content link.
- Responsive cards, dialogs and controls for narrow screens.
- Escape key closes mobile menu; menu reports expanded state to assistive technology.
- Reduced-motion and forced-colour accessibility support.
- Existing marketplace functionality retained.

INSTALL / UPGRADE
1. Export V22 listing backup and any separate CSV records first.
2. Extract this ZIP. Copy your configured marketplace-config.js from V22 if needed.
3. Upload all files to your existing GitHub Pages repository.
4. Refresh the site; if an installed PWA appears stale, close and reopen it.
5. No new Supabase SQL is needed.

TEST
- Phone: Menu opens and closes; choose each major section.
- Desktop: All navigation buttons remain visible.
- Keyboard: Tab to Skip to main content; focus indicator visible; Escape closes menu.
- Check cloud listings, account, messaging, seller/admin functions.

LIMITATIONS
These improvements are not a formal WCAG audit; test with assistive technologies before public release.
