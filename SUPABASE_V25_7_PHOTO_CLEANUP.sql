-- Version 25.7: permit authenticated sellers to delete ONLY their own uploaded photos.
-- Run in Supabase SQL Editor. No service-role key is needed in the browser.
DROP POLICY IF EXISTS "Marketplace sellers delete own photos" ON storage.objects;
CREATE POLICY "Marketplace sellers delete own photos" ON storage.objects
FOR DELETE TO authenticated
USING (
  bucket_id = 'marketplace-photos'
  AND (storage.foldername(name))[1] = (SELECT auth.uid())::text
);
-- IMPORTANT: this is client-initiated cleanup after a confirmed listing deletion.
-- If a device goes offline between the two requests, an orphaned photo may remain.
-- Existing orphaned photos are not deleted by this upgrade.
