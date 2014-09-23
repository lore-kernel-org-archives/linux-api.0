From: Mark yao <mark.yao@rock-chips.com>
Subject: Re: [PATCH v4 1/5] drm/rockchip: Add basic drm driver
Date: Tue, 23 Sep 2014 13:59:22 +0800
Message-ID: <54210C3A.50001@rock-chips.com>
References: <1411382820-1615-1-git-send-email-mark.yao@rock-chips.com>	<1411382934-1763-1-git-send-email-mark.yao@rock-chips.com> <20140922152448.5c5cd178@bbrezillon>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140922152448.5c5cd178@bbrezillon>
Sender: linux-kernel-owner@vger.kernel.org
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: heiko@sntech.de, David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Randy Dunlap <rdunlap@infradead.org>, Grant Likely <grant.likely@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, John Stultz <john.stultz@linaro.org>, Rom Lemarchand <romlem@google.com>, devicetree@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org, linux-rockchip@lists.infradead.org, dianders@chromium.org, marcheu@chromium.org, dbehr@chromium.org, olof@lixom.net, djkurtz@chromium.org, xjq@rock-chips.com, kfx@rock-chips.com, cym@rock-chips.com, cf@rock-chips.com, zyw@rock-chips.com, xxm@rock-chips.com, huang
List-Id: linux-api@vger.kernel.org

On 2014=E5=B9=B409=E6=9C=8822=E6=97=A5 21:24, Boris BREZILLON wrote:
> Hi Mark,
>
> You'll find some comments inline.
> Anyway, I wouldn't call it a review (your driver is using some concep=
ts
> I'm not used to, like IOMMUs) but rather a collection of nitpicks :-)=
=2E
>
> I haven't been through the whole driver yet, but I'll get back to it
> soon ;-).
>
> And remember this is a 2 way thing, I wait for your review too
> (here is the last version of my driver [1]) :-)
>
>
> On Mon, 22 Sep 2014 18:48:54 +0800
> Mark yao <mark.yao@rock-chips.com> wrote:
>
>> This patch adds the basic structure of a DRM Driver for Rockchip Soc=
s.
>>
>> Signed-off-by: Mark yao <mark.yao@rock-chips.com>
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
> Do you really need those specific CFLAGS (AFAIK, these path are
> already set, though you'll have to include <drm/xxx.h> instead of
> "xxx.h" if you're referencing drm headers, but you're already
> referencing the correct patch anyway) ?
Sure, I will do it.
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
>> + * Author:Mark Yao <mark.yao@rock-chips.com>
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
> [...]
>
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
>
> Not sure you need to set driver data to NULL.
>
>
oh, dev_set_drvdata is no used now, I will remove it.
>> +	return ret;
>> +}
>> +
> [...]
>
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
> You meant
>
> 	if (!pm_runtime_suspended(dev))
>
> right ?
>
> BTW, I see the same mistake in exynos driver [2]
yes, you are right.
>
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
> Not sure you should call of_node_put on a node pointer passed as an
> argument (unless you previously called of_node_get which is not the c=
ase
> in this function)...
right, I will remove it.
>
> Best Regards,
>
> Boris
>
> [1]http://thread.gmane.org/gmane.comp.video.dri.devel/114064
> [2]https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/t=
ree/drivers/gpu/drm/exynos/exynos_drm_drv.c?id=3Drefs/tags/next-2014092=
2#n373
