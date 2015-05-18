From: Robert Bragg <robert-St23OQVBDYPNLxjTenLetw@public.gmane.org>
Subject: [RFC PATCH v2] drm/i915: Expose PMU for Observation Architecture
Date: Mon, 18 May 2015 18:17:18 +0100
Message-ID: <1431969438-31959-1-git-send-email-robert@sixbynine.org>
References: <CAMou1-1QsATpCLMxmzGNTWyTEic4GtihiaRib0GJ55vsLYyaCQ@mail.gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMou1-1QsATpCLMxmzGNTWyTEic4GtihiaRib0GJ55vsLYyaCQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Cc: Daniel Vetter <daniel.vetter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Gen graphics hardware can be set up to periodically write snapshots of
performance counters into a circular buffer and this patch exposes that
capability to userspace via the perf interface.

To start with this only enables the A (aggregating) counters with the
simplest configuration requirements.

Only Haswell is supported currently.

v2:
- fix deadlock in init_oa_buffer error path
- EBADF for bad drm fd, EINVAL for failure to lookup ctx
- mmio write barriers, after OA reconfigure, before unlocks
- use i915_mutex_lock_interruptible within event init

Signed-off-by: Robert Bragg <robert-St23OQVBDYPNLxjTenLetw@public.gmane.org>
---
 drivers/gpu/drm/i915/Makefile           |   1 +
 drivers/gpu/drm/i915/i915_dma.c         |   6 +
 drivers/gpu/drm/i915/i915_drv.h         |  53 +++
 drivers/gpu/drm/i915/i915_gem_context.c |  45 +-
 drivers/gpu/drm/i915/i915_oa_perf.c     | 762 ++++++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/i915_reg.h         |  68 +++
 include/uapi/drm/i915_drm.h             |  29 ++
 7 files changed, 954 insertions(+), 10 deletions(-)
 create mode 100644 drivers/gpu/drm/i915/i915_oa_perf.c

diff --git a/drivers/gpu/drm/i915/Makefile b/drivers/gpu/drm/i915/Makefile
index b7ddf48..b5ebfbe 100644
--- a/drivers/gpu/drm/i915/Makefile
+++ b/drivers/gpu/drm/i915/Makefile
@@ -15,6 +15,7 @@ i915-y := i915_drv.o \
 
 i915-$(CONFIG_COMPAT)   += i915_ioc32.o
 i915-$(CONFIG_DEBUG_FS) += i915_debugfs.o
+i915-$(CONFIG_PERF_EVENTS) += i915_oa_perf.o
 
 # GEM code
 i915-y += i915_cmd_parser.o \
diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index a238889..c299e18 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -818,6 +818,11 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 	mutex_init(&dev_priv->modeset_restore_lock);
 	mutex_init(&dev_priv->csr_lock);
 
+	/* Must at least be registered before trying to pin any context
+	 * otherwise i915_oa_context_pin_notify() will lock an un-initialized
+	 * spinlock, upsetting lockdep checks */
+	i915_oa_pmu_register(dev);
+
 	intel_pm_setup(dev);
 
 	intel_display_crc_init(dev);
@@ -1067,6 +1072,7 @@ int i915_driver_unload(struct drm_device *dev)
 		return ret;
 	}
 
+	i915_oa_pmu_unregister(dev);
 	intel_power_domains_fini(dev_priv);
 
 	intel_gpu_ips_teardown();
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 6a66d6b..dd475ca 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -49,6 +49,7 @@
 #include <linux/hashtable.h>
 #include <linux/intel-iommu.h>
 #include <linux/kref.h>
+#include <linux/perf_event.h>
 #include <linux/pm_qos.h>
 
 /* General customization:
@@ -1839,6 +1840,35 @@ struct drm_i915_private {
 	 */
 	struct workqueue_struct *dp_wq;
 
+#ifdef CONFIG_PERF_EVENTS
+	struct {
+		struct pmu pmu;
+		spinlock_t lock;
+		struct hrtimer timer;
+		struct pt_regs dummy_regs;
+
+		struct perf_event *exclusive_event;
+		struct intel_context *specific_ctx;
+		bool event_active;
+
+		bool periodic;
+		u32 period_exponent;
+
+		u32 metrics_set;
+
+		struct {
+			struct drm_i915_gem_object *obj;
+			u32 gtt_offset;
+			u8 *addr;
+			u32 head;
+			u32 tail;
+			int format;
+			int format_size;
+			spinlock_t flush_lock;
+		} oa_buffer;
+	} oa_pmu;
+#endif
+
 	/* Abstract the submission mechanism (legacy ringbuffer or execlists) away */
 	struct {
 		int (*execbuf_submit)(struct drm_device *dev, struct drm_file *file,
@@ -3012,6 +3042,20 @@ int i915_gem_context_getparam_ioctl(struct drm_device *dev, void *data,
 int i915_gem_context_setparam_ioctl(struct drm_device *dev, void *data,
 				    struct drm_file *file_priv);
 
+#ifdef CONFIG_PERF_EVENTS
+void i915_oa_context_pin_notify(struct drm_i915_private *dev_priv,
+				struct intel_context *context);
+void i915_oa_context_unpin_notify(struct drm_i915_private *dev_priv,
+				  struct intel_context *context);
+#else
+static inline void
+i915_oa_context_pin_notify(struct drm_i915_private *dev_priv,
+			   struct intel_context *context) {}
+static inline void
+i915_oa_context_unpin_notify(struct drm_i915_private *dev_priv,
+			     struct intel_context *context) {}
+#endif
+
 /* i915_gem_evict.c */
 int __must_check i915_gem_evict_something(struct drm_device *dev,
 					  struct i915_address_space *vm,
@@ -3121,6 +3165,15 @@ int i915_parse_cmds(struct intel_engine_cs *ring,
 		    u32 batch_len,
 		    bool is_master);
 
+/* i915_oa_perf.c */
+#ifdef CONFIG_PERF_EVENTS
+extern void i915_oa_pmu_register(struct drm_device *dev);
+extern void i915_oa_pmu_unregister(struct drm_device *dev);
+#else
+static inline void i915_oa_pmu_register(struct drm_device *dev) {}
+static inline void i915_oa_pmu_unregister(struct drm_device *dev) {}
+#endif
+
 /* i915_suspend.c */
 extern int i915_save_state(struct drm_device *dev);
 extern int i915_restore_state(struct drm_device *dev);
diff --git a/drivers/gpu/drm/i915/i915_gem_context.c b/drivers/gpu/drm/i915/i915_gem_context.c
index 5a47eb5..3e9a7f5 100644
--- a/drivers/gpu/drm/i915/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/i915_gem_context.c
@@ -133,6 +133,33 @@ static int get_context_size(struct drm_device *dev)
 	return ret;
 }
 
+static int i915_gem_context_pin_state(struct drm_device *dev,
+				      struct intel_context *ctx)
+{
+	int ret;
+
+	BUG_ON(!mutex_is_locked(&dev->struct_mutex));
+
+	ret = i915_gem_obj_ggtt_pin(ctx->legacy_hw_ctx.rcs_state,
+				    get_context_alignment(dev), 0);
+	if (ret)
+		return ret;
+
+	i915_oa_context_pin_notify(dev->dev_private, ctx);
+
+	return 0;
+}
+
+static void i915_gem_context_unpin_state(struct drm_device *dev,
+					 struct intel_context *ctx)
+{
+	/* Ensure that we stop the OA unit referencing the context *before*
+	 * actually unpinning the ctx */
+	i915_oa_context_unpin_notify(dev->dev_private, ctx);
+
+	i915_gem_object_ggtt_unpin(ctx->legacy_hw_ctx.rcs_state);
+}
+
 void i915_gem_context_free(struct kref *ctx_ref)
 {
 	struct intel_context *ctx = container_of(ctx_ref,
@@ -260,8 +287,7 @@ i915_gem_create_context(struct drm_device *dev,
 		 * be available. To avoid this we always pin the default
 		 * context.
 		 */
-		ret = i915_gem_obj_ggtt_pin(ctx->legacy_hw_ctx.rcs_state,
-					    get_context_alignment(dev), 0);
+		ret = i915_gem_context_pin_state(dev, ctx);
 		if (ret) {
 			DRM_DEBUG_DRIVER("Couldn't pin %d\n", ret);
 			goto err_destroy;
@@ -287,7 +313,7 @@ i915_gem_create_context(struct drm_device *dev,
 
 err_unpin:
 	if (is_global_default_ctx && ctx->legacy_hw_ctx.rcs_state)
-		i915_gem_object_ggtt_unpin(ctx->legacy_hw_ctx.rcs_state);
+		i915_gem_context_unpin_state(dev, ctx);
 err_destroy:
 	i915_gem_context_unreference(ctx);
 	return ERR_PTR(ret);
@@ -314,7 +340,7 @@ void i915_gem_context_reset(struct drm_device *dev)
 
 		if (lctx) {
 			if (lctx->legacy_hw_ctx.rcs_state && i == RCS)
-				i915_gem_object_ggtt_unpin(lctx->legacy_hw_ctx.rcs_state);
+				i915_gem_context_unpin_state(dev, lctx);
 
 			i915_gem_context_unreference(lctx);
 			ring->last_context = NULL;
@@ -388,12 +414,12 @@ void i915_gem_context_fini(struct drm_device *dev)
 		if (dev_priv->ring[RCS].last_context == dctx) {
 			/* Fake switch to NULL context */
 			WARN_ON(dctx->legacy_hw_ctx.rcs_state->active);
-			i915_gem_object_ggtt_unpin(dctx->legacy_hw_ctx.rcs_state);
+			i915_gem_context_unpin_state(dev, dctx);
 			i915_gem_context_unreference(dctx);
 			dev_priv->ring[RCS].last_context = NULL;
 		}
 
-		i915_gem_object_ggtt_unpin(dctx->legacy_hw_ctx.rcs_state);
+		i915_gem_context_unpin_state(dev, dctx);
 	}
 
 	for (i = 0; i < I915_NUM_RINGS; i++) {
@@ -642,8 +668,7 @@ static int do_switch(struct intel_engine_cs *ring,
 
 	/* Trying to pin first makes error handling easier. */
 	if (ring == &dev_priv->ring[RCS]) {
-		ret = i915_gem_obj_ggtt_pin(to->legacy_hw_ctx.rcs_state,
-					    get_context_alignment(ring->dev), 0);
+		ret = i915_gem_context_pin_state(ring->dev, to);
 		if (ret)
 			return ret;
 	}
@@ -757,7 +782,7 @@ static int do_switch(struct intel_engine_cs *ring,
 			from->legacy_hw_ctx.rcs_state->last_read_req) != ring);
 
 		/* obj is kept alive until the next request by its active ref */
-		i915_gem_object_ggtt_unpin(from->legacy_hw_ctx.rcs_state);
+		i915_gem_context_unpin_state(ring->dev, from);
 		i915_gem_context_unreference(from);
 	}
 
@@ -780,7 +805,7 @@ done:
 
 unpin_out:
 	if (ring->id == RCS)
-		i915_gem_object_ggtt_unpin(to->legacy_hw_ctx.rcs_state);
+		i915_gem_context_unpin_state(ring->dev, to);
 	return ret;
 }
 
diff --git a/drivers/gpu/drm/i915/i915_oa_perf.c b/drivers/gpu/drm/i915/i915_oa_perf.c
new file mode 100644
index 0000000..bf1c1d6
--- /dev/null
+++ b/drivers/gpu/drm/i915/i915_oa_perf.c
@@ -0,0 +1,762 @@
+#include <linux/perf_event.h>
+#include <linux/sizes.h>
+
+#include "i915_drv.h"
+#include "intel_ringbuffer.h"
+
+/* Must be a power of two */
+#define OA_BUFFER_SIZE	     SZ_16M
+#define OA_TAKEN(tail, head) ((tail - head) & (OA_BUFFER_SIZE - 1))
+
+#define FREQUENCY 200
+#define PERIOD max_t(u64, 10000, NSEC_PER_SEC / FREQUENCY)
+
+static int hsw_perf_format_sizes[] = {
+	64,  /* A13_HSW */
+	128, /* A29_HSW */
+	128, /* A13_B8_C8_HSW */
+	-1,  /* Disallowed since 192 bytes doesn't factor into buffer size
+		(A29_B8_C8_HSW) */
+	64,  /* B4_C8_HSW */
+	256, /* A45_B8_C8_HSW */
+	128, /* B4_C8_A16_HSW */
+	64   /* C4_B8_HSW */
+};
+
+static void forward_one_oa_snapshot_to_event(struct drm_i915_private *dev_priv,
+					     u8 *snapshot,
+					     struct perf_event *event)
+{
+	struct perf_sample_data data;
+	int snapshot_size = dev_priv->oa_pmu.oa_buffer.format_size;
+	struct perf_raw_record raw;
+
+	WARN_ON(snapshot_size == 0);
+
+	perf_sample_data_init(&data, 0, event->hw.last_period);
+
+	/* Note: the combined u32 raw->size member + raw data itself must be 8
+	 * byte aligned. (See note in init_oa_buffer for more details) */
+	raw.size = snapshot_size + 4;
+	raw.data = snapshot;
+
+	data.raw = &raw;
+
+	perf_event_overflow(event, &data, &dev_priv->oa_pmu.dummy_regs);
+}
+
+static u32 forward_oa_snapshots(struct drm_i915_private *dev_priv,
+				u32 head,
+				u32 tail)
+{
+	struct perf_event *exclusive_event = dev_priv->oa_pmu.exclusive_event;
+	int snapshot_size = dev_priv->oa_pmu.oa_buffer.format_size;
+	u8 *oa_buf_base = dev_priv->oa_pmu.oa_buffer.addr;
+	u32 mask = (OA_BUFFER_SIZE - 1);
+	u8 *snapshot;
+	u32 taken;
+
+	head -= dev_priv->oa_pmu.oa_buffer.gtt_offset;
+	tail -= dev_priv->oa_pmu.oa_buffer.gtt_offset;
+
+	/* Note: the gpu doesn't wrap the tail according to the OA buffer size
+	 * so when we need to make sure our head/tail values are in-bounds we
+	 * use the above mask.
+	 */
+
+	while ((taken = OA_TAKEN(tail, head))) {
+		/* The tail increases in 64 byte increments, not in
+		 * format_size steps. */
+		if (taken < snapshot_size)
+			break;
+
+		snapshot = oa_buf_base + (head & mask);
+		head += snapshot_size;
+
+		/* We currently only allow exclusive access to the counters
+		 * so only have one event to forward too... */
+		if (dev_priv->oa_pmu.event_active)
+			forward_one_oa_snapshot_to_event(dev_priv, snapshot,
+							 exclusive_event);
+	}
+
+	return dev_priv->oa_pmu.oa_buffer.gtt_offset + head;
+}
+
+static void flush_oa_snapshots(struct drm_i915_private *dev_priv,
+			       bool skip_if_flushing)
+{
+	unsigned long flags;
+	u32 oastatus2;
+	u32 oastatus1;
+	u32 head;
+	u32 tail;
+
+	/* Can either flush via hrtimer callback or pmu methods/fops */
+	if (skip_if_flushing) {
+
+		/* If the hrtimer triggers at the same time that we are
+		 * responding to a userspace initiated flush then we can
+		 * just bail out...
+		 */
+		if (!spin_trylock_irqsave(&dev_priv->oa_pmu.oa_buffer.flush_lock,
+					  flags))
+			return;
+	} else
+		spin_lock_irqsave(&dev_priv->oa_pmu.oa_buffer.flush_lock, flags);
+
+	WARN_ON(!dev_priv->oa_pmu.oa_buffer.addr);
+
+	oastatus2 = I915_READ(GEN7_OASTATUS2);
+	oastatus1 = I915_READ(GEN7_OASTATUS1);
+
+	head = oastatus2 & GEN7_OASTATUS2_HEAD_MASK;
+	tail = oastatus1 & GEN7_OASTATUS1_TAIL_MASK;
+
+	if (oastatus1 & (GEN7_OASTATUS1_OABUFFER_OVERFLOW |
+			 GEN7_OASTATUS1_REPORT_LOST)) {
+
+		/* XXX: How can we convey report-lost errors to userspace?  It
+		 * doesn't look like perf's _REPORT_LOST mechanism is
+		 * appropriate in this case; that's just for cases where we
+		 * run out of space for samples in the perf circular buffer.
+		 *
+		 * Maybe we can claim a special report-id and use that to
+		 * forward status flags?
+		 */
+		pr_debug("OA buffer read error: addr = %p, head = %u, offset = %u, tail = %u cnt o'flow = %d, buf o'flow = %d, rpt lost = %d\n",
+			 dev_priv->oa_pmu.oa_buffer.addr,
+			 head,
+			 head - dev_priv->oa_pmu.oa_buffer.gtt_offset,
+			 tail,
+			 oastatus1 & GEN7_OASTATUS1_COUNTER_OVERFLOW ? 1 : 0,
+			 oastatus1 & GEN7_OASTATUS1_OABUFFER_OVERFLOW ? 1 : 0,
+			 oastatus1 & GEN7_OASTATUS1_REPORT_LOST ? 1 : 0);
+
+		I915_WRITE(GEN7_OASTATUS1, oastatus1 &
+			   ~(GEN7_OASTATUS1_OABUFFER_OVERFLOW |
+			     GEN7_OASTATUS1_REPORT_LOST));
+	}
+
+	head = forward_oa_snapshots(dev_priv, head, tail);
+
+	I915_WRITE(GEN7_OASTATUS2, (head & GEN7_OASTATUS2_HEAD_MASK) |
+				    GEN7_OASTATUS2_GGTT);
+
+	spin_unlock_irqrestore(&dev_priv->oa_pmu.oa_buffer.flush_lock, flags);
+}
+
+static void
+oa_buffer_destroy(struct drm_i915_private *i915)
+{
+	mutex_lock(&i915->dev->struct_mutex);
+
+	vunmap(i915->oa_pmu.oa_buffer.addr);
+	i915_gem_object_ggtt_unpin(i915->oa_pmu.oa_buffer.obj);
+	drm_gem_object_unreference(&i915->oa_pmu.oa_buffer.obj->base);
+
+	i915->oa_pmu.oa_buffer.obj = NULL;
+	i915->oa_pmu.oa_buffer.gtt_offset = 0;
+	i915->oa_pmu.oa_buffer.addr = NULL;
+
+	mutex_unlock(&i915->dev->struct_mutex);
+}
+
+static void i915_oa_event_destroy(struct perf_event *event)
+{
+	struct drm_i915_private *i915 =
+		container_of(event->pmu, typeof(*i915), oa_pmu.pmu);
+
+	WARN_ON(event->parent);
+
+	oa_buffer_destroy(i915);
+
+	i915->oa_pmu.specific_ctx = NULL;
+
+	BUG_ON(i915->oa_pmu.exclusive_event != event);
+	i915->oa_pmu.exclusive_event = NULL;
+
+	intel_uncore_forcewake_put(i915, FORCEWAKE_ALL);
+	intel_runtime_pm_put(i915);
+}
+
+static void *vmap_oa_buffer(struct drm_i915_gem_object *obj)
+{
+	int i;
+	void *addr = NULL;
+	struct sg_page_iter sg_iter;
+	struct page **pages;
+
+	pages = drm_malloc_ab(obj->base.size >> PAGE_SHIFT, sizeof(*pages));
+	if (pages == NULL) {
+		DRM_DEBUG_DRIVER("Failed to get space for pages\n");
+		goto finish;
+	}
+
+	i = 0;
+	for_each_sg_page(obj->pages->sgl, &sg_iter, obj->pages->nents, 0) {
+		pages[i] = sg_page_iter_page(&sg_iter);
+		i++;
+	}
+
+	addr = vmap(pages, i, 0, PAGE_KERNEL);
+	if (addr == NULL) {
+		DRM_DEBUG_DRIVER("Failed to vmap pages\n");
+		goto finish;
+	}
+
+finish:
+	if (pages)
+		drm_free_large(pages);
+	return addr;
+}
+
+static int init_oa_buffer(struct perf_event *event)
+{
+	struct drm_i915_private *dev_priv =
+		container_of(event->pmu, typeof(*dev_priv), oa_pmu.pmu);
+	struct drm_i915_gem_object *bo;
+	int ret;
+
+	BUG_ON(!IS_HASWELL(dev_priv->dev));
+	BUG_ON(mutex_is_locked(&dev_priv->dev->struct_mutex));
+	BUG_ON(dev_priv->oa_pmu.oa_buffer.obj);
+
+	ret = i915_mutex_lock_interruptible(dev_priv->dev);
+	if (ret)
+		return ret;
+
+	spin_lock_init(&dev_priv->oa_pmu.oa_buffer.flush_lock);
+
+	/* NB: We over allocate the OA buffer due to the way raw sample data
+	 * gets copied from the gpu mapped circular buffer into the perf
+	 * circular buffer so that only one copy is required.
+	 *
+	 * For each perf sample (raw->size + 4) needs to be 8 byte aligned,
+	 * where the 4 corresponds to the 32bit raw->size member that's
+	 * added to the sample header that userspace sees.
+	 *
+	 * Due to the + 4 for the size member: when we copy a report to the
+	 * userspace facing perf buffer we always copy an additional 4 bytes
+	 * from the subsequent report to make up for the miss alignment, but
+	 * when a report is at the end of the gpu mapped buffer we need to
+	 * read 4 bytes past the end of the buffer.
+	 */
+	bo = i915_gem_alloc_object(dev_priv->dev, OA_BUFFER_SIZE + PAGE_SIZE);
+	if (bo == NULL) {
+		DRM_ERROR("Failed to allocate OA buffer\n");
+		ret = -ENOMEM;
+		goto unlock;
+	}
+	dev_priv->oa_pmu.oa_buffer.obj = bo;
+
+	ret = i915_gem_object_set_cache_level(bo, I915_CACHE_LLC);
+	if (ret)
+		goto err_unref;
+
+	/* PreHSW required 512K alignment, HSW requires 16M */
+	ret = i915_gem_obj_ggtt_pin(bo, SZ_16M, 0);
+	if (ret)
+		goto err_unref;
+
+	dev_priv->oa_pmu.oa_buffer.gtt_offset = i915_gem_obj_ggtt_offset(bo);
+	dev_priv->oa_pmu.oa_buffer.addr = vmap_oa_buffer(bo);
+
+	/* Pre-DevBDW: OABUFFER must be set with counters off,
+	 * before OASTATUS1, but after OASTATUS2 */
+	I915_WRITE(GEN7_OASTATUS2, dev_priv->oa_pmu.oa_buffer.gtt_offset |
+		   GEN7_OASTATUS2_GGTT); /* head */
+	I915_WRITE(GEN7_OABUFFER, dev_priv->oa_pmu.oa_buffer.gtt_offset);
+	I915_WRITE(GEN7_OASTATUS1, dev_priv->oa_pmu.oa_buffer.gtt_offset |
+		   GEN7_OASTATUS1_OABUFFER_SIZE_16M); /* tail */
+
+	DRM_DEBUG_DRIVER("OA Buffer initialized, gtt offset = 0x%x, vaddr = %p",
+			 dev_priv->oa_pmu.oa_buffer.gtt_offset,
+			 dev_priv->oa_pmu.oa_buffer.addr);
+
+	goto unlock;
+
+err_unref:
+	drm_gem_object_unreference(&bo->base);
+
+unlock:
+	mutex_unlock(&dev_priv->dev->struct_mutex);
+	return ret;
+}
+
+static enum hrtimer_restart hrtimer_sample(struct hrtimer *hrtimer)
+{
+	struct drm_i915_private *i915 =
+		container_of(hrtimer, typeof(*i915), oa_pmu.timer);
+
+	flush_oa_snapshots(i915, true);
+
+	hrtimer_forward_now(hrtimer, ns_to_ktime(PERIOD));
+	return HRTIMER_RESTART;
+}
+
+static struct intel_context *
+lookup_context(struct drm_i915_private *dev_priv,
+	       struct file *user_filp,
+	       u32 ctx_user_handle)
+{
+	struct intel_context *ctx;
+
+	mutex_lock(&dev_priv->dev->struct_mutex);
+	list_for_each_entry(ctx, &dev_priv->context_list, link) {
+		struct drm_file *drm_file;
+
+		if (!ctx->file_priv)
+			continue;
+
+		drm_file = ctx->file_priv->file;
+
+		if (user_filp->private_data == drm_file &&
+		    ctx->user_handle == ctx_user_handle) {
+			mutex_unlock(&dev_priv->dev->struct_mutex);
+			return ctx;
+		}
+	}
+	mutex_unlock(&dev_priv->dev->struct_mutex);
+
+	return NULL;
+}
+
+static int i915_oa_copy_attr(drm_i915_oa_attr_t __user *uattr,
+			     drm_i915_oa_attr_t *attr)
+{
+	u32 size;
+	int ret;
+
+	if (!access_ok(VERIFY_WRITE, uattr, I915_OA_ATTR_SIZE_VER0))
+		return -EFAULT;
+
+	/*
+	 * zero the full structure, so that a short copy will be nice.
+	 */
+	memset(attr, 0, sizeof(*attr));
+
+	ret = get_user(size, &uattr->size);
+	if (ret)
+		return ret;
+
+	if (size > PAGE_SIZE)	/* silly large */
+		goto err_size;
+
+	if (size < I915_OA_ATTR_SIZE_VER0)
+		goto err_size;
+
+	/*
+	 * If we're handed a bigger struct than we know of,
+	 * ensure all the unknown bits are 0 - i.e. new
+	 * user-space does not rely on any kernel feature
+	 * extensions we dont know about yet.
+	 */
+	if (size > sizeof(*attr)) {
+		unsigned char __user *addr;
+		unsigned char __user *end;
+		unsigned char val;
+
+		addr = (void __user *)uattr + sizeof(*attr);
+		end  = (void __user *)uattr + size;
+
+		for (; addr < end; addr++) {
+			ret = get_user(val, addr);
+			if (ret)
+				return ret;
+			if (val)
+				goto err_size;
+		}
+		size = sizeof(*attr);
+	}
+
+	ret = copy_from_user(attr, uattr, size);
+	if (ret)
+		return -EFAULT;
+
+	if (attr->__reserved_1)
+		return -EINVAL;
+
+out:
+	return ret;
+
+err_size:
+	put_user(sizeof(*attr), &uattr->size);
+	ret = -E2BIG;
+	goto out;
+}
+
+static int i915_oa_event_init(struct perf_event *event)
+{
+	struct drm_i915_private *dev_priv =
+		container_of(event->pmu, typeof(*dev_priv), oa_pmu.pmu);
+	drm_i915_oa_attr_t oa_attr;
+	u64 report_format;
+	int ret = 0;
+
+	if (event->attr.type != event->pmu->type)
+		return -ENOENT;
+
+	ret = i915_oa_copy_attr(to_user_ptr(event->attr.config), &oa_attr);
+	if (ret)
+		return ret;
+
+	/* To avoid the complexity of having to accurately filter
+	 * counter snapshots and marshal to the appropriate client
+	 * we currently only allow exclusive access */
+	if (dev_priv->oa_pmu.oa_buffer.obj)
+		return -EBUSY;
+
+	report_format = oa_attr.format;
+	dev_priv->oa_pmu.oa_buffer.format = report_format;
+	dev_priv->oa_pmu.metrics_set = oa_attr.metrics_set;
+
+	if (IS_HASWELL(dev_priv->dev)) {
+		int snapshot_size;
+
+		if (report_format >= ARRAY_SIZE(hsw_perf_format_sizes))
+			return -EINVAL;
+
+		snapshot_size = hsw_perf_format_sizes[report_format];
+		if (snapshot_size < 0)
+			return -EINVAL;
+
+		dev_priv->oa_pmu.oa_buffer.format_size = snapshot_size;
+	} else {
+		BUG(); /* pmu shouldn't have been registered */
+		return -ENODEV;
+	}
+
+	/* Since we are limited to an exponential scale for
+	 * programming the OA sampling period we don't allow userspace
+	 * to pass a precise attr.sample_period. */
+	if (event->attr.freq ||
+	    (event->attr.sample_period != 0 &&
+	     event->attr.sample_period != 1))
+		return -EINVAL;
+
+	dev_priv->oa_pmu.periodic = event->attr.sample_period;
+
+	/* Instead of allowing userspace to configure the period via
+	 * attr.sample_period we instead accept an exponent whereby
+	 * the sample_period will be:
+	 *
+	 *   80ns * 2^(period_exponent + 1)
+	 *
+	 * Programming a period of 160 nanoseconds would not be very
+	 * polite, so higher frequencies are reserved for root.
+	 */
+	if (dev_priv->oa_pmu.periodic) {
+		u64 period_exponent = oa_attr.timer_exponent;
+
+		if (period_exponent > 63)
+			return -EINVAL;
+
+		if (period_exponent < 15 && !capable(CAP_SYS_ADMIN))
+			return -EACCES;
+
+		dev_priv->oa_pmu.period_exponent = period_exponent;
+	} else if (oa_attr.timer_exponent)
+		return -EINVAL;
+
+	/* We bypass the default perf core perf_paranoid_cpu() ||
+	 * CAP_SYS_ADMIN check by using the PERF_PMU_CAP_IS_DEVICE
+	 * flag and instead authenticate based on whether the current
+	 * pid owns the specified context, or require CAP_SYS_ADMIN
+	 * when collecting cross-context metrics.
+	 */
+	dev_priv->oa_pmu.specific_ctx = NULL;
+	if (oa_attr.single_context) {
+		u32 ctx_id = oa_attr.ctx_id;
+		unsigned int drm_fd = oa_attr.drm_fd;
+		struct fd fd = fdget(drm_fd);
+
+		if (!fd.file)
+			return -EBADF;
+
+		dev_priv->oa_pmu.specific_ctx =
+			lookup_context(dev_priv, fd.file, ctx_id);
+		fdput(fd);
+
+		if (!dev_priv->oa_pmu.specific_ctx)
+			return -EINVAL;
+	}
+
+	if (!dev_priv->oa_pmu.specific_ctx && !capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	ret = init_oa_buffer(event);
+	if (ret)
+		return ret;
+
+	BUG_ON(dev_priv->oa_pmu.exclusive_event);
+	dev_priv->oa_pmu.exclusive_event = event;
+
+	event->destroy = i915_oa_event_destroy;
+
+	/* PRM - observability performance counters:
+	 *
+	 *   OACONTROL, performance counter enable, note:
+	 *
+	 *   "When this bit is set, in order to have coherent counts,
+	 *   RC6 power state and trunk clock gating must be disabled.
+	 *   This can be achieved by programming MMIO registers as
+	 *   0xA094=0 and 0xA090[31]=1"
+	 *
+	 *   In our case we are expected that taking pm + FORCEWAKE
+	 *   references will effectively disable RC6 and trunk clock
+	 *   gating.
+	 */
+	intel_runtime_pm_get(dev_priv);
+	intel_uncore_forcewake_get(dev_priv, FORCEWAKE_ALL);
+
+	return 0;
+}
+
+static void update_oacontrol(struct drm_i915_private *dev_priv)
+{
+	BUG_ON(!spin_is_locked(&dev_priv->oa_pmu.lock));
+
+	if (dev_priv->oa_pmu.event_active) {
+		unsigned long ctx_id = 0;
+		bool pinning_ok = false;
+
+		if (dev_priv->oa_pmu.specific_ctx) {
+			struct intel_context *ctx =
+				dev_priv->oa_pmu.specific_ctx;
+			struct drm_i915_gem_object *obj =
+				ctx->legacy_hw_ctx.rcs_state;
+
+			if (i915_gem_obj_is_pinned(obj)) {
+				ctx_id = i915_gem_obj_ggtt_offset(obj);
+				pinning_ok = true;
+			}
+		}
+
+		if ((ctx_id == 0 || pinning_ok)) {
+			bool periodic = dev_priv->oa_pmu.periodic;
+			u32 period_exponent = dev_priv->oa_pmu.period_exponent;
+			u32 report_format = dev_priv->oa_pmu.oa_buffer.format;
+
+			I915_WRITE(GEN7_OACONTROL,
+				   (ctx_id & GEN7_OACONTROL_CTX_MASK) |
+				   (period_exponent <<
+				    GEN7_OACONTROL_TIMER_PERIOD_SHIFT) |
+				   (periodic ?
+				    GEN7_OACONTROL_TIMER_ENABLE : 0) |
+				   (report_format <<
+				    GEN7_OACONTROL_FORMAT_SHIFT) |
+				   (ctx_id ?
+				    GEN7_OACONTROL_PER_CTX_ENABLE : 0) |
+				   GEN7_OACONTROL_ENABLE);
+			return;
+		}
+	}
+
+	I915_WRITE(GEN7_OACONTROL, 0);
+}
+
+static void i915_oa_event_start(struct perf_event *event, int flags)
+{
+	struct drm_i915_private *dev_priv =
+		container_of(event->pmu, typeof(*dev_priv), oa_pmu.pmu);
+	unsigned long lock_flags;
+	u32 oastatus1, tail;
+
+	/* PRM - observability performance counters:
+	 *
+	 *   OACONTROL, specific context enable:
+	 *
+	 *   "OA unit level clock gating must be ENABLED when using
+	 *   specific ContextID feature."
+	 *
+	 * Assuming we don't ever disable OA unit level clock gating
+	 * lets just assert that this condition is met...
+	 */
+	WARN_ONCE(I915_READ(GEN6_UCGCTL3) & GEN6_OACSUNIT_CLOCK_GATE_DISABLE,
+		  "disabled OA unit level clock gating will result in incorrect per-context OA counters");
+
+	/* XXX: On Haswell, when threshold disable mode is desired,
+	 * instead of setting the threshold enable to '0', we need to
+	 * program it to '1' and set OASTARTTRIG1 bits 15:0 to 0
+	 * (threshold value of 0)
+	 */
+	I915_WRITE(OASTARTTRIG6, (OASTARTTRIG6_B4_TO_B7_THRESHOLD_ENABLE |
+				  OASTARTTRIG6_B4_CUSTOM_EVENT_ENABLE));
+	I915_WRITE(OASTARTTRIG5, 0); /* threshold value */
+
+	I915_WRITE(OASTARTTRIG2, (OASTARTTRIG2_B0_TO_B3_THRESHOLD_ENABLE |
+				  OASTARTTRIG2_B0_CUSTOM_EVENT_ENABLE));
+	I915_WRITE(OASTARTTRIG1, 0); /* threshold value */
+
+	/* Setup B0 as the gpu clock counter... */
+	I915_WRITE(OACEC0_0, OACEC0_0_B0_COMPARE_GREATER_OR_EQUAL); /* to 0 */
+	I915_WRITE(OACEC0_1, 0xfffe); /* Select NOA[0] */
+
+	spin_lock_irqsave(&dev_priv->oa_pmu.lock, lock_flags);
+
+	dev_priv->oa_pmu.event_active = true;
+	update_oacontrol(dev_priv);
+
+	/* Reset the head ptr to ensure we don't forward reports relating
+	 * to a previous perf event */
+	oastatus1 = I915_READ(GEN7_OASTATUS1);
+	tail = oastatus1 & GEN7_OASTATUS1_TAIL_MASK;
+	I915_WRITE(GEN7_OASTATUS2, (tail & GEN7_OASTATUS2_HEAD_MASK) |
+				    GEN7_OASTATUS2_GGTT);
+
+	mmiowb();
+	spin_unlock_irqrestore(&dev_priv->oa_pmu.lock, lock_flags);
+
+	if (event->attr.sample_period)
+		__hrtimer_start_range_ns(&dev_priv->oa_pmu.timer,
+					 ns_to_ktime(PERIOD), 0,
+					 HRTIMER_MODE_REL_PINNED, 0);
+
+	event->hw.state = 0;
+}
+
+static void i915_oa_event_stop(struct perf_event *event, int flags)
+{
+	struct drm_i915_private *dev_priv =
+		container_of(event->pmu, typeof(*dev_priv), oa_pmu.pmu);
+	unsigned long lock_flags;
+
+	spin_lock_irqsave(&dev_priv->oa_pmu.lock, lock_flags);
+
+	dev_priv->oa_pmu.event_active = false;
+	update_oacontrol(dev_priv);
+
+	mmiowb();
+	spin_unlock_irqrestore(&dev_priv->oa_pmu.lock, lock_flags);
+
+	if (event->attr.sample_period) {
+		hrtimer_cancel(&dev_priv->oa_pmu.timer);
+		flush_oa_snapshots(dev_priv, false);
+	}
+
+	event->hw.state = PERF_HES_STOPPED;
+}
+
+static int i915_oa_event_add(struct perf_event *event, int flags)
+{
+	if (flags & PERF_EF_START)
+		i915_oa_event_start(event, flags);
+
+	return 0;
+}
+
+static void i915_oa_event_del(struct perf_event *event, int flags)
+{
+	i915_oa_event_stop(event, flags);
+}
+
+static void i915_oa_event_read(struct perf_event *event)
+{
+	struct drm_i915_private *i915 =
+		container_of(event->pmu, typeof(*i915), oa_pmu.pmu);
+
+	/* XXX: What counter would be useful here? */
+	local64_set(&event->count, 0);
+}
+
+static int i915_oa_event_flush(struct perf_event *event)
+{
+	if (event->attr.sample_period) {
+		struct drm_i915_private *i915 =
+			container_of(event->pmu, typeof(*i915), oa_pmu.pmu);
+
+		flush_oa_snapshots(i915, true);
+	}
+
+	return 0;
+}
+
+static int i915_oa_event_event_idx(struct perf_event *event)
+{
+	return 0;
+}
+
+void i915_oa_context_pin_notify(struct drm_i915_private *dev_priv,
+				struct intel_context *context)
+{
+	unsigned long flags;
+
+	if (dev_priv->oa_pmu.pmu.event_init == NULL)
+		return;
+
+	spin_lock_irqsave(&dev_priv->oa_pmu.lock, flags);
+
+	if (dev_priv->oa_pmu.specific_ctx == context)
+		update_oacontrol(dev_priv);
+
+	mmiowb();
+	spin_unlock_irqrestore(&dev_priv->oa_pmu.lock, flags);
+}
+
+void i915_oa_context_unpin_notify(struct drm_i915_private *dev_priv,
+				  struct intel_context *context)
+{
+	unsigned long flags;
+
+	if (dev_priv->oa_pmu.pmu.event_init == NULL)
+		return;
+
+	spin_lock_irqsave(&dev_priv->oa_pmu.lock, flags);
+
+	if (dev_priv->oa_pmu.specific_ctx == context)
+		update_oacontrol(dev_priv);
+
+	mmiowb();
+	spin_unlock_irqrestore(&dev_priv->oa_pmu.lock, flags);
+}
+
+void i915_oa_pmu_register(struct drm_device *dev)
+{
+	struct drm_i915_private *i915 = to_i915(dev);
+
+	if (!IS_HASWELL(dev))
+		return;
+
+	/* We need to be careful about forwarding cpu metrics to
+	 * userspace considering that PERF_PMU_CAP_IS_DEVICE bypasses
+	 * the events/core security check that stops an unprivileged
+	 * process collecting metrics for other processes.
+	 */
+	i915->oa_pmu.dummy_regs = *task_pt_regs(current);
+
+	hrtimer_init(&i915->oa_pmu.timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	i915->oa_pmu.timer.function = hrtimer_sample;
+
+	spin_lock_init(&i915->oa_pmu.lock);
+
+	i915->oa_pmu.pmu.capabilities  = PERF_PMU_CAP_IS_DEVICE;
+
+	/* Effectively disallow opening an event with a specific pid
+	 * since we aren't interested in processes running on the cpu...
+	 */
+	i915->oa_pmu.pmu.task_ctx_nr   = perf_invalid_context;
+
+	i915->oa_pmu.pmu.event_init    = i915_oa_event_init;
+	i915->oa_pmu.pmu.add	       = i915_oa_event_add;
+	i915->oa_pmu.pmu.del	       = i915_oa_event_del;
+	i915->oa_pmu.pmu.start	       = i915_oa_event_start;
+	i915->oa_pmu.pmu.stop	       = i915_oa_event_stop;
+	i915->oa_pmu.pmu.read	       = i915_oa_event_read;
+	i915->oa_pmu.pmu.flush	       = i915_oa_event_flush;
+	i915->oa_pmu.pmu.event_idx     = i915_oa_event_event_idx;
+
+	if (perf_pmu_register(&i915->oa_pmu.pmu, "i915_oa", -1))
+		i915->oa_pmu.pmu.event_init = NULL;
+}
+
+void i915_oa_pmu_unregister(struct drm_device *dev)
+{
+	struct drm_i915_private *i915 = to_i915(dev);
+
+	if (i915->oa_pmu.pmu.event_init == NULL)
+		return;
+
+	perf_pmu_unregister(&i915->oa_pmu.pmu);
+	i915->oa_pmu.pmu.event_init = NULL;
+}
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index dc6907b..40fc44f 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -516,6 +516,73 @@
 #define GEN7_3DPRIM_BASE_VERTEX         0x2440
 
 #define GEN7_OACONTROL 0x2360
+#define  GEN7_OACONTROL_CTX_MASK	    0xFFFFF000
+#define  GEN7_OACONTROL_TIMER_PERIOD_MASK   0x3F
+#define  GEN7_OACONTROL_TIMER_PERIOD_SHIFT  6
+#define  GEN7_OACONTROL_TIMER_ENABLE	    (1<<5)
+#define  GEN7_OACONTROL_FORMAT_A13	    (0<<2)
+#define  GEN7_OACONTROL_FORMAT_A29	    (1<<2)
+#define  GEN7_OACONTROL_FORMAT_A13_B8_C8    (2<<2)
+#define  GEN7_OACONTROL_FORMAT_A29_B8_C8    (3<<2)
+#define  GEN7_OACONTROL_FORMAT_B4_C8	    (4<<2)
+#define  GEN7_OACONTROL_FORMAT_A45_B8_C8    (5<<2)
+#define  GEN7_OACONTROL_FORMAT_B4_C8_A16    (6<<2)
+#define  GEN7_OACONTROL_FORMAT_C4_B8	    (7<<2)
+#define  GEN7_OACONTROL_FORMAT_SHIFT	    2
+#define  GEN7_OACONTROL_PER_CTX_ENABLE	    (1<<1)
+#define  GEN7_OACONTROL_ENABLE		    (1<<0)
+
+#define OASTARTTRIG5 0x02720
+#define  OASTARTTRIG5_THRESHOLD_VALUE_MASK	0xffff
+
+#define OASTARTTRIG6 0x02724
+#define  OASTARTTRIG6_B4_TO_B7_THRESHOLD_ENABLE (1<<23)
+#define  OASTARTTRIG6_B4_CUSTOM_EVENT_ENABLE	(1<<28)
+
+#define OASTARTTRIG1 0x02710
+#define  OASTARTTRIG1_THRESHOLD_VALUE_MASK	0xffff
+
+#define OASTARTTRIG2 0x02714
+#define  OASTARTTRIG2_B0_TO_B3_THRESHOLD_ENABLE (1<<23)
+#define  OASTARTTRIG2_B0_CUSTOM_EVENT_ENABLE	(1<<28)
+
+#define OACEC0_0 0x2770
+#define  OACEC0_0_B0_COMPARE_ANY_EQUAL		0
+#define  OACEC0_0_B0_COMPARE_OR			0
+#define  OACEC0_0_B0_COMPARE_GREATER_THAN	1
+#define  OACEC0_0_B0_COMPARE_EQUAL		2
+#define  OACEC0_0_B0_COMPARE_GREATER_OR_EQUAL	3
+#define  OACEC0_0_B0_COMPARE_LESS_THAN		4
+#define  OACEC0_0_B0_COMPARE_NOT_EQUAL		5
+#define  OACEC0_0_B0_COMPARE_LESS_OR_EQUAL	6
+#define  OACEC0_0_B0_COMPARE_VALUE_MASK		0xffff
+#define  OACEC0_0_B0_COMPARE_VALUE_SHIFT	3
+
+#define OACEC0_1 0x2774
+
+#define GEN7_OABUFFER 0x23B0 /* R/W */
+#define  GEN7_OABUFFER_OVERRUN_DISABLE	    (1<<3)
+#define  GEN7_OABUFFER_EDGE_TRIGGER	    (1<<2)
+#define  GEN7_OABUFFER_STOP_RESUME_ENABLE   (1<<1)
+#define  GEN7_OABUFFER_RESUME		    (1<<0)
+
+#define GEN7_OASTATUS1 0x2364
+#define  GEN7_OASTATUS1_TAIL_MASK	    0xffffffc0
+#define  GEN7_OASTATUS1_OABUFFER_SIZE_128K  (0<<3)
+#define  GEN7_OASTATUS1_OABUFFER_SIZE_256K  (1<<3)
+#define  GEN7_OASTATUS1_OABUFFER_SIZE_512K  (2<<3)
+#define  GEN7_OASTATUS1_OABUFFER_SIZE_1M    (3<<3)
+#define  GEN7_OASTATUS1_OABUFFER_SIZE_2M    (4<<3)
+#define  GEN7_OASTATUS1_OABUFFER_SIZE_4M    (5<<3)
+#define  GEN7_OASTATUS1_OABUFFER_SIZE_8M    (6<<3)
+#define  GEN7_OASTATUS1_OABUFFER_SIZE_16M   (7<<3)
+#define  GEN7_OASTATUS1_COUNTER_OVERFLOW    (1<<2)
+#define  GEN7_OASTATUS1_OABUFFER_OVERFLOW   (1<<1)
+#define  GEN7_OASTATUS1_REPORT_LOST	    (1<<0)
+
+#define GEN7_OASTATUS2 0x2368
+#define GEN7_OASTATUS2_HEAD_MASK    0xffffffc0
+#define GEN7_OASTATUS2_GGTT	    0x1
 
 #define _GEN7_PIPEA_DE_LOAD_SL	0x70068
 #define _GEN7_PIPEB_DE_LOAD_SL	0x71068
@@ -6545,6 +6612,7 @@ enum skl_disp_power_wells {
 # define GEN6_RCCUNIT_CLOCK_GATE_DISABLE		(1 << 11)
 
 #define GEN6_UCGCTL3				0x9408
+# define GEN6_OACSUNIT_CLOCK_GATE_DISABLE		(1 << 20)
 
 #define GEN7_UCGCTL4				0x940c
 #define  GEN7_L3BANK2X_CLOCK_GATE_DISABLE	(1<<25)
diff --git a/include/uapi/drm/i915_drm.h b/include/uapi/drm/i915_drm.h
index 4851d66..f78f232 100644
--- a/include/uapi/drm/i915_drm.h
+++ b/include/uapi/drm/i915_drm.h
@@ -58,6 +58,35 @@
 #define I915_ERROR_UEVENT		"ERROR"
 #define I915_RESET_UEVENT		"RESET"
 
+/**
+ * DOC: perf events configuration exposed by i915 through /sys/bus/event_sources/drivers/i915_oa
+ *
+ */
+
+#define I915_OA_FORMAT_A13_HSW		0
+#define I915_OA_FORMAT_A29_HSW		1
+#define I915_OA_FORMAT_A13_B8_C8_HSW	2
+#define I915_OA_FORMAT_B4_C8_HSW	4
+#define I915_OA_FORMAT_A45_B8_C8_HSW	5
+#define I915_OA_FORMAT_B4_C8_A16_HSW	6
+#define I915_OA_FORMAT_C4_B8_HSW	7
+
+#define I915_OA_ATTR_SIZE_VER0		32  /* sizeof first published struct */
+
+typedef struct _drm_i915_oa_attr {
+	__u32 size;
+
+	__u32 format;
+	__u32 metrics_set;
+	__u32 timer_exponent;
+
+	__u32 drm_fd;
+	__u32 ctx_id;
+
+	__u64 single_context : 1,
+	      __reserved_1 : 63;
+} drm_i915_oa_attr_t;
+
 /* Each region is a minimum of 16k, and there are at most 255 of them.
  */
 #define I915_NR_TEX_REGIONS 255	/* table size 2k - maximum due to use
-- 
2.4.1
