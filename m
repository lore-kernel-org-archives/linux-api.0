From: Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v4 1/5] drm/rockchip: Add basic drm driver
Date: Mon, 22 Sep 2014 15:24:48 +0200
Message-ID: <20140922152448.5c5cd178@bbrezillon>
References: <1411382820-1615-1-git-send-email-mark.yao@rock-chips.com>
	<1411382934-1763-1-git-send-email-mark.yao@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1411382934-1763-1-git-send-email-mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Cc: heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org, David Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rom Lemarchand <romlem-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, dbehr-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org, djkurtz-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, xjq-TNX95d0MmH7DzftRWevZcw@public.gmane.org, kfx-TNX95d0MmH7DzftRWevZcw@public.gmane.org, cym-TNX95d0MmH7DzftRWevZcw@public.gmane.org, cf-TNX95d0MmH7DzftRWevZcw@public.gmane.org, zyw-TNX95d0MmH7DzftRWevZcw@public.gmane.org, xxm-TNX95d0MmH7DzftRWevZcw@public.gmane.org, huang
List-Id: linux-api@vger.kernel.org

Hi Mark,

You'll find some comments inline.
Anyway, I wouldn't call it a review (your driver is using some concepts
I'm not used to, like IOMMUs) but rather a collection of nitpicks :-).

I haven't been through the whole driver yet, but I'll get back to it
soon ;-).

And remember this is a 2 way thing, I wait for your review too
(here is the last version of my driver [1]) :-)


On Mon, 22 Sep 2014 18:48:54 +0800
Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org> wrote:

> This patch adds the basic structure of a DRM Driver for Rockchip Socs.
> 
> Signed-off-by: Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
> ---
> Changes in v2:
> - use the component framework to defer main drm driver probe
>   until all VOP devices have been probed.
> - use dma-mapping API with ARM_DMA_USE_IOMMU, create dma mapping by
>   master device and each vop device can shared the drm dma mapping.
> - use drm_crtc_init_with_planes and drm_universal_plane_init.
> - remove unnecessary middle layers.
> - add cursor set, move funcs to rockchip drm crtc.
> - use vop reset at first init
> - reference framebuffer when used and unreference when swap out vop
> 
> Changes in v3:
> - change "crtc->fb" to "crtc->primary-fb"
> Adviced by Daniel Vetter
> - init cursor plane with universal api, remove unnecessary cursor set,move 
> 
> Changes in v4:
> Adviced by David Herrmann
> - remove drm_platform_*() usage, use register drm device directly.
> Adviced by Rob Clark
> - remove special mmap ioctl, do userspace mmap with normal mmap() or mmap offset
> 
>  drivers/gpu/drm/Kconfig                       |    2 +
>  drivers/gpu/drm/Makefile                      |    1 +
>  drivers/gpu/drm/rockchip/Kconfig              |   19 +
>  drivers/gpu/drm/rockchip/Makefile             |   10 +
>  drivers/gpu/drm/rockchip/rockchip_drm_drv.c   |  524 ++++++++++
>  drivers/gpu/drm/rockchip/rockchip_drm_drv.h   |  120 +++
>  drivers/gpu/drm/rockchip/rockchip_drm_fb.c    |  201 ++++
>  drivers/gpu/drm/rockchip/rockchip_drm_fb.h    |   28 +
>  drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c |  231 +++++
>  drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h |   20 +
>  drivers/gpu/drm/rockchip/rockchip_drm_gem.c   |  404 ++++++++
>  drivers/gpu/drm/rockchip/rockchip_drm_gem.h   |   72 ++
>  drivers/gpu/drm/rockchip/rockchip_drm_vop.c   | 1372 +++++++++++++++++++++++++
>  drivers/gpu/drm/rockchip/rockchip_drm_vop.h   |  187 ++++
>  include/uapi/drm/rockchip_drm.h               |   75 ++
>  15 files changed, 3266 insertions(+)
>  create mode 100644 drivers/gpu/drm/rockchip/Kconfig
>  create mode 100644 drivers/gpu/drm/rockchip/Makefile
>  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_drv.c
>  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_drv.h
>  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fb.c
>  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fb.h
>  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c
>  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h
>  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_gem.c
>  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_gem.h
>  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_vop.c
>  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_vop.h
>  create mode 100644 include/uapi/drm/rockchip_drm.h
> 
> diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
> index b066bb3..7c4c3c6 100644
> --- a/drivers/gpu/drm/Kconfig
> +++ b/drivers/gpu/drm/Kconfig
> @@ -171,6 +171,8 @@ config DRM_SAVAGE
>  
>  source "drivers/gpu/drm/exynos/Kconfig"
>  
> +source "drivers/gpu/drm/rockchip/Kconfig"
> +
>  source "drivers/gpu/drm/vmwgfx/Kconfig"
>  
>  source "drivers/gpu/drm/gma500/Kconfig"
> diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
> index 4a55d59..d03387a 100644
> --- a/drivers/gpu/drm/Makefile
> +++ b/drivers/gpu/drm/Makefile
> @@ -52,6 +52,7 @@ obj-$(CONFIG_DRM_VMWGFX)+= vmwgfx/
>  obj-$(CONFIG_DRM_VIA)	+=via/
>  obj-$(CONFIG_DRM_NOUVEAU) +=nouveau/
>  obj-$(CONFIG_DRM_EXYNOS) +=exynos/
> +obj-$(CONFIG_DRM_ROCKCHIP) +=rockchip/
>  obj-$(CONFIG_DRM_GMA500) += gma500/
>  obj-$(CONFIG_DRM_UDL) += udl/
>  obj-$(CONFIG_DRM_AST) += ast/
> diff --git a/drivers/gpu/drm/rockchip/Kconfig b/drivers/gpu/drm/rockchip/Kconfig
> new file mode 100644
> index 0000000..7146c80
> --- /dev/null
> +++ b/drivers/gpu/drm/rockchip/Kconfig
> @@ -0,0 +1,19 @@
> +config DRM_ROCKCHIP
> +	tristate "DRM Support for Rockchip"
> +	depends on DRM && ROCKCHIP_IOMMU
> +	select ARM_DMA_USE_IOMMU
> +	select IOMMU_API
> +	select DRM_KMS_HELPER
> +	select DRM_KMS_FB_HELPER
> +	select DRM_PANEL
> +	select FB_CFB_FILLRECT
> +	select FB_CFB_COPYAREA
> +	select FB_CFB_IMAGEBLIT
> +	select VT_HW_CONSOLE_BINDING if FRAMEBUFFER_CONSOLE
> +	select VIDEOMODE_HELPERS
> +	help
> +	  Choose this option if you have a Rockchip soc chipset.
> +	  This driver provides kernel mode setting and buffer
> +	  management to userspace. This driver does not provides
> +	  2D or 3D acceleration; acceleration is performed by other
> +	  IP found on the SoC.
> diff --git a/drivers/gpu/drm/rockchip/Makefile b/drivers/gpu/drm/rockchip/Makefile
> new file mode 100644
> index 0000000..6e6d468
> --- /dev/null
> +++ b/drivers/gpu/drm/rockchip/Makefile
> @@ -0,0 +1,10 @@
> +#
> +# Makefile for the drm device driver.  This driver provides support for the
> +# Direct Rendering Infrastructure (DRI) in XFree86 4.1.0 and higher.
> +
> +ccflags-y := -Iinclude/drm -Idrivers/gpu/drm/rockchip

Do you really need those specific CFLAGS (AFAIK, these path are
already set, though you'll have to include <drm/xxx.h> instead of
"xxx.h" if you're referencing drm headers, but you're already
referencing the correct patch anyway) ?

> +
> +rockchipdrm-y := rockchip_drm_drv.o rockchip_drm_fb.o rockchip_drm_fbdev.o \
> +		rockchip_drm_gem.o rockchip_drm_vop.o
> +
> +obj-$(CONFIG_DRM_ROCKCHIP) += rockchipdrm.o
> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_drv.c b/drivers/gpu/drm/rockchip/rockchip_drm_drv.c
> new file mode 100644
> index 0000000..94926cb
> --- /dev/null
> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_drv.c
> @@ -0,0 +1,524 @@
> +/*
> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
> + * Author:Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
> + *
> + * based on exynos_drm_drv.c
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +

[...]

> +
> +static int rockchip_drm_load(struct drm_device *drm_dev, unsigned long flags)
> +{
> +	struct rockchip_drm_private *private;
> +	struct dma_iommu_mapping *mapping;
> +	struct device *dev = drm_dev->dev;
> +	int ret;
> +
> +	private = devm_kzalloc(drm_dev->dev, sizeof(*private), GFP_KERNEL);
> +	if (!private)
> +		return -ENOMEM;
> +
> +	dev_set_drvdata(drm_dev->dev, dev);
> +	drm_dev->dev_private = private;
> +
> +	drm_mode_config_init(drm_dev);
> +
> +	rockchip_drm_mode_config_init(drm_dev);
> +
> +	dev->dma_parms = devm_kzalloc(dev, sizeof(*dev->dma_parms),
> +				      GFP_KERNEL);
> +	if (!dev->dma_parms) {
> +		ret = -ENOMEM;
> +		goto err_config_cleanup;
> +	}
> +
> +	/* TODO(djkurtz): fetch the mapping start/size from somewhere */
> +	mapping = arm_iommu_create_mapping(&platform_bus_type, 0x10000000,
> +					   SZ_1G);
> +	if (IS_ERR(mapping)) {
> +		ret = PTR_ERR(mapping);
> +		goto err_config_cleanup;
> +	}
> +
> +	dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
> +	dma_set_max_seg_size(dev, 0xffffffffu);
> +
> +	ret = arm_iommu_attach_device(dev, mapping);
> +	if (ret)
> +		goto err_release_mapping;
> +
> +	/* Try to bind all sub drivers. */
> +	ret = component_bind_all(dev, drm_dev);
> +	if (ret)
> +		goto err_detach_device;
> +
> +	/* init kms poll for handling hpd */
> +	drm_kms_helper_poll_init(drm_dev);
> +
> +	/*
> +	 * enable drm irq mode.
> +	 * - with irq_enabled = true, we can use the vblank feature.
> +	 */
> +	drm_dev->irq_enabled = true;
> +
> +	/*
> +	 * with vblank_disable_allowed = true, vblank interrupt will be disabled
> +	 * by drm timer once a current process gives up ownership of
> +	 * vblank event.(after drm_vblank_put function is called)
> +	 */
> +	drm_dev->vblank_disable_allowed = true;
> +
> +	ret = drm_vblank_init(drm_dev, ROCKCHIP_MAX_CRTC);
> +	if (ret)
> +		goto err_kms_helper_poll_fini;
> +
> +	rockchip_drm_fbdev_init(drm_dev);
> +
> +	/* force connectors detection */
> +	drm_helper_hpd_irq_event(drm_dev);
> +
> +	return 0;
> +
> +err_kms_helper_poll_fini:
> +	drm_kms_helper_poll_fini(drm_dev);
> +	component_unbind_all(dev, drm_dev);
> +err_detach_device:
> +	arm_iommu_detach_device(dev);
> +err_release_mapping:
> +	arm_iommu_release_mapping(dev->archdata.mapping);
> +err_config_cleanup:
> +	drm_mode_config_cleanup(drm_dev);
> +	drm_dev->dev_private = NULL;
> +	dev_set_drvdata(dev, NULL);


Not sure you need to set driver data to NULL.


> +	return ret;
> +}
> +

[...]

> +
> +#ifdef CONFIG_PM_SLEEP
> +static int rockchip_drm_sys_suspend(struct device *dev)
> +{
> +	struct drm_device *drm_dev = dev_get_drvdata(dev);
> +	pm_message_t message;
> +
> +	if (pm_runtime_suspended(dev))
> +		return 0;
> +
> +	message.event = PM_EVENT_SUSPEND;
> +
> +	return rockchip_drm_suspend(drm_dev, message);
> +}
> +
> +static int rockchip_drm_sys_resume(struct device *dev)
> +{
> +	struct drm_device *drm_dev = dev_get_drvdata(dev);
> +
> +	if (pm_runtime_suspended(dev))

You meant

	if (!pm_runtime_suspended(dev))

right ?

BTW, I see the same mistake in exynos driver [2]


> +		return 0;
> +
> +	return rockchip_drm_resume(drm_dev);
> +}
> +#endif
> +
> +static const struct dev_pm_ops rockchip_drm_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(rockchip_drm_sys_suspend,
> +				rockchip_drm_sys_resume)
> +};
> +
> +int rockchip_drm_add_crtc(struct drm_device *drm, struct drm_crtc *crtc,
> +			  struct device_node *np)
> +{
> +	struct rockchip_drm_private *priv = drm->dev_private;
> +	struct device_node *port;
> +	int pipe;
> +
> +	if (priv->num_pipe >= ROCKCHIP_MAX_CRTC)
> +		return -EINVAL;
> +
> +	port = of_get_child_by_name(np, "port");
> +	of_node_put(np);

Not sure you should call of_node_put on a node pointer passed as an
argument (unless you previously called of_node_get which is not the case
in this function)...


Best Regards,

Boris

[1]http://thread.gmane.org/gmane.comp.video.dri.devel/114064
[2]https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/drivers/gpu/drm/exynos/exynos_drm_drv.c?id=refs/tags/next-20140922#n373
-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
