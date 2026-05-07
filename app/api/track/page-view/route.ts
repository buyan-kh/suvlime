import { cookies, headers } from "next/headers";
import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { deviceFromUserAgent } from "@/lib/device";

const ANON_COOKIE = "suv_anon_id";

interface Payload {
  path?: string;
  referrer?: string | null;
  utm_source?: string | null;
  utm_medium?: string | null;
  utm_campaign?: string | null;
  utm_content?: string | null;
}

export async function POST(req: Request) {
  const body = (await req.json().catch(() => ({}))) as Payload;
  if (!body.path) return NextResponse.json({ ok: false }, { status: 400 });

  const cookieStore = await cookies();
  const headerStore = await headers();
  const anonId = cookieStore.get(ANON_COOKIE)?.value ?? crypto.randomUUID();
  const ua = headerStore.get("user-agent");
  const country = headerStore.get("x-vercel-ip-country");

  const supabase = createAdminClient();
  await supabase.from("page_views").insert({
    path: body.path,
    referrer: body.referrer ?? null,
    utm_source: body.utm_source ?? null,
    utm_medium: body.utm_medium ?? null,
    utm_campaign: body.utm_campaign ?? null,
    utm_content: body.utm_content ?? null,
    anon_user_id: anonId,
    user_agent: ua,
    country,
    device: deviceFromUserAgent(ua),
  });

  return NextResponse.json({ ok: true });
}
