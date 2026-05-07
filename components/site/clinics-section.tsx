"use client";

import { useState } from "react";
import { clinics } from "@/lib/data";

export function ClinicsSection() {
  const [comparing, setComparing] = useState<string[]>([]);

  const toggle = (id: string) =>
    setComparing((prev) =>
      prev.includes(id) ? prev.filter((x) => x !== id) : [...prev, id].slice(-3),
    );
  const remove = (id: string) =>
    setComparing((prev) => prev.filter((x) => x !== id));

  const cartClinics = comparing.map((id) => clinics.find((c) => c.id === id)!).filter(Boolean);

  return (
    <>
      <section className="va-section" id="clinics" style={{ padding: 0, margin: 0 }}>
        <div className="va-clinics">
          <div className="container">
            <div className="va-section-head">
              <div className="ttl">
                <span className="eyebrow" style={{ color: "rgba(250,247,241,0.5)" }}>The shortlist · Updated weekly</span>
                <h2 style={{ marginTop: 14 }}>
                  Top telehealth clinics<br /><em>worth your script.</em>
                </h2>
                <p>Twelve clinics tested over six months. We ordered, evaluated, and audited every one. These four made the cut.</p>
              </div>
              <button className="va-btn outline sm" style={{ color: "var(--bone)", borderColor: "rgba(250,247,241,0.2)" }}>
                See all 12 ranked →
              </button>
            </div>

            <div className="va-clinic-grid">
              {clinics.map((c, i) => (
                <div key={c.id} className={`va-clinic-card ${i === 0 ? "recommended" : ""}`}>
                  {i === 0 && <span className="ribbon">EDITOR&rsquo;S PICK</span>}
                  <div>
                    <div className="name">{c.name}</div>
                    <div className="tag" style={{ marginTop: 6 }}>{c.tagline}</div>
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
                    {c.badges.map((b) => <span key={b} className="b-tag">{b}</span>)}
                  </div>
                  <ul className="pros">
                    {c.pros.map((p) => <li key={p}>{p}</li>)}
                  </ul>
                  <div className="cta-row">
                    <button className="va-btn primary">{c.affiliateLabel} →</button>
                    <button
                      className="va-btn outline"
                      onClick={() => toggle(c.id)}
                      style={{ flex: "0 0 auto", padding: "10px 14px" }}
                      aria-label="Compare"
                    >
                      {comparing.includes(c.id) ? "✓" : "+"}
                    </button>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>

      <div className={`va-cart ${cartClinics.length > 0 ? "show" : ""}`}>
        <span className="l">Comparing</span>
        <div className="items">
          {cartClinics.map((c) => (
            <span key={c.id} className="pill">
              {c.name}
              <span className="x" onClick={() => remove(c.id)}>×</span>
            </span>
          ))}
        </div>
        <button className="va-btn primary">Compare {cartClinics.length} →</button>
      </div>
    </>
  );
}
