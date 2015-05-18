From: Robert Bragg <robert-St23OQVBDYPNLxjTenLetw@public.gmane.org>
Subject: [RFC PATCH] squash: be more careful stopping oacontrol updates
Date: Mon, 18 May 2015 18:21:46 +0100
Message-ID: <1431969706-32102-1-git-send-email-robert@sixbynine.org>
References: <CAMou1-1QsATpCLMxmzGNTWyTEic4GtihiaRib0GJ55vsLYyaCQ@mail.gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMou1-1QsATpCLMxmzGNTWyTEic4GtihiaRib0GJ55vsLYyaCQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Cc: Daniel Vetter <daniel.vetter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This makes sure we've stopped touching oacontrol before we start
resetting OA, PM and clock gating. Shouldn't strictly be needed since we
know that oacontrol will have been disabled before we start destroying
an event but it seems worth highlighting that update_oacontrol() could
still be running asynchronously and stopping it early in case it might
become an issue in the future.
---
 drivers/gpu/drm/i915/i915_oa_perf.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_oa_perf.c b/drivers/gpu/drm/i915/i915_oa_perf.c
index bf1c1d6..e47ed90 100644
--- a/drivers/gpu/drm/i915/i915_oa_perf.c
+++ b/drivers/gpu/drm/i915/i915_oa_perf.c
@@ -166,12 +166,21 @@ static void i915_oa_event_destroy(struct perf_event *event)
 {
 	struct drm_i915_private *i915 =
 		container_of(event->pmu, typeof(*i915), oa_pmu.pmu);
+	unsigned long lock_flags;
 
 	WARN_ON(event->parent);
 
-	oa_buffer_destroy(i915);
-
+	/* Stop updating oacontrol via _oa_context_pin_[un]notify()... */
+	spin_lock_irqsave(&i915->oa_pmu.lock, lock_flags);
 	i915->oa_pmu.specific_ctx = NULL;
+	spin_unlock_irqrestore(&i915->oa_pmu.lock, lock_flags);
+
+	/* Don't let the compiler start resetting OA, PM and clock gating
+	 * state before we've stopped update_oacontrol()
+	 */
+	barrier();
+
+	oa_buffer_destroy(i915);
 
 	BUG_ON(i915->oa_pmu.exclusive_event != event);
 	i915->oa_pmu.exclusive_event = NULL;
@@ -513,6 +522,11 @@ static int i915_oa_event_init(struct perf_event *event)
 	return 0;
 }
 
+/* Note: Although pmu methods are called with the corresponding
+ * perf_event_context lock taken (so we don't need to worry about our pmu
+ * methods contending with each other) update_oacontrol() may be called
+ * asynchronously via the i915_oa_pmu_[un]register() hooks.
+ */
 static void update_oacontrol(struct drm_i915_private *dev_priv)
 {
 	BUG_ON(!spin_is_locked(&dev_priv->oa_pmu.lock));
-- 
2.4.1
