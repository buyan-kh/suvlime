-- Page views — minimal table for traffic analytics.
-- Inserted by POST /api/track/page-view (service-role key, bypasses RLS).

create table page_views (
  id            uuid primary key default gen_random_uuid(),
  path          text not null,
  referrer      text,
  utm_source    text,
  utm_medium    text,
  utm_campaign  text,
  utm_content   text,
  anon_user_id  text not null,
  country       text,
  device        text,
  user_agent    text,
  created_at    timestamptz not null default now()
);

create index page_views_created_at_idx on page_views (created_at desc);
create index page_views_anon_created_idx on page_views (anon_user_id, created_at desc);
create index page_views_path_created_idx on page_views (path, created_at desc);

alter table page_views enable row level security;
-- No policies = nothing reachable from anon. Service role bypasses RLS.
