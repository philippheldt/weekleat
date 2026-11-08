-- Einmal im Supabase-Dashboard unter "SQL Editor" ausführen.
-- Legt die einzige Tabelle an, in der Wochenplan, Votes, Einstellungen und
-- Einkaufsliste gespeichert werden (die Rezepte selbst stehen in rezepte.yaml).

create table if not exists public.items (
  collection text not null,
  id         text not null,
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (collection, id)
);

create or replace function public.items_touch() returns trigger
language plpgsql as $$
begin
  new.updated_at := now();
  return new;
end $$;

drop trigger if exists items_touch on public.items;
create trigger items_touch before insert or update on public.items
  for each row execute function public.items_touch();

-- Nur angemeldete Nutzer (euer gemeinsamer Haushalts-Login) dürfen lesen und schreiben.
alter table public.items enable row level security;

drop policy if exists "Haushalt darf alles" on public.items;
create policy "Haushalt darf alles" on public.items
  for all to authenticated using (true) with check (true);

-- Live-Synchronisierung zwischen den Handys einschalten.
do $$
begin
  alter publication supabase_realtime add table public.items;
exception when duplicate_object then null;
end $$;
