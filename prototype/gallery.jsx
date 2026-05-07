/* global React, SUVLIME_DATA, CompareSlider */
const { useState, useEffect, useMemo } = React;
const D = window.SUVLIME_DATA;

// ---------- Tiny SVG line chart (no library) ----------
function LineChart({ series, placebo, width = 480, height = 220 }) {
  const min = Math.min(...series, ...placebo);
  const max = 0;
  const padX = 36, padY = 24;
  const w = width - padX * 2;
  const h = height - padY * 2;
  const len = series.length;
  const sx = (i) => padX + (i / (len - 1)) * w;
  const sy = (v) => padY + ((v - max) / (min - max)) * h;
  const path = (arr) => arr.map((v, i) => `${i === 0 ? 'M' : 'L'} ${sx(i).toFixed(1)} ${sy(v).toFixed(1)}`).join(' ');
  const area = (arr) => `${path(arr)} L ${sx(len - 1).toFixed(1)} ${padY + h} L ${padX} ${padY + h} Z`;

  // Y gridlines at 0, -5, -10, -15, -20
  const ticks = [];
  for (let v = 0; v >= min; v -= 5) ticks.push(v);

  return (
    <svg className="va-chart-svg" viewBox={`0 0 ${width} ${height}`} preserveAspectRatio="none">
      {ticks.map(t => (
        <g key={t}>
          <line x1={padX} x2={width - padX} y1={sy(t)} y2={sy(t)} stroke="rgba(31,26,20,0.08)" strokeDasharray={t === 0 ? '0' : '2 4'} />
          <text x={padX - 8} y={sy(t) + 3} textAnchor="end" fontFamily="JetBrains Mono, monospace" fontSize="9" fill="rgba(31,26,20,0.5)">{t}%</text>
        </g>
      ))}
      <defs>
        <linearGradient id="va-grad" x1="0" x2="0" y1="0" y2="1">
          <stop offset="0%" stopColor="#C2624A" stopOpacity="0.18" />
          <stop offset="100%" stopColor="#C2624A" stopOpacity="0" />
        </linearGradient>
      </defs>
      <path d={area(series)} fill="url(#va-grad)" />
      <path d={path(placebo)} fill="none" stroke="#7A6F61" strokeWidth="1.5" strokeDasharray="3 3" />
      <path d={path(series)} fill="none" stroke="#C2624A" strokeWidth="2.5" strokeLinejoin="round" strokeLinecap="round" />
      <circle cx={sx(len - 1)} cy={sy(series[len - 1])} r="4" fill="#C2624A" />
      <text x={sx(len - 1) - 6} y={sy(series[len - 1]) - 10} textAnchor="end" fontFamily="Instrument Serif, serif" fontSize="14" fill="#9B4A36" fontWeight="500">{series[len - 1]}%</text>
    </svg>
  );
}

// ---------- Hero ----------
function Hero({ onScrollToGallery }) {
  return (
    <section className="va-hero">
      <div className="container">
        <div className="va-hero-grid">
          <div>
            <span className="eyebrow">Independently reviewed · Updated Apr 2026</span>
            <h1 style={{ marginTop: 18 }}>
              The peptide era,<br/>
              <em>without the bro science.</em>
            </h1>
            <p className="va-hero-lede">
              We test, vet, and rank the telehealth clinics prescribing GLP-1s, peptides, TRT, and ED meds — so you don't have to read another Reddit thread at 2am.
            </p>
            <div className="va-hero-cta-row">
              <button className="va-btn primary lg" onClick={onScrollToGallery}>See real results</button>
              <button className="va-btn outline lg">Take the 60-second quiz</button>
            </div>
            <div className="va-hero-trust">
              <div className="col">
                <span className="num">12</span>
                <div className="lbl">Clinics tested</div>
              </div>
              <div className="col">
                <span className="num">2,847</span>
                <div className="lbl">Verified reviews</div>
              </div>
              <div className="col">
                <span className="num">141</span>
                <div className="lbl">Studies cited</div>
              </div>
            </div>
          </div>
          <div className="va-hero-photo">
            <img src="https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=900&q=80" alt="" />
            <div className="badge"><span className="pulse"></span>Live tracking · 41 protocols</div>
            <div className="stat-card">
              <div className="row">
                <div>
                  <span className="num">−14.9%</span>
                  <div className="lbl">Avg. weight loss · semaglutide</div>
                </div>
                <div>
                  <span className="num">68wk</span>
                  <div className="lbl">STEP 1 trial endpoint</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

// ---------- Category strip / filter ----------
function CategoryStrip({ active, setActive }) {
  const counts = useMemo(() => {
    const m = { all: D.beforeAfters.length };
    D.categories.forEach(c => { m[c.id] = D.beforeAfters.filter(b => b.category === c.id).length; });
    return m;
  }, []);
  return (
    <div className="va-cats">
      <div className="container va-cats-inner">
        <span className="label">Filter by category</span>
        <button className={`va-chip ${active === 'all' ? 'active' : ''}`} onClick={() => setActive('all')}>
          All <span className="n">{counts.all}</span>
        </button>
        {D.categories.map(c => (
          <button key={c.id} className={`va-chip ${active === c.id ? 'active' : ''}`} onClick={() => setActive(c.id)}>
            {c.label} <span className="n">{counts[c.id] || 0}</span>
          </button>
        ))}
      </div>
    </div>
  );
}

// ---------- Before/After Gallery (PRIMARY SCREEN) ----------
function BeforeAfterGallery({ filter }) {
  const items = filter === 'all' ? D.beforeAfters : D.beforeAfters.filter(b => b.category === filter);
  // Layout: feat (8) + std (4) + wide (6) + wide (6) + std (4) + std (4) + std (4)
  const layout = ['feat', 'std', 'wide', 'wide', 'std', 'std', 'std', 'std'];

  return (
    <section className="va-section" id="gallery">
      <div className="container">
        <div className="va-section-head">
          <div className="ttl">
            <span className="eyebrow">The gallery · 12 / 16-week protocols</span>
            <h2 style={{ marginTop: 14 }}>Real people, <em>real protocols,</em><br/>real timelines.</h2>
            <p>Drag the slider on any photo to compare. Every story is paired with the protocol used and the clinic that prescribed it. Verified means we've seen the prescription paperwork.</p>
          </div>
          <div className="actions">
            <button className="va-btn outline sm">Sort: Most recent ↓</button>
            <button className="va-btn outline sm">Submit yours →</button>
          </div>
        </div>

        <div className="va-ba-grid">
          {items.map((b, i) => {
            const span = layout[i % layout.length];
            return (
              <article key={b.id} className={`va-ba-card ${span}`}>
                <CompareSlider before={b.before} after={b.after} />
                <div className="va-ba-meta">
                  <div className="top-row">
                    <div>
                      <div className="name">{b.name}</div>
                      <div className="protocol">{b.protocol} · {b.weeks} weeks</div>
                    </div>
                    <div className="stat">
                      <div className="v">{b.stat.value}</div>
                      <div className="l">{b.stat.label} · {b.stat.sub}</div>
                    </div>
                  </div>
                  <div className="quote">"{b.caption}"</div>
                  <div className="footer">
                    <span>via <strong style={{color: 'var(--ink-2)'}}>{b.clinic}</strong></span>
                    {b.verified && <span className="verified">✓ Verified</span>}
                  </div>
                </div>
              </article>
            );
          })}
        </div>
      </div>
    </section>
  );
}

window.VA_Hero = Hero;
window.VA_CategoryStrip = CategoryStrip;
window.VA_BeforeAfterGallery = BeforeAfterGallery;
window.VA_LineChart = LineChart;
