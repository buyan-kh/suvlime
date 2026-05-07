import { cookies } from "next/headers";
import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";

const ANON_COOKIE = "suv_anon_id";

interface Payload {
  answers?: Record<string, string>;
  recommendedClinicSlug?: string | null;
  email?: string | null;
}

export async function POST(req: Request) {
  const body = (await req.json().catch(() => ({}))) as Payload;
  if (!body.answers || typeof body.answers !== "object") {
    return NextResponse.json({ ok: false }, { status: 400 });
  }

  const cookieStore = await cookies();
  const anonId = cookieStore.get(ANON_COOKIE)?.value ?? null;
  const supabase = createAdminClient();

  let clinicId: string | null = null;
  if (body.recommendedClinicSlug) {
    const { data } = await supabase
      .from("clinics")
      .select("id")
      .eq("slug", body.recommendedClinicSlug)
      .maybeSingle();
    clinicId = data?.id ?? null;
  }

  await supabase.from("quiz_responses").insert({
    answers: body.answers,
    recommended_clinic_id: clinicId,
    email: body.email ?? null,
    anon_user_id: anonId,
  });

  return NextResponse.json({ ok: true });
}
