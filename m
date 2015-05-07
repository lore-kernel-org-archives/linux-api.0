From: Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>
Subject: Re: [Intel-gfx] [RFC PATCH 07/11] drm/i915: Expose PMU for
 Observation Architecture
Date: Thu, 7 May 2015 15:58:00 +0100
Message-ID: <20150507145800.GZ22099@nuc-i3427.alporthouse.com>
References: <1431008154-6833-1-git-send-email-robert@sixbynine.org>
 <1431008154-6833-8-git-send-email-robert@sixbynine.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1431008154-6833-8-git-send-email-robert-St23OQVBDYPNLxjTenLetw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Bragg <robert-St23OQVBDYPNLxjTenLetw@public.gmane.org>
Cc: intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Vetter <daniel.vetter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, May 07, 2015 at 03:15:50PM +0100, Robert Bragg wrote:
> +	/* We bypass the default perf core perf_paranoid_cpu() ||
> +	 * CAP_SYS_ADMIN check by using the PERF_PMU_CAP_IS_DEVICE
> +	 * flag and instead authenticate based on whether the current
> +	 * pid owns the specified context, or require CAP_SYS_ADMIN
> +	 * when collecting cross-context metrics.
> +	 */
> +	dev_priv->oa_pmu.specific_ctx = NULL;
> +	if (oa_attr.single_context) {
> +		u32 ctx_id = oa_attr.ctx_id;
> +		unsigned int drm_fd = oa_attr.drm_fd;
> +		struct fd fd = fdget(drm_fd);
> +
> +		if (fd.file) {

Specify a ctx and not providing the right fd should be its own error,
either EBADF or EINVAL.

> +			dev_priv->oa_pmu.specific_ctx =
> +				lookup_context(dev_priv, fd.file, ctx_id);
> +		}

Missing fdput

> +	}
> +
> +	if (!dev_priv->oa_pmu.specific_ctx && !capable(CAP_SYS_ADMIN))
> +		return -EACCES;
> +
> +	mutex_lock(&dev_priv->dev->struct_mutex);

i915_mutex_interruptible, probably best to couple into the GPU error
handling here as well especially as init_oa_buffer() will go onto touch
GPU internals.

> +	ret = init_oa_buffer(event);
> +	mutex_unlock(&dev_priv->dev->struct_mutex);
> +
> +	if (ret)
> +		return ret;
> +
> +	BUG_ON(dev_priv->oa_pmu.exclusive_event);
> +	dev_priv->oa_pmu.exclusive_event = event;
> +
> +	event->destroy = i915_oa_event_destroy;
> +
> +	/* PRM - observability performance counters:
> +	 *
> +	 *   OACONTROL, performance counter enable, note:
> +	 *
> +	 *   "When this bit is set, in order to have coherent counts,
> +	 *   RC6 power state and trunk clock gating must be disabled.
> +	 *   This can be achieved by programming MMIO registers as
> +	 *   0xA094=0 and 0xA090[31]=1"
> +	 *
> +	 *   In our case we are expected that taking pm + FORCEWAKE
> +	 *   references will effectively disable RC6 and trunk clock
> +	 *   gating.
> +	 */
> +	intel_runtime_pm_get(dev_priv);
> +	intel_uncore_forcewake_get(dev_priv, FORCEWAKE_ALL);

That is a nuisance. Aside: Why isn't OA inside the powerctx? Is a subset
valid with forcewake? It does perturb the system greatly to disable rc6,
so I wonder if it could be made optional?

> +
> +	return 0;
> +}
> +
> +static void update_oacontrol(struct drm_i915_private *dev_priv)
> +{
> +	BUG_ON(!spin_is_locked(&dev_priv->oa_pmu.lock));
> +
> +	if (dev_priv->oa_pmu.event_active) {
> +		unsigned long ctx_id = 0;
> +		bool pinning_ok = false;
> +
> +		if (dev_priv->oa_pmu.specific_ctx) {
> +			struct intel_context *ctx =
> +				dev_priv->oa_pmu.specific_ctx;
> +			struct drm_i915_gem_object *obj =
> +				ctx->legacy_hw_ctx.rcs_state;

If only there was ctx->legacy_hw_ctx.rcs_vma...

> +
> +			if (i915_gem_obj_is_pinned(obj)) {
> +				ctx_id = i915_gem_obj_ggtt_offset(obj);
> +				pinning_ok = true;
> +			}
> +		}
> +
> +		if ((ctx_id == 0 || pinning_ok)) {
> +			bool periodic = dev_priv->oa_pmu.periodic;
> +			u32 period_exponent = dev_priv->oa_pmu.period_exponent;
> +			u32 report_format = dev_priv->oa_pmu.oa_buffer.format;
> +
> +			I915_WRITE(GEN7_OACONTROL,
> +				   (ctx_id & GEN7_OACONTROL_CTX_MASK) |
> +				   (period_exponent <<
> +				    GEN7_OACONTROL_TIMER_PERIOD_SHIFT) |
> +				   (periodic ?
> +				    GEN7_OACONTROL_TIMER_ENABLE : 0) |
> +				   (report_format <<
> +				    GEN7_OACONTROL_FORMAT_SHIFT) |
> +				   (ctx_id ?
> +				    GEN7_OACONTROL_PER_CTX_ENABLE : 0) |
> +				   GEN7_OACONTROL_ENABLE);

I notice you don't use any write barriers...
-Chris
-- 
Chris Wilson, Intel Open Source Technology Centre
