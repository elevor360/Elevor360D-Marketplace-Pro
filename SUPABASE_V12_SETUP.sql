-- V12: Run AFTER V11 SQL in Supabase SQL Editor.
-- Enable email confirmation in Authentication > Providers > Email.
-- Configure Site URL and allowed redirect URLs for your GitHub Pages site.
create table if not exists public.marketplace_profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null check (char_length(display_name) between 2 and 60),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table public.marketplace_profiles enable row level security;
revoke all on public.marketplace_profiles from anon, authenticated;
grant select, insert, update on public.marketplace_profiles to authenticated;
drop policy if exists "Users read own profile" on public.marketplace_profiles;
drop policy if exists "Users create own profile" on public.marketplace_profiles;
drop policy if exists "Users update own profile" on public.marketplace_profiles;
create policy "Users read own profile" on public.marketplace_profiles for select to authenticated using ((select auth.uid()) = id);
create policy "Users create own profile" on public.marketplace_profiles for insert to authenticated with check ((select auth.uid()) = id);
create policy "Users update own profile" on public.marketplace_profiles for update to authenticated using ((select auth.uid()) = id) with check ((select auth.uid()) = id);
-- Listing table remains read-only to clients. Seller writes will be added in V13.
-- NEVER place Supabase secret/service-role keys in GitHub Pages or browser code.
