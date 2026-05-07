"use client";

import { useState } from "react";
import { peptideFacts, research } from "@/lib/data";
import { LineChart } from "./line-chart";

export function ResearchSection() {
  const [active, setActive] = useState(0);
  const r = research[active];
  const [headlineFirst, ...rest] = r.headline.split(" ");

  return (
    <section className="va-section" id="research" style={{ background: "var(--paper-2)" }}>
      <div className="container">
        <div className="va-section-head">
          <div className="ttl">
            <span className="eyebrow">The receipts · Peer-reviewed sources</span>
            <h2 style={{ marginTop: 14 }}>
              The data, <em>not the discourse.</em>
            </h2>
            <p>We pulled every Phase 3 trial we could find. Here&rsquo;s what 4,500 patients and 140 weeks of dosing actually showed.</p>
          </div>
          <div className="actions">
            {research.map((rr, i) => (
              <button
                key={rr.id}
                className={`va-btn ${active === i ? "primary" : "outline"} sm`}
                onClick={() => setActive(i)}
              >
                {rr.compound.split(" ")[0]}
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
                  <span className="v">{headlineFirst}</span> {rest.join(" ")}
                </div>
                <div className="study" style={{ marginTop: 8 }}>{r.study}</div>
              </div>
              <div className="vs">
                <div className="l">vs. placebo</div>
                <div className="v">{r.vsPlacebo}</div>
              </div>
            </div>
            <LineChart series={r.series} placebo={r.placebo} />
            <div className="va-chart-legend">
              <div className="item"><span className="swatch compound" />{r.compound}</div>
              <div className="item"><span className="swatch placebo" />Placebo</div>
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
              {peptideFacts.map((p) => (
                <div key={p.compound} className="row">
                  <div className="compound">{p.compound}</div>
                  <div>{p.primary}</div>
                  <div style={{ color: "var(--ink-3)" }}>{p.evidence}</div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
