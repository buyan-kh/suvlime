import { createClient } from "@supabase/supabase-js";

// Service-role client. Bypasses RLS. Server-only (route handlers, server actions).
// Never import this into a Client Component.
export function createAdminClient() {
  return createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.SUPABASE_SECRET_KEY!,
    {
      auth: { persistSession: false, autoRefreshToken: false },
    },
  );
}
