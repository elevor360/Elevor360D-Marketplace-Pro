-- Run in Supabase SQL Editor. Public SELECT only; no anonymous writes.
create extension if not exists pgcrypto;
create table if not exists public.marketplace_listings (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  title text not null check (char_length(title) between 1 and 90),
  price numeric(12,2) not null check (price >= 0),
  category text not null default 'Other',
  condition text not null default 'Used - Good',
  location text not null default '',
  description text not null default '',
  photos jsonb not null default '[]'::jsonb check (jsonb_typeof(photos) = 'array'),
  status text not null default 'draft' check (status in ('draft','published','sold')),
  created_at timestamptz not null default now()
);
create index if not exists marketplace_listings_published_idx on public.marketplace_listings(created_at desc) where status = 'published';
alter table public.marketplace_listings enable row level security;
-- Restrict API grants; RLS is an additional row-level barrier.
revoke all on public.marketplace_listings from anon, authenticated;
grant select on public.marketplace_listings to anon, authenticated;
drop policy if exists "Public can read published listings" on public.marketplace_listings;
create policy "Public can read published listings" on public.marketplace_listings
  for select to anon, authenticated using (status = 'published');
-- No INSERT/UPDATE/DELETE policy in V11. V12 adds authenticated ownership rules.
-- V11 does not create a public photo bucket; use HTTPS photo URLs only.
