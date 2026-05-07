---
tags: [analytics, tracking, growth, plan]
status: draft
created: 2026-05-07
---

# Analytics & Tracking — Suvlime

The whole point: **we are an affiliate site.** Revenue = clicks → conversions on partner clinics. If we don't know which page → which quiz answer → which clinic CTA actually converts, we're flying blind.

This doc is the living plan for **what we capture, where we store it, how we view it.**

---

## What we need to know

In rough order of business value:

1. **Conversions per clinic** — how many "See [Clinic] plans →" clicks fire per day, per clinic. (Pre-revenue proxy until partners give us postbacks.)
2. **Quiz funnel** — start → step-by-step drop-off → completion → recommended-clinic CTA click.
3. **Audience demographics** — age bracket, sex, goal. *Which segment converts best?*
4. **Traffic sources** — UTM source/medium/campaign + landing page → conversion. Where do we double down?
5. **Engagement** — time-on-gallery, before/after slider drags, research tab clicks. Soft signals that predict conversion.
6. **Visits** — pageviews and uniques. Vercel Analytics handles this for free; no DIY needed.

---

## Build vs. buy — decision

**Going DIY on top of Supabase**, with two specific exceptions:

- **Vercel Analytics** for raw pageviews/visitors (free, zero-config, just `<Analytics />`).
- **PostHog** kept on the bench. Cloud free tier is 1M events/mo, but self-hosting is also fully free. If our DIY funnel queries get painful (cohort analysis, retention, session replay), revisit.

Why DIY-on-Supabase wins for us *right now*:

- Schema already exists: `click_events`, `quiz_responses`, plus a soon-to-be-added `page_views`.
- Zero vendor lock-in on the data that defines our business model.
- Trivial joins: "click_events JOIN clinics" gives us per-clinic CTR without leaving SQL.
- Admin page is just a server-rendered Next route hitting Supabase.

What we explicitly **don't** build ourselves:

- Session replay
- Heatmaps
- Cohort retention curves
- A/B test orchestration

If we ever need any of those, we layer PostHog on top. We don't reinvent it.

---

## What we capture

### `page_views` (new table — to add)

Logged on every server-rendered page render. Tiny insert, indexed for time-series queries.

| Column | Type | Notes |
|---|---|---|
| id | uuid | PK |
| ts | timestamptz | default now() |
| path | text | `/`, `/clinics/northwind`, etc. |
| referrer | text | `document.referrer` if any |
| utm_source | text | from query param |
| utm_medium | text | |
| utm_campaign | text | |
| utm_content | text | |
| anon_user_id | text | first-party cookie, 1-year |
| country | text | from `x-vercel-ip-country` header |
| device | text | `mobile` / `desktop` / `tablet` |
| user_agent | text | for bot filtering / debugging |

### `click_events` (already in schema)

Logged on every `/go/[clinic]?ref=...` redirect — i.e., every affiliate click.

Gives: clicks-per-clinic, source-attributed conversions.

### `quiz_responses` (already in schema)

Logged when the user finishes the quiz. Stores all 5 answers as JSONB so the schema doesn't break when we change questions.

`answers` example:
```json
{ "goal": "weight", "age": "30_44", "sex": "f", "budget": "mid", "speed": "soon" }
```

We can also log **partial** responses (each step) to compute drop-off — TBD; might add `quiz_step_events` if we need it.

### `subscribers` (already in schema)

Newsletter / "send me my recommendation" email captures.

---

## Implementation

### Tracker — client side

Tiny `lib/tracker.ts` that exposes:

```ts
track.pageView()                       // fires on route change
track.affiliateClick(clinicSlug)       // fires before /go/ redirect
track.quizComplete(answers, recommendedClinicId)
track.subscribe(email, source)
```

Each call is a `fetch('/api/track/...', { method: 'POST', body })` — we own the endpoint, no third-party JS. No cookie banner needed if we keep the `anon_user_id` cookie first-party and don't share with anyone.

### Tracker — server side

Next route handlers under `app/api/track/`:

- `POST /api/track/page-view`
- `POST /api/track/quiz`
- `POST /api/track/subscribe`
- `GET  /go/[clinic]` — reads `clinic_id`, INSERTs into `click_events`, then 302 to the partner URL with our affiliate ID appended. **This is the revenue mechanism.**

Server-side inserts use the **service role key** so RLS doesn't block them. Anon RLS policies stay strict (insert-only via API, no client-side INSERTs).

### Admin page

`app/admin/page.tsx` — protected behind a single env-gated password (good enough for v1; add Supabase Auth later). Server-rendered cards:

**Top row — last 7 days**
- Pageviews
- Unique visitors (distinct `anon_user_id`)
- Quiz completions
- Affiliate clicks

**Funnel**
- Landed → started quiz → finished quiz → clicked recommended clinic
- Drop-off % at each step

**Per-clinic**
- Clicks
- Quiz recommendations
- Click-through rate from gallery vs from clinic card

**Demographics (sliced from quiz_responses)**
- Age bracket distribution
- Sex distribution
- Goal distribution
- *Which combination converts best?*

**Sources**
- Top 10 UTM sources by clicks
- Top 10 referrers

All powered by SQL views in Supabase. Each card = one query.

---

## Quiz expansion — 5 questions

Going from 3 to 5 to capture demographics that the admin page actually needs:

1. **Goal** *(existing)* — drives clinic recommendation
2. **Age bracket** *(new)* — `18_29` / `30_44` / `45_59` / `60_plus`
3. **Sex** *(new)* — `m` / `f` / `other` — relevant because Vertex is men-only
4. **Budget** *(existing)*
5. **Timeline** *(existing)*

We log all 5 as a single JSONB blob. Adding/removing questions later is a code change, no migration needed.

---

## Privacy & compliance

- First-party cookie only (`anon_user_id`). No third-party trackers.
- Affiliate disclosure already in footer (FTC requirement).
- If/when we ship to EU: add a cookie banner *only for analytics consent*, not transactional. Currently US-only audience so we're OK.
- HIPAA does **not** apply — we're not a covered entity, we're a publisher. Quiz answers aren't tied to a clinical record.

---

## Backlog (in order)

- [x] Schema for `clinics`, `before_afters`, `testimonials`, `research_studies`, `quiz_responses`, `click_events`, `subscribers`
- [x] Quiz: bump to 5 questions (add `age`, `sex`)
- [ ] `page_views` table + migration
- [ ] `lib/supabase.ts` — server + browser clients
- [ ] `lib/tracker.ts` — client tracking helper + first-party cookie helper
- [ ] `POST /api/track/page-view`
- [ ] `POST /api/track/quiz`
- [ ] `GET /go/[clinic]` — affiliate redirect with click logging
- [ ] `app/admin/page.tsx` — env-password-gated dashboard
- [ ] SQL views: `v_funnel_7d`, `v_clinic_perf_7d`, `v_demographics`
- [ ] Vercel Analytics (`@vercel/analytics` package)
- [ ] (Later) Postback integration with partner clinics for actual conversion data, not just CTR

---

## Open questions

- Do we capture email earlier in the funnel (before quiz finish) for retargeting? **Tradeoff:** email gate kills completion rate.
- Do we want to log partial-quiz drop-off events? **Tradeoff:** DB writes vs. measuring funnel friction.
- When do we revisit PostHog? **Trigger:** when we want session replay or A/B testing.
