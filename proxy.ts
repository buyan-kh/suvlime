import { NextResponse, type NextRequest } from "next/server";
import { updateSession } from "@/lib/supabase/middleware";

const ANON_COOKIE = "suv_anon_id";
const ANON_TTL_SECONDS = 60 * 60 * 24 * 365; // 1 year

export async function middleware(request: NextRequest) {
  const response = await updateSession(request);

  // Ensure first-party anon_user_id cookie exists.
  if (!request.cookies.get(ANON_COOKIE)) {
    response.cookies.set(ANON_COOKIE, crypto.randomUUID(), {
      httpOnly: false, // readable from browser tracker if we ever need it
      sameSite: "lax",
      secure: process.env.NODE_ENV === "production",
      maxAge: ANON_TTL_SECONDS,
      path: "/",
    });
  }

  return response;
}

export const config = {
  matcher: "/((?!api|_next|_vercel|.*\\..*).*)",
};
