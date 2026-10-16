-- Elevor360D Marketplace Pro V17: Run AFTER V16 in a NEW Supabase SQL Editor query.
-- Buyer reports are private. Admins manage them via security-definer functions.
create table if not exists public.marketplace_listing_reports (
 id uuid primary key default gen_random_uuid(),
 listing_id uuid not null references public.marketplace_listings(id) on delete cascade,
 reporter_id uuid not null references auth.users(id) on delete cascade,
 reason text not null check (reason in ('Scam','Prohibited item','Misleading','Harassment','Other')),
 details text not null default '' check (char_length(details)<=1000),
 status text not null default 'open' check (status in ('open','reviewing','dismissed','resolved')),
 created_at timestamptz not null default now(),
 unique(listing_id,reporter_id)
);
create index if not exists marketplace_reports_status_idx on public.marketplace_listing_reports(status,created_at desc);
alter table public.marketplace_listing_reports enable row level security;
revoke all on public.marketplace_listing_reports from anon, authenticated;
grant select,insert on public.marketplace_listing_reports to authenticated;
drop policy if exists "Reporters read own reports" on public.marketplace_listing_reports;
create policy "Reporters read own reports" on public.marketplace_listing_reports for select to authenticated using (reporter_id=(select auth.uid()));
drop policy if exists "Buyers report published listings" on public.marketplace_listing_reports;
create policy "Buyers report published listings" on public.marketplace_listing_reports for insert to authenticated with check (
 reporter_id=(select auth.uid()) and status='open' and exists (
 select 1 from public.marketplace_listings l where l.id=listing_id and l.status='published' and l.owner_id<>(select auth.uid())
 ));
-- Keep moderation separate from seller-editable listing fields.
create table if not exists public.marketplace_listing_moderation (
 listing_id uuid primary key references public.marketplace_listings(id) on delete cascade,
 blocked boolean not null default true,
 updated_at timestamptz not null default now()
);
alter table public.marketplace_listing_moderation enable row level security;
revoke all on public.marketplace_listing_moderation from anon,authenticated;
-- Blocked listings cannot be made public or modified by their sellers.
create or replace function public.marketplace_guard_moderation() returns trigger
language plpgsql security definer set search_path='' as $$
begin
 if exists(select 1 from public.marketplace_listing_moderation m where m.listing_id=old.id and m.blocked) then
   if not public.marketplace_is_admin() then
     raise exception 'Listing is blocked by marketplace moderation' using errcode='42501';
   end if;
 end if;
 if TG_OP = 'DELETE' then return OLD; end if;
 return NEW;
end $$;
revoke all on function public.marketplace_guard_moderation() from public,anon,authenticated;
drop trigger if exists marketplace_blocked_listing_guard on public.marketplace_listings;
create trigger marketplace_blocked_listing_guard before update or delete on public.marketplace_listings
 for each row execute function public.marketplace_guard_moderation();
-- Public reads must exclude blocked listings even if status was previously published.
drop policy if exists "Public can read published listings" on public.marketplace_listings;
create policy "Public can read published listings" on public.marketplace_listings
 for select to anon,authenticated using (status='published' and not exists (
  select 1 from public.marketplace_listing_moderation m where m.listing_id=id and m.blocked));
-- Since moderation table is not publicly readable, use a stable definer helper in the policy.
create or replace function public.marketplace_is_blocked(p_id uuid) returns boolean
language sql stable security definer set search_path='' as $$
 select exists(select 1 from public.marketplace_listing_moderation where listing_id=p_id and blocked);
$$;
revoke all on function public.marketplace_is_blocked(uuid) from public;
grant execute on function public.marketplace_is_blocked(uuid) to anon,authenticated;
drop policy if exists "Public can read published listings" on public.marketplace_listings;
create policy "Public can read published listings" on public.marketplace_listings
 for select to anon,authenticated using (status='published' and not public.marketplace_is_blocked(id));
create or replace function public.marketplace_admin_reports() returns jsonb
language plpgsql stable security definer set search_path='' as $$
declare result jsonb;
begin
 if not public.marketplace_is_admin() then raise exception 'Not authorised' using errcode='42501'; end if;
 select coalesce(jsonb_agg(to_jsonb(t)),'[]'::jsonb) into result from (
 select r.id,r.reason,r.details,r.status,r.created_at,l.title as listing_title,l.status as listing_status
 from public.marketplace_listing_reports r left join public.marketplace_listings l on l.id=r.listing_id
 order by r.created_at desc limit 150) t;
 return result;
end $$;
revoke all on function public.marketplace_admin_reports() from public,anon;
grant execute on function public.marketplace_admin_reports() to authenticated;
create or replace function public.marketplace_admin_moderate(p_report_id uuid,p_action text) returns boolean
language plpgsql security definer set search_path='' as $$
declare lid uuid;
begin
 if not public.marketplace_is_admin() then raise exception 'Not authorised' using errcode='42501'; end if;
 if p_action not in ('reviewing','dismissed','resolved','blocked','restore') then raise exception 'Invalid action'; end if;
 select listing_id into lid from public.marketplace_listing_reports where id=p_report_id for update;
 if lid is null then raise exception 'Report not found'; end if;
 if p_action='blocked' then
  insert into public.marketplace_listing_moderation(listing_id,blocked) values(lid,true)
   on conflict(listing_id) do update set blocked=true,updated_at=now();
  update public.marketplace_listings set status='draft' where id=lid and status='published';
  update public.marketplace_listing_reports set status='resolved' where id=p_report_id;
 elsif p_action='restore' then
  update public.marketplace_listing_moderation set blocked=false,updated_at=now() where listing_id=lid;
  update public.marketplace_listing_reports set status='resolved' where id=p_report_id;
 else
  update public.marketplace_listing_reports set status=p_action where id=p_report_id;
 end if;
 return true;
end $$;
revoke all on function public.marketplace_admin_moderate(uuid,text) from public,anon;
grant execute on function public.marketplace_admin_moderate(uuid,text) to authenticated;
-- Harden V16 unpublish to block rather than create seller-republishable drafts.
create or replace function public.marketplace_admin_unpublish(p_listing_id uuid) returns boolean
language plpgsql security definer set search_path='' as $$
begin
 if not public.marketplace_is_admin() then raise exception 'Not authorised' using errcode='42501'; end if;
 insert into public.marketplace_listing_moderation(listing_id,blocked) values(p_listing_id,true)
 on conflict(listing_id) do update set blocked=true,updated_at=now();
 update public.marketplace_listings set status='draft' where id=p_listing_id and status='published';
 return found;
end $$;
revoke all on function public.marketplace_admin_unpublish(uuid) from public,anon;
grant execute on function public.marketplace_admin_unpublish(uuid) to authenticated;
