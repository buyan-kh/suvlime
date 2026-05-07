/* global React, SUVLIME_DATA, VA_LineChart */
const D2 = window.SUVLIME_DATA;

// ---------- Top Clinics (compare strip) ----------
function TopClinics({ onAddCompare, comparing }) {
  return (
    <section className="va-section" id="clinics" style={{ padding: '0', margin: '0' }}>
      <div className="va-clinics">
        <div className="container">
          <div className="va-section-head">
            <div className="ttl">
              <span className="eyebrow" style={{ color: 'rgba(250,247,241,0.5)' }}>The shortlist · Updated weekly</span>
              <h2 style={{ marginTop: 14 }}>Top telehealth clinics<br/><em>worth your script.</em></h2>
              <p>Twelve clinics tested over six months. We ordered, evaluated, and audited every one. These four made the cut.</p>
            </div>
            <button className="va-btn outline sm" style={{ color: 'var(--bone)', borderColor: 'rgba(250,247,241,0.2)' }}>See all 12 ranked →</button>
          </div>

          <div className="va-clinic-grid">
            {D2.clinics.map((c, i) => (
              <div key={c.id} className={`va-clinic-card ${i === 0 ? 'recommended' : ''}`}>
                {i === 0 && <span className="ribbon">EDITOR'S PICK</span>}
                <div>
                  <div className="name">{c.name}</div>
                  <div className="tag" style={{marginTop: 6}}>{c.tagline}</div>
                </div>
                <div className="rating">
                  <span className="stars">★★★★★</span>
                  <span>{c.rating}</span>
                  <span className="n">({c.reviews.toLocaleString()})</span>
                </div>
                <div className="price">
                  <span className="from">FROM</span>
                  <span className="v">${c.price.from}</span>
                  <span className="u">{c.price.unit}</span>
                </div>
                <div className="badges">
                  {c.badges.map(b => <span key={b} className="b-tag">{b}</span>)}
                </div>
                <ul className="pros">
                  {c.pros.map(p => <li key={p}>{p}</li>)}
                </ul>
                <div className="cta-row">
                  <button className="va-btn primary">{c.affiliateLabel} →</button>
                  <button
                    className="va-btn outline"
                    onClick={() => onAddCompare(c.id)}
                    style={{ flex: '0 0 auto', padding: '10px 14px' }}
                    title="Compare"
                  >
                    {comparing.includes(c.id) ? '✓' : '+'}
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}

// ---------- Research section ----------
function Research() {
  const [active, setActive] = React.useState(0);
  const r = D2.research[active];
  return (
    <section className="va-section" id="research" style={{ background: 'var(--paper-2)' }}>
      <div className="container">
        <div className="va-section-head">
          <div className="ttl">
            <span className="eyebrow">The receipts · Peer-reviewed sources</span>
            <h2 style={{ marginTop: 14 }}>The data, <em>not the discourse.</em></h2>
            <p>We pulled every Phase 3 trial we could find. Here's what 4,500 patients and 140 weeks of dosing actually showed.</p>
          </div>
          <div className="actions">
            {D2.research.map((rr, i) => (
              <button key={rr.id} className={`va-btn ${active === i ? 'primary' : 'outline'} sm`} onClick={() => setActive(i)}>
                {rr.compound.split(' ')[0]}
              </button>
            ))}
          </div>
        </div>

        <div className="va-research-grid">
          <div className="va-research-chart">
            <div className="head">
              <div>
                <div className="compound">{r.compound} · n = {r.n.toLocaleString()}</div>
                <div className="headline">
                  <span className="v">{r.headline.split(' ')[0]}</span>{' '}
                  {r.headline.split(' ').slice(1).join(' ')}
                </div>
                <div className="study" style={{ marginTop: 8 }}>{r.study}</div>
              </div>
              <div className="vs">
                <div className="l">vs. placebo</div>
                <div className="v">{r.vsPlacebo}</div>
              </div>
            </div>
            <VA_LineChart series={r.series} placebo={r.placebo} />
            <div className="va-chart-legend">
              <div className="item"><span className="swatch compound"></span>{r.compound}</div>
              <div className="item"><span className="swatch placebo"></span>Placebo</div>
            </div>
          </div>

          <div className="va-research-side">
            <div className="va-research-stat-grid">
              <div className="cell"><div className="v">73%</div><div className="l">of tirzepatide patients lost ≥15% body weight</div></div>
              <div className="cell"><div className="v">−9.4</div><div className="l">avg. systolic BP drop, mmHg</div></div>
              <div className="cell"><div className="v">2.1×</div><div className="l">more weight loss vs. semaglutide head-to-head</div></div>
              <div className="cell"><div className="v">94%</div><div className="l">retention through trial endpoint</div></div>
            </div>
            <div className="va-peptide-table">
              <div className="row head">
                <div>Peptide</div><div>Primary use</div><div>Evidence</div>
              </div>
              {D2.peptideFacts.map(p => (
                <div key={p.compound} className="row">
                  <div className="compound">{p.compound}</div>
                  <div>{p.primary}</div>
                  <div style={{ color: 'var(--ink-3)' }}>{p.evidence}</div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

// ---------- Testimonials ----------
function Testimonials() {
  return (
    <section className="va-section" id="reviews">
      <div className="container">
        <div className="va-section-head">
          <div className="ttl">
            <span className="eyebrow">Long-form reviews · 100% verified</span>
            <h2 style={{ marginTop: 14 }}>Stories, <em>not soundbites.</em></h2>
            <p>We don't run a single review under 200 words. The internet is full of "Worked great. Five stars." — that's not what's happening here.</p>
          </div>
        </div>
        <div className="va-testi-grid">
          {D2.testimonials.map(t => (
            <article key={t.id} className="va-testi-card">
              <div className="head">
                <img className="photo" src={t.photo} alt="" />
                <div className="person">
                  <div className="n">{t.name}, {t.age}</div>
                  <div className="l">{t.location}</div>
                </div>
              </div>
              <div className="stats">
                {t.stats.map(s => (
                  <div key={s.k} className="cell">
                    <div className="v">{s.v}</div>
                    <div className="k">{s.k}</div>
                  </div>
                ))}
              </div>
              <div className="quote">{t.quote}</div>
              <div className="protocol-row">
                <span>{t.protocol}</span>
                {t.verified && <span className="verified">✓ Verified Rx</span>}
              </div>
            </article>
          ))}
        </div>
      </div>
    </section>
  );
}

// ---------- Quiz ----------
function Quiz() {
  const [step, setStep] = React.useState(0);
  const [answers, setAnswers] = React.useState({});
  const total = D2.quiz.length;

  const select = (qid, optId) => {
    const next = { ...answers, [qid]: optId };
    setAnswers(next);
    setTimeout(() => setStep(s => s + 1), 220);
  };

  const recommended = React.useMemo(() => {
    if (step < total) return null;
    const goalQ = D2.quiz[0];
    const chosen = goalQ.options.find(o => o.id === answers.goal);
    const targetCats = chosen ? chosen.maps : ['glp1'];
    const ranked = D2.clinics
      .map(c => ({
        c,
        score: c.categories.filter(x => targetCats.includes(x)).length * 10
             + (answers.budget === 'low' ? -c.price.from / 50 : 0)
             + c.rating,
      }))
      .sort((a, b) => b.score - a.score);
    return ranked[0].c;
  }, [step, answers, total]);

  const reset = () => { setStep(0); setAnswers({}); };

  return (
    <section className="va-section" id="quiz">
      <div className="container">
        <div className="va-quiz">
          <div className="va-quiz-grid">
            <div>
              <span className="eyebrow">Find your match · 60 seconds</span>
              <h2 style={{ marginTop: 14 }}>Three questions.<br/><em>One real recommendation.</em></h2>
              <p className="lede">No email gate. No upsell. Just an honest answer about which clinic fits the goal you actually have.</p>
            </div>

            <div className="va-quiz-card">
              <div className="va-quiz-progress">
                {Array.from({length: total}).map((_, i) => (
                  <div key={i} className={`pip ${i < step ? 'done' : ''} ${i === step ? 'active' : ''}`} />
                ))}
              </div>

              {step < total ? (
                <>
                  <div className="va-quiz-q">Step {step + 1} of {total}</div>
                  <div className="va-quiz-h">{D2.quiz[step].q}</div>
                  <div className="va-quiz-options">
                    {D2.quiz[step].options.map(o => (
                      <button
                        key={o.id}
                        className={`va-quiz-opt ${answers[D2.quiz[step].id] === o.id ? 'selected' : ''}`}
                        onClick={() => select(D2.quiz[step].id, o.id)}
                      >
                        {o.label}
                      </button>
                    ))}
                  </div>
                </>
              ) : (
                <div className="va-quiz-result">
                  <div className="pre">Your match</div>
                  <div className="name">{recommended.name}</div>
                  <div className="why">
                    Best fit for your goal, budget, and timeline. {recommended.tagline}
                  </div>
                  <button className="va-btn clay lg">{recommended.affiliateLabel} →</button>
                  <div style={{ marginTop: 14 }}>
                    <button onClick={reset} style={{background: 'none', border: 'none', cursor: 'pointer', fontSize: 13, color: 'var(--ink-3)', textDecoration: 'underline'}}>Retake the quiz</button>
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

// ---------- Sticky compare cart ----------
function CompareCart({ items, onRemove }) {
  const clinics = items.map(id => D2.clinics.find(c => c.id === id)).filter(Boolean);
  return (
    <div className={`va-cart ${clinics.length > 0 ? 'show' : ''}`}>
      <span className="l">Comparing</span>
      <div className="items">
        {clinics.map(c => (
          <span key={c.id} className="pill">
            {c.name}
            <span className="x" onClick={() => onRemove(c.id)}>×</span>
          </span>
        ))}
      </div>
      <button className="va-btn primary">Compare {clinics.length} →</button>
    </div>
  );
}

// ---------- Footer ----------
function Footer() {
  return (
    <footer className="va-foot">
      <div className="container">
        <div className="va-foot-grid">
          <div>
            <div className="logo">suvlime</div>
            <p className="blurb">Independent reviews of telehealth peptide, GLP-1, and TRT clinics. We test, we order, we verify. We may earn a commission when you sign up — that never affects our rankings.</p>
          </div>
          <div>
            <h4>Categories</h4>
            <ul>
              <li><a>GLP-1s</a></li>
              <li><a>Peptides</a></li>
              <li><a>TRT</a></li>
              <li><a>ED</a></li>
              <li><a>Sleep & recovery</a></li>
            </ul>
          </div>
          <div>
            <h4>Research</h4>
            <ul>
              <li><a>Semaglutide</a></li>
              <li><a>Tirzepatide</a></li>
              <li><a>BPC-157</a></li>
              <li><a>Ipamorelin</a></li>
            </ul>
          </div>
          <div>
            <h4>About</h4>
            <ul>
              <li><a>How we test</a></li>
              <li><a>Editorial standards</a></li>
              <li><a>Affiliate disclosure</a></li>
              <li><a>Contact</a></li>
            </ul>
          </div>
        </div>
        <div className="legal">
          <span>© 2026 Suvlime, Inc.</span>
          <span className="disc">Suvlime is not a medical provider. Information here is for educational purposes only and is not medical advice. Always consult a licensed clinician. Some links are affiliate links — we may earn a commission, at no cost to you.</span>
        </div>
      </div>
    </footer>
  );
}

// ---------- Top bar ----------
function TopBar() {
  return (
    <header className="va-top">
      <div className="container va-top-inner">
        <div className="va-logo"><span className="dot"></span>suvlime</div>
        <nav className="va-nav">
          <a>GLP-1s</a>
          <a>Peptides</a>
          <a>TRT</a>
          <a>ED</a>
          <a>Research</a>
          <a>Reviews</a>
        </nav>
        <div className="va-top-cta">
          <span className="ghost">Sign in</span>
          <button className="va-btn clay">Take the quiz</button>
        </div>
      </div>
    </header>
  );
}

// ---------- Root ----------
function SuvlimeApp() {
  const [filter, setFilter] = React.useState('all');
  const [comparing, setComparing] = React.useState([]);
  const onAddCompare = (id) => {
    setComparing(prev => prev.includes(id) ? prev.filter(x => x !== id) : [...prev, id].slice(-3));
  };
  const onRemove = (id) => setComparing(prev => prev.filter(x => x !== id));

  const scrollToGallery = () => {
    const el = document.getElementById('gallery');
    if (el) window.scrollTo({ top: el.offsetTop - 80, behavior: 'smooth' });
  };

  return (
    <div className="va-root">
      <TopBar />
      <window.VA_Hero onScrollToGallery={scrollToGallery} />
      <window.VA_CategoryStrip active={filter} setActive={setFilter} />
      <window.VA_BeforeAfterGallery filter={filter} />
      <TopClinics onAddCompare={onAddCompare} comparing={comparing} />
      <Research />
      <Testimonials />
      <Quiz />
      <Footer />
      <CompareCart items={comparing} onRemove={onRemove} />
    </div>
  );
}

window.SuvlimeApp = SuvlimeApp;
