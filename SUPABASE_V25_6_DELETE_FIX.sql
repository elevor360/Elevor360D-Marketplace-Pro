-- Marketplace Pro V25.6: repair BEFORE DELETE moderation guard.
-- Previous trigger returned NEW on DELETE; NEW is NULL, which silently cancels deletion.
-- Keep moderation checks intact; return OLD for DELETE and NEW for UPDATE.
create or replace function public.marketplace_guard_moderation() returns trigger
language plpgsql security definer set search_path = '' as $$
begin
  if exists (
    select 1 from public.marketplace_listing_moderation m
    where m.listing_id = old.id and m.blocked
  ) then
    if not public.marketplace_is_admin() then
      raise exception 'Listing is blocked by marketplace moderation' using errcode = '42501';
    end if;
  end if;
  if TG_OP = 'DELETE' then
    return OLD;
  end if;
  return NEW;
end;
$$;
