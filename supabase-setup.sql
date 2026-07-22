-- Run this once in the Supabase SQL Editor.
-- Replace the example address with every person who may use Weekmenu.

create table if not exists public.allowed_emails (
  email text primary key check (email = lower(email))
);

create table if not exists public.app_data (
  id integer primary key check (id = 1),
  payload jsonb not null default '{"menu": {}, "recepten": []}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.allowed_emails enable row level security;
alter table public.app_data enable row level security;

create or replace function public.is_weekmenu_member()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.allowed_emails
    where email = lower(coalesce(auth.jwt() ->> 'email', ''))
  );
$$;

revoke all on function public.is_weekmenu_member() from public;
grant execute on function public.is_weekmenu_member() to authenticated;

drop policy if exists "Members can read app data" on public.app_data;
create policy "Members can read app data" on public.app_data
for select to authenticated using (public.is_weekmenu_member());

drop policy if exists "Members can add app data" on public.app_data;
create policy "Members can add app data" on public.app_data
for insert to authenticated
with check (id = 1 and public.is_weekmenu_member());

drop policy if exists "Members can update app data" on public.app_data;
create policy "Members can update app data" on public.app_data
for update to authenticated
using (public.is_weekmenu_member())
with check (id = 1 and public.is_weekmenu_member());

insert into public.allowed_emails (email) values
  ('replace-with-your-email@example.com')
on conflict (email) do nothing;
