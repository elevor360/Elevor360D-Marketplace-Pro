-- V15: Run in a NEW SQL Editor query after V14. No existing tables are deleted.
-- Only public display names and aggregate counts are exposed; account emails stay private.
create table if not exists public.marketplace_seller_reviews (
 id uuid primary key default gen_random_uuid(),
 seller_id uuid not null references auth.users(id) on delete cascade,
 reviewer_id uuid not null references auth.users(id) on delete cascade,
 rating integer not null check (rating between 1 and 5),
 comment text not null default '' check (char_length(comment) <= 500),
 created_at timestamptz not null default now(),
 unique(seller_id, reviewer_id),
 check(seller_id <> reviewer_id)
);
create index if not exists marketplace_reviews_seller_idx on public.marketplace_seller_reviews(seller_id,created_at desc);
create or replace function public.marketplace_review_guard() returns trigger
language plpgsql security definer set search_path = '' as $$
begin
 if auth.uid() is null then raise exception 'Sign in required'; end if;
 new.reviewer_id := auth.uid();
 if new.seller_id = auth.uid() then raise exception 'You cannot review yourself'; end if;
 if not exists (select 1 from public.marketplace_messages m
   join public.marketplace_listings l on l.id=m.listing_id
   where l.owner_id=new.seller_id and m.sender_id=auth.uid() and m.recipient_id=new.seller_id)
 then raise exception 'Only buyers who contacted this seller can review'; end if;
 return new;
end $$;
drop trigger if exists marketplace_review_guard_trigger on public.marketplace_seller_reviews;
create trigger marketplace_review_guard_trigger before insert on public.marketplace_seller_reviews
for each row execute function public.marketplace_review_guard();
alter table public.marketplace_seller_reviews enable row level security;
revoke all on public.marketplace_seller_reviews from public,anon,authenticated;
grant select on public.marketplace_seller_reviews to anon,authenticated;
grant insert on public.marketplace_seller_reviews to authenticated;
drop policy if exists "Anyone can read seller reviews" on public.marketplace_seller_reviews;
create policy "Anyone can read seller reviews" on public.marketplace_seller_reviews
for select to anon,authenticated using (true);
drop policy if exists "Contacted buyers can write reviews" on public.marketplace_seller_reviews;
create policy "Contacted buyers can write reviews" on public.marketplace_seller_reviews
for insert to authenticated with check (reviewer_id=(select auth.uid()) and seller_id<>(select auth.uid()));
-- No client update or delete permissions. Public reviews are not verified purchases.
create or replace function public.marketplace_public_seller_profile(p_seller_id uuid)
returns jsonb language sql stable security definer set search_path = '' as $$
 select case when exists (select 1 from public.marketplace_listings l where l.owner_id=p_seller_id and l.status='published')
 then jsonb_build_object(
 'seller_id',p_seller_id,
 'display_name',coalesce((select p.display_name from public.marketplace_profiles p where p.id=p_seller_id),'Marketplace seller'),
 'published_count',(select count(*) from public.marketplace_listings l where l.owner_id=p_seller_id and l.status='published'),
 'review_count',(select count(*) from public.marketplace_seller_reviews r where r.seller_id=p_seller_id),
 'average_rating',(select round(avg(r.rating)::numeric,1) from public.marketplace_seller_reviews r where r.seller_id=p_seller_id))
 else null end;
$$;
revoke all on function public.marketplace_public_seller_profile(uuid) from public;
grant execute on function public.marketplace_public_seller_profile(uuid) to anon,authenticated;
