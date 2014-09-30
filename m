From: Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [PATCH v9 1/3] drm: rockchip: Add basic drm driver
Date: Tue, 30 Sep 2014 15:31:30 +0200
Message-ID: <542AB0B2.6000207@samsung.com>
References: <1412081870-27535-1-git-send-email-mark.yao@rock-chips.com>
 <1412082181-27703-1-git-send-email-mark.yao@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-reply-to: <1412082181-27703-1-git-send-email-mark.yao@rock-chips.com>
Sender: linux-doc-owner@vger.kernel.org
To: Mark Yao <mark.yao@rock-chips.com>, heiko@sntech.de, Boris BREZILLON <boris.brezillon@free-electrons.com>, David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>, Daniel Vetter <daniel@ffwll.ch>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Randy Dunlap <rdunlap@infradead.org>, Grant Likely <grant.likely@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, John Stultz <john.stultz@linaro.org>, Rom Lemarchand <romlem@google.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org, linux-rockchip@lists.infradead.org, dianders@chromium.org, marcheu@chromium.org, dbehr@chromium.org, olof@lixom.net, djkurtz@chromium.org, xjq@rock-chips.com, kfx@rock-chips.com, cym@rock-chips.com, cf@rock-chips.com, zyw@rock-chips.com, xxm@rock-chips.com, huangtao@rock-chips.com, kever.yang@rock-chips.com, yxj@rock-chips.com, wxt@rock-chips.com, xw@rock-chips.com
List-Id: linux-api@vger.kernel.org

Hi Mark,

On 09/30/2014 03:03 PM, Mark Yao wrote:
> From: Mark yao <mark.yao@rock-chips.com>
> 
> This patch adds the basic structure of a DRM Driver for Rockchip Socs.
> 
> Signed-off-by: Mark Yao <mark.yao@rock-chips.com>
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> Acked-by: Daniel Vetter <daniel@ffwll.ch>
> Reviewed-by: Rob Clark <robdclark@gmail.com>
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
> Changes in v5:
> Adviced by Arnd Bergmann
> - doing DMA start with a 32-bit masks with dma_mask and dma_coherent_mark
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
> - fix some mistake, bugs, remove unused define, more better code style etc. 
> - use clk_prepare()/unprepare() at probe()/remove() and clk_enable()/disable()
>   at runtime instead of clk_prepare_enable().
> - provide a help function from vop for encoder to do mode config, instead of
>   using drm_diaplay_mode private method.
> - change vop mode_set timing to make it more safely. 
> 
> Changes in v7:
> - fix memory leakage problem
> 
> Changes in v8:
> - fix iommu crash when use dual crtc.
> - use frame start interrupt for vsync instead of line flag interrupt,
> because the win config take affect at frame start time, if we use ling flag
> interrupt, the address check often failed.
> Adviced by Daniel Kurtz
> - fix some bugs, mistake, remove unused function
> - keep clock and vop disabled when probe end
> - use drm_plane_helper_check_update to check update_plane if vaild
> 
> Changes in v9:
> - fix suspend and resume bug, make iommu attach and detach safely.
> 
>  drivers/gpu/drm/Kconfig                       |    2 +
>  drivers/gpu/drm/Makefile                      |    1 +
>  drivers/gpu/drm/rockchip/Kconfig              |   17 +
>  drivers/gpu/drm/rockchip/Makefile             |    8 +
>  drivers/gpu/drm/rockchip/rockchip_drm_drv.c   |  509 +++++++++
>  drivers/gpu/drm/rockchip/rockchip_drm_drv.h   |   65 ++
>  drivers/gpu/drm/rockchip/rockchip_drm_fb.c    |  200 ++++
>  drivers/gpu/drm/rockchip/rockchip_drm_fb.h    |   28 +
>  drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c |  209 ++++
>  drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h |   20 +
>  drivers/gpu/drm/rockchip/rockchip_drm_gem.c   |  294 +++++
>  drivers/gpu/drm/rockchip/rockchip_drm_gem.h   |   54 +
>  drivers/gpu/drm/rockchip/rockchip_drm_vop.c   | 1423 +++++++++++++++++++++++++
>  drivers/gpu/drm/rockchip/rockchip_drm_vop.h   |  196 ++++
>  14 files changed, 3026 insertions(+)
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
> index 0000000..87255f7
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
> +	  management to userspace. This driver does not provides
> +	  2D or 3D acceleration; acceleration is performed by other
> +	  IP found on the SoC.
> diff --git a/drivers/gpu/drm/rockchip/Makefile b/drivers/gpu/drm/rockchip/Makefile
> new file mode 100644
> index 0000000..b3a5193
> --- /dev/null
> +++ b/drivers/gpu/drm/rockchip/Makefile
> @@ -0,0 +1,8 @@
> +#
> +# Makefile for the drm device driver.  This driver provides support for the
> +# Direct Rendering Infrastructure (DRI) in XFree86 4.1.0 and higher.
> +
> +rockchipdrm-y := rockchip_drm_drv.o rockchip_drm_fb.o rockchip_drm_fbdev.o \
> +		rockchip_drm_gem.o rockchip_drm_vop.o
> +
> +obj-$(CONFIG_DRM_ROCKCHIP) += rockchipdrm.o
> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_drv.c b/drivers/gpu/drm/rockchip/rockchip_drm_drv.c
> new file mode 100644
> index 0000000..879b2e0
> --- /dev/null
> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_drv.c
> @@ -0,0 +1,509 @@
> +/*
> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
> + * Author:Mark Yao <mark.yao@rock-chips.com>
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
> + * Attach a (component) device to the shared drm dma mapping from master drm
> + * device.  This is used by the VOPs to map GEM buffers to a common DMA
> + * mapping.
> + */
> +int rockchip_drm_dma_attach_device(struct drm_device *drm_dev,
> +				   struct device *dev)
> +{
> +	struct dma_iommu_mapping *mapping = drm_dev->dev->archdata.mapping;
> +	int ret;
> +
> +	ret = dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
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
> +	mapping = arm_iommu_create_mapping(&platform_bus_type, 0x00000000,
> +					   SZ_2G);
> +	if (IS_ERR(mapping)) {
> +		ret = PTR_ERR(mapping);
> +		goto err_config_cleanup;
> +	}
> +
> +	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
> +	if (ret)
> +		goto err_release_mapping;
> +
> +	dma_set_max_seg_size(dev, DMA_BIT_MASK(32));
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
> +	return ret;
> +}
> +
> +static int rockchip_drm_unload(struct drm_device *drm_dev)
> +{
> +	struct device *dev = drm_dev->dev;
> +
> +	drm_kms_helper_poll_fini(drm_dev);
> +	component_unbind_all(dev, drm_dev);
> +	arm_iommu_detach_device(dev);
> +	arm_iommu_release_mapping(dev->archdata.mapping);
> +	drm_mode_config_cleanup(drm_dev);
> +	drm_dev->dev_private = NULL;
> +
> +	return 0;
> +}
> +
> +void rockchip_drm_lastclose(struct drm_device *dev)
> +{
> +	struct rockchip_drm_private *priv = dev->dev_private;
> +
> +	drm_fb_helper_restore_fbdev_mode_unlocked(&priv->fbdev_helper);
> +}
> +
> +static const struct file_operations rockchip_drm_driver_fops = {
> +	.owner = THIS_MODULE,
> +	.open = drm_open,
> +	.mmap = rockchip_gem_mmap,
> +	.poll = drm_poll,
> +	.read = drm_read,
> +	.unlocked_ioctl = drm_ioctl,
> +#ifdef CONFIG_COMPAT
> +	.compat_ioctl = drm_compat_ioctl,
> +#endif
> +	.release = drm_release,
> +};
> +
> +const struct vm_operations_struct rockchip_drm_vm_ops = {
> +	.open = drm_gem_vm_open,
> +	.close = drm_gem_vm_close,
> +};
> +
> +static struct drm_driver rockchip_drm_driver = {
> +	.driver_features	= DRIVER_MODESET | DRIVER_GEM | DRIVER_PRIME,
> +	.load			= rockchip_drm_load,
> +	.unload			= rockchip_drm_unload,
> +	.lastclose		= rockchip_drm_lastclose,
> +	.get_vblank_counter	= drm_vblank_count,
> +	.enable_vblank		= rockchip_drm_crtc_enable_vblank,
> +	.disable_vblank		= rockchip_drm_crtc_disable_vblank,
> +	.gem_vm_ops		= &rockchip_drm_vm_ops,
> +	.gem_free_object	= rockchip_gem_free_object,
> +	.dumb_create		= rockchip_gem_dumb_create,
> +	.dumb_map_offset	= rockchip_gem_dumb_map_offset,
> +	.dumb_destroy		= drm_gem_dumb_destroy,
> +	.prime_handle_to_fd	= drm_gem_prime_handle_to_fd,
> +	.prime_fd_to_handle	= drm_gem_prime_fd_to_handle,
> +	.gem_prime_import	= drm_gem_prime_import,
> +	.gem_prime_export	= drm_gem_prime_export,
> +	.gem_prime_get_sg_table	= rockchip_gem_prime_get_sg_table,
> +	.gem_prime_vmap		= rockchip_gem_prime_vmap,
> +	.gem_prime_vunmap	= rockchip_gem_prime_vunmap,
> +	.fops			= &rockchip_drm_driver_fops,
> +	.name	= DRIVER_NAME,
> +	.desc	= DRIVER_DESC,
> +	.date	= DRIVER_DATE,
> +	.major	= DRIVER_MAJOR,
> +	.minor	= DRIVER_MINOR,
> +};
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int rockchip_drm_suspend(struct drm_device *dev, pm_message_t state)
> +{
> +	struct drm_connector *connector;
> +
> +	drm_modeset_lock_all(dev);
> +	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
> +		int old_dpms = connector->dpms;
> +
> +		if (connector->funcs->dpms)
> +			connector->funcs->dpms(connector, DRM_MODE_DPMS_OFF);
> +
> +		/* Set the old mode back to the connector for resume */
> +		connector->dpms = old_dpms;
> +	}
> +	drm_modeset_unlock_all(dev);
> +
> +	return 0;
> +}
> +
> +static int rockchip_drm_resume(struct drm_device *dev)
> +{
> +	struct drm_connector *connector;
> +
> +	drm_modeset_lock_all(dev);
> +	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
> +		if (connector->funcs->dpms)
> +			connector->funcs->dpms(connector, connector->dpms);
> +	}
> +	drm_modeset_unlock_all(dev);
> +
> +	drm_helper_resume_force_mode(dev);
> +
> +	return 0;
> +}
> +
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

drm_dev can be NULL here, it can happen when system is suspended
before all components are bound. It can also contain invalid pointer
if after successfull drm initialization de-initialization happens for
some reason.

Some workaround is to check for null here and set drvdata to null on
master unbind. But I guess it should be protected somehow to avoid races
in accessing drvdata.


> +}
> +
> +static int rockchip_drm_sys_resume(struct device *dev)
> +{
> +	struct drm_device *drm_dev = dev_get_drvdata(dev);
> +
> +	if (!pm_runtime_suspended(dev))
> +		return 0;
> +
> +	return rockchip_drm_resume(drm_dev);

Ditto.

Regards
Andrzej


