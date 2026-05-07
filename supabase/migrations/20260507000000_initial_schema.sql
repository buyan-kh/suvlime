-- Suvlime initial schema
-- Content tables (clinics, gallery, reviews, research) are public-readable.
-- Write-only tables (clicks, quiz responses, subscribers) accept anon inserts only.

create extension if not exists "pgcrypto";

-- =========================================================================
-- CONTENT
-- =========================================================================

create table clinics (
  id              uuid primary key default gen_random_uuid(),
  slug            text unique not null,
  name            text not null,
  tagline         text not null,
  categories      text[] not null default '{}',
  price_from      integer not null,
  price_unit      text not null default '/mo',
  rating          numeric(3,2) not null,
  reviews         integer not null default 0,
  badges          text[] not null default '{}',
  pros            text[] not null default '{}',
  cons            text[] not null default '{}',
  shipping        text,
  states          integer,
  affiliate_label text not null,
  affiliate_url   text not null,
  sort_order      integer not null default 0,
  published       boolean not null default true,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create table before_afters (
  id           uuid primary key default gen_random_uuid(),
  slug         text unique not null,
  person_name  text not null,
  category     text not null,
  protocol     text not null,
  weeks        integer not null,
  stat_label   text not null,
  stat_value   text not null,
  stat_sub     text,
  caption      text not null,
  before_image text not null,
  after_image  text not null,
  clinic_id    uuid references clinics(id) on delete set null,
  verified     boolean not null default false,
  sort_order   integer not null default 0,
  published    boolean not null default true,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

create table testimonials (
  id          uuid primary key default gen_random_uuid(),
  slug        text unique not null,
  person_name text not null,
  age         integer,
  location    text,
  photo       text,
  protocol    text not null,
  stats       jsonb not null default '[]'::jsonb,
  quote       text not null,
  rating      integer not null default 5,
  verified    boolean not null default false,
  clinic_id   uuid references clinics(id) on delete set null,
  sort_order  integer not null default 0,
  published   boolean not null default true,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create table research_studies (
  id            uuid primary key default gen_random_uuid(),
  slug          text unique not null,
  compound      text not null,
  headline      text not null,
  vs_placebo    text,
  n             integer,
  study         text,
  series        numeric[] not null default '{}',
  placebo_series numeric[] not null default '{}',
  sort_order    integer not null default 0,
  published     boolean not null default true,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

create table peptide_facts (
  id          uuid primary key default gen_random_uuid(),
  compound    text not null,
  primary_use text not null,
  evidence    text,
  dose        text,
  sort_order  integer not null default 0,
  published   boolean not null default true,
  created_at  timestamptz not null default now()
);

-- =========================================================================
-- LEADS / EVENTS
-- =========================================================================

create table click_events (
  id            uuid primary key default gen_random_uuid(),
  clinic_id     uuid references clinics(id) on delete set null,
  source_path   text,
  utm_source    text,
  utm_medium    text,
  utm_campaign  text,
  utm_content   text,
  referrer      text,
  country       text,
  anon_user_id  text,
  created_at    timestamptz not null default now()
);

create index click_events_clinic_id_created_at_idx
  on click_events (clinic_id, created_at desc);

create table quiz_responses (
  id                     uuid primary key default gen_random_uuid(),
  answers                jsonb not null,
  recommended_clinic_id  uuid references clinics(id) on delete set null,
  email                  text,
  anon_user_id           text,
  created_at             timestamptz not null default now()
);

create table subscribers (
  id          uuid primary key default gen_random_uuid(),
  email       text unique not null,
  source      text,
  created_at  timestamptz not null default now()
);

-- =========================================================================
-- ROW-LEVEL SECURITY
-- =========================================================================

-- Public content: anyone can read; only service_role can write.
alter table clinics          enable row level security;
alter table before_afters    enable row level security;
alter table testimonials     enable row level security;
alter table research_studies enable row level security;
alter table peptide_facts    enable row level security;

create policy "public read clinics"          on clinics          for select using (published);
create policy "public read before_afters"    on before_afters    for select using (published);
create policy "public read testimonials"     on testimonials     for select using (published);
create policy "public read research_studies" on research_studies for select using (published);
create policy "public read peptide_facts"    on peptide_facts    for select using (published);

-- Lead tables: anon may insert, no one but service_role may read.
alter table click_events    enable row level security;
alter table quiz_responses  enable row level security;
alter table subscribers     enable row level security;

create policy "anon insert clicks"  on click_events   for insert with check (true);
create policy "anon insert quiz"    on quiz_responses for insert with check (true);
create policy "anon insert subs"    on subscribers    for insert with check (true);

-- =========================================================================
-- updated_at triggers
-- =========================================================================

create or replace function set_updated_at() returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end $$;

create trigger clinics_updated_at       before update on clinics       for each row execute function set_updated_at();
create trigger before_afters_updated_at before update on before_afters for each row execute function set_updated_at();
create trigger testimonials_updated_at  before update on testimonials  for each row execute function set_updated_at();
create trigger research_updated_at      before update on research_studies for each row execute function set_updated_at();
