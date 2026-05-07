/* global React */
const { useState, useRef, useEffect, useCallback } = React;

function CompareSlider({ before, after, beforeLabel = "BEFORE", afterLabel = "AFTER", initial = 50 }) {
  const [pos, setPos] = useState(initial);
  const wrapRef = useRef(null);
  const draggingRef = useRef(false);

  const updateFromClientX = useCallback((clientX) => {
    const el = wrapRef.current;
    if (!el) return;
    const rect = el.getBoundingClientRect();
    const x = clientX - rect.left;
    const p = Math.max(0, Math.min(100, (x / rect.width) * 100));
    setPos(p);
  }, []);

  useEffect(() => {
    const onMove = (e) => {
      if (!draggingRef.current) return;
      const cx = e.touches ? e.touches[0].clientX : e.clientX;
      updateFromClientX(cx);
    };
    const onUp = () => { draggingRef.current = false; };
    window.addEventListener('mousemove', onMove);
    window.addEventListener('mouseup', onUp);
    window.addEventListener('touchmove', onMove, { passive: true });
    window.addEventListener('touchend', onUp);
    return () => {
      window.removeEventListener('mousemove', onMove);
      window.removeEventListener('mouseup', onUp);
      window.removeEventListener('touchmove', onMove);
      window.removeEventListener('touchend', onUp);
    };
  }, [updateFromClientX]);

  const onDown = (e) => {
    draggingRef.current = true;
    const cx = e.touches ? e.touches[0].clientX : e.clientX;
    updateFromClientX(cx);
  };

  // After image is full-bleed; before image is clipped to the left of the handle.
  return (
    <div className="va-compare-wrap" ref={wrapRef} onMouseDown={onDown} onTouchStart={onDown}>
      <img className="va-compare-img after" src={after} alt="after" draggable={false} />
      <img
        className="va-compare-img before"
        src={before}
        alt="before"
        draggable={false}
        style={{ clipPath: `inset(0 ${100 - pos}% 0 0)` }}
      />
      <span className="va-compare-tag before-tag" style={{ opacity: pos > 12 ? 1 : 0 }}>{beforeLabel}</span>
      <span className="va-compare-tag after-tag" style={{ opacity: pos < 88 ? 1 : 0 }}>{afterLabel}</span>
      <div className="va-compare-handle" style={{ left: pos + '%' }} />
    </div>
  );
}

window.CompareSlider = CompareSlider;
