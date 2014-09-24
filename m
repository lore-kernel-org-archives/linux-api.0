From: Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Subject: Re: [PATCH v4 1/5] drm/rockchip: Add basic drm driver
Date: Wed, 24 Sep 2014 17:31:39 +0800
Message-ID: <54228F7B.2050608@rock-chips.com>
References: <1411382820-1615-1-git-send-email-mark.yao@rock-chips.com> <1411382934-1763-1-git-send-email-mark.yao@rock-chips.com> <20140924082037.GJ15734@phenom.ffwll.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140924082037.GJ15734-dv86pmgwkMBes7Z6vYuT8azUEOm+Xw19@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org, Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, David Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rom Lemarchand <romlem-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kever.yang-TNX95d0MmH7DzftRWevZcw@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, xjq-TNX95d0MmH7DzftRWevZcw@public.gmane.org, zyw-TNX95d0MmH7DzftRWevZcw@public.gmane.org, cym-TNX95d0MmH7DzftRWevZcw@public.gmane.org, linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kfx-TNX95d0MmH7DzftRWevZcw@public.gmane.org, wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org, huangtao-TNX95d0MmH7DzftRWevZcw@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yxj-TNX95d0MmH7DzftRWevZcw@public.gmane.org, marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, xxm@rock-chi
List-Id: linux-api@vger.kernel.org

On 2014=E5=B9=B409=E6=9C=8824=E6=97=A5 16:20, Daniel Vetter wrote:
> On Mon, Sep 22, 2014 at 06:48:54PM +0800, Mark yao wrote:
>> This patch adds the basic structure of a DRM Driver for Rockchip Soc=
s.
>>
>> Signed-off-by: Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
>> ---
>> Changes in v2:
>> - use the component framework to defer main drm driver probe
>>    until all VOP devices have been probed.
>> - use dma-mapping API with ARM_DMA_USE_IOMMU, create dma mapping by
>>    master device and each vop device can shared the drm dma mapping.
>> - use drm_crtc_init_with_planes and drm_universal_plane_init.
>> - remove unnecessary middle layers.
>> - add cursor set, move funcs to rockchip drm crtc.
>> - use vop reset at first init
>> - reference framebuffer when used and unreference when swap out vop
>>
>> Changes in v3:
>> - change "crtc->fb" to "crtc->primary-fb"
>> Adviced by Daniel Vetter
>> - init cursor plane with universal api, remove unnecessary cursor se=
t,move
>>
>> Changes in v4:
>> Adviced by David Herrmann
>> - remove drm_platform_*() usage, use register drm device directly.
>> Adviced by Rob Clark
>> - remove special mmap ioctl, do userspace mmap with normal mmap() or=
 mmap offset
>>
>>   drivers/gpu/drm/Kconfig                       |    2 +
>>   drivers/gpu/drm/Makefile                      |    1 +
>>   drivers/gpu/drm/rockchip/Kconfig              |   19 +
>>   drivers/gpu/drm/rockchip/Makefile             |   10 +
>>   drivers/gpu/drm/rockchip/rockchip_drm_drv.c   |  524 ++++++++++
>>   drivers/gpu/drm/rockchip/rockchip_drm_drv.h   |  120 +++
>>   drivers/gpu/drm/rockchip/rockchip_drm_fb.c    |  201 ++++
>>   drivers/gpu/drm/rockchip/rockchip_drm_fb.h    |   28 +
>>   drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c |  231 +++++
>>   drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h |   20 +
>>   drivers/gpu/drm/rockchip/rockchip_drm_gem.c   |  404 ++++++++
>>   drivers/gpu/drm/rockchip/rockchip_drm_gem.h   |   72 ++
>>   drivers/gpu/drm/rockchip/rockchip_drm_vop.c   | 1372 +++++++++++++=
++++++++++++
>>   drivers/gpu/drm/rockchip/rockchip_drm_vop.h   |  187 ++++
>>   include/uapi/drm/rockchip_drm.h               |   75 ++
> uapi is still here ... Was this an oversight?
> -Daniel
>
Hi, Daniel
this version is old, newest is v5. and I remove uapi at v5.
you can see v5 patch at:
https://lkml.org/lkml/2014/9/23/1061
thanks
-Mark
>>   15 files changed, 3266 insertions(+)
>>   create mode 100644 drivers/gpu/drm/rockchip/Kconfig
>>   create mode 100644 drivers/gpu/drm/rockchip/Makefile
>>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_drv.c
>>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_drv.h
>>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fb.c
>>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fb.h
>>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c
>>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h
>>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_gem.c
>>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_gem.h
>>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_vop.c
>>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_vop.h
>>   create mode 100644 include/uapi/drm/rockchip_drm.h
>>
>> diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
>> index b066bb3..7c4c3c6 100644
>> --- a/drivers/gpu/drm/Kconfig
>> +++ b/drivers/gpu/drm/Kconfig
>> @@ -171,6 +171,8 @@ config DRM_SAVAGE
>>  =20
>>   source "drivers/gpu/drm/exynos/Kconfig"
>>  =20
>> +source "drivers/gpu/drm/rockchip/Kconfig"
>> +
>>   source "drivers/gpu/drm/vmwgfx/Kconfig"
>>  =20
>>   source "drivers/gpu/drm/gma500/Kconfig"
>> diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
>> index 4a55d59..d03387a 100644
>> --- a/drivers/gpu/drm/Makefile
>> +++ b/drivers/gpu/drm/Makefile
>> @@ -52,6 +52,7 @@ obj-$(CONFIG_DRM_VMWGFX)+=3D vmwgfx/
>>   obj-$(CONFIG_DRM_VIA)	+=3Dvia/
>>   obj-$(CONFIG_DRM_NOUVEAU) +=3Dnouveau/
>>   obj-$(CONFIG_DRM_EXYNOS) +=3Dexynos/
>> +obj-$(CONFIG_DRM_ROCKCHIP) +=3Drockchip/
>>   obj-$(CONFIG_DRM_GMA500) +=3D gma500/
>>   obj-$(CONFIG_DRM_UDL) +=3D udl/
>>   obj-$(CONFIG_DRM_AST) +=3D ast/
>> diff --git a/drivers/gpu/drm/rockchip/Kconfig b/drivers/gpu/drm/rock=
chip/Kconfig
>> new file mode 100644
>> index 0000000..7146c80
>> --- /dev/null
>> +++ b/drivers/gpu/drm/rockchip/Kconfig
>> @@ -0,0 +1,19 @@
>> +config DRM_ROCKCHIP
>> +	tristate "DRM Support for Rockchip"
>> +	depends on DRM && ROCKCHIP_IOMMU
>> +	select ARM_DMA_USE_IOMMU
>> +	select IOMMU_API
>> +	select DRM_KMS_HELPER
>> +	select DRM_KMS_FB_HELPER
>> +	select DRM_PANEL
>> +	select FB_CFB_FILLRECT
>> +	select FB_CFB_COPYAREA
>> +	select FB_CFB_IMAGEBLIT
>> +	select VT_HW_CONSOLE_BINDING if FRAMEBUFFER_CONSOLE
>> +	select VIDEOMODE_HELPERS
>> +	help
>> +	  Choose this option if you have a Rockchip soc chipset.
>> +	  This driver provides kernel mode setting and buffer
>> +	  management to userspace. This driver does not provides
>> +	  2D or 3D acceleration; acceleration is performed by other
>> +	  IP found on the SoC.
>> diff --git a/drivers/gpu/drm/rockchip/Makefile b/drivers/gpu/drm/roc=
kchip/Makefile
>> new file mode 100644
>> index 0000000..6e6d468
>> --- /dev/null
>> +++ b/drivers/gpu/drm/rockchip/Makefile
>> @@ -0,0 +1,10 @@
>> +#
>> +# Makefile for the drm device driver.  This driver provides support=
 for the
>> +# Direct Rendering Infrastructure (DRI) in XFree86 4.1.0 and higher=
=2E
>> +
>> +ccflags-y :=3D -Iinclude/drm -Idrivers/gpu/drm/rockchip
>> +
>> +rockchipdrm-y :=3D rockchip_drm_drv.o rockchip_drm_fb.o rockchip_dr=
m_fbdev.o \
>> +		rockchip_drm_gem.o rockchip_drm_vop.o
>> +
>> +obj-$(CONFIG_DRM_ROCKCHIP) +=3D rockchipdrm.o
>> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_drv.c b/drivers/g=
pu/drm/rockchip/rockchip_drm_drv.c
>> new file mode 100644
>> index 0000000..94926cb
>> --- /dev/null
>> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_drv.c
>> @@ -0,0 +1,524 @@
>> +/*
>> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
>> + * Author:Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
>> + *
>> + * based on exynos_drm_drv.c
>> + *
>> + * This software is licensed under the terms of the GNU General Pub=
lic
>> + * License version 2, as published by the Free Software Foundation,=
 and
>> + * may be copied, distributed, and modified under those terms.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <asm/dma-iommu.h>
>> +
>> +#include <drm/drmP.h>
>> +#include <drm/drm_crtc_helper.h>
>> +#include <drm/drm_fb_helper.h>
>> +#include <linux/dma-mapping.h>
>> +#include <linux/pm_runtime.h>
>> +#include <linux/of_graph.h>
>> +#include <linux/component.h>
>> +
>> +#include <drm/rockchip_drm.h>
>> +
>> +#include "rockchip_drm_drv.h"
>> +#include "rockchip_drm_fb.h"
>> +#include "rockchip_drm_fbdev.h"
>> +#include "rockchip_drm_gem.h"
>> +
>> +#define DRIVER_NAME	"rockchip"
>> +#define DRIVER_DESC	"RockChip Soc DRM"
>> +#define DRIVER_DATE	"20140818"
>> +#define DRIVER_MAJOR	1
>> +#define DRIVER_MINOR	0
>> +
>> +/*
>> + * Attach a (component) device to the shared drm dma mapping from m=
aster drm
>> + * device.  This is used by the VOPs to map GEM buffers to a common=
 DMA
>> + * mapping.
>> + */
>> +int rockchip_drm_dma_attach_device(struct drm_device *drm_dev,
>> +				   struct device *dev)
>> +{
>> +	struct dma_iommu_mapping *mapping =3D drm_dev->dev->archdata.mappi=
ng;
>> +	int ret;
>> +
>> +	ret =3D dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
>> +	if (ret)
>> +		return ret;
>> +
>> +	dma_set_max_seg_size(dev, 0xffffffffu);
>> +
>> +	return arm_iommu_attach_device(dev, mapping);
>> +}
>> +
>> +void rockchip_drm_dma_detach_device(struct drm_device *drm_dev,
>> +				    struct device *dev)
>> +{
>> +	arm_iommu_detach_device(drm_dev->dev);
>> +}
>> +
>> +static int rockchip_drm_load(struct drm_device *drm_dev, unsigned l=
ong flags)
>> +{
>> +	struct rockchip_drm_private *private;
>> +	struct dma_iommu_mapping *mapping;
>> +	struct device *dev =3D drm_dev->dev;
>> +	int ret;
>> +
>> +	private =3D devm_kzalloc(drm_dev->dev, sizeof(*private), GFP_KERNE=
L);
>> +	if (!private)
>> +		return -ENOMEM;
>> +
>> +	dev_set_drvdata(drm_dev->dev, dev);
>> +	drm_dev->dev_private =3D private;
>> +
>> +	drm_mode_config_init(drm_dev);
>> +
>> +	rockchip_drm_mode_config_init(drm_dev);
>> +
>> +	dev->dma_parms =3D devm_kzalloc(dev, sizeof(*dev->dma_parms),
>> +				      GFP_KERNEL);
>> +	if (!dev->dma_parms) {
>> +		ret =3D -ENOMEM;
>> +		goto err_config_cleanup;
>> +	}
>> +
>> +	/* TODO(djkurtz): fetch the mapping start/size from somewhere */
>> +	mapping =3D arm_iommu_create_mapping(&platform_bus_type, 0x1000000=
0,
>> +					   SZ_1G);
>> +	if (IS_ERR(mapping)) {
>> +		ret =3D PTR_ERR(mapping);
>> +		goto err_config_cleanup;
>> +	}
>> +
>> +	dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
>> +	dma_set_max_seg_size(dev, 0xffffffffu);
>> +
>> +	ret =3D arm_iommu_attach_device(dev, mapping);
>> +	if (ret)
>> +		goto err_release_mapping;
>> +
>> +	/* Try to bind all sub drivers. */
>> +	ret =3D component_bind_all(dev, drm_dev);
>> +	if (ret)
>> +		goto err_detach_device;
>> +
>> +	/* init kms poll for handling hpd */
>> +	drm_kms_helper_poll_init(drm_dev);
>> +
>> +	/*
>> +	 * enable drm irq mode.
>> +	 * - with irq_enabled =3D true, we can use the vblank feature.
>> +	 */
>> +	drm_dev->irq_enabled =3D true;
>> +
>> +	/*
>> +	 * with vblank_disable_allowed =3D true, vblank interrupt will be =
disabled
>> +	 * by drm timer once a current process gives up ownership of
>> +	 * vblank event.(after drm_vblank_put function is called)
>> +	 */
>> +	drm_dev->vblank_disable_allowed =3D true;
>> +
>> +	ret =3D drm_vblank_init(drm_dev, ROCKCHIP_MAX_CRTC);
>> +	if (ret)
>> +		goto err_kms_helper_poll_fini;
>> +
>> +	rockchip_drm_fbdev_init(drm_dev);
>> +
>> +	/* force connectors detection */
>> +	drm_helper_hpd_irq_event(drm_dev);
>> +
>> +	return 0;
>> +
>> +err_kms_helper_poll_fini:
>> +	drm_kms_helper_poll_fini(drm_dev);
>> +	component_unbind_all(dev, drm_dev);
>> +err_detach_device:
>> +	arm_iommu_detach_device(dev);
>> +err_release_mapping:
>> +	arm_iommu_release_mapping(dev->archdata.mapping);
>> +err_config_cleanup:
>> +	drm_mode_config_cleanup(drm_dev);
>> +	drm_dev->dev_private =3D NULL;
>> +	dev_set_drvdata(dev, NULL);
>> +	return ret;
>> +}
>> +
>> +static int rockchip_drm_unload(struct drm_device *drm_dev)
>> +{
>> +	struct device *dev =3D drm_dev->dev;
>> +
>> +	drm_kms_helper_poll_fini(drm_dev);
>> +	component_unbind_all(dev, drm_dev);
>> +	arm_iommu_detach_device(dev);
>> +	arm_iommu_release_mapping(dev->archdata.mapping);
>> +	drm_mode_config_cleanup(drm_dev);
>> +	drm_dev->dev_private =3D NULL;
>> +	dev_set_drvdata(dev, NULL);
>> +
>> +	return 0;
>> +}
>> +
>> +static int rockchip_drm_suspend(struct drm_device *dev, pm_message_=
t state)
>> +{
>> +	struct drm_connector *connector;
>> +
>> +	drm_modeset_lock_all(dev);
>> +	list_for_each_entry(connector, &dev->mode_config.connector_list, h=
ead) {
>> +		int old_dpms =3D connector->dpms;
>> +
>> +		if (connector->funcs->dpms)
>> +			connector->funcs->dpms(connector, DRM_MODE_DPMS_OFF);
>> +
>> +		/* Set the old mode back to the connector for resume */
>> +		connector->dpms =3D old_dpms;
>> +	}
>> +	drm_modeset_unlock_all(dev);
>> +
>> +	return 0;
>> +}
>> +
>> +static int rockchip_drm_resume(struct drm_device *dev)
>> +{
>> +	struct drm_connector *connector;
>> +
>> +	drm_modeset_lock_all(dev);
>> +	list_for_each_entry(connector, &dev->mode_config.connector_list, h=
ead) {
>> +		if (connector->funcs->dpms)
>> +			connector->funcs->dpms(connector, connector->dpms);
>> +	}
>> +	drm_modeset_unlock_all(dev);
>> +
>> +	drm_helper_resume_force_mode(dev);
>> +
>> +	return 0;
>> +}
>> +
>> +void rockchip_drm_lastclose(struct drm_device *dev)
>> +{
>> +	struct rockchip_drm_private *priv =3D dev->dev_private;
>> +
>> +	drm_modeset_lock_all(dev);
>> +	if (priv->fb_helper)
>> +		drm_fb_helper_restore_fbdev_mode(priv->fb_helper);
>> +	drm_modeset_unlock_all(dev);
>> +}
>> +
>> +static const struct drm_ioctl_desc rockchip_ioctls[] =3D {
>> +	DRM_IOCTL_DEF_DRV(ROCKCHIP_GEM_CREATE, rockchip_gem_create_ioctl,
>> +			  DRM_UNLOCKED | DRM_AUTH),
>> +	DRM_IOCTL_DEF_DRV(ROCKCHIP_GEM_GET, rockchip_gem_get_ioctl,
>> +			  DRM_UNLOCKED),
>> +	DRM_IOCTL_DEF_DRV(ROCKCHIP_GEM_MAP_OFFSET,
>> +			  rockchip_gem_map_offset_ioctl, DRM_UNLOCKED |
>> +			  DRM_AUTH),
>> +};
>> +
>> +static const struct file_operations rockchip_drm_driver_fops =3D {
>> +	.owner =3D THIS_MODULE,
>> +	.open =3D drm_open,
>> +	.mmap =3D rockchip_drm_gem_mmap,
>> +	.poll =3D drm_poll,
>> +	.read =3D drm_read,
>> +	.unlocked_ioctl =3D drm_ioctl,
>> +#ifdef CONFIG_COMPAT
>> +	.compat_ioctl =3D drm_compat_ioctl,
>> +#endif
>> +	.release =3D drm_release,
>> +};
>> +
>> +const struct vm_operations_struct rockchip_drm_vm_ops =3D {
>> +	.open =3D drm_gem_vm_open,
>> +	.close =3D drm_gem_vm_close,
>> +};
>> +
>> +static struct drm_driver rockchip_drm_driver =3D {
>> +	.driver_features	=3D DRIVER_MODESET | DRIVER_GEM | DRIVER_PRIME,
>> +	.load			=3D rockchip_drm_load,
>> +	.unload			=3D rockchip_drm_unload,
>> +	.lastclose		=3D rockchip_drm_lastclose,
>> +	.suspend		=3D rockchip_drm_suspend,
>> +	.resume			=3D rockchip_drm_resume,
>> +	.get_vblank_counter	=3D drm_vblank_count,
>> +	.enable_vblank		=3D rockchip_drm_crtc_enable_vblank,
>> +	.disable_vblank		=3D rockchip_drm_crtc_disable_vblank,
>> +	.gem_vm_ops		=3D &rockchip_drm_vm_ops,
>> +	.gem_free_object	=3D rockchip_gem_free_object,
>> +	.dumb_create		=3D rockchip_gem_dumb_create,
>> +	.dumb_map_offset	=3D rockchip_gem_dumb_map_offset,
>> +	.dumb_destroy		=3D drm_gem_dumb_destroy,
>> +	.prime_handle_to_fd	=3D drm_gem_prime_handle_to_fd,
>> +	.prime_fd_to_handle	=3D drm_gem_prime_fd_to_handle,
>> +	.gem_prime_import	=3D drm_gem_prime_import,
>> +	.gem_prime_export	=3D drm_gem_prime_export,
>> +	.gem_prime_get_sg_table	=3D rockchip_gem_prime_get_sg_table,
>> +	.gem_prime_import_sg_table	=3D rockchip_gem_prime_import_sg_table,
>> +	.gem_prime_vmap		=3D rockchip_gem_prime_vmap,
>> +	.gem_prime_vunmap	=3D rockchip_gem_prime_vunmap,
>> +	.gem_prime_mmap		=3D rockchip_gem_prime_mmap,
>> +	.ioctls			=3D rockchip_ioctls,
>> +	.num_ioctls		=3D ARRAY_SIZE(rockchip_ioctls),
>> +	.fops			=3D &rockchip_drm_driver_fops,
>> +	.name	=3D DRIVER_NAME,
>> +	.desc	=3D DRIVER_DESC,
>> +	.date	=3D DRIVER_DATE,
>> +	.major	=3D DRIVER_MAJOR,
>> +	.minor	=3D DRIVER_MINOR,
>> +};
>> +
>> +#ifdef CONFIG_PM_SLEEP
>> +static int rockchip_drm_sys_suspend(struct device *dev)
>> +{
>> +	struct drm_device *drm_dev =3D dev_get_drvdata(dev);
>> +	pm_message_t message;
>> +
>> +	if (pm_runtime_suspended(dev))
>> +		return 0;
>> +
>> +	message.event =3D PM_EVENT_SUSPEND;
>> +
>> +	return rockchip_drm_suspend(drm_dev, message);
>> +}
>> +
>> +static int rockchip_drm_sys_resume(struct device *dev)
>> +{
>> +	struct drm_device *drm_dev =3D dev_get_drvdata(dev);
>> +
>> +	if (pm_runtime_suspended(dev))
>> +		return 0;
>> +
>> +	return rockchip_drm_resume(drm_dev);
>> +}
>> +#endif
>> +
>> +static const struct dev_pm_ops rockchip_drm_pm_ops =3D {
>> +	SET_SYSTEM_SLEEP_PM_OPS(rockchip_drm_sys_suspend,
>> +				rockchip_drm_sys_resume)
>> +};
>> +
>> +int rockchip_drm_add_crtc(struct drm_device *drm, struct drm_crtc *=
crtc,
>> +			  struct device_node *np)
>> +{
>> +	struct rockchip_drm_private *priv =3D drm->dev_private;
>> +	struct device_node *port;
>> +	int pipe;
>> +
>> +	if (priv->num_pipe >=3D ROCKCHIP_MAX_CRTC)
>> +		return -EINVAL;
>> +
>> +	port =3D of_get_child_by_name(np, "port");
>> +	of_node_put(np);
>> +	if (!port) {
>> +		dev_err(drm->dev, "no port node found in %s\n",
>> +			np->full_name);
>> +		return -ENXIO;
>> +	}
>> +	pipe =3D priv->num_pipe++;
>> +	crtc->port =3D port;
>> +
>> +	priv->crtc[pipe] =3D crtc;
>> +
>> +	return pipe;
>> +}
>> +
>> +void rockchip_drm_remove_crtc(struct drm_device *drm, int pipe)
>> +{
>> +	struct rockchip_drm_private *priv =3D drm->dev_private;
>> +
>> +	priv->num_pipe--;
>> +	of_node_put(priv->crtc[pipe]->port);
>> +	priv->crtc[pipe] =3D NULL;
>> +}
>> +
>> +struct drm_crtc *rockchip_find_crtc(struct drm_device *drm, int pip=
e)
>> +{
>> +	struct rockchip_drm_private *priv =3D drm->dev_private;
>> +
>> +	if (pipe < ROCKCHIP_MAX_CRTC && priv->crtc[pipe])
>> +		return priv->crtc[pipe];
>> +
>> +	return NULL;
>> +}
>> +
>> +/*
>> + * @node: device tree node containing encoder input ports
>> + * @encoder: drm_encoder
>> + */
>> +int rockchip_drm_encoder_get_mux_id(struct device_node *node,
>> +				    struct drm_encoder *encoder)
>> +{
>> +	struct device_node *ep =3D NULL;
>> +	struct drm_crtc *crtc =3D encoder->crtc;
>> +	struct of_endpoint endpoint;
>> +	struct device_node *port;
>> +	int ret;
>> +
>> +	if (!node || !crtc)
>> +		return -EINVAL;
>> +
>> +	do {
>> +		ep =3D of_graph_get_next_endpoint(node, ep);
>> +		if (!ep)
>> +			break;
>> +
>> +		port =3D of_graph_get_remote_port(ep);
>> +		of_node_put(port);
>> +		if (port =3D=3D crtc->port) {
>> +			ret =3D of_graph_parse_endpoint(ep, &endpoint);
>> +			return ret ? ret : endpoint.id;
>> +		}
>> +	} while (ep);
>> +
>> +	return -EINVAL;
>> +}
>> +
>> +static int compare_of(struct device *dev, void *data)
>> +{
>> +	struct device_node *np =3D data;
>> +
>> +	return dev->of_node =3D=3D np;
>> +}
>> +
>> +static void rockchip_add_endpoints(struct device *dev,
>> +				   struct component_match **match,
>> +				   struct device_node *port)
>> +{
>> +	struct device_node *ep, *remote;
>> +
>> +	for_each_child_of_node(port, ep) {
>> +		remote =3D of_graph_get_remote_port_parent(ep);
>> +		if (!remote || !of_device_is_available(remote)) {
>> +			of_node_put(remote);
>> +			continue;
>> +		} else if (!of_device_is_available(remote->parent)) {
>> +			dev_warn(dev, "parent device of %s is not available\n",
>> +				 remote->full_name);
>> +			of_node_put(remote);
>> +			continue;
>> +		}
>> +
>> +		component_match_add(dev, match, compare_of, remote);
>> +		of_node_put(remote);
>> +	}
>> +}
>> +
>> +static int rockchip_drm_bind(struct device *dev)
>> +{
>> +	struct drm_device *drm;
>> +	int ret;
>> +
>> +	drm =3D drm_dev_alloc(&rockchip_drm_driver, dev);
>> +	if (!drm)
>> +		return -ENOMEM;
>> +
>> +	ret =3D drm_dev_set_unique(drm, "%s", dev_name(dev));
>> +	if (ret)
>> +		goto err_free;
>> +
>> +	ret =3D drm_dev_register(drm, 0);
>> +	if (ret)
>> +		goto err_free;
>> +
>> +	dev_set_drvdata(dev, drm);
>> +
>> +	return 0;
>> +
>> +err_free:
>> +	drm_dev_unref(drm);
>> +	return ret;
>> +}
>> +
>> +static void rockchip_drm_unbind(struct device *dev)
>> +{
>> +	struct drm_device *drm =3D dev_get_drvdata(dev);
>> +
>> +	drm_dev_unregister(drm);
>> +	drm_dev_unref(drm);
>> +}
>> +
>> +static const struct component_master_ops rockchip_drm_ops =3D {
>> +	.bind =3D rockchip_drm_bind,
>> +	.unbind =3D rockchip_drm_unbind,
>> +};
>> +
>> +static int rockchip_drm_platform_probe(struct platform_device *pdev=
)
>> +{
>> +	struct device *dev =3D &pdev->dev;
>> +	struct component_match *match =3D NULL;
>> +	struct device_node *np =3D dev->of_node;
>> +	struct device_node *port;
>> +	int i;
>> +	int ret;
>> +
>> +	if (!np)
>> +		return -ENODEV;
>> +	/*
>> +	 * Bind the crtc ports first, so that
>> +	 * drm_of_find_possible_crtcs called from encoder .bind callbacks
>> +	 * works as expected.
>> +	 */
>> +	for (i =3D 0;; i++) {
>> +		port =3D of_parse_phandle(np, "ports", i);
>> +		if (!port)
>> +			break;
>> +
>> +		component_match_add(dev, &match, compare_of, port->parent);
>> +		of_node_put(port);
>> +	}
>> +
>> +	if (i =3D=3D 0) {
>> +		dev_err(dev, "missing 'ports' property\n");
>> +		return -ENODEV;
>> +	}
>> +	/*
>> +	 * For each bound crtc, bind the encoders attached to its
>> +	 * remote endpoint.
>> +	 */
>> +	for (i =3D 0;; i++) {
>> +		port =3D of_parse_phandle(np, "ports", i);
>> +		if (!port)
>> +			break;
>> +
>> +		rockchip_add_endpoints(dev, &match, port);
>> +		of_node_put(port);
>> +	}
>> +
>> +	ret =3D dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
>> +	if (ret)
>> +		return ret;
>> +
>> +	return component_master_add_with_match(dev, &rockchip_drm_ops, mat=
ch);
>> +}
>> +
>> +static int rockchip_drm_platform_remove(struct platform_device *pde=
v)
>> +{
>> +	component_master_del(&pdev->dev, &rockchip_drm_ops);
>> +	return 0;
>> +}
>> +
>> +static const struct of_device_id rockchip_drm_dt_ids[] =3D {
>> +	{ .compatible =3D "rockchip,display-subsystem", },
>> +	{ /* sentinel */ },
>> +};
>> +MODULE_DEVICE_TABLE(of, rockchip_drm_dt_ids);
>> +
>> +static struct platform_driver rockchip_drm_platform_driver =3D {
>> +	.probe =3D rockchip_drm_platform_probe,
>> +	.remove =3D rockchip_drm_platform_remove,
>> +	.driver =3D {
>> +		.owner =3D THIS_MODULE,
>> +		.name =3D "rockchip-drm",
>> +		.of_match_table =3D rockchip_drm_dt_ids,
>> +	},
>> +};
>> +
>> +module_platform_driver(rockchip_drm_platform_driver);
>> +
>> +MODULE_AUTHOR("Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>");
>> +MODULE_DESCRIPTION("ROCKCHIP DRM Driver");
>> +MODULE_LICENSE("GPL v2");
>> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_drv.h b/drivers/g=
pu/drm/rockchip/rockchip_drm_drv.h
>> new file mode 100644
>> index 0000000..154b3ec
>> --- /dev/null
>> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_drv.h
>> @@ -0,0 +1,120 @@
>> +/*
>> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
>> + * Author:Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
>> + *
>> + * based on exynos_drm_drv.h
>> + *
>> + * This software is licensed under the terms of the GNU General Pub=
lic
>> + * License version 2, as published by the Free Software Foundation,=
 and
>> + * may be copied, distributed, and modified under those terms.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#ifndef _ROCKCHIP_DRM_DRV_H
>> +#define _ROCKCHIP_DRM_DRV_H
>> +
>> +#include <linux/module.h>
>> +#include <linux/component.h>
>> +
>> +#define ROCKCHIP_MAX_FB_BUFFER	4
>> +#define ROCKCHIP_MAX_CONNECTOR	2
>> +
>> +struct drm_device;
>> +struct drm_connector;
>> +
>> +/*
>> + * display output interface supported by rockchip lcdc
>> + */
>> +#define ROCKCHIP_OUTFACE_P888	0
>> +#define ROCKCHIP_OUTFACE_P666	1
>> +#define ROCKCHIP_OUTFACE_P565	2
>> +/* for use special outface */
>> +#define ROCKCHIP_OUTFACE_AAAA	15
>> +
>> +#define ROCKCHIP_COLOR_SWAP_RG	0x1
>> +#define ROCKCHIP_COLOR_SWAP_RB	0x2
>> +#define ROCKCHIP_COLOR_SWAP_GB	0x4
>> +
>> +/*
>> + * Special mode info for rockchip
>> + *
>> + * @out_type: lcd controller need to know the sceen type.
>> + */
>> +struct rockchip_display_mode {
>> +	int out_type;
>> +};
>> +
>> +#define ROCKCHIP_EVENT_HOTPLUG	1
>> +
>> +enum rockchip_plane_type {
>> +	ROCKCHIP_WIN0,
>> +	ROCKCHIP_WIN1,
>> +	ROCKCHIP_WIN2,
>> +	ROCKCHIP_WIN3,
>> +	ROCKCHIP_CURSOR,
>> +	ROCKCHIP_MAX_PLANE,
>> +};
>> +
>> +/* This enumerates device type. */
>> +enum rockchip_drm_device_type {
>> +	ROCKCHIP_DEVICE_TYPE_NONE,
>> +	ROCKCHIP_DEVICE_TYPE_CRTC,
>> +	ROCKCHIP_DEVICE_TYPE_CONNECTOR,
>> +};
>> +
>> +/* this enumerates display type. */
>> +enum rockchip_drm_output_type {
>> +	ROCKCHIP_DISPLAY_TYPE_NONE =3D 0,
>> +	/* RGB Interface. */
>> +	ROCKCHIP_DISPLAY_TYPE_RGB,
>> +	/* LVDS Interface. */
>> +	ROCKCHIP_DISPLAY_TYPE_LVDS,
>> +	/* EDP Interface. */
>> +	ROCKCHIP_DISPLAY_TYPE_EDP,
>> +	/* MIPI Interface. */
>> +	ROCKCHIP_DISPLAY_TYPE_MIPI,
>> +	/* HDMI Interface. */
>> +	ROCKCHIP_DISPLAY_TYPE_HDMI,
>> +};
>> +
>> +enum rockchip_crtc_type {
>> +	ROCKCHIP_CRTC_VOPB,
>> +	ROCKCHIP_CRTC_VOPL,
>> +	ROCKCHIP_MAX_CRTC,
>> +};
>> +
>> +/*
>> + * Rockchip drm private structure.
>> + *
>> + * @num_pipe: number of pipes for this device.
>> + */
>> +struct rockchip_drm_private {
>> +	struct drm_fb_helper *fb_helper;
>> +	/*
>> +	 * created crtc object would be contained at this array and
>> +	 * this array is used to be aware of which crtc did it request vbl=
ank.
>> +	 */
>> +	struct drm_crtc *crtc[ROCKCHIP_MAX_CRTC];
>> +
>> +	unsigned int num_pipe;
>> +};
>> +
>> +int rockchip_drm_add_crtc(struct drm_device *drm, struct drm_crtc *=
crtc,
>> +			  struct device_node *port);
>> +void rockchip_drm_remove_crtc(struct drm_device *drm, int pipe);
>> +struct drm_crtc *rockchip_find_crtc(struct drm_device *drm, int pip=
e);
>> +int rockchip_drm_encoder_get_mux_id(struct device_node *node,
>> +				    struct drm_encoder *encoder);
>> +void rockchip_drm_crtc_finish_pageflip(struct drm_device *dev, int =
pipe);
>> +void rockchip_drm_crtc_cancel_pending_flip(struct drm_device *dev);
>> +int rockchip_drm_crtc_enable_vblank(struct drm_device *dev, int pip=
e);
>> +void rockchip_drm_crtc_disable_vblank(struct drm_device *dev, int p=
ipe);
>> +int rockchip_drm_dma_attach_device(struct drm_device *drm_dev,
>> +				   struct device *dev);
>> +void rockchip_drm_dma_detach_device(struct drm_device *drm_dev,
>> +				    struct device *dev);
>> +#endif /* _ROCKCHIP_DRM_DRV_H_ */
>> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_fb.c b/drivers/gp=
u/drm/rockchip/rockchip_drm_fb.c
>> new file mode 100644
>> index 0000000..b319505
>> --- /dev/null
>> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_fb.c
>> @@ -0,0 +1,201 @@
>> +/*
>> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
>> + * Author:Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
>> + *
>> + * This software is licensed under the terms of the GNU General Pub=
lic
>> + * License version 2, as published by the Free Software Foundation,=
 and
>> + * may be copied, distributed, and modified under those terms.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <drm/drmP.h>
>> +#include <drm/drm_fb_helper.h>
>> +#include <drm/drm_crtc_helper.h>
>> +#include <uapi/drm/rockchip_drm.h>
>> +
>> +#include "rockchip_drm_drv.h"
>> +#include "rockchip_drm_gem.h"
>> +
>> +#define to_rockchip_fb(x) container_of(x, struct rockchip_drm_fb, f=
b)
>> +
>> +struct rockchip_drm_fb {
>> +	struct drm_framebuffer fb;
>> +	struct drm_gem_object *obj[ROCKCHIP_MAX_FB_BUFFER];
>> +};
>> +
>> +struct drm_gem_object *rockchip_fb_get_gem_obj(struct drm_framebuff=
er *fb,
>> +					       unsigned int plane)
>> +{
>> +	struct rockchip_drm_fb *rk_fb =3D to_rockchip_fb(fb);
>> +
>> +	if (plane >=3D ROCKCHIP_MAX_FB_BUFFER)
>> +		return NULL;
>> +
>> +	return rk_fb->obj[plane];
>> +}
>> +
>> +static void rockchip_drm_fb_destroy(struct drm_framebuffer *fb)
>> +{
>> +	struct rockchip_drm_fb *rockchip_fb =3D to_rockchip_fb(fb);
>> +	struct drm_gem_object *obj;
>> +	int i;
>> +
>> +	for (i =3D 0; i < ROCKCHIP_MAX_FB_BUFFER; i++) {
>> +		obj =3D rockchip_fb->obj[i];
>> +		if (obj)
>> +			drm_gem_object_unreference_unlocked(obj);
>> +	}
>> +
>> +	drm_framebuffer_cleanup(fb);
>> +	kfree(rockchip_fb);
>> +}
>> +
>> +static int rockchip_drm_fb_create_handle(struct drm_framebuffer *fb=
,
>> +					 struct drm_file *file_priv,
>> +					 unsigned int *handle)
>> +{
>> +	struct rockchip_drm_fb *rockchip_fb =3D to_rockchip_fb(fb);
>> +
>> +	return drm_gem_handle_create(file_priv,
>> +				     rockchip_fb->obj[0], handle);
>> +}
>> +
>> +static struct drm_framebuffer_funcs rockchip_drm_fb_funcs =3D {
>> +	.destroy	=3D rockchip_drm_fb_destroy,
>> +	.create_handle	=3D rockchip_drm_fb_create_handle,
>> +};
>> +
>> +static struct rockchip_drm_fb *
>> +rockchip_fb_alloc(struct drm_device *dev, struct drm_mode_fb_cmd2 *=
mode_cmd,
>> +		  struct drm_gem_object **obj, unsigned int num_planes)
>> +{
>> +	struct rockchip_drm_fb *rockchip_fb;
>> +	int ret;
>> +	int i;
>> +
>> +	rockchip_fb =3D kzalloc(sizeof(*rockchip_fb), GFP_KERNEL);
>> +	if (!rockchip_fb)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	drm_helper_mode_fill_fb_struct(&rockchip_fb->fb, mode_cmd);
>> +
>> +	for (i =3D 0; i < num_planes; i++)
>> +		rockchip_fb->obj[i] =3D obj[i];
>> +
>> +	ret =3D drm_framebuffer_init(dev, &rockchip_fb->fb,
>> +				   &rockchip_drm_fb_funcs);
>> +	if (ret) {
>> +		dev_err(dev->dev, "Failed to initialize framebuffer: %d\n",
>> +			ret);
>> +		kfree(rockchip_fb);
>> +		return ERR_PTR(ret);
>> +	}
>> +
>> +	return rockchip_fb;
>> +}
>> +
>> +static struct drm_framebuffer *
>> +rockchip_user_fb_create(struct drm_device *dev, struct drm_file *fi=
le_priv,
>> +			struct drm_mode_fb_cmd2 *mode_cmd)
>> +{
>> +	struct rockchip_drm_fb *rockchip_fb;
>> +	struct drm_gem_object *objs[ROCKCHIP_MAX_FB_BUFFER];
>> +	struct drm_gem_object *obj;
>> +	unsigned int hsub;
>> +	unsigned int vsub;
>> +	int num_planes;
>> +	int ret;
>> +	int i;
>> +
>> +	hsub =3D drm_format_horz_chroma_subsampling(mode_cmd->pixel_format=
);
>> +	vsub =3D drm_format_vert_chroma_subsampling(mode_cmd->pixel_format=
);
>> +	num_planes =3D min(drm_format_num_planes(mode_cmd->pixel_format),
>> +			 ROCKCHIP_MAX_FB_BUFFER);
>> +
>> +	for (i =3D 0; i < num_planes; i++) {
>> +		unsigned int width =3D mode_cmd->width / (i ? hsub : 1);
>> +		unsigned int height =3D mode_cmd->height / (i ? vsub : 1);
>> +		unsigned int min_size;
>> +
>> +		obj =3D drm_gem_object_lookup(dev, file_priv,
>> +					    mode_cmd->handles[i]);
>> +		if (!obj) {
>> +			dev_err(dev->dev, "Failed to lookup GEM object\n");
>> +			ret =3D -ENXIO;
>> +			goto err_gem_object_unreference;
>> +		}
>> +
>> +		min_size =3D (height - 1) * mode_cmd->pitches[i] +
>> +			mode_cmd->offsets[i] +
>> +			width * drm_format_plane_cpp(mode_cmd->pixel_format, i);
>> +
>> +		if (obj->size < min_size) {
>> +			drm_gem_object_unreference_unlocked(obj);
>> +			ret =3D -EINVAL;
>> +			goto err_gem_object_unreference;
>> +		}
>> +		objs[i] =3D obj;
>> +	}
>> +
>> +	rockchip_fb =3D rockchip_fb_alloc(dev, mode_cmd, objs, i);
>> +	if (IS_ERR(rockchip_fb)) {
>> +		ret =3D PTR_ERR(rockchip_fb);
>> +		goto err_gem_object_unreference;
>> +	}
>> +
>> +	return &rockchip_fb->fb;
>> +
>> +err_gem_object_unreference:
>> +	for (i--; i >=3D 0; i--)
>> +		drm_gem_object_unreference_unlocked(objs[i]);
>> +	return ERR_PTR(ret);
>> +}
>> +
>> +static void rockchip_drm_output_poll_changed(struct drm_device *dev=
)
>> +{
>> +	struct rockchip_drm_private *private =3D dev->dev_private;
>> +	struct drm_fb_helper *fb_helper =3D private->fb_helper;
>> +
>> +	if (fb_helper)
>> +		drm_fb_helper_hotplug_event(fb_helper);
>> +}
>> +
>> +static const struct drm_mode_config_funcs rockchip_drm_mode_config_=
funcs =3D {
>> +	.fb_create =3D rockchip_user_fb_create,
>> +	.output_poll_changed =3D rockchip_drm_output_poll_changed,
>> +};
>> +
>> +struct drm_framebuffer *
>> +rockchip_drm_framebuffer_init(struct drm_device *dev,
>> +			      struct drm_mode_fb_cmd2 *mode_cmd,
>> +			      struct drm_gem_object *obj)
>> +{
>> +	struct rockchip_drm_fb *rockchip_fb;
>> +
>> +	rockchip_fb =3D rockchip_fb_alloc(dev, mode_cmd, &obj, 1);
>> +	if (IS_ERR(rockchip_fb))
>> +		return NULL;
>> +
>> +	return &rockchip_fb->fb;
>> +}
>> +
>> +void rockchip_drm_mode_config_init(struct drm_device *dev)
>> +{
>> +	dev->mode_config.min_width =3D 0;
>> +	dev->mode_config.min_height =3D 0;
>> +
>> +	/*
>> +	 * set max width and height as default value(4096x4096).
>> +	 * this value would be used to check framebuffer size limitation
>> +	 * at drm_mode_addfb().
>> +	 */
>> +	dev->mode_config.max_width =3D 4096;
>> +	dev->mode_config.max_height =3D 4096;
>> +
>> +	dev->mode_config.funcs =3D &rockchip_drm_mode_config_funcs;
>> +}
>> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_fb.h b/drivers/gp=
u/drm/rockchip/rockchip_drm_fb.h
>> new file mode 100644
>> index 0000000..09574d4
>> --- /dev/null
>> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_fb.h
>> @@ -0,0 +1,28 @@
>> +/*
>> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
>> + * Author:Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
>> + *
>> + * This software is licensed under the terms of the GNU General Pub=
lic
>> + * License version 2, as published by the Free Software Foundation,=
 and
>> + * may be copied, distributed, and modified under those terms.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#ifndef _ROCKCHIP_DRM_FB_H
>> +#define _ROCKCHIP_DRM_FB_H
>> +
>> +struct drm_framebuffer *
>> +rockchip_drm_framebuffer_init(struct drm_device *dev,
>> +			      struct drm_mode_fb_cmd2 *mode_cmd,
>> +			      struct drm_gem_object *obj);
>> +void rockchip_drm_framebuffer_fini(struct drm_framebuffer *fb);
>> +
>> +void rockchip_drm_mode_config_init(struct drm_device *dev);
>> +
>> +struct drm_gem_object *rockchip_fb_get_gem_obj(struct drm_framebuff=
er *fb,
>> +					       unsigned int plane);
>> +#endif /* _ROCKCHIP_DRM_FB_H */
>> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c b/drivers=
/gpu/drm/rockchip/rockchip_drm_fbdev.c
>> new file mode 100644
>> index 0000000..fe1bb22
>> --- /dev/null
>> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c
>> @@ -0,0 +1,231 @@
>> +/*
>> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
>> + * Author:Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
>> + *
>> + * This software is licensed under the terms of the GNU General Pub=
lic
>> + * License version 2, as published by the Free Software Foundation,=
 and
>> + * may be copied, distributed, and modified under those terms.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <drm/drmP.h>
>> +#include <drm/drm_fb_helper.h>
>> +#include <drm/drm_crtc_helper.h>
>> +
>> +#include <drm/rockchip_drm.h>
>> +
>> +#include "rockchip_drm_drv.h"
>> +#include "rockchip_drm_gem.h"
>> +#include "rockchip_drm_fb.h"
>> +
>> +#define PREFERRED_BPP		32
>> +#define to_rockchip_fbdev(x) container_of(x, struct rockchip_fbdev,=
 helper)
>> +
>> +struct rockchip_fbdev {
>> +	struct drm_fb_helper helper;
>> +	struct drm_gem_object *bo;
>> +};
>> +
>> +static int rockchip_fbdev_mmap(struct fb_info *info,
>> +			       struct vm_area_struct *vma)
>> +{
>> +	struct drm_fb_helper *helper =3D info->par;
>> +	struct rockchip_fbdev *fbdev =3D to_rockchip_fbdev(helper);
>> +
>> +	return rockchip_gem_mmap(fbdev->bo, vma);
>> +}
>> +
>> +static struct fb_ops rockchip_drm_fbdev_ops =3D {
>> +	.owner		=3D THIS_MODULE,
>> +	.fb_mmap	=3D rockchip_fbdev_mmap,
>> +	.fb_fillrect	=3D cfb_fillrect,
>> +	.fb_copyarea	=3D cfb_copyarea,
>> +	.fb_imageblit	=3D cfb_imageblit,
>> +	.fb_check_var	=3D drm_fb_helper_check_var,
>> +	.fb_set_par	=3D drm_fb_helper_set_par,
>> +	.fb_blank	=3D drm_fb_helper_blank,
>> +	.fb_pan_display	=3D drm_fb_helper_pan_display,
>> +	.fb_setcmap	=3D drm_fb_helper_setcmap,
>> +};
>> +
>> +static int rockchip_drm_fbdev_create(struct drm_fb_helper *helper,
>> +				     struct drm_fb_helper_surface_size *sizes)
>> +{
>> +	struct rockchip_fbdev *fbdev =3D to_rockchip_fbdev(helper);
>> +	struct drm_mode_fb_cmd2 mode_cmd =3D { 0 };
>> +	struct drm_device *dev =3D helper->dev;
>> +	struct rockchip_gem_object *rk_obj;
>> +	struct drm_framebuffer *fb;
>> +	unsigned int bytes_per_pixel;
>> +	unsigned long offset;
>> +	struct fb_info *fbi;
>> +	size_t size;
>> +	int ret;
>> +
>> +	bytes_per_pixel =3D DIV_ROUND_UP(sizes->surface_bpp, 8);
>> +
>> +	mode_cmd.width =3D sizes->surface_width;
>> +	mode_cmd.height =3D sizes->surface_height;
>> +	mode_cmd.pitches[0] =3D sizes->surface_width * bytes_per_pixel;
>> +	mode_cmd.pixel_format =3D drm_mode_legacy_fb_format(sizes->surface=
_bpp,
>> +		sizes->surface_depth);
>> +
>> +	size =3D mode_cmd.pitches[0] * mode_cmd.height;
>> +
>> +	rk_obj =3D rockchip_gem_create_object(dev, size);
>> +	if (IS_ERR(rk_obj))
>> +		return -ENOMEM;
>> +
>> +	fbdev->bo =3D &rk_obj->base;
>> +
>> +	fbi =3D framebuffer_alloc(0, dev->dev);
>> +	if (!fbi) {
>> +		dev_err(dev->dev, "Failed to allocate framebuffer info.\n");
>> +		ret =3D -ENOMEM;
>> +		goto err_rockchip_gem_free_object;
>> +	}
>> +
>> +	helper->fb =3D rockchip_drm_framebuffer_init(dev, &mode_cmd, fbdev=
->bo);
>> +	if (IS_ERR(helper->fb)) {
>> +		dev_err(dev->dev, "Failed to allocate DRM framebuffer.\n");
>> +		ret =3D PTR_ERR(helper->fb);
>> +		goto err_framebuffer_release;
>> +	}
>> +
>> +	helper->fbdev =3D fbi;
>> +
>> +	fbi->par =3D helper;
>> +	fbi->flags =3D FBINFO_FLAG_DEFAULT;
>> +	fbi->fbops =3D &rockchip_drm_fbdev_ops;
>> +
>> +	ret =3D fb_alloc_cmap(&fbi->cmap, 256, 0);
>> +	if (ret) {
>> +		dev_err(dev->dev, "Failed to allocate color map.\n");
>> +		goto err_drm_framebuffer_unref;
>> +	}
>> +
>> +	fb =3D helper->fb;
>> +	drm_fb_helper_fill_fix(fbi, fb->pitches[0], fb->depth);
>> +	drm_fb_helper_fill_var(fbi, helper, fb->width, fb->height);
>> +
>> +	offset =3D fbi->var.xoffset * bytes_per_pixel;
>> +	offset +=3D fbi->var.yoffset * fb->pitches[0];
>> +
>> +	dev->mode_config.fb_base =3D 0;
>> +	fbi->screen_base =3D rk_obj->kvaddr + offset;
>> +	fbi->screen_size =3D rk_obj->base.size;
>> +	fbi->fix.smem_len =3D rk_obj->base.size;
>> +
>> +	DRM_DEBUG_KMS("FB [%dx%d]-%d kvaddr=3D%p offset=3D%ld size=3D%d\n"=
,
>> +		      fb->width, fb->height, fb->depth, rk_obj->kvaddr,
>> +		      offset, size);
>> +	return 0;
>> +
>> +err_drm_framebuffer_unref:
>> +	drm_framebuffer_unreference(helper->fb);
>> +err_framebuffer_release:
>> +	framebuffer_release(fbi);
>> +err_rockchip_gem_free_object:
>> +	rockchip_gem_free_object(&rk_obj->base);
>> +	return ret;
>> +}
>> +
>> +static struct drm_fb_helper_funcs rockchip_drm_fb_helper_funcs =3D =
{
>> +	.fb_probe =3D rockchip_drm_fbdev_create,
>> +};
>> +
>> +int rockchip_drm_fbdev_init(struct drm_device *dev)
>> +{
>> +	struct rockchip_drm_private *private =3D dev->dev_private;
>> +	struct rockchip_fbdev *fbdev;
>> +	struct drm_fb_helper *helper;
>> +	unsigned int num_crtc;
>> +	int ret;
>> +
>> +	if (!dev->mode_config.num_crtc || !dev->mode_config.num_connector)
>> +		return -EINVAL;
>> +
>> +	if (private->fb_helper) {
>> +		DRM_ERROR("no allow to reinit fbdev\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	num_crtc =3D dev->mode_config.num_crtc;
>> +
>> +	fbdev =3D kzalloc(sizeof(*fbdev), GFP_KERNEL);
>> +	if (!fbdev)
>> +		return -ENOMEM;
>> +
>> +	fbdev->helper.funcs =3D &rockchip_drm_fb_helper_funcs;
>> +	helper =3D &fbdev->helper;
>> +
>> +	ret =3D drm_fb_helper_init(dev, helper, num_crtc, ROCKCHIP_MAX_CON=
NECTOR);
>> +	if (ret < 0) {
>> +		dev_err(dev->dev, "Failed to initialize drm fb helper.\n");
>> +		goto err_free;
>> +	}
>> +
>> +	ret =3D drm_fb_helper_single_add_all_connectors(helper);
>> +	if (ret < 0) {
>> +		dev_err(dev->dev, "Failed to add connectors.\n");
>> +		goto err_drm_fb_helper_fini;
>> +	}
>> +
>> +	/* disable all the possible outputs/crtcs before entering KMS mode=
 */
>> +	drm_helper_disable_unused_functions(dev);
>> +
>> +	ret =3D drm_fb_helper_initial_config(helper, PREFERRED_BPP);
>> +	if (ret < 0) {
>> +		dev_err(dev->dev, "Failed to set initial hw configuration.\n");
>> +		goto err_drm_fb_helper_fini;
>> +	}
>> +
>> +	private->fb_helper =3D helper;
>> +
>> +	return 0;
>> +
>> +err_drm_fb_helper_fini:
>> +	drm_fb_helper_fini(helper);
>> +err_free:
>> +	kfree(fbdev);
>> +	return ret;
>> +}
>> +
>> +void rockchip_drm_fbdev_fini(struct drm_device *dev)
>> +{
>> +	struct rockchip_drm_private *private =3D dev->dev_private;
>> +	struct drm_fb_helper *helper;
>> +	struct rockchip_fbdev *fbdev;
>> +
>> +	if (!private || !private->fb_helper)
>> +		return;
>> +
>> +	helper =3D private->fb_helper;
>> +	fbdev =3D to_rockchip_fbdev(helper);
>> +
>> +	if (helper->fbdev) {
>> +		struct fb_info *info;
>> +		int ret;
>> +
>> +		info =3D helper->fbdev;
>> +		ret =3D unregister_framebuffer(info);
>> +		if (ret < 0)
>> +			DRM_DEBUG_KMS("failed unregister_framebuffer()\n");
>> +
>> +		if (info->cmap.len)
>> +			fb_dealloc_cmap(&info->cmap);
>> +
>> +		framebuffer_release(info);
>> +	}
>> +
>> +	if (helper->fb)
>> +		drm_framebuffer_unreference(helper->fb);
>> +
>> +	drm_fb_helper_fini(helper);
>> +	kfree(fbdev);
>> +	private->fb_helper =3D NULL;
>> +}
>> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h b/drivers=
/gpu/drm/rockchip/rockchip_drm_fbdev.h
>> new file mode 100644
>> index 0000000..5edcf6a
>> --- /dev/null
>> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h
>> @@ -0,0 +1,20 @@
>> +/*
>> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
>> + * Author:Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
>> + *
>> + * This software is licensed under the terms of the GNU General Pub=
lic
>> + * License version 2, as published by the Free Software Foundation,=
 and
>> + * may be copied, distributed, and modified under those terms.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#ifndef _ROCKCHIP_DRM_FBDEV_H
>> +#define _ROCKCHIP_DRM_FBDEV_H
>> +
>> +int rockchip_drm_fbdev_init(struct drm_device *dev);
>> +
>> +#endif /* _ROCKCHIP_DRM_FBDEV_H */
>> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c b/drivers/g=
pu/drm/rockchip/rockchip_drm_gem.c
>> new file mode 100644
>> index 0000000..2f34e92
>> --- /dev/null
>> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
>> @@ -0,0 +1,404 @@
>> +/*
>> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
>> + * Author:Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
>> + *
>> + * This software is licensed under the terms of the GNU General Pub=
lic
>> + * License version 2, as published by the Free Software Foundation,=
 and
>> + * may be copied, distributed, and modified under those terms.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <drm/drmP.h>
>> +#include <drm/drm_vma_manager.h>
>> +#include <drm/rockchip_drm.h>
>> +
>> +#include <linux/anon_inodes.h>
>> +#include <linux/dma-attrs.h>
>> +
>> +#include "rockchip_drm_drv.h"
>> +#include "rockchip_drm_gem.h"
>> +
>> +static int rockchip_gem_alloc_buf(struct rockchip_gem_object *rk_ob=
j)
>> +{
>> +	struct drm_gem_object *obj =3D &rk_obj->base;
>> +	struct drm_device *drm =3D obj->dev;
>> +
>> +	init_dma_attrs(&rk_obj->dma_attrs);
>> +	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &rk_obj->dma_attrs);
>> +
>> +	/* TODO(djkurtz): Use DMA_ATTR_NO_KERNEL_MAPPING except for fbdev =
*/
>> +	rk_obj->kvaddr =3D dma_alloc_attrs(drm->dev, obj->size,
>> +					 &rk_obj->dma_addr, GFP_KERNEL,
>> +					 &rk_obj->dma_attrs);
>> +	if (IS_ERR(rk_obj->kvaddr)) {
>> +		int ret =3D PTR_ERR(rk_obj->kvaddr);
>> +
>> +		DRM_ERROR("failed to allocate %#x byte dma buffer, %d",
>> +			  obj->size, ret);
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static void rockchip_gem_free_buf(struct rockchip_gem_object *rk_ob=
j)
>> +{
>> +	struct drm_gem_object *obj =3D &rk_obj->base;
>> +	struct drm_device *drm =3D obj->dev;
>> +
>> +	dma_free_attrs(drm->dev, obj->size, rk_obj->kvaddr, rk_obj->dma_ad=
dr,
>> +		       &rk_obj->dma_attrs);
>> +}
>> +
>> +/* drm driver mmap file operations */
>> +int rockchip_drm_gem_mmap(struct file *filp, struct vm_area_struct =
*vma)
>> +{
>> +	struct drm_file *priv =3D filp->private_data;
>> +	struct drm_device *dev =3D priv->minor->dev;
>> +	struct drm_gem_object *obj;
>> +	struct drm_vma_offset_node *node;
>> +	int ret;
>> +
>> +	if (drm_device_is_unplugged(dev))
>> +		return -ENODEV;
>> +
>> +	mutex_lock(&dev->struct_mutex);
>> +
>> +	node =3D drm_vma_offset_exact_lookup(dev->vma_offset_manager,
>> +					   vma->vm_pgoff,
>> +					   vma_pages(vma));
>> +	if (!node) {
>> +		mutex_unlock(&dev->struct_mutex);
>> +		DRM_ERROR("failed to find vma node.\n");
>> +		return -EINVAL;
>> +	} else if (!drm_vma_node_is_allowed(node, filp)) {
>> +		mutex_unlock(&dev->struct_mutex);
>> +		return -EACCES;
>> +	}
>> +
>> +	obj =3D container_of(node, struct drm_gem_object, vma_node);
>> +	ret =3D rockchip_gem_mmap(obj, vma);
>> +
>> +	mutex_unlock(&dev->struct_mutex);
>> +
>> +	return ret;
>> +}
>> +
>> +int rockchip_drm_gem_mmap_buffer(struct file *filp,
>> +				 struct vm_area_struct *vma)
>> +{
>> +	struct drm_gem_object *obj =3D filp->private_data;
>> +
>> +	return rockchip_gem_mmap(obj, vma);
>> +}
>> +
>> +static const struct file_operations rockchip_drm_gem_fops =3D {
>> +	.mmap =3D rockchip_drm_gem_mmap_buffer,
>> +};
>> +
>> +struct rockchip_gem_object *
>> +	rockchip_gem_create_object(struct drm_device *drm, unsigned int si=
ze)
>> +{
>> +	struct rockchip_gem_object *rk_obj;
>> +	struct drm_gem_object *obj;
>> +	struct file *filp;
>> +	int ret;
>> +
>> +	size =3D round_up(size, PAGE_SIZE);
>> +
>> +	rk_obj =3D kzalloc(sizeof(*rk_obj), GFP_KERNEL);
>> +	if (!rk_obj)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	obj =3D &rk_obj->base;
>> +
>> +	drm_gem_private_object_init(drm, obj, size);
>> +
>> +	filp =3D anon_inode_getfile("rockchip_gem", &rockchip_drm_gem_fops=
,
>> +				  obj, 0);
>> +	if (IS_ERR(filp)) {
>> +		DRM_ERROR("failed to create anon file object.\n");
>> +		ret =3D PTR_ERR(filp);
>> +		goto err_free_rk_obj;
>> +	}
>> +	filp->f_mode =3D FMODE_READ | FMODE_WRITE;
>> +	obj->filp =3D filp;
>> +
>> +	ret =3D drm_gem_create_mmap_offset(obj);
>> +	if (ret)
>> +		goto err_free_obj;
>> +
>> +	ret =3D rockchip_gem_alloc_buf(rk_obj);
>> +	if (ret)
>> +		goto err_free_mmap_offset;
>> +
>> +	return rk_obj;
>> +
>> +err_free_mmap_offset:
>> +	drm_gem_free_mmap_offset(obj);
>> +err_free_obj:
>> +	drm_gem_object_release(obj);
>> +err_free_rk_obj:
>> +	kfree(rk_obj);
>> +	return ERR_PTR(ret);
>> +}
>> +
>> +/*
>> + * rockchip_gem_free_object - (struct drm_driver)->gem_free_object =
callback
>> + * function
>> + */
>> +void rockchip_gem_free_object(struct drm_gem_object *obj)
>> +{
>> +	struct rockchip_gem_object *rk_obj;
>> +
>> +	drm_gem_free_mmap_offset(obj);
>> +
>> +	rk_obj =3D to_rockchip_obj(obj);
>> +
>> +	rockchip_gem_free_buf(rk_obj);
>> +	drm_gem_free_mmap_offset(obj);
>> +
>> +	drm_gem_object_release(obj);
>> +
>> +	kfree(rk_obj);
>> +}
>> +
>> +int rockchip_gem_mmap(struct drm_gem_object *obj, struct vm_area_st=
ruct *vma)
>> +{
>> +	struct rockchip_gem_object *rk_obj =3D to_rockchip_obj(obj);
>> +	struct drm_device *drm =3D obj->dev;
>> +	unsigned long vm_size;
>> +
>> +	vma->vm_flags |=3D VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
>> +	vm_size =3D vma->vm_end - vma->vm_start;
>> +
>> +	if (vm_size > obj->size)
>> +		return -EINVAL;
>> +
>> +	return dma_mmap_attrs(drm->dev, vma, rk_obj->kvaddr, rk_obj->dma_a=
ddr,
>> +			     obj->size, &rk_obj->dma_attrs);
>> +}
>> +
>> +/*
>> + * rockchip_gem_create_with_handle - allocate an object with the gi=
ven
>> + * size and create a gem handle on it
>> + *
>> + * returns a struct rockchip_gem_object* on success or ERR_PTR valu=
es
>> + * on failure.
>> + */
>> +static struct rockchip_gem_object *
>> +rockchip_gem_create_with_handle(struct drm_file *file_priv,
>> +				struct drm_device *drm, unsigned int size,
>> +				unsigned int *handle)
>> +{
>> +	struct rockchip_gem_object *rk_obj;
>> +	struct drm_gem_object *obj;
>> +	int ret;
>> +
>> +	rk_obj =3D rockchip_gem_create_object(drm, size);
>> +	if (IS_ERR(rk_obj))
>> +		return NULL;
>> +
>> +	obj =3D &rk_obj->base;
>> +
>> +	/*
>> +	 * allocate a id of idr table where the obj is registered
>> +	 * and handle has the id what user can see.
>> +	 */
>> +	ret =3D drm_gem_handle_create(file_priv, obj, handle);
>> +	if (ret)
>> +		goto err_handle_create;
>> +
>> +	/* drop reference from allocate - handle holds it now. */
>> +	drm_gem_object_unreference_unlocked(obj);
>> +
>> +	return rk_obj;
>> +
>> +err_handle_create:
>> +	rockchip_gem_free_object(obj);
>> +
>> +	return ERR_PTR(ret);
>> +}
>> +
>> +int rockchip_gem_dumb_map_offset(struct drm_file *file_priv,
>> +				 struct drm_device *dev, uint32_t handle,
>> +				 uint64_t *offset)
>> +{
>> +	struct drm_gem_object *obj;
>> +	int ret =3D 0;
>> +
>> +	mutex_lock(&dev->struct_mutex);
>> +
>> +	/*
>> +	 * get offset of memory allocated for drm framebuffer.
>> +	 * - this callback would be called by user application
>> +	 * with DRM_IOCTL_MODE_MAP_DUMB command.
>> +	 */
>> +
>> +	obj =3D drm_gem_object_lookup(dev, file_priv, handle);
>> +	if (!obj) {
>> +		DRM_ERROR("failed to lookup gem object.\n");
>> +		ret =3D -EINVAL;
>> +		goto unlock;
>> +	}
>> +
>> +	ret =3D drm_gem_create_mmap_offset(obj);
>> +	if (ret)
>> +		goto out;
>> +
>> +	*offset =3D drm_vma_node_offset_addr(&obj->vma_node);
>> +	DRM_DEBUG_KMS("offset =3D 0x%lx\n", (unsigned long)*offset);
>> +
>> +out:
>> +	drm_gem_object_unreference(obj);
>> +unlock:
>> +	mutex_unlock(&dev->struct_mutex);
>> +	return ret;
>> +}
>> +
>> +/*
>> + * rockchip_gem_dumb_create - (struct drm_driver)->dumb_create call=
back
>> + * function
>> + *
>> + * This aligns the pitch and size arguments to the minimum required=
=2E wrap
>> + * this into your own function if you need bigger alignment.
>> + */
>> +int rockchip_gem_dumb_create(struct drm_file *file_priv,
>> +			     struct drm_device *dev,
>> +			     struct drm_mode_create_dumb *args)
>> +{
>> +	struct rockchip_gem_object *rk_obj;
>> +	int min_pitch =3D DIV_ROUND_UP(args->width * args->bpp, 8);
>> +
>> +	if (args->pitch < min_pitch)
>> +		args->pitch =3D min_pitch;
>> +
>> +	if (args->size < args->pitch * args->height)
>> +		args->size =3D args->pitch * args->height;
>> +
>> +	rk_obj =3D rockchip_gem_create_with_handle(file_priv, dev, args->s=
ize,
>> +						 &args->handle);
>> +
>> +	return PTR_ERR_OR_ZERO(rk_obj);
>> +}
>> +
>> +int rockchip_gem_get_ioctl(struct drm_device *dev, void *data,
>> +			   struct drm_file *file_priv)
>> +{
>> +	struct drm_rockchip_gem_info *args =3D data;
>> +	struct rockchip_gem_object *rk_obj;
>> +	struct drm_gem_object *obj;
>> +
>> +	mutex_lock(&dev->struct_mutex);
>> +
>> +	obj =3D drm_gem_object_lookup(dev, file_priv, args->handle);
>> +	if (!obj) {
>> +		DRM_ERROR("failed to lookup gem object.\n");
>> +		mutex_unlock(&dev->struct_mutex);
>> +		return -EINVAL;
>> +	}
>> +
>> +	rk_obj =3D to_rockchip_obj(obj);
>> +
>> +	args->flags =3D rk_obj->flags;
>> +	args->size =3D obj->size;
>> +
>> +	drm_gem_object_unreference(obj);
>> +	mutex_unlock(&dev->struct_mutex);
>> +
>> +	return 0;
>> +}
>> +
>> +int rockchip_gem_map_offset_ioctl(struct drm_device *drm, void *dat=
a,
>> +				  struct drm_file *file_priv)
>> +{
>> +	struct drm_rockchip_gem_map_off *args =3D data;
>> +
>> +	return rockchip_gem_dumb_map_offset(file_priv, drm, args->handle,
>> +					    &args->offset);
>> +}
>> +
>> +int rockchip_gem_create_ioctl(struct drm_device *dev, void *data,
>> +			      struct drm_file *file_priv)
>> +{
>> +	struct drm_rockchip_gem_create *args =3D data;
>> +	struct rockchip_gem_object *rk_obj;
>> +
>> +	rk_obj =3D rockchip_gem_create_with_handle(file_priv, dev, args->s=
ize,
>> +						 &args->handle);
>> +	return PTR_ERR_OR_ZERO(rk_obj);
>> +}
>> +
>> +/*
>> + * Allocate a sg_table for this GEM object.
>> + * Note: Both the table's contents, and the sg_table itself must be=
 freed by
>> + *       the caller.
>> + * Returns a pointer to the newly allocated sg_table, or an ERR_PTR=
() error.
>> + */
>> +struct sg_table *rockchip_gem_prime_get_sg_table(struct drm_gem_obj=
ect *obj)
>> +{
>> +	struct rockchip_gem_object *rk_obj =3D to_rockchip_obj(obj);
>> +	struct drm_device *drm =3D obj->dev;
>> +	struct sg_table *sgt =3D NULL;
>> +	int ret;
>> +
>> +	sgt =3D kzalloc(sizeof(*sgt), GFP_KERNEL);
>> +	if (!sgt)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	ret =3D dma_get_sgtable_attrs(drm->dev, sgt, rk_obj->kvaddr,
>> +				    rk_obj->dma_addr, obj->size,
>> +				    &rk_obj->dma_attrs);
>> +	if (ret) {
>> +		DRM_ERROR("failed to allocate sgt, %d\n", ret);
>> +		kfree(sgt);
>> +		return ERR_PTR(ret);
>> +	}
>> +
>> +	return sgt;
>> +}
>> +
>> +struct drm_gem_object *
>> +rockchip_gem_prime_import_sg_table(struct drm_device *dev, size_t s=
ize,
>> +				   struct sg_table *sgt)
>> +{
>> +	struct rockchip_gem_object *rk_obj;
>> +
>> +	if (sgt->nents !=3D 1)
>> +		return ERR_PTR(-EINVAL);
>> +
>> +	rk_obj =3D rockchip_gem_create_object(dev, size);
>> +	if (IS_ERR(rk_obj))
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	return &rk_obj->base;
>> +}
>> +
>> +void *rockchip_gem_prime_vmap(struct drm_gem_object *obj)
>> +{
>> +	struct rockchip_gem_object *rk_obj =3D to_rockchip_obj(obj);
>> +
>> +	return rk_obj->kvaddr;
>> +}
>> +
>> +void rockchip_gem_prime_vunmap(struct drm_gem_object *obj, void *va=
ddr)
>> +{
>> +	/* Nothing to do */
>> +}
>> +
>> +int rockchip_gem_prime_mmap(struct drm_gem_object *obj,
>> +			    struct vm_area_struct *vma)
>> +{
>> +	struct drm_device *dev =3D obj->dev;
>> +	int ret;
>> +
>> +	mutex_lock(&dev->struct_mutex);
>> +	ret =3D drm_gem_mmap_obj(obj, obj->size, vma);
>> +	mutex_unlock(&dev->struct_mutex);
>> +
>> +	return ret;
>> +}
>> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_gem.h b/drivers/g=
pu/drm/rockchip/rockchip_drm_gem.h
>> new file mode 100644
>> index 0000000..6277dbd
>> --- /dev/null
>> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_gem.h
>> @@ -0,0 +1,72 @@
>> +/*
>> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
>> + * Author:Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
>> + *
>> + * This software is licensed under the terms of the GNU General Pub=
lic
>> + * License version 2, as published by the Free Software Foundation,=
 and
>> + * may be copied, distributed, and modified under those terms.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#ifndef _ROCKCHIP_DRM_GEM_H
>> +#define _ROCKCHIP_DRM_GEM_H
>> +
>> +#define to_rockchip_obj(x) container_of(x, struct rockchip_gem_obje=
ct, base)
>> +
>> +struct rockchip_gem_object {
>> +	struct drm_gem_object base;
>> +	unsigned int flags;
>> +
>> +	void *kvaddr;
>> +	dma_addr_t dma_addr;
>> +	struct dma_attrs dma_attrs;
>> +};
>> +
>> +struct sg_table *rockchip_gem_prime_get_sg_table(struct drm_gem_obj=
ect *obj);
>> +struct drm_gem_object *
>> +rockchip_gem_prime_import_sg_table(struct drm_device *dev, size_t s=
ize,
>> +				   struct sg_table *sgt);
>> +void *rockchip_gem_prime_vmap(struct drm_gem_object *obj);
>> +void rockchip_gem_prime_vunmap(struct drm_gem_object *obj, void *va=
ddr);
>> +int rockchip_gem_prime_mmap(struct drm_gem_object *obj,
>> +			    struct vm_area_struct *vma);
>> +
>> +/* drm driver mmap file operations */
>> +int rockchip_drm_gem_mmap(struct file *filp, struct vm_area_struct =
*vma);
>> +
>> +/* mmap a gem object to userspace. */
>> +int rockchip_gem_mmap(struct drm_gem_object *obj, struct vm_area_st=
ruct *vma);
>> +
>> +struct rockchip_gem_object *
>> +	rockchip_gem_create_object(struct drm_device *drm, unsigned int si=
ze);
>> +
>> +void rockchip_gem_free_object(struct drm_gem_object *obj);
>> +
>> +int rockchip_gem_dumb_create(struct drm_file *file_priv,
>> +			     struct drm_device *dev,
>> +			     struct drm_mode_create_dumb *args);
>> +int rockchip_gem_dumb_map_offset(struct drm_file *file_priv,
>> +				 struct drm_device *dev, uint32_t handle,
>> +				 uint64_t *offset);
>> +int rockchip_gem_map_offset_ioctl(struct drm_device *drm, void *dat=
a,
>> +				  struct drm_file *file_priv);
>> +/*
>> + * request gem object creation and buffer allocation as the size
>> + * that it is calculated with framebuffer information such as width=
,
>> + * height and bpp.
>> + */
>> +int rockchip_gem_create_ioctl(struct drm_device *dev, void *data,
>> +			      struct drm_file *file_priv);
>> +
>> +/* get buffer offset to map to user space. */
>> +int rockchip_gem_map_offset_ioctl(struct drm_device *dev, void *dat=
a,
>> +				  struct drm_file *file_priv);
>> +
>> +/* get buffer information to memory region allocated by gem. */
>> +int rockchip_gem_get_ioctl(struct drm_device *dev, void *data,
>> +			   struct drm_file *file_priv);
>> +#endif /* _ROCKCHIP_DRM_GEM_H */
>> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/g=
pu/drm/rockchip/rockchip_drm_vop.c
>> new file mode 100644
>> index 0000000..d2ec4d5
>> --- /dev/null
>> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
>> @@ -0,0 +1,1372 @@
>> +/*
>> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
>> + * Author:Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
>> + *
>> + * This software is licensed under the terms of the GNU General Pub=
lic
>> + * License version 2, as published by the Free Software Foundation,=
 and
>> + * may be copied, distributed, and modified under those terms.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +#include <drm/drmP.h>
>> +#include <drm/drm_crtc.h>
>> +#include <drm/drm_crtc_helper.h>
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/clk.h>
>> +#include <linux/of.h>
>> +#include <linux/of_device.h>
>> +#include <linux/pm_runtime.h>
>> +#include <linux/component.h>
>> +
>> +#include <linux/reset.h>
>> +#include <linux/iommu.h>
>> +#include <linux/delay.h>
>> +#include <drm/rockchip_drm.h>
>> +
>> +#include <video/of_display_timing.h>
>> +#include <video/of_videomode.h>
>> +
>> +#include "rockchip_drm_drv.h"
>> +#include "rockchip_drm_fbdev.h"
>> +#include "rockchip_drm_gem.h"
>> +#include "rockchip_drm_fb.h"
>> +#include "rockchip_drm_vop.h"
>> +
>> +#define VOP_DEFAULT_FRAMERATE	60
>> +#define VOP_MAX_WIN_SUPPORT	5
>> +#define VOP_DEFAULT_CURSOR	1
>> +#define VOP_REG(off, _mask, s) \
>> +		{.offset =3D off, \
>> +		 .mask =3D _mask, \
>> +		 .shift =3D s,}
>> +
>> +#define __REG_SET(x, off, mask, shift, v) \
>> +		vop_mask_write(x, off, (mask) << shift, (v) << shift)
>> +
>> +#define REG_SET(x, base, reg, v) \
>> +		__REG_SET(x, base + reg.offset, reg.mask, reg.shift, v)
>> +
>> +#define VOP_WIN_SET(x, win, name, v) \
>> +		REG_SET(x, win->base, win->phy->name, v)
>> +#define VOP_CTRL_SET(x, name, v) \
>> +		REG_SET(x, 0, (x)->data->ctrl->name, v)
>> +
>> +#define VOP_WIN_GET_YRGBADDR(ctx, win) \
>> +		vop_readl(ctx, win->base + win->phy->yrgb_mst.offset)
>> +
>> +#define to_vop_ctx(x) container_of(x, struct vop_context, crtc)
>> +#define to_rockchip_plane(x) container_of(x, struct rockchip_plane,=
 base)
>> +
>> +struct rockchip_plane {
>> +	int id;
>> +	struct drm_plane base;
>> +	const struct vop_win *win;
>> +	struct vop_context *ctx;
>> +
>> +	uint32_t pending_yrgb_mst;
>> +	struct drm_framebuffer *front_fb;
>> +	struct drm_framebuffer *pending_fb;
>> +	bool enabled;
>> +};
>> +
>> +struct vop_context {
>> +	struct device *dev;
>> +	struct drm_device *drm_dev;
>> +	struct drm_crtc crtc;
>> +	struct drm_pending_vblank_event *event;
>> +	struct vop_driver *drv;
>> +	unsigned int dpms;
>> +	unsigned int win_mask;
>> +	wait_queue_head_t wait_vsync_queue;
>> +	atomic_t wait_vsync_event;
>> +
>> +	struct workqueue_struct *vsync_wq;
>> +	struct work_struct vsync_work;
>> +
>> +	/* mutex vsync_ work */
>> +	struct mutex vsync_mutex;
>> +	bool vsync_work_pending;
>> +
>> +	struct vop_driver_data *data;
>> +
>> +	uint32_t *regsbak;
>> +	void __iomem *regs;
>> +
>> +	/* physical map length of vop register */
>> +	uint32_t len;
>> +
>> +	/* one time only one process allowed to config the register */
>> +	spinlock_t reg_lock;
>> +	/* lock vop irq reg */
>> +	spinlock_t irq_lock;
>> +
>> +	unsigned int irq;
>> +
>> +	/* vop AHP clk */
>> +	struct clk *hclk;
>> +	/* vop dclk */
>> +	struct clk *dclk;
>> +	/* vop share memory frequency */
>> +	struct clk *aclk;
>> +	uint32_t pixclock;
>> +
>> +	int pipe;
>> +	bool clk_on;
>> +};
>> +
>> +enum vop_data_format {
>> +	VOP_FMT_ARGB8888 =3D 0,
>> +	VOP_FMT_RGB888,
>> +	VOP_FMT_RGB565,
>> +	VOP_FMT_YUV420SP =3D 4,
>> +	VOP_FMT_YUV422SP,
>> +	VOP_FMT_YUV444SP,
>> +};
>> +
>> +struct vop_reg_data {
>> +	uint32_t offset;
>> +	uint32_t value;
>> +};
>> +
>> +struct vop_reg {
>> +	uint32_t offset;
>> +	uint32_t shift;
>> +	uint32_t mask;
>> +};
>> +
>> +struct vop_ctrl {
>> +	struct vop_reg standby;
>> +	struct vop_reg gate_en;
>> +	struct vop_reg mmu_en;
>> +	struct vop_reg rgb_en;
>> +	struct vop_reg edp_en;
>> +	struct vop_reg hdmi_en;
>> +	struct vop_reg mipi_en;
>> +	struct vop_reg out_mode;
>> +	struct vop_reg dither_down;
>> +	struct vop_reg dither_up;
>> +	struct vop_reg pin_pol;
>> +
>> +	struct vop_reg htotal_pw;
>> +	struct vop_reg hact_st_end;
>> +	struct vop_reg vtotal_pw;
>> +	struct vop_reg vact_st_end;
>> +	struct vop_reg hpost_st_end;
>> +	struct vop_reg vpost_st_end;
>> +};
>> +
>> +struct vop_win_phy {
>> +	const uint32_t *data_formats;
>> +	uint32_t nformats;
>> +
>> +	struct vop_reg enable;
>> +	struct vop_reg format;
>> +	struct vop_reg act_info;
>> +	struct vop_reg dsp_info;
>> +	struct vop_reg dsp_st;
>> +	struct vop_reg yrgb_mst;
>> +	struct vop_reg uv_mst;
>> +	struct vop_reg yrgb_vir;
>> +	struct vop_reg uv_vir;
>> +
>> +	struct vop_reg dst_alpha_ctl;
>> +	struct vop_reg src_alpha_ctl;
>> +};
>> +
>> +struct vop_win {
>> +	uint32_t base;
>> +	const struct vop_win_phy *phy;
>> +};
>> +
>> +struct vop_driver_data {
>> +	const void *init_table;
>> +	int table_size;
>> +	const struct vop_ctrl *ctrl;
>> +	const struct vop_win *win[VOP_MAX_WIN_SUPPORT];
>> +};
>> +
>> +static const uint32_t formats_01[] =3D {
>> +	DRM_FORMAT_XRGB8888,
>> +	DRM_FORMAT_ARGB8888,
>> +	DRM_FORMAT_RGB888,
>> +	DRM_FORMAT_RGB565,
>> +	DRM_FORMAT_NV12,
>> +	DRM_FORMAT_NV16,
>> +	DRM_FORMAT_NV24,
>> +};
>> +
>> +static const uint32_t formats_234[] =3D {
>> +	DRM_FORMAT_XRGB8888,
>> +	DRM_FORMAT_ARGB8888,
>> +	DRM_FORMAT_RGB888,
>> +	DRM_FORMAT_RGB565,
>> +};
>> +
>> +static const struct vop_win_phy win01_data =3D {
>> +	.data_formats =3D formats_01,
>> +	.nformats =3D ARRAY_SIZE(formats_01),
>> +	.enable =3D VOP_REG(WIN0_CTRL0, 0x1, 0),
>> +	.format =3D VOP_REG(WIN0_CTRL0, 0x7, 1),
>> +	.act_info =3D VOP_REG(WIN0_ACT_INFO, 0x1fff1fff, 0),
>> +	.dsp_info =3D VOP_REG(WIN0_DSP_INFO, 0x1fff1fff, 0),
>> +	.dsp_st =3D VOP_REG(WIN0_DSP_ST, 0x1fff1fff, 0),
>> +	.yrgb_mst =3D VOP_REG(WIN0_YRGB_MST, 0xffffffff, 0),
>> +	.uv_mst =3D VOP_REG(WIN0_CBR_MST, 0xffffffff, 0),
>> +	.yrgb_vir =3D VOP_REG(WIN0_VIR, 0x3fff, 0),
>> +	.uv_vir =3D VOP_REG(WIN0_VIR, 0x3fff, 16),
>> +	.src_alpha_ctl =3D VOP_REG(WIN0_SRC_ALPHA_CTRL, 0xff, 0),
>> +	.dst_alpha_ctl =3D VOP_REG(WIN0_DST_ALPHA_CTRL, 0xff, 0),
>> +};
>> +
>> +static const struct vop_win_phy win23_data =3D {
>> +	.data_formats =3D formats_234,
>> +	.nformats =3D ARRAY_SIZE(formats_234),
>> +	.enable =3D VOP_REG(WIN2_CTRL0, 0x1, 0),
>> +	.format =3D VOP_REG(WIN2_CTRL0, 0x7, 1),
>> +	.dsp_info =3D VOP_REG(WIN2_DSP_INFO0, 0x0fff0fff, 0),
>> +	.dsp_st =3D VOP_REG(WIN2_DSP_ST0, 0x1fff1fff, 0),
>> +	.yrgb_mst =3D VOP_REG(WIN2_MST0, 0xffffffff, 0),
>> +	.yrgb_vir =3D VOP_REG(WIN2_VIR0_1, 0x1fff, 0),
>> +	.src_alpha_ctl =3D VOP_REG(WIN2_SRC_ALPHA_CTRL, 0xff, 0),
>> +	.dst_alpha_ctl =3D VOP_REG(WIN2_DST_ALPHA_CTRL, 0xff, 0),
>> +};
>> +
>> +static const struct vop_win_phy cursor_data =3D {
>> +	.data_formats =3D formats_234,
>> +	.nformats =3D ARRAY_SIZE(formats_234),
>> +	.enable =3D VOP_REG(HWC_CTRL0, 0x1, 0),
>> +	.format =3D VOP_REG(HWC_CTRL0, 0x7, 1),
>> +	.dsp_st =3D VOP_REG(HWC_DSP_ST, 0x1fff1fff, 0),
>> +	.yrgb_mst =3D VOP_REG(HWC_MST, 0xffffffff, 0),
>> +};
>> +
>> +static const struct vop_win win0 =3D {
>> +	.base =3D 0,
>> +	.phy =3D &win01_data,
>> +};
>> +
>> +static const struct vop_win win1 =3D {
>> +	.base =3D 0x40,
>> +	.phy =3D &win01_data,
>> +};
>> +
>> +static const struct vop_win win2 =3D {
>> +	.base =3D 0,
>> +	.phy =3D &win23_data,
>> +};
>> +
>> +static const struct vop_win win3 =3D {
>> +	.base =3D 0x50,
>> +	.phy =3D &win23_data,
>> +};
>> +
>> +static const struct vop_win win_cursor =3D {
>> +	.base =3D 0,
>> +	.phy =3D &cursor_data,
>> +};
>> +
>> +static const struct vop_ctrl ctrl_data =3D {
>> +	.standby =3D VOP_REG(SYS_CTRL, 0x1, 22),
>> +	.gate_en =3D VOP_REG(SYS_CTRL, 0x1, 23),
>> +	.mmu_en =3D VOP_REG(SYS_CTRL, 0x1, 20),
>> +	.rgb_en =3D VOP_REG(SYS_CTRL, 0x1, 12),
>> +	.hdmi_en =3D VOP_REG(SYS_CTRL, 0x1, 13),
>> +	.edp_en =3D VOP_REG(SYS_CTRL, 0x1, 14),
>> +	.mipi_en =3D VOP_REG(SYS_CTRL, 0x1, 15),
>> +	.dither_down =3D VOP_REG(DSP_CTRL1, 0xf, 1),
>> +	.dither_up =3D VOP_REG(DSP_CTRL1, 0x1, 6),
>> +	.out_mode =3D VOP_REG(DSP_CTRL0, 0xf, 0),
>> +	.pin_pol =3D VOP_REG(DSP_CTRL0, 0xf, 4),
>> +	.htotal_pw =3D VOP_REG(DSP_HTOTAL_HS_END, 0x1fff1fff, 0),
>> +	.hact_st_end =3D VOP_REG(DSP_HACT_ST_END, 0x1fff1fff, 0),
>> +	.vtotal_pw =3D VOP_REG(DSP_VTOTAL_VS_END, 0x1fff1fff, 0),
>> +	.vact_st_end =3D VOP_REG(DSP_VACT_ST_END, 0x1fff1fff, 0),
>> +	.hpost_st_end =3D VOP_REG(POST_DSP_HACT_INFO, 0x1fff1fff, 0),
>> +	.vpost_st_end =3D VOP_REG(POST_DSP_VACT_INFO, 0x1fff1fff, 0),
>> +};
>> +
>> +static const struct vop_reg_data vop_init_reg_table[] =3D {
>> +	{SYS_CTRL, 0x00801000},
>> +	{DSP_CTRL0, 0x00000000},
>> +	{WIN0_CTRL0, 0x00000080},
>> +	{WIN1_CTRL0, 0x00000080},
>> +};
>> +
>> +static const struct vop_driver_data rockchip_rk3288_vop =3D {
>> +	.init_table =3D vop_init_reg_table,
>> +	.table_size =3D ARRAY_SIZE(vop_init_reg_table),
>> +	.ctrl =3D &ctrl_data,
>> +	.win[0] =3D &win0,
>> +	.win[1] =3D &win1,
>> +	.win[2] =3D &win2,
>> +	.win[3] =3D &win3,
>> +	.win[4] =3D &win_cursor,
>> +};
>> +
>> +static const struct of_device_id vop_driver_dt_match[] =3D {
>> +	{ .compatible =3D "rockchip,rk3288-vop",
>> +	  .data =3D (void *)&rockchip_rk3288_vop },
>> +	{},
>> +};
>> +
>> +static inline void vop_writel(struct vop_context *ctx,
>> +			      uint32_t offset, uint32_t v)
>> +{
>> +	writel(v, ctx->regs + offset);
>> +	ctx->regsbak[offset >> 2] =3D v;
>> +}
>> +
>> +static inline uint32_t vop_readl(struct vop_context *ctx, uint32_t =
offset)
>> +{
>> +	return readl(ctx->regs + offset);
>> +}
>> +
>> +static inline void vop_cfg_done(struct vop_context *ctx)
>> +{
>> +	writel(0x01, ctx->regs + REG_CFG_DONE);
>> +}
>> +
>> +static inline void vop_mask_write(struct vop_context *ctx,
>> +				  uint32_t offset, uint32_t mask, uint32_t v)
>> +{
>> +	if (mask) {
>> +		uint32_t cached_val =3D ctx->regsbak[offset >> 2];
>> +
>> +		cached_val =3D (cached_val & ~mask) | v;
>> +		writel(cached_val, ctx->regs + offset);
>> +		ctx->regsbak[offset >> 2] =3D cached_val;
>> +	}
>> +}
>> +
>> +static inline struct vop_driver_data *vop_get_driver_data(struct de=
vice *dev)
>> +{
>> +	const struct of_device_id *of_id =3D
>> +			of_match_device(vop_driver_dt_match, dev);
>> +
>> +	return (struct vop_driver_data *)of_id->data;
>> +}
>> +
>> +static enum vop_data_format vop_convert_format(uint32_t format)
>> +{
>> +	switch (format) {
>> +	case DRM_FORMAT_XRGB8888:
>> +	case DRM_FORMAT_ARGB8888:
>> +		return VOP_FMT_ARGB8888;
>> +	case DRM_FORMAT_RGB888:
>> +		return VOP_FMT_RGB888;
>> +	case DRM_FORMAT_RGB565:
>> +		return VOP_FMT_RGB565;
>> +	case DRM_FORMAT_NV12:
>> +		return VOP_FMT_YUV420SP;
>> +	case DRM_FORMAT_NV16:
>> +		return VOP_FMT_YUV422SP;
>> +	case DRM_FORMAT_NV24:
>> +		return VOP_FMT_YUV444SP;
>> +	default:
>> +		DRM_ERROR("unsupport format[%08x]\n", format);
>> +		return -EINVAL;
>> +	}
>> +}
>> +
>> +static bool is_alpha_support(uint32_t format)
>> +{
>> +	switch (format) {
>> +	case DRM_FORMAT_ARGB8888:
>> +		return true;
>> +	default:
>> +		return false;
>> +	}
>> +}
>> +
>> +/* TODO(djkurtz): move generic 'setup slave rk_iommu' code somewher=
e common */
>> +int vop_iommu_init(struct vop_context *ctx)
>> +{
>> +	struct device *dev =3D ctx->dev;
>> +	struct device_node *np =3D dev->of_node;
>> +	struct platform_device *pd;
>> +	int count;
>> +	int ret;
>> +	struct of_phandle_args args;
>> +
>> +	/* Each VOP must have exactly one iommu node, with no args */
>> +	count =3D of_count_phandle_with_args(np, "iommus", "#iommu-cells")=
;
>> +	if (count !=3D 1) {
>> +		dev_err(dev, "of_count_phandle_with_args(%s) =3D> %d\n",
>> +			np->full_name, count);
>> +		return -EINVAL;
>> +	}
>> +
>> +	ret =3D of_parse_phandle_with_args(np, "iommus", "#iommu-cells", 0=
,
>> +					 &args);
>> +	if (ret) {
>> +		dev_err(dev, "of_parse_phandle_with_args(%s) =3D> %d\n",
>> +			np->full_name, ret);
>> +		return ret;
>> +	}
>> +	if (args.args_count !=3D 0) {
>> +		dev_err(dev, "incorrect number of iommu params found for %s (foun=
d %d, expected 0)\n",
>> +			args.np->full_name, args.args_count);
>> +		return -EINVAL;
>> +	}
>> +
>> +	pd =3D of_find_device_by_node(args.np);
>> +	of_node_put(args.np);
>> +	if (!pd) {
>> +		dev_err(dev, "iommu %s not found\n", args.np->full_name);
>> +		return -EPROBE_DEFER;
>> +	}
>> +
>> +	/* TODO(djkurtz): handle multiple slave iommus for a single master=
 */
>> +	dev->archdata.iommu =3D &pd->dev;
>> +
>> +	ret =3D rockchip_drm_dma_attach_device(ctx->drm_dev, dev);
>> +	if (ret) {
>> +		dev_err(dev, "failed to attach to drm dma mapping, %d\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static void vop_iommu_fini(struct vop_context *ctx)
>> +{
>> +	rockchip_drm_dma_detach_device(ctx->drm_dev, ctx->dev);
>> +}
>> +
>> +static int rockchip_plane_get_size(int start, unsigned length, unsi=
gned last)
>> +{
>> +	int end =3D start + length;
>> +	int size =3D 0;
>> +
>> +	if (start <=3D 0) {
>> +		if (end > 0)
>> +			size =3D min_t(unsigned, end, last);
>> +	} else if (start <=3D last) {
>> +		size =3D min_t(unsigned, last - start, length);
>> +	}
>> +
>> +	return size;
>> +}
>> +
>> +static int vop_clk_enable(struct vop_context *ctx)
>> +{
>> +	int ret;
>> +
>> +	if (!ctx->clk_on) {
>> +		ret =3D clk_prepare_enable(ctx->hclk);
>> +		if (ret < 0) {
>> +			dev_err(ctx->dev, "failed to enable hclk\n");
>> +			return ret;
>> +		}
>> +
>> +		ret =3D clk_prepare_enable(ctx->dclk);
>> +		if (ret < 0) {
>> +			dev_err(ctx->dev, "failed to enable dclk\n");
>> +			goto err_dclk;
>> +		}
>> +
>> +		ret =3D clk_prepare_enable(ctx->aclk);
>> +		if (ret < 0) {
>> +			dev_err(ctx->dev, "failed to enable aclk\n");
>> +			goto err_aclk;
>> +		}
>> +		ctx->clk_on =3D true;
>> +	}
>> +
>> +	return ret;
>> +err_aclk:
>> +	clk_disable_unprepare(ctx->aclk);
>> +err_dclk:
>> +	clk_disable_unprepare(ctx->hclk);
>> +	return ret;
>> +}
>> +
>> +static void vop_clk_disable(struct vop_context *ctx)
>> +{
>> +	if (ctx->clk_on) {
>> +		clk_disable_unprepare(ctx->dclk);
>> +		clk_disable_unprepare(ctx->hclk);
>> +		clk_disable_unprepare(ctx->aclk);
>> +		ctx->clk_on =3D false;
>> +	}
>> +}
>> +
>> +static void vop_power_on(struct vop_context *ctx)
>> +{
>> +	if (vop_clk_enable(ctx) < 0) {
>> +		dev_err(ctx->dev, "failed to enable clks\n");
>> +		return;
>> +	}
>> +
>> +	spin_lock(&ctx->reg_lock);
>> +
>> +	VOP_CTRL_SET(ctx, standby, 0);
>> +
>> +	spin_unlock(&ctx->reg_lock);
>> +}
>> +
>> +static void vop_power_off(struct vop_context *ctx)
>> +{
>> +	spin_lock(&ctx->reg_lock);
>> +
>> +	VOP_CTRL_SET(ctx, standby, 1);
>> +
>> +	spin_unlock(&ctx->reg_lock);
>> +
>> +	vop_clk_disable(ctx);
>> +}
>> +
>> +static int rockchip_update_plane(struct drm_plane *plane, struct dr=
m_crtc *crtc,
>> +				 struct drm_framebuffer *fb, int crtc_x,
>> +				 int crtc_y, unsigned int crtc_w,
>> +				 unsigned int crtc_h, uint32_t src_x,
>> +				 uint32_t src_y, uint32_t src_w, uint32_t src_h)
>> +{
>> +	struct rockchip_plane *rockchip_plane =3D to_rockchip_plane(plane)=
;
>> +	const struct vop_win *win =3D rockchip_plane->win;
>> +	struct vop_context *ctx =3D to_vop_ctx(crtc);
>> +	struct drm_gem_object *obj;
>> +	struct rockchip_gem_object *rk_obj;
>> +	unsigned long offset;
>> +	unsigned int actual_w;
>> +	unsigned int actual_h;
>> +	unsigned int dsp_stx;
>> +	unsigned int dsp_sty;
>> +	unsigned int y_vir_stride;
>> +	dma_addr_t yrgb_mst;
>> +	enum vop_data_format format;
>> +	uint32_t val;
>> +	bool is_alpha;
>> +
>> +	if (!win) {
>> +		DRM_ERROR("can't find win data for vop, failed\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	obj =3D rockchip_fb_get_gem_obj(fb, 0);
>> +	if (!obj) {
>> +		DRM_ERROR("fail to get rockchip gem object from framebuffer\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	rk_obj =3D to_rockchip_obj(obj);
>> +
>> +	yrgb_mst =3D rk_obj->dma_addr;
>> +	if (yrgb_mst <=3D 0)
>> +		return -ENOMEM;
>> +
>> +	actual_w =3D rockchip_plane_get_size(crtc_x,
>> +					   crtc_w, crtc->mode.hdisplay);
>> +	actual_h =3D rockchip_plane_get_size(crtc_y,
>> +					   crtc_h, crtc->mode.vdisplay);
>> +	if (crtc_x < 0) {
>> +		if (actual_w)
>> +			src_x -=3D crtc_x;
>> +		crtc_x =3D 0;
>> +	}
>> +
>> +	if (crtc_y < 0) {
>> +		if (actual_h)
>> +			src_y -=3D crtc_y;
>> +		crtc_y =3D 0;
>> +	}
>> +
>> +	dsp_stx =3D crtc_x + crtc->mode.htotal - crtc->mode.hsync_start;
>> +	dsp_sty =3D crtc_y + crtc->mode.vtotal - crtc->mode.vsync_start;
>> +
>> +	offset =3D src_x * (fb->bits_per_pixel >> 3);
>> +	offset +=3D src_y * fb->pitches[0];
>> +
>> +	y_vir_stride =3D fb->pitches[0] / (fb->bits_per_pixel >> 3);
>> +	is_alpha =3D is_alpha_support(fb->pixel_format);
>> +	format =3D vop_convert_format(fb->pixel_format);
>> +
>> +	spin_lock(&ctx->reg_lock);
>> +
>> +	VOP_WIN_SET(ctx, win, format, format);
>> +	VOP_WIN_SET(ctx, win, yrgb_vir, y_vir_stride);
>> +	yrgb_mst +=3D offset;
>> +	VOP_WIN_SET(ctx, win, yrgb_mst, yrgb_mst);
>> +	VOP_WIN_SET(ctx, win, act_info,
>> +		    ((actual_h - 1) << 16) | (actual_w - 1));
>> +	VOP_WIN_SET(ctx, win, dsp_info,
>> +		    ((actual_h - 1) << 16) | (actual_w - 1));
>> +	VOP_WIN_SET(ctx, win, dsp_st, (dsp_sty << 16) | dsp_stx);
>> +	if (is_alpha) {
>> +		VOP_WIN_SET(ctx, win, dst_alpha_ctl,
>> +			    DST_FACTOR_M0(ALPHA_SRC_INVERSE));
>> +		val =3D SRC_ALPHA_EN(1) | SRC_COLOR_M0(ALPHA_SRC_PRE_MUL) |
>> +			SRC_ALPHA_M0(ALPHA_STRAIGHT) |
>> +			SRC_BLEND_M0(ALPHA_PER_PIX) |
>> +			SRC_ALPHA_CAL_M0(ALPHA_NO_SATURATION) |
>> +			SRC_FACTOR_M0(ALPHA_ONE);
>> +		VOP_WIN_SET(ctx, win, src_alpha_ctl, val);
>> +	} else {
>> +		VOP_WIN_SET(ctx, win, src_alpha_ctl, SRC_ALPHA_EN(0));
>> +	}
>> +
>> +	VOP_WIN_SET(ctx, win, enable, 1);
>> +
>> +	spin_unlock(&ctx->reg_lock);
>> +
>> +	mutex_lock(&ctx->vsync_mutex);
>> +
>> +	/*
>> +	 * Because the buffer set to vop take effect at frame start time,
>> +	 * we need make sure old buffer is not in use before we release
>> +	 * it.
>> +	 * reference the framebuffer, and unference it when it swap out of=
 vop.
>> +	 */
>> +	if (fb !=3D rockchip_plane->front_fb) {
>> +		drm_framebuffer_reference(fb);
>> +		rockchip_plane->pending_fb =3D fb;
>> +		rockchip_plane->pending_yrgb_mst =3D yrgb_mst;
>> +		ctx->vsync_work_pending =3D true;
>> +	}
>> +	rockchip_plane->enabled =3D true;
>> +
>> +	mutex_unlock(&ctx->vsync_mutex);
>> +
>> +	spin_lock(&ctx->reg_lock);
>> +	vop_cfg_done(ctx);
>> +	spin_unlock(&ctx->reg_lock);
>> +
>> +	return 0;
>> +}
>> +
>> +static int rockchip_disable_plane(struct drm_plane *plane)
>> +{
>> +	struct rockchip_plane *rockchip_plane =3D to_rockchip_plane(plane)=
;
>> +	struct vop_context *ctx =3D rockchip_plane->ctx;
>> +	const struct vop_win *win =3D rockchip_plane->win;
>> +
>> +	spin_lock(&ctx->reg_lock);
>> +
>> +	VOP_WIN_SET(ctx, win, enable, 0);
>> +	vop_cfg_done(ctx);
>> +
>> +	spin_unlock(&ctx->reg_lock);
>> +
>> +	mutex_lock(&ctx->vsync_mutex);
>> +
>> +	/*
>> +	* clear the pending framebuffer and set vsync_work_pending true,
>> +	* so that the framebuffer will unref at the next vblank.
>> +	*/
>> +	if (rockchip_plane->pending_fb) {
>> +		drm_framebuffer_unreference(rockchip_plane->pending_fb);
>> +		rockchip_plane->pending_fb =3D NULL;
>> +	}
>> +
>> +	rockchip_plane->enabled =3D false;
>> +	ctx->vsync_work_pending =3D true;
>> +
>> +	mutex_unlock(&ctx->vsync_mutex);
>> +
>> +	return 0;
>> +}
>> +
>> +static void rockchip_plane_destroy(struct drm_plane *plane)
>> +{
>> +	struct rockchip_plane *rockchip_plane =3D to_rockchip_plane(plane)=
;
>> +	struct vop_context *ctx =3D rockchip_plane->ctx;
>> +
>> +	rockchip_disable_plane(plane);
>> +	drm_plane_cleanup(plane);
>> +	ctx->win_mask &=3D ~(1 << rockchip_plane->id);
>> +	kfree(rockchip_plane);
>> +}
>> +
>> +static const struct drm_plane_funcs rockchip_plane_funcs =3D {
>> +	.update_plane =3D rockchip_update_plane,
>> +	.disable_plane =3D rockchip_disable_plane,
>> +	.destroy =3D rockchip_plane_destroy,
>> +};
>> +
>> +struct drm_plane *rockchip_plane_init(struct vop_context *ctx,
>> +				      unsigned long possible_crtcs,
>> +				      enum drm_plane_type type)
>> +{
>> +	struct rockchip_plane *rockchip_plane;
>> +	struct vop_driver_data *vop_data =3D ctx->data;
>> +	const struct vop_win *win;
>> +	int i;
>> +	int err;
>> +
>> +	rockchip_plane =3D kzalloc(sizeof(*rockchip_plane), GFP_KERNEL);
>> +	if (!rockchip_plane)
>> +		return NULL;
>> +
>> +	for (i =3D 0; i < VOP_MAX_WIN_SUPPORT; i++) {
>> +		if (!(ctx->win_mask & (1 << i))) {
>> +			win =3D vop_data->win[i];
>> +			break;
>> +		}
>> +	}
>> +
>> +	if (VOP_MAX_WIN_SUPPORT =3D=3D i) {
>> +		DRM_ERROR("failed to find win\n");
>> +		kfree(rockchip_plane);
>> +		return NULL;
>> +	}
>> +
>> +	ctx->win_mask |=3D (1 << i);
>> +	rockchip_plane->id =3D i;
>> +	rockchip_plane->win =3D win;
>> +	rockchip_plane->ctx =3D ctx;
>> +
>> +	err =3D drm_universal_plane_init(ctx->drm_dev, &rockchip_plane->ba=
se,
>> +				       possible_crtcs, &rockchip_plane_funcs,
>> +				       win->phy->data_formats,
>> +				       win->phy->nformats, type);
>> +	if (err) {
>> +		DRM_ERROR("failed to initialize plane\n");
>> +		kfree(rockchip_plane);
>> +		return NULL;
>> +	}
>> +
>> +	return &rockchip_plane->base;
>> +}
>> +
>> +int rockchip_drm_crtc_enable_vblank(struct drm_device *dev, int pip=
e)
>> +{
>> +	struct vop_context *ctx =3D to_vop_ctx(rockchip_find_crtc(dev, pip=
e));
>> +	unsigned long flags;
>> +
>> +	if (ctx->dpms !=3D DRM_MODE_DPMS_ON)
>> +		return -EPERM;
>> +
>> +	spin_lock_irqsave(&ctx->irq_lock, flags);
>> +
>> +	vop_mask_write(ctx, INTR_CTRL0, LINE_FLAG_INTR_MASK,
>> +		       LINE_FLAG_INTR_EN(1));
>> +
>> +	spin_unlock_irqrestore(&ctx->irq_lock, flags);
>> +
>> +	return 0;
>> +}
>> +
>> +void rockchip_drm_crtc_disable_vblank(struct drm_device *dev, int p=
ipe)
>> +{
>> +	struct vop_context *ctx =3D to_vop_ctx(rockchip_find_crtc(dev, pip=
e));
>> +	unsigned long flags;
>> +
>> +	if (ctx->dpms !=3D DRM_MODE_DPMS_ON)
>> +		return;
>> +	spin_lock_irqsave(&ctx->irq_lock, flags);
>> +	vop_mask_write(ctx, INTR_CTRL0, LINE_FLAG_INTR_MASK,
>> +		       LINE_FLAG_INTR_EN(0));
>> +	spin_unlock_irqrestore(&ctx->irq_lock, flags);
>> +}
>> +
>> +static void rockchip_drm_crtc_dpms(struct drm_crtc *crtc, int mode)
>> +{
>> +	struct vop_context *ctx =3D to_vop_ctx(crtc);
>> +
>> +	DRM_DEBUG_KMS("crtc[%d] mode[%d]\n", crtc->base.id, mode);
>> +
>> +	if (ctx->dpms =3D=3D mode) {
>> +		DRM_DEBUG_KMS("desired dpms mode is same as previous one.\n");
>> +		return;
>> +	}
>> +	if (mode > DRM_MODE_DPMS_ON) {
>> +		/* wait for the completion of page flip. */
>> +		if (!wait_event_timeout(ctx->wait_vsync_queue,
>> +					!atomic_read(&ctx->wait_vsync_event),
>> +					HZ/20))
>> +			DRM_DEBUG_KMS("vblank wait timed out.\n");
>> +		drm_vblank_off(crtc->dev, ctx->pipe);
>> +	}
>> +
>> +	switch (mode) {
>> +	case DRM_MODE_DPMS_ON:
>> +		vop_power_on(ctx);
>> +		break;
>> +	case DRM_MODE_DPMS_STANDBY:
>> +	case DRM_MODE_DPMS_SUSPEND:
>> +	case DRM_MODE_DPMS_OFF:
>> +		vop_power_off(ctx);
>> +		break;
>> +	default:
>> +		DRM_DEBUG_KMS("unspecified mode %d\n", mode);
>> +		break;
>> +	}
>> +
>> +	ctx->dpms =3D mode;
>> +}
>> +
>> +static void rockchip_drm_crtc_prepare(struct drm_crtc *crtc)
>> +{
>> +	rockchip_drm_crtc_dpms(crtc, DRM_MODE_DPMS_ON);
>> +}
>> +
>> +static bool rockchip_drm_crtc_mode_fixup(struct drm_crtc *crtc,
>> +					 const struct drm_display_mode *mode,
>> +					 struct drm_display_mode *adjusted_mode)
>> +{
>> +	/* just do dummy now */
>> +
>> +	return true;
>> +}
>> +
>> +static int rockchip_drm_crtc_mode_set_base(struct drm_crtc *crtc, i=
nt x, int y,
>> +					   struct drm_framebuffer *old_fb);
>> +
>> +static int rockchip_drm_crtc_mode_set(struct drm_crtc *crtc,
>> +				      struct drm_display_mode *mode,
>> +				      struct drm_display_mode *adjusted_mode,
>> +				      int x, int y,
>> +				      struct drm_framebuffer *fb)
>> +{
>> +	struct vop_context *ctx =3D to_vop_ctx(crtc);
>> +	u16 hsync_len =3D adjusted_mode->hsync_end - adjusted_mode->hsync_=
start;
>> +	u16 left_margin =3D adjusted_mode->htotal - adjusted_mode->hsync_e=
nd;
>> +	u16 vsync_len =3D adjusted_mode->vsync_end - adjusted_mode->vsync_=
start;
>> +	u16 upper_margin =3D adjusted_mode->vtotal - adjusted_mode->vsync_=
end;
>> +	u16 hdisplay =3D adjusted_mode->hdisplay;
>> +	u16 vdisplay =3D adjusted_mode->vdisplay;
>> +	u16 htotal =3D adjusted_mode->htotal;
>> +	u16 vtotal =3D adjusted_mode->vtotal;
>> +	struct rockchip_display_mode *priv_mode =3D
>> +					(void *)adjusted_mode->private;
>> +	unsigned long flags;
>> +	int ret;
>> +	uint32_t val;
>> +
>> +	/* nothing to do if we haven't set the mode yet */
>> +	if (adjusted_mode->htotal =3D=3D 0 || adjusted_mode->vtotal =3D=3D=
 0)
>> +		return -EINVAL;
>> +
>> +	if (!priv_mode) {
>> +		DRM_ERROR("fail to found display output type[%d]\n",
>> +			  priv_mode->out_type);
>> +		return -EINVAL;
>> +	}
>> +
>> +	ret =3D rockchip_drm_crtc_mode_set_base(crtc, x, y, fb);
>> +	if (ret)
>> +		return ret;
>> +
>> +	switch (priv_mode->out_type) {
>> +	case ROCKCHIP_DISPLAY_TYPE_RGB:
>> +	case ROCKCHIP_DISPLAY_TYPE_LVDS:
>> +		VOP_CTRL_SET(ctx, rgb_en, 1);
>> +		VOP_CTRL_SET(ctx, out_mode, ROCKCHIP_OUTFACE_P888);
>> +		break;
>> +	case ROCKCHIP_DISPLAY_TYPE_EDP:
>> +		VOP_CTRL_SET(ctx, edp_en, 1);
>> +		VOP_CTRL_SET(ctx, out_mode, ROCKCHIP_OUTFACE_AAAA);
>> +		break;
>> +	case ROCKCHIP_DISPLAY_TYPE_HDMI:
>> +		VOP_CTRL_SET(ctx, out_mode, ROCKCHIP_OUTFACE_AAAA);
>> +		VOP_CTRL_SET(ctx, hdmi_en, 1);
>> +		break;
>> +	default:
>> +		DRM_ERROR("unsupport out type[%d]\n", priv_mode->out_type);
>> +		return -EINVAL;
>> +	};
>> +
>> +	val =3D 0x8;
>> +	val |=3D (adjusted_mode->flags & DRM_MODE_FLAG_NHSYNC) ? 1 : 0;
>> +	val |=3D (adjusted_mode->flags & DRM_MODE_FLAG_NVSYNC) ? (1 << 1) =
: 0;
>> +	VOP_CTRL_SET(ctx, pin_pol, val);
>> +
>> +	VOP_CTRL_SET(ctx, htotal_pw, (htotal << 16) | hsync_len);
>> +	val =3D (hsync_len + left_margin) << 16;
>> +	val |=3D hsync_len + left_margin + hdisplay;
>> +	VOP_CTRL_SET(ctx, hact_st_end, val);
>> +	VOP_CTRL_SET(ctx, hpost_st_end, val);
>> +
>> +	VOP_CTRL_SET(ctx, vtotal_pw, (vtotal << 16) | vsync_len);
>> +	val =3D (vsync_len + upper_margin) << 16;
>> +	val |=3D vsync_len + upper_margin + vdisplay;
>> +	VOP_CTRL_SET(ctx, vact_st_end, val);
>> +	VOP_CTRL_SET(ctx, vpost_st_end, val);
>> +
>> +	spin_lock_irqsave(&ctx->irq_lock, flags);
>> +
>> +	vop_mask_write(ctx, INTR_CTRL0, DSP_LINE_NUM_MASK,
>> +		       DSP_LINE_NUM(vsync_len + upper_margin + vdisplay));
>> +
>> +	spin_unlock_irqrestore(&ctx->irq_lock, flags);
>> +
>> +	clk_set_rate(ctx->dclk, adjusted_mode->clock * 1000);
>> +
>> +	return 0;
>> +}
>> +
>> +static int rockchip_drm_crtc_mode_set_base(struct drm_crtc *crtc, i=
nt x, int y,
>> +					   struct drm_framebuffer *old_fb)
>> +{
>> +	unsigned int crtc_w;
>> +	unsigned int crtc_h;
>> +	int ret;
>> +
>> +	crtc_w =3D crtc->primary->fb->width - crtc->x;
>> +	crtc_h =3D crtc->primary->fb->height - crtc->y;
>> +
>> +	ret =3D rockchip_update_plane(crtc->primary, crtc, crtc->primary->=
fb, 0,
>> +				    0, crtc_w, crtc_h, crtc->x, crtc->y, crtc_w,
>> +				    crtc_h);
>> +	if (ret < 0) {
>> +		DRM_ERROR("fail to update plane\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static void rockchip_drm_crtc_commit(struct drm_crtc *crtc)
>> +{
>> +	/* just do dummy now */
>> +}
>> +
>> +static const struct drm_crtc_helper_funcs rockchip_crtc_helper_func=
s =3D {
>> +	.dpms =3D rockchip_drm_crtc_dpms,
>> +	.prepare =3D rockchip_drm_crtc_prepare,
>> +	.mode_fixup =3D rockchip_drm_crtc_mode_fixup,
>> +	.mode_set =3D rockchip_drm_crtc_mode_set,
>> +	.mode_set_base =3D rockchip_drm_crtc_mode_set_base,
>> +	.commit =3D rockchip_drm_crtc_commit,
>> +};
>> +
>> +static int rockchip_drm_crtc_page_flip(struct drm_crtc *crtc,
>> +				       struct drm_framebuffer *fb,
>> +				       struct drm_pending_vblank_event *event,
>> +				       uint32_t page_flip_flags)
>> +{
>> +	struct drm_device *dev =3D crtc->dev;
>> +	struct vop_context *ctx =3D to_vop_ctx(crtc);
>> +	struct drm_framebuffer *old_fb =3D crtc->primary->fb;
>> +	unsigned int crtc_w;
>> +	unsigned int crtc_h;
>> +	int ret;
>> +
>> +	/* when the page flip is requested, crtc's dpms should be on */
>> +	if (ctx->dpms > DRM_MODE_DPMS_ON) {
>> +		DRM_DEBUG("failed page flip request at dpms[%d].\n", ctx->dpms);
>> +		return 0;
>> +	}
>> +
>> +	ret =3D drm_vblank_get(dev, ctx->pipe);
>> +	if (ret) {
>> +		DRM_DEBUG("failed to acquire vblank counter\n");
>> +		return ret;
>> +	}
>> +
>> +	spin_lock_irq(&dev->event_lock);
>> +	if (ctx->event) {
>> +		spin_unlock_irq(&dev->event_lock);
>> +		DRM_ERROR("already pending flip!\n");
>> +		return -EBUSY;
>> +	}
>> +	ctx->event =3D event;
>> +	atomic_set(&ctx->wait_vsync_event, 1);
>> +	spin_unlock_irq(&dev->event_lock);
>> +
>> +	crtc->primary->fb =3D fb;
>> +	crtc_w =3D crtc->primary->fb->width - crtc->x;
>> +	crtc_h =3D crtc->primary->fb->height - crtc->y;
>> +
>> +	ret =3D rockchip_update_plane(crtc->primary, crtc, fb, 0, 0, crtc_=
w,
>> +				    crtc_h, crtc->x, crtc->y, crtc_w, crtc_h);
>> +	if (ret) {
>> +		crtc->primary->fb =3D old_fb;
>> +
>> +		spin_lock_irq(&dev->event_lock);
>> +		drm_vblank_put(dev, ctx->pipe);
>> +		atomic_set(&ctx->wait_vsync_event, 0);
>> +		ctx->event =3D NULL;
>> +		spin_unlock_irq(&dev->event_lock);
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +void rockchip_drm_crtc_finish_pageflip(struct drm_device *dev, int =
pipe)
>> +{
>> +	struct rockchip_drm_private *dev_priv =3D dev->dev_private;
>> +	struct drm_crtc *drm_crtc =3D dev_priv->crtc[pipe];
>> +	struct vop_context *ctx;
>> +	unsigned long flags;
>> +
>> +	if (!drm_crtc)
>> +		return;
>> +
>> +	ctx =3D to_vop_ctx(drm_crtc);
>> +
>> +	spin_lock_irqsave(&dev->event_lock, flags);
>> +
>> +	if (ctx->event) {
>> +		drm_send_vblank_event(dev, -1, ctx->event);
>> +		drm_vblank_put(dev, pipe);
>> +		atomic_set(&ctx->wait_vsync_event, 0);
>> +		wake_up(&ctx->wait_vsync_queue);
>> +		ctx->event =3D NULL;
>> +	}
>> +
>> +	spin_unlock_irqrestore(&dev->event_lock, flags);
>> +}
>> +
>> +void rockchip_drm_crtc_cancel_pending_flip(struct drm_device *dev)
>> +{
>> +	int i;
>> +
>> +	for (i =3D 0; i < dev->num_crtcs; i++)
>> +		rockchip_drm_crtc_finish_pageflip(dev, i);
>> +}
>> +
>> +static void rockchip_drm_crtc_destroy(struct drm_crtc *crtc)
>> +{
>> +	struct vop_context *ctx =3D to_vop_ctx(crtc);
>> +	struct rockchip_drm_private *private =3D crtc->dev->dev_private;
>> +
>> +	private->crtc[ctx->pipe] =3D NULL;
>> +	drm_crtc_cleanup(crtc);
>> +}
>> +
>> +static const struct drm_crtc_funcs rockchip_crtc_funcs =3D {
>> +	.set_config =3D drm_crtc_helper_set_config,
>> +	.page_flip =3D rockchip_drm_crtc_page_flip,
>> +	.destroy =3D rockchip_drm_crtc_destroy,
>> +};
>> +
>> +static void rockchip_vsync_worker(struct work_struct *work)
>> +{
>> +	struct vop_context *ctx =3D container_of(work, struct vop_context,
>> +					       vsync_work);
>> +	struct drm_device *drm =3D ctx->drm_dev;
>> +	struct rockchip_drm_private *dev_priv =3D drm->dev_private;
>> +	struct drm_crtc *crtc =3D dev_priv->crtc[ctx->pipe];
>> +	struct rockchip_plane *rockchip_plane;
>> +	struct drm_plane *plane;
>> +	uint32_t yrgb_mst;
>> +
>> +	mutex_lock(&ctx->vsync_mutex);
>> +
>> +	ctx->vsync_work_pending =3D false;
>> +
>> +	list_for_each_entry(plane, &drm->mode_config.plane_list, head) {
>> +		rockchip_plane =3D to_rockchip_plane(plane);
>> +
>> +		if (rockchip_plane->ctx !=3D ctx)
>> +			continue;
>> +		if (rockchip_plane->enabled && !rockchip_plane->pending_fb)
>> +			continue;
>> +		if (!rockchip_plane->enabled && !rockchip_plane->front_fb)
>> +			continue;
>> +		/*
>> +		 * make sure the yrgb_mst take effect, so that
>> +		 * we can unreference the old framebuffer.
>> +		 */
>> +		yrgb_mst =3D VOP_WIN_GET_YRGBADDR(ctx, rockchip_plane->win);
>> +		if (rockchip_plane->pending_yrgb_mst !=3D yrgb_mst) {
>> +			/*
>> +			 * some plane no complete, unref at next vblank
>> +			 */
>> +			ctx->vsync_work_pending =3D true;
>> +			continue;
>> +		}
>> +
>> +		/*
>> +		 * drm_framebuffer_unreference maybe call iommu unmap,
>> +		 * and iommu not allow unmap buffer at irq context,
>> +		 * so we do drm_framebuffer_unreference at queue_work.
>> +		 */
>> +		if (rockchip_plane->front_fb)
>> +			drm_framebuffer_unreference(rockchip_plane->front_fb);
>> +
>> +		rockchip_plane->front_fb =3D rockchip_plane->pending_fb;
>> +		rockchip_plane->pending_fb =3D NULL;
>> +
>> +		/*
>> +		 * if primary plane flip complete, sending the event to
>> +		 * userspace
>> +		 */
>> +		if (&rockchip_plane->base =3D=3D crtc->primary)
>> +			rockchip_drm_crtc_finish_pageflip(ctx->drm_dev,
>> +							  ctx->pipe);
>> +	}
>> +
>> +	mutex_unlock(&ctx->vsync_mutex);
>> +}
>> +
>> +static irqreturn_t rockchip_vop_isr(int irq, void *data)
>> +{
>> +	struct vop_context *ctx =3D data;
>> +	uint32_t intr0_reg;
>> +	unsigned long flags;
>> +
>> +	intr0_reg =3D vop_readl(ctx, INTR_CTRL0);
>> +	if (intr0_reg & LINE_FLAG_INTR) {
>> +		spin_lock_irqsave(&ctx->irq_lock, flags);
>> +		vop_writel(ctx, INTR_CTRL0, intr0_reg | LINE_FLAG_INTR_CLR);
>> +		spin_unlock_irqrestore(&ctx->irq_lock, flags);
>> +	} else {
>> +		return IRQ_NONE;
>> +	}
>> +
>> +	drm_handle_vblank(ctx->drm_dev, ctx->pipe);
>> +	if (ctx->vsync_work_pending)
>> +		queue_work(ctx->vsync_wq, &ctx->vsync_work);
>> +
>> +	return IRQ_HANDLED;
>> +}
>> +
>> +static int vop_create_crtc(struct vop_context *ctx)
>> +{
>> +	struct device *dev =3D ctx->dev;
>> +	struct drm_device *drm_dev =3D ctx->drm_dev;
>> +	struct drm_plane *primary, *cursor;
>> +	unsigned long possible_crtcs;
>> +	struct drm_crtc *crtc;
>> +	int ret;
>> +	int nr;
>> +
>> +	ctx->win_mask =3D 0;
>> +	crtc =3D &ctx->crtc;
>> +
>> +	ret =3D rockchip_drm_add_crtc(drm_dev, crtc, dev->of_node);
>> +	if (ret < 0)
>> +		return ret;
>> +	ctx->pipe =3D ret;
>> +
>> +	possible_crtcs =3D (1 << ctx->pipe);
>> +
>> +	primary =3D rockchip_plane_init(ctx, possible_crtcs,
>> +				      DRM_PLANE_TYPE_PRIMARY);
>> +	if (!primary) {
>> +		DRM_ERROR("fail to init primary plane\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	for (nr =3D 1; nr < ROCKCHIP_MAX_PLANE; nr++) {
>> +		if (nr =3D=3D VOP_DEFAULT_CURSOR) {
>> +			cursor =3D rockchip_plane_init(ctx, possible_crtcs,
>> +						     DRM_PLANE_TYPE_CURSOR);
>> +			if (!cursor) {
>> +				DRM_ERROR("fail to init cursor plane\n");
>> +				return -EINVAL;
>> +			}
>> +		} else {
>> +			struct drm_plane *plane;
>> +
>> +			plane =3D rockchip_plane_init(ctx, possible_crtcs,
>> +						    DRM_PLANE_TYPE_OVERLAY);
>> +			if (!plane) {
>> +				DRM_ERROR("fail to init overlay plane\n");
>> +				return -EINVAL;
>> +			}
>> +		}
>> +	}
>> +
>> +	drm_crtc_init_with_planes(drm_dev, crtc, primary, cursor,
>> +				  &rockchip_crtc_funcs);
>> +	drm_crtc_helper_add(crtc, &rockchip_crtc_helper_funcs);
>> +
>> +	return 0;
>> +}
>> +
>> +static int rockchip_vop_initial(struct vop_context *ctx)
>> +{
>> +	struct vop_driver_data *vop_data =3D ctx->data;
>> +	const struct vop_reg_data *init_table =3D vop_data->init_table;
>> +	struct reset_control *rst;
>> +	int i, ret;
>> +
>> +	ctx->hclk =3D devm_clk_get(ctx->dev, "hclk_vop");
>> +	if (IS_ERR(ctx->hclk)) {
>> +		dev_err(ctx->dev, "failed to get hclk source\n");
>> +		return PTR_ERR(ctx->hclk);
>> +	}
>> +	ctx->aclk =3D devm_clk_get(ctx->dev, "aclk_vop");
>> +	if (IS_ERR(ctx->aclk)) {
>> +		dev_err(ctx->dev, "failed to get aclk source\n");
>> +		return PTR_ERR(ctx->aclk);
>> +	}
>> +	ctx->dclk =3D devm_clk_get(ctx->dev, "dclk_vop");
>> +	if (IS_ERR(ctx->dclk)) {
>> +		dev_err(ctx->dev, "failed to get dclk source\n");
>> +		return PTR_ERR(ctx->dclk);
>> +	}
>> +
>> +	ret =3D vop_clk_enable(ctx);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	/*
>> +	 * do hclk_reset, reset all vop registers.
>> +	 */
>> +	rst =3D devm_reset_control_get(ctx->dev, "ahb");
>> +	if (IS_ERR(rst)) {
>> +		dev_err(ctx->dev, "failed to get ahb reset\n");
>> +		return PTR_ERR(rst);
>> +	}
>> +	reset_control_assert(rst);
>> +	usleep_range(10, 20);
>> +	reset_control_deassert(rst);
>> +
>> +	memcpy(ctx->regsbak, ctx->regs, ctx->len);
>> +
>> +	for (i =3D 0; i < vop_data->table_size; i++)
>> +		vop_writel(ctx, init_table[i].offset, init_table[i].value);
>> +
>> +	for (i =3D 0; i < VOP_MAX_WIN_SUPPORT; i++)
>> +		VOP_WIN_SET(ctx, vop_data->win[i], enable, 0);
>> +
>> +	vop_cfg_done(ctx);
>> +
>> +	/*
>> +	 * do dclk_reset, let all win config take affect, and then we can =
enable
>> +	 * iommu safe.
>> +	 */
>> +	rst =3D devm_reset_control_get(ctx->dev, "dclk");
>> +	if (IS_ERR(rst)) {
>> +		dev_err(ctx->dev, "failed to get dclk reset\n");
>> +		return PTR_ERR(rst);
>> +	}
>> +	reset_control_assert(rst);
>> +	usleep_range(10, 20);
>> +	reset_control_deassert(rst);
>> +
>> +	ctx->dpms =3D DRM_MODE_DPMS_ON;
>> +
>> +	return 0;
>> +}
>> +
>> +static int vop_bind(struct device *dev, struct device *master, void=
 *data)
>> +{
>> +	struct platform_device *pdev =3D to_platform_device(dev);
>> +	struct vop_driver_data *vop_data =3D vop_get_driver_data(dev);
>> +	struct drm_device *drm_dev =3D data;
>> +	struct vop_context *ctx;
>> +	struct resource *res;
>> +	int ret;
>> +
>> +	if (!vop_data)
>> +		return -ENODEV;
>> +
>> +	ctx =3D devm_kzalloc(dev, sizeof(*ctx), GFP_KERNEL);
>> +	if (!ctx)
>> +		return -ENOMEM;
>> +
>> +	ctx->dev =3D dev;
>> +	ctx->data =3D vop_data;
>> +	ctx->drm_dev =3D drm_dev;
>> +	dev_set_drvdata(dev, ctx);
>> +
>> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	ctx->len =3D resource_size(res);
>> +	ctx->regs =3D devm_ioremap_resource(dev, res);
>> +	if (IS_ERR(ctx->regs))
>> +		return PTR_ERR(ctx->regs);
>> +
>> +	ctx->regsbak =3D devm_kzalloc(dev, ctx->len, GFP_KERNEL);
>> +	if (!ctx->regsbak)
>> +		return -ENOMEM;
>> +
>> +	ret =3D rockchip_vop_initial(ctx);
>> +	if (ret < 0) {
>> +		dev_err(&pdev->dev, "cannot initial vop dev - err %d\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	ctx->irq =3D platform_get_irq(pdev, 0);
>> +	if (ctx->irq < 0) {
>> +		dev_err(dev, "cannot find irq for vop\n");
>> +		return ctx->irq;
>> +	}
>> +
>> +	spin_lock_init(&ctx->reg_lock);
>> +	spin_lock_init(&ctx->irq_lock);
>> +
>> +	init_waitqueue_head(&ctx->wait_vsync_queue);
>> +	atomic_set(&ctx->wait_vsync_event, 0);
>> +
>> +	ret =3D vop_iommu_init(ctx);
>> +	if (ret) {
>> +		DRM_ERROR("Failed to setup iommu, %d\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	ctx->vsync_wq =3D create_singlethread_workqueue("vsync");
>> +	if (!ctx->vsync_wq) {
>> +		dev_err(dev, "failed to create workqueue\n");
>> +		return -EINVAL;
>> +	}
>> +	INIT_WORK(&ctx->vsync_work, rockchip_vsync_worker);
>> +
>> +	mutex_init(&ctx->vsync_mutex);
>> +	pm_runtime_enable(&pdev->dev);
>> +
>> +	ret =3D devm_request_irq(dev, ctx->irq, rockchip_vop_isr,
>> +			       IRQF_SHARED, dev_name(dev), ctx);
>> +	if (ret) {
>> +		dev_err(dev, "cannot requeset irq%d - err %d\n", ctx->irq, ret);
>> +		return ret;
>> +	}
>> +
>> +	return vop_create_crtc(ctx);
>> +}
>> +
>> +static void vop_unbind(struct device *dev, struct device *master,
>> +		       void *data)
>> +{
>> +	struct drm_device *drm_dev =3D data;
>> +	struct vop_context *ctx =3D dev_get_drvdata(dev);
>> +	struct drm_crtc *crtc =3D &ctx->crtc;
>> +
>> +	drm_crtc_cleanup(crtc);
>> +	pm_runtime_disable(dev);
>> +	rockchip_drm_remove_crtc(drm_dev, ctx->pipe);
>> +
>> +	vop_iommu_fini(ctx);
>> +}
>> +
>> +static const struct component_ops vop_component_ops =3D {
>> +	.bind =3D vop_bind,
>> +	.unbind =3D vop_unbind,
>> +};
>> +
>> +static int vop_probe(struct platform_device *pdev)
>> +{
>> +	struct device *dev =3D &pdev->dev;
>> +	struct vop_context *ctx;
>> +
>> +	if (!dev->of_node) {
>> +		dev_err(dev, "can't find vop devices\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	platform_set_drvdata(pdev, ctx);
>> +
>> +	return component_add(dev, &vop_component_ops);
>> +}
>> +
>> +static int vop_remove(struct platform_device *pdev)
>> +{
>> +	component_del(&pdev->dev, &vop_component_ops);
>> +
>> +	return 0;
>> +}
>> +
>> +struct platform_driver rockchip_vop_platform_driver =3D {
>> +	.probe =3D vop_probe,
>> +	.remove =3D vop_remove,
>> +	.driver =3D {
>> +		.name =3D "rockchip-vop",
>> +		.owner =3D THIS_MODULE,
>> +		.of_match_table =3D of_match_ptr(vop_driver_dt_match),
>> +	},
>> +};
>> +
>> +module_platform_driver(rockchip_vop_platform_driver);
>> +
>> +MODULE_AUTHOR("Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>");
>> +MODULE_DESCRIPTION("ROCKCHIP VOP Driver");
>> +MODULE_LICENSE("GPL v2");
>> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.h b/drivers/g=
pu/drm/rockchip/rockchip_drm_vop.h
>> new file mode 100644
>> index 0000000..2343760
>> --- /dev/null
>> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.h
>> @@ -0,0 +1,187 @@
>> +/*
>> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
>> + * Author:Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
>> + *
>> + * This software is licensed under the terms of the GNU General Pub=
lic
>> + * License version 2, as published by the Free Software Foundation,=
 and
>> + * may be copied, distributed, and modified under those terms.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#ifndef _ROCKCHIP_DRM_VOP_H
>> +#define _ROCKCHIP_DRM_VOP_H
>> +
>> +/* register definition */
>> +#define REG_CFG_DONE			0x0000
>> +#define VERSION_INFO			0x0004
>> +#define SYS_CTRL			0x0008
>> +#define SYS_CTRL1			0x000c
>> +#define DSP_CTRL0			0x0010
>> +#define DSP_CTRL1			0x0014
>> +#define DSP_BG				0x0018
>> +#define MCU_CTRL			0x001c
>> +#define INTR_CTRL0			0x0020
>> +#define INTR_CTRL1			0x0024
>> +#define WIN0_CTRL0			0x0030
>> +#define WIN0_CTRL1			0x0034
>> +#define WIN0_COLOR_KEY			0x0038
>> +#define WIN0_VIR			0x003c
>> +#define WIN0_YRGB_MST			0x0040
>> +#define WIN0_CBR_MST			0x0044
>> +#define WIN0_ACT_INFO			0x0048
>> +#define WIN0_DSP_INFO			0x004c
>> +#define WIN0_DSP_ST			0x0050
>> +#define WIN0_SCL_FACTOR_YRGB		0x0054
>> +#define WIN0_SCL_FACTOR_CBR		0x0058
>> +#define WIN0_SCL_OFFSET			0x005c
>> +#define WIN0_SRC_ALPHA_CTRL		0x0060
>> +#define WIN0_DST_ALPHA_CTRL		0x0064
>> +#define WIN0_FADING_CTRL		0x0068
>> +/* win1 register */
>> +#define WIN1_CTRL0			0x0070
>> +#define WIN1_CTRL1			0x0074
>> +#define WIN1_COLOR_KEY			0x0078
>> +#define WIN1_VIR			0x007c
>> +#define WIN1_YRGB_MST			0x0080
>> +#define WIN1_CBR_MST			0x0084
>> +#define WIN1_ACT_INFO			0x0088
>> +#define WIN1_DSP_INFO			0x008c
>> +#define WIN1_DSP_ST			0x0090
>> +#define WIN1_SCL_FACTOR_YRGB		0x0094
>> +#define WIN1_SCL_FACTOR_CBR		0x0098
>> +#define WIN1_SCL_OFFSET			0x009c
>> +#define WIN1_SRC_ALPHA_CTRL		0x00a0
>> +#define WIN1_DST_ALPHA_CTRL		0x00a4
>> +#define WIN1_FADING_CTRL		0x00a8
>> +/* win2 register */
>> +#define WIN2_CTRL0			0x00b0
>> +#define WIN2_CTRL1			0x00b4
>> +#define WIN2_VIR0_1			0x00b8
>> +#define WIN2_VIR2_3			0x00bc
>> +#define WIN2_MST0			0x00c0
>> +#define WIN2_DSP_INFO0			0x00c4
>> +#define WIN2_DSP_ST0			0x00c8
>> +#define WIN2_COLOR_KEY			0x00cc
>> +#define WIN2_MST1			0x00d0
>> +#define WIN2_DSP_INFO1			0x00d4
>> +#define WIN2_DSP_ST1			0x00d8
>> +#define WIN2_SRC_ALPHA_CTRL		0x00dc
>> +#define WIN2_MST2			0x00e0
>> +#define WIN2_DSP_INFO2			0x00e4
>> +#define WIN2_DSP_ST2			0x00e8
>> +#define WIN2_DST_ALPHA_CTRL		0x00ec
>> +#define WIN2_MST3			0x00f0
>> +#define WIN2_DSP_INFO3			0x00f4
>> +#define WIN2_DSP_ST3			0x00f8
>> +#define WIN2_FADING_CTRL		0x00fc
>> +/* win3 register */
>> +#define WIN3_CTRL0			0x0100
>> +#define WIN3_CTRL1			0x0104
>> +#define WIN3_VIR0_1			0x0108
>> +#define WIN3_VIR2_3			0x010c
>> +#define WIN3_MST0			0x0110
>> +#define WIN3_DSP_INFO0			0x0114
>> +#define WIN3_DSP_ST0			0x0118
>> +#define WIN3_COLOR_KEY			0x011c
>> +#define WIN3_MST1			0x0120
>> +#define WIN3_DSP_INFO1			0x0124
>> +#define WIN3_DSP_ST1			0x0128
>> +#define WIN3_SRC_ALPHA_CTRL		0x012c
>> +#define WIN3_MST2			0x0130
>> +#define WIN3_DSP_INFO2			0x0134
>> +#define WIN3_DSP_ST2			0x0138
>> +#define WIN3_DST_ALPHA_CTRL		0x013c
>> +#define WIN3_MST3			0x0140
>> +#define WIN3_DSP_INFO3			0x0144
>> +#define WIN3_DSP_ST3			0x0148
>> +#define WIN3_FADING_CTRL		0x014c
>> +/* hwc register */
>> +#define HWC_CTRL0			0x0150
>> +#define HWC_CTRL1			0x0154
>> +#define HWC_MST				0x0158
>> +#define HWC_DSP_ST			0x015c
>> +#define HWC_SRC_ALPHA_CTRL		0x0160
>> +#define HWC_DST_ALPHA_CTRL		0x0164
>> +#define HWC_FADING_CTRL			0x0168
>> +/* post process register */
>> +#define POST_DSP_HACT_INFO		0x0170
>> +#define POST_DSP_VACT_INFO		0x0174
>> +#define POST_SCL_FACTOR_YRGB		0x0178
>> +#define POST_SCL_CTRL			0x0180
>> +#define POST_DSP_VACT_INFO_F1		0x0184
>> +#define DSP_HTOTAL_HS_END		0x0188
>> +#define DSP_HACT_ST_END			0x018c
>> +#define DSP_VTOTAL_VS_END		0x0190
>> +#define DSP_VACT_ST_END			0x0194
>> +#define DSP_VS_ST_END_F1		0x0198
>> +#define DSP_VACT_ST_END_F1		0x019c
>> +/* register definition end */
>> +
>> +/* interrupt define */
>> +#define DSP_HOLD_VALID_INTR		(1 << 0)
>> +#define FS_INTR				(1 << 1)
>> +#define LINE_FLAG_INTR			(1 << 2)
>> +#define BUS_ERROR_INTR			(1 << 3)
>> +
>> +#define DSP_HOLD_VALID_INTR_EN(x)	((x) << 4)
>> +#define FS_INTR_EN(x)			((x) << 5)
>> +#define LINE_FLAG_INTR_EN(x)		((x) << 6)
>> +#define BUS_ERROR_INTR_EN(x)		((x) << 7)
>> +#define DSP_HOLD_VALID_INTR_MASK	(1 << 4)
>> +#define FS_INTR_EN_MASK			(1 << 5)
>> +#define LINE_FLAG_INTR_MASK		(1 << 6)
>> +#define BUS_ERROR_INTR_MASK		(1 << 7)
>> +
>> +#define DSP_HOLD_VALID_INTR_CLR		(1 << 8)
>> +#define FS_INTR_EN_CLR			(1 << 9)
>> +#define LINE_FLAG_INTR_CLR		(1 << 10)
>> +#define BUS_ERROR_INTR_CLR		(1 << 11)
>> +#define DSP_LINE_NUM(x)			(((x) & 0x1fff) << 12)
>> +#define DSP_LINE_NUM_MASK		(0x1fff << 12)
>> +
>> +/* src alpha ctrl define */
>> +#define SRC_FADING_VALUE(x)		(((x) & 0xff) << 24)
>> +#define SRC_GLOBAL_ALPHA(x)		(((x) & 0xff) << 16)
>> +#define SRC_FACTOR_M0(x)		(((x) & 0x7) << 6)
>> +#define SRC_ALPHA_CAL_M0(x)		(((x) & 0x1) << 5)
>> +#define SRC_BLEND_M0(x)			(((x) & 0x3) << 3)
>> +#define SRC_ALPHA_M0(x)			(((x) & 0x1) << 2)
>> +#define SRC_COLOR_M0(x)			(((x) & 0x1) << 1)
>> +#define SRC_ALPHA_EN(x)			(((x) & 0x1) << 0)
>> +/* dst alpha ctrl define */
>> +#define DST_FACTOR_M0(x)		(((x) & 0x7) << 6)
>> +
>> +enum alpha_mode {
>> +	ALPHA_STRAIGHT,
>> +	ALPHA_INVERSE,
>> +};
>> +
>> +enum global_blend_mode {
>> +	ALPHA_GLOBAL,
>> +	ALPHA_PER_PIX,
>> +	ALPHA_PER_PIX_GLOBAL,
>> +};
>> +
>> +enum alpha_cal_mode {
>> +	ALPHA_SATURATION,
>> +	ALPHA_NO_SATURATION,
>> +};
>> +
>> +enum color_mode {
>> +	ALPHA_SRC_PRE_MUL,
>> +	ALPHA_SRC_NO_PRE_MUL,
>> +};
>> +
>> +enum factor_mode {
>> +	ALPHA_ZERO,
>> +	ALPHA_ONE,
>> +	ALPHA_SRC,
>> +	ALPHA_SRC_INVERSE,
>> +	ALPHA_SRC_GLOBAL,
>> +};
>> +
>> +#endif /* _ROCKCHIP_DRM_VOP_H */
>> diff --git a/include/uapi/drm/rockchip_drm.h b/include/uapi/drm/rock=
chip_drm.h
>> new file mode 100644
>> index 0000000..3193360
>> --- /dev/null
>> +++ b/include/uapi/drm/rockchip_drm.h
>> @@ -0,0 +1,75 @@
>> +/*
>> + *
>> + * Copyright (c) Fuzhou Rockchip Electronics Co.Ltd
>> + * Authors:
>> + *       Mark Yao <yzq-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
>> + *
>> + * base on exynos_drm.h
>> + *
>> + * This program is free software; you can redistribute  it and/or m=
odify it
>> + * under  the terms of  the GNU General  Public License as publishe=
d by the
>> + * Free Software Foundation;  either version 2 of the  License, or =
(at your
>> + * option) any later version.
>> + */
>> +
>> +#ifndef _UAPI_ROCKCHIP_DRM_H
>> +#define _UAPI_ROCKCHIP_DRM_H
>> +
>> +#include <drm/drm.h>
>> +
>> +/**
>> + * User-desired buffer creation information structure.
>> + *
>> + * @size: user-desired memory allocation size.
>> + * @flags: user request for setting memory type or cache attributes=
=2E
>> + * @handle: returned a handle to created gem object.
>> + *     - this handle will be set by gem module of kernel side.
>> + */
>> +struct drm_rockchip_gem_create {
>> +	uint64_t size;
>> +	uint32_t flags;
>> +	uint32_t handle;
>> +};
>> +
>> +/**
>> + * A structure for getting buffer offset.
>> + *
>> + * @handle: a pointer to gem object created.
>> + * @pad: just padding to be 64-bit aligned.
>> + * @offset: relatived offset value of the memory region allocated.
>> + *     - this value should be set by user.
>> + */
>> +struct drm_rockchip_gem_map_off {
>> +	uint32_t handle;
>> +	uint32_t pad;
>> +	uint64_t offset;
>> +};
>> +
>> +/**
>> + * A structure to gem information.
>> + *
>> + * @handle: a handle to gem object created.
>> + * @flags: flag value including memory type and cache attribute and
>> + *      this value would be set by driver.
>> + * @size: size to memory region allocated by gem and this size woul=
d
>> + *      be set by driver.
>> + */
>> +struct drm_rockchip_gem_info {
>> +	uint32_t handle;
>> +	uint32_t flags;
>> +	uint64_t size;
>> +};
>> +
>> +#define DRM_ROCKCHIP_GEM_CREATE		0x00
>> +#define DRM_ROCKCHIP_GEM_GET		0x01
>> +#define DRM_ROCKCHIP_GEM_MAP_OFFSET	0x02
>> +
>> +#define DRM_IOCTL_ROCKCHIP_GEM_CREATE	DRM_IOWR(DRM_COMMAND_BASE + \
>> +		DRM_ROCKCHIP_GEM_CREATE, struct drm_rockchip_gem_create)
>> +
>> +#define DRM_IOCTL_ROCKCHIP_GEM_MAP_OFFSET	DRM_IOWR(DRM_COMMAND_BASE=
 + \
>> +		DRM_ROCKCHIP_GEM_MAP_OFFSET, struct drm_rockchip_gem_map_off)
>> +
>> +#define DRM_IOCTL_ROCKCHIP_GEM_GET	DRM_IOWR(DRM_COMMAND_BASE + \
>> +		DRM_ROCKCHIP_GEM_GET, struct drm_rockchip_gem_info)
>> +#endif /* _UAPI_ROCKCHIP_DRM_H */
>> --=20
>> 1.7.9.5
>>
>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
>> http://lists.freedesktop.org/mailman/listinfo/dri-devel


--
To unsubscribe from this list: send the line "unsubscribe devicetree" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
