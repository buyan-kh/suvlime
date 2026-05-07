import Image from "next/image";
import { testimonials } from "@/lib/data";

export function Testimonials() {
  return (
    <section className="va-section" id="reviews">
      <div className="container">
        <div className="va-section-head">
          <div className="ttl">
            <span className="eyebrow">Long-form reviews · 100% verified</span>
            <h2 style={{ marginTop: 14 }}>
              Stories, <em>not soundbites.</em>
            </h2>
            <p>We don&rsquo;t run a single review under 200 words. The internet is full of &ldquo;Worked great. Five stars.&rdquo; — that&rsquo;s not what&rsquo;s happening here.</p>
          </div>
        </div>
        <div className="va-testi-grid">
          {testimonials.map((p) => (
            <article key={p.id} className="va-testi-card">
              <div className="head">
                <Image
                  className="photo"
                  src={p.photo}
                  alt=""
                  width={56}
                  height={56}
                />
                <div className="person">
                  <div className="n">{p.name}, {p.age}</div>
                  <div className="l">{p.location}</div>
                </div>
              </div>
              <div className="stats">
                {p.stats.map((s) => (
                  <div key={s.k} className="cell">
                    <div className="v">{s.v}</div>
                    <div className="k">{s.k}</div>
                  </div>
                ))}
              </div>
              <div className="quote">{p.quote}</div>
              <div className="protocol-row">
                <span>{p.protocol}</span>
                {p.verified && <span className="verified">✓ Verified Rx</span>}
              </div>
            </article>
          ))}
        </div>
      </div>
    </section>
  );
}
