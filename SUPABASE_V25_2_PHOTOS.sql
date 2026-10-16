-- Run once in Supabase SQL Editor as project owner.
-- Product images are PUBLIC; never upload private images.
insert into storage.buckets (id,name,public,file_size_limit,allowed_mime_types)
values ('marketplace-photos','marketplace-photos',true,5242880,array['image/jpeg','image/png','image/webp','image/gif'])
on conflict (id) do update set public=true,file_size_limit=5242880,allowed_mime_types=array['image/jpeg','image/png','image/webp','image/gif'];

drop policy if exists "Marketplace sellers upload own photos" on storage.objects;
create policy "Marketplace sellers upload own photos" on storage.objects for insert to authenticated
with check (bucket_id='marketplace-photos' and (storage.foldername(name))[1]=(select auth.uid())::text);
-- Public read is provided by the bucket public setting.
-- Storage deletion is deliberately not enabled: contact an administrator for photo removal.
