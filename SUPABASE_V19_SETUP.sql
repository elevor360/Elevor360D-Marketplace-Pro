-- V19: run after V16. Read-only admin seller overview. No billing tables or payment collection.
create or replace function public.marketplace_admin_seller_overview()
returns table (id uuid, display_name text, published_count bigint, draft_count bigint, sold_count bigint)
language plpgsql stable security definer set search_path = '' as $$
begin
 if not public.marketplace_is_admin() then raise exception 'Not authorised' using errcode='42501'; end if;
 return query select p.id,p.display_name,
 count(l.id) filter (where l.status='published'),
 count(l.id) filter (where l.status='draft'),
 count(l.id) filter (where l.status='sold')
 from public.marketplace_profiles p left join public.marketplace_listings l on l.owner_id=p.id
 group by p.id,p.display_name order by p.display_name limit 500;
end $$;
revoke all on function public.marketplace_admin_seller_overview() from public, anon;
grant execute on function public.marketplace_admin_seller_overview() to authenticated;
