From: Robert Bragg <robert-St23OQVBDYPNLxjTenLetw@public.gmane.org>
Subject: [RFC 5/6] drm/i915: Add dev.i915.perf_event_paranoid sysctl option
Date: Tue, 29 Sep 2015 15:39:08 +0100
Message-ID: <1443537549-6905-6-git-send-email-robert@sixbynine.org>
References: <1443537549-6905-1-git-send-email-robert@sixbynine.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443537549-6905-1-git-send-email-robert-St23OQVBDYPNLxjTenLetw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Cc: Daniel Vetter <daniel.vetter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, Sourab Gupta <sourab.gupta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Zhenyu Wang <zhenyuw-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kan Liang <kan.liang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Zheng Yan <zheng.z.yan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Consistent with the kernel.perf_event_paranoid sysctl option that can
allow non-root users to access system wide cpu metrics, this can
optionally allow non-root users to access system wide OA counter metrics
from Gen graphics hardware.

Signed-off-by: Robert Bragg <robert-St23OQVBDYPNLxjTenLetw@public.gmane.org>
---
 drivers/gpu/drm/i915/i915_perf.c | 46 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
index bc1c4d1..ab82857 100644
--- a/drivers/gpu/drm/i915/i915_perf.c
+++ b/drivers/gpu/drm/i915/i915_perf.c
@@ -38,6 +38,8 @@
 #define POLL_FREQUENCY 200
 #define POLL_PERIOD max_t(u64, 10000, NSEC_PER_SEC / POLL_FREQUENCY)
 
+static u32 i915_perf_event_paranoid = true;
+
 #define OA_EXPONENT_MAX 0x3f
 
 static struct i915_oa_format hsw_oa_formats[I915_OA_FORMAT_MAX] = {
@@ -1016,7 +1018,13 @@ int i915_perf_open_ioctl_locked(struct drm_device *dev, void *data,
 		}
 	}
 
-	if (!specific_ctx && !capable(CAP_SYS_ADMIN)) {
+	/* Similar to perf's kernel.perf_paranoid_cpu sysctl option
+	 * we check a dev.i915.perf_event_paranoid sysctl option
+	 * to determine if it's ok to access system wide OA counters
+	 * without CAP_SYS_ADMIN privileges.
+	 */
+	if (!specific_ctx &&
+	    i915_perf_event_paranoid && !capable(CAP_SYS_ADMIN)) {
 		DRM_ERROR("Insufficient privileges to open perf event\n");
 		ret = -EACCES;
 		goto err_ctx;
@@ -1096,6 +1104,38 @@ int i915_perf_open_ioctl(struct drm_device *dev, void *data,
 	return ret;
 }
 
+
+static struct ctl_table oa_table[] = {
+	{
+	 .procname = "perf_event_paranoid",
+	 .data = &i915_perf_event_paranoid,
+	 .maxlen = sizeof(i915_perf_event_paranoid),
+	 .mode = 0644,
+	 .proc_handler = proc_dointvec,
+	 },
+	{}
+};
+
+static struct ctl_table i915_root[] = {
+	{
+	 .procname = "i915",
+	 .maxlen = 0,
+	 .mode = 0555,
+	 .child = oa_table,
+	 },
+	{}
+};
+
+static struct ctl_table dev_root[] = {
+	{
+	 .procname = "dev",
+	 .maxlen = 0,
+	 .mode = 0555,
+	 .child = i915_root,
+	 },
+	{}
+};
+
 void i915_perf_init(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = to_i915(dev);
@@ -1103,6 +1143,8 @@ void i915_perf_init(struct drm_device *dev)
 	if (!IS_HASWELL(dev))
 		return;
 
+	dev_priv->perf.sysctl_header = register_sysctl_table(dev_root);
+
 	hrtimer_init(&dev_priv->perf.oa.poll_check_timer,
 		     CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	dev_priv->perf.oa.poll_check_timer.function = poll_check_timer_cb;
@@ -1132,6 +1174,8 @@ void i915_perf_fini(struct drm_device *dev)
 	if (!dev_priv->perf.initialized)
 		return;
 
+	unregister_sysctl_table(dev_priv->perf.sysctl_header);
+
 	dev_priv->perf.oa.ops.init_oa_buffer = NULL;
 
 	dev_priv->perf.initialized = false;
-- 
2.5.2
