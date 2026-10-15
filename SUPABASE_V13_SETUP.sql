-- Elevor360D Marketplace Pro V13. Run after V11 and V12 SQL scripts.
-- Owner-specific access for authenticated sellers, public access only to published listings.
alter table public.marketplace_listings enable row level security;
revoke all on public.marketplace_listings from anon, authenticated;
grant select on public.marketplace_listings to anon;
grant select, insert, update, delete on public.marketplace_listings to authenticated;
drop policy if exists "Public can read published listings" on public.marketplace_listings;
create policy "Public can read published listings" on public.marketplace_listings for select to anon, authenticated using (status = 'published');
drop policy if exists "Owners can view own listings" on public.marketplace_listings;
create policy "Owners can view own listings" on public.marketplace_listings for select to authenticated using (owner_id = (select auth.uid()));
drop policy if exists "Owners can create listings" on public.marketplace_listings;
create policy "Owners can create listings" on public.marketplace_listings for insert to authenticated with check (owner_id = (select auth.uid()));
drop policy if exists "Owners can edit listings" on public.marketplace_listings;
create policy "Owners can edit listings" on public.marketplace_listings for update to authenticated using (owner_id = (select auth.uid())) with check (owner_id = (select auth.uid()));
drop policy if exists "Owners can delete listings" on public.marketplace_listings;
create policy "Owners can delete listings" on public.marketplace_listings for delete to authenticated using (owner_id = (select auth.uid()));
-- No anonymous write privileges. Never put service-role keys in client-side code.
