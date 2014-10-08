From: Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Subject: Re: [PATCH v10 1/3] drm: rockchip: Add basic drm driver
Date: Wed, 08 Oct 2014 17:29:43 +0800
Message-ID: <54350407.3050905@rock-chips.com>
References: <1412742179-32761-1-git-send-email-mark.yao@rock-chips.com> <1412742228-355-1-git-send-email-mark.yao@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412742228-355-1-git-send-email-mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org, Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, David Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rom Lemarchand <romlem-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, dbehr-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org, djkurtz-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, xjq-TNX95d0MmH7DzftRWevZcw@public.gmane.org, kfx-TNX95d0MmH7DzftRWevZcw@public.gmane.org, cym-TNX95d0MmH7DzftRWevZcw@public.gmane.org, cf-TNX95d0MmH7DzftRWevZcw@public.gmane.org, zyw-TNX95d0MmH7DzftRWevZcw@public.gmane.org, xxm-TNX95d0MmH7DzftRWevZcw@public.gmane.org, huangtao-TNX95d0MmH7DzftRWevZcw@public.gmane.org, kever.yang-TNX95d0MmH7DzftRWevZcw@public.gmane.org, yxj-TNX95d0MmH7DzftRWevZcw@public.gmane.org, wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org, xw-TNX95d0MmH7DzftRWevZcw@public.gmane.org, Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 2014=E5=B9=B410=E6=9C=8808=E6=97=A5 12:23, Mark Yao wrote:
> From: Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
>
> This patch adds the basic structure of a DRM Driver for Rockchip Socs=
=2E
>
> Signed-off-by: Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
> Signed-off-by: Daniel Kurtz <djkurtz-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Acked-by: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
> Reviewed-by: Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> Changes in v2:
> - use the component framework to defer main drm driver probe
>    until all VOP devices have been probed.
> - use dma-mapping API with ARM_DMA_USE_IOMMU, create dma mapping by
>    master device and each vop device can shared the drm dma mapping.
> - use drm_crtc_init_with_planes and drm_universal_plane_init.
> - remove unnecessary middle layers.
> - add cursor set, move funcs to rockchip drm crtc.
> - use vop reset at first init
> - reference framebuffer when used and unreference when swap out vop
>
> Changes in v3:
> - change "crtc->fb" to "crtc->primary-fb"
> Adviced by Daniel Vetter
> - init cursor plane with universal api, remove unnecessary cursor set=
,move
>
> Changes in v4:
> Adviced by David Herrmann
> - remove drm_platform_*() usage, use register drm device directly.
> Adviced by Rob Clark
> - remove special mmap ioctl, do userspace mmap with normal mmap() or =
mmap offset
>
> Changes in v5:
> Adviced by Arnd Bergmann
> - doing DMA start with a 32-bit masks with dma_mask and dma_coherent_=
mark
> - fix some incorrect dependencies.
> Adviced by Boris BREZILLON
> - fix some mistake and bugs.
> Adviced by Daniel Vetter
> - drop all special ioctl and use generic kms ioctl instead.
> Adviced by Rob Clark
> - use unlocked api for drm_fb_helper_restore_fbdev_mode.
> - remove unused rockchip_gem_prime_import_sg_table.
>
> Changes in v6:
> - set gem buffer pitch 64 bytes align, needed by mali gpu.
> Adviced by Daniel Kurtz
> - fix some mistake, bugs, remove unused define, more better code styl=
e etc.
> - use clk_prepare()/unprepare() at probe()/remove() and clk_enable()/=
disable()
>    at runtime instead of clk_prepare_enable().
> - provide a help function from vop for encoder to do mode config, ins=
tead of
>    using drm_diaplay_mode private method.
> - change vop mode_set timing to make it more safely.
>
> Changes in v7:
> - fix memory leakage problem
>
> Changes in v8:
> - fix iommu crash when use dual crtc.
> - use frame start interrupt for vsync instead of line flag interrupt,
> because the win config take affect at frame start time, if we use lin=
g flag
> interrupt, the address check often failed.
> Adviced by Daniel Kurtz
> - fix some bugs, mistake, remove unused function
> - keep clock and vop disabled when probe end
> - use drm_plane_helper_check_update to check update_plane if vaild
>
> Changes in v9:
> - fix suspend and resume bug, make iommu attach and detach safely.
>
> Changes in v10:
> Adviced by Andrzej Hajda
> - check drm_dev if it's NULL at PM suspend/resume
> Adviced by Sean Paul
> - use drm_fb_helper_prepare to init fb_helper funcs
> - Optimized code structure and remove some unnecessary Variables.
>
>   drivers/gpu/drm/Kconfig                       |    2 +
>   drivers/gpu/drm/Makefile                      |    1 +
>   drivers/gpu/drm/rockchip/Kconfig              |   17 +
>   drivers/gpu/drm/rockchip/Makefile             |    8 +
>   drivers/gpu/drm/rockchip/rockchip_drm_drv.c   |  465 ++++++++
>   drivers/gpu/drm/rockchip/rockchip_drm_drv.h   |   55 +
>   drivers/gpu/drm/rockchip/rockchip_drm_fb.c    |  200 ++++
>   drivers/gpu/drm/rockchip/rockchip_drm_fb.h    |   28 +
>   drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c |  210 ++++
>   drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h |   20 +
>   drivers/gpu/drm/rockchip/rockchip_drm_gem.c   |  294 +++++
>   drivers/gpu/drm/rockchip/rockchip_drm_gem.h   |   54 +
>   drivers/gpu/drm/rockchip/rockchip_drm_vop.c   | 1415 ++++++++++++++=
+++++++++++
>   drivers/gpu/drm/rockchip/rockchip_drm_vop.h   |  196 ++++
>   14 files changed, 2965 insertions(+)
>   create mode 100644 drivers/gpu/drm/rockchip/Kconfig
>   create mode 100644 drivers/gpu/drm/rockchip/Makefile
>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_drv.c
>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_drv.h
>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fb.c
>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fb.h
>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c
>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h
>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_gem.c
>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_gem.h
>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_vop.c
>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_vop.h
>
> diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
> index b066bb3..7c4c3c6 100644
> --- a/drivers/gpu/drm/Kconfig
> +++ b/drivers/gpu/drm/Kconfig
> @@ -171,6 +171,8 @@ config DRM_SAVAGE
>  =20
>   source "drivers/gpu/drm/exynos/Kconfig"
>  =20
> +source "drivers/gpu/drm/rockchip/Kconfig"
> +
>   source "drivers/gpu/drm/vmwgfx/Kconfig"
>  =20
>   source "drivers/gpu/drm/gma500/Kconfig"
> diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
> index 4a55d59..d03387a 100644
> --- a/drivers/gpu/drm/Makefile
> +++ b/drivers/gpu/drm/Makefile
> @@ -52,6 +52,7 @@ obj-$(CONFIG_DRM_VMWGFX)+=3D vmwgfx/
>   obj-$(CONFIG_DRM_VIA)	+=3Dvia/
>   obj-$(CONFIG_DRM_NOUVEAU) +=3Dnouveau/
>   obj-$(CONFIG_DRM_EXYNOS) +=3Dexynos/
> +obj-$(CONFIG_DRM_ROCKCHIP) +=3Drockchip/
>   obj-$(CONFIG_DRM_GMA500) +=3D gma500/
>   obj-$(CONFIG_DRM_UDL) +=3D udl/
>   obj-$(CONFIG_DRM_AST) +=3D ast/
> diff --git a/drivers/gpu/drm/rockchip/Kconfig b/drivers/gpu/drm/rockc=
hip/Kconfig
> new file mode 100644
> index 0000000..0ff6682
> --- /dev/null
> +++ b/drivers/gpu/drm/rockchip/Kconfig
> @@ -0,0 +1,17 @@
> +config DRM_ROCKCHIP
> +	tristate "DRM Support for Rockchip"
> +	depends on DRM && ROCKCHIP_IOMMU && ARM_DMA_USE_IOMMU && IOMMU_API
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
> +	  management to userspace. This driver does not provide
> +	  2D or 3D acceleration; acceleration is performed by other
> +	  IP found on the SoC.
> diff --git a/drivers/gpu/drm/rockchip/Makefile b/drivers/gpu/drm/rock=
chip/Makefile
> new file mode 100644
> index 0000000..b3a5193
> --- /dev/null
> +++ b/drivers/gpu/drm/rockchip/Makefile
> @@ -0,0 +1,8 @@
> +#
> +# Makefile for the drm device driver.  This driver provides support =
for the
> +# Direct Rendering Infrastructure (DRI) in XFree86 4.1.0 and higher.
> +
> +rockchipdrm-y :=3D rockchip_drm_drv.o rockchip_drm_fb.o rockchip_drm=
_fbdev.o \
> +		rockchip_drm_gem.o rockchip_drm_vop.o
> +
> +obj-$(CONFIG_DRM_ROCKCHIP) +=3D rockchipdrm.o
> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_drv.c b/drivers/gp=
u/drm/rockchip/rockchip_drm_drv.c
> new file mode 100644
> index 0000000..480b6ba
> --- /dev/null
> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_drv.c
> @@ -0,0 +1,465 @@
> +/*
> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
> + * Author:Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
> + *
> + * based on exynos_drm_drv.c
> + *
> + * This software is licensed under the terms of the GNU General Publ=
ic
> + * License version 2, as published by the Free Software Foundation, =
and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <asm/dma-iommu.h>
> +
> +#include <drm/drmP.h>
> +#include <drm/drm_crtc_helper.h>
> +#include <drm/drm_fb_helper.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/of_graph.h>
> +#include <linux/component.h>
> +
> +#include "rockchip_drm_drv.h"
> +#include "rockchip_drm_fb.h"
> +#include "rockchip_drm_fbdev.h"
> +#include "rockchip_drm_gem.h"
> +
> +#define DRIVER_NAME	"rockchip"
> +#define DRIVER_DESC	"RockChip Soc DRM"
> +#define DRIVER_DATE	"20140818"
> +#define DRIVER_MAJOR	1
> +#define DRIVER_MINOR	0
> +
> +/*
> + * Attach a (component) device to the shared drm dma mapping from ma=
ster drm
> + * device.  This is used by the VOPs to map GEM buffers to a common =
DMA
> + * mapping.
> + */
> +int rockchip_drm_dma_attach_device(struct drm_device *drm_dev,
> +				   struct device *dev)
> +{
> +	struct dma_iommu_mapping *mapping =3D drm_dev->dev->archdata.mappin=
g;
> +	int ret;
> +
> +	ret =3D dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
> +	if (ret)
> +		return ret;
> +
> +	dma_set_max_seg_size(dev, DMA_BIT_MASK(32));
> +
> +	return arm_iommu_attach_device(dev, mapping);
> +}
> +
> +void rockchip_drm_dma_detach_device(struct drm_device *drm_dev,
> +				    struct device *dev)
> +{
> +	arm_iommu_detach_device(dev);
> +}
> +
> +static int rockchip_drm_load(struct drm_device *drm_dev, unsigned lo=
ng flags)
> +{
> +	struct rockchip_drm_private *private;
> +	struct dma_iommu_mapping *mapping;
> +	struct device *dev =3D drm_dev->dev;
> +	int ret;
> +
> +	private =3D devm_kzalloc(drm_dev->dev, sizeof(*private), GFP_KERNEL=
);
> +	if (!private)
> +		return -ENOMEM;
> +
> +	drm_dev->dev_private =3D private;
> +
> +	drm_mode_config_init(drm_dev);
> +
> +	rockchip_drm_mode_config_init(drm_dev);
> +
> +	dev->dma_parms =3D devm_kzalloc(dev, sizeof(*dev->dma_parms),
> +				      GFP_KERNEL);
> +	if (!dev->dma_parms) {
> +		ret =3D -ENOMEM;
> +		goto err_config_cleanup;
> +	}
> +
> +	/* TODO(djkurtz): fetch the mapping start/size from somewhere */
> +	mapping =3D arm_iommu_create_mapping(&platform_bus_type, 0x00000000=
,
> +					   SZ_2G);
> +	if (IS_ERR(mapping)) {
> +		ret =3D PTR_ERR(mapping);
> +		goto err_config_cleanup;
> +	}
> +
> +	ret =3D dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
> +	if (ret)
> +		goto err_release_mapping;
> +
> +	dma_set_max_seg_size(dev, DMA_BIT_MASK(32));
> +
> +	ret =3D arm_iommu_attach_device(dev, mapping);
> +	if (ret)
> +		goto err_release_mapping;
> +
> +	/* Try to bind all sub drivers. */
> +	ret =3D component_bind_all(dev, drm_dev);
> +	if (ret)
> +		goto err_detach_device;
> +
> +	/* init kms poll for handling hpd */
> +	drm_kms_helper_poll_init(drm_dev);
> +
> +	/*
> +	 * enable drm irq mode.
> +	 * - with irq_enabled =3D true, we can use the vblank feature.
> +	 */
> +	drm_dev->irq_enabled =3D true;
> +
> +	/*
> +	 * with vblank_disable_allowed =3D true, vblank interrupt will be d=
isabled
> +	 * by drm timer once a current process gives up ownership of
> +	 * vblank event.(after drm_vblank_put function is called)
> +	 */
> +	drm_dev->vblank_disable_allowed =3D true;
> +
> +	ret =3D drm_vblank_init(drm_dev, ROCKCHIP_MAX_CRTC);
> +	if (ret)
> +		goto err_kms_helper_poll_fini;
> +
> +	rockchip_drm_fbdev_init(drm_dev);
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
> +	drm_dev->dev_private =3D NULL;
> +	return ret;
> +}
> +
> +static int rockchip_drm_unload(struct drm_device *drm_dev)
> +{
> +	struct device *dev =3D drm_dev->dev;
> +
> +	drm_kms_helper_poll_fini(drm_dev);
> +	component_unbind_all(dev, drm_dev);
> +	arm_iommu_detach_device(dev);
> +	arm_iommu_release_mapping(dev->archdata.mapping);
> +	drm_mode_config_cleanup(drm_dev);
> +	drm_dev->dev_private =3D NULL;
> +
> +	return 0;
> +}
> +
> +void rockchip_drm_lastclose(struct drm_device *dev)
> +{
> +	struct rockchip_drm_private *priv =3D dev->dev_private;
> +
> +	drm_fb_helper_restore_fbdev_mode_unlocked(&priv->fbdev_helper);
> +}
> +
> +static const struct file_operations rockchip_drm_driver_fops =3D {
> +	.owner =3D THIS_MODULE,
> +	.open =3D drm_open,
> +	.mmap =3D rockchip_gem_mmap,
> +	.poll =3D drm_poll,
> +	.read =3D drm_read,
> +	.unlocked_ioctl =3D drm_ioctl,
> +#ifdef CONFIG_COMPAT
> +	.compat_ioctl =3D drm_compat_ioctl,
> +#endif
> +	.release =3D drm_release,
> +};
> +
> +const struct vm_operations_struct rockchip_drm_vm_ops =3D {
> +	.open =3D drm_gem_vm_open,
> +	.close =3D drm_gem_vm_close,
> +};
> +
> +static struct drm_driver rockchip_drm_driver =3D {
> +	.driver_features	=3D DRIVER_MODESET | DRIVER_GEM | DRIVER_PRIME,
> +	.load			=3D rockchip_drm_load,
> +	.unload			=3D rockchip_drm_unload,
> +	.lastclose		=3D rockchip_drm_lastclose,
> +	.get_vblank_counter	=3D drm_vblank_count,
> +	.enable_vblank		=3D rockchip_drm_crtc_enable_vblank,
> +	.disable_vblank		=3D rockchip_drm_crtc_disable_vblank,
> +	.gem_vm_ops		=3D &rockchip_drm_vm_ops,
> +	.gem_free_object	=3D rockchip_gem_free_object,
> +	.dumb_create		=3D rockchip_gem_dumb_create,
> +	.dumb_map_offset	=3D rockchip_gem_dumb_map_offset,
> +	.dumb_destroy		=3D drm_gem_dumb_destroy,
> +	.prime_handle_to_fd	=3D drm_gem_prime_handle_to_fd,
> +	.prime_fd_to_handle	=3D drm_gem_prime_fd_to_handle,
> +	.gem_prime_import	=3D drm_gem_prime_import,
> +	.gem_prime_export	=3D drm_gem_prime_export,
> +	.gem_prime_get_sg_table	=3D rockchip_gem_prime_get_sg_table,
> +	.gem_prime_vmap		=3D rockchip_gem_prime_vmap,
> +	.gem_prime_vunmap	=3D rockchip_gem_prime_vunmap,
> +	.fops			=3D &rockchip_drm_driver_fops,
> +	.name	=3D DRIVER_NAME,
> +	.desc	=3D DRIVER_DESC,
> +	.date	=3D DRIVER_DATE,
> +	.major	=3D DRIVER_MAJOR,
> +	.minor	=3D DRIVER_MINOR,
> +};
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int rockchip_drm_sys_suspend(struct device *dev)
> +{
> +	struct drm_device *drm_dev =3D dev_get_drvdata(dev);
> +	struct drm_connector *connector;
> +
> +	if (pm_runtime_suspended(dev) || !drm_dev)
> +		return 0;
> +
> +	drm_modeset_lock_all(dev);
Oh, sorry, I make a mistake here, the drm_modeset_lock_all(...) need=20
drm_dev not dev;
> +	list_for_each_entry(connector, &dev->mode_config.connector_list, he=
ad) {
> +		int old_dpms =3D connector->dpms;
> +
> +		if (connector->funcs->dpms)
> +			connector->funcs->dpms(connector, DRM_MODE_DPMS_OFF);
> +
> +		/* Set the old mode back to the connector for resume */
> +		connector->dpms =3D old_dpms;
> +	}
> +	drm_modeset_unlock_all(dev);
> +
> +	return 0;
> +}
> +
> +static int rockchip_drm_sys_resume(struct device *dev)
> +{
> +	struct drm_device *drm_dev =3D dev_get_drvdata(dev);
> +	struct drm_connector *connector;
> +
> +	if (!pm_runtime_suspended(dev) || !drm_dev)
> +		return 0;
> +
> +	drm_modeset_lock_all(dev);
> +	list_for_each_entry(connector, &dev->mode_config.connector_list, he=
ad) {
> +		if (connector->funcs->dpms)
> +			connector->funcs->dpms(connector, connector->dpms);
> +	}
> +	drm_modeset_unlock_all(dev);
> +
> +	drm_helper_resume_force_mode(dev);
> +
> +	return 0;
> +}
> +#endif
> +
> +static const struct dev_pm_ops rockchip_drm_pm_ops =3D {
> +	SET_SYSTEM_SLEEP_PM_OPS(rockchip_drm_sys_suspend,
> +				rockchip_drm_sys_resume)
> +};
> +
> +struct drm_crtc *rockchip_drm_find_crtc(struct drm_device *drm, int =
pipe)
> +{
> +	struct drm_crtc *c, *crtc =3D NULL;
> +	int i;
> +
> +	mutex_lock(&drm->mode_config.mutex);
> +	list_for_each_entry(c, &drm->mode_config.crtc_list, head)
> +		if (i++ =3D=3D pipe) {
> +			crtc =3D c;
> +			break;
> +		}
> +	mutex_unlock(&drm->mode_config.mutex);
> +
> +	return crtc;
> +}
> +
> +/*
> + * @node: device tree node containing encoder input ports
> + * @encoder: drm_encoder
> + */
> +int rockchip_drm_encoder_get_mux_id(struct device_node *node,
> +				    struct drm_encoder *encoder)
> +{
> +	struct device_node *ep =3D NULL;
> +	struct drm_crtc *crtc =3D encoder->crtc;
> +	struct of_endpoint endpoint;
> +	struct device_node *port;
> +	int ret;
> +
> +	if (!node || !crtc)
> +		return -EINVAL;
> +
> +	do {
> +		ep =3D of_graph_get_next_endpoint(node, ep);
> +		if (!ep)
> +			break;
> +
> +		port =3D of_graph_get_remote_port(ep);
> +		of_node_put(port);
> +		if (port =3D=3D crtc->port) {
> +			ret =3D of_graph_parse_endpoint(ep, &endpoint);
> +			return ret ?: endpoint.id;
> +		}
> +	} while (ep);
> +
> +	return -EINVAL;
> +}
> +
> +static int compare_of(struct device *dev, void *data)
> +{
> +	struct device_node *np =3D data;
> +
> +	return dev->of_node =3D=3D np;
> +}
> +
> +static void rockchip_add_endpoints(struct device *dev,
> +				   struct component_match **match,
> +				   struct device_node *port)
> +{
> +	struct device_node *ep, *remote;
> +
> +	for_each_child_of_node(port, ep) {
> +		remote =3D of_graph_get_remote_port_parent(ep);
> +		if (!remote || !of_device_is_available(remote)) {
> +			of_node_put(remote);
> +			continue;
> +		} else if (!of_device_is_available(remote->parent)) {
> +			dev_warn(dev, "parent device of %s is not available\n",
> +				 remote->full_name);
> +			of_node_put(remote);
> +			continue;
> +		}
> +
> +		component_match_add(dev, match, compare_of, remote);
> +		of_node_put(remote);
> +	}
> +}
> +
> +static int rockchip_drm_bind(struct device *dev)
> +{
> +	struct drm_device *drm;
> +	int ret;
> +
> +	drm =3D drm_dev_alloc(&rockchip_drm_driver, dev);
> +	if (!drm)
> +		return -ENOMEM;
> +
> +	ret =3D drm_dev_set_unique(drm, "%s", dev_name(dev));
> +	if (ret)
> +		goto err_free;
> +
> +	ret =3D drm_dev_register(drm, 0);
> +	if (ret)
> +		goto err_free;
> +
> +	dev_set_drvdata(dev, drm);
> +
> +	return 0;
> +
> +err_free:
> +	drm_dev_unref(drm);
> +	return ret;
> +}
> +
> +static void rockchip_drm_unbind(struct device *dev)
> +{
> +	struct drm_device *drm =3D dev_get_drvdata(dev);
> +
> +	drm_dev_unregister(drm);
> +	drm_dev_unref(drm);
> +	dev_set_drvdata(dev, NULL);
> +}
> +
> +static const struct component_master_ops rockchip_drm_ops =3D {
> +	.bind =3D rockchip_drm_bind,
> +	.unbind =3D rockchip_drm_unbind,
> +};
> +
> +static int rockchip_drm_platform_probe(struct platform_device *pdev)
> +{
> +	struct device *dev =3D &pdev->dev;
> +	struct component_match *match =3D NULL;
> +	struct device_node *np =3D dev->of_node;
> +	struct device_node *port;
> +	int i;
> +
> +	if (!np)
> +		return -ENODEV;
> +	/*
> +	 * Bind the crtc ports first, so that
> +	 * drm_of_find_possible_crtcs called from encoder .bind callbacks
> +	 * works as expected.
> +	 */
> +	for (i =3D 0;; i++) {
> +		port =3D of_parse_phandle(np, "ports", i);
> +		if (!port)
> +			break;
> +
> +		if (!of_device_is_available(port->parent)) {
> +			of_node_put(port);
> +			continue;
> +		}
> +
> +		component_match_add(dev, &match, compare_of, port->parent);
> +		of_node_put(port);
> +	}
> +
> +	if (i =3D=3D 0) {
> +		dev_err(dev, "missing 'ports' property\n");
> +		return -ENODEV;
> +	}
> +	/*
> +	 * For each bound crtc, bind the encoders attached to its
> +	 * remote endpoint.
> +	 */
> +	for (i =3D 0;; i++) {
> +		port =3D of_parse_phandle(np, "ports", i);
> +		if (!port)
> +			break;
> +
> +		if (!of_device_is_available(port->parent)) {
> +			of_node_put(port);
> +			continue;
> +		}
> +
> +		rockchip_add_endpoints(dev, &match, port);
> +		of_node_put(port);
> +	}
> +
> +	return component_master_add_with_match(dev, &rockchip_drm_ops, matc=
h);
> +}
> +
> +static int rockchip_drm_platform_remove(struct platform_device *pdev=
)
> +{
> +	component_master_del(&pdev->dev, &rockchip_drm_ops);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id rockchip_drm_dt_ids[] =3D {
> +	{ .compatible =3D "rockchip,display-subsystem", },
> +	{ /* sentinel */ },
> +};
> +MODULE_DEVICE_TABLE(of, rockchip_drm_dt_ids);
> +
> +static struct platform_driver rockchip_drm_platform_driver =3D {
> +	.probe =3D rockchip_drm_platform_probe,
> +	.remove =3D rockchip_drm_platform_remove,
> +	.driver =3D {
> +		.owner =3D THIS_MODULE,
> +		.name =3D "rockchip-drm",
> +		.of_match_table =3D rockchip_drm_dt_ids,
> +		.pm =3D &rockchip_drm_pm_ops,
> +	},
> +};
> +
> +module_platform_driver(rockchip_drm_platform_driver);
> +
> +MODULE_AUTHOR("Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>");
> +MODULE_DESCRIPTION("ROCKCHIP DRM Driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_drv.h b/drivers/gp=
u/drm/rockchip/rockchip_drm_drv.h
> new file mode 100644
> index 0000000..9fa82e2
> --- /dev/null
> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_drv.h
> @@ -0,0 +1,55 @@
> +/*
> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
> + * Author:Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
> + *
> + * based on exynos_drm_drv.h
> + *
> + * This software is licensed under the terms of the GNU General Publ=
ic
> + * License version 2, as published by the Free Software Foundation, =
and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef _ROCKCHIP_DRM_DRV_H
> +#define _ROCKCHIP_DRM_DRV_H
> +
> +#include <drm/drm_fb_helper.h>
> +
> +#include <linux/module.h>
> +#include <linux/component.h>
> +
> +#define ROCKCHIP_MAX_FB_BUFFER	3
> +#define ROCKCHIP_MAX_CONNECTOR	2
> +#define ROCKCHIP_MAX_CRTC	2
> +
> +struct drm_device;
> +struct drm_connector;
> +
> +/*
> + * Rockchip drm private structure.
> + *
> + * @crtc: array of enabled CRTCs, used to map from "pipe" to drm_crt=
c.
> + * @num_pipe: number of pipes for this device.
> + */
> +struct rockchip_drm_private {
> +	struct drm_fb_helper fbdev_helper;
> +	struct drm_gem_object *fbdev_bo;
> +};
> +
> +struct drm_crtc *rockchip_drm_find_crtc(struct drm_device *drm, int =
pipe);
> +int rockchip_drm_encoder_get_mux_id(struct device_node *node,
> +				    struct drm_encoder *encoder);
> +int rockchip_drm_crtc_mode_config(struct drm_crtc *crtc, int connect=
or_type,
> +				  int out_mode);
> +int rockchip_drm_crtc_enable_vblank(struct drm_device *dev, int pipe=
);
> +void rockchip_drm_crtc_disable_vblank(struct drm_device *dev, int pi=
pe);
> +int rockchip_drm_dma_attach_device(struct drm_device *drm_dev,
> +				   struct device *dev);
> +void rockchip_drm_dma_detach_device(struct drm_device *drm_dev,
> +				    struct device *dev);
> +
> +#endif /* _ROCKCHIP_DRM_DRV_H_ */
> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_fb.c b/drivers/gpu=
/drm/rockchip/rockchip_drm_fb.c
> new file mode 100644
> index 0000000..88e43c4
> --- /dev/null
> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_fb.c
> @@ -0,0 +1,200 @@
> +/*
> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
> + * Author:Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
> + *
> + * This software is licensed under the terms of the GNU General Publ=
ic
> + * License version 2, as published by the Free Software Foundation, =
and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <drm/drm.h>
> +#include <drm/drmP.h>
> +#include <drm/drm_fb_helper.h>
> +#include <drm/drm_crtc_helper.h>
> +
> +#include "rockchip_drm_drv.h"
> +#include "rockchip_drm_gem.h"
> +
> +#define to_rockchip_fb(x) container_of(x, struct rockchip_drm_fb, fb=
)
> +
> +struct rockchip_drm_fb {
> +	struct drm_framebuffer fb;
> +	struct drm_gem_object *obj[ROCKCHIP_MAX_FB_BUFFER];
> +};
> +
> +struct drm_gem_object *rockchip_fb_get_gem_obj(struct drm_framebuffe=
r *fb,
> +					       unsigned int plane)
> +{
> +	struct rockchip_drm_fb *rk_fb =3D to_rockchip_fb(fb);
> +
> +	if (plane >=3D ROCKCHIP_MAX_FB_BUFFER)
> +		return NULL;
> +
> +	return rk_fb->obj[plane];
> +}
> +
> +static void rockchip_drm_fb_destroy(struct drm_framebuffer *fb)
> +{
> +	struct rockchip_drm_fb *rockchip_fb =3D to_rockchip_fb(fb);
> +	struct drm_gem_object *obj;
> +	int i;
> +
> +	for (i =3D 0; i < ROCKCHIP_MAX_FB_BUFFER; i++) {
> +		obj =3D rockchip_fb->obj[i];
> +		if (obj)
> +			drm_gem_object_unreference_unlocked(obj);
> +	}
> +
> +	drm_framebuffer_cleanup(fb);
> +	kfree(rockchip_fb);
> +}
> +
> +static int rockchip_drm_fb_create_handle(struct drm_framebuffer *fb,
> +					 struct drm_file *file_priv,
> +					 unsigned int *handle)
> +{
> +	struct rockchip_drm_fb *rockchip_fb =3D to_rockchip_fb(fb);
> +
> +	return drm_gem_handle_create(file_priv,
> +				     rockchip_fb->obj[0], handle);
> +}
> +
> +static struct drm_framebuffer_funcs rockchip_drm_fb_funcs =3D {
> +	.destroy	=3D rockchip_drm_fb_destroy,
> +	.create_handle	=3D rockchip_drm_fb_create_handle,
> +};
> +
> +static struct rockchip_drm_fb *
> +rockchip_fb_alloc(struct drm_device *dev, struct drm_mode_fb_cmd2 *m=
ode_cmd,
> +		  struct drm_gem_object **obj, unsigned int num_planes)
> +{
> +	struct rockchip_drm_fb *rockchip_fb;
> +	int ret;
> +	int i;
> +
> +	rockchip_fb =3D kzalloc(sizeof(*rockchip_fb), GFP_KERNEL);
> +	if (!rockchip_fb)
> +		return ERR_PTR(-ENOMEM);
> +
> +	drm_helper_mode_fill_fb_struct(&rockchip_fb->fb, mode_cmd);
> +
> +	for (i =3D 0; i < num_planes; i++)
> +		rockchip_fb->obj[i] =3D obj[i];
> +
> +	ret =3D drm_framebuffer_init(dev, &rockchip_fb->fb,
> +				   &rockchip_drm_fb_funcs);
> +	if (ret) {
> +		dev_err(dev->dev, "Failed to initialize framebuffer: %d\n",
> +			ret);
> +		kfree(rockchip_fb);
> +		return ERR_PTR(ret);
> +	}
> +
> +	return rockchip_fb;
> +}
> +
> +static struct drm_framebuffer *
> +rockchip_user_fb_create(struct drm_device *dev, struct drm_file *fil=
e_priv,
> +			struct drm_mode_fb_cmd2 *mode_cmd)
> +{
> +	struct rockchip_drm_fb *rockchip_fb;
> +	struct drm_gem_object *objs[ROCKCHIP_MAX_FB_BUFFER];
> +	struct drm_gem_object *obj;
> +	unsigned int hsub;
> +	unsigned int vsub;
> +	int num_planes;
> +	int ret;
> +	int i;
> +
> +	hsub =3D drm_format_horz_chroma_subsampling(mode_cmd->pixel_format)=
;
> +	vsub =3D drm_format_vert_chroma_subsampling(mode_cmd->pixel_format)=
;
> +	num_planes =3D min(drm_format_num_planes(mode_cmd->pixel_format),
> +			 ROCKCHIP_MAX_FB_BUFFER);
> +
> +	for (i =3D 0; i < num_planes; i++) {
> +		unsigned int width =3D mode_cmd->width / (i ? hsub : 1);
> +		unsigned int height =3D mode_cmd->height / (i ? vsub : 1);
> +		unsigned int min_size;
> +
> +		obj =3D drm_gem_object_lookup(dev, file_priv,
> +					    mode_cmd->handles[i]);
> +		if (!obj) {
> +			dev_err(dev->dev, "Failed to lookup GEM object\n");
> +			ret =3D -ENXIO;
> +			goto err_gem_object_unreference;
> +		}
> +
> +		min_size =3D (height - 1) * mode_cmd->pitches[i] +
> +			mode_cmd->offsets[i] +
> +			width * drm_format_plane_cpp(mode_cmd->pixel_format, i);
> +
> +		if (obj->size < min_size) {
> +			drm_gem_object_unreference_unlocked(obj);
> +			ret =3D -EINVAL;
> +			goto err_gem_object_unreference;
> +		}
> +		objs[i] =3D obj;
> +	}
> +
> +	rockchip_fb =3D rockchip_fb_alloc(dev, mode_cmd, objs, i);
> +	if (IS_ERR(rockchip_fb)) {
> +		ret =3D PTR_ERR(rockchip_fb);
> +		goto err_gem_object_unreference;
> +	}
> +
> +	return &rockchip_fb->fb;
> +
> +err_gem_object_unreference:
> +	for (i--; i >=3D 0; i--)
> +		drm_gem_object_unreference_unlocked(objs[i]);
> +	return ERR_PTR(ret);
> +}
> +
> +static void rockchip_drm_output_poll_changed(struct drm_device *dev)
> +{
> +	struct rockchip_drm_private *private =3D dev->dev_private;
> +	struct drm_fb_helper *fb_helper =3D &private->fbdev_helper;
> +
> +	drm_fb_helper_hotplug_event(fb_helper);
> +}
> +
> +static const struct drm_mode_config_funcs rockchip_drm_mode_config_f=
uncs =3D {
> +	.fb_create =3D rockchip_user_fb_create,
> +	.output_poll_changed =3D rockchip_drm_output_poll_changed,
> +};
> +
> +struct drm_framebuffer *
> +rockchip_drm_framebuffer_init(struct drm_device *dev,
> +			      struct drm_mode_fb_cmd2 *mode_cmd,
> +			      struct drm_gem_object *obj)
> +{
> +	struct rockchip_drm_fb *rockchip_fb;
> +
> +	rockchip_fb =3D rockchip_fb_alloc(dev, mode_cmd, &obj, 1);
> +	if (IS_ERR(rockchip_fb))
> +		return NULL;
> +
> +	return &rockchip_fb->fb;
> +}
> +
> +void rockchip_drm_mode_config_init(struct drm_device *dev)
> +{
> +	dev->mode_config.min_width =3D 0;
> +	dev->mode_config.min_height =3D 0;
> +
> +	/*
> +	 * set max width and height as default value(4096x4096).
> +	 * this value would be used to check framebuffer size limitation
> +	 * at drm_mode_addfb().
> +	 */
> +	dev->mode_config.max_width =3D 4096;
> +	dev->mode_config.max_height =3D 4096;
> +
> +	dev->mode_config.funcs =3D &rockchip_drm_mode_config_funcs;
> +}
> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_fb.h b/drivers/gpu=
/drm/rockchip/rockchip_drm_fb.h
> new file mode 100644
> index 0000000..09574d4
> --- /dev/null
> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_fb.h
> @@ -0,0 +1,28 @@
> +/*
> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
> + * Author:Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
> + *
> + * This software is licensed under the terms of the GNU General Publ=
ic
> + * License version 2, as published by the Free Software Foundation, =
and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef _ROCKCHIP_DRM_FB_H
> +#define _ROCKCHIP_DRM_FB_H
> +
> +struct drm_framebuffer *
> +rockchip_drm_framebuffer_init(struct drm_device *dev,
> +			      struct drm_mode_fb_cmd2 *mode_cmd,
> +			      struct drm_gem_object *obj);
> +void rockchip_drm_framebuffer_fini(struct drm_framebuffer *fb);
> +
> +void rockchip_drm_mode_config_init(struct drm_device *dev);
> +
> +struct drm_gem_object *rockchip_fb_get_gem_obj(struct drm_framebuffe=
r *fb,
> +					       unsigned int plane);
> +#endif /* _ROCKCHIP_DRM_FB_H */
> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c b/drivers/=
gpu/drm/rockchip/rockchip_drm_fbdev.c
> new file mode 100644
> index 0000000..363db1e
> --- /dev/null
> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c
> @@ -0,0 +1,210 @@
> +/*
> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
> + * Author:Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
> + *
> + * This software is licensed under the terms of the GNU General Publ=
ic
> + * License version 2, as published by the Free Software Foundation, =
and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <drm/drm.h>
> +#include <drm/drmP.h>
> +#include <drm/drm_fb_helper.h>
> +#include <drm/drm_crtc_helper.h>
> +
> +#include "rockchip_drm_drv.h"
> +#include "rockchip_drm_gem.h"
> +#include "rockchip_drm_fb.h"
> +
> +#define PREFERRED_BPP		32
> +#define to_drm_private(x) \
> +		container_of(x, struct rockchip_drm_private, fbdev_helper)
> +
> +static int rockchip_fbdev_mmap(struct fb_info *info,
> +			       struct vm_area_struct *vma)
> +{
> +	struct drm_fb_helper *helper =3D info->par;
> +	struct rockchip_drm_private *private =3D to_drm_private(helper);
> +
> +	return rockchip_gem_mmap_buf(private->fbdev_bo, vma);
> +}
> +
> +static struct fb_ops rockchip_drm_fbdev_ops =3D {
> +	.owner		=3D THIS_MODULE,
> +	.fb_mmap	=3D rockchip_fbdev_mmap,
> +	.fb_fillrect	=3D cfb_fillrect,
> +	.fb_copyarea	=3D cfb_copyarea,
> +	.fb_imageblit	=3D cfb_imageblit,
> +	.fb_check_var	=3D drm_fb_helper_check_var,
> +	.fb_set_par	=3D drm_fb_helper_set_par,
> +	.fb_blank	=3D drm_fb_helper_blank,
> +	.fb_pan_display	=3D drm_fb_helper_pan_display,
> +	.fb_setcmap	=3D drm_fb_helper_setcmap,
> +};
> +
> +static int rockchip_drm_fbdev_create(struct drm_fb_helper *helper,
> +				     struct drm_fb_helper_surface_size *sizes)
> +{
> +	struct rockchip_drm_private *private =3D to_drm_private(helper);
> +	struct drm_mode_fb_cmd2 mode_cmd =3D { 0 };
> +	struct drm_device *dev =3D helper->dev;
> +	struct rockchip_gem_object *rk_obj;
> +	struct drm_framebuffer *fb;
> +	unsigned int bytes_per_pixel;
> +	unsigned long offset;
> +	struct fb_info *fbi;
> +	size_t size;
> +	int ret;
> +
> +	bytes_per_pixel =3D DIV_ROUND_UP(sizes->surface_bpp, 8);
> +
> +	mode_cmd.width =3D sizes->surface_width;
> +	mode_cmd.height =3D sizes->surface_height;
> +	mode_cmd.pitches[0] =3D sizes->surface_width * bytes_per_pixel;
> +	mode_cmd.pixel_format =3D drm_mode_legacy_fb_format(sizes->surface_=
bpp,
> +		sizes->surface_depth);
> +
> +	size =3D mode_cmd.pitches[0] * mode_cmd.height;
> +
> +	rk_obj =3D rockchip_gem_create_object(dev, size);
> +	if (IS_ERR(rk_obj))
> +		return -ENOMEM;
> +
> +	private->fbdev_bo =3D &rk_obj->base;
> +
> +	fbi =3D framebuffer_alloc(0, dev->dev);
> +	if (!fbi) {
> +		dev_err(dev->dev, "Failed to allocate framebuffer info.\n");
> +		ret =3D -ENOMEM;
> +		goto err_rockchip_gem_free_object;
> +	}
> +
> +	helper->fb =3D rockchip_drm_framebuffer_init(dev, &mode_cmd,
> +						   private->fbdev_bo);
> +	if (IS_ERR(helper->fb)) {
> +		dev_err(dev->dev, "Failed to allocate DRM framebuffer.\n");
> +		ret =3D PTR_ERR(helper->fb);
> +		goto err_framebuffer_release;
> +	}
> +
> +	helper->fbdev =3D fbi;
> +
> +	fbi->par =3D helper;
> +	fbi->flags =3D FBINFO_FLAG_DEFAULT;
> +	fbi->fbops =3D &rockchip_drm_fbdev_ops;
> +
> +	ret =3D fb_alloc_cmap(&fbi->cmap, 256, 0);
> +	if (ret) {
> +		dev_err(dev->dev, "Failed to allocate color map.\n");
> +		goto err_drm_framebuffer_unref;
> +	}
> +
> +	fb =3D helper->fb;
> +	drm_fb_helper_fill_fix(fbi, fb->pitches[0], fb->depth);
> +	drm_fb_helper_fill_var(fbi, helper, fb->width, fb->height);
> +
> +	offset =3D fbi->var.xoffset * bytes_per_pixel;
> +	offset +=3D fbi->var.yoffset * fb->pitches[0];
> +
> +	dev->mode_config.fb_base =3D 0;
> +	fbi->screen_base =3D rk_obj->kvaddr + offset;
> +	fbi->screen_size =3D rk_obj->base.size;
> +	fbi->fix.smem_len =3D rk_obj->base.size;
> +
> +	DRM_DEBUG_KMS("FB [%dx%d]-%d kvaddr=3D%p offset=3D%ld size=3D%d\n",
> +		      fb->width, fb->height, fb->depth, rk_obj->kvaddr,
> +		      offset, size);
> +	return 0;
> +
> +err_drm_framebuffer_unref:
> +	drm_framebuffer_unreference(helper->fb);
> +err_framebuffer_release:
> +	framebuffer_release(fbi);
> +err_rockchip_gem_free_object:
> +	rockchip_gem_free_object(&rk_obj->base);
> +	return ret;
> +}
> +
> +static struct drm_fb_helper_funcs rockchip_drm_fb_helper_funcs =3D {
> +	.fb_probe =3D rockchip_drm_fbdev_create,
> +};
> +
> +int rockchip_drm_fbdev_init(struct drm_device *dev)
> +{
> +	struct rockchip_drm_private *private =3D dev->dev_private;
> +	struct drm_fb_helper *helper;
> +	unsigned int num_crtc;
> +	int ret;
> +
> +	if (!dev->mode_config.num_crtc || !dev->mode_config.num_connector)
> +		return -EINVAL;
> +
> +	num_crtc =3D dev->mode_config.num_crtc;
> +
> +	helper =3D &private->fbdev_helper;
> +
> +	drm_fb_helper_prepare(dev, helper, &rockchip_drm_fb_helper_funcs);
> +
> +	ret =3D drm_fb_helper_init(dev, helper, num_crtc, ROCKCHIP_MAX_CONN=
ECTOR);
> +	if (ret < 0) {
> +		dev_err(dev->dev, "Failed to initialize drm fb helper - %d.\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	ret =3D drm_fb_helper_single_add_all_connectors(helper);
> +	if (ret < 0) {
> +		dev_err(dev->dev, "Failed to add connectors - %d.\n", ret);
> +		goto err_drm_fb_helper_fini;
> +	}
> +
> +	/* disable all the possible outputs/crtcs before entering KMS mode =
*/
> +	drm_helper_disable_unused_functions(dev);
> +
> +	ret =3D drm_fb_helper_initial_config(helper, PREFERRED_BPP);
> +	if (ret < 0) {
> +		dev_err(dev->dev, "Failed to set initial hw config - %d.\n",
> +			ret);
> +		goto err_drm_fb_helper_fini;
> +	}
> +
> +	return 0;
> +
> +err_drm_fb_helper_fini:
> +	drm_fb_helper_fini(helper);
> +	return ret;
> +}
> +
> +void rockchip_drm_fbdev_fini(struct drm_device *dev)
> +{
> +	struct rockchip_drm_private *private =3D dev->dev_private;
> +	struct drm_fb_helper *helper;
> +
> +	helper =3D &private->fbdev_helper;
> +
> +	if (helper->fbdev) {
> +		struct fb_info *info;
> +		int ret;
> +
> +		info =3D helper->fbdev;
> +		ret =3D unregister_framebuffer(info);
> +		if (ret < 0)
> +			DRM_DEBUG_KMS("failed unregister_framebuffer() - %d\n",
> +				      ret);
> +
> +		if (info->cmap.len)
> +			fb_dealloc_cmap(&info->cmap);
> +
> +		framebuffer_release(info);
> +	}
> +
> +	if (helper->fb)
> +		drm_framebuffer_unreference(helper->fb);
> +
> +	drm_fb_helper_fini(helper);
> +}
> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h b/drivers/=
gpu/drm/rockchip/rockchip_drm_fbdev.h
> new file mode 100644
> index 0000000..5edcf6a
> --- /dev/null
> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h
> @@ -0,0 +1,20 @@
> +/*
> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
> + * Author:Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
> + *
> + * This software is licensed under the terms of the GNU General Publ=
ic
> + * License version 2, as published by the Free Software Foundation, =
and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef _ROCKCHIP_DRM_FBDEV_H
> +#define _ROCKCHIP_DRM_FBDEV_H
> +
> +int rockchip_drm_fbdev_init(struct drm_device *dev);
> +
> +#endif /* _ROCKCHIP_DRM_FBDEV_H */
> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c b/drivers/gp=
u/drm/rockchip/rockchip_drm_gem.c
> new file mode 100644
> index 0000000..e55f0b9
> --- /dev/null
> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
> @@ -0,0 +1,294 @@
> +/*
> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
> + * Author:Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
> + *
> + * This software is licensed under the terms of the GNU General Publ=
ic
> + * License version 2, as published by the Free Software Foundation, =
and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <drm/drm.h>
> +#include <drm/drmP.h>
> +#include <drm/drm_vma_manager.h>
> +
> +#include <linux/anon_inodes.h>
> +#include <linux/dma-attrs.h>
> +
> +#include "rockchip_drm_drv.h"
> +#include "rockchip_drm_gem.h"
> +
> +static int rockchip_gem_alloc_buf(struct rockchip_gem_object *rk_obj=
)
> +{
> +	struct drm_gem_object *obj =3D &rk_obj->base;
> +	struct drm_device *drm =3D obj->dev;
> +
> +	init_dma_attrs(&rk_obj->dma_attrs);
> +	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &rk_obj->dma_attrs);
> +
> +	/* TODO(djkurtz): Use DMA_ATTR_NO_KERNEL_MAPPING except for fbdev *=
/
> +	rk_obj->kvaddr =3D dma_alloc_attrs(drm->dev, obj->size,
> +					 &rk_obj->dma_addr, GFP_KERNEL,
> +					 &rk_obj->dma_attrs);
> +	if (IS_ERR(rk_obj->kvaddr)) {
> +		int ret =3D PTR_ERR(rk_obj->kvaddr);
> +
> +		DRM_ERROR("failed to allocate %#x byte dma buffer, %d",
> +			  obj->size, ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static void rockchip_gem_free_buf(struct rockchip_gem_object *rk_obj=
)
> +{
> +	struct drm_gem_object *obj =3D &rk_obj->base;
> +	struct drm_device *drm =3D obj->dev;
> +
> +	dma_free_attrs(drm->dev, obj->size, rk_obj->kvaddr, rk_obj->dma_add=
r,
> +		       &rk_obj->dma_attrs);
> +}
> +
> +int rockchip_gem_mmap_buf(struct drm_gem_object *obj,
> +			  struct vm_area_struct *vma)
> +{
> +	struct rockchip_gem_object *rk_obj =3D to_rockchip_obj(obj);
> +	struct drm_device *drm =3D obj->dev;
> +	unsigned long vm_size;
> +
> +	vma->vm_flags |=3D VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
> +	vm_size =3D vma->vm_end - vma->vm_start;
> +
> +	if (vm_size > obj->size)
> +		return -EINVAL;
> +
> +	return dma_mmap_attrs(drm->dev, vma, rk_obj->kvaddr, rk_obj->dma_ad=
dr,
> +			     obj->size, &rk_obj->dma_attrs);
> +}
> +
> +/* drm driver mmap file operations */
> +int rockchip_gem_mmap(struct file *filp, struct vm_area_struct *vma)
> +{
> +	struct drm_file *priv =3D filp->private_data;
> +	struct drm_device *dev =3D priv->minor->dev;
> +	struct drm_gem_object *obj;
> +	struct drm_vma_offset_node *node;
> +	int ret;
> +
> +	if (drm_device_is_unplugged(dev))
> +		return -ENODEV;
> +
> +	mutex_lock(&dev->struct_mutex);
> +
> +	node =3D drm_vma_offset_exact_lookup(dev->vma_offset_manager,
> +					   vma->vm_pgoff,
> +					   vma_pages(vma));
> +	if (!node) {
> +		mutex_unlock(&dev->struct_mutex);
> +		DRM_ERROR("failed to find vma node.\n");
> +		return -EINVAL;
> +	} else if (!drm_vma_node_is_allowed(node, filp)) {
> +		mutex_unlock(&dev->struct_mutex);
> +		return -EACCES;
> +	}
> +
> +	obj =3D container_of(node, struct drm_gem_object, vma_node);
> +	ret =3D rockchip_gem_mmap_buf(obj, vma);
> +
> +	mutex_unlock(&dev->struct_mutex);
> +
> +	return ret;
> +}
> +
> +struct rockchip_gem_object *
> +	rockchip_gem_create_object(struct drm_device *drm, unsigned int siz=
e)
> +{
> +	struct rockchip_gem_object *rk_obj;
> +	struct drm_gem_object *obj;
> +	int ret;
> +
> +	size =3D round_up(size, PAGE_SIZE);
> +
> +	rk_obj =3D kzalloc(sizeof(*rk_obj), GFP_KERNEL);
> +	if (!rk_obj)
> +		return ERR_PTR(-ENOMEM);
> +
> +	obj =3D &rk_obj->base;
> +
> +	drm_gem_private_object_init(drm, obj, size);
> +
> +	ret =3D rockchip_gem_alloc_buf(rk_obj);
> +	if (ret)
> +		goto err_free_rk_obj;
> +
> +	return rk_obj;
> +
> +err_free_rk_obj:
> +	kfree(rk_obj);
> +	return ERR_PTR(ret);
> +}
> +
> +/*
> + * rockchip_gem_free_object - (struct drm_driver)->gem_free_object c=
allback
> + * function
> + */
> +void rockchip_gem_free_object(struct drm_gem_object *obj)
> +{
> +	struct rockchip_gem_object *rk_obj;
> +
> +	drm_gem_free_mmap_offset(obj);
> +
> +	rk_obj =3D to_rockchip_obj(obj);
> +
> +	rockchip_gem_free_buf(rk_obj);
> +
> +	kfree(rk_obj);
> +}
> +
> +/*
> + * rockchip_gem_create_with_handle - allocate an object with the giv=
en
> + * size and create a gem handle on it
> + *
> + * returns a struct rockchip_gem_object* on success or ERR_PTR value=
s
> + * on failure.
> + */
> +static struct rockchip_gem_object *
> +rockchip_gem_create_with_handle(struct drm_file *file_priv,
> +				struct drm_device *drm, unsigned int size,
> +				unsigned int *handle)
> +{
> +	struct rockchip_gem_object *rk_obj;
> +	struct drm_gem_object *obj;
> +	int ret;
> +
> +	rk_obj =3D rockchip_gem_create_object(drm, size);
> +	if (IS_ERR(rk_obj))
> +		return ERR_CAST(rk_obj);
> +
> +	obj =3D &rk_obj->base;
> +
> +	/*
> +	 * allocate a id of idr table where the obj is registered
> +	 * and handle has the id what user can see.
> +	 */
> +	ret =3D drm_gem_handle_create(file_priv, obj, handle);
> +	if (ret)
> +		goto err_handle_create;
> +
> +	/* drop reference from allocate - handle holds it now. */
> +	drm_gem_object_unreference_unlocked(obj);
> +
> +	return rk_obj;
> +
> +err_handle_create:
> +	rockchip_gem_free_object(obj);
> +
> +	return ERR_PTR(ret);
> +}
> +
> +int rockchip_gem_dumb_map_offset(struct drm_file *file_priv,
> +				 struct drm_device *dev, uint32_t handle,
> +				 uint64_t *offset)
> +{
> +	struct drm_gem_object *obj;
> +	int ret;
> +
> +	mutex_lock(&dev->struct_mutex);
> +
> +	obj =3D drm_gem_object_lookup(dev, file_priv, handle);
> +	if (!obj) {
> +		DRM_ERROR("failed to lookup gem object.\n");
> +		ret =3D -EINVAL;
> +		goto unlock;
> +	}
> +
> +	ret =3D drm_gem_create_mmap_offset(obj);
> +	if (ret)
> +		goto out;
> +
> +	*offset =3D drm_vma_node_offset_addr(&obj->vma_node);
> +	DRM_DEBUG_KMS("offset =3D 0x%llx\n", *offset);
> +
> +out:
> +	drm_gem_object_unreference(obj);
> +unlock:
> +	mutex_unlock(&dev->struct_mutex);
> +	return ret;
> +}
> +
> +/*
> + * rockchip_gem_dumb_create - (struct drm_driver)->dumb_create callb=
ack
> + * function
> + *
> + * This aligns the pitch and size arguments to the minimum required.=
 wrap
> + * this into your own function if you need bigger alignment.
> + */
> +int rockchip_gem_dumb_create(struct drm_file *file_priv,
> +			     struct drm_device *dev,
> +			     struct drm_mode_create_dumb *args)
> +{
> +	struct rockchip_gem_object *rk_obj;
> +	int min_pitch =3D DIV_ROUND_UP(args->width * args->bpp, 8);
> +
> +	/*
> +	 * align to 64 bytes since Mali requires it.
> +	 */
> +	min_pitch =3D ALIGN(min_pitch, 64);
> +
> +	if (args->pitch < min_pitch)
> +		args->pitch =3D min_pitch;
> +
> +	if (args->size < args->pitch * args->height)
> +		args->size =3D args->pitch * args->height;
> +
> +	rk_obj =3D rockchip_gem_create_with_handle(file_priv, dev, args->si=
ze,
> +						 &args->handle);
> +
> +	return PTR_ERR_OR_ZERO(rk_obj);
> +}
> +
> +/*
> + * Allocate a sg_table for this GEM object.
> + * Note: Both the table's contents, and the sg_table itself must be =
freed by
> + *       the caller.
> + * Returns a pointer to the newly allocated sg_table, or an ERR_PTR(=
) error.
> + */
> +struct sg_table *rockchip_gem_prime_get_sg_table(struct drm_gem_obje=
ct *obj)
> +{
> +	struct rockchip_gem_object *rk_obj =3D to_rockchip_obj(obj);
> +	struct drm_device *drm =3D obj->dev;
> +	struct sg_table *sgt;
> +	int ret;
> +
> +	sgt =3D kzalloc(sizeof(*sgt), GFP_KERNEL);
> +	if (!sgt)
> +		return ERR_PTR(-ENOMEM);
> +
> +	ret =3D dma_get_sgtable_attrs(drm->dev, sgt, rk_obj->kvaddr,
> +				    rk_obj->dma_addr, obj->size,
> +				    &rk_obj->dma_attrs);
> +	if (ret) {
> +		DRM_ERROR("failed to allocate sgt, %d\n", ret);
> +		kfree(sgt);
> +		return ERR_PTR(ret);
> +	}
> +
> +	return sgt;
> +}
> +
> +void *rockchip_gem_prime_vmap(struct drm_gem_object *obj)
> +{
> +	struct rockchip_gem_object *rk_obj =3D to_rockchip_obj(obj);
> +
> +	return rk_obj->kvaddr;
> +}
> +
> +void rockchip_gem_prime_vunmap(struct drm_gem_object *obj, void *vad=
dr)
> +{
> +	/* Nothing to do */
> +}
> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_gem.h b/drivers/gp=
u/drm/rockchip/rockchip_drm_gem.h
> new file mode 100644
> index 0000000..67bcebe
> --- /dev/null
> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_gem.h
> @@ -0,0 +1,54 @@
> +/*
> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
> + * Author:Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
> + *
> + * This software is licensed under the terms of the GNU General Publ=
ic
> + * License version 2, as published by the Free Software Foundation, =
and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef _ROCKCHIP_DRM_GEM_H
> +#define _ROCKCHIP_DRM_GEM_H
> +
> +#define to_rockchip_obj(x) container_of(x, struct rockchip_gem_objec=
t, base)
> +
> +struct rockchip_gem_object {
> +	struct drm_gem_object base;
> +	unsigned int flags;
> +
> +	void *kvaddr;
> +	dma_addr_t dma_addr;
> +	struct dma_attrs dma_attrs;
> +};
> +
> +struct sg_table *rockchip_gem_prime_get_sg_table(struct drm_gem_obje=
ct *obj);
> +struct drm_gem_object *
> +rockchip_gem_prime_import_sg_table(struct drm_device *dev, size_t si=
ze,
> +				   struct sg_table *sgt);
> +void *rockchip_gem_prime_vmap(struct drm_gem_object *obj);
> +void rockchip_gem_prime_vunmap(struct drm_gem_object *obj, void *vad=
dr);
> +
> +/* drm driver mmap file operations */
> +int rockchip_gem_mmap(struct file *filp, struct vm_area_struct *vma)=
;
> +
> +/* mmap a gem object to userspace. */
> +int rockchip_gem_mmap_buf(struct drm_gem_object *obj,
> +			  struct vm_area_struct *vma);
> +
> +struct rockchip_gem_object *
> +	rockchip_gem_create_object(struct drm_device *drm, unsigned int siz=
e);
> +
> +void rockchip_gem_free_object(struct drm_gem_object *obj);
> +
> +int rockchip_gem_dumb_create(struct drm_file *file_priv,
> +			     struct drm_device *dev,
> +			     struct drm_mode_create_dumb *args);
> +int rockchip_gem_dumb_map_offset(struct drm_file *file_priv,
> +				 struct drm_device *dev, uint32_t handle,
> +				 uint64_t *offset);
> +#endif /* _ROCKCHIP_DRM_GEM_H */
> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/gp=
u/drm/rockchip/rockchip_drm_vop.c
> new file mode 100644
> index 0000000..b49b6b4
> --- /dev/null
> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
> @@ -0,0 +1,1415 @@
> +/*
> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
> + * Author:Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
> + *
> + * This software is licensed under the terms of the GNU General Publ=
ic
> + * License version 2, as published by the Free Software Foundation, =
and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <drm/drm.h>
> +#include <drm/drmP.h>
> +#include <drm/drm_crtc.h>
> +#include <drm/drm_crtc_helper.h>
> +#include <drm/drm_plane_helper.h>
> +#include <drm/drm_rect.h>
> +
> +#include <linux/kernel.h>
> +#include <linux/platform_device.h>
> +#include <linux/clk.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/component.h>
> +
> +#include <linux/reset.h>
> +#include <linux/iommu.h>
> +#include <linux/delay.h>
> +
> +#include <video/of_display_timing.h>
> +#include <video/of_videomode.h>
> +
> +#include "rockchip_drm_drv.h"
> +#include "rockchip_drm_fbdev.h"
> +#include "rockchip_drm_gem.h"
> +#include "rockchip_drm_fb.h"
> +#include "rockchip_drm_vop.h"
> +
> +#define VOP_DEFAULT_FRAMERATE	60
> +#define VOP_MAX_WIN_SUPPORT	5
> +#define VOP_DEFAULT_PRIMARY	0
> +#define VOP_DEFAULT_CURSOR	1
> +#define VOP_REG(off, _mask, s) \
> +		{.offset =3D off, \
> +		 .mask =3D _mask, \
> +		 .shift =3D s,}
> +
> +#define __REG_SET_RELAXED(x, off, mask, shift, v) \
> +		vop_mask_write_relaxed(x, off, (mask) << shift, (v) << shift)
> +#define __REG_SET_NORMAL(x, off, mask, shift, v) \
> +		vop_mask_write(x, off, (mask) << shift, (v) << shift)
> +
> +#define REG_SET(x, base, reg, v, mode) \
> +		__REG_SET_##mode(x, base + reg.offset, reg.mask, reg.shift, v)
> +
> +#define VOP_WIN_SET(x, win, name, v) \
> +		REG_SET(x, win->base, win->phy->name, v, RELAXED)
> +#define VOP_CTRL_SET(x, name, v) \
> +		REG_SET(x, 0, (x)->data->ctrl->name, v, NORMAL)
> +
> +#define VOP_WIN_GET_YRGBADDR(ctx, win) \
> +		vop_readl(ctx, win->base + win->phy->yrgb_mst.offset)
> +
> +#define to_vop_ctx(x) container_of(x, struct vop_context, crtc)
> +#define to_rockchip_plane(x) container_of(x, struct rockchip_plane, =
base)
> +
> +struct rockchip_plane {
> +	int id;
> +	struct drm_plane base;
> +	const struct vop_win *win;
> +
> +	uint32_t pending_yrgb_mst;
> +	struct drm_framebuffer *front_fb;
> +	struct drm_framebuffer *pending_fb;
> +	bool enabled;
> +};
> +
> +struct vop_context {
> +	struct device *dev;
> +	struct drm_device *drm_dev;
> +	struct drm_crtc crtc;
> +	struct drm_pending_vblank_event *event;
> +	struct vop_driver *drv;
> +	unsigned int dpms;
> +
> +	int connector_type;
> +	int connector_out_mode;
> +	wait_queue_head_t wait_vsync_queue;
> +	atomic_t wait_vsync_event;
> +
> +	struct workqueue_struct *vsync_wq;
> +	struct work_struct vsync_work;
> +
> +	/* mutex vsync_ work */
> +	struct mutex vsync_mutex;
> +	bool vsync_work_pending;
> +
> +	struct vop_driver_data *data;
> +
> +	uint32_t *regsbak;
> +	void __iomem *regs;
> +
> +	/* physical map length of vop register */
> +	uint32_t len;
> +
> +	/* one time only one process allowed to config the register */
> +	spinlock_t reg_lock;
> +	/* lock vop irq reg */
> +	spinlock_t irq_lock;
> +
> +	unsigned int irq;
> +
> +	/* vop AHP clk */
> +	struct clk *hclk;
> +	/* vop dclk */
> +	struct clk *dclk;
> +	/* vop share memory frequency */
> +	struct clk *aclk;
> +
> +	/* vop dclk reset */
> +	struct reset_control *dclk_rst;
> +
> +	int pipe;
> +	bool clk_on;
> +	bool is_iommu_attach;
> +};
> +
> +enum vop_data_format {
> +	VOP_FMT_ARGB8888 =3D 0,
> +	VOP_FMT_RGB888,
> +	VOP_FMT_RGB565,
> +	VOP_FMT_YUV420SP =3D 4,
> +	VOP_FMT_YUV422SP,
> +	VOP_FMT_YUV444SP,
> +};
> +
> +struct vop_reg_data {
> +	uint32_t offset;
> +	uint32_t value;
> +};
> +
> +struct vop_reg {
> +	uint32_t offset;
> +	uint32_t shift;
> +	uint32_t mask;
> +};
> +
> +struct vop_ctrl {
> +	struct vop_reg standby;
> +	struct vop_reg data_blank;
> +	struct vop_reg gate_en;
> +	struct vop_reg mmu_en;
> +	struct vop_reg rgb_en;
> +	struct vop_reg edp_en;
> +	struct vop_reg hdmi_en;
> +	struct vop_reg mipi_en;
> +	struct vop_reg out_mode;
> +	struct vop_reg dither_down;
> +	struct vop_reg dither_up;
> +	struct vop_reg pin_pol;
> +
> +	struct vop_reg htotal_pw;
> +	struct vop_reg hact_st_end;
> +	struct vop_reg vtotal_pw;
> +	struct vop_reg vact_st_end;
> +	struct vop_reg hpost_st_end;
> +	struct vop_reg vpost_st_end;
> +};
> +
> +struct vop_win_phy {
> +	const uint32_t *data_formats;
> +	uint32_t nformats;
> +
> +	struct vop_reg enable;
> +	struct vop_reg format;
> +	struct vop_reg act_info;
> +	struct vop_reg dsp_info;
> +	struct vop_reg dsp_st;
> +	struct vop_reg yrgb_mst;
> +	struct vop_reg uv_mst;
> +	struct vop_reg yrgb_vir;
> +	struct vop_reg uv_vir;
> +
> +	struct vop_reg dst_alpha_ctl;
> +	struct vop_reg src_alpha_ctl;
> +};
> +
> +struct vop_win {
> +	uint32_t base;
> +	const struct vop_win_phy *phy;
> +};
> +
> +struct vop_driver_data {
> +	const void *init_table;
> +	int table_size;
> +	const struct vop_ctrl *ctrl;
> +	const struct vop_win *win[VOP_MAX_WIN_SUPPORT];
> +};
> +
> +static const uint32_t formats_01[] =3D {
> +	DRM_FORMAT_XRGB8888,
> +	DRM_FORMAT_ARGB8888,
> +	DRM_FORMAT_RGB888,
> +	DRM_FORMAT_RGB565,
> +	DRM_FORMAT_NV12,
> +	DRM_FORMAT_NV16,
> +	DRM_FORMAT_NV24,
> +};
> +
> +static const uint32_t formats_234[] =3D {
> +	DRM_FORMAT_XRGB8888,
> +	DRM_FORMAT_ARGB8888,
> +	DRM_FORMAT_RGB888,
> +	DRM_FORMAT_RGB565,
> +};
> +
> +static const struct vop_win_phy win01_data =3D {
> +	.data_formats =3D formats_01,
> +	.nformats =3D ARRAY_SIZE(formats_01),
> +	.enable =3D VOP_REG(WIN0_CTRL0, 0x1, 0),
> +	.format =3D VOP_REG(WIN0_CTRL0, 0x7, 1),
> +	.act_info =3D VOP_REG(WIN0_ACT_INFO, 0x1fff1fff, 0),
> +	.dsp_info =3D VOP_REG(WIN0_DSP_INFO, 0x0fff0fff, 0),
> +	.dsp_st =3D VOP_REG(WIN0_DSP_ST, 0x1fff1fff, 0),
> +	.yrgb_mst =3D VOP_REG(WIN0_YRGB_MST, 0xffffffff, 0),
> +	.uv_mst =3D VOP_REG(WIN0_CBR_MST, 0xffffffff, 0),
> +	.yrgb_vir =3D VOP_REG(WIN0_VIR, 0x3fff, 0),
> +	.uv_vir =3D VOP_REG(WIN0_VIR, 0x3fff, 16),
> +	.src_alpha_ctl =3D VOP_REG(WIN0_SRC_ALPHA_CTRL, 0xff, 0),
> +	.dst_alpha_ctl =3D VOP_REG(WIN0_DST_ALPHA_CTRL, 0xff, 0),
> +};
> +
> +static const struct vop_win_phy win23_data =3D {
> +	.data_formats =3D formats_234,
> +	.nformats =3D ARRAY_SIZE(formats_234),
> +	.enable =3D VOP_REG(WIN2_CTRL0, 0x1, 0),
> +	.format =3D VOP_REG(WIN2_CTRL0, 0x7, 1),
> +	.dsp_info =3D VOP_REG(WIN2_DSP_INFO0, 0x0fff0fff, 0),
> +	.dsp_st =3D VOP_REG(WIN2_DSP_ST0, 0x1fff1fff, 0),
> +	.yrgb_mst =3D VOP_REG(WIN2_MST0, 0xffffffff, 0),
> +	.yrgb_vir =3D VOP_REG(WIN2_VIR0_1, 0x1fff, 0),
> +	.src_alpha_ctl =3D VOP_REG(WIN2_SRC_ALPHA_CTRL, 0xff, 0),
> +	.dst_alpha_ctl =3D VOP_REG(WIN2_DST_ALPHA_CTRL, 0xff, 0),
> +};
> +
> +static const struct vop_win_phy cursor_data =3D {
> +	.data_formats =3D formats_234,
> +	.nformats =3D ARRAY_SIZE(formats_234),
> +	.enable =3D VOP_REG(HWC_CTRL0, 0x1, 0),
> +	.format =3D VOP_REG(HWC_CTRL0, 0x7, 1),
> +	.dsp_st =3D VOP_REG(HWC_DSP_ST, 0x1fff1fff, 0),
> +	.yrgb_mst =3D VOP_REG(HWC_MST, 0xffffffff, 0),
> +};
> +
> +static const struct vop_win win0 =3D {
> +	.base =3D 0,
> +	.phy =3D &win01_data,
> +};
> +
> +static const struct vop_win win1 =3D {
> +	.base =3D 0x40,
> +	.phy =3D &win01_data,
> +};
> +
> +static const struct vop_win win2 =3D {
> +	.base =3D 0,
> +	.phy =3D &win23_data,
> +};
> +
> +static const struct vop_win win3 =3D {
> +	.base =3D 0x50,
> +	.phy =3D &win23_data,
> +};
> +
> +static const struct vop_win win_cursor =3D {
> +	.base =3D 0,
> +	.phy =3D &cursor_data,
> +};
> +
> +static const struct vop_ctrl ctrl_data =3D {
> +	.standby =3D VOP_REG(SYS_CTRL, 0x1, 22),
> +	.gate_en =3D VOP_REG(SYS_CTRL, 0x1, 23),
> +	.mmu_en =3D VOP_REG(SYS_CTRL, 0x1, 20),
> +	.rgb_en =3D VOP_REG(SYS_CTRL, 0x1, 12),
> +	.hdmi_en =3D VOP_REG(SYS_CTRL, 0x1, 13),
> +	.edp_en =3D VOP_REG(SYS_CTRL, 0x1, 14),
> +	.mipi_en =3D VOP_REG(SYS_CTRL, 0x1, 15),
> +	.dither_down =3D VOP_REG(DSP_CTRL1, 0xf, 1),
> +	.dither_up =3D VOP_REG(DSP_CTRL1, 0x1, 6),
> +	.data_blank =3D VOP_REG(DSP_CTRL0, 0x1, 19),
> +	.out_mode =3D VOP_REG(DSP_CTRL0, 0xf, 0),
> +	.pin_pol =3D VOP_REG(DSP_CTRL0, 0xf, 4),
> +	.htotal_pw =3D VOP_REG(DSP_HTOTAL_HS_END, 0x1fff1fff, 0),
> +	.hact_st_end =3D VOP_REG(DSP_HACT_ST_END, 0x1fff1fff, 0),
> +	.vtotal_pw =3D VOP_REG(DSP_VTOTAL_VS_END, 0x1fff1fff, 0),
> +	.vact_st_end =3D VOP_REG(DSP_VACT_ST_END, 0x1fff1fff, 0),
> +	.hpost_st_end =3D VOP_REG(POST_DSP_HACT_INFO, 0x1fff1fff, 0),
> +	.vpost_st_end =3D VOP_REG(POST_DSP_VACT_INFO, 0x1fff1fff, 0),
> +};
> +
> +static const struct vop_reg_data vop_init_reg_table[] =3D {
> +	{SYS_CTRL, 0x00c00000},
> +	{DSP_CTRL0, 0x00000000},
> +	{WIN0_CTRL0, 0x00000080},
> +	{WIN1_CTRL0, 0x00000080},
> +};
> +
> +static const struct vop_driver_data rockchip_rk3288_vop =3D {
> +	.init_table =3D vop_init_reg_table,
> +	.table_size =3D ARRAY_SIZE(vop_init_reg_table),
> +	.ctrl =3D &ctrl_data,
> +	.win[0] =3D &win0,
> +	.win[1] =3D &win1,
> +	.win[2] =3D &win2,
> +	.win[3] =3D &win3,
> +	.win[4] =3D &win_cursor,
> +};
> +
> +static const struct of_device_id vop_driver_dt_match[] =3D {
> +	{ .compatible =3D "rockchip,rk3288-vop",
> +	  .data =3D (void *)&rockchip_rk3288_vop },
> +	{},
> +};
> +
> +static inline void vop_writel(struct vop_context *ctx,
> +			      uint32_t offset, uint32_t v)
> +{
> +	writel(v, ctx->regs + offset);
> +	ctx->regsbak[offset >> 2] =3D v;
> +}
> +
> +static inline uint32_t vop_readl(struct vop_context *ctx, uint32_t o=
ffset)
> +{
> +	return readl(ctx->regs + offset);
> +}
> +
> +static inline void vop_cfg_done(struct vop_context *ctx)
> +{
> +	writel(0x01, ctx->regs + REG_CFG_DONE);
> +}
> +
> +static inline void vop_mask_write(struct vop_context *ctx,
> +				  uint32_t offset, uint32_t mask, uint32_t v)
> +{
> +	if (mask) {
> +		uint32_t cached_val =3D ctx->regsbak[offset >> 2];
> +
> +		cached_val =3D (cached_val & ~mask) | v;
> +		writel(cached_val, ctx->regs + offset);
> +		ctx->regsbak[offset >> 2] =3D cached_val;
> +	}
> +}
> +
> +static inline void vop_mask_write_relaxed(struct vop_context *ctx,
> +					  uint32_t offset, uint32_t mask,
> +					  uint32_t v)
> +{
> +	if (mask) {
> +		uint32_t cached_val =3D ctx->regsbak[offset >> 2];
> +
> +		cached_val =3D (cached_val & ~mask) | v;
> +		writel_relaxed(cached_val, ctx->regs + offset);
> +		ctx->regsbak[offset >> 2] =3D cached_val;
> +	}
> +}
> +
> +static inline struct vop_driver_data *vop_get_driver_data(struct dev=
ice *dev)
> +{
> +	const struct of_device_id *of_id =3D
> +			of_match_device(vop_driver_dt_match, dev);
> +
> +	return (struct vop_driver_data *)of_id->data;
> +}
> +
> +static enum vop_data_format vop_convert_format(uint32_t format)
> +{
> +	switch (format) {
> +	case DRM_FORMAT_XRGB8888:
> +	case DRM_FORMAT_ARGB8888:
> +		return VOP_FMT_ARGB8888;
> +	case DRM_FORMAT_RGB888:
> +		return VOP_FMT_RGB888;
> +	case DRM_FORMAT_RGB565:
> +		return VOP_FMT_RGB565;
> +	case DRM_FORMAT_NV12:
> +		return VOP_FMT_YUV420SP;
> +	case DRM_FORMAT_NV16:
> +		return VOP_FMT_YUV422SP;
> +	case DRM_FORMAT_NV24:
> +		return VOP_FMT_YUV444SP;
> +	default:
> +		DRM_ERROR("unsupport format[%08x]\n", format);
> +		return -EINVAL;
> +	}
> +}
> +
> +static bool is_alpha_support(uint32_t format)
> +{
> +	switch (format) {
> +	case DRM_FORMAT_ARGB8888:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
> +/* TODO(djkurtz): move generic 'setup slave rk_iommu' code somewhere=
 common */
> +static int vop_iommu_init(struct vop_context *ctx)
> +{
> +	struct device *dev =3D ctx->dev;
> +	struct device_node *np =3D dev->of_node;
> +	struct platform_device *pd;
> +	int count;
> +	int ret;
> +	struct of_phandle_args args;
> +
> +	/* Each VOP must have exactly one iommu node, with no args */
> +	count =3D of_count_phandle_with_args(np, "iommus", "#iommu-cells");
> +	if (count !=3D 1) {
> +		dev_err(dev, "of_count_phandle_with_args(%s) =3D> %d\n",
> +			np->full_name, count);
> +		return -EINVAL;
> +	}
> +
> +	ret =3D of_parse_phandle_with_args(np, "iommus", "#iommu-cells", 0,
> +					 &args);
> +	if (ret) {
> +		dev_err(dev, "of_parse_phandle_with_args(%s) =3D> %d\n",
> +			np->full_name, ret);
> +		return ret;
> +	}
> +	if (args.args_count !=3D 0) {
> +		dev_err(dev, "incorrect number of iommu params found for %s (found=
 %d, expected 0)\n",
> +			args.np->full_name, args.args_count);
> +		return -EINVAL;
> +	}
> +
> +	pd =3D of_find_device_by_node(args.np);
> +	of_node_put(args.np);
> +	if (!pd) {
> +		dev_err(dev, "iommu %s not found\n", args.np->full_name);
> +		return -EPROBE_DEFER;
> +	}
> +
> +	/* TODO(djkurtz): handle multiple slave iommus for a single master =
*/
> +	dev->archdata.iommu =3D &pd->dev;
> +
> +	return 0;
> +}
> +
> +static void rockchip_power_on(struct drm_crtc *crtc)
> +{
> +	struct vop_context *ctx =3D to_vop_ctx(crtc);
> +	int ret;
> +
> +	ret =3D clk_enable(ctx->hclk);
> +	if (ret < 0) {
> +		dev_err(ctx->dev, "failed to enable hclk - %d\n", ret);
> +		return;
> +	}
> +
> +	ret =3D clk_enable(ctx->dclk);
> +	if (ret < 0) {
> +		dev_err(ctx->dev, "failed to enable dclk - %d\n", ret);
> +		goto err_disable_hclk;
> +	}
> +
> +	ret =3D clk_enable(ctx->aclk);
> +	if (ret < 0) {
> +		dev_err(ctx->dev, "failed to enable aclk - %d\n", ret);
> +		goto err_disable_dclk;
> +	}
> +	if (!ctx->is_iommu_attach) {
> +		/*
> +		 * when we attach iommu device, we sould sure the vop scan at
> +		 * correct address.
> +		 */
> +		ret =3D rockchip_drm_dma_attach_device(ctx->drm_dev, ctx->dev);
> +		if (ret) {
> +			dev_err(ctx->dev, "failed to attach dma mapping, %d\n",
> +				ret);
> +			goto err_disable_aclk;
> +		}
> +		ctx->is_iommu_attach =3D true;
> +	}
> +
> +	spin_lock(&ctx->reg_lock);
> +
> +	VOP_CTRL_SET(ctx, standby, 0);
> +
> +	spin_unlock(&ctx->reg_lock);
> +
> +	return;
> +
> +err_disable_aclk:
> +	clk_disable(ctx->aclk);
> +err_disable_dclk:
> +	clk_disable(ctx->dclk);
> +err_disable_hclk:
> +	clk_disable(ctx->hclk);
> +}
> +
> +static void rockchip_power_off(struct drm_crtc *crtc)
> +{
> +	struct vop_context *ctx =3D to_vop_ctx(crtc);
> +
> +	drm_vblank_off(crtc->dev, ctx->pipe);
> +
> +	spin_lock(&ctx->reg_lock);
> +
> +	VOP_CTRL_SET(ctx, standby, 1);
> +
> +	spin_unlock(&ctx->reg_lock);
> +	/*
> +	 * disable dclk to stop frame scan, so we can safely detach iommu,
> +	 */
> +	clk_disable(ctx->dclk);
> +
> +	if (ctx->is_iommu_attach) {
> +		rockchip_drm_dma_detach_device(ctx->drm_dev, ctx->dev);
> +		ctx->is_iommu_attach =3D false;
> +	}
> +
> +	clk_disable(ctx->aclk);
> +	clk_disable(ctx->hclk);
> +}
> +
> +static int rockchip_update_plane(struct drm_plane *plane, struct drm=
_crtc *crtc,
> +				 struct drm_framebuffer *fb, int crtc_x,
> +				 int crtc_y, unsigned int crtc_w,
> +				 unsigned int crtc_h, uint32_t src_x,
> +				 uint32_t src_y, uint32_t src_w, uint32_t src_h)
> +{
> +	struct rockchip_plane *rockchip_plane =3D to_rockchip_plane(plane);
> +	const struct vop_win *win =3D rockchip_plane->win;
> +	struct vop_context *ctx =3D to_vop_ctx(crtc);
> +	struct drm_gem_object *obj;
> +	struct rockchip_gem_object *rk_obj;
> +	unsigned long offset;
> +	unsigned int actual_w;
> +	unsigned int actual_h;
> +	unsigned int dsp_stx;
> +	unsigned int dsp_sty;
> +	unsigned int y_vir_stride;
> +	dma_addr_t yrgb_mst;
> +	enum vop_data_format format;
> +	uint32_t val;
> +	bool is_alpha;
> +	bool visible;
> +	int ret;
> +	struct drm_rect dest =3D {
> +		.x1 =3D crtc_x,
> +		.y1 =3D crtc_y,
> +		.x2 =3D crtc_x + crtc_w,
> +		.y2 =3D crtc_y + crtc_h,
> +	};
> +	struct drm_rect src =3D {
> +		/* 16.16 fixed point */
> +		.x1 =3D src_x,
> +		.y1 =3D src_y,
> +		.x2 =3D src_x + src_w,
> +		.y2 =3D src_y + src_h,
> +	};
> +	const struct drm_rect clip =3D {
> +		.x2 =3D crtc->mode.hdisplay,
> +		.y2 =3D crtc->mode.vdisplay,
> +	};
> +	bool can_position =3D plane->type !=3D DRM_PLANE_TYPE_PRIMARY;
> +
> +	ret =3D drm_plane_helper_check_update(plane, crtc, fb,
> +					    &src, &dest, &clip,
> +					    DRM_PLANE_HELPER_NO_SCALING,
> +					    DRM_PLANE_HELPER_NO_SCALING,
> +					    can_position, false, &visible);
> +	if (ret)
> +		return ret;
> +
> +	if (!visible)
> +		return 0;
> +
> +	is_alpha =3D is_alpha_support(fb->pixel_format);
> +	format =3D vop_convert_format(fb->pixel_format);
> +	if (format < 0)
> +		return format;
> +
> +	obj =3D rockchip_fb_get_gem_obj(fb, 0);
> +	if (!obj) {
> +		DRM_ERROR("fail to get rockchip gem object from framebuffer\n");
> +		return -EINVAL;
> +	}
> +
> +	rk_obj =3D to_rockchip_obj(obj);
> +
> +	yrgb_mst =3D rk_obj->dma_addr;
> +	actual_w =3D (src.x2 - src.x1) >> 16;
> +	actual_h =3D (src.y2 - src.y1) >> 16;
> +	crtc_x =3D max(0, crtc_x);
> +	crtc_y =3D max(0, crtc_y);
> +
> +	dsp_stx =3D crtc_x + crtc->mode.htotal - crtc->mode.hsync_start;
> +	dsp_sty =3D crtc_y + crtc->mode.vtotal - crtc->mode.vsync_start;
> +
> +	offset =3D (src.x1 >> 16) * (fb->bits_per_pixel >> 3);
> +	offset +=3D (src.y1 >> 16) * fb->pitches[0];
> +
> +	y_vir_stride =3D fb->pitches[0] / (fb->bits_per_pixel >> 3);
> +
> +	spin_lock(&ctx->reg_lock);
> +
> +	VOP_WIN_SET(ctx, win, format, format);
> +	VOP_WIN_SET(ctx, win, yrgb_vir, y_vir_stride);
> +	yrgb_mst +=3D offset;
> +	VOP_WIN_SET(ctx, win, yrgb_mst, yrgb_mst);
> +	val =3D (actual_h - 1) << 16;
> +	val |=3D (actual_w - 1) & 0xffff;
> +	VOP_WIN_SET(ctx, win, act_info, val);
> +	VOP_WIN_SET(ctx, win, dsp_info, val);
> +	val =3D (dsp_sty - 1) << 16;
> +	val |=3D (dsp_stx - 1) & 0xffff;
> +	VOP_WIN_SET(ctx, win, dsp_st, val);
> +
> +	if (is_alpha) {
> +		VOP_WIN_SET(ctx, win, dst_alpha_ctl,
> +			    DST_FACTOR_M0(ALPHA_SRC_INVERSE));
> +		val =3D SRC_ALPHA_EN(1) | SRC_COLOR_M0(ALPHA_SRC_PRE_MUL) |
> +			SRC_ALPHA_M0(ALPHA_STRAIGHT) |
> +			SRC_BLEND_M0(ALPHA_PER_PIX) |
> +			SRC_ALPHA_CAL_M0(ALPHA_NO_SATURATION) |
> +			SRC_FACTOR_M0(ALPHA_ONE);
> +		VOP_WIN_SET(ctx, win, src_alpha_ctl, val);
> +	} else {
> +		VOP_WIN_SET(ctx, win, src_alpha_ctl, SRC_ALPHA_EN(0));
> +	}
> +
> +	VOP_WIN_SET(ctx, win, enable, 1);
> +
> +	spin_unlock(&ctx->reg_lock);
> +
> +	mutex_lock(&ctx->vsync_mutex);
> +
> +	/*
> +	 * Because the buffer set to vop take effect at frame start time,
> +	 * we need make sure old buffer is not in use before we release
> +	 * it.
> +	 * reference the framebuffer, and unference it when it swap out of =
vop.
> +	 */
> +	if (fb !=3D rockchip_plane->front_fb) {
> +		drm_framebuffer_reference(fb);
> +		if (rockchip_plane->pending_fb)
> +			drm_framebuffer_unreference(rockchip_plane->pending_fb);
> +		rockchip_plane->pending_fb =3D fb;
> +		rockchip_plane->pending_yrgb_mst =3D yrgb_mst;
> +		ctx->vsync_work_pending =3D true;
> +	}
> +	rockchip_plane->enabled =3D true;
> +
> +	mutex_unlock(&ctx->vsync_mutex);
> +
> +	spin_lock(&ctx->reg_lock);
> +	vop_cfg_done(ctx);
> +	spin_unlock(&ctx->reg_lock);
> +
> +	return 0;
> +}
> +
> +static inline int rockchip_update_primary_plane(struct drm_crtc *crt=
c)
> +{
> +	unsigned int crtc_w, crtc_h;
> +
> +	crtc_w =3D crtc->primary->fb->width - crtc->x;
> +	crtc_h =3D crtc->primary->fb->height - crtc->y;
> +
> +	return rockchip_update_plane(crtc->primary, crtc, crtc->primary->fb=
,
> +				     0, 0, crtc_w, crtc_h, crtc->x << 16,
> +				     crtc->y << 16, crtc_w << 16, crtc_h << 16);
> +}
> +
> +static int rockchip_disable_plane(struct drm_plane *plane)
> +{
> +	struct rockchip_plane *rockchip_plane =3D to_rockchip_plane(plane);
> +	const struct vop_win *win =3D rockchip_plane->win;
> +	struct vop_context *ctx;
> +
> +	if (!plane->crtc || !rockchip_plane->enabled)
> +		return 0;
> +
> +	ctx =3D to_vop_ctx(plane->crtc);
> +	spin_lock(&ctx->reg_lock);
> +
> +	VOP_WIN_SET(ctx, win, enable, 0);
> +	vop_cfg_done(ctx);
> +
> +	spin_unlock(&ctx->reg_lock);
> +
> +	mutex_lock(&ctx->vsync_mutex);
> +
> +	/*
> +	* clear the pending framebuffer and set vsync_work_pending true,
> +	* so that the framebuffer will unref at the next vblank.
> +	*/
> +	if (rockchip_plane->pending_fb) {
> +		drm_framebuffer_unreference(rockchip_plane->pending_fb);
> +		rockchip_plane->pending_fb =3D NULL;
> +	}
> +
> +	rockchip_plane->enabled =3D false;
> +	ctx->vsync_work_pending =3D true;
> +
> +	mutex_unlock(&ctx->vsync_mutex);
> +
> +	return 0;
> +}
> +
> +static void rockchip_plane_destroy(struct drm_plane *plane)
> +{
> +	struct rockchip_plane *rockchip_plane =3D to_rockchip_plane(plane);
> +
> +	rockchip_disable_plane(plane);
> +	drm_plane_cleanup(plane);
> +	kfree(rockchip_plane);
> +}
> +
> +static const struct drm_plane_funcs rockchip_plane_funcs =3D {
> +	.update_plane =3D rockchip_update_plane,
> +	.disable_plane =3D rockchip_disable_plane,
> +	.destroy =3D rockchip_plane_destroy,
> +};
> +
> +static struct drm_plane *rockchip_plane_init(struct vop_context *ctx=
,
> +					     unsigned long possible_crtcs,
> +					     enum drm_plane_type type,
> +					     int index)
> +{
> +	struct rockchip_plane *rockchip_plane;
> +	struct vop_driver_data *vop_data =3D ctx->data;
> +	const struct vop_win *win;
> +	int err;
> +
> +	if (index >=3D VOP_MAX_WIN_SUPPORT)
> +		return ERR_PTR(-EINVAL);
> +
> +	rockchip_plane =3D kzalloc(sizeof(*rockchip_plane), GFP_KERNEL);
> +	if (!rockchip_plane)
> +		return ERR_PTR(-ENOMEM);
> +
> +	win =3D vop_data->win[index];
> +	rockchip_plane->id =3D index;
> +	rockchip_plane->win =3D win;
> +
> +	err =3D drm_universal_plane_init(ctx->drm_dev, &rockchip_plane->bas=
e,
> +				       possible_crtcs, &rockchip_plane_funcs,
> +				       win->phy->data_formats,
> +				       win->phy->nformats, type);
> +	if (err) {
> +		DRM_ERROR("failed to initialize plane\n");
> +		kfree(rockchip_plane);
> +		return ERR_PTR(err);
> +	}
> +
> +	return &rockchip_plane->base;
> +}
> +
> +int rockchip_drm_crtc_mode_config(struct drm_crtc *crtc,
> +				  int connector_type,
> +				  int out_mode)
> +{
> +	struct vop_context *ctx =3D to_vop_ctx(crtc);
> +
> +	ctx->connector_type =3D connector_type;
> +	ctx->connector_out_mode =3D out_mode;
> +
> +	return 0;
> +}
> +
> +int rockchip_drm_crtc_enable_vblank(struct drm_device *dev, int pipe=
)
> +{
> +	struct vop_context *ctx =3D to_vop_ctx(rockchip_drm_find_crtc(dev, =
pipe));
> +	unsigned long flags;
> +
> +	if (ctx->dpms !=3D DRM_MODE_DPMS_ON)
> +		return -EPERM;
> +
> +	spin_lock_irqsave(&ctx->irq_lock, flags);
> +
> +	vop_mask_write(ctx, INTR_CTRL0, FS_INTR_MASK,
> +		       FS_INTR_EN(1));
> +
> +	spin_unlock_irqrestore(&ctx->irq_lock, flags);
> +
> +	return 0;
> +}
> +
> +void rockchip_drm_crtc_disable_vblank(struct drm_device *dev, int pi=
pe)
> +{
> +	struct vop_context *ctx =3D to_vop_ctx(rockchip_drm_find_crtc(dev, =
pipe));
> +	unsigned long flags;
> +
> +	if (ctx->dpms !=3D DRM_MODE_DPMS_ON)
> +		return;
> +	spin_lock_irqsave(&ctx->irq_lock, flags);
> +	vop_mask_write(ctx, INTR_CTRL0, FS_INTR_MASK,
> +		       FS_INTR_EN(0));
> +	spin_unlock_irqrestore(&ctx->irq_lock, flags);
> +}
> +
> +static void rockchip_drm_crtc_dpms(struct drm_crtc *crtc, int mode)
> +{
> +	struct vop_context *ctx =3D to_vop_ctx(crtc);
> +
> +	DRM_DEBUG_KMS("crtc[%d] mode[%d]\n", crtc->base.id, mode);
> +
> +	if (ctx->dpms =3D=3D mode) {
> +		DRM_DEBUG_KMS("desired dpms mode is same as previous one.\n");
> +		return;
> +	}
> +
> +	switch (mode) {
> +	case DRM_MODE_DPMS_ON:
> +		rockchip_power_on(crtc);
> +		break;
> +	case DRM_MODE_DPMS_STANDBY:
> +	case DRM_MODE_DPMS_SUSPEND:
> +	case DRM_MODE_DPMS_OFF:
> +		rockchip_power_off(crtc);
> +		break;
> +	default:
> +		DRM_DEBUG_KMS("unspecified mode %d\n", mode);
> +		break;
> +	}
> +
> +	ctx->dpms =3D mode;
> +}
> +
> +static void rockchip_drm_crtc_prepare(struct drm_crtc *crtc)
> +{
> +	rockchip_drm_crtc_dpms(crtc, DRM_MODE_DPMS_ON);
> +}
> +
> +static bool rockchip_drm_crtc_mode_fixup(struct drm_crtc *crtc,
> +					 const struct drm_display_mode *mode,
> +					 struct drm_display_mode *adjusted_mode)
> +{
> +	if (adjusted_mode->htotal =3D=3D 0 || adjusted_mode->vtotal =3D=3D =
0)
> +		return false;
> +
> +	return true;
> +}
> +
> +static int rockchip_drm_crtc_mode_set_base(struct drm_crtc *crtc, in=
t x, int y,
> +					   struct drm_framebuffer *old_fb)
> +{
> +	int ret;
> +
> +	crtc->x =3D x;
> +	crtc->y =3D y;
> +
> +	ret =3D rockchip_update_primary_plane(crtc);
> +	if (ret < 0) {
> +		DRM_ERROR("fail to update plane\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int rockchip_drm_crtc_mode_set(struct drm_crtc *crtc,
> +				      struct drm_display_mode *mode,
> +				      struct drm_display_mode *adjusted_mode,
> +				      int x, int y,
> +				      struct drm_framebuffer *fb)
> +{
> +	struct vop_context *ctx =3D to_vop_ctx(crtc);
> +	u16 hsync_len =3D adjusted_mode->hsync_end - adjusted_mode->hsync_s=
tart;
> +	u16 hdisplay =3D adjusted_mode->hdisplay;
> +	u16 htotal =3D adjusted_mode->htotal;
> +	u16 hact_st =3D adjusted_mode->htotal - adjusted_mode->hsync_start;
> +	u16 hact_end =3D hact_st + hdisplay;
> +	u16 vdisplay =3D adjusted_mode->vdisplay;
> +	u16 vtotal =3D adjusted_mode->vtotal;
> +	u16 vsync_len =3D adjusted_mode->vsync_end - adjusted_mode->vsync_s=
tart;
> +	u16 vact_st =3D adjusted_mode->vtotal - adjusted_mode->vsync_start;
> +	u16 vact_end =3D vact_st + vdisplay;
> +	int ret;
> +	uint32_t val;
> +
> +	/*
> +	 * disable dclk to stop frame scan, so that we can safe config mode=
 and
> +	 * enable iommu.
> +	 */
> +	clk_disable(ctx->dclk);
> +
> +	ret =3D rockchip_drm_crtc_mode_set_base(crtc, x, y, fb);
> +	if (ret)
> +		return ret;
> +
> +	switch (ctx->connector_type) {
> +	case DRM_MODE_CONNECTOR_LVDS:
> +		VOP_CTRL_SET(ctx, rgb_en, 1);
> +		break;
> +	case DRM_MODE_CONNECTOR_eDP:
> +		VOP_CTRL_SET(ctx, edp_en, 1);
> +		break;
> +	case DRM_MODE_CONNECTOR_HDMIA:
> +		VOP_CTRL_SET(ctx, hdmi_en, 1);
> +		break;
> +	default:
> +		DRM_ERROR("unsupport connector_type[%d]\n",
> +			  ctx->connector_type);
> +		return -EINVAL;
> +	};
> +	VOP_CTRL_SET(ctx, out_mode, ctx->connector_out_mode);
> +
> +	val =3D 0x8;
> +	val |=3D (adjusted_mode->flags & DRM_MODE_FLAG_NHSYNC) ? 1 : 0;
> +	val |=3D (adjusted_mode->flags & DRM_MODE_FLAG_NVSYNC) ? (1 << 1) :=
 0;
> +	VOP_CTRL_SET(ctx, pin_pol, val);
> +
> +	VOP_CTRL_SET(ctx, htotal_pw, (htotal << 16) | hsync_len);
> +	val =3D hact_st << 16;
> +	val |=3D hact_end;
> +	VOP_CTRL_SET(ctx, hact_st_end, val);
> +	VOP_CTRL_SET(ctx, hpost_st_end, val);
> +
> +	VOP_CTRL_SET(ctx, vtotal_pw, (vtotal << 16) | vsync_len);
> +	val =3D vact_st << 16;
> +	val |=3D vact_end;
> +	VOP_CTRL_SET(ctx, vact_st_end, val);
> +	VOP_CTRL_SET(ctx, vpost_st_end, val);
> +	/*
> +	 * reset dclk, take all mode config affect, so the clk would run in
> +	 * correct frame.
> +	 */
> +	reset_control_assert(ctx->dclk_rst);
> +	usleep_range(10, 20);
> +	reset_control_deassert(ctx->dclk_rst);
> +
> +	clk_set_rate(ctx->dclk, adjusted_mode->clock * 1000);
> +	ret =3D clk_enable(ctx->dclk);
> +	if (ret < 0) {
> +		dev_err(ctx->dev, "failed to enable dclk - %d\n", ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static void rockchip_drm_crtc_commit(struct drm_crtc *crtc)
> +{
> +}
> +
> +static const struct drm_crtc_helper_funcs rockchip_crtc_helper_funcs=
 =3D {
> +	.dpms =3D rockchip_drm_crtc_dpms,
> +	.prepare =3D rockchip_drm_crtc_prepare,
> +	.mode_fixup =3D rockchip_drm_crtc_mode_fixup,
> +	.mode_set =3D rockchip_drm_crtc_mode_set,
> +	.mode_set_base =3D rockchip_drm_crtc_mode_set_base,
> +	.commit =3D rockchip_drm_crtc_commit,
> +};
> +
> +static int rockchip_drm_crtc_page_flip(struct drm_crtc *crtc,
> +				       struct drm_framebuffer *fb,
> +				       struct drm_pending_vblank_event *event,
> +				       uint32_t page_flip_flags)
> +{
> +	struct drm_device *dev =3D crtc->dev;
> +	struct vop_context *ctx =3D to_vop_ctx(crtc);
> +	struct drm_framebuffer *old_fb =3D crtc->primary->fb;
> +	int pipe =3D ctx->pipe;
> +	int ret;
> +
> +	/* when the page flip is requested, crtc's dpms should be on */
> +	if (ctx->dpms > DRM_MODE_DPMS_ON) {
> +		DRM_DEBUG("failed page flip request at dpms[%d].\n", ctx->dpms);
> +		return 0;
> +	}
> +
> +	ret =3D drm_vblank_get(dev, pipe);
> +	if (ret) {
> +		DRM_DEBUG("failed to acquire vblank counter\n");
> +		return ret;
> +	}
> +
> +	spin_lock_irq(&dev->event_lock);
> +	if (ctx->event) {
> +		spin_unlock_irq(&dev->event_lock);
> +		DRM_ERROR("already pending flip!\n");
> +		return -EBUSY;
> +	}
> +	ctx->event =3D event;
> +	atomic_set(&ctx->wait_vsync_event, 1);
> +	spin_unlock_irq(&dev->event_lock);
> +
> +	crtc->primary->fb =3D fb;
> +
> +	ret =3D rockchip_update_primary_plane(crtc);
> +	if (ret) {
> +		crtc->primary->fb =3D old_fb;
> +
> +		spin_lock_irq(&dev->event_lock);
> +		drm_vblank_put(dev, pipe);
> +		atomic_set(&ctx->wait_vsync_event, 0);
> +		ctx->event =3D NULL;
> +		spin_unlock_irq(&dev->event_lock);
> +	}
> +
> +	return ret;
> +}
> +
> +static void rockchip_drm_crtc_finish_pageflip(struct drm_crtc *crtc)
> +{
> +	struct vop_context *ctx =3D to_vop_ctx(crtc);
> +	struct drm_device *drm =3D ctx->drm_dev;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&drm->event_lock, flags);
> +
> +	if (ctx->event) {
> +		drm_send_vblank_event(drm, -1, ctx->event);
> +		drm_vblank_put(drm, ctx->pipe);
> +		atomic_set(&ctx->wait_vsync_event, 0);
> +		wake_up(&ctx->wait_vsync_queue);
> +		ctx->event =3D NULL;
> +	}
> +
> +	spin_unlock_irqrestore(&drm->event_lock, flags);
> +}
> +
> +static void rockchip_drm_crtc_destroy(struct drm_crtc *crtc)
> +{
> +	drm_crtc_cleanup(crtc);
> +}
> +
> +static const struct drm_crtc_funcs rockchip_crtc_funcs =3D {
> +	.set_config =3D drm_crtc_helper_set_config,
> +	.page_flip =3D rockchip_drm_crtc_page_flip,
> +	.destroy =3D rockchip_drm_crtc_destroy,
> +};
> +
> +static void rockchip_vsync_worker(struct work_struct *work)
> +{
> +	struct vop_context *ctx =3D container_of(work, struct vop_context,
> +					       vsync_work);
> +	struct drm_device *drm =3D ctx->drm_dev;
> +	struct drm_crtc *crtc =3D &ctx->crtc;
> +	struct rockchip_plane *rockchip_plane;
> +	struct drm_plane *plane;
> +	uint32_t yrgb_mst;
> +
> +	mutex_lock(&ctx->vsync_mutex);
> +
> +	ctx->vsync_work_pending =3D false;
> +
> +	list_for_each_entry(plane, &drm->mode_config.plane_list, head) {
> +		rockchip_plane =3D to_rockchip_plane(plane);
> +
> +		if (plane->crtc !=3D crtc)
> +			continue;
> +		if (rockchip_plane->enabled && !rockchip_plane->pending_fb)
> +			continue;
> +		if (!rockchip_plane->enabled && !rockchip_plane->front_fb)
> +			continue;
> +		/*
> +		 * make sure the yrgb_mst take effect, so that
> +		 * we can unreference the old framebuffer.
> +		 */
> +		yrgb_mst =3D VOP_WIN_GET_YRGBADDR(ctx, rockchip_plane->win);
> +		if (rockchip_plane->pending_yrgb_mst !=3D yrgb_mst) {
> +			/*
> +			 * some plane no complete, unref at next vblank
> +			 */
> +			ctx->vsync_work_pending =3D true;
> +			continue;
> +		}
> +
> +		/*
> +		 * drm_framebuffer_unreference maybe call iommu unmap,
> +		 * and iommu not allow unmap buffer at irq context,
> +		 * so we do drm_framebuffer_unreference at queue_work.
> +		 */
> +		if (rockchip_plane->front_fb)
> +			drm_framebuffer_unreference(rockchip_plane->front_fb);
> +
> +		rockchip_plane->front_fb =3D rockchip_plane->pending_fb;
> +		rockchip_plane->pending_fb =3D NULL;
> +
> +		/*
> +		 * if primary plane flip complete, sending the event to
> +		 * userspace
> +		 */
> +		if (&rockchip_plane->base =3D=3D crtc->primary)
> +			rockchip_drm_crtc_finish_pageflip(crtc);
> +	}
> +
> +	mutex_unlock(&ctx->vsync_mutex);
> +}
> +
> +static irqreturn_t rockchip_vop_isr(int irq, void *data)
> +{
> +	struct vop_context *ctx =3D data;
> +	uint32_t intr0_reg;
> +	unsigned long flags;
> +
> +	intr0_reg =3D vop_readl(ctx, INTR_CTRL0);
> +	if (intr0_reg & FS_INTR) {
> +		spin_lock_irqsave(&ctx->irq_lock, flags);
> +		vop_writel(ctx, INTR_CTRL0, intr0_reg | FS_INTR_CLR);
> +		spin_unlock_irqrestore(&ctx->irq_lock, flags);
> +	} else {
> +		return IRQ_NONE;
> +	}
> +
> +	drm_handle_vblank(ctx->drm_dev, ctx->pipe);
> +	if (ctx->vsync_work_pending)
> +		queue_work(ctx->vsync_wq, &ctx->vsync_work);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int vop_create_crtc(struct vop_context *ctx)
> +{
> +	struct device *dev =3D ctx->dev;
> +	struct drm_device *drm_dev =3D ctx->drm_dev;
> +	struct drm_plane *primary, *cursor, *plane;
> +	enum drm_plane_type plane_type;
> +	struct drm_crtc *crtc =3D &ctx->crtc;
> +	struct device_node *port;
> +	int ret;
> +	int nr;
> +
> +	for (nr =3D 0; nr < VOP_MAX_WIN_SUPPORT; nr++) {
> +		if (nr =3D=3D VOP_DEFAULT_PRIMARY)
> +			plane_type =3D DRM_PLANE_TYPE_PRIMARY;
> +		else if (nr =3D=3D VOP_DEFAULT_CURSOR)
> +			plane_type =3D DRM_PLANE_TYPE_CURSOR;
> +		else
> +			plane_type =3D DRM_PLANE_TYPE_OVERLAY;
> +
> +		plane =3D rockchip_plane_init(ctx, 0xff, plane_type, nr);
> +		if (IS_ERR(plane)) {
> +			ret =3D PTR_ERR(plane);
> +			DRM_ERROR("fail to init overlay plane - %d\n", ret);
> +			goto err_destroy_plane;
> +		}
> +
> +		if (plane_type =3D=3D DRM_PLANE_TYPE_PRIMARY)
> +			primary =3D plane;
> +		else if (plane_type =3D=3D DRM_PLANE_TYPE_CURSOR)
> +			cursor =3D plane;
> +	}
> +
> +	ret =3D drm_crtc_init_with_planes(drm_dev, crtc, primary, cursor,
> +					&rockchip_crtc_funcs);
> +	if (ret)
> +		goto err_destroy_plane;
> +
> +	drm_crtc_helper_add(crtc, &rockchip_crtc_helper_funcs);
> +
> +	port =3D of_get_child_by_name(dev->of_node, "port");
> +	if (!port) {
> +		DRM_ERROR("no port node found in %s\n",
> +			  dev->of_node->full_name);
> +		goto err_cleanup_crtc;
> +	}
> +
> +	drm_modeset_lock_all(drm_dev);
> +	crtc->port =3D port;
> +	ctx->pipe =3D drm_crtc_index(crtc);
> +	drm_modeset_unlock_all(drm_dev);
> +
> +	return 0;
> +
> +err_cleanup_crtc:
> +	drm_crtc_cleanup(crtc);
> +err_destroy_plane:
> +	mutex_lock(&drm_dev->mode_config.mutex);
> +	list_for_each_entry(plane, &drm_dev->mode_config.plane_list, head)
> +		plane->funcs->destroy(plane);
> +	mutex_unlock(&drm_dev->mode_config.mutex);
> +	return ret;
> +}
> +
> +static int rockchip_vop_initial(struct vop_context *ctx)
> +{
> +	struct vop_driver_data *vop_data =3D ctx->data;
> +	const struct vop_reg_data *init_table =3D vop_data->init_table;
> +	struct reset_control *ahb_rst;
> +	int i, ret;
> +
> +	ctx->hclk =3D devm_clk_get(ctx->dev, "hclk_vop");
> +	if (IS_ERR(ctx->hclk)) {
> +		dev_err(ctx->dev, "failed to get hclk source\n");
> +		return PTR_ERR(ctx->hclk);
> +	}
> +	ctx->aclk =3D devm_clk_get(ctx->dev, "aclk_vop");
> +	if (IS_ERR(ctx->aclk)) {
> +		dev_err(ctx->dev, "failed to get aclk source\n");
> +		return PTR_ERR(ctx->aclk);
> +	}
> +	ctx->dclk =3D devm_clk_get(ctx->dev, "dclk_vop");
> +	if (IS_ERR(ctx->dclk)) {
> +		dev_err(ctx->dev, "failed to get dclk source\n");
> +		return PTR_ERR(ctx->dclk);
> +	}
> +
> +	ret =3D clk_prepare(ctx->hclk);
> +	if (ret < 0) {
> +		dev_err(ctx->dev, "failed to prepare hclk\n");
> +		return ret;
> +	}
> +
> +	ret =3D clk_prepare(ctx->dclk);
> +	if (ret < 0) {
> +		dev_err(ctx->dev, "failed to prepare dclk\n");
> +		goto err_unprepare_hclk;
> +	}
> +
> +	ret =3D clk_prepare(ctx->aclk);
> +	if (ret < 0) {
> +		dev_err(ctx->dev, "failed to prepare aclk\n");
> +		goto err_unprepare_dclk;
> +	}
> +
> +	/*
> +	 * enable hclk, so that we can config vop register.
> +	 */
> +	ret =3D clk_enable(ctx->hclk);
> +	if (ret < 0) {
> +		dev_err(ctx->dev, "failed to prepare aclk\n");
> +		goto err_unprepare_aclk;
> +	}
> +	/*
> +	 * do hclk_reset, reset all vop registers.
> +	 */
> +	ahb_rst =3D devm_reset_control_get(ctx->dev, "ahb");
> +	if (IS_ERR(ahb_rst)) {
> +		dev_err(ctx->dev, "failed to get ahb reset\n");
> +		ret =3D PTR_ERR(ahb_rst);
> +		goto err_disable_hclk;
> +	}
> +	reset_control_assert(ahb_rst);
> +	usleep_range(10, 20);
> +	reset_control_deassert(ahb_rst);
> +
> +	memcpy(ctx->regsbak, ctx->regs, ctx->len);
> +
> +	for (i =3D 0; i < vop_data->table_size; i++)
> +		vop_writel(ctx, init_table[i].offset, init_table[i].value);
> +
> +	for (i =3D 0; i < VOP_MAX_WIN_SUPPORT; i++)
> +		VOP_WIN_SET(ctx, vop_data->win[i], enable, 0);
> +
> +	vop_cfg_done(ctx);
> +
> +	/*
> +	 * do dclk_reset, let all config take affect.
> +	 */
> +	ctx->dclk_rst =3D devm_reset_control_get(ctx->dev, "dclk");
> +	if (IS_ERR(ctx->dclk_rst)) {
> +		dev_err(ctx->dev, "failed to get dclk reset\n");
> +		ret =3D PTR_ERR(ctx->dclk_rst);
> +		goto err_unprepare_aclk;
> +	}
> +	reset_control_assert(ctx->dclk_rst);
> +	usleep_range(10, 20);
> +	reset_control_deassert(ctx->dclk_rst);
> +
> +	clk_disable(ctx->hclk);
> +
> +	ctx->dpms =3D DRM_MODE_DPMS_OFF;
> +
> +	return 0;
> +
> +err_disable_hclk:
> +	clk_disable(ctx->hclk);
> +err_unprepare_aclk:
> +	clk_unprepare(ctx->aclk);
> +err_unprepare_dclk:
> +	clk_unprepare(ctx->dclk);
> +err_unprepare_hclk:
> +	clk_unprepare(ctx->hclk);
> +	return ret;
> +}
> +
> +static int vop_bind(struct device *dev, struct device *master, void =
*data)
> +{
> +	struct platform_device *pdev =3D to_platform_device(dev);
> +	struct vop_driver_data *vop_data =3D vop_get_driver_data(dev);
> +	struct drm_device *drm_dev =3D data;
> +	struct vop_context *ctx;
> +	struct resource *res;
> +	int ret;
> +
> +	if (!vop_data)
> +		return -ENODEV;
> +
> +	ctx =3D devm_kzalloc(dev, sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx)
> +		return -ENOMEM;
> +
> +	ctx->dev =3D dev;
> +	ctx->data =3D vop_data;
> +	ctx->drm_dev =3D drm_dev;
> +	dev_set_drvdata(dev, ctx);
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	ctx->len =3D resource_size(res);
> +	ctx->regs =3D devm_ioremap_resource(dev, res);
> +	if (IS_ERR(ctx->regs))
> +		return PTR_ERR(ctx->regs);
> +
> +	ctx->regsbak =3D devm_kzalloc(dev, ctx->len, GFP_KERNEL);
> +	if (!ctx->regsbak)
> +		return -ENOMEM;
> +
> +	ret =3D rockchip_vop_initial(ctx);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "cannot initial vop dev - err %d\n", ret);
> +		return ret;
> +	}
> +
> +	ctx->irq =3D platform_get_irq(pdev, 0);
> +	if (ctx->irq < 0) {
> +		dev_err(dev, "cannot find irq for vop\n");
> +		return ctx->irq;
> +	}
> +
> +	spin_lock_init(&ctx->reg_lock);
> +	spin_lock_init(&ctx->irq_lock);
> +
> +	init_waitqueue_head(&ctx->wait_vsync_queue);
> +	atomic_set(&ctx->wait_vsync_event, 0);
> +
> +	ret =3D vop_iommu_init(ctx);
> +	if (ret) {
> +		DRM_ERROR("Failed to setup iommu, %d\n", ret);
> +		return ret;
> +	}
> +
> +	ctx->vsync_wq =3D create_singlethread_workqueue("vsync");
> +	if (!ctx->vsync_wq) {
> +		dev_err(dev, "failed to create workqueue\n");
> +		return -EINVAL;
> +	}
> +	INIT_WORK(&ctx->vsync_work, rockchip_vsync_worker);
> +
> +	mutex_init(&ctx->vsync_mutex);
> +	pm_runtime_enable(&pdev->dev);
> +
> +	ret =3D devm_request_irq(dev, ctx->irq, rockchip_vop_isr,
> +			       IRQF_SHARED, dev_name(dev), ctx);
> +	if (ret) {
> +		dev_err(dev, "cannot requeset irq%d - err %d\n", ctx->irq, ret);
> +		return ret;
> +	}
> +
> +	return vop_create_crtc(ctx);
> +}
> +
> +static void vop_unbind(struct device *dev, struct device *master,
> +		       void *data)
> +{
> +	struct vop_context *ctx =3D dev_get_drvdata(dev);
> +	struct drm_crtc *crtc =3D &ctx->crtc;
> +
> +	of_node_put(crtc->port);
> +	drm_crtc_cleanup(crtc);
> +	pm_runtime_disable(dev);
> +}
> +
> +static const struct component_ops vop_component_ops =3D {
> +	.bind =3D vop_bind,
> +	.unbind =3D vop_unbind,
> +};
> +
> +static int vop_probe(struct platform_device *pdev)
> +{
> +	struct device *dev =3D &pdev->dev;
> +	struct vop_context *ctx;
> +
> +	if (!dev->of_node) {
> +		dev_err(dev, "can't find vop devices\n");
> +		return -ENODEV;
> +	}
> +
> +	platform_set_drvdata(pdev, ctx);
> +
> +	return component_add(dev, &vop_component_ops);
> +}
> +
> +static int vop_remove(struct platform_device *pdev)
> +{
> +	component_del(&pdev->dev, &vop_component_ops);
> +
> +	return 0;
> +}
> +
> +struct platform_driver rockchip_vop_platform_driver =3D {
> +	.probe =3D vop_probe,
> +	.remove =3D vop_remove,
> +	.driver =3D {
> +		.name =3D "rockchip-vop",
> +		.owner =3D THIS_MODULE,
> +		.of_match_table =3D of_match_ptr(vop_driver_dt_match),
> +	},
> +};
> +
> +module_platform_driver(rockchip_vop_platform_driver);
> +
> +MODULE_AUTHOR("Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>");
> +MODULE_DESCRIPTION("ROCKCHIP VOP Driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.h b/drivers/gp=
u/drm/rockchip/rockchip_drm_vop.h
> new file mode 100644
> index 0000000..952317c
> --- /dev/null
> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.h
> @@ -0,0 +1,196 @@
> +/*
> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
> + * Author:Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
> + *
> + * This software is licensed under the terms of the GNU General Publ=
ic
> + * License version 2, as published by the Free Software Foundation, =
and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef _ROCKCHIP_DRM_VOP_H
> +#define _ROCKCHIP_DRM_VOP_H
> +
> +/* register definition */
> +#define REG_CFG_DONE			0x0000
> +#define VERSION_INFO			0x0004
> +#define SYS_CTRL			0x0008
> +#define SYS_CTRL1			0x000c
> +#define DSP_CTRL0			0x0010
> +#define DSP_CTRL1			0x0014
> +#define DSP_BG				0x0018
> +#define MCU_CTRL			0x001c
> +#define INTR_CTRL0			0x0020
> +#define INTR_CTRL1			0x0024
> +#define WIN0_CTRL0			0x0030
> +#define WIN0_CTRL1			0x0034
> +#define WIN0_COLOR_KEY			0x0038
> +#define WIN0_VIR			0x003c
> +#define WIN0_YRGB_MST			0x0040
> +#define WIN0_CBR_MST			0x0044
> +#define WIN0_ACT_INFO			0x0048
> +#define WIN0_DSP_INFO			0x004c
> +#define WIN0_DSP_ST			0x0050
> +#define WIN0_SCL_FACTOR_YRGB		0x0054
> +#define WIN0_SCL_FACTOR_CBR		0x0058
> +#define WIN0_SCL_OFFSET			0x005c
> +#define WIN0_SRC_ALPHA_CTRL		0x0060
> +#define WIN0_DST_ALPHA_CTRL		0x0064
> +#define WIN0_FADING_CTRL		0x0068
> +/* win1 register */
> +#define WIN1_CTRL0			0x0070
> +#define WIN1_CTRL1			0x0074
> +#define WIN1_COLOR_KEY			0x0078
> +#define WIN1_VIR			0x007c
> +#define WIN1_YRGB_MST			0x0080
> +#define WIN1_CBR_MST			0x0084
> +#define WIN1_ACT_INFO			0x0088
> +#define WIN1_DSP_INFO			0x008c
> +#define WIN1_DSP_ST			0x0090
> +#define WIN1_SCL_FACTOR_YRGB		0x0094
> +#define WIN1_SCL_FACTOR_CBR		0x0098
> +#define WIN1_SCL_OFFSET			0x009c
> +#define WIN1_SRC_ALPHA_CTRL		0x00a0
> +#define WIN1_DST_ALPHA_CTRL		0x00a4
> +#define WIN1_FADING_CTRL		0x00a8
> +/* win2 register */
> +#define WIN2_CTRL0			0x00b0
> +#define WIN2_CTRL1			0x00b4
> +#define WIN2_VIR0_1			0x00b8
> +#define WIN2_VIR2_3			0x00bc
> +#define WIN2_MST0			0x00c0
> +#define WIN2_DSP_INFO0			0x00c4
> +#define WIN2_DSP_ST0			0x00c8
> +#define WIN2_COLOR_KEY			0x00cc
> +#define WIN2_MST1			0x00d0
> +#define WIN2_DSP_INFO1			0x00d4
> +#define WIN2_DSP_ST1			0x00d8
> +#define WIN2_SRC_ALPHA_CTRL		0x00dc
> +#define WIN2_MST2			0x00e0
> +#define WIN2_DSP_INFO2			0x00e4
> +#define WIN2_DSP_ST2			0x00e8
> +#define WIN2_DST_ALPHA_CTRL		0x00ec
> +#define WIN2_MST3			0x00f0
> +#define WIN2_DSP_INFO3			0x00f4
> +#define WIN2_DSP_ST3			0x00f8
> +#define WIN2_FADING_CTRL		0x00fc
> +/* win3 register */
> +#define WIN3_CTRL0			0x0100
> +#define WIN3_CTRL1			0x0104
> +#define WIN3_VIR0_1			0x0108
> +#define WIN3_VIR2_3			0x010c
> +#define WIN3_MST0			0x0110
> +#define WIN3_DSP_INFO0			0x0114
> +#define WIN3_DSP_ST0			0x0118
> +#define WIN3_COLOR_KEY			0x011c
> +#define WIN3_MST1			0x0120
> +#define WIN3_DSP_INFO1			0x0124
> +#define WIN3_DSP_ST1			0x0128
> +#define WIN3_SRC_ALPHA_CTRL		0x012c
> +#define WIN3_MST2			0x0130
> +#define WIN3_DSP_INFO2			0x0134
> +#define WIN3_DSP_ST2			0x0138
> +#define WIN3_DST_ALPHA_CTRL		0x013c
> +#define WIN3_MST3			0x0140
> +#define WIN3_DSP_INFO3			0x0144
> +#define WIN3_DSP_ST3			0x0148
> +#define WIN3_FADING_CTRL		0x014c
> +/* hwc register */
> +#define HWC_CTRL0			0x0150
> +#define HWC_CTRL1			0x0154
> +#define HWC_MST				0x0158
> +#define HWC_DSP_ST			0x015c
> +#define HWC_SRC_ALPHA_CTRL		0x0160
> +#define HWC_DST_ALPHA_CTRL		0x0164
> +#define HWC_FADING_CTRL			0x0168
> +/* post process register */
> +#define POST_DSP_HACT_INFO		0x0170
> +#define POST_DSP_VACT_INFO		0x0174
> +#define POST_SCL_FACTOR_YRGB		0x0178
> +#define POST_SCL_CTRL			0x0180
> +#define POST_DSP_VACT_INFO_F1		0x0184
> +#define DSP_HTOTAL_HS_END		0x0188
> +#define DSP_HACT_ST_END			0x018c
> +#define DSP_VTOTAL_VS_END		0x0190
> +#define DSP_VACT_ST_END			0x0194
> +#define DSP_VS_ST_END_F1		0x0198
> +#define DSP_VACT_ST_END_F1		0x019c
> +/* register definition end */
> +
> +/* interrupt define */
> +#define DSP_HOLD_VALID_INTR		(1 << 0)
> +#define FS_INTR				(1 << 1)
> +#define LINE_FLAG_INTR			(1 << 2)
> +#define BUS_ERROR_INTR			(1 << 3)
> +
> +#define DSP_HOLD_VALID_INTR_EN(x)	((x) << 4)
> +#define FS_INTR_EN(x)			((x) << 5)
> +#define LINE_FLAG_INTR_EN(x)		((x) << 6)
> +#define BUS_ERROR_INTR_EN(x)		((x) << 7)
> +#define DSP_HOLD_VALID_INTR_MASK	(1 << 4)
> +#define FS_INTR_MASK			(1 << 5)
> +#define LINE_FLAG_INTR_MASK		(1 << 6)
> +#define BUS_ERROR_INTR_MASK		(1 << 7)
> +
> +#define DSP_HOLD_VALID_INTR_CLR		(1 << 8)
> +#define FS_INTR_CLR			(1 << 9)
> +#define LINE_FLAG_INTR_CLR		(1 << 10)
> +#define BUS_ERROR_INTR_CLR		(1 << 11)
> +#define DSP_LINE_NUM(x)			(((x) & 0x1fff) << 12)
> +#define DSP_LINE_NUM_MASK		(0x1fff << 12)
> +
> +/* src alpha ctrl define */
> +#define SRC_FADING_VALUE(x)		(((x) & 0xff) << 24)
> +#define SRC_GLOBAL_ALPHA(x)		(((x) & 0xff) << 16)
> +#define SRC_FACTOR_M0(x)		(((x) & 0x7) << 6)
> +#define SRC_ALPHA_CAL_M0(x)		(((x) & 0x1) << 5)
> +#define SRC_BLEND_M0(x)			(((x) & 0x3) << 3)
> +#define SRC_ALPHA_M0(x)			(((x) & 0x1) << 2)
> +#define SRC_COLOR_M0(x)			(((x) & 0x1) << 1)
> +#define SRC_ALPHA_EN(x)			(((x) & 0x1) << 0)
> +/* dst alpha ctrl define */
> +#define DST_FACTOR_M0(x)		(((x) & 0x7) << 6)
> +
> +/*
> + * display output interface supported by rockchip lcdc
> + */
> +#define ROCKCHIP_OUT_MODE_P888	0
> +#define ROCKCHIP_OUT_MODE_P666	1
> +#define ROCKCHIP_OUT_MODE_P565	2
> +/* for use special outface */
> +#define ROCKCHIP_OUT_MODE_AAAA	15
> +
> +enum alpha_mode {
> +	ALPHA_STRAIGHT,
> +	ALPHA_INVERSE,
> +};
> +
> +enum global_blend_mode {
> +	ALPHA_GLOBAL,
> +	ALPHA_PER_PIX,
> +	ALPHA_PER_PIX_GLOBAL,
> +};
> +
> +enum alpha_cal_mode {
> +	ALPHA_SATURATION,
> +	ALPHA_NO_SATURATION,
> +};
> +
> +enum color_mode {
> +	ALPHA_SRC_PRE_MUL,
> +	ALPHA_SRC_NO_PRE_MUL,
> +};
> +
> +enum factor_mode {
> +	ALPHA_ZERO,
> +	ALPHA_ONE,
> +	ALPHA_SRC,
> +	ALPHA_SRC_INVERSE,
> +	ALPHA_SRC_GLOBAL,
> +};
> +
> +#endif /* _ROCKCHIP_DRM_VOP_H */
