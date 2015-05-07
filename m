From: Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>
Subject: Re: [Intel-gfx] [RFC PATCH 07/11] drm/i915: Expose PMU for
 Observation Architecture
Date: Thu, 7 May 2015 15:36:39 +0100
Message-ID: <20150507143639.GY22099@nuc-i3427.alporthouse.com>
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
> +static int init_oa_buffer(struct perf_event *event)
> +{
> +	struct drm_i915_private *dev_priv =
> +		container_of(event->pmu, typeof(*dev_priv), oa_pmu.pmu);
> +	struct drm_i915_gem_object *bo;
> +	int ret;
> +
> +	BUG_ON(!IS_HASWELL(dev_priv->dev));
> +	BUG_ON(!mutex_is_locked(&dev_priv->dev->struct_mutex));
> +	BUG_ON(dev_priv->oa_pmu.oa_buffer.obj);
> +
> +	spin_lock_init(&dev_priv->oa_pmu.oa_buffer.flush_lock);
> +
> +	/* NB: We over allocate the OA buffer due to the way raw sample data
> +	 * gets copied from the gpu mapped circular buffer into the perf
> +	 * circular buffer so that only one copy is required.
> +	 *
> +	 * For each perf sample (raw->size + 4) needs to be 8 byte aligned,
> +	 * where the 4 corresponds to the 32bit raw->size member that's
> +	 * added to the sample header that userspace sees.
> +	 *
> +	 * Due to the + 4 for the size member: when we copy a report to the
> +	 * userspace facing perf buffer we always copy an additional 4 bytes
> +	 * from the subsequent report to make up for the miss alignment, but
> +	 * when a report is at the end of the gpu mapped buffer we need to
> +	 * read 4 bytes past the end of the buffer.
> +	 */
> +	bo = i915_gem_alloc_object(dev_priv->dev, OA_BUFFER_SIZE + PAGE_SIZE);
> +	if (bo == NULL) {
> +		DRM_ERROR("Failed to allocate OA buffer\n");
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +	dev_priv->oa_pmu.oa_buffer.obj = bo;
> +
> +	ret = i915_gem_object_set_cache_level(bo, I915_CACHE_LLC);
> +	if (ret)
> +		goto err_unref;
> +
> +	/* PreHSW required 512K alignment, HSW requires 16M */
> +	ret = i915_gem_obj_ggtt_pin(bo, SZ_16M, 0);
> +	if (ret)
> +		goto err_unref;
> +
> +	dev_priv->oa_pmu.oa_buffer.gtt_offset = i915_gem_obj_ggtt_offset(bo);
> +	dev_priv->oa_pmu.oa_buffer.addr = vmap_oa_buffer(bo);

You can look forward to both i915_gem_object_create_internal() and
i915_gem_object_pin_vmap()

> +
> +	/* Pre-DevBDW: OABUFFER must be set with counters off,
> +	 * before OASTATUS1, but after OASTATUS2 */
> +	I915_WRITE(GEN7_OASTATUS2, dev_priv->oa_pmu.oa_buffer.gtt_offset |
> +		   GEN7_OASTATUS2_GGTT); /* head */
> +	I915_WRITE(GEN7_OABUFFER, dev_priv->oa_pmu.oa_buffer.gtt_offset);
> +	I915_WRITE(GEN7_OASTATUS1, dev_priv->oa_pmu.oa_buffer.gtt_offset |
> +		   GEN7_OASTATUS1_OABUFFER_SIZE_16M); /* tail */
> +
> +	DRM_DEBUG_DRIVER("OA Buffer initialized, gtt offset = 0x%x, vaddr = %p",
> +			 dev_priv->oa_pmu.oa_buffer.gtt_offset,
> +			 dev_priv->oa_pmu.oa_buffer.addr);
> +
> +	return 0;
> +
> +err_unref:
> +	drm_gem_object_unreference_unlocked(&bo->base);

But what I really what to say was:
mutex deadlock^^^
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
