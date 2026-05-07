import Image from "next/image";

export function Hero() {
  return (
    <section className="va-hero">
      <div className="container">
        <div className="va-hero-grid">
          <div>
            <span className="eyebrow">Independently reviewed · Updated Apr 2026</span>
            <h1 style={{ marginTop: 18 }}>
              The peptide era,<br />
              <em>without the bro science.</em>
            </h1>
            <p className="va-hero-lede">
              We test, vet, and rank the telehealth clinics prescribing GLP-1s, peptides, TRT, and ED meds — so you don&rsquo;t have to read another Reddit thread at 2am.
            </p>
            <div className="va-hero-cta-row">
              <a className="va-btn primary lg" href="#gallery">See real results</a>
              <a className="va-btn outline lg" href="#quiz">Take the 60-second quiz</a>
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
            <Image
              src="https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=900&q=80"
              alt=""
              fill
              sizes="(min-width: 1024px) 50vw, 100vw"
              style={{ objectFit: "cover" }}
              priority
            />
            <div className="badge"><span className="pulse" />Live tracking · 41 protocols</div>
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
