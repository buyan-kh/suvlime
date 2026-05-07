export function deviceFromUserAgent(ua: string | null): string {
  if (!ua) return "unknown";
  const lower = ua.toLowerCase();
  if (/ipad|tablet|kindle/.test(lower)) return "tablet";
  if (/mobi|iphone|ipod|android.*mobile|blackberry|opera mini/.test(lower)) return "mobile";
  return "desktop";
}
