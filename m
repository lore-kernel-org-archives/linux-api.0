From: Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v4 1/5] drm/rockchip: Add basic drm driver
Date: Mon, 22 Sep 2014 17:15:06 +0200
Message-ID: <20140922171506.31d59a76@bbrezillon>
References: <1411382820-1615-1-git-send-email-mark.yao@rock-chips.com>
	<1411382934-1763-1-git-send-email-mark.yao@rock-chips.com>
	<3036415.u40f3Xnhod@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3036415.u40f3Xnhod@wuerfel>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>, heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org, David Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rom Lemarchand <romlem-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, dbehr-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org, djkurtz-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, xjq-TNX95d0MmH7DzftRWevZcw@public.gmane.org, kfx-TNX95d0MmH7DzftRWevZcw@public.gmane.org, cym-TNX95d0MmH7DzftRWevZcw@public.gmane.org, cf-TNX95d0MmH7DzftRWevZcw@public.gmane.org, zyw@rock-
List-Id: linux-api@vger.kernel.org

On Mon, 22 Sep 2014 16:43:31 +0200
Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:

> On Monday 22 September 2014 18:48:54 Mark yao wrote:
> > diff --git a/drivers/gpu/drm/rockchip/Kconfig b/drivers/gpu/drm/rockchip/Kconfig
> > new file mode 100644
> > index 0000000..7146c80
> > --- /dev/null
> > +++ b/drivers/gpu/drm/rockchip/Kconfig
> > @@ -0,0 +1,19 @@
> > +config DRM_ROCKCHIP
> > +	tristate "DRM Support for Rockchip"
> > +	depends on DRM && ROCKCHIP_IOMMU
> > +	select ARM_DMA_USE_IOMMU
> > +	select IOMMU_API
> > +	select DRM_KMS_HELPER
> > +	select DRM_KMS_FB_HELPER
> > +	select DRM_PANEL
> > +	select FB_CFB_FILLRECT
> > +	select FB_CFB_COPYAREA
> > +	select FB_CFB_IMAGEBLIT
> > +	select VT_HW_CONSOLE_BINDING if FRAMEBUFFER_CONSOLE
> > +	select VIDEOMODE_HELPERS
> 
> Be careful with 'select', at least some of these should be 'depends on'.
> In particular IOMMU_API and ARM_DMA_USE_IOMMU, but possibly others
> as well. Just check how the symbols are used normally, if you get this
> wrong, we can end up with incorrect dependencies or loops.
> 
> > diff --git a/drivers/gpu/drm/rockchip/Makefile b/drivers/gpu/drm/rockchip/Makefile
> > new file mode 100644
> > index 0000000..6e6d468
> > --- /dev/null
> > +++ b/drivers/gpu/drm/rockchip/Makefile
> > @@ -0,0 +1,10 @@
> > +#
> > +# Makefile for the drm device driver.  This driver provides support for the
> > +# Direct Rendering Infrastructure (DRI) in XFree86 4.1.0 and higher.
> > +
> > +ccflags-y := -Iinclude/drm -Idrivers/gpu/drm/rockchip
> 
> The second one should not be required.
> 
> > +static int rockchip_drm_load(struct drm_device *drm_dev, unsigned long flags)
> > +{
> > +	struct rockchip_drm_private *private;
> > +	struct dma_iommu_mapping *mapping;
> > +	struct device *dev = drm_dev->dev;
> > +	int ret;
> > +
> > +	private = devm_kzalloc(drm_dev->dev, sizeof(*private), GFP_KERNEL);
> > +	if (!private)
> > +		return -ENOMEM;
> > +
> > +	dev_set_drvdata(drm_dev->dev, dev);
> > +	drm_dev->dev_private = private;
> > +
> > +	drm_mode_config_init(drm_dev);
> > +
> > +	rockchip_drm_mode_config_init(drm_dev);
> > +
> > +	dev->dma_parms = devm_kzalloc(dev, sizeof(*dev->dma_parms),
> > +				      GFP_KERNEL);
> > +	if (!dev->dma_parms) {
> > +		ret = -ENOMEM;
> > +		goto err_config_cleanup;
> > +	}
> > +
> > +	/* TODO(djkurtz): fetch the mapping start/size from somewhere */
> > +	mapping = arm_iommu_create_mapping(&platform_bus_type, 0x10000000,
> > +					   SZ_1G);
> > +	if (IS_ERR(mapping)) {
> > +		ret = PTR_ERR(mapping);
> > +		goto err_config_cleanup;
> > +	}
> > +
> > +	dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
> 
> This is the default coherent mask. If you call this function, you
> should normally check the return value, or call dma_set_mask first,
> which you apparently don't do here, and in another place in this
> patch.

By "This is the default mask" do you mean it shouldn't be called at
all ? Cause I ran into some trouble when not calling this in my
atmel-hlcdc driver.
Actually, in my case the platform device is created by the MFD core
which seems to let the coherent_dma_mask uninitialized.

Best Regards,

Boris


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
