"use client";

import { useEffect } from "react";
import { usePathname } from "next/navigation";
import { track } from "@/lib/tracker";

export function PageViewTracker() {
  const pathname = usePathname();
  useEffect(() => {
    track.pageView(pathname);
  }, [pathname]);
  return null;
}
