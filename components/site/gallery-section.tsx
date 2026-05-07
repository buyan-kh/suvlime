"use client";

import { useMemo, useState } from "react";
import { beforeAfters, categories, type CategoryId } from "@/lib/data";
import { CompareSlider } from "./compare-slider";

type Filter = "all" | CategoryId;

export function GallerySection() {
  const [filter, setFilter] = useState<Filter>("all");

  const counts = useMemo(() => {
    const m: Record<string, number> = { all: beforeAfters.length };
    categories.forEach((c) => {
      m[c.id] = beforeAfters.filter((b) => b.category === c.id).length;
    });
    return m;
  }, []);

  const items = filter === "all" ? beforeAfters : beforeAfters.filter((b) => b.category === filter);
  const layout = ["feat", "std", "wide", "wide", "std", "std", "std", "std"] as const;

  return (
    <>
      <div className="va-cats">
        <div className="container va-cats-inner">
          <span className="label">Filter by category</span>
          <button
            className={`va-chip ${filter === "all" ? "active" : ""}`}
            onClick={() => setFilter("all")}
          >
            All <span className="n">{counts.all}</span>
          </button>
          {categories.map((c) => (
            <button
              key={c.id}
              className={`va-chip ${filter === c.id ? "active" : ""}`}
              onClick={() => setFilter(c.id)}
            >
              {c.label} <span className="n">{counts[c.id] ?? 0}</span>
            </button>
          ))}
        </div>
      </div>

      <section className="va-section" id="gallery">
        <div className="container">
          <div className="va-section-head">
            <div className="ttl">
              <span className="eyebrow">The gallery · 12 / 16-week protocols</span>
              <h2 style={{ marginTop: 14 }}>
                Real people, <em>real protocols,</em>
                <br />
                real timelines.
              </h2>
              <p>Drag the slider on any photo to compare. Every story is paired with the protocol used and the clinic that prescribed it. Verified means we&rsquo;ve seen the prescription paperwork.</p>
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
                    <div className="quote">&ldquo;{b.caption}&rdquo;</div>
                    <div className="footer">
                      <span>via <strong style={{ color: "var(--ink-2)" }}>{b.clinic}</strong></span>
                      {b.verified && <span className="verified">✓ Verified</span>}
                    </div>
                  </div>
                </article>
              );
            })}
          </div>
        </div>
      </section>
    </>
  );
}
