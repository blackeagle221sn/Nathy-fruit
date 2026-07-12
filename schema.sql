-- ============================================
-- Nathy Exotic Fruits — Schéma de base de données
-- À copier-coller dans Supabase > SQL Editor > Run
-- ============================================

create table if not exists utilisateurs (
  id uuid primary key default gen_random_uuid(),
  nom text not null,
  pin text not null,
  created_at timestamptz default now()
);

create table if not exists produits (
  id uuid primary key default gen_random_uuid(),
  nom text not null,
  prix_gros numeric default 0,
  prix_petit numeric default 0,
  unite text default 'carton',
  created_at timestamptz default now()
);

create table if not exists clients (
  id uuid primary key default gen_random_uuid(),
  nom text not null,
  numero text,
  created_at timestamptz default now()
);

create table if not exists factures (
  id uuid primary key default gen_random_uuid(),
  numero integer not null,
  date_facture date not null default current_date,
  client_nom text not null,
  client_numero text,
  utilisateur text,
  total numeric not null default 0,
  acompte numeric not null default 0,
  restant numeric not null default 0,
  statut text not null default 'en_cours',
  created_at timestamptz default now()
);

create table if not exists facture_lignes (
  id uuid primary key default gen_random_uuid(),
  facture_id uuid references factures(id) on delete cascade,
  qte text not null,
  designation text not null,
  prix numeric not null default 0,
  ordre integer default 0
);

-- Compteur de numéro de facture auto-incrémenté
create table if not exists compteurs (
  cle text primary key,
  valeur integer not null default 200
);
insert into compteurs (cle, valeur) values ('numero_facture', 209)
  on conflict (cle) do nothing;

-- Active l'accès (RLS ouvert car usage interne à 2 personnes avec PIN applicatif)
alter table utilisateurs enable row level security;
alter table produits enable row level security;
alter table clients enable row level security;
alter table factures enable row level security;
alter table facture_lignes enable row level security;
alter table compteurs enable row level security;

create policy "allow all utilisateurs" on utilisateurs for all using (true) with check (true);
create policy "allow all produits" on produits for all using (true) with check (true);
create policy "allow all clients" on clients for all using (true) with check (true);
create policy "allow all factures" on factures for all using (true) with check (true);
create policy "allow all facture_lignes" on facture_lignes for all using (true) with check (true);
create policy "allow all compteurs" on compteurs for all using (true) with check (true);

-- Utilisateurs de départ (change les PIN ensuite si tu veux)
insert into utilisateurs (nom, pin) values
  ('Cheikh', '1234'),
  ('Employé', '5678')
on conflict do nothing;

-- Catalogue de départ, basé sur ta liste "Prix clients"
insert into produits (nom, prix_gros, prix_petit) values
  ('Pomme', 32000, 16000),
  ('Prune', 20000, 10000),
  ('Kiwi', 20000, 10000),
  ('Clémentine', 20000, 10000),
  ('Raisin', 20000, 10000),
  ('Banane', 21000, 10500),
  ('Poire', 27000, 13500),
  ('Orange', 20000, 10000),
  ('Ananas', 17000, 8500)
on conflict do nothing;
