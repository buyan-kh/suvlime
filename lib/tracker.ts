"use client";

interface QuizCompletePayload {
  answers: Record<string, string>;
  recommendedClinicSlug?: string | null;
  email?: string | null;
}

async function post(path: string, body: unknown) {
  try {
    await fetch(path, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(body),
      keepalive: true,
    });
  } catch {
    // Tracking failures are silent — they should never affect UX.
  }
}

function utmParams() {
  if (typeof window === "undefined") return {};
  const p = new URLSearchParams(window.location.search);
  return {
    utm_source: p.get("utm_source"),
    utm_medium: p.get("utm_medium"),
    utm_campaign: p.get("utm_campaign"),
    utm_content: p.get("utm_content"),
  };
}

export const track = {
  pageView(path: string) {
    return post("/api/track/page-view", {
      path,
      referrer: typeof document !== "undefined" ? document.referrer || null : null,
      ...utmParams(),
    });
  },
  quizComplete(payload: QuizCompletePayload) {
    return post("/api/track/quiz", payload);
  },
};
