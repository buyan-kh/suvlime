// Shared data for both variations of Suvlime
// Fictional clinics, fictional testimonials, fictional but plausible research numbers.

window.SUVLIME_DATA = {
  brand: {
    name: "suvlime",
    tagline: "Peptides, GLP-1s, and the science behind them — without the noise.",
  },

  categories: [
    { id: "glp1", label: "GLP-1s", short: "Weight" },
    { id: "peptides", label: "Peptides", short: "Recovery" },
    { id: "ed", label: "ED", short: "Performance" },
    { id: "trt", label: "TRT", short: "Hormones" },
    { id: "sleep", label: "Sleep", short: "Recovery" },
  ],

  // ====== BEFORE / AFTER GALLERY (primary screen) ======
  beforeAfters: [
    {
      id: "ba-mara",
      name: "Mara, 38",
      category: "glp1",
      protocol: "Tirzepatide 2.5→7.5mg",
      weeks: 16,
      stat: { label: "Lost", value: "−24 lb", sub: "Week 0 → 16" },
      caption:
        "Plateaued at 178 for two years. Started low-dose tirzepatide through Northwind in February.",
      // Using high-quality Unsplash people photos — different angles to feel like before/after
      before: "https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=900&q=80",
      after: "https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=900&q=80",
      clinic: "Northwind Health",
      verified: true,
    },
    {
      id: "ba-james",
      name: "James, 44",
      category: "trt",
      protocol: "Testosterone Cypionate 100mg/wk",
      weeks: 12,
      stat: { label: "T level", value: "287 → 742", sub: "ng/dL" },
      caption:
        "Energy, sleep, and lifts all came back online by week six. Wife noticed before I did.",
      before: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=900&q=80",
      after: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=900&q=80",
      clinic: "Meridian MD",
      verified: true,
    },
    {
      id: "ba-priya",
      name: "Priya, 31",
      category: "peptides",
      protocol: "BPC-157 + TB-500 stack",
      weeks: 8,
      stat: { label: "Pain score", value: "7 → 1", sub: "Tendinopathy" },
      caption:
        "Six months of PT didn't touch my elbow tendinopathy. Eight weeks on the stack and it's gone.",
      before: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=900&q=80",
      after: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=900&q=80",
      clinic: "Helix Peptides",
      verified: true,
    },
    {
      id: "ba-david",
      name: "David, 52",
      category: "glp1",
      protocol: "Semaglutide 0.5→2.0mg",
      weeks: 24,
      stat: { label: "Lost", value: "−41 lb", sub: "A1C 6.8 → 5.4" },
      caption:
        "I'd tried everything. Semaglutide didn't feel like willpower — it felt like the volume knob got turned down.",
      before: "https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=900&q=80",
      after: "https://images.unsplash.com/photo-1564564321837-a57b7070ac4f?w=900&q=80",
      clinic: "Northwind Health",
      verified: true,
    },
    {
      id: "ba-sasha",
      name: "Sasha, 29",
      category: "peptides",
      protocol: "Ipamorelin / CJC-1295",
      weeks: 12,
      stat: { label: "Deep sleep", value: "+47 min", sub: "Oura nightly avg" },
      caption:
        "Sleep architecture totally changed. I wake up before my alarm now, which used to be unthinkable.",
      before: "https://images.unsplash.com/photo-1517841905240-472988babdf9?w=900&q=80",
      after: "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=900&q=80",
      clinic: "Helix Peptides",
      verified: false,
    },
    {
      id: "ba-marcus",
      name: "Marcus, 47",
      category: "ed",
      protocol: "Tadalafil 5mg daily",
      weeks: 6,
      stat: { label: "IIEF-5", value: "14 → 23", sub: "Out of 25" },
      caption:
        "Daily low-dose worked where the on-demand stuff didn't. Felt like myself again by week three.",
      before: "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=900&q=80",
      after: "https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=900&q=80",
      clinic: "Vertex Men's Health",
      verified: true,
    },
  ],

  // ====== CLINICS ======
  clinics: [
    {
      id: "northwind",
      name: "Northwind Health",
      categories: ["glp1", "trt"],
      tagline: "GLP-1 specialists. Compounded and brand-name.",
      price: { from: 199, unit: "/mo" },
      rating: 4.8,
      reviews: 2419,
      badges: ["Compounded options", "Insurance-friendly", "MD-supervised"],
      pros: ["Lowest GLP-1 starting price", "Free initial consult", "Same-day Rx"],
      cons: ["Wait list in 6 states", "No peptides"],
      shipping: "Free, 2–3 days",
      states: 44,
      affiliateLabel: "See Northwind plans",
    },
    {
      id: "meridian",
      name: "Meridian MD",
      categories: ["trt", "ed"],
      tagline: "Hormone optimization, taken seriously.",
      price: { from: 165, unit: "/mo" },
      rating: 4.7,
      reviews: 1182,
      badges: ["Full bloodwork", "MD on call", "TRT specialists"],
      pros: ["Most thorough labs", "Real telehealth visits", "Includes ED meds"],
      cons: ["Higher upfront cost", "Mail-in labs only"],
      shipping: "Included",
      states: 50,
      affiliateLabel: "See Meridian plans",
    },
    {
      id: "helix",
      name: "Helix Peptides",
      categories: ["peptides", "sleep"],
      tagline: "Research peptides, prescribed and shipped.",
      price: { from: 129, unit: "/mo" },
      rating: 4.6,
      reviews: 743,
      badges: ["BPC-157, TB-500, Ipamorelin", "Pharmacist-compounded", "Cold-chain shipping"],
      pros: ["Largest peptide formulary", "Stack discounts", "Detailed protocols"],
      cons: ["Limited GLP-1 options", "33 states only"],
      shipping: "$15, overnight",
      states: 33,
      affiliateLabel: "See Helix plans",
    },
    {
      id: "vertex",
      name: "Vertex Men's Health",
      categories: ["ed", "trt"],
      tagline: "ED, TRT, and recovery — for men over 35.",
      price: { from: 89, unit: "/mo" },
      rating: 4.5,
      reviews: 3104,
      badges: ["Generic + brand", "Discreet packaging", "Async refills"],
      pros: ["Cheapest ED option", "Bundled discounts", "Fast intake"],
      cons: ["Async-only consults", "Upsells in cart"],
      shipping: "Free",
      states: 50,
      affiliateLabel: "See Vertex plans",
    },
  ],

  // ====== RESEARCH (data-viz forward) ======
  research: [
    {
      id: "step1",
      compound: "Semaglutide 2.4mg",
      headline: "−14.9% body weight at 68 weeks",
      vsPlacebo: "−2.4%",
      n: 1961,
      study: "STEP 1 (NEJM, 2021)",
      // Weekly weight change %, 16 data points
      series: [0, -1.4, -2.8, -4.1, -5.5, -6.8, -7.9, -9.0, -10.0, -11.0, -11.8, -12.6, -13.3, -14.0, -14.5, -14.9],
      placebo: [0, -0.2, -0.5, -0.8, -1.0, -1.3, -1.5, -1.6, -1.8, -1.9, -2.0, -2.1, -2.2, -2.3, -2.35, -2.4],
    },
    {
      id: "surmount",
      compound: "Tirzepatide 15mg",
      headline: "−20.9% body weight at 72 weeks",
      vsPlacebo: "−3.1%",
      n: 2539,
      study: "SURMOUNT-1 (NEJM, 2022)",
      series: [0, -2.0, -4.0, -6.0, -8.0, -10.0, -12.0, -13.5, -15.0, -16.5, -17.8, -18.8, -19.5, -20.1, -20.6, -20.9],
      placebo: [0, -0.3, -0.6, -0.9, -1.2, -1.5, -1.8, -2.0, -2.2, -2.4, -2.6, -2.8, -2.9, -3.0, -3.05, -3.1],
    },
  ],

  peptideFacts: [
    { compound: "BPC-157", primary: "Tendon/gut healing", evidence: "Animal + small human", dose: "250–500mcg sc daily" },
    { compound: "TB-500", primary: "Soft-tissue repair", evidence: "Animal", dose: "2–5mg sc weekly" },
    { compound: "Ipamorelin", primary: "GH pulse / sleep", evidence: "Human", dose: "200–300mcg sc nightly" },
    { compound: "CJC-1295", primary: "GH amplification", evidence: "Human", dose: "1–2mg sc weekly" },
    { compound: "GHK-Cu", primary: "Skin / collagen", evidence: "Human (topical)", dose: "1–3mg sc 3×/wk" },
  ],

  // ====== TESTIMONIALS (long-form) ======
  testimonials: [
    {
      id: "t-mara",
      name: "Mara K.",
      age: 38,
      location: "Austin, TX",
      photo: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&q=80",
      protocol: "Tirzepatide via Northwind",
      stats: [
        { k: "Start", v: "178 lb" },
        { k: "Now", v: "154 lb" },
        { k: "Weeks", v: "16" },
      ],
      quote:
        "I'd plateaued for two years. Diet, lifting, the whole thing. The first week on tirzepatide I just… wasn't thinking about food every twenty minutes. That's the part nobody told me. The weight came off but the bigger thing was getting my brain back.",
      rating: 5,
      verified: true,
    },
    {
      id: "t-james",
      name: "James R.",
      age: 44,
      location: "Denver, CO",
      photo: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&q=80",
      protocol: "TRT via Meridian",
      stats: [
        { k: "Free T", v: "287 → 742" },
        { k: "Sleep", v: "+1.2 hr" },
        { k: "Weeks", v: "12" },
      ],
      quote:
        "I thought I was just getting old. Turns out I had the testosterone of an 80-year-old at 44. Six weeks in, I was lifting numbers I hadn't seen since my twenties. My wife noticed before I did — she said I just seemed like myself again.",
      rating: 5,
      verified: true,
    },
    {
      id: "t-priya",
      name: "Priya S.",
      age: 31,
      location: "Brooklyn, NY",
      photo: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&q=80",
      protocol: "BPC-157 + TB-500 via Helix",
      stats: [
        { k: "Pain", v: "7 → 1" },
        { k: "Grip", v: "+18%" },
        { k: "Weeks", v: "8" },
      ],
      quote:
        "Climbing-induced tendinopathy that PT couldn't touch. I was skeptical — peptides feel like the wild west. But Helix walked me through dosing, sent everything cold-chain, and my elbow is functionally healed. I climb V6 again.",
      rating: 5,
      verified: true,
    },
    {
      id: "t-david",
      name: "David L.",
      age: 52,
      location: "Phoenix, AZ",
      photo: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&q=80",
      protocol: "Semaglutide via Northwind",
      stats: [
        { k: "Start", v: "247 lb" },
        { k: "Now", v: "206 lb" },
        { k: "A1C", v: "6.8 → 5.4" },
      ],
      quote:
        "Pre-diabetic, knees shot, snoring my wife out of the bedroom. Six months on semaglutide and I came off two BP meds. My doctor was the one who suggested I try a telehealth route — she couldn't prescribe it for weight loss but Northwind could.",
      rating: 5,
      verified: true,
    },
  ],

  // ====== QUIZ ======
  quiz: [
    {
      id: "goal",
      q: "What's the primary goal?",
      options: [
        { id: "weight", label: "Lose weight", maps: ["glp1"] },
        { id: "energy", label: "Energy + libido", maps: ["trt", "ed"] },
        { id: "recovery", label: "Recovery + sleep", maps: ["peptides", "sleep"] },
        { id: "ed", label: "ED specifically", maps: ["ed"] },
      ],
    },
    {
      id: "budget",
      q: "Monthly budget?",
      options: [
        { id: "low", label: "Under $150" },
        { id: "mid", label: "$150–$300" },
        { id: "high", label: "$300+" },
      ],
    },
    {
      id: "speed",
      q: "How fast do you want to start?",
      options: [
        { id: "now", label: "This week" },
        { id: "soon", label: "This month" },
        { id: "research", label: "Just researching" },
      ],
    },
  ],
};
