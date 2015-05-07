From: Robert Bragg <robert-St23OQVBDYPNLxjTenLetw@public.gmane.org>
Subject: [RFC PATCH 01/11] perf: export perf_event_overflow
Date: Thu,  7 May 2015 15:15:44 +0100
Message-ID: <1431008154-6833-2-git-send-email-robert@sixbynine.org>
References: <1431008154-6833-1-git-send-email-robert@sixbynine.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431008154-6833-1-git-send-email-robert-St23OQVBDYPNLxjTenLetw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Cc: Daniel Vetter <daniel.vetter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

To support pmu drivers in loadable modules, such as the i915 driver

Signed-off-by: Robert Bragg <robert-St23OQVBDYPNLxjTenLetw@public.gmane.org>
---
 kernel/events/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2fabc06..38c240c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5851,6 +5851,7 @@ int perf_event_overflow(struct perf_event *event,
 {
 	return __perf_event_overflow(event, 1, data, regs);
 }
+EXPORT_SYMBOL_GPL(perf_event_overflow);
 
 /*
  * Generic software event infrastructure
-- 
2.3.2
