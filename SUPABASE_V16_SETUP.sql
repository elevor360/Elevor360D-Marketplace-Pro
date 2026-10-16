-- Elevor360D Marketplace Pro V16 — run in the existing Supabase SQL Editor.
-- Run AFTER V11–V15 scripts. Keep this SQL private to the project owner.
create table if not exists public.marketplace_admins (user_id uuid primary key references auth.users(id) on delete cascade, created_at timestamptz not null default now());
alter table public.marketplace_admins enable row level security;
revoke all on public.marketplace_admins from anon, authenticated;
-- IMPORTANT: Set your own authenticated Supabase User ID here, AFTER running this script:
-- insert into public.marketplace_admins(user_id) values ('YOUR-AUTH-USER-UUID') on conflict do nothing;
-- Find the UUID under Authentication > Users. Never use an email address here.
create or replace function public.marketplace_is_admin() returns boolean language sql stable security definer set search_path = '' as $$
 select exists (select 1 from public.marketplace_admins where user_id = (select auth.uid()));
$$;
revoke all on function public.marketplace_is_admin() from public, anon;
grant execute on function public.marketplace_is_admin() to authenticated;
create or replace function public.marketplace_admin_dashboard() returns jsonb language plpgsql stable security definer set search_path = '' as $$
declare result jsonb;
begin
 if not public.marketplace_is_admin() then raise exception 'Not authorised' using errcode = '42501'; end if;
 select jsonb_build_object(
 'stats',jsonb_build_object(
 'profiles',(select count(*) from public.marketplace_profiles),
 'published',(select count(*) from public.marketplace_listings where status='published'),
 'drafts',(select count(*) from public.marketplace_listings where status='draft'),
 'sold',(select count(*) from public.marketplace_listings where status='sold'),
 'reviews',(select count(*) from public.marketplace_seller_reviews)),
 'listings',coalesce((select jsonb_agg(to_jsonb(t)) from (select id,title,price,status,created_at from public.marketplace_listings order by created_at desc limit 100) t),'[]'::jsonb)) into result;
 return result;
end $$;
revoke all on function public.marketplace_admin_dashboard() from public, anon;
grant execute on function public.marketplace_admin_dashboard() to authenticated;
create or replace function public.marketplace_admin_unpublish(p_listing_id uuid) returns boolean language plpgsql security definer set search_path = '' as $$
begin
 if not public.marketplace_is_admin() then raise exception 'Not authorised' using errcode = '42501'; end if;
 update public.marketplace_listings set status='draft' where id=p_listing_id and status='published';
 return found;
end $$;
revoke all on function public.marketplace_admin_unpublish(uuid) from public, anon;
grant execute on function public.marketplace_admin_unpublish(uuid) to authenticated;
