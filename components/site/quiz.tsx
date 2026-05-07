"use client";

import { useMemo, useState } from "react";
import { clinics, quiz, type QuizStep } from "@/lib/data";

type AnswerMap = Partial<Record<QuizStep["id"], string>>;

export function Quiz() {
  const total = quiz.length;
  const [step, setStep] = useState(0);
  const [answers, setAnswers] = useState<AnswerMap>({});

  const select = (qid: QuizStep["id"], optId: string) => {
    setAnswers((prev) => ({ ...prev, [qid]: optId }));
    setTimeout(() => setStep((s) => s + 1), 220);
  };

  const recommended = useMemo(() => {
    if (step < total) return null;
    const goalQ = quiz[0];
    const chosen = goalQ.options.find((o) => o.id === answers.goal);
    const targetCats = chosen?.maps ?? ["glp1"];
    const ranked = clinics
      .map((c) => ({
        c,
        score:
          c.categories.filter((x) => targetCats.includes(x)).length * 10 +
          (answers.budget === "low" ? -c.price.from / 50 : 0) +
          c.rating,
      }))
      .sort((a, b) => b.score - a.score);
    return ranked[0].c;
  }, [step, answers, total]);

  const reset = () => {
    setStep(0);
    setAnswers({});
  };

  return (
    <section className="va-section" id="quiz">
      <div className="container">
        <div className="va-quiz">
          <div className="va-quiz-grid">
            <div>
              <span className="eyebrow">Find your match · 60 seconds</span>
              <h2 style={{ marginTop: 14 }}>
                Three questions.<br /><em>One real recommendation.</em>
              </h2>
              <p className="lede">No email gate. No upsell. Just an honest answer about which clinic fits the goal you actually have.</p>
            </div>

            <div className="va-quiz-card">
              <div className="va-quiz-progress">
                {Array.from({ length: total }).map((_, i) => (
                  <div key={i} className={`pip ${i < step ? "done" : ""} ${i === step ? "active" : ""}`} />
                ))}
              </div>

              {step < total ? (
                <>
                  <div className="va-quiz-q">Step {step + 1} of {total}</div>
                  <div className="va-quiz-h">{quiz[step].q}</div>
                  <div className="va-quiz-options">
                    {quiz[step].options.map((o) => (
                      <button
                        key={o.id}
                        className={`va-quiz-opt ${answers[quiz[step].id] === o.id ? "selected" : ""}`}
                        onClick={() => select(quiz[step].id, o.id)}
                      >
                        {o.label}
                      </button>
                    ))}
                  </div>
                </>
              ) : (
                recommended && (
                  <div className="va-quiz-result">
                    <div className="pre">Your match</div>
                    <div className="name">{recommended.name}</div>
                    <div className="why">Best fit for your goal, budget, and timeline. {recommended.tagline}</div>
                    <button className="va-btn clay lg">{recommended.affiliateLabel} →</button>
                    <div style={{ marginTop: 14 }}>
                      <button
                        onClick={reset}
                        style={{
                          background: "none",
                          border: "none",
                          cursor: "pointer",
                          fontSize: 13,
                          color: "var(--ink-3)",
                          textDecoration: "underline",
                        }}
                      >
                        Retake the quiz
                      </button>
                    </div>
                  </div>
                )
              )}
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
