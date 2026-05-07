-- Suvlime seed data — mirrors lib/data.ts for local dev.
-- Run automatically by `supabase db reset` and `supabase start`.

-- =========================================================================
-- CLINICS
-- =========================================================================
insert into clinics (slug, name, tagline, categories, price_from, price_unit, rating, reviews, badges, pros, cons, shipping, states, affiliate_label, affiliate_url, sort_order) values
('northwind', 'Northwind Health', 'GLP-1 specialists. Compounded and brand-name.',
  '{glp1,trt}', 199, '/mo', 4.8, 2419,
  '{"Compounded options","Insurance-friendly","MD-supervised"}',
  '{"Lowest GLP-1 starting price","Free initial consult","Same-day Rx"}',
  '{"Wait list in 6 states","No peptides"}',
  'Free, 2–3 days', 44, 'See Northwind plans', 'https://example.com/northwind', 0),
('meridian', 'Meridian MD', 'Hormone optimization, taken seriously.',
  '{trt,ed}', 165, '/mo', 4.7, 1182,
  '{"Full bloodwork","MD on call","TRT specialists"}',
  '{"Most thorough labs","Real telehealth visits","Includes ED meds"}',
  '{"Higher upfront cost","Mail-in labs only"}',
  'Included', 50, 'See Meridian plans', 'https://example.com/meridian', 1),
('helix', 'Helix Peptides', 'Research peptides, prescribed and shipped.',
  '{peptides,sleep}', 129, '/mo', 4.6, 743,
  '{"BPC-157, TB-500, Ipamorelin","Pharmacist-compounded","Cold-chain shipping"}',
  '{"Largest peptide formulary","Stack discounts","Detailed protocols"}',
  '{"Limited GLP-1 options","33 states only"}',
  '$15, overnight', 33, 'See Helix plans', 'https://example.com/helix', 2),
('vertex', 'Vertex Men''s Health', 'ED, TRT, and recovery — for men over 35.',
  '{ed,trt}', 89, '/mo', 4.5, 3104,
  '{"Generic + brand","Discreet packaging","Async refills"}',
  '{"Cheapest ED option","Bundled discounts","Fast intake"}',
  '{"Async-only consults","Upsells in cart"}',
  'Free', 50, 'See Vertex plans', 'https://example.com/vertex', 3);

-- =========================================================================
-- BEFORE / AFTERS
-- =========================================================================
insert into before_afters (slug, person_name, category, protocol, weeks, stat_label, stat_value, stat_sub, caption, before_image, after_image, clinic_id, verified, sort_order)
select
  v.slug, v.person_name, v.category, v.protocol, v.weeks, v.stat_label, v.stat_value, v.stat_sub,
  v.caption, v.before_image, v.after_image,
  (select id from clinics where slug = v.clinic_slug),
  v.verified, v.sort_order
from (values
  ('ba-mara',   'Mara, 38',   'glp1',     'Tirzepatide 2.5→7.5mg',           16, 'Lost',       '−24 lb',    'Week 0 → 16',
   'Plateaued at 178 for two years. Started low-dose tirzepatide through Northwind in February.',
   'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=900&q=80',
   'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=900&q=80',
   'northwind', true, 0),
  ('ba-james',  'James, 44',  'trt',      'Testosterone Cypionate 100mg/wk', 12, 'T level',    '287 → 742', 'ng/dL',
   'Energy, sleep, and lifts all came back online by week six. Wife noticed before I did.',
   'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=900&q=80',
   'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=900&q=80',
   'meridian',  true, 1),
  ('ba-priya',  'Priya, 31',  'peptides', 'BPC-157 + TB-500 stack',           8, 'Pain score', '7 → 1',     'Tendinopathy',
   'Six months of PT didn''t touch my elbow tendinopathy. Eight weeks on the stack and it''s gone.',
   'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=900&q=80',
   'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=900&q=80',
   'helix',     true, 2),
  ('ba-david',  'David, 52',  'glp1',     'Semaglutide 0.5→2.0mg',           24, 'Lost',       '−41 lb',    'A1C 6.8 → 5.4',
   'I''d tried everything. Semaglutide didn''t feel like willpower — it felt like the volume knob got turned down.',
   'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=900&q=80',
   'https://images.unsplash.com/photo-1564564321837-a57b7070ac4f?w=900&q=80',
   'northwind', true, 3),
  ('ba-sasha',  'Sasha, 29',  'peptides', 'Ipamorelin / CJC-1295',           12, 'Deep sleep', '+47 min',   'Oura nightly avg',
   'Sleep architecture totally changed. I wake up before my alarm now, which used to be unthinkable.',
   'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=900&q=80',
   'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=900&q=80',
   'helix',     false, 4),
  ('ba-marcus', 'Marcus, 47', 'ed',       'Tadalafil 5mg daily',              6, 'IIEF-5',     '14 → 23',   'Out of 25',
   'Daily low-dose worked where the on-demand stuff didn''t. Felt like myself again by week three.',
   'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=900&q=80',
   'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=900&q=80',
   'vertex',    true, 5)
) as v(slug, person_name, category, protocol, weeks, stat_label, stat_value, stat_sub, caption, before_image, after_image, clinic_slug, verified, sort_order);

-- =========================================================================
-- TESTIMONIALS
-- =========================================================================
insert into testimonials (slug, person_name, age, location, photo, protocol, stats, quote, verified, clinic_id, sort_order)
select v.slug, v.person_name, v.age, v.location, v.photo, v.protocol, v.stats::jsonb, v.quote, v.verified,
       (select id from clinics where slug = v.clinic_slug), v.sort_order
from (values
  ('t-mara', 'Mara K.', 38, 'Austin, TX',
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&q=80',
    'Tirzepatide via Northwind',
    '[{"k":"Start","v":"178 lb"},{"k":"Now","v":"154 lb"},{"k":"Weeks","v":"16"}]',
    'I''d plateaued for two years. Diet, lifting, the whole thing. The first week on tirzepatide I just… wasn''t thinking about food every twenty minutes. That''s the part nobody told me. The weight came off but the bigger thing was getting my brain back.',
    true, 'northwind', 0),
  ('t-james', 'James R.', 44, 'Denver, CO',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&q=80',
    'TRT via Meridian',
    '[{"k":"Free T","v":"287 → 742"},{"k":"Sleep","v":"+1.2 hr"},{"k":"Weeks","v":"12"}]',
    'I thought I was just getting old. Turns out I had the testosterone of an 80-year-old at 44. Six weeks in, I was lifting numbers I hadn''t seen since my twenties. My wife noticed before I did — she said I just seemed like myself again.',
    true, 'meridian', 1),
  ('t-priya', 'Priya S.', 31, 'Brooklyn, NY',
    'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&q=80',
    'BPC-157 + TB-500 via Helix',
    '[{"k":"Pain","v":"7 → 1"},{"k":"Grip","v":"+18%"},{"k":"Weeks","v":"8"}]',
    'Climbing-induced tendinopathy that PT couldn''t touch. I was skeptical — peptides feel like the wild west. But Helix walked me through dosing, sent everything cold-chain, and my elbow is functionally healed. I climb V6 again.',
    true, 'helix', 2),
  ('t-david', 'David L.', 52, 'Phoenix, AZ',
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&q=80',
    'Semaglutide via Northwind',
    '[{"k":"Start","v":"247 lb"},{"k":"Now","v":"206 lb"},{"k":"A1C","v":"6.8 → 5.4"}]',
    'Pre-diabetic, knees shot, snoring my wife out of the bedroom. Six months on semaglutide and I came off two BP meds. My doctor was the one who suggested I try a telehealth route — she couldn''t prescribe it for weight loss but Northwind could.',
    true, 'northwind', 3)
) as v(slug, person_name, age, location, photo, protocol, stats, quote, verified, clinic_slug, sort_order);

-- =========================================================================
-- RESEARCH
-- =========================================================================
insert into research_studies (slug, compound, headline, vs_placebo, n, study, series, placebo_series, sort_order) values
('step1', 'Semaglutide 2.4mg', '−14.9% body weight at 68 weeks', '−2.4%', 1961, 'STEP 1 (NEJM, 2021)',
  '{0,-1.4,-2.8,-4.1,-5.5,-6.8,-7.9,-9.0,-10.0,-11.0,-11.8,-12.6,-13.3,-14.0,-14.5,-14.9}'::numeric[],
  '{0,-0.2,-0.5,-0.8,-1.0,-1.3,-1.5,-1.6,-1.8,-1.9,-2.0,-2.1,-2.2,-2.3,-2.35,-2.4}'::numeric[], 0),
('surmount', 'Tirzepatide 15mg', '−20.9% body weight at 72 weeks', '−3.1%', 2539, 'SURMOUNT-1 (NEJM, 2022)',
  '{0,-2.0,-4.0,-6.0,-8.0,-10.0,-12.0,-13.5,-15.0,-16.5,-17.8,-18.8,-19.5,-20.1,-20.6,-20.9}'::numeric[],
  '{0,-0.3,-0.6,-0.9,-1.2,-1.5,-1.8,-2.0,-2.2,-2.4,-2.6,-2.8,-2.9,-3.0,-3.05,-3.1}'::numeric[], 1);

-- =========================================================================
-- PEPTIDE FACTS
-- =========================================================================
insert into peptide_facts (compound, primary_use, evidence, dose, sort_order) values
('BPC-157',   'Tendon/gut healing',  'Animal + small human', '250–500mcg sc daily',  0),
('TB-500',    'Soft-tissue repair',  'Animal',               '2–5mg sc weekly',      1),
('Ipamorelin','GH pulse / sleep',    'Human',                '200–300mcg sc nightly',2),
('CJC-1295',  'GH amplification',    'Human',                '1–2mg sc weekly',      3),
('GHK-Cu',    'Skin / collagen',     'Human (topical)',      '1–3mg sc 3×/wk',       4);
