import { ClinicsSection } from "@/components/site/clinics-section";
import { Footer } from "@/components/site/footer";
import { GallerySection } from "@/components/site/gallery-section";
import { Hero } from "@/components/site/hero";
import { Quiz } from "@/components/site/quiz";
import { ResearchSection } from "@/components/site/research-section";
import { Testimonials } from "@/components/site/testimonials";
import { TopBar } from "@/components/site/topbar";

export default function Home() {
  return (
    <div className="va-root">
      <TopBar />
      <Hero />
      <GallerySection />
      <ClinicsSection />
      <ResearchSection />
      <Testimonials />
      <Quiz />
      <Footer />
    </div>
  );
}
