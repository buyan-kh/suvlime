export function TopBar() {
  return (
    <header className="va-top">
      <div className="container va-top-inner">
        <div className="va-logo"><span className="dot" />suvlime</div>
        <nav className="va-nav">
          <a>GLP-1s</a>
          <a>Peptides</a>
          <a>TRT</a>
          <a>ED</a>
          <a>Research</a>
          <a>Reviews</a>
        </nav>
        <div className="va-top-cta">
          <span className="ghost">Sign in</span>
          <button className="va-btn clay">Take the quiz</button>
        </div>
      </div>
    </header>
  );
}
