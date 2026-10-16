-- Elevor360D Marketplace Pro V14. Run in a NEW SQL Editor query after V13.
-- Authenticated-only private messages. RLS protects read access.
create table if not exists public.marketplace_messages (
 id uuid primary key default gen_random_uuid(),
 listing_id uuid not null references public.marketplace_listings(id) on delete cascade,
 sender_id uuid not null references auth.users(id) on delete cascade,
 recipient_id uuid not null references auth.users(id) on delete cascade,
 body text not null check (char_length(btrim(body)) between 1 and 2000),
 created_at timestamptz not null default now(),
 constraint different_users check (sender_id <> recipient_id)
);
create index if not exists marketplace_messages_participants on public.marketplace_messages(sender_id,recipient_id,created_at desc);
create index if not exists marketplace_messages_listing on public.marketplace_messages(listing_id,created_at desc);
create or replace function public.marketplace_message_guard() returns trigger language plpgsql security definer set search_path = '' as $$
declare owner uuid; listing_status text;
begin
 if auth.uid() is null then raise exception 'Authentication required'; end if;
 select l.owner_id,l.status into owner,listing_status from public.marketplace_listings l where l.id=new.listing_id;
 if owner is null then raise exception 'Listing not found'; end if;
 new.sender_id := auth.uid();
 if new.sender_id=owner then
   if new.recipient_id is null or not exists (
      select 1 from public.marketplace_messages m where m.listing_id=new.listing_id
      and m.sender_id=new.recipient_id and m.recipient_id=owner
   ) then raise exception 'Seller may only reply to a buyer who has contacted them'; end if;
 else
   if listing_status <> 'published' then raise exception 'Listing is not published'; end if;
   if new.recipient_id is distinct from owner then raise exception 'Buyer must message listing owner'; end if;
 end if;
 return new;
end $$;
drop trigger if exists marketplace_message_guard_trigger on public.marketplace_messages;
create trigger marketplace_message_guard_trigger before insert on public.marketplace_messages for each row execute function public.marketplace_message_guard();
alter table public.marketplace_messages enable row level security;
revoke all on public.marketplace_messages from public, anon, authenticated;
grant select, insert on public.marketplace_messages to authenticated;
drop policy if exists "Participants can read their messages" on public.marketplace_messages;
create policy "Participants can read their messages" on public.marketplace_messages for select to authenticated using (sender_id=(select auth.uid()) or recipient_id=(select auth.uid()));
drop policy if exists "Authenticated participants can send" on public.marketplace_messages;
create policy "Authenticated participants can send" on public.marketplace_messages for insert to authenticated with check (sender_id=(select auth.uid()));
-- No update/delete grants or policies. Never expose service-role credentials.
