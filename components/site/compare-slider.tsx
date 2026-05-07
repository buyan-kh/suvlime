"use client";

import { useCallback, useEffect, useRef, useState } from "react";

interface CompareSliderProps {
  before: string;
  after: string;
  initial?: number;
}

export function CompareSlider({ before, after, initial = 50 }: CompareSliderProps) {
  const [pos, setPos] = useState(initial);
  const wrapRef = useRef<HTMLDivElement>(null);
  const draggingRef = useRef(false);

  const updateFromClientX = useCallback((clientX: number) => {
    const el = wrapRef.current;
    if (!el) return;
    const rect = el.getBoundingClientRect();
    const x = clientX - rect.left;
    const p = Math.max(0, Math.min(100, (x / rect.width) * 100));
    setPos(p);
  }, []);

  useEffect(() => {
    const onMove = (e: MouseEvent | TouchEvent) => {
      if (!draggingRef.current) return;
      const cx = "touches" in e ? e.touches[0].clientX : e.clientX;
      updateFromClientX(cx);
    };
    const onUp = () => { draggingRef.current = false; };
    window.addEventListener("mousemove", onMove);
    window.addEventListener("mouseup", onUp);
    window.addEventListener("touchmove", onMove, { passive: true });
    window.addEventListener("touchend", onUp);
    return () => {
      window.removeEventListener("mousemove", onMove);
      window.removeEventListener("mouseup", onUp);
      window.removeEventListener("touchmove", onMove);
      window.removeEventListener("touchend", onUp);
    };
  }, [updateFromClientX]);

  const onDown = (e: React.MouseEvent | React.TouchEvent) => {
    draggingRef.current = true;
    const cx = "touches" in e ? e.touches[0].clientX : e.clientX;
    updateFromClientX(cx);
  };

  return (
    <div className="va-compare-wrap" ref={wrapRef} onMouseDown={onDown} onTouchStart={onDown}>
      {/* eslint-disable-next-line @next/next/no-img-element */}
      <img className="va-compare-img after" src={after} alt="after" draggable={false} />
      {/* eslint-disable-next-line @next/next/no-img-element */}
      <img
        className="va-compare-img before"
        src={before}
        alt="before"
        draggable={false}
        style={{ clipPath: `inset(0 ${100 - pos}% 0 0)` }}
      />
      <span className="va-compare-tag before-tag" style={{ opacity: pos > 12 ? 1 : 0 }}>BEFORE</span>
      <span className="va-compare-tag after-tag" style={{ opacity: pos < 88 ? 1 : 0 }}>AFTER</span>
      <div className="va-compare-handle" style={{ left: pos + "%" }} />
    </div>
  );
}
