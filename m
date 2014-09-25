From: Mark yao <mark.yao@rock-chips.com>
Subject: Re: [PATCH v5 1/3] drm/rockchip: Add basic drm driver
Date: Thu, 25 Sep 2014 16:58:57 +0800
Message-ID: <5423D951.4030703@rock-chips.com>
References: <1411524672-14524-1-git-send-email-mark.yao@rock-chips.com>
 <1411524746-14635-1-git-send-email-mark.yao@rock-chips.com>
 <CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=Wf3gyJZC8bw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0892311294=="
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=Wf3gyJZC8bw@mail.gmail.com>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>, =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>, linux-doc@vger.kernel.org, kever.yang@rock-chips.com, dri-devel <dri-devel@lists.freedesktop.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xjq@rock-chips.com, zyw@rock-chips.com, linux-api@vger.kernel.org, jeff chen <cym@rock-chips.com>, linux-rockchip@lists.infradead.org, kfx@rock-chips.com, Grant Likely <grant.likely@linaro.org>, wxt@rock-chips.com, huangtao@rock-chips.com, devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, yxj@rock-chips.com, Eddie Cai <cf@rock-chips.com>, Rob Herring <robh+dt@kernel.org>, =?UTF-8?B?U3TDqXBoYW5lIE1hcmNoZXNpbg==?= <marcheu@chromium.org>, simon xue <xxm@rock-chips.com>, xw@rock-chips.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.or>
List-Id: linux-api@vger.kernel.org

This is a multi-part message in MIME format.
--===============0892311294==
Content-Type: multipart/alternative;
 boundary="------------020302040903060005080105"

This is a multi-part message in MIME format.
--------------020302040903060005080105
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014=E5=B9=B409=E6=9C=8825=E6=97=A5 00:20, Daniel Kurtz wrote:
> Hi Mark,
>
> Please review comments inline...
>
> On Wed, Sep 24, 2014 at 10:12 AM, Mark yao <mark.yao@rock-chips.com> wr=
ote:
>> This patch adds the basic structure of a DRM Driver for Rockchip Socs.
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
>> - init cursor plane with universal api, remove unnecessary cursor set,=
move
>>
>> Changes in v4:
>> Adviced by David Herrmann
>> - remove drm_platform_*() usage, use register drm device directly.
>> Adviced by Rob Clark
>> - remove special mmap ioctl, do userspace mmap with normal mmap() or m=
map offset
>>
>> Changes in v5:
>> Adviced by Arnd Bergmann
>> - doing DMA start with a 32-bit masks with dma_mask and dma_coherent_m=
ark
>> - fix some incorrect dependencies.
>> Adviced by Boris BREZILLON
>> - fix some mistake and bugs.
>> Adviced by Daniel Vetter
>> - drop all special ioctl and use generic kms ioctl instead.
>> Adviced by Rob Clark
>> - use unlocked api for drm_fb_helper_restore_fbdev_mode.
>> - remove unused rockchip_gem_prime_import_sg_table.
>>
>>   drivers/gpu/drm/Kconfig                       |    2 +
>>   drivers/gpu/drm/Makefile                      |    1 +
>>   drivers/gpu/drm/rockchip/Kconfig              |   17 +
>>   drivers/gpu/drm/rockchip/Makefile             |    8 +
>>   drivers/gpu/drm/rockchip/rockchip_drm_drv.c   |  509 +++++++++
>>   drivers/gpu/drm/rockchip/rockchip_drm_drv.h   |  120 +++
>>   drivers/gpu/drm/rockchip/rockchip_drm_fb.c    |  201 ++++
>>   drivers/gpu/drm/rockchip/rockchip_drm_fb.h    |   28 +
>>   drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c |  230 +++++
>>   drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h |   20 +
>>   drivers/gpu/drm/rockchip/rockchip_drm_gem.c   |  341 ++++++
>>   drivers/gpu/drm/rockchip/rockchip_drm_gem.h   |   55 +
>>   drivers/gpu/drm/rockchip/rockchip_drm_vop.c   | 1373 +++++++++++++++=
++++++++++
>>   drivers/gpu/drm/rockchip/rockchip_drm_vop.h   |  187 ++++
>>   14 files changed, 3092 insertions(+)
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
>>
>> diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
>> index b066bb3..7c4c3c6 100644
>> --- a/drivers/gpu/drm/Kconfig
>> +++ b/drivers/gpu/drm/Kconfig
>> @@ -171,6 +171,8 @@ config DRM_SAVAGE
>>
>>   source "drivers/gpu/drm/exynos/Kconfig"
>>
>> +source "drivers/gpu/drm/rockchip/Kconfig"
>> +
>>   source "drivers/gpu/drm/vmwgfx/Kconfig"
>>
>>   source "drivers/gpu/drm/gma500/Kconfig"
>> diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
>> index 4a55d59..d03387a 100644
>> --- a/drivers/gpu/drm/Makefile
>> +++ b/drivers/gpu/drm/Makefile
>> @@ -52,6 +52,7 @@ obj-$(CONFIG_DRM_VMWGFX)+=3D vmwgfx/
>>   obj-$(CONFIG_DRM_VIA)  +=3Dvia/
>>   obj-$(CONFIG_DRM_NOUVEAU) +=3Dnouveau/
>>   obj-$(CONFIG_DRM_EXYNOS) +=3Dexynos/
>> +obj-$(CONFIG_DRM_ROCKCHIP) +=3Drockchip/
>>   obj-$(CONFIG_DRM_GMA500) +=3D gma500/
>>   obj-$(CONFIG_DRM_UDL) +=3D udl/
>>   obj-$(CONFIG_DRM_AST) +=3D ast/
>> diff --git a/drivers/gpu/drm/rockchip/Kconfig b/drivers/gpu/drm/rockch=
ip/Kconfig
>> new file mode 100644
>> index 0000000..87255f7
>> --- /dev/null
>> +++ b/drivers/gpu/drm/rockchip/Kconfig
>> @@ -0,0 +1,17 @@
>> +config DRM_ROCKCHIP
>> +       tristate "DRM Support for Rockchip"
>> +       depends on DRM && ROCKCHIP_IOMMU && ARM_DMA_USE_IOMMU && IOMMU=
_API
>> +       select DRM_KMS_HELPER
>> +       select DRM_KMS_FB_HELPER
>> +       select DRM_PANEL
>> +       select FB_CFB_FILLRECT
>> +       select FB_CFB_COPYAREA
>> +       select FB_CFB_IMAGEBLIT
>> +       select VT_HW_CONSOLE_BINDING if FRAMEBUFFER_CONSOLE
>> +       select VIDEOMODE_HELPERS
>> +       help
>> +         Choose this option if you have a Rockchip soc chipset.
>> +         This driver provides kernel mode setting and buffer
>> +         management to userspace. This driver does not provides
>> +         2D or 3D acceleration; acceleration is performed by other
>> +         IP found on the SoC.
>> diff --git a/drivers/gpu/drm/rockchip/Makefile b/drivers/gpu/drm/rockc=
hip/Makefile
>> new file mode 100644
>> index 0000000..b3a5193
>> --- /dev/null
>> +++ b/drivers/gpu/drm/rockchip/Makefile
>> @@ -0,0 +1,8 @@
>> +#
>> +# Makefile for the drm device driver.  This driver provides support f=
or the
>> +# Direct Rendering Infrastructure (DRI) in XFree86 4.1.0 and higher.
>> +
>> +rockchipdrm-y :=3D rockchip_drm_drv.o rockchip_drm_fb.o rockchip_drm_=
fbdev.o \
>> +               rockchip_drm_gem.o rockchip_drm_vop.o
>> +
>> +obj-$(CONFIG_DRM_ROCKCHIP) +=3D rockchipdrm.o
>> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_drv.c b/drivers/gpu=
/drm/rockchip/rockchip_drm_drv.c
>> new file mode 100644
>> index 0000000..0ca4a6b
>> --- /dev/null
>> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_drv.c
>> @@ -0,0 +1,509 @@
>> +/*
>> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
>> + * Author:Mark Yao <mark.yao@rock-chips.com>
>> + *
>> + * based on exynos_drm_drv.c
>> + *
>> + * This software is licensed under the terms of the GNU General Publi=
c
>> + * License version 2, as published by the Free Software Foundation, a=
nd
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
>> +#include "rockchip_drm_drv.h"
>> +#include "rockchip_drm_fb.h"
>> +#include "rockchip_drm_fbdev.h"
>> +#include "rockchip_drm_gem.h"
>> +
>> +#define DRIVER_NAME    "rockchip"
>> +#define DRIVER_DESC    "RockChip Soc DRM"
>> +#define DRIVER_DATE    "20140818"
>> +#define DRIVER_MAJOR   1
>> +#define DRIVER_MINOR   0
>> +
>> +/*
>> + * Attach a (component) device to the shared drm dma mapping from mas=
ter drm
>> + * device.  This is used by the VOPs to map GEM buffers to a common D=
MA
>> + * mapping.
>> + */
>> +int rockchip_drm_dma_attach_device(struct drm_device *drm_dev,
>> +                                  struct device *dev)
>> +{
>> +       struct dma_iommu_mapping *mapping =3D drm_dev->dev->archdata.m=
apping;
>> +       int ret;
>> +
>> +       ret =3D dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
>> +       if (ret)
>> +               return ret;
>> +
>> +       dma_set_max_seg_size(dev, 0xffffffffu);
>> +
>> +       return arm_iommu_attach_device(dev, mapping);
>> +}
>> +
>> +void rockchip_drm_dma_detach_device(struct drm_device *drm_dev,
>> +                                   struct device *dev)
>> +{
>> +       arm_iommu_detach_device(drm_dev->dev);
>> +}
>> +
>> +static int rockchip_drm_load(struct drm_device *drm_dev, unsigned lon=
g flags)
>> +{
>> +       struct rockchip_drm_private *private;
>> +       struct dma_iommu_mapping *mapping;
>> +       struct device *dev =3D drm_dev->dev;
>> +       int ret;
>> +
>> +       private =3D devm_kzalloc(drm_dev->dev, sizeof(*private), GFP_K=
ERNEL);
>> +       if (!private)
>> +               return -ENOMEM;
>> +
>> +       drm_dev->dev_private =3D private;
>> +
>> +       drm_mode_config_init(drm_dev);
>> +
>> +       rockchip_drm_mode_config_init(drm_dev);
>> +
>> +       dev->dma_parms =3D devm_kzalloc(dev, sizeof(*dev->dma_parms),
>> +                                     GFP_KERNEL);
>> +       if (!dev->dma_parms) {
>> +               ret =3D -ENOMEM;
>> +               goto err_config_cleanup;
>> +       }
>> +
>> +       /* TODO(djkurtz): fetch the mapping start/size from somewhere =
*/
>> +       mapping =3D arm_iommu_create_mapping(&platform_bus_type, 0x100=
00000,
>> +                                          SZ_1G);
>> +       if (IS_ERR(mapping)) {
>> +               ret =3D PTR_ERR(mapping);
>> +               goto err_config_cleanup;
>> +       }
>> +
>> +       ret =3D dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
>> +       if (ret)
>> +               goto err_config_cleanup;
> goto err_release_mapping;
oh, I make a mistake... Sure, I will fix it.
>
>> +
>> +       dma_set_max_seg_size(dev, 0xffffffffu);
>> +
>> +       ret =3D arm_iommu_attach_device(dev, mapping);
>> +       if (ret)
>> +               goto err_release_mapping;
>> +
>> +       /* Try to bind all sub drivers. */
>> +       ret =3D component_bind_all(dev, drm_dev);
>> +       if (ret)
>> +               goto err_detach_device;
>> +
>> +       /* init kms poll for handling hpd */
>> +       drm_kms_helper_poll_init(drm_dev);
>> +
>> +       /*
>> +        * enable drm irq mode.
>> +        * - with irq_enabled =3D true, we can use the vblank feature.
>> +        */
>> +       drm_dev->irq_enabled =3D true;
>> +
>> +       /*
>> +        * with vblank_disable_allowed =3D true, vblank interrupt will=
 be disabled
>> +        * by drm timer once a current process gives up ownership of
>> +        * vblank event.(after drm_vblank_put function is called)
>> +        */
>> +       drm_dev->vblank_disable_allowed =3D true;
>> +
>> +       ret =3D drm_vblank_init(drm_dev, ROCKCHIP_MAX_CRTC);
>> +       if (ret)
>> +               goto err_kms_helper_poll_fini;
>> +
>> +       rockchip_drm_fbdev_init(drm_dev);
>> +
>> +       /* force connectors detection */
>> +       drm_helper_hpd_irq_event(drm_dev);
>> +
>> +       return 0;
>> +
>> +err_kms_helper_poll_fini:
>> +       drm_kms_helper_poll_fini(drm_dev);
>> +       component_unbind_all(dev, drm_dev);
>> +err_detach_device:
>> +       arm_iommu_detach_device(dev);
>> +err_release_mapping:
>> +       arm_iommu_release_mapping(dev->archdata.mapping);
>> +err_config_cleanup:
>> +       drm_mode_config_cleanup(drm_dev);
>> +       drm_dev->dev_private =3D NULL;
>> +       return ret;
>> +}
>> +
>> +static int rockchip_drm_unload(struct drm_device *drm_dev)
>> +{
>> +       struct device *dev =3D drm_dev->dev;
>> +
>> +       drm_kms_helper_poll_fini(drm_dev);
>> +       component_unbind_all(dev, drm_dev);
>> +       arm_iommu_detach_device(dev);
>> +       arm_iommu_release_mapping(dev->archdata.mapping);
>> +       drm_mode_config_cleanup(drm_dev);
>> +       drm_dev->dev_private =3D NULL;
>> +
>> +       return 0;
>> +}
>> +
>> +static int rockchip_drm_suspend(struct drm_device *dev, pm_message_t =
state)
>> +{
>> +       struct drm_connector *connector;
>> +
>> +       drm_modeset_lock_all(dev);
>> +       list_for_each_entry(connector, &dev->mode_config.connector_lis=
t, head) {
>> +               int old_dpms =3D connector->dpms;
>> +
>> +               if (connector->funcs->dpms)
>> +                       connector->funcs->dpms(connector, DRM_MODE_DPM=
S_OFF);
>> +
>> +               /* Set the old mode back to the connector for resume *=
/
>> +               connector->dpms =3D old_dpms;
>> +       }
>> +       drm_modeset_unlock_all(dev);
>> +
>> +       return 0;
>> +}
>> +
>> +static int rockchip_drm_resume(struct drm_device *dev)
>> +{
>> +       struct drm_connector *connector;
>> +
>> +       drm_modeset_lock_all(dev);
>> +       list_for_each_entry(connector, &dev->mode_config.connector_lis=
t, head) {
>> +               if (connector->funcs->dpms)
>> +                       connector->funcs->dpms(connector, connector->d=
pms);
>> +       }
>> +       drm_modeset_unlock_all(dev);
>> +
>> +       drm_helper_resume_force_mode(dev);
>> +
>> +       return 0;
>> +}
>> +
>> +void rockchip_drm_lastclose(struct drm_device *dev)
>> +{
>> +       struct rockchip_drm_private *priv =3D dev->dev_private;
>> +
>> +       if (priv->fb_helper)
>> +               drm_fb_helper_restore_fbdev_mode_unlocked(priv->fb_hel=
per);
>> +}
>> +
>> +static const struct file_operations rockchip_drm_driver_fops =3D {
>> +       .owner =3D THIS_MODULE,
>> +       .open =3D drm_open,
>> +       .mmap =3D rockchip_drm_gem_mmap,
>> +       .poll =3D drm_poll,
>> +       .read =3D drm_read,
>> +       .unlocked_ioctl =3D drm_ioctl,
>> +#ifdef CONFIG_COMPAT
>> +       .compat_ioctl =3D drm_compat_ioctl,
>> +#endif
>> +       .release =3D drm_release,
>> +};
>> +
>> +const struct vm_operations_struct rockchip_drm_vm_ops =3D {
>> +       .open =3D drm_gem_vm_open,
>> +       .close =3D drm_gem_vm_close,
>> +};
>> +
>> +static struct drm_driver rockchip_drm_driver =3D {
>> +       .driver_features        =3D DRIVER_MODESET | DRIVER_GEM | DRIV=
ER_PRIME,
>> +       .load                   =3D rockchip_drm_load,
>> +       .unload                 =3D rockchip_drm_unload,
>> +       .lastclose              =3D rockchip_drm_lastclose,
>> +       .suspend                =3D rockchip_drm_suspend,
>> +       .resume                 =3D rockchip_drm_resume,
> Looking at drm_sysfs.c, the .suspend/.resume callbacks are only
> invoked if the driver does not set DRIVER_MODESET in .driver_features.
> Since this driver does have DRIVER_MODESET, let's just drop these two i=
tems.
> The platform_driver provides its own suspend/resume callbacks, instead.
right, driver_features with DRIVER_MODESET, the suspend/resume do not be=20
called.
I will remove it to platform_driver.
>> +       .get_vblank_counter     =3D drm_vblank_count,
>> +       .enable_vblank          =3D rockchip_drm_crtc_enable_vblank,
>> +       .disable_vblank         =3D rockchip_drm_crtc_disable_vblank,
>> +       .gem_vm_ops             =3D &rockchip_drm_vm_ops,
>> +       .gem_free_object        =3D rockchip_gem_free_object,
>> +       .dumb_create            =3D rockchip_gem_dumb_create,
>> +       .dumb_map_offset        =3D rockchip_gem_dumb_map_offset,
>> +       .dumb_destroy           =3D drm_gem_dumb_destroy,
>> +       .prime_handle_to_fd     =3D drm_gem_prime_handle_to_fd,
>> +       .prime_fd_to_handle     =3D drm_gem_prime_fd_to_handle,
>> +       .gem_prime_import       =3D drm_gem_prime_import,
>> +       .gem_prime_export       =3D drm_gem_prime_export,
>> +       .gem_prime_get_sg_table =3D rockchip_gem_prime_get_sg_table,
>> +       .gem_prime_vmap         =3D rockchip_gem_prime_vmap,
>> +       .gem_prime_vunmap       =3D rockchip_gem_prime_vunmap,
>> +       .gem_prime_mmap         =3D rockchip_gem_prime_mmap,
>> +       .ioctls                 =3D rockchip_ioctls,
>> +       .num_ioctls             =3D ARRAY_SIZE(rockchip_ioctls),
>> +       .fops                   =3D &rockchip_drm_driver_fops,
>> +       .name   =3D DRIVER_NAME,
>> +       .desc   =3D DRIVER_DESC,
>> +       .date   =3D DRIVER_DATE,
>> +       .major  =3D DRIVER_MAJOR,
>> +       .minor  =3D DRIVER_MINOR,
>> +};
>> +
>> +#ifdef CONFIG_PM_SLEEP
>> +static int rockchip_drm_sys_suspend(struct device *dev)
>> +{
>> +       struct drm_device *drm_dev =3D dev_get_drvdata(dev);
>> +       pm_message_t message;
>> +
>> +       if (pm_runtime_suspended(dev))
>> +               return 0;
>> +
>> +       message.event =3D PM_EVENT_SUSPEND;
>> +
>> +       return rockchip_drm_suspend(drm_dev, message);
>> +}
>> +
>> +static int rockchip_drm_sys_resume(struct device *dev)
>> +{
>> +       struct drm_device *drm_dev =3D dev_get_drvdata(dev);
>> +
>> +       if (pm_runtime_suspended(dev))
>> +               return 0;
>> +
>> +       return rockchip_drm_resume(drm_dev);
>> +}
>> +#endif
>> +
>> +static const struct dev_pm_ops rockchip_drm_pm_ops =3D {
>> +       SET_SYSTEM_SLEEP_PM_OPS(rockchip_drm_sys_suspend,
>> +                               rockchip_drm_sys_resume)
>> +};
> Looks like this is not actually hooked up.
> Perhaps you meant to add this to rockchip_drm_platform_driver, see belo=
w...
>
>> +
>> +int rockchip_drm_add_crtc(struct drm_device *drm, struct drm_crtc *cr=
tc,
>> +                         struct device_node *np)
>> +{
>> +       struct rockchip_drm_private *priv =3D drm->dev_private;
>> +       struct device_node *port;
>> +       int pipe;
>> +
>> +       if (priv->num_pipe >=3D ROCKCHIP_MAX_CRTC)
>> +               return -EINVAL;
>> +
>> +       port =3D of_get_child_by_name(np, "port");
>> +       if (!port) {
>> +               dev_err(drm->dev, "no port node found in %s\n",
>> +                       np->full_name);
>> +               return -ENXIO;
>> +       }
>> +       pipe =3D priv->num_pipe++;
>> +       crtc->port =3D port;
>> +
>> +       priv->crtc[pipe] =3D crtc;
>> +
>> +       return pipe;
>> +}
>> +
>> +void rockchip_drm_remove_crtc(struct drm_device *drm, int pipe)
>> +{
>> +       struct rockchip_drm_private *priv =3D drm->dev_private;
>> +
>> +       priv->num_pipe--;
>> +       of_node_put(priv->crtc[pipe]->port);
>> +       priv->crtc[pipe] =3D NULL;
>> +}
>> +
>> +struct drm_crtc *rockchip_find_crtc(struct drm_device *drm, int pipe)
>> +{
>> +       struct rockchip_drm_private *priv =3D drm->dev_private;
>> +
>> +       if (pipe < ROCKCHIP_MAX_CRTC && priv->crtc[pipe])
>> +               return priv->crtc[pipe];
>> +
>> +       return NULL;
>> +}
>> +
>> +/*
>> + * @node: device tree node containing encoder input ports
>> + * @encoder: drm_encoder
>> + */
>> +int rockchip_drm_encoder_get_mux_id(struct device_node *node,
>> +                                   struct drm_encoder *encoder)
>> +{
>> +       struct device_node *ep =3D NULL;
>> +       struct drm_crtc *crtc =3D encoder->crtc;
>> +       struct of_endpoint endpoint;
>> +       struct device_node *port;
>> +       int ret;
>> +
>> +       if (!node || !crtc)
>> +               return -EINVAL;
>> +
>> +       do {
>> +               ep =3D of_graph_get_next_endpoint(node, ep);
>> +               if (!ep)
>> +                       break;
>> +
>> +               port =3D of_graph_get_remote_port(ep);
>> +               of_node_put(port);
>> +               if (port =3D=3D crtc->port) {
>> +                       ret =3D of_graph_parse_endpoint(ep, &endpoint)=
;
>> +                       return ret ? ret : endpoint.id;
> nit:
>
>     return ret ?: endpoint.id;
OK, I will do it.
>
>> +               }
>> +       } while (ep);
>> +
>> +       return -EINVAL;
>> +}
>> +
>> +static int compare_of(struct device *dev, void *data)
>> +{
>> +       struct device_node *np =3D data;
>> +
>> +       return dev->of_node =3D=3D np;
>> +}
>> +
>> +static void rockchip_add_endpoints(struct device *dev,
>> +                                  struct component_match **match,
>> +                                  struct device_node *port)
>> +{
>> +       struct device_node *ep, *remote;
>> +
>> +       for_each_child_of_node(port, ep) {
>> +               remote =3D of_graph_get_remote_port_parent(ep);
>> +               if (!remote || !of_device_is_available(remote)) {
>> +                       of_node_put(remote);
>> +                       continue;
>> +               } else if (!of_device_is_available(remote->parent)) {
>> +                       dev_warn(dev, "parent device of %s is not avai=
lable\n",
>> +                                remote->full_name);
>> +                       of_node_put(remote);
>> +                       continue;
>> +               }
>> +
>> +               component_match_add(dev, match, compare_of, remote);
>> +               of_node_put(remote);
>> +       }
>> +}
>> +
>> +static int rockchip_drm_bind(struct device *dev)
>> +{
>> +       struct drm_device *drm;
>> +       int ret;
>> +
>> +       drm =3D drm_dev_alloc(&rockchip_drm_driver, dev);
>> +       if (!drm)
>> +               return -ENOMEM;
>> +
>> +       ret =3D drm_dev_set_unique(drm, "%s", dev_name(dev));
>> +       if (ret)
>> +               goto err_free;
>> +
>> +       ret =3D drm_dev_register(drm, 0);
>> +       if (ret)
>> +               goto err_free;
>> +
>> +       dev_set_drvdata(dev, drm);
>> +
>> +       return 0;
>> +
>> +err_free:
>> +       drm_dev_unref(drm);
>> +       return ret;
>> +}
>> +
>> +static void rockchip_drm_unbind(struct device *dev)
>> +{
>> +       struct drm_device *drm =3D dev_get_drvdata(dev);
>> +
>> +       drm_dev_unregister(drm);
>> +       drm_dev_unref(drm);
>> +}
>> +
>> +static const struct component_master_ops rockchip_drm_ops =3D {
>> +       .bind =3D rockchip_drm_bind,
>> +       .unbind =3D rockchip_drm_unbind,
>> +};
>> +
>> +static int rockchip_drm_platform_probe(struct platform_device *pdev)
>> +{
>> +       struct device *dev =3D &pdev->dev;
>> +       struct component_match *match =3D NULL;
>> +       struct device_node *np =3D dev->of_node;
>> +       struct device_node *port;
>> +       int i;
>> +       int ret;
>> +
>> +       if (!np)
>> +               return -ENODEV;
>> +       /*
>> +        * Bind the crtc ports first, so that
>> +        * drm_of_find_possible_crtcs called from encoder .bind callba=
cks
>> +        * works as expected.
>> +        */
>> +       for (i =3D 0;; i++) {
>> +               port =3D of_parse_phandle(np, "ports", i);
>> +               if (!port)
>> +                       break;
> I think you want to make sure that the parent node of this 'port' (ie,
> the VOP node) is not disabled...
>
>    if (!of_device_is_available(port->parent)) {
>      of_node_put(port);
>      continue;
>    }
right, vop node maybe disabled, we should check it.
>> +
>> +               component_match_add(dev, &match, compare_of, port->par=
ent);
>> +               of_node_put(port);
>> +       }
>> +
>> +       if (i =3D=3D 0) {
>> +               dev_err(dev, "missing 'ports' property\n");
>> +               return -ENODEV;
>> +       }
>> +       /*
>> +        * For each bound crtc, bind the encoders attached to its
>> +        * remote endpoint.
>> +        */
>> +       for (i =3D 0;; i++) {
>> +               port =3D of_parse_phandle(np, "ports", i);
>> +               if (!port)
>> +                       break;
>> +
> Here, too:
>    if (!of_device_is_available(port->parent)) {
>      of_node_put(port);
>      continue;
>    }
OK.
>> +               rockchip_add_endpoints(dev, &match, port);
>> +               of_node_put(port);
>> +       }
>> +
>> +       ret =3D dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
>> +       if (ret)
>> +               return ret;
>> +
>> +       return component_master_add_with_match(dev, &rockchip_drm_ops,=
 match);
>> +}
>> +
>> +static int rockchip_drm_platform_remove(struct platform_device *pdev)
>> +{
>> +       component_master_del(&pdev->dev, &rockchip_drm_ops);
>> +
>> +       return 0;
>> +}
>> +
>> +static const struct of_device_id rockchip_drm_dt_ids[] =3D {
>> +       { .compatible =3D "rockchip,display-subsystem", },
>> +       { /* sentinel */ },
>> +};
>> +MODULE_DEVICE_TABLE(of, rockchip_drm_dt_ids);
>> +
>> +static struct platform_driver rockchip_drm_platform_driver =3D {
>> +       .probe =3D rockchip_drm_platform_probe,
>> +       .remove =3D rockchip_drm_platform_remove,
>> +       .driver =3D {
>> +               .owner =3D THIS_MODULE,
>> +               .name =3D "rockchip-drm",
>> +               .of_match_table =3D rockchip_drm_dt_ids,
>        .pm =3D &rockchip_drm_pm_ops,
OK
>> +       },
>> +};
>> +
>> +module_platform_driver(rockchip_drm_platform_driver);
>> +
>> +MODULE_AUTHOR("Mark Yao <mark.yao@rock-chips.com>");
>> +MODULE_DESCRIPTION("ROCKCHIP DRM Driver");
>> +MODULE_LICENSE("GPL v2");
>> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_drv.h b/drivers/gpu=
/drm/rockchip/rockchip_drm_drv.h
>> new file mode 100644
>> index 0000000..154b3ec
>> --- /dev/null
>> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_drv.h
>> @@ -0,0 +1,120 @@
>> +/*
>> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
>> + * Author:Mark Yao <mark.yao@rock-chips.com>
>> + *
>> + * based on exynos_drm_drv.h
>> + *
>> + * This software is licensed under the terms of the GNU General Publi=
c
>> + * License version 2, as published by the Free Software Foundation, a=
nd
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
>> +#define ROCKCHIP_MAX_FB_BUFFER 4
> This is only used to size the array of gem object pointers used by a
> framebuffer .
> What framebuffer pixel format uses 4 planes?  I think the max is 3?
right, the max is 3 with YUV format.
>> +#define ROCKCHIP_MAX_CONNECTOR 2
>> +
>> +struct drm_device;
>> +struct drm_connector;
>> +
>> +/*
>> + * display output interface supported by rockchip lcdc
> s/lcdc/vop
OK, I will fix it.
>> + */
>> +#define ROCKCHIP_OUTFACE_P888  0
>> +#define ROCKCHIP_OUTFACE_P666  1
>> +#define ROCKCHIP_OUTFACE_P565  2
>> +/* for use special outface */
>> +#define ROCKCHIP_OUTFACE_AAAA  15
> "outface" is creative.  It is actually an English word that means "to
> disconcert an opponent by bold confrontation", I do not think that is
> what you mean here :-).
>
> Rename these to ROCKCHIP_OUT_MODE_, to be consistent with the
> corresponding field (dsp_out_mode) of the VOP_DSP_CTRL0 register to
> which these are written.
> Also, since these are register values written to VOP_DSP_CTRL0, so
> move them to the VOP header file.
"outface" maybe Chinese English, so you are right, I will change it.
>> +
>> +#define ROCKCHIP_COLOR_SWAP_RG 0x1
>> +#define ROCKCHIP_COLOR_SWAP_RB 0x2
>> +#define ROCKCHIP_COLOR_SWAP_GB 0x4
>> +
>> +/*
>> + * Special mode info for rockchip
>> + *
>> + * @out_type: lcd controller need to know the sceen type.
>> + */
>> +struct rockchip_display_mode {
>> +       int out_type;
>> +};
>> +
>> +#define ROCKCHIP_EVENT_HOTPLUG 1
>> +
>> +enum rockchip_plane_type {
>> +       ROCKCHIP_WIN0,
>> +       ROCKCHIP_WIN1,
>> +       ROCKCHIP_WIN2,
>> +       ROCKCHIP_WIN3,
>> +       ROCKCHIP_CURSOR,
>> +       ROCKCHIP_MAX_PLANE,
>> +};
>> +
>> +/* This enumerates device type. */
>> +enum rockchip_drm_device_type {
>> +       ROCKCHIP_DEVICE_TYPE_NONE,
>> +       ROCKCHIP_DEVICE_TYPE_CRTC,
>> +       ROCKCHIP_DEVICE_TYPE_CONNECTOR,
>> +};
>> +
>> +/* this enumerates display type. */
>> +enum rockchip_drm_output_type {
>> +       ROCKCHIP_DISPLAY_TYPE_NONE =3D 0,
> To match the enum name, use ROCKCHIP_OUTPUT_TYPE_*.
> Also, no need to explicitly set the first one to 0.
> However, see below.  I don't think we to modify the drm_display_mode
> to include an output type.
but vop devices need know the connector type, connector enable register=20
is in vop.
can I do that like under to  get connector type for crtc?

     static int rockchip_get_connector_type(struct drm_crtc *crtc)
     {
           struct drm_device *dev =3D crtc->dev;
           struct drm_connector * connector;

           list_for_each_entry(connector,=20
&dev->mode_config.connector_list, head) {
           if (!connector->encoder)
                   continue;
           /*
            * one crtc only has one connector in my case, so just find=20
the first connector at list.
            */
           if (connector->encoder->crtc =3D=3D crtc)
                   break;
     }

     if (!connector)
             return -EINVAL;

     return connector->connector_type;
}
>> +       /* RGB Interface. */
>> +       ROCKCHIP_DISPLAY_TYPE_RGB,
>> +       /* LVDS Interface. */
>> +       ROCKCHIP_DISPLAY_TYPE_LVDS,
>> +       /* EDP Interface. */
>> +       ROCKCHIP_DISPLAY_TYPE_EDP,
>> +       /* MIPI Interface. */
>> +       ROCKCHIP_DISPLAY_TYPE_MIPI,
>> +       /* HDMI Interface. */
>> +       ROCKCHIP_DISPLAY_TYPE_HDMI,
>> +};
>> +
>> +enum rockchip_crtc_type {
>> +       ROCKCHIP_CRTC_VOPB,
>> +       ROCKCHIP_CRTC_VOPL,
>> +       ROCKCHIP_MAX_CRTC,
>> +};
> None of the following defined above are used and they can all be remove=
d:
>   ROCKCHIP_EVENT_HOTPLUG
>   rockchip_plane_type
>   rockchip_drm_device_type
>   ROCKCHIP_COLOR_SWAP_*
>   rockchip_crtc_type
OK, I will drop them.
>> +
>> +/*
>> + * Rockchip drm private structure.
>> + *
>> + * @num_pipe: number of pipes for this device.
>> + */
>> +struct rockchip_drm_private {
>> +       struct drm_fb_helper *fb_helper;
>> +       /*
>> +        * created crtc object would be contained at this array and
>> +        * this array is used to be aware of which crtc did it request=
 vblank.
>> +        */
> Move this comment up to the struct comment, above "num_pipe".
>
> @crtc: array of enabled CRTCs, used to map from "pipe" to drm_crtc
OK
>> +       struct drm_crtc *crtc[ROCKCHIP_MAX_CRTC];
>> +
>> +       unsigned int num_pipe;
>> +};
>> +
>> +int rockchip_drm_add_crtc(struct drm_device *drm, struct drm_crtc *cr=
tc,
>> +                         struct device_node *port);
>> +void rockchip_drm_remove_crtc(struct drm_device *drm, int pipe);
>> +struct drm_crtc *rockchip_find_crtc(struct drm_device *drm, int pipe)=
;
> For consistency, this should probably be "rockchip_drm_find_crtc",
> although you can probably drop the "_drm" from all of these function
> names if you wanted to make them shorter.
> Or, perhaps use:  rk_drm_*()
OK
>> +int rockchip_drm_encoder_get_mux_id(struct device_node *node,
>> +                                   struct drm_encoder *encoder);
>> +void rockchip_drm_crtc_finish_pageflip(struct drm_device *dev, int pi=
pe);
>> +void rockchip_drm_crtc_cancel_pending_flip(struct drm_device *dev);
>> +int rockchip_drm_crtc_enable_vblank(struct drm_device *dev, int pipe)=
;
>> +void rockchip_drm_crtc_disable_vblank(struct drm_device *dev, int pip=
e);
>> +int rockchip_drm_dma_attach_device(struct drm_device *drm_dev,
>> +                                  struct device *dev);
>> +void rockchip_drm_dma_detach_device(struct drm_device *drm_dev,
>> +                                   struct device *dev);
> A blank line here helps.
OK
>> +#endif /* _ROCKCHIP_DRM_DRV_H_ */
>> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_fb.c b/drivers/gpu/=
drm/rockchip/rockchip_drm_fb.c
>> new file mode 100644
>> index 0000000..482f7b8
>> --- /dev/null
>> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_fb.c
>> @@ -0,0 +1,201 @@
>> +/*
>> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
>> + * Author:Mark Yao <mark.yao@rock-chips.com>
>> + *
>> + * This software is licensed under the terms of the GNU General Publi=
c
>> + * License version 2, as published by the Free Software Foundation, a=
nd
>> + * may be copied, distributed, and modified under those terms.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <drm/drm.h>
>> +#include <drm/drmP.h>
>> +#include <drm/drm_fb_helper.h>
>> +#include <drm/drm_crtc_helper.h>
>> +
>> +#include "rockchip_drm_drv.h"
>> +#include "rockchip_drm_gem.h"
>> +
>> +#define to_rockchip_fb(x) container_of(x, struct rockchip_drm_fb, fb)
>> +
>> +struct rockchip_drm_fb {
>> +       struct drm_framebuffer fb;
>> +       struct drm_gem_object *obj[ROCKCHIP_MAX_FB_BUFFER];
>> +};
>> +
>> +struct drm_gem_object *rockchip_fb_get_gem_obj(struct drm_framebuffer=
 *fb,
>> +                                              unsigned int plane)
>> +{
>> +       struct rockchip_drm_fb *rk_fb =3D to_rockchip_fb(fb);
>> +
>> +       if (plane >=3D ROCKCHIP_MAX_FB_BUFFER)
>> +               return NULL;
>> +
>> +       return rk_fb->obj[plane];
>> +}
>> +
>> +static void rockchip_drm_fb_destroy(struct drm_framebuffer *fb)
>> +{
>> +       struct rockchip_drm_fb *rockchip_fb =3D to_rockchip_fb(fb);
>> +       struct drm_gem_object *obj;
>> +       int i;
>> +
>> +       for (i =3D 0; i < ROCKCHIP_MAX_FB_BUFFER; i++) {
>> +               obj =3D rockchip_fb->obj[i];
>> +               if (obj)
>> +                       drm_gem_object_unreference_unlocked(obj);
>> +       }
>> +
>> +       drm_framebuffer_cleanup(fb);
>> +       kfree(rockchip_fb);
>> +}
>> +
>> +static int rockchip_drm_fb_create_handle(struct drm_framebuffer *fb,
>> +                                        struct drm_file *file_priv,
>> +                                        unsigned int *handle)
>> +{
>> +       struct rockchip_drm_fb *rockchip_fb =3D to_rockchip_fb(fb);
>> +
>> +       return drm_gem_handle_create(file_priv,
>> +                                    rockchip_fb->obj[0], handle);
>> +}
>> +
>> +static struct drm_framebuffer_funcs rockchip_drm_fb_funcs =3D {
>> +       .destroy        =3D rockchip_drm_fb_destroy,
>> +       .create_handle  =3D rockchip_drm_fb_create_handle,
>> +};
>> +
>> +static struct rockchip_drm_fb *
>> +rockchip_fb_alloc(struct drm_device *dev, struct drm_mode_fb_cmd2 *mo=
de_cmd,
>> +                 struct drm_gem_object **obj, unsigned int num_planes=
)
>> +{
>> +       struct rockchip_drm_fb *rockchip_fb;
>> +       int ret;
>> +       int i;
>> +
>> +       rockchip_fb =3D kzalloc(sizeof(*rockchip_fb), GFP_KERNEL);
>> +       if (!rockchip_fb)
>> +               return ERR_PTR(-ENOMEM);
>> +
>> +       drm_helper_mode_fill_fb_struct(&rockchip_fb->fb, mode_cmd);
>> +
>> +       for (i =3D 0; i < num_planes; i++)
>> +               rockchip_fb->obj[i] =3D obj[i];
>> +
>> +       ret =3D drm_framebuffer_init(dev, &rockchip_fb->fb,
>> +                                  &rockchip_drm_fb_funcs);
>> +       if (ret) {
>> +               dev_err(dev->dev, "Failed to initialize framebuffer: %=
d\n",
>> +                       ret);
>> +               kfree(rockchip_fb);
>> +               return ERR_PTR(ret);
>> +       }
>> +
>> +       return rockchip_fb;
>> +}
>> +
>> +static struct drm_framebuffer *
>> +rockchip_user_fb_create(struct drm_device *dev, struct drm_file *file=
_priv,
>> +                       struct drm_mode_fb_cmd2 *mode_cmd)
>> +{
>> +       struct rockchip_drm_fb *rockchip_fb;
>> +       struct drm_gem_object *objs[ROCKCHIP_MAX_FB_BUFFER];
>> +       struct drm_gem_object *obj;
>> +       unsigned int hsub;
>> +       unsigned int vsub;
>> +       int num_planes;
>> +       int ret;
>> +       int i;
>> +
>> +       hsub =3D drm_format_horz_chroma_subsampling(mode_cmd->pixel_fo=
rmat);
>> +       vsub =3D drm_format_vert_chroma_subsampling(mode_cmd->pixel_fo=
rmat);
>> +       num_planes =3D min(drm_format_num_planes(mode_cmd->pixel_forma=
t),
>> +                        ROCKCHIP_MAX_FB_BUFFER);
>> +
>> +       for (i =3D 0; i < num_planes; i++) {
>> +               unsigned int width =3D mode_cmd->width / (i ? hsub : 1=
);
>> +               unsigned int height =3D mode_cmd->height / (i ? vsub :=
 1);
>> +               unsigned int min_size;
>> +
>> +               obj =3D drm_gem_object_lookup(dev, file_priv,
>> +                                           mode_cmd->handles[i]);
>> +               if (!obj) {
>> +                       dev_err(dev->dev, "Failed to lookup GEM object=
\n");
>> +                       ret =3D -ENXIO;
>> +                       goto err_gem_object_unreference;
>> +               }
>> +
>> +               min_size =3D (height - 1) * mode_cmd->pitches[i] +
>> +                       mode_cmd->offsets[i] +
>> +                       width * drm_format_plane_cpp(mode_cmd->pixel_f=
ormat, i);
>> +
>> +               if (obj->size < min_size) {
>> +                       drm_gem_object_unreference_unlocked(obj);
>> +                       ret =3D -EINVAL;
>> +                       goto err_gem_object_unreference;
>> +               }
>> +               objs[i] =3D obj;
>> +       }
>> +
>> +       rockchip_fb =3D rockchip_fb_alloc(dev, mode_cmd, objs, i);
>> +       if (IS_ERR(rockchip_fb)) {
>> +               ret =3D PTR_ERR(rockchip_fb);
>> +               goto err_gem_object_unreference;
>> +       }
>> +
>> +       return &rockchip_fb->fb;
>> +
>> +err_gem_object_unreference:
>> +       for (i--; i >=3D 0; i--)
>> +               drm_gem_object_unreference_unlocked(objs[i]);
>> +       return ERR_PTR(ret);
>> +}
>> +
>> +static void rockchip_drm_output_poll_changed(struct drm_device *dev)
>> +{
>> +       struct rockchip_drm_private *private =3D dev->dev_private;
>> +       struct drm_fb_helper *fb_helper =3D private->fb_helper;
>> +
>> +       if (fb_helper)
>> +               drm_fb_helper_hotplug_event(fb_helper);
>> +}
>> +
>> +static const struct drm_mode_config_funcs rockchip_drm_mode_config_fu=
ncs =3D {
>> +       .fb_create =3D rockchip_user_fb_create,
>> +       .output_poll_changed =3D rockchip_drm_output_poll_changed,
>> +};
>> +
>> +struct drm_framebuffer *
>> +rockchip_drm_framebuffer_init(struct drm_device *dev,
>> +                             struct drm_mode_fb_cmd2 *mode_cmd,
>> +                             struct drm_gem_object *obj)
>> +{
>> +       struct rockchip_drm_fb *rockchip_fb;
>> +
>> +       rockchip_fb =3D rockchip_fb_alloc(dev, mode_cmd, &obj, 1);
>> +       if (IS_ERR(rockchip_fb))
>> +               return NULL;
>> +
>> +       return &rockchip_fb->fb;
>> +}
>> +
>> +void rockchip_drm_mode_config_init(struct drm_device *dev)
>> +{
>> +       dev->mode_config.min_width =3D 0;
>> +       dev->mode_config.min_height =3D 0;
>> +
>> +       /*
>> +        * set max width and height as default value(4096x4096).
>> +        * this value would be used to check framebuffer size limitati=
on
>> +        * at drm_mode_addfb().
>> +        */
>> +       dev->mode_config.max_width =3D 4096;
>> +       dev->mode_config.max_height =3D 4096;
>> +
>> +       dev->mode_config.funcs =3D &rockchip_drm_mode_config_funcs;
>> +}
>> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_fb.h b/drivers/gpu/=
drm/rockchip/rockchip_drm_fb.h
>> new file mode 100644
>> index 0000000..09574d4
>> --- /dev/null
>> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_fb.h
>> @@ -0,0 +1,28 @@
>> +/*
>> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
>> + * Author:Mark Yao <mark.yao@rock-chips.com>
>> + *
>> + * This software is licensed under the terms of the GNU General Publi=
c
>> + * License version 2, as published by the Free Software Foundation, a=
nd
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
>> +                             struct drm_mode_fb_cmd2 *mode_cmd,
>> +                             struct drm_gem_object *obj);
>> +void rockchip_drm_framebuffer_fini(struct drm_framebuffer *fb);
>> +
>> +void rockchip_drm_mode_config_init(struct drm_device *dev);
>> +
>> +struct drm_gem_object *rockchip_fb_get_gem_obj(struct drm_framebuffer=
 *fb,
>> +                                              unsigned int plane);
>> +#endif /* _ROCKCHIP_DRM_FB_H */
>> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c b/drivers/g=
pu/drm/rockchip/rockchip_drm_fbdev.c
>> new file mode 100644
>> index 0000000..ae563f5
>> --- /dev/null
>> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c
>> @@ -0,0 +1,230 @@
>> +/*
>> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
>> + * Author:Mark Yao <mark.yao@rock-chips.com>
>> + *
>> + * This software is licensed under the terms of the GNU General Publi=
c
>> + * License version 2, as published by the Free Software Foundation, a=
nd
>> + * may be copied, distributed, and modified under those terms.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <drm/drm.h>
>> +#include <drm/drmP.h>
>> +#include <drm/drm_fb_helper.h>
>> +#include <drm/drm_crtc_helper.h>
>> +
>> +#include "rockchip_drm_drv.h"
>> +#include "rockchip_drm_gem.h"
>> +#include "rockchip_drm_fb.h"
>> +
>> +#define PREFERRED_BPP          32
>> +#define to_rockchip_fbdev(x) container_of(x, struct rockchip_fbdev, h=
elper)
>> +
>> +struct rockchip_fbdev {
>> +       struct drm_fb_helper helper;
>> +       struct drm_gem_object *bo;
>> +};
>> +
>> +static int rockchip_fbdev_mmap(struct fb_info *info,
>> +                              struct vm_area_struct *vma)
>> +{
>> +       struct drm_fb_helper *helper =3D info->par;
>> +       struct rockchip_fbdev *fbdev =3D to_rockchip_fbdev(helper);
>> +
>> +       return rockchip_gem_mmap(fbdev->bo, vma);
>> +}
>> +
>> +static struct fb_ops rockchip_drm_fbdev_ops =3D {
>> +       .owner          =3D THIS_MODULE,
>> +       .fb_mmap        =3D rockchip_fbdev_mmap,
>> +       .fb_fillrect    =3D cfb_fillrect,
>> +       .fb_copyarea    =3D cfb_copyarea,
>> +       .fb_imageblit   =3D cfb_imageblit,
>> +       .fb_check_var   =3D drm_fb_helper_check_var,
>> +       .fb_set_par     =3D drm_fb_helper_set_par,
>> +       .fb_blank       =3D drm_fb_helper_blank,
>> +       .fb_pan_display =3D drm_fb_helper_pan_display,
>> +       .fb_setcmap     =3D drm_fb_helper_setcmap,
>> +};
>> +
>> +static int rockchip_drm_fbdev_create(struct drm_fb_helper *helper,
>> +                                    struct drm_fb_helper_surface_size=
 *sizes)
>> +{
>> +       struct rockchip_fbdev *fbdev =3D to_rockchip_fbdev(helper);
>> +       struct drm_mode_fb_cmd2 mode_cmd =3D { 0 };
>> +       struct drm_device *dev =3D helper->dev;
>> +       struct rockchip_gem_object *rk_obj;
>> +       struct drm_framebuffer *fb;
>> +       unsigned int bytes_per_pixel;
>> +       unsigned long offset;
>> +       struct fb_info *fbi;
>> +       size_t size;
>> +       int ret;
>> +
>> +       bytes_per_pixel =3D DIV_ROUND_UP(sizes->surface_bpp, 8);
>> +
>> +       mode_cmd.width =3D sizes->surface_width;
>> +       mode_cmd.height =3D sizes->surface_height;
>> +       mode_cmd.pitches[0] =3D sizes->surface_width * bytes_per_pixel=
;
>> +       mode_cmd.pixel_format =3D drm_mode_legacy_fb_format(sizes->sur=
face_bpp,
>> +               sizes->surface_depth);
>> +
>> +       size =3D mode_cmd.pitches[0] * mode_cmd.height;
>> +
>> +       rk_obj =3D rockchip_gem_create_object(dev, size);
>> +       if (IS_ERR(rk_obj))
>> +               return -ENOMEM;
>> +
>> +       fbdev->bo =3D &rk_obj->base;
>> +
>> +       fbi =3D framebuffer_alloc(0, dev->dev);
>> +       if (!fbi) {
>> +               dev_err(dev->dev, "Failed to allocate framebuffer info=
.\n");
>> +               ret =3D -ENOMEM;
>> +               goto err_rockchip_gem_free_object;
>> +       }
>> +
>> +       helper->fb =3D rockchip_drm_framebuffer_init(dev, &mode_cmd, f=
bdev->bo);
>> +       if (IS_ERR(helper->fb)) {
>> +               dev_err(dev->dev, "Failed to allocate DRM framebuffer.=
\n");
>> +               ret =3D PTR_ERR(helper->fb);
>> +               goto err_framebuffer_release;
>> +       }
>> +
>> +       helper->fbdev =3D fbi;
>> +
>> +       fbi->par =3D helper;
>> +       fbi->flags =3D FBINFO_FLAG_DEFAULT;
>> +       fbi->fbops =3D &rockchip_drm_fbdev_ops;
>> +
>> +       ret =3D fb_alloc_cmap(&fbi->cmap, 256, 0);
>> +       if (ret) {
>> +               dev_err(dev->dev, "Failed to allocate color map.\n");
>> +               goto err_drm_framebuffer_unref;
>> +       }
>> +
>> +       fb =3D helper->fb;
>> +       drm_fb_helper_fill_fix(fbi, fb->pitches[0], fb->depth);
>> +       drm_fb_helper_fill_var(fbi, helper, fb->width, fb->height);
>> +
>> +       offset =3D fbi->var.xoffset * bytes_per_pixel;
>> +       offset +=3D fbi->var.yoffset * fb->pitches[0];
>> +
>> +       dev->mode_config.fb_base =3D 0;
>> +       fbi->screen_base =3D rk_obj->kvaddr + offset;
>> +       fbi->screen_size =3D rk_obj->base.size;
>> +       fbi->fix.smem_len =3D rk_obj->base.size;
>> +
>> +       DRM_DEBUG_KMS("FB [%dx%d]-%d kvaddr=3D%p offset=3D%ld size=3D%=
d\n",
>> +                     fb->width, fb->height, fb->depth, rk_obj->kvaddr=
,
>> +                     offset, size);
>> +       return 0;
>> +
>> +err_drm_framebuffer_unref:
>> +       drm_framebuffer_unreference(helper->fb);
>> +err_framebuffer_release:
>> +       framebuffer_release(fbi);
>> +err_rockchip_gem_free_object:
>> +       rockchip_gem_free_object(&rk_obj->base);
>> +       return ret;
>> +}
>> +
>> +static struct drm_fb_helper_funcs rockchip_drm_fb_helper_funcs =3D {
>> +       .fb_probe =3D rockchip_drm_fbdev_create,
>> +};
>> +
>> +int rockchip_drm_fbdev_init(struct drm_device *dev)
>> +{
>> +       struct rockchip_drm_private *private =3D dev->dev_private;
>> +       struct rockchip_fbdev *fbdev;
>> +       struct drm_fb_helper *helper;
>> +       unsigned int num_crtc;
>> +       int ret;
>> +
>> +       if (!dev->mode_config.num_crtc || !dev->mode_config.num_connec=
tor)
>> +               return -EINVAL;
>> +
>> +       if (private->fb_helper) {
>> +               DRM_ERROR("no allow to reinit fbdev\n");
>> +               return -EINVAL;
>> +       }
>> +
>> +       num_crtc =3D dev->mode_config.num_crtc;
>> +
>> +       fbdev =3D kzalloc(sizeof(*fbdev), GFP_KERNEL);
>> +       if (!fbdev)
>> +               return -ENOMEM;
>> +
>> +       fbdev->helper.funcs =3D &rockchip_drm_fb_helper_funcs;
>> +       helper =3D &fbdev->helper;
>> +
>> +       ret =3D drm_fb_helper_init(dev, helper, num_crtc, ROCKCHIP_MAX=
_CONNECTOR);
>> +       if (ret < 0) {
>> +               dev_err(dev->dev, "Failed to initialize drm fb helper.=
\n");
>> +               goto err_free;
>> +       }
>> +
>> +       ret =3D drm_fb_helper_single_add_all_connectors(helper);
>> +       if (ret < 0) {
>> +               dev_err(dev->dev, "Failed to add connectors.\n");
>> +               goto err_drm_fb_helper_fini;
>> +       }
>> +
>> +       /* disable all the possible outputs/crtcs before entering KMS =
mode */
>> +       drm_helper_disable_unused_functions(dev);
>> +
>> +       ret =3D drm_fb_helper_initial_config(helper, PREFERRED_BPP);
>> +       if (ret < 0) {
>> +               dev_err(dev->dev, "Failed to set initial hw configurat=
ion.\n");
>> +               goto err_drm_fb_helper_fini;
>> +       }
>> +
>> +       private->fb_helper =3D helper;
>> +
>> +       return 0;
>> +
>> +err_drm_fb_helper_fini:
>> +       drm_fb_helper_fini(helper);
>> +err_free:
>> +       kfree(fbdev);
>> +       return ret;
>> +}
>> +
>> +void rockchip_drm_fbdev_fini(struct drm_device *dev)
>> +{
>> +       struct rockchip_drm_private *private =3D dev->dev_private;
>> +       struct drm_fb_helper *helper;
>> +       struct rockchip_fbdev *fbdev;
>> +
>> +       if (!private || !private->fb_helper)
>> +               return;
>> +
>> +       helper =3D private->fb_helper;
>> +       fbdev =3D to_rockchip_fbdev(helper);
>> +
>> +       if (helper->fbdev) {
>> +               struct fb_info *info;
>> +               int ret;
>> +
>> +               info =3D helper->fbdev;
>> +               ret =3D unregister_framebuffer(info);
>> +               if (ret < 0)
>> +                       DRM_DEBUG_KMS("failed unregister_framebuffer()=
\n");
>> +
>> +               if (info->cmap.len)
>> +                       fb_dealloc_cmap(&info->cmap);
>> +
>> +               framebuffer_release(info);
>> +       }
>> +
>> +       if (helper->fb)
>> +               drm_framebuffer_unreference(helper->fb);
>> +
>> +       drm_fb_helper_fini(helper);
>> +       kfree(fbdev);
>> +       private->fb_helper =3D NULL;
>> +}
>> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h b/drivers/g=
pu/drm/rockchip/rockchip_drm_fbdev.h
>> new file mode 100644
>> index 0000000..5edcf6a
>> --- /dev/null
>> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h
>> @@ -0,0 +1,20 @@
>> +/*
>> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
>> + * Author:Mark Yao <mark.yao@rock-chips.com>
>> + *
>> + * This software is licensed under the terms of the GNU General Publi=
c
>> + * License version 2, as published by the Free Software Foundation, a=
nd
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
>> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c b/drivers/gpu=
/drm/rockchip/rockchip_drm_gem.c
>> new file mode 100644
>> index 0000000..8e7a91c
>> --- /dev/null
>> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
>> @@ -0,0 +1,341 @@
>> +/*
>> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
>> + * Author:Mark Yao <mark.yao@rock-chips.com>
>> + *
>> + * This software is licensed under the terms of the GNU General Publi=
c
>> + * License version 2, as published by the Free Software Foundation, a=
nd
>> + * may be copied, distributed, and modified under those terms.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <drm/drm.h>
>> +#include <drm/drmP.h>
>> +#include <drm/drm_vma_manager.h>
>> +
>> +#include <linux/anon_inodes.h>
>> +#include <linux/dma-attrs.h>
>> +
>> +#include "rockchip_drm_drv.h"
>> +#include "rockchip_drm_gem.h"
>> +
>> +static int rockchip_gem_alloc_buf(struct rockchip_gem_object *rk_obj)
>> +{
>> +       struct drm_gem_object *obj =3D &rk_obj->base;
>> +       struct drm_device *drm =3D obj->dev;
>> +
>> +       init_dma_attrs(&rk_obj->dma_attrs);
>> +       dma_set_attr(DMA_ATTR_WRITE_COMBINE, &rk_obj->dma_attrs);
>> +
>> +       /* TODO(djkurtz): Use DMA_ATTR_NO_KERNEL_MAPPING except for fb=
dev */
>> +       rk_obj->kvaddr =3D dma_alloc_attrs(drm->dev, obj->size,
>> +                                        &rk_obj->dma_addr, GFP_KERNEL=
,
>> +                                        &rk_obj->dma_attrs);
>> +       if (IS_ERR(rk_obj->kvaddr)) {
>> +               int ret =3D PTR_ERR(rk_obj->kvaddr);
>> +
>> +               DRM_ERROR("failed to allocate %#x byte dma buffer, %d"=
,
>> +                         obj->size, ret);
>> +               return ret;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static void rockchip_gem_free_buf(struct rockchip_gem_object *rk_obj)
>> +{
>> +       struct drm_gem_object *obj =3D &rk_obj->base;
>> +       struct drm_device *drm =3D obj->dev;
>> +
>> +       dma_free_attrs(drm->dev, obj->size, rk_obj->kvaddr, rk_obj->dm=
a_addr,
>> +                      &rk_obj->dma_attrs);
>> +}
>> +
>> +/* drm driver mmap file operations */
>> +int rockchip_drm_gem_mmap(struct file *filp, struct vm_area_struct *v=
ma)
>> +{
>> +       struct drm_file *priv =3D filp->private_data;
>> +       struct drm_device *dev =3D priv->minor->dev;
>> +       struct drm_gem_object *obj;
>> +       struct drm_vma_offset_node *node;
>> +       int ret;
>> +
>> +       if (drm_device_is_unplugged(dev))
>> +               return -ENODEV;
>> +
>> +       mutex_lock(&dev->struct_mutex);
>> +
>> +       node =3D drm_vma_offset_exact_lookup(dev->vma_offset_manager,
>> +                                          vma->vm_pgoff,
>> +                                          vma_pages(vma));
>> +       if (!node) {
>> +               mutex_unlock(&dev->struct_mutex);
>> +               DRM_ERROR("failed to find vma node.\n");
>> +               return -EINVAL;
>> +       } else if (!drm_vma_node_is_allowed(node, filp)) {
>> +               mutex_unlock(&dev->struct_mutex);
>> +               return -EACCES;
>> +       }
>> +
>> +       obj =3D container_of(node, struct drm_gem_object, vma_node);
>> +       ret =3D rockchip_gem_mmap(obj, vma);
>> +
>> +       mutex_unlock(&dev->struct_mutex);
>> +
>> +       return ret;
>> +}
>> +
>> +int rockchip_drm_gem_mmap_buffer(struct file *filp,
>> +                                struct vm_area_struct *vma)
>> +{
>> +       struct drm_gem_object *obj =3D filp->private_data;
>> +
>> +       return rockchip_gem_mmap(obj, vma);
>> +}
>> +
>> +static const struct file_operations rockchip_drm_gem_fops =3D {
>> +       .mmap =3D rockchip_drm_gem_mmap_buffer,
>> +};
>> +
>> +struct rockchip_gem_object *
>> +       rockchip_gem_create_object(struct drm_device *drm, unsigned in=
t size)
>> +{
>> +       struct rockchip_gem_object *rk_obj;
>> +       struct drm_gem_object *obj;
>> +       struct file *filp;
>> +       int ret;
>> +
>> +       size =3D round_up(size, PAGE_SIZE);
>> +
>> +       rk_obj =3D kzalloc(sizeof(*rk_obj), GFP_KERNEL);
>> +       if (!rk_obj)
>> +               return ERR_PTR(-ENOMEM);
>> +
>> +       obj =3D &rk_obj->base;
>> +
>> +       drm_gem_private_object_init(drm, obj, size);
>> +
>> +       filp =3D anon_inode_getfile("rockchip_gem", &rockchip_drm_gem_=
fops,
>> +                                 obj, 0);
>> +       if (IS_ERR(filp)) {
>> +               DRM_ERROR("failed to create anon file object.\n");
>> +               ret =3D PTR_ERR(filp);
>> +               goto err_free_rk_obj;
>> +       }
>> +       filp->f_mode =3D FMODE_READ | FMODE_WRITE;
>> +       obj->filp =3D filp;
>> +
>> +       ret =3D drm_gem_create_mmap_offset(obj);
>> +       if (ret)
>> +               goto err_free_obj;
>> +
>> +       ret =3D rockchip_gem_alloc_buf(rk_obj);
>> +       if (ret)
>> +               goto err_free_mmap_offset;
>> +
>> +       return rk_obj;
>> +
>> +err_free_mmap_offset:
>> +       drm_gem_free_mmap_offset(obj);
>> +err_free_obj:
>> +       drm_gem_object_release(obj);
>> +err_free_rk_obj:
>> +       kfree(rk_obj);
>> +       return ERR_PTR(ret);
>> +}
>> +
>> +/*
>> + * rockchip_gem_free_object - (struct drm_driver)->gem_free_object ca=
llback
>> + * function
>> + */
>> +void rockchip_gem_free_object(struct drm_gem_object *obj)
>> +{
>> +       struct rockchip_gem_object *rk_obj;
>> +
>> +       drm_gem_free_mmap_offset(obj);
>> +
>> +       rk_obj =3D to_rockchip_obj(obj);
>> +
>> +       rockchip_gem_free_buf(rk_obj);
>> +       drm_gem_free_mmap_offset(obj);
>> +
>> +       drm_gem_object_release(obj);
>> +
>> +       kfree(rk_obj);
>> +}
>> +
>> +int rockchip_gem_mmap(struct drm_gem_object *obj, struct vm_area_stru=
ct *vma)
>> +{
>> +       struct rockchip_gem_object *rk_obj =3D to_rockchip_obj(obj);
>> +       struct drm_device *drm =3D obj->dev;
>> +       unsigned long vm_size;
>> +
>> +       vma->vm_flags |=3D VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
>> +       vm_size =3D vma->vm_end - vma->vm_start;
>> +
>> +       if (vm_size > obj->size)
>> +               return -EINVAL;
>> +
>> +       return dma_mmap_attrs(drm->dev, vma, rk_obj->kvaddr, rk_obj->d=
ma_addr,
>> +                            obj->size, &rk_obj->dma_attrs);
>> +}
>> +
>> +/*
>> + * rockchip_gem_create_with_handle - allocate an object with the give=
n
>> + * size and create a gem handle on it
>> + *
>> + * returns a struct rockchip_gem_object* on success or ERR_PTR values
>> + * on failure.
>> + */
>> +static struct rockchip_gem_object *
>> +rockchip_gem_create_with_handle(struct drm_file *file_priv,
>> +                               struct drm_device *drm, unsigned int s=
ize,
>> +                               unsigned int *handle)
>> +{
>> +       struct rockchip_gem_object *rk_obj;
>> +       struct drm_gem_object *obj;
>> +       int ret;
>> +
>> +       rk_obj =3D rockchip_gem_create_object(drm, size);
>> +       if (IS_ERR(rk_obj))
>> +               return NULL;
>> +
>> +       obj =3D &rk_obj->base;
>> +
>> +       /*
>> +        * allocate a id of idr table where the obj is registered
>> +        * and handle has the id what user can see.
>> +        */
>> +       ret =3D drm_gem_handle_create(file_priv, obj, handle);
>> +       if (ret)
>> +               goto err_handle_create;
>> +
>> +       /* drop reference from allocate - handle holds it now. */
>> +       drm_gem_object_unreference_unlocked(obj);
>> +
>> +       return rk_obj;
>> +
>> +err_handle_create:
>> +       rockchip_gem_free_object(obj);
>> +
>> +       return ERR_PTR(ret);
>> +}
>> +
>> +int rockchip_gem_dumb_map_offset(struct drm_file *file_priv,
>> +                                struct drm_device *dev, uint32_t hand=
le,
>> +                                uint64_t *offset)
>> +{
>> +       struct drm_gem_object *obj;
>> +       int ret =3D 0;
>> +
>> +       mutex_lock(&dev->struct_mutex);
>> +
>> +       /*
>> +        * get offset of memory allocated for drm framebuffer.
>> +        * - this callback would be called by user application
>> +        * with DRM_IOCTL_MODE_MAP_DUMB command.
>> +        */
>> +
>> +       obj =3D drm_gem_object_lookup(dev, file_priv, handle);
>> +       if (!obj) {
>> +               DRM_ERROR("failed to lookup gem object.\n");
>> +               ret =3D -EINVAL;
>> +               goto unlock;
>> +       }
>> +
>> +       ret =3D drm_gem_create_mmap_offset(obj);
>> +       if (ret)
>> +               goto out;
>> +
>> +       *offset =3D drm_vma_node_offset_addr(&obj->vma_node);
>> +       DRM_DEBUG_KMS("offset =3D 0x%lx\n", (unsigned long)*offset);
>> +
>> +out:
>> +       drm_gem_object_unreference(obj);
>> +unlock:
>> +       mutex_unlock(&dev->struct_mutex);
>> +       return ret;
>> +}
>> +
>> +/*
>> + * rockchip_gem_dumb_create - (struct drm_driver)->dumb_create callba=
ck
>> + * function
>> + *
>> + * This aligns the pitch and size arguments to the minimum required. =
wrap
>> + * this into your own function if you need bigger alignment.
>> + */
>> +int rockchip_gem_dumb_create(struct drm_file *file_priv,
>> +                            struct drm_device *dev,
>> +                            struct drm_mode_create_dumb *args)
>> +{
>> +       struct rockchip_gem_object *rk_obj;
>> +       int min_pitch =3D DIV_ROUND_UP(args->width * args->bpp, 8);
>> +
>> +       if (args->pitch < min_pitch)
>> +               args->pitch =3D min_pitch;
>> +
>> +       if (args->size < args->pitch * args->height)
>> +               args->size =3D args->pitch * args->height;
>> +
>> +       rk_obj =3D rockchip_gem_create_with_handle(file_priv, dev, arg=
s->size,
>> +                                                &args->handle);
>> +
>> +       return PTR_ERR_OR_ZERO(rk_obj);
>> +}
>> +
>> +/*
>> + * Allocate a sg_table for this GEM object.
>> + * Note: Both the table's contents, and the sg_table itself must be f=
reed by
>> + *       the caller.
>> + * Returns a pointer to the newly allocated sg_table, or an ERR_PTR()=
 error.
>> + */
>> +struct sg_table *rockchip_gem_prime_get_sg_table(struct drm_gem_objec=
t *obj)
>> +{
>> +       struct rockchip_gem_object *rk_obj =3D to_rockchip_obj(obj);
>> +       struct drm_device *drm =3D obj->dev;
>> +       struct sg_table *sgt =3D NULL;
>> +       int ret;
>> +
>> +       sgt =3D kzalloc(sizeof(*sgt), GFP_KERNEL);
>> +       if (!sgt)
>> +               return ERR_PTR(-ENOMEM);
>> +
>> +       ret =3D dma_get_sgtable_attrs(drm->dev, sgt, rk_obj->kvaddr,
>> +                                   rk_obj->dma_addr, obj->size,
>> +                                   &rk_obj->dma_attrs);
>> +       if (ret) {
>> +               DRM_ERROR("failed to allocate sgt, %d\n", ret);
>> +               kfree(sgt);
>> +               return ERR_PTR(ret);
>> +       }
>> +
>> +       return sgt;
>> +}
>> +
>> +void *rockchip_gem_prime_vmap(struct drm_gem_object *obj)
>> +{
>> +       struct rockchip_gem_object *rk_obj =3D to_rockchip_obj(obj);
>> +
>> +       return rk_obj->kvaddr;
>> +}
>> +
>> +void rockchip_gem_prime_vunmap(struct drm_gem_object *obj, void *vadd=
r)
>> +{
>> +       /* Nothing to do */
>> +}
>> +
>> +int rockchip_gem_prime_mmap(struct drm_gem_object *obj,
>> +                           struct vm_area_struct *vma)
>> +{
>> +       struct drm_device *dev =3D obj->dev;
>> +       int ret;
>> +
>> +       mutex_lock(&dev->struct_mutex);
>> +       ret =3D drm_gem_mmap_obj(obj, obj->size, vma);
>> +       mutex_unlock(&dev->struct_mutex);
>> +
>> +       return ret;
>> +}
>> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_gem.h b/drivers/gpu=
/drm/rockchip/rockchip_drm_gem.h
>> new file mode 100644
>> index 0000000..e37b921
>> --- /dev/null
>> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_gem.h
>> @@ -0,0 +1,55 @@
>> +/*
>> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
>> + * Author:Mark Yao <mark.yao@rock-chips.com>
>> + *
>> + * This software is licensed under the terms of the GNU General Publi=
c
>> + * License version 2, as published by the Free Software Foundation, a=
nd
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
>> +#define to_rockchip_obj(x) container_of(x, struct rockchip_gem_object=
, base)
>> +
>> +struct rockchip_gem_object {
>> +       struct drm_gem_object base;
>> +       unsigned int flags;
>> +
>> +       void *kvaddr;
>> +       dma_addr_t dma_addr;
>> +       struct dma_attrs dma_attrs;
>> +};
>> +
>> +struct sg_table *rockchip_gem_prime_get_sg_table(struct drm_gem_objec=
t *obj);
>> +struct drm_gem_object *
>> +rockchip_gem_prime_import_sg_table(struct drm_device *dev, size_t siz=
e,
>> +                                  struct sg_table *sgt);
>> +void *rockchip_gem_prime_vmap(struct drm_gem_object *obj);
>> +void rockchip_gem_prime_vunmap(struct drm_gem_object *obj, void *vadd=
r);
>> +int rockchip_gem_prime_mmap(struct drm_gem_object *obj,
>> +                           struct vm_area_struct *vma);
>> +
>> +/* drm driver mmap file operations */
>> +int rockchip_drm_gem_mmap(struct file *filp, struct vm_area_struct *v=
ma);
>> +
>> +/* mmap a gem object to userspace. */
>> +int rockchip_gem_mmap(struct drm_gem_object *obj, struct vm_area_stru=
ct *vma);
>> +
>> +struct rockchip_gem_object *
>> +       rockchip_gem_create_object(struct drm_device *drm, unsigned in=
t size);
>> +
>> +void rockchip_gem_free_object(struct drm_gem_object *obj);
>> +
>> +int rockchip_gem_dumb_create(struct drm_file *file_priv,
>> +                            struct drm_device *dev,
>> +                            struct drm_mode_create_dumb *args);
>> +int rockchip_gem_dumb_map_offset(struct drm_file *file_priv,
>> +                                struct drm_device *dev, uint32_t hand=
le,
>> +                                uint64_t *offset);
>> +#endif /* _ROCKCHIP_DRM_GEM_H */
>> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/gpu=
/drm/rockchip/rockchip_drm_vop.c
>> new file mode 100644
>> index 0000000..24c3946
>> --- /dev/null
>> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
>> @@ -0,0 +1,1373 @@
>> +/*
>> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
>> + * Author:Mark Yao <mark.yao@rock-chips.com>
>> + *
>> + * This software is licensed under the terms of the GNU General Publi=
c
>> + * License version 2, as published by the Free Software Foundation, a=
nd
>> + * may be copied, distributed, and modified under those terms.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <drm/drm.h>
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
>> +#define VOP_DEFAULT_FRAMERATE  60
>> +#define VOP_MAX_WIN_SUPPORT    5
>> +#define VOP_DEFAULT_CURSOR     1
>> +#define VOP_REG(off, _mask, s) \
>> +               {.offset =3D off, \
>> +                .mask =3D _mask, \
>> +                .shift =3D s,}
>> +
>> +#define __REG_SET(x, off, mask, shift, v) \
>> +               vop_mask_write(x, off, (mask) << shift, (v) << shift)
>> +
>> +#define REG_SET(x, base, reg, v) \
>> +               __REG_SET(x, base + reg.offset, reg.mask, reg.shift, v=
)
>> +
>> +#define VOP_WIN_SET(x, win, name, v) \
>> +               REG_SET(x, win->base, win->phy->name, v)
>> +#define VOP_CTRL_SET(x, name, v) \
>> +               REG_SET(x, 0, (x)->data->ctrl->name, v)
>> +
>> +#define VOP_WIN_GET_YRGBADDR(ctx, win) \
>> +               vop_readl(ctx, win->base + win->phy->yrgb_mst.offset)
>> +
>> +#define to_vop_ctx(x) container_of(x, struct vop_context, crtc)
>> +#define to_rockchip_plane(x) container_of(x, struct rockchip_plane, b=
ase)
>> +
>> +struct rockchip_plane {
>> +       int id;
>> +       struct drm_plane base;
>> +       const struct vop_win *win;
>> +       struct vop_context *ctx;
> Isn't ctx just: to_vop_ctx(base->crtc)
>
OK. we can use to_vop_ctx(base->crtc) to get ctx.
>> +
>> +       uint32_t pending_yrgb_mst;
>> +       struct drm_framebuffer *front_fb;
>> +       struct drm_framebuffer *pending_fb;
>> +       bool enabled;
>> +};
>> +
>> +struct vop_context {
>> +       struct device *dev;
>> +       struct drm_device *drm_dev;
>> +       struct drm_crtc crtc;
>> +       struct drm_pending_vblank_event *event;
>> +       struct vop_driver *drv;
>> +       unsigned int dpms;
>> +       unsigned int win_mask;
>> +       wait_queue_head_t wait_vsync_queue;
>> +       atomic_t wait_vsync_event;
>> +
>> +       struct workqueue_struct *vsync_wq;
>> +       struct work_struct vsync_work;
>> +
>> +       /* mutex vsync_ work */
>> +       struct mutex vsync_mutex;
>> +       bool vsync_work_pending;
>> +
>> +       struct vop_driver_data *data;
>> +
>> +       uint32_t *regsbak;
>> +       void __iomem *regs;
>> +
>> +       /* physical map length of vop register */
>> +       uint32_t len;
>> +
>> +       /* one time only one process allowed to config the register */
>> +       spinlock_t reg_lock;
>> +       /* lock vop irq reg */
>> +       spinlock_t irq_lock;
>> +
>> +       unsigned int irq;
>> +
>> +       /* vop AHP clk */
>> +       struct clk *hclk;
>> +       /* vop dclk */
>> +       struct clk *dclk;
>> +       /* vop share memory frequency */
>> +       struct clk *aclk;
>> +       uint32_t pixclock;
>> +
>> +       int pipe;
>> +       bool clk_on;
>> +};
>> +
>> +enum vop_data_format {
>> +       VOP_FMT_ARGB8888 =3D 0,
>> +       VOP_FMT_RGB888,
>> +       VOP_FMT_RGB565,
>> +       VOP_FMT_YUV420SP =3D 4,
>> +       VOP_FMT_YUV422SP,
>> +       VOP_FMT_YUV444SP,
>> +};
>> +
>> +struct vop_reg_data {
>> +       uint32_t offset;
>> +       uint32_t value;
>> +};
>> +
>> +struct vop_reg {
>> +       uint32_t offset;
>> +       uint32_t shift;
>> +       uint32_t mask;
>> +};
>> +
>> +struct vop_ctrl {
>> +       struct vop_reg standby;
>> +       struct vop_reg gate_en;
>> +       struct vop_reg mmu_en;
>> +       struct vop_reg rgb_en;
>> +       struct vop_reg edp_en;
>> +       struct vop_reg hdmi_en;
>> +       struct vop_reg mipi_en;
>> +       struct vop_reg out_mode;
>> +       struct vop_reg dither_down;
>> +       struct vop_reg dither_up;
>> +       struct vop_reg pin_pol;
>> +
>> +       struct vop_reg htotal_pw;
>> +       struct vop_reg hact_st_end;
>> +       struct vop_reg vtotal_pw;
>> +       struct vop_reg vact_st_end;
>> +       struct vop_reg hpost_st_end;
>> +       struct vop_reg vpost_st_end;
>> +};
>> +
>> +struct vop_win_phy {
>> +       const uint32_t *data_formats;
>> +       uint32_t nformats;
>> +
>> +       struct vop_reg enable;
>> +       struct vop_reg format;
>> +       struct vop_reg act_info;
>> +       struct vop_reg dsp_info;
>> +       struct vop_reg dsp_st;
>> +       struct vop_reg yrgb_mst;
>> +       struct vop_reg uv_mst;
>> +       struct vop_reg yrgb_vir;
>> +       struct vop_reg uv_vir;
>> +
>> +       struct vop_reg dst_alpha_ctl;
>> +       struct vop_reg src_alpha_ctl;
>> +};
>> +
>> +struct vop_win {
>> +       uint32_t base;
>> +       const struct vop_win_phy *phy;
>> +};
>> +
>> +struct vop_driver_data {
>> +       const void *init_table;
>> +       int table_size;
>> +       const struct vop_ctrl *ctrl;
>> +       const struct vop_win *win[VOP_MAX_WIN_SUPPORT];
>> +};
>> +
>> +static const uint32_t formats_01[] =3D {
>> +       DRM_FORMAT_XRGB8888,
>> +       DRM_FORMAT_ARGB8888,
>> +       DRM_FORMAT_RGB888,
>> +       DRM_FORMAT_RGB565,
>> +       DRM_FORMAT_NV12,
>> +       DRM_FORMAT_NV16,
>> +       DRM_FORMAT_NV24,
>> +};
>> +
>> +static const uint32_t formats_234[] =3D {
>> +       DRM_FORMAT_XRGB8888,
>> +       DRM_FORMAT_ARGB8888,
>> +       DRM_FORMAT_RGB888,
>> +       DRM_FORMAT_RGB565,
>> +};
>> +
>> +static const struct vop_win_phy win01_data =3D {
>> +       .data_formats =3D formats_01,
>> +       .nformats =3D ARRAY_SIZE(formats_01),
>> +       .enable =3D VOP_REG(WIN0_CTRL0, 0x1, 0),
>> +       .format =3D VOP_REG(WIN0_CTRL0, 0x7, 1),
>> +       .act_info =3D VOP_REG(WIN0_ACT_INFO, 0x1fff1fff, 0),
>> +       .dsp_info =3D VOP_REG(WIN0_DSP_INFO, 0x1fff1fff, 0),
>> +       .dsp_st =3D VOP_REG(WIN0_DSP_ST, 0x1fff1fff, 0),
>> +       .yrgb_mst =3D VOP_REG(WIN0_YRGB_MST, 0xffffffff, 0),
>> +       .uv_mst =3D VOP_REG(WIN0_CBR_MST, 0xffffffff, 0),
>> +       .yrgb_vir =3D VOP_REG(WIN0_VIR, 0x3fff, 0),
>> +       .uv_vir =3D VOP_REG(WIN0_VIR, 0x3fff, 16),
>> +       .src_alpha_ctl =3D VOP_REG(WIN0_SRC_ALPHA_CTRL, 0xff, 0),
>> +       .dst_alpha_ctl =3D VOP_REG(WIN0_DST_ALPHA_CTRL, 0xff, 0),
>> +};
>> +
>> +static const struct vop_win_phy win23_data =3D {
>> +       .data_formats =3D formats_234,
>> +       .nformats =3D ARRAY_SIZE(formats_234),
>> +       .enable =3D VOP_REG(WIN2_CTRL0, 0x1, 0),
>> +       .format =3D VOP_REG(WIN2_CTRL0, 0x7, 1),
>> +       .dsp_info =3D VOP_REG(WIN2_DSP_INFO0, 0x0fff0fff, 0),
>> +       .dsp_st =3D VOP_REG(WIN2_DSP_ST0, 0x1fff1fff, 0),
>> +       .yrgb_mst =3D VOP_REG(WIN2_MST0, 0xffffffff, 0),
>> +       .yrgb_vir =3D VOP_REG(WIN2_VIR0_1, 0x1fff, 0),
>> +       .src_alpha_ctl =3D VOP_REG(WIN2_SRC_ALPHA_CTRL, 0xff, 0),
>> +       .dst_alpha_ctl =3D VOP_REG(WIN2_DST_ALPHA_CTRL, 0xff, 0),
>> +};
>> +
>> +static const struct vop_win_phy cursor_data =3D {
>> +       .data_formats =3D formats_234,
>> +       .nformats =3D ARRAY_SIZE(formats_234),
>> +       .enable =3D VOP_REG(HWC_CTRL0, 0x1, 0),
>> +       .format =3D VOP_REG(HWC_CTRL0, 0x7, 1),
>> +       .dsp_st =3D VOP_REG(HWC_DSP_ST, 0x1fff1fff, 0),
>> +       .yrgb_mst =3D VOP_REG(HWC_MST, 0xffffffff, 0),
>> +};
>> +
>> +static const struct vop_win win0 =3D {
>> +       .base =3D 0,
>> +       .phy =3D &win01_data,
>> +};
>> +
>> +static const struct vop_win win1 =3D {
>> +       .base =3D 0x40,
>> +       .phy =3D &win01_data,
>> +};
>> +
>> +static const struct vop_win win2 =3D {
>> +       .base =3D 0,
>> +       .phy =3D &win23_data,
>> +};
>> +
>> +static const struct vop_win win3 =3D {
>> +       .base =3D 0x50,
>> +       .phy =3D &win23_data,
>> +};
>> +
>> +static const struct vop_win win_cursor =3D {
>> +       .base =3D 0,
>> +       .phy =3D &cursor_data,
>> +};
>> +
>> +static const struct vop_ctrl ctrl_data =3D {
>> +       .standby =3D VOP_REG(SYS_CTRL, 0x1, 22),
>> +       .gate_en =3D VOP_REG(SYS_CTRL, 0x1, 23),
>> +       .mmu_en =3D VOP_REG(SYS_CTRL, 0x1, 20),
>> +       .rgb_en =3D VOP_REG(SYS_CTRL, 0x1, 12),
>> +       .hdmi_en =3D VOP_REG(SYS_CTRL, 0x1, 13),
>> +       .edp_en =3D VOP_REG(SYS_CTRL, 0x1, 14),
>> +       .mipi_en =3D VOP_REG(SYS_CTRL, 0x1, 15),
>> +       .dither_down =3D VOP_REG(DSP_CTRL1, 0xf, 1),
>> +       .dither_up =3D VOP_REG(DSP_CTRL1, 0x1, 6),
>> +       .out_mode =3D VOP_REG(DSP_CTRL0, 0xf, 0),
>> +       .pin_pol =3D VOP_REG(DSP_CTRL0, 0xf, 4),
>> +       .htotal_pw =3D VOP_REG(DSP_HTOTAL_HS_END, 0x1fff1fff, 0),
>> +       .hact_st_end =3D VOP_REG(DSP_HACT_ST_END, 0x1fff1fff, 0),
>> +       .vtotal_pw =3D VOP_REG(DSP_VTOTAL_VS_END, 0x1fff1fff, 0),
>> +       .vact_st_end =3D VOP_REG(DSP_VACT_ST_END, 0x1fff1fff, 0),
>> +       .hpost_st_end =3D VOP_REG(POST_DSP_HACT_INFO, 0x1fff1fff, 0),
>> +       .vpost_st_end =3D VOP_REG(POST_DSP_VACT_INFO, 0x1fff1fff, 0),
>> +};
>> +
>> +static const struct vop_reg_data vop_init_reg_table[] =3D {
>> +       {SYS_CTRL, 0x00801000},
>> +       {DSP_CTRL0, 0x00000000},
>> +       {WIN0_CTRL0, 0x00000080},
>> +       {WIN1_CTRL0, 0x00000080},
>> +};
>> +
>> +static const struct vop_driver_data rockchip_rk3288_vop =3D {
>> +       .init_table =3D vop_init_reg_table,
>> +       .table_size =3D ARRAY_SIZE(vop_init_reg_table),
>> +       .ctrl =3D &ctrl_data,
>> +       .win[0] =3D &win0,
>> +       .win[1] =3D &win1,
>> +       .win[2] =3D &win2,
>> +       .win[3] =3D &win3,
>> +       .win[4] =3D &win_cursor,
>> +};
>> +
>> +static const struct of_device_id vop_driver_dt_match[] =3D {
>> +       { .compatible =3D "rockchip,rk3288-vop",
>> +         .data =3D (void *)&rockchip_rk3288_vop },
>> +       {},
>> +};
>> +
>> +static inline void vop_writel(struct vop_context *ctx,
>> +                             uint32_t offset, uint32_t v)
>> +{
>> +       writel(v, ctx->regs + offset);
>> +       ctx->regsbak[offset >> 2] =3D v;
>> +}
>> +
>> +static inline uint32_t vop_readl(struct vop_context *ctx, uint32_t of=
fset)
>> +{
>> +       return readl(ctx->regs + offset);
>> +}
>> +
>> +static inline void vop_cfg_done(struct vop_context *ctx)
>> +{
>> +       writel(0x01, ctx->regs + REG_CFG_DONE);
>> +}
>> +
>> +static inline void vop_mask_write(struct vop_context *ctx,
>> +                                 uint32_t offset, uint32_t mask, uint=
32_t v)
>> +{
>> +       if (mask) {
>> +               uint32_t cached_val =3D ctx->regsbak[offset >> 2];
>> +
>> +               cached_val =3D (cached_val & ~mask) | v;
>> +               writel(cached_val, ctx->regs + offset);
>> +               ctx->regsbak[offset >> 2] =3D cached_val;
>> +       }
>> +}
>> +
>> +static inline struct vop_driver_data *vop_get_driver_data(struct devi=
ce *dev)
>> +{
>> +       const struct of_device_id *of_id =3D
>> +                       of_match_device(vop_driver_dt_match, dev);
>> +
>> +       return (struct vop_driver_data *)of_id->data;
>> +}
>> +
>> +static enum vop_data_format vop_convert_format(uint32_t format)
>> +{
>> +       switch (format) {
>> +       case DRM_FORMAT_XRGB8888:
>> +       case DRM_FORMAT_ARGB8888:
>> +               return VOP_FMT_ARGB8888;
>> +       case DRM_FORMAT_RGB888:
>> +               return VOP_FMT_RGB888;
>> +       case DRM_FORMAT_RGB565:
>> +               return VOP_FMT_RGB565;
>> +       case DRM_FORMAT_NV12:
>> +               return VOP_FMT_YUV420SP;
>> +       case DRM_FORMAT_NV16:
>> +               return VOP_FMT_YUV422SP;
>> +       case DRM_FORMAT_NV24:
>> +               return VOP_FMT_YUV444SP;
>> +       default:
>> +               DRM_ERROR("unsupport format[%08x]\n", format);
>> +               return -EINVAL;
>> +       }
>> +}
>> +
>> +static bool is_alpha_support(uint32_t format)
>> +{
>> +       switch (format) {
>> +       case DRM_FORMAT_ARGB8888:
>> +               return true;
>> +       default:
>> +               return false;
>> +       }
>> +}
>> +
>> +/* TODO(djkurtz): move generic 'setup slave rk_iommu' code somewhere =
common */
>> +int vop_iommu_init(struct vop_context *ctx)
>> +{
>> +       struct device *dev =3D ctx->dev;
>> +       struct device_node *np =3D dev->of_node;
>> +       struct platform_device *pd;
>> +       int count;
>> +       int ret;
>> +       struct of_phandle_args args;
>> +
>> +       /* Each VOP must have exactly one iommu node, with no args */
>> +       count =3D of_count_phandle_with_args(np, "iommus", "#iommu-cel=
ls");
>> +       if (count !=3D 1) {
>> +               dev_err(dev, "of_count_phandle_with_args(%s) =3D> %d\n=
",
>> +                       np->full_name, count);
>> +               return -EINVAL;
>> +       }
>> +
>> +       ret =3D of_parse_phandle_with_args(np, "iommus", "#iommu-cells=
", 0,
>> +                                        &args);
>> +       if (ret) {
>> +               dev_err(dev, "of_parse_phandle_with_args(%s) =3D> %d\n=
",
>> +                       np->full_name, ret);
>> +               return ret;
>> +       }
>> +       if (args.args_count !=3D 0) {
>> +               dev_err(dev, "incorrect number of iommu params found f=
or %s (found %d, expected 0)\n",
>> +                       args.np->full_name, args.args_count);
>> +               return -EINVAL;
>> +       }
>> +
>> +       pd =3D of_find_device_by_node(args.np);
>> +       of_node_put(args.np);
>> +       if (!pd) {
>> +               dev_err(dev, "iommu %s not found\n", args.np->full_nam=
e);
>> +               return -EPROBE_DEFER;
>> +       }
>> +
>> +       /* TODO(djkurtz): handle multiple slave iommus for a single ma=
ster */
>> +       dev->archdata.iommu =3D &pd->dev;
>> +
>> +       ret =3D rockchip_drm_dma_attach_device(ctx->drm_dev, dev);
>> +       if (ret) {
>> +               dev_err(dev, "failed to attach to drm dma mapping, %d\=
n", ret);
>> +               return ret;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static void vop_iommu_fini(struct vop_context *ctx)
>> +{
>> +       rockchip_drm_dma_detach_device(ctx->drm_dev, ctx->dev);
>> +}
>> +
>> +static int rockchip_plane_get_size(int start, unsigned length, unsign=
ed last)
> This function can use some documentation to define the variables which =
are
> somewhat misleadingly named:
>    start:  starting pixel in screen coordinates
>    length: length of buffer "row" in pixels
>    end:    one pixel past end of buffer in screen coordinates
>    last:   width of screen, or one pixel past end of screen
>    size:   number of pixels of buffer to display on screen
>
>> +{
>> +       int end =3D start + length;
>> +       int size =3D 0;
>> +
>> +       if (start <=3D 0) {
>> +               if (end > 0)
>> +                       size =3D min_t(unsigned, end, last);
>> +       } else if (start <=3D last) {
>    start < last
>
> /* if (start =3D=3D last), we are starting 1 pixel past the end of the =
screen,
>     so no need to compute size :-), it will be 0. */
right, got it.
>> +               size =3D min_t(unsigned, last - start, length);
>> +       }
>> +
>> +       return size;
>> +}
>> +
>> +static int vop_clk_enable(struct vop_context *ctx)
>> +{
>> +       int ret;
>> +
>> +       if (!ctx->clk_on) {
>> +               ret =3D clk_prepare_enable(ctx->hclk);
> I saw a code review recently that suggested to do
> "clk_prepare/_unprepare()" in probe()/remove(), and just do
> clk_enable()/clk_disable() at runtime.
so , vop_clk_enable is called by probe() and runtime,
OK, I will change "clk_prepare/_unprepare()" / to=20
"clk_enable()/clk_disable()"
>> +               if (ret < 0) {
>> +                       dev_err(ctx->dev, "failed to enable hclk\n");
>> +                       return ret;
>> +               }
>> +
>> +               ret =3D clk_prepare_enable(ctx->dclk);
>> +               if (ret < 0) {
>> +                       dev_err(ctx->dev, "failed to enable dclk\n");
>> +                       goto err_dclk;
>> +               }
>> +
>> +               ret =3D clk_prepare_enable(ctx->aclk);
>> +               if (ret < 0) {
>> +                       dev_err(ctx->dev, "failed to enable aclk\n");
>> +                       goto err_aclk;
>> +               }
>> +               ctx->clk_on =3D true;
>> +       }
>> +
>> +       return ret;
>> +err_aclk:
>> +       clk_disable_unprepare(ctx->aclk);
> this should be dclk
Oh, yes, mistake...
>
>> +err_dclk:
>> +       clk_disable_unprepare(ctx->hclk);
>> +       return ret;
>> +}
>> +
>> +static void vop_clk_disable(struct vop_context *ctx)
>> +{
>> +       if (ctx->clk_on) {
>> +               clk_disable_unprepare(ctx->dclk);
>> +               clk_disable_unprepare(ctx->hclk);
>> +               clk_disable_unprepare(ctx->aclk);
> disable in inverse order from enable:
>
> aclk
> dclk
> hclk
OK.
>> +               ctx->clk_on =3D false;
>> +       }
>> +}
>> +
>> +static void vop_power_on(struct vop_context *ctx)
>> +{
>> +       if (vop_clk_enable(ctx) < 0) {
>> +               dev_err(ctx->dev, "failed to enable clks\n");
>> +               return;
>> +       }
>> +
>> +       spin_lock(&ctx->reg_lock);
>> +
>> +       VOP_CTRL_SET(ctx, standby, 0);
>> +
>> +       spin_unlock(&ctx->reg_lock);
>> +}
>> +
>> +static void vop_power_off(struct vop_context *ctx)
>> +{
>> +       spin_lock(&ctx->reg_lock);
>> +
>> +       VOP_CTRL_SET(ctx, standby, 1);
>> +
>> +       spin_unlock(&ctx->reg_lock);
>> +
>> +       vop_clk_disable(ctx);
>> +}
>> +
>> +static int rockchip_update_plane(struct drm_plane *plane, struct drm_=
crtc *crtc,
>> +                                struct drm_framebuffer *fb, int crtc_=
x,
>> +                                int crtc_y, unsigned int crtc_w,
>> +                                unsigned int crtc_h, uint32_t src_x,
>> +                                uint32_t src_y, uint32_t src_w, uint3=
2_t src_h)
>> +{
>> +       struct rockchip_plane *rockchip_plane =3D to_rockchip_plane(pl=
ane);
>> +       const struct vop_win *win =3D rockchip_plane->win;
>> +       struct vop_context *ctx =3D to_vop_ctx(crtc);
>> +       struct drm_gem_object *obj;
>> +       struct rockchip_gem_object *rk_obj;
>> +       unsigned long offset;
>> +       unsigned int actual_w;
>> +       unsigned int actual_h;
>> +       unsigned int dsp_stx;
>> +       unsigned int dsp_sty;
>> +       unsigned int y_vir_stride;
>> +       dma_addr_t yrgb_mst;
>> +       enum vop_data_format format;
>> +       uint32_t val;
>> +       bool is_alpha;
>> +
>> +       if (!win) {
>> +               DRM_ERROR("can't find win data for vop, failed\n");
>> +               return -EINVAL;
>> +       }
> There should be no need for this error checking.
right, rockchip_plane always has a vop_win, no need check here, I will=20
remove the check.
>> +
>> +       obj =3D rockchip_fb_get_gem_obj(fb, 0);
>> +       if (!obj) {
>> +               DRM_ERROR("fail to get rockchip gem object from frameb=
uffer\n");
>> +               return -EINVAL;
>> +       }
> Nor this.
>
>> +
>> +       rk_obj =3D to_rockchip_obj(obj);
>> +
>> +       yrgb_mst =3D rk_obj->dma_addr;
>> +       if (yrgb_mst <=3D 0)
>> +               return -ENOMEM;
> Nor this:
> I don't think dma_addr_t can be less than 0.
> Also, dma_addr_t =3D=3D 0 could be a valid iova.
right.
> src_* are actually 16.16 fixed point 'subpixel' units, but crtc_x is in=
 pixels.
>
> However, since you aren't implementing sub-pixel positioning, you can d=
o:
>
>   if (src_x & 0xffff || src_y & 0xffff || src_w & 0xffff || src_h & 0xf=
fff)
>      return -EINVAL;
>
> And, since you aren't implementing plane scaling:
>
>   src_w >>=3D 16;
>   src_h >>=3D 16;
>   src_x >>=3D 16;
>   src_y >>=3D 16;
>
>   if (crtc_w !=3D src_w || crtc_h !=3D src_h)
>     return -EINVAL;
OK, got it.
>> +
>> +       actual_w =3D rockchip_plane_get_size(crtc_x,
>> +                                          crtc_w, crtc->mode.hdisplay=
);
>> +       actual_h =3D rockchip_plane_get_size(crtc_y,
>> +                                          crtc_h, crtc->mode.vdisplay=
);
> crtc_w and crtc_h seem to imply the width & height of the crtc, but
> really they are they are
> desired width and height of the framebuffer in crtc pixel units.
>
> actual_w and actual_h are the number of pixels of this framebuffer that=
 will
> actually be shown on the crtc.  What happens if one of them is 0?  Perh=
aps we
> should just return -EINVAL.  Otherwise you might compute -1 below when =
setting
> act_info/dsp_info, and end up programming a very large number.
correct, got it.
>> +       if (crtc_x < 0) {
>> +               if (actual_w)
>> +                       src_x -=3D crtc_x;
>> +               crtc_x =3D 0;
>> +       }
>> +
>> +       if (crtc_y < 0) {
>> +               if (actual_h)
>> +                       src_y -=3D crtc_y;
>> +               crtc_y =3D 0;
>> +       }
>> +
>> +       dsp_stx =3D crtc_x + crtc->mode.htotal - crtc->mode.hsync_star=
t;
>> +       dsp_sty =3D crtc_y + crtc->mode.vtotal - crtc->mode.vsync_star=
t;
> The additions herer are because you have the vblank at the beginning
> of the frame.
> Can you simplify this by moving vblank to the end of the frame? (see be=
low)
>
>> +
>> +       offset =3D src_x * (fb->bits_per_pixel >> 3);
>> +       offset +=3D src_y * fb->pitches[0];
>> +
>> +       y_vir_stride =3D fb->pitches[0] / (fb->bits_per_pixel >> 3);
>> +       is_alpha =3D is_alpha_support(fb->pixel_format);
>> +       format =3D vop_convert_format(fb->pixel_format);
> This function would return < 0 if the format not supported. Check this =
earlier.
> Although, it should not be possible to get an invalid format, since it =
is
> already verified by drm core.
OK. got it.
>> +
>> +       spin_lock(&ctx->reg_lock);
>> +
>> +       VOP_WIN_SET(ctx, win, format, format);
>> +       VOP_WIN_SET(ctx, win, yrgb_vir, y_vir_stride);
>> +       yrgb_mst +=3D offset;
>> +       VOP_WIN_SET(ctx, win, yrgb_mst, yrgb_mst);
>> +       VOP_WIN_SET(ctx, win, act_info,
>> +                   ((actual_h - 1) << 16) | (actual_w - 1));
> Nit: You should probably be masking the individual h/w fields to 13-bit=
s each
> before or'ing them together.
> Same with dsp_st.
OK, got it.
>> +       VOP_WIN_SET(ctx, win, dsp_info,
>> +                   ((actual_h - 1) << 16) | (actual_w - 1));
>> +       VOP_WIN_SET(ctx, win, dsp_st, (dsp_sty << 16) | dsp_stx);
>> +       if (is_alpha) {
>> +               VOP_WIN_SET(ctx, win, dst_alpha_ctl,
>> +                           DST_FACTOR_M0(ALPHA_SRC_INVERSE));
>> +               val =3D SRC_ALPHA_EN(1) | SRC_COLOR_M0(ALPHA_SRC_PRE_M=
UL) |
>> +                       SRC_ALPHA_M0(ALPHA_STRAIGHT) |
>> +                       SRC_BLEND_M0(ALPHA_PER_PIX) |
>> +                       SRC_ALPHA_CAL_M0(ALPHA_NO_SATURATION) |
>> +                       SRC_FACTOR_M0(ALPHA_ONE);
>> +               VOP_WIN_SET(ctx, win, src_alpha_ctl, val);
>> +       } else {
>> +               VOP_WIN_SET(ctx, win, src_alpha_ctl, SRC_ALPHA_EN(0));
>> +       }
>> +
>> +       VOP_WIN_SET(ctx, win, enable, 1);
>> +
>> +       spin_unlock(&ctx->reg_lock);
>> +
>> +       mutex_lock(&ctx->vsync_mutex);
>> +
>> +       /*
>> +        * Because the buffer set to vop take effect at frame start ti=
me,
>> +        * we need make sure old buffer is not in use before we releas=
e
>> +        * it.
>> +        * reference the framebuffer, and unference it when it swap ou=
t of vop.
>> +        */
>> +       if (fb !=3D rockchip_plane->front_fb) {
>> +               drm_framebuffer_reference(fb);
>> +               rockchip_plane->pending_fb =3D fb;
>> +               rockchip_plane->pending_yrgb_mst =3D yrgb_mst;
>> +               ctx->vsync_work_pending =3D true;
>> +       }
>> +       rockchip_plane->enabled =3D true;
>> +
>> +       mutex_unlock(&ctx->vsync_mutex);
>> +
>> +       spin_lock(&ctx->reg_lock);
>> +       vop_cfg_done(ctx);
>> +       spin_unlock(&ctx->reg_lock);
>> +
>> +       return 0;
>> +}
>> +
>> +static int rockchip_disable_plane(struct drm_plane *plane)
>> +{
>> +       struct rockchip_plane *rockchip_plane =3D to_rockchip_plane(pl=
ane);
>> +       struct vop_context *ctx =3D rockchip_plane->ctx;
>> +       const struct vop_win *win =3D rockchip_plane->win;
>> +
>> +       spin_lock(&ctx->reg_lock);
>> +
>> +       VOP_WIN_SET(ctx, win, enable, 0);
>> +       vop_cfg_done(ctx);
>> +
>> +       spin_unlock(&ctx->reg_lock);
>> +
>> +       mutex_lock(&ctx->vsync_mutex);
>> +
>> +       /*
>> +       * clear the pending framebuffer and set vsync_work_pending tru=
e,
>> +       * so that the framebuffer will unref at the next vblank.
>> +       */
>> +       if (rockchip_plane->pending_fb) {
>> +               drm_framebuffer_unreference(rockchip_plane->pending_fb=
);
>> +               rockchip_plane->pending_fb =3D NULL;
>> +       }
>> +
>> +       rockchip_plane->enabled =3D false;
>> +       ctx->vsync_work_pending =3D true;
>> +
>> +       mutex_unlock(&ctx->vsync_mutex);
>> +
>> +       return 0;
>> +}
>> +
>> +static void rockchip_plane_destroy(struct drm_plane *plane)
>> +{
>> +       struct rockchip_plane *rockchip_plane =3D to_rockchip_plane(pl=
ane);
>> +       struct vop_context *ctx =3D rockchip_plane->ctx;
>> +
>> +       rockchip_disable_plane(plane);
>> +       drm_plane_cleanup(plane);
>> +       ctx->win_mask &=3D ~(1 << rockchip_plane->id);
>> +       kfree(rockchip_plane);
>> +}
>> +
>> +static const struct drm_plane_funcs rockchip_plane_funcs =3D {
>> +       .update_plane =3D rockchip_update_plane,
>> +       .disable_plane =3D rockchip_disable_plane,
>> +       .destroy =3D rockchip_plane_destroy,
>> +};
>> +
>> +struct drm_plane *rockchip_plane_init(struct vop_context *ctx,
>> +                                     unsigned long possible_crtcs,
>> +                                     enum drm_plane_type type)
>> +{
>> +       struct rockchip_plane *rockchip_plane;
>> +       struct vop_driver_data *vop_data =3D ctx->data;
>> +       const struct vop_win *win;
>> +       int i;
>> +       int err;
>> +
>> +       rockchip_plane =3D kzalloc(sizeof(*rockchip_plane), GFP_KERNEL=
);
>> +       if (!rockchip_plane)
>> +               return NULL;
> Let's propagate errors from this function, like this...
>
> return ERR_PTR(-ENOMEM);
OK.
>> +
>> +       for (i =3D 0; i < VOP_MAX_WIN_SUPPORT; i++) {
>> +               if (!(ctx->win_mask & (1 << i))) {
>> +                       win =3D vop_data->win[i];
>> +                       break;
>> +               }
>> +       }
> The caller already knows for which window index they are init'ing the p=
lane.
> Just have the caller pass it in.
OK.
>> +
>> +       if (VOP_MAX_WIN_SUPPORT =3D=3D i) {
>> +               DRM_ERROR("failed to find win\n");
>> +               kfree(rockchip_plane);
>> +               return NULL;
>> +       }
>> +
>> +       ctx->win_mask |=3D (1 << i);
>> +       rockchip_plane->id =3D i;
>> +       rockchip_plane->win =3D win;
>> +       rockchip_plane->ctx =3D ctx;
>> +
>> +       err =3D drm_universal_plane_init(ctx->drm_dev, &rockchip_plane=
->base,
>> +                                      possible_crtcs, &rockchip_plane=
_funcs,
>> +                                      win->phy->data_formats,
>> +                                      win->phy->nformats, type);
>> +       if (err) {
>> +               DRM_ERROR("failed to initialize plane\n");
>> +               kfree(rockchip_plane);
>> +               return NULL;
> return ERR_PTR(err);
OK.
>> +       }
>> +
>> +       return &rockchip_plane->base;
>> +}
>> +
>> +int rockchip_drm_crtc_enable_vblank(struct drm_device *dev, int pipe)
>> +{
>> +       struct vop_context *ctx =3D to_vop_ctx(rockchip_find_crtc(dev,=
 pipe));
>> +       unsigned long flags;
>> +
>> +       if (ctx->dpms !=3D DRM_MODE_DPMS_ON)
>> +               return -EPERM;
>> +
>> +       spin_lock_irqsave(&ctx->irq_lock, flags);
>> +
>> +       vop_mask_write(ctx, INTR_CTRL0, LINE_FLAG_INTR_MASK,
>> +                      LINE_FLAG_INTR_EN(1));
>> +
>> +       spin_unlock_irqrestore(&ctx->irq_lock, flags);
>> +
>> +       return 0;
>> +}
>> +
>> +void rockchip_drm_crtc_disable_vblank(struct drm_device *dev, int pip=
e)
>> +{
>> +       struct vop_context *ctx =3D to_vop_ctx(rockchip_find_crtc(dev,=
 pipe));
>> +       unsigned long flags;
>> +
>> +       if (ctx->dpms !=3D DRM_MODE_DPMS_ON)
>> +               return;
>> +       spin_lock_irqsave(&ctx->irq_lock, flags);
>> +       vop_mask_write(ctx, INTR_CTRL0, LINE_FLAG_INTR_MASK,
>> +                      LINE_FLAG_INTR_EN(0));
>> +       spin_unlock_irqrestore(&ctx->irq_lock, flags);
>> +}
>> +
>> +static void rockchip_drm_crtc_dpms(struct drm_crtc *crtc, int mode)
>> +{
>> +       struct vop_context *ctx =3D to_vop_ctx(crtc);
>> +
>> +       DRM_DEBUG_KMS("crtc[%d] mode[%d]\n", crtc->base.id, mode);
>> +
>> +       if (ctx->dpms =3D=3D mode) {
>> +               DRM_DEBUG_KMS("desired dpms mode is same as previous o=
ne.\n");
>> +               return;
>> +       }
>> +       if (mode > DRM_MODE_DPMS_ON) {
>> +               /* wait for the completion of page flip. */
>> +               if (!wait_event_timeout(ctx->wait_vsync_queue,
>> +                                       !atomic_read(&ctx->wait_vsync_=
event),
>> +                                       HZ/20))
>> +                       DRM_DEBUG_KMS("vblank wait timed out.\n");
>> +               drm_vblank_off(crtc->dev, ctx->pipe);
>> +       }
>> +
>> +       switch (mode) {
>> +       case DRM_MODE_DPMS_ON:
>> +               vop_power_on(ctx);
>> +               break;
>> +       case DRM_MODE_DPMS_STANDBY:
>> +       case DRM_MODE_DPMS_SUSPEND:
>> +       case DRM_MODE_DPMS_OFF:
>> +               vop_power_off(ctx);
>> +               break;
>> +       default:
>> +               DRM_DEBUG_KMS("unspecified mode %d\n", mode);
>> +               break;
>> +       }
>> +
>> +       ctx->dpms =3D mode;
>> +}
>> +
>> +static void rockchip_drm_crtc_prepare(struct drm_crtc *crtc)
>> +{
>> +       rockchip_drm_crtc_dpms(crtc, DRM_MODE_DPMS_ON);
>> +}
>> +
>> +static bool rockchip_drm_crtc_mode_fixup(struct drm_crtc *crtc,
>> +                                        const struct drm_display_mode=
 *mode,
>> +                                        struct drm_display_mode *adju=
sted_mode)
>> +{
>> +       /* just do dummy now */
>> +
>> +       return true;
>> +}
>> +
>> +static int rockchip_drm_crtc_mode_set_base(struct drm_crtc *crtc, int=
 x, int y,
>> +                                          struct drm_framebuffer *old=
_fb);
>> +
>> +static int rockchip_drm_crtc_mode_set(struct drm_crtc *crtc,
>> +                                     struct drm_display_mode *mode,
>> +                                     struct drm_display_mode *adjuste=
d_mode,
>> +                                     int x, int y,
>> +                                     struct drm_framebuffer *fb)
>> +{
>> +       struct vop_context *ctx =3D to_vop_ctx(crtc);
>> +       u16 hsync_len =3D adjusted_mode->hsync_end - adjusted_mode->hs=
ync_start;
>> +       u16 left_margin =3D adjusted_mode->htotal - adjusted_mode->hsy=
nc_end;
>> +       u16 vsync_len =3D adjusted_mode->vsync_end - adjusted_mode->vs=
ync_start;
>> +       u16 upper_margin =3D adjusted_mode->vtotal - adjusted_mode->vs=
ync_end;
> This moves the vblank/hblank to the front of the frame rather than the =
end.
> Is that necessary on this hardware?
> If you leave the active area origin at (0,0), it makes it a little bit =
simpler
> to locate overlays.
in fact, the hardware define is different with drm_display_mode define:
drm_display_mode define that:

              Active                 Front           Sync           Back
              Region                 Porch                          Porch
     <-----------------------><----------------><-------------><---------=
----->

       //////////////////////|
      ////////////////////// |
     //////////////////////  |..................               ..........=
......
                                                _______________

     <----- [hv]display ----->
     <------------- [hv]sync_start ------------>
     <--------------------- [hv]sync_end --------------------->
     <-------------------------------- [hv]total ------------------------=
----->

but vop hardware define is that:

       Sync          Back              Active                 Front
                     Porch              Region                 Porch
     <-----------><-------------><--------------------><-------------->

                                |//////////////////////|
                                |//////////////////////|
                  ..............|//////////////////////|...............
     |____________|

     <-dsp_hs_end->
     <------ dsp_hact_st------->
     <----------------dsp_hact_end-------------------->
     <-------------------------------- dsp_hact_end-------------------->

So, we need to convert the setting.
>> +       u16 hdisplay =3D adjusted_mode->hdisplay;
>> +       u16 vdisplay =3D adjusted_mode->vdisplay;
>> +       u16 htotal =3D adjusted_mode->htotal;
>> +       u16 vtotal =3D adjusted_mode->vtotal;
>> +       struct rockchip_display_mode *priv_mode =3D
>> +                                       (void *)adjusted_mode->private=
;
>> +       unsigned long flags;
>> +       int ret;
>> +       uint32_t val;
>> +
>> +       /* nothing to do if we haven't set the mode yet */
>> +       if (adjusted_mode->htotal =3D=3D 0 || adjusted_mode->vtotal =3D=
=3D 0)
>> +               return -EINVAL;
> How is it possible to be given a mode with htotal or vtotal =3D=3D 0?
> How could we be doing a mode set without a mode to set?
> Can you do these verification checks to mode_fixup() instead?
OK, I will move it to mode_fixup().
>> +
>> +       if (!priv_mode) {
>> +               DRM_ERROR("fail to found display output type[%d]\n",
>> +                         priv_mode->out_type);
>> +               return -EINVAL;
>> +       }
>> +
>> +       ret =3D rockchip_drm_crtc_mode_set_base(crtc, x, y, fb);
>> +       if (ret)
>> +               return ret;
>> +
>> +       switch (priv_mode->out_type) {
>> +       case ROCKCHIP_DISPLAY_TYPE_RGB:
>> +       case ROCKCHIP_DISPLAY_TYPE_LVDS:
>> +               VOP_CTRL_SET(ctx, rgb_en, 1);
>> +               VOP_CTRL_SET(ctx, out_mode, ROCKCHIP_OUTFACE_P888);
>> +               break;
>> +       case ROCKCHIP_DISPLAY_TYPE_EDP:
>> +               VOP_CTRL_SET(ctx, edp_en, 1);
>> +               VOP_CTRL_SET(ctx, out_mode, ROCKCHIP_OUTFACE_AAAA);
>> +               break;
>> +       case ROCKCHIP_DISPLAY_TYPE_HDMI:
>> +               VOP_CTRL_SET(ctx, out_mode, ROCKCHIP_OUTFACE_AAAA);
>> +               VOP_CTRL_SET(ctx, hdmi_en, 1);
>> +               break;
>> +       default:
>> +               DRM_ERROR("unsupport out type[%d]\n", priv_mode->out_t=
ype);
>> +               return -EINVAL;
>> +       };
> This switch is directing the vop output to a particular output (edp,
> lvds, hdmi, etc)
> based on a private field added to the drm_display_mode by the down-pipe=
 encoder.
> However, on other hardware, it is possible to drive multiple outputs
> from the same crtc.
> This is a useful feature, for mirroring one framebuffer to multiple dis=
plays.
>
> Is that possible for rk3288 too?
> It looks like it should be possible to set multiple rgb_en, edp_en, hdm=
i_en, etc
> bits at the same time.
>
> If so, then we can't really make the encoder selection part of the mode=
.
> Instead, what we can try to do is implement this output selection step =
by
> providing a helper function from the vop for the encoders to call in th=
eir own
> mode_set() callback.
>
> Also, vop can expose another helper for allowing the encoder to select =
the vop
> pixel output format that it requires (ie, LVDS panel encoder can select=
 565).
OK, I would provide a helper function for encoders to call instead of=20
using drm_display_mode private.
>> +
>> +       val =3D 0x8;
>> +       val |=3D (adjusted_mode->flags & DRM_MODE_FLAG_NHSYNC) ? 1 : 0=
;
>> +       val |=3D (adjusted_mode->flags & DRM_MODE_FLAG_NVSYNC) ? (1 <<=
 1) : 0;
>> +       VOP_CTRL_SET(ctx, pin_pol, val);
>> +
>> +       VOP_CTRL_SET(ctx, htotal_pw, (htotal << 16) | hsync_len);
>> +       val =3D (hsync_len + left_margin) << 16;
>> +       val |=3D hsync_len + left_margin + hdisplay;
>> +       VOP_CTRL_SET(ctx, hact_st_end, val);
>> +       VOP_CTRL_SET(ctx, hpost_st_end, val);
>> +
>> +       VOP_CTRL_SET(ctx, vtotal_pw, (vtotal << 16) | vsync_len);
>> +       val =3D (vsync_len + upper_margin) << 16;
>> +       val |=3D vsync_len + upper_margin + vdisplay;
>> +       VOP_CTRL_SET(ctx, vact_st_end, val);
>> +       VOP_CTRL_SET(ctx, vpost_st_end, val);
>> +
>> +       spin_lock_irqsave(&ctx->irq_lock, flags);
>> +
>> +       vop_mask_write(ctx, INTR_CTRL0, DSP_LINE_NUM_MASK,
>> +                      DSP_LINE_NUM(vsync_len + upper_margin + vdispla=
y));
>> +
>> +       spin_unlock_irqrestore(&ctx->irq_lock, flags);
>> +
>> +       clk_set_rate(ctx->dclk, adjusted_mode->clock * 1000);
> When we are changing modes, can we just change the dclk like this while=
 a
> previous frame is already being scanned out using the old clock?
> Shouldn't we synchronize changing clocks:
>
>   - schedule any current scanout to stop at next vblank
>   - wait for that vblank
>   - disable clock
>   - program new mode
>   - program new framebuffer(s) to match that new mode.
>   - start clock
>
> Or maybe like what you do in initial before turning on the iommu:
>
>    - disable dclk
>    - do a dclk & ahb reset
>    - program new mode
>    - program new fb(s)
>    - enable dclk.
right, and there is another problem:
all mode config will take effect at frame start, and at runtime, frame=20
start event maybe happen at any  place
when setting mode config:
      VOP_CTRL_SET(ctx, htotal_pw, (htotal << 16) | hsync_len);
       ----> frame start
      VOP_CTRL_SET(ctx, hact_st_end, val);
      then htotal_pw take effect, but hact_st_end should wait for next=20
frame start, so we got a wrong frame.

so I want to change it like your advices :
mode_set:
- disable dclk
- program new fb(s)
- program new mode
- do a dclk reset, reset the frame scan point to the beginning, then all=20
setting will take effect.
- dclk set rate.
- enable dclk
>> +
>> +       return 0;
>> +}
>> +
>> +static int rockchip_drm_crtc_mode_set_base(struct drm_crtc *crtc, int=
 x, int y,
>> +                                          struct drm_framebuffer *old=
_fb)
>> +{
>> +       unsigned int crtc_w;
>> +       unsigned int crtc_h;
>> +       int ret;
>> +
>> +       crtc_w =3D crtc->primary->fb->width - crtc->x;
>> +       crtc_h =3D crtc->primary->fb->height - crtc->y;
>> +
>> +       ret =3D rockchip_update_plane(crtc->primary, crtc, crtc->prima=
ry->fb, 0,
>> +                                   0, crtc_w, crtc_h, crtc->x, crtc->=
y, crtc_w,
>> +                                   crtc_h);
>
> rockchip_update_plane expects its src_x, src_y, src_h, src_w to be in 1=
6.16
> 'sub-pixel' units, so you need to << 16 the last 4 parameters here.
>
> It might be more convenient to split rockchip_update_plane() into two f=
unctions:
>   (1) rockchip_update_plane() which takes 16.16 src_ and is used for th=
e
>      drm_plane_funcs.update_plane.  This function converts src_* from 1=
6.16 to
>      pixels, and then calls:
>   (2) a helper function which just takes src_ in whole pixel units.  Th=
e helper
>      function you can call from rockchip_drm_crtc_mode_set_base() and
>      rockchip_drm_crtc_page_flip().  In fact, since we do not support s=
caling,
>      the helper probably does not even need src_w and src_h arguments.
OK, Got it.
>> +       if (ret < 0) {
>> +               DRM_ERROR("fail to update plane\n");
>> +               return -EINVAL;
> return ret;
OK.
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static void rockchip_drm_crtc_commit(struct drm_crtc *crtc)
>> +{
>> +       /* just do dummy now */
>> +}
>> +
>> +static const struct drm_crtc_helper_funcs rockchip_crtc_helper_funcs =
=3D {
>> +       .dpms =3D rockchip_drm_crtc_dpms,
>> +       .prepare =3D rockchip_drm_crtc_prepare,
>> +       .mode_fixup =3D rockchip_drm_crtc_mode_fixup,
>> +       .mode_set =3D rockchip_drm_crtc_mode_set,
>> +       .mode_set_base =3D rockchip_drm_crtc_mode_set_base,
>> +       .commit =3D rockchip_drm_crtc_commit,
>> +};
>> +
>> +static int rockchip_drm_crtc_page_flip(struct drm_crtc *crtc,
>> +                                      struct drm_framebuffer *fb,
>> +                                      struct drm_pending_vblank_event=
 *event,
>> +                                      uint32_t page_flip_flags)
>> +{
>> +       struct drm_device *dev =3D crtc->dev;
>> +       struct vop_context *ctx =3D to_vop_ctx(crtc);
>> +       struct drm_framebuffer *old_fb =3D crtc->primary->fb;
>> +       unsigned int crtc_w;
>> +       unsigned int crtc_h;
>> +       int ret;
>> +
>> +       /* when the page flip is requested, crtc's dpms should be on *=
/
>> +       if (ctx->dpms > DRM_MODE_DPMS_ON) {
>> +               DRM_DEBUG("failed page flip request at dpms[%d].\n", c=
tx->dpms);
>> +               return 0;
>> +       }
>> +
>> +       ret =3D drm_vblank_get(dev, ctx->pipe);
>> +       if (ret) {
>> +               DRM_DEBUG("failed to acquire vblank counter\n");
>> +               return ret;
>> +       }
>> +
>> +       spin_lock_irq(&dev->event_lock);
>> +       if (ctx->event) {
>> +               spin_unlock_irq(&dev->event_lock);
>> +               DRM_ERROR("already pending flip!\n");
>> +               return -EBUSY;
>> +       }
>> +       ctx->event =3D event;
>> +       atomic_set(&ctx->wait_vsync_event, 1);
>> +       spin_unlock_irq(&dev->event_lock);
>> +
>> +       crtc->primary->fb =3D fb;
>> +       crtc_w =3D crtc->primary->fb->width - crtc->x;
>> +       crtc_h =3D crtc->primary->fb->height - crtc->y;
>> +
>> +       ret =3D rockchip_update_plane(crtc->primary, crtc, fb, 0, 0, c=
rtc_w,
>> +                                   crtc_h, crtc->x, crtc->y, crtc_w, =
crtc_h);
>> +       if (ret) {
>> +               crtc->primary->fb =3D old_fb;
>> +
>> +               spin_lock_irq(&dev->event_lock);
>> +               drm_vblank_put(dev, ctx->pipe);
>> +               atomic_set(&ctx->wait_vsync_event, 0);
>> +               ctx->event =3D NULL;
>> +               spin_unlock_irq(&dev->event_lock);
>> +       }
>> +
>> +       return ret;
>> +}
>> +
>> +void rockchip_drm_crtc_finish_pageflip(struct drm_device *dev, int pi=
pe)
>> +{
>> +       struct rockchip_drm_private *dev_priv =3D dev->dev_private;
>> +       struct drm_crtc *drm_crtc =3D dev_priv->crtc[pipe];
>> +       struct vop_context *ctx;
>> +       unsigned long flags;
>> +
>> +       if (!drm_crtc)
>> +               return;
> Can you add a comment describing when this can happen?
nothing would happen, I think drm_crtc would not be NULL, I will just=20
remove it.
>> +
>> +       ctx =3D to_vop_ctx(drm_crtc);
>> +
>> +       spin_lock_irqsave(&dev->event_lock, flags);
>> +
>> +       if (ctx->event) {
>> +               drm_send_vblank_event(dev, -1, ctx->event);
>> +               drm_vblank_put(dev, pipe);
>> +               atomic_set(&ctx->wait_vsync_event, 0);
>> +               wake_up(&ctx->wait_vsync_queue);
>> +               ctx->event =3D NULL;
>> +       }
>> +
>> +       spin_unlock_irqrestore(&dev->event_lock, flags);
>> +}
>> +
>> +void rockchip_drm_crtc_cancel_pending_flip(struct drm_device *dev)
>> +{
>> +       int i;
>> +
>> +       for (i =3D 0; i < dev->num_crtcs; i++)
>> +               rockchip_drm_crtc_finish_pageflip(dev, i);
>> +}
>> +
>> +static void rockchip_drm_crtc_destroy(struct drm_crtc *crtc)
>> +{
>> +       struct vop_context *ctx =3D to_vop_ctx(crtc);
>> +       struct rockchip_drm_private *private =3D crtc->dev->dev_privat=
e;
>> +
>> +       private->crtc[ctx->pipe] =3D NULL;
>> +       drm_crtc_cleanup(crtc);
>> +}
>> +
>> +static const struct drm_crtc_funcs rockchip_crtc_funcs =3D {
>> +       .set_config =3D drm_crtc_helper_set_config,
>> +       .page_flip =3D rockchip_drm_crtc_page_flip,
>> +       .destroy =3D rockchip_drm_crtc_destroy,
>> +};
>> +
>> +static void rockchip_vsync_worker(struct work_struct *work)
>> +{
>> +       struct vop_context *ctx =3D container_of(work, struct vop_cont=
ext,
>> +                                              vsync_work);
>> +       struct drm_device *drm =3D ctx->drm_dev;
>> +       struct rockchip_drm_private *dev_priv =3D drm->dev_private;
>> +       struct drm_crtc *crtc =3D dev_priv->crtc[ctx->pipe];
>> +       struct rockchip_plane *rockchip_plane;
>> +       struct drm_plane *plane;
>> +       uint32_t yrgb_mst;
>> +
>> +       mutex_lock(&ctx->vsync_mutex);
>> +
>> +       ctx->vsync_work_pending =3D false;
>> +
>> +       list_for_each_entry(plane, &drm->mode_config.plane_list, head)=
 {
>> +               rockchip_plane =3D to_rockchip_plane(plane);
>> +
>> +               if (rockchip_plane->ctx !=3D ctx)
>> +                       continue;
>> +               if (rockchip_plane->enabled && !rockchip_plane->pendin=
g_fb)
>> +                       continue;
>> +               if (!rockchip_plane->enabled && !rockchip_plane->front=
_fb)
>> +                       continue;
>> +               /*
>> +                * make sure the yrgb_mst take effect, so that
>> +                * we can unreference the old framebuffer.
>> +                */
>> +               yrgb_mst =3D VOP_WIN_GET_YRGBADDR(ctx, rockchip_plane-=
>win);
>> +               if (rockchip_plane->pending_yrgb_mst !=3D yrgb_mst) {
>> +                       /*
>> +                        * some plane no complete, unref at next vblan=
k
>> +                        */
>> +                       ctx->vsync_work_pending =3D true;
>> +                       continue;
>> +               }
>> +
>> +               /*
>> +                * drm_framebuffer_unreference maybe call iommu unmap,
>> +                * and iommu not allow unmap buffer at irq context,
>> +                * so we do drm_framebuffer_unreference at queue_work.
>> +                */
>> +               if (rockchip_plane->front_fb)
>> +                       drm_framebuffer_unreference(rockchip_plane->fr=
ont_fb);
>> +
>> +               rockchip_plane->front_fb =3D rockchip_plane->pending_f=
b;
>> +               rockchip_plane->pending_fb =3D NULL;
>> +
>> +               /*
>> +                * if primary plane flip complete, sending the event t=
o
>> +                * userspace
>> +                */
>> +               if (&rockchip_plane->base =3D=3D crtc->primary)
>> +                       rockchip_drm_crtc_finish_pageflip(ctx->drm_dev=
,
>> +                                                         ctx->pipe);
>> +       }
>> +
>> +       mutex_unlock(&ctx->vsync_mutex);
>> +}
>> +
>> +static irqreturn_t rockchip_vop_isr(int irq, void *data)
>> +{
>> +       struct vop_context *ctx =3D data;
>> +       uint32_t intr0_reg;
>> +       unsigned long flags;
>> +
>> +       intr0_reg =3D vop_readl(ctx, INTR_CTRL0);
>> +       if (intr0_reg & LINE_FLAG_INTR) {
>> +               spin_lock_irqsave(&ctx->irq_lock, flags);
>> +               vop_writel(ctx, INTR_CTRL0, intr0_reg | LINE_FLAG_INTR=
_CLR);
>> +               spin_unlock_irqrestore(&ctx->irq_lock, flags);
>> +       } else {
>> +               return IRQ_NONE;
>> +       }
>> +
>> +       drm_handle_vblank(ctx->drm_dev, ctx->pipe);
>> +       if (ctx->vsync_work_pending)
>> +               queue_work(ctx->vsync_wq, &ctx->vsync_work);
>> +
>> +       return IRQ_HANDLED;
>> +}
>> +
>> +static int vop_create_crtc(struct vop_context *ctx)
>> +{
>> +       struct device *dev =3D ctx->dev;
>> +       struct drm_device *drm_dev =3D ctx->drm_dev;
>> +       struct drm_plane *primary, *cursor;
>> +       unsigned long possible_crtcs;
>> +       struct drm_crtc *crtc;
>> +       int ret;
>> +       int nr;
>> +
>> +       ctx->win_mask =3D 0;
>> +       crtc =3D &ctx->crtc;
>> +
>> +       ret =3D rockchip_drm_add_crtc(drm_dev, crtc, dev->of_node);
>> +       if (ret < 0)
>> +               return ret;
>> +       ctx->pipe =3D ret;
>> +
>> +       possible_crtcs =3D (1 << ctx->pipe);
>> +
>> +       primary =3D rockchip_plane_init(ctx, possible_crtcs,
>> +                                     DRM_PLANE_TYPE_PRIMARY);
>> +       if (!primary) {
>> +               DRM_ERROR("fail to init primary plane\n");
>> +               return -EINVAL;
>> +       }
>> +
>> +       for (nr =3D 1; nr < ROCKCHIP_MAX_PLANE; nr++) {
>> +               if (nr =3D=3D VOP_DEFAULT_CURSOR) {
>> +                       cursor =3D rockchip_plane_init(ctx, possible_c=
rtcs,
>> +                                                    DRM_PLANE_TYPE_CU=
RSOR);
>> +                       if (!cursor) {
>> +                               DRM_ERROR("fail to init cursor plane\n=
");
>> +                               return -EINVAL;
>> +                       }
>> +               } else {
>> +                       struct drm_plane *plane;
>> +
>> +                       plane =3D rockchip_plane_init(ctx, possible_cr=
tcs,
>> +                                                   DRM_PLANE_TYPE_OVE=
RLAY);
>> +                       if (!plane) {
>> +                               DRM_ERROR("fail to init overlay plane\=
n");
>> +                               return -EINVAL;
>> +                       }
>> +               }
>> +       }
>> +
>> +       drm_crtc_init_with_planes(drm_dev, crtc, primary, cursor,
>> +                                 &rockchip_crtc_funcs);
>> +       drm_crtc_helper_add(crtc, &rockchip_crtc_helper_funcs);
>> +
>> +       return 0;
>> +}
>> +
>> +static int rockchip_vop_initial(struct vop_context *ctx)
>> +{
>> +       struct vop_driver_data *vop_data =3D ctx->data;
>> +       const struct vop_reg_data *init_table =3D vop_data->init_table=
;
>> +       struct reset_control *rst;
>> +       int i, ret;
>> +
>> +       ctx->hclk =3D devm_clk_get(ctx->dev, "hclk_vop");
>> +       if (IS_ERR(ctx->hclk)) {
>> +               dev_err(ctx->dev, "failed to get hclk source\n");
>> +               return PTR_ERR(ctx->hclk);
>> +       }
>> +       ctx->aclk =3D devm_clk_get(ctx->dev, "aclk_vop");
>> +       if (IS_ERR(ctx->aclk)) {
>> +               dev_err(ctx->dev, "failed to get aclk source\n");
>> +               return PTR_ERR(ctx->aclk);
>> +       }
>> +       ctx->dclk =3D devm_clk_get(ctx->dev, "dclk_vop");
>> +       if (IS_ERR(ctx->dclk)) {
>> +               dev_err(ctx->dev, "failed to get dclk source\n");
>> +               return PTR_ERR(ctx->dclk);
>> +       }
>> +
>> +       ret =3D vop_clk_enable(ctx);
>> +       if (ret < 0)
>> +               return ret;
> if anything fails after this, remember to disable the clk...
oh, yes, I will do disable clk if fail.
> Ok, that is enough for now :-)
>
> Thanks,
> -djk
Thanks very much for your review,  nice suggestions.
-Mark
>
>> +
>> +       /*
>> +        * do hclk_reset, reset all vop registers.
>> +        */
>> +       rst =3D devm_reset_control_get(ctx->dev, "ahb");
>> +       if (IS_ERR(rst)) {
>> +               dev_err(ctx->dev, "failed to get ahb reset\n");
>> +               return PTR_ERR(rst);
>> +       }
>> +       reset_control_assert(rst);
>> +       usleep_range(10, 20);
>> +       reset_control_deassert(rst);
>> +
>> +       memcpy(ctx->regsbak, ctx->regs, ctx->len);
>> +
>> +       for (i =3D 0; i < vop_data->table_size; i++)
>> +               vop_writel(ctx, init_table[i].offset, init_table[i].va=
lue);
>> +
>> +       for (i =3D 0; i < VOP_MAX_WIN_SUPPORT; i++)
>> +               VOP_WIN_SET(ctx, vop_data->win[i], enable, 0);
>> +
>> +       vop_cfg_done(ctx);
>> +
>> +       /*
>> +        * do dclk_reset, let all win config take affect, and then we =
can enable
>> +        * iommu safe.
>> +        */
>> +       rst =3D devm_reset_control_get(ctx->dev, "dclk");
>> +       if (IS_ERR(rst)) {
>> +               dev_err(ctx->dev, "failed to get dclk reset\n");
>> +               return PTR_ERR(rst);
>> +       }
>> +       reset_control_assert(rst);
>> +       usleep_range(10, 20);
>> +       reset_control_deassert(rst);
>> +
>> +       ctx->dpms =3D DRM_MODE_DPMS_ON;
>> +
>> +       return 0;
>> +}
>> +
>> +static int vop_bind(struct device *dev, struct device *master, void *=
data)
>> +{
>> +       struct platform_device *pdev =3D to_platform_device(dev);
>> +       struct vop_driver_data *vop_data =3D vop_get_driver_data(dev);
>> +       struct drm_device *drm_dev =3D data;
>> +       struct vop_context *ctx;
>> +       struct resource *res;
>> +       int ret;
>> +
>> +       if (!vop_data)
>> +               return -ENODEV;
>> +
>> +       ctx =3D devm_kzalloc(dev, sizeof(*ctx), GFP_KERNEL);
>> +       if (!ctx)
>> +               return -ENOMEM;
>> +
>> +       ctx->dev =3D dev;
>> +       ctx->data =3D vop_data;
>> +       ctx->drm_dev =3D drm_dev;
>> +       dev_set_drvdata(dev, ctx);
>> +
>> +       res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +       ctx->len =3D resource_size(res);
>> +       ctx->regs =3D devm_ioremap_resource(dev, res);
>> +       if (IS_ERR(ctx->regs))
>> +               return PTR_ERR(ctx->regs);
>> +
>> +       ctx->regsbak =3D devm_kzalloc(dev, ctx->len, GFP_KERNEL);
>> +       if (!ctx->regsbak)
>> +               return -ENOMEM;
>> +
>> +       ret =3D rockchip_vop_initial(ctx);
>> +       if (ret < 0) {
>> +               dev_err(&pdev->dev, "cannot initial vop dev - err %d\n=
", ret);
>> +               return ret;
>> +       }
>> +
>> +       ctx->irq =3D platform_get_irq(pdev, 0);
>> +       if (ctx->irq < 0) {
>> +               dev_err(dev, "cannot find irq for vop\n");
>> +               return ctx->irq;
>> +       }
>> +
>> +       spin_lock_init(&ctx->reg_lock);
>> +       spin_lock_init(&ctx->irq_lock);
>> +
>> +       init_waitqueue_head(&ctx->wait_vsync_queue);
>> +       atomic_set(&ctx->wait_vsync_event, 0);
>> +
>> +       ret =3D vop_iommu_init(ctx);
>> +       if (ret) {
>> +               DRM_ERROR("Failed to setup iommu, %d\n", ret);
>> +               return ret;
>> +       }
>> +
>> +       ctx->vsync_wq =3D create_singlethread_workqueue("vsync");
>> +       if (!ctx->vsync_wq) {
>> +               dev_err(dev, "failed to create workqueue\n");
>> +               return -EINVAL;
>> +       }
>> +       INIT_WORK(&ctx->vsync_work, rockchip_vsync_worker);
>> +
>> +       mutex_init(&ctx->vsync_mutex);
>> +       pm_runtime_enable(&pdev->dev);
>> +
>> +       ret =3D devm_request_irq(dev, ctx->irq, rockchip_vop_isr,
>> +                              IRQF_SHARED, dev_name(dev), ctx);
>> +       if (ret) {
>> +               dev_err(dev, "cannot requeset irq%d - err %d\n", ctx->=
irq, ret);
>> +               return ret;
>> +       }
>> +
>> +       return vop_create_crtc(ctx);
>> +}
>> +
>> +static void vop_unbind(struct device *dev, struct device *master,
>> +                      void *data)
>> +{
>> +       struct drm_device *drm_dev =3D data;
>> +       struct vop_context *ctx =3D dev_get_drvdata(dev);
>> +       struct drm_crtc *crtc =3D &ctx->crtc;
>> +
>> +       drm_crtc_cleanup(crtc);
>> +       pm_runtime_disable(dev);
>> +       rockchip_drm_remove_crtc(drm_dev, ctx->pipe);
>> +
>> +       vop_iommu_fini(ctx);
>> +}
>> +
>> +static const struct component_ops vop_component_ops =3D {
>> +       .bind =3D vop_bind,
>> +       .unbind =3D vop_unbind,
>> +};
>> +
>> +static int vop_probe(struct platform_device *pdev)
>> +{
>> +       struct device *dev =3D &pdev->dev;
>> +       struct vop_context *ctx;
>> +
>> +       if (!dev->of_node) {
>> +               dev_err(dev, "can't find vop devices\n");
>> +               return -ENODEV;
>> +       }
>> +
>> +       platform_set_drvdata(pdev, ctx);
>> +
>> +       return component_add(dev, &vop_component_ops);
>> +}
>> +
>> +static int vop_remove(struct platform_device *pdev)
>> +{
>> +       component_del(&pdev->dev, &vop_component_ops);
>> +
>> +       return 0;
>> +}
>> +
>> +struct platform_driver rockchip_vop_platform_driver =3D {
>> +       .probe =3D vop_probe,
>> +       .remove =3D vop_remove,
>> +       .driver =3D {
>> +               .name =3D "rockchip-vop",
>> +               .owner =3D THIS_MODULE,
>> +               .of_match_table =3D of_match_ptr(vop_driver_dt_match),
>> +       },
>> +};
>> +
>> +module_platform_driver(rockchip_vop_platform_driver);
>> +
>> +MODULE_AUTHOR("Mark Yao <mark.yao@rock-chips.com>");
>> +MODULE_DESCRIPTION("ROCKCHIP VOP Driver");
>> +MODULE_LICENSE("GPL v2");
>> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.h b/drivers/gpu=
/drm/rockchip/rockchip_drm_vop.h
>> new file mode 100644
>> index 0000000..2343760
>> --- /dev/null
>> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.h
>> @@ -0,0 +1,187 @@
>> +/*
>> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
>> + * Author:Mark Yao <mark.yao@rock-chips.com>
>> + *
>> + * This software is licensed under the terms of the GNU General Publi=
c
>> + * License version 2, as published by the Free Software Foundation, a=
nd
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
>> +#define REG_CFG_DONE                   0x0000
>> +#define VERSION_INFO                   0x0004
>> +#define SYS_CTRL                       0x0008
>> +#define SYS_CTRL1                      0x000c
>> +#define DSP_CTRL0                      0x0010
>> +#define DSP_CTRL1                      0x0014
>> +#define DSP_BG                         0x0018
>> +#define MCU_CTRL                       0x001c
>> +#define INTR_CTRL0                     0x0020
>> +#define INTR_CTRL1                     0x0024
>> +#define WIN0_CTRL0                     0x0030
>> +#define WIN0_CTRL1                     0x0034
>> +#define WIN0_COLOR_KEY                 0x0038
>> +#define WIN0_VIR                       0x003c
>> +#define WIN0_YRGB_MST                  0x0040
>> +#define WIN0_CBR_MST                   0x0044
>> +#define WIN0_ACT_INFO                  0x0048
>> +#define WIN0_DSP_INFO                  0x004c
>> +#define WIN0_DSP_ST                    0x0050
>> +#define WIN0_SCL_FACTOR_YRGB           0x0054
>> +#define WIN0_SCL_FACTOR_CBR            0x0058
>> +#define WIN0_SCL_OFFSET                        0x005c
>> +#define WIN0_SRC_ALPHA_CTRL            0x0060
>> +#define WIN0_DST_ALPHA_CTRL            0x0064
>> +#define WIN0_FADING_CTRL               0x0068
>> +/* win1 register */
>> +#define WIN1_CTRL0                     0x0070
>> +#define WIN1_CTRL1                     0x0074
>> +#define WIN1_COLOR_KEY                 0x0078
>> +#define WIN1_VIR                       0x007c
>> +#define WIN1_YRGB_MST                  0x0080
>> +#define WIN1_CBR_MST                   0x0084
>> +#define WIN1_ACT_INFO                  0x0088
>> +#define WIN1_DSP_INFO                  0x008c
>> +#define WIN1_DSP_ST                    0x0090
>> +#define WIN1_SCL_FACTOR_YRGB           0x0094
>> +#define WIN1_SCL_FACTOR_CBR            0x0098
>> +#define WIN1_SCL_OFFSET                        0x009c
>> +#define WIN1_SRC_ALPHA_CTRL            0x00a0
>> +#define WIN1_DST_ALPHA_CTRL            0x00a4
>> +#define WIN1_FADING_CTRL               0x00a8
>> +/* win2 register */
>> +#define WIN2_CTRL0                     0x00b0
>> +#define WIN2_CTRL1                     0x00b4
>> +#define WIN2_VIR0_1                    0x00b8
>> +#define WIN2_VIR2_3                    0x00bc
>> +#define WIN2_MST0                      0x00c0
>> +#define WIN2_DSP_INFO0                 0x00c4
>> +#define WIN2_DSP_ST0                   0x00c8
>> +#define WIN2_COLOR_KEY                 0x00cc
>> +#define WIN2_MST1                      0x00d0
>> +#define WIN2_DSP_INFO1                 0x00d4
>> +#define WIN2_DSP_ST1                   0x00d8
>> +#define WIN2_SRC_ALPHA_CTRL            0x00dc
>> +#define WIN2_MST2                      0x00e0
>> +#define WIN2_DSP_INFO2                 0x00e4
>> +#define WIN2_DSP_ST2                   0x00e8
>> +#define WIN2_DST_ALPHA_CTRL            0x00ec
>> +#define WIN2_MST3                      0x00f0
>> +#define WIN2_DSP_INFO3                 0x00f4
>> +#define WIN2_DSP_ST3                   0x00f8
>> +#define WIN2_FADING_CTRL               0x00fc
>> +/* win3 register */
>> +#define WIN3_CTRL0                     0x0100
>> +#define WIN3_CTRL1                     0x0104
>> +#define WIN3_VIR0_1                    0x0108
>> +#define WIN3_VIR2_3                    0x010c
>> +#define WIN3_MST0                      0x0110
>> +#define WIN3_DSP_INFO0                 0x0114
>> +#define WIN3_DSP_ST0                   0x0118
>> +#define WIN3_COLOR_KEY                 0x011c
>> +#define WIN3_MST1                      0x0120
>> +#define WIN3_DSP_INFO1                 0x0124
>> +#define WIN3_DSP_ST1                   0x0128
>> +#define WIN3_SRC_ALPHA_CTRL            0x012c
>> +#define WIN3_MST2                      0x0130
>> +#define WIN3_DSP_INFO2                 0x0134
>> +#define WIN3_DSP_ST2                   0x0138
>> +#define WIN3_DST_ALPHA_CTRL            0x013c
>> +#define WIN3_MST3                      0x0140
>> +#define WIN3_DSP_INFO3                 0x0144
>> +#define WIN3_DSP_ST3                   0x0148
>> +#define WIN3_FADING_CTRL               0x014c
>> +/* hwc register */
>> +#define HWC_CTRL0                      0x0150
>> +#define HWC_CTRL1                      0x0154
>> +#define HWC_MST                                0x0158
>> +#define HWC_DSP_ST                     0x015c
>> +#define HWC_SRC_ALPHA_CTRL             0x0160
>> +#define HWC_DST_ALPHA_CTRL             0x0164
>> +#define HWC_FADING_CTRL                        0x0168
>> +/* post process register */
>> +#define POST_DSP_HACT_INFO             0x0170
>> +#define POST_DSP_VACT_INFO             0x0174
>> +#define POST_SCL_FACTOR_YRGB           0x0178
>> +#define POST_SCL_CTRL                  0x0180
>> +#define POST_DSP_VACT_INFO_F1          0x0184
>> +#define DSP_HTOTAL_HS_END              0x0188
>> +#define DSP_HACT_ST_END                        0x018c
>> +#define DSP_VTOTAL_VS_END              0x0190
>> +#define DSP_VACT_ST_END                        0x0194
>> +#define DSP_VS_ST_END_F1               0x0198
>> +#define DSP_VACT_ST_END_F1             0x019c
>> +/* register definition end */
>> +
>> +/* interrupt define */
>> +#define DSP_HOLD_VALID_INTR            (1 << 0)
>> +#define FS_INTR                                (1 << 1)
>> +#define LINE_FLAG_INTR                 (1 << 2)
>> +#define BUS_ERROR_INTR                 (1 << 3)
>> +
>> +#define DSP_HOLD_VALID_INTR_EN(x)      ((x) << 4)
>> +#define FS_INTR_EN(x)                  ((x) << 5)
>> +#define LINE_FLAG_INTR_EN(x)           ((x) << 6)
>> +#define BUS_ERROR_INTR_EN(x)           ((x) << 7)
>> +#define DSP_HOLD_VALID_INTR_MASK       (1 << 4)
>> +#define FS_INTR_EN_MASK                        (1 << 5)
>> +#define LINE_FLAG_INTR_MASK            (1 << 6)
>> +#define BUS_ERROR_INTR_MASK            (1 << 7)
>> +
>> +#define DSP_HOLD_VALID_INTR_CLR                (1 << 8)
>> +#define FS_INTR_EN_CLR                 (1 << 9)
>> +#define LINE_FLAG_INTR_CLR             (1 << 10)
>> +#define BUS_ERROR_INTR_CLR             (1 << 11)
>> +#define DSP_LINE_NUM(x)                        (((x) & 0x1fff) << 12)
>> +#define DSP_LINE_NUM_MASK              (0x1fff << 12)
>> +
>> +/* src alpha ctrl define */
>> +#define SRC_FADING_VALUE(x)            (((x) & 0xff) << 24)
>> +#define SRC_GLOBAL_ALPHA(x)            (((x) & 0xff) << 16)
>> +#define SRC_FACTOR_M0(x)               (((x) & 0x7) << 6)
>> +#define SRC_ALPHA_CAL_M0(x)            (((x) & 0x1) << 5)
>> +#define SRC_BLEND_M0(x)                        (((x) & 0x3) << 3)
>> +#define SRC_ALPHA_M0(x)                        (((x) & 0x1) << 2)
>> +#define SRC_COLOR_M0(x)                        (((x) & 0x1) << 1)
>> +#define SRC_ALPHA_EN(x)                        (((x) & 0x1) << 0)
>> +/* dst alpha ctrl define */
>> +#define DST_FACTOR_M0(x)               (((x) & 0x7) << 6)
>> +
>> +enum alpha_mode {
>> +       ALPHA_STRAIGHT,
>> +       ALPHA_INVERSE,
>> +};
>> +
>> +enum global_blend_mode {
>> +       ALPHA_GLOBAL,
>> +       ALPHA_PER_PIX,
>> +       ALPHA_PER_PIX_GLOBAL,
>> +};
>> +
>> +enum alpha_cal_mode {
>> +       ALPHA_SATURATION,
>> +       ALPHA_NO_SATURATION,
>> +};
>> +
>> +enum color_mode {
>> +       ALPHA_SRC_PRE_MUL,
>> +       ALPHA_SRC_NO_PRE_MUL,
>> +};
>> +
>> +enum factor_mode {
>> +       ALPHA_ZERO,
>> +       ALPHA_ONE,
>> +       ALPHA_SRC,
>> +       ALPHA_SRC_INVERSE,
>> +       ALPHA_SRC_GLOBAL,
>> +};
>> +
>> +#endif /* _ROCKCHIP_DRM_VOP_H */
>> --
>> 1.7.9.5
>>
>
>


--------------020302040903060005080105
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<html>
  <head>
    <meta content=3D"text/html; charset=3DUTF-8" http-equiv=3D"Content-Ty=
pe">
  </head>
  <body text=3D"#000000" bgcolor=3D"#FFFFFF">
    <div class=3D"moz-cite-prefix">On 2014=E5=B9=B409=E6=9C=8825=E6=97=A5=
 00:20, Daniel Kurtz
      wrote:<br>
    </div>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">Hi Mark,

Please review comments inline...

On Wed, Sep 24, 2014 at 10:12 AM, Mark yao <a class=3D"moz-txt-link-rfc23=
96E" href=3D"mailto:mark.yao@rock-chips.com">&lt;mark.yao@rock-chips.com&=
gt;</a> wrote:
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">This patch adds the basic structure of a DRM Drive=
r for Rockchip Socs.

Signed-off-by: Mark yao <a class=3D"moz-txt-link-rfc2396E" href=3D"mailto=
:mark.yao@rock-chips.com">&lt;mark.yao@rock-chips.com&gt;</a>
---
Changes in v2:
- use the component framework to defer main drm driver probe
  until all VOP devices have been probed.
- use dma-mapping API with ARM_DMA_USE_IOMMU, create dma mapping by
  master device and each vop device can shared the drm dma mapping.
- use drm_crtc_init_with_planes and drm_universal_plane_init.
- remove unnecessary middle layers.
- add cursor set, move funcs to rockchip drm crtc.
- use vop reset at first init
- reference framebuffer when used and unreference when swap out vop

Changes in v3:
- change "crtc-&gt;fb" to "crtc-&gt;primary-fb"
Adviced by Daniel Vetter
- init cursor plane with universal api, remove unnecessary cursor set,mov=
e

Changes in v4:
Adviced by David Herrmann
- remove drm_platform_*() usage, use register drm device directly.
Adviced by Rob Clark
- remove special mmap ioctl, do userspace mmap with normal mmap() or mmap=
 offset

Changes in v5:
Adviced by Arnd Bergmann
- doing DMA start with a 32-bit masks with dma_mask and dma_coherent_mark
- fix some incorrect dependencies.
Adviced by Boris BREZILLON
- fix some mistake and bugs.
Adviced by Daniel Vetter
- drop all special ioctl and use generic kms ioctl instead.
Adviced by Rob Clark
- use unlocked api for drm_fb_helper_restore_fbdev_mode.
- remove unused rockchip_gem_prime_import_sg_table.

 drivers/gpu/drm/Kconfig                       |    2 +
 drivers/gpu/drm/Makefile                      |    1 +
 drivers/gpu/drm/rockchip/Kconfig              |   17 +
 drivers/gpu/drm/rockchip/Makefile             |    8 +
 drivers/gpu/drm/rockchip/rockchip_drm_drv.c   |  509 +++++++++
 drivers/gpu/drm/rockchip/rockchip_drm_drv.h   |  120 +++
 drivers/gpu/drm/rockchip/rockchip_drm_fb.c    |  201 ++++
 drivers/gpu/drm/rockchip/rockchip_drm_fb.h    |   28 +
 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c |  230 +++++
 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h |   20 +
 drivers/gpu/drm/rockchip/rockchip_drm_gem.c   |  341 ++++++
 drivers/gpu/drm/rockchip/rockchip_drm_gem.h   |   55 +
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c   | 1373 +++++++++++++++++++=
++++++
 drivers/gpu/drm/rockchip/rockchip_drm_vop.h   |  187 ++++
 14 files changed, 3092 insertions(+)
 create mode 100644 drivers/gpu/drm/rockchip/Kconfig
 create mode 100644 drivers/gpu/drm/rockchip/Makefile
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_drv.c
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_drv.h
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fb.c
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fb.h
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_gem.c
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_gem.h
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_vop.c
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_vop.h

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index b066bb3..7c4c3c6 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -171,6 +171,8 @@ config DRM_SAVAGE

 source "drivers/gpu/drm/exynos/Kconfig"

+source "drivers/gpu/drm/rockchip/Kconfig"
+
 source "drivers/gpu/drm/vmwgfx/Kconfig"

 source "drivers/gpu/drm/gma500/Kconfig<a class=3D"moz-txt-link-rfc2396E"=
 href=3D"mailto:diff--gita/drivers/gpu/drm/Makefileb/drivers/gpu/drm/Make=
fileindex4a55d59..d03387a100644---a/drivers/gpu/drm/Makefile+++b/drivers/=
gpu/drm/Makefile@@-52,6+52,7@@obj-$(CONFIG_DRM_VMWGFX)+=3Dvmwgfx/obj-$(CO=
NFIG_DRM_VIA)+=3Dvia/obj-$(CONFIG_DRM_NOUVEAU)+=3Dnouveau/obj-$(CONFIG_DR=
M_EXYNOS)+=3Dexynos/+obj-$(CONFIG_DRM_ROCKCHIP)+=3Drockchip/obj-$(CONFIG_=
DRM_GMA500)+=3Dgma500/obj-$(CONFIG_DRM_UDL)+=3Dudl/obj-$(CONFIG_DRM_AST)+=
=3Dast/diff--gita/drivers/gpu/drm/rockchip/Kconfigb/drivers/gpu/drm/rockc=
hip/Kconfignewfilemode100644index0000000..87255f7---/dev/null+++b/drivers=
/gpu/drm/rockchip/Kconfig@@-0,0+1,17@@+configDRM_ROCKCHIP+tristate">"
diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
index 4a55d59..d03387a 100644
--- a/drivers/gpu/drm/Makefile
+++ b/drivers/gpu/drm/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_DRM_VMWGFX)+=3D vmwgfx/
 obj-$(CONFIG_DRM_VIA)  +=3Dvia/
 obj-$(CONFIG_DRM_NOUVEAU) +=3Dnouveau/
 obj-$(CONFIG_DRM_EXYNOS) +=3Dexynos/
+obj-$(CONFIG_DRM_ROCKCHIP) +=3Drockchip/
 obj-$(CONFIG_DRM_GMA500) +=3D gma500/
 obj-$(CONFIG_DRM_UDL) +=3D udl/
 obj-$(CONFIG_DRM_AST) +=3D ast/
diff --git a/drivers/gpu/drm/rockchip/Kconfig b/drivers/gpu/drm/rockchip/=
Kconfig
new file mode 100644
index 0000000..87255f7
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/Kconfig
@@ -0,0 +1,17 @@
+config DRM_ROCKCHIP
+       tristate "</a>DRM Support for Rockchip"
+       depends on DRM &amp;&amp; ROCKCHIP_IOMMU &amp;&amp; ARM_DMA_USE_I=
OMMU &amp;&amp; IOMMU_API
+       select DRM_KMS_HELPER
+       select DRM_KMS_FB_HELPER
+       select DRM_PANEL
+       select FB_CFB_FILLRECT
+       select FB_CFB_COPYAREA
+       select FB_CFB_IMAGEBLIT
+       select VT_HW_CONSOLE_BINDING if FRAMEBUFFER_CONSOLE
+       select VIDEOMODE_HELPERS
+       help
+         Choose this option if you have a Rockchip soc chipset.
+         This driver provides kernel mode setting and buffer
+         management to userspace. This driver does not provides
+         2D or 3D acceleration; acceleration is performed by other
+         IP found on the SoC.
diff --git a/drivers/gpu/drm/rockchip/Makefile b/drivers/gpu/drm/rockchip=
/Makefile
new file mode 100644
index 0000000..b3a5193
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/Makefile
@@ -0,0 +1,8 @@
+#
+# Makefile for the drm device driver.  This driver provides support for =
the
+# Direct Rendering Infrastructure (DRI) in XFree86 4.1.0 and higher.
+
+rockchipdrm-y :=3D rockchip_drm_drv.o rockchip_drm_fb.o rockchip_drm_fbd=
ev.o \
+               rockchip_drm_gem.o rockchip_drm_vop.o
+
+obj-$(CONFIG_DRM_ROCKCHIP) +=3D rockchipdrm.o
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_drv.c b/drivers/gpu/dr=
m/rockchip/rockchip_drm_drv.c
new file mode 100644
index 0000000..0ca4a6b
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_drv.c
@@ -0,0 +1,509 @@
+/*
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:Mark Yao <a class=3D"moz-txt-link-rfc2396E" href=3D"mailto:mar=
k.yao@rock-chips.com">&lt;mark.yao@rock-chips.com&gt;</a>
+ *
+ * based on exynos_drm_drv.c
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include &lt;asm/dma-iommu.h&gt;
+
+#include &lt;drm/drmP.h&gt;
+#include &lt;drm/drm_crtc_helper.h&gt;
+#include &lt;drm/drm_fb_helper.h&gt;
+#include &lt;linux/dma-mapping.h&gt;
+#include &lt;linux/pm_runtime.h&gt;
+#include &lt;linux/of_graph.h&gt;
+#include &lt;linux/component.h&gt;
+
+#include "rockchip_drm_drv.h"
+#include "rockchip_drm_fb.h"
+#include "rockchip_drm_fbdev.h"
+#include "rockchip_drm_gem.h"
+
+#define DRIVER_NAME    "rockchip"
+#define DRIVER_DESC    "RockChip Soc DRM"
+#define DRIVER_DATE    "20140818"
+#define DRIVER_MAJOR   1
+#define DRIVER_MINOR   0
+
+/*
+ * Attach a (component) device to the shared drm dma mapping from master=
 drm
+ * device.  This is used by the VOPs to map GEM buffers to a common DMA
+ * mapping.
+ */
+int rockchip_drm_dma_attach_device(struct drm_device *drm_dev,
+                                  struct device *dev)
+{
+       struct dma_iommu_mapping *mapping =3D drm_dev-&gt;dev-&gt;archdat=
a.mapping;
+       int ret;
+
+       ret =3D dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
+       if (ret)
+               return ret;
+
+       dma_set_max_seg_size(dev, 0xffffffffu);
+
+       return arm_iommu_attach_device(dev, mapping);
+}
+
+void rockchip_drm_dma_detach_device(struct drm_device *drm_dev,
+                                   struct device *dev)
+{
+       arm_iommu_detach_device(drm_dev-&gt;dev);
+}
+
+static int rockchip_drm_load(struct drm_device *drm_dev, unsigned long f=
lags)
+{
+       struct rockchip_drm_private *private;
+       struct dma_iommu_mapping *mapping;
+       struct device *dev =3D drm_dev-&gt;dev;
+       int ret;
+
+       private =3D devm_kzalloc(drm_dev-&gt;dev, sizeof(*private), GFP_K=
ERNEL);
+       if (!private)
+               return -ENOMEM;
+
+       drm_dev-&gt;dev_private =3D private;
+
+       drm_mode_config_init(drm_dev);
+
+       rockchip_drm_mode_config_init(drm_dev);
+
+       dev-&gt;dma_parms =3D devm_kzalloc(dev, sizeof(*dev-&gt;dma_parms=
),
+                                     GFP_KERNEL);
+       if (!dev-&gt;dma_parms) {
+               ret =3D -ENOMEM;
+               goto err_config_cleanup;
+       }
+
+       /* TODO(djkurtz): fetch the mapping start/size from somewhere */
+       mapping =3D arm_iommu_create_mapping(&amp;platform_bus_type, 0x10=
000000,
+                                          SZ_1G);
+       if (IS_ERR(mapping)) {
+               ret =3D PTR_ERR(mapping);
+               goto err_config_cleanup;
+       }
+
+       ret =3D dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
+       if (ret)
+               goto err_config_cleanup;
</pre>
      </blockquote>
      <pre wrap=3D"">
goto err_release_mapping;</pre>
    </blockquote>
    oh, I make a mistake... Sure, I will fix it.<br>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">

</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+
+       dma_set_max_seg_size(dev, 0xffffffffu);
+
+       ret =3D arm_iommu_attach_device(dev, mapping);
+       if (ret)
+               goto err_release_mapping;
+
+       /* Try to bind all sub drivers. */
+       ret =3D component_bind_all(dev, drm_dev);
+       if (ret)
+               goto err_detach_device;
+
+       /* init kms poll for handling hpd */
+       drm_kms_helper_poll_init(drm_dev);
+
+       /*
+        * enable drm irq mode.
+        * - with irq_enabled =3D true, we can use the vblank feature.
+        */
+       drm_dev-&gt;irq_enabled =3D true;
+
+       /*
+        * with vblank_disable_allowed =3D true, vblank interrupt will be=
 disabled
+        * by drm timer once a current process gives up ownership of
+        * vblank event.(after drm_vblank_put function is called)
+        */
+       drm_dev-&gt;vblank_disable_allowed =3D true;
+
+       ret =3D drm_vblank_init(drm_dev, ROCKCHIP_MAX_CRTC);
+       if (ret)
+               goto err_kms_helper_poll_fini;
+
+       rockchip_drm_fbdev_init(drm_dev);
+
+       /* force connectors detection */
+       drm_helper_hpd_irq_event(drm_dev);
+
+       return 0;
+
+err_kms_helper_poll_fini:
+       drm_kms_helper_poll_fini(drm_dev);
+       component_unbind_all(dev, drm_dev);
+err_detach_device:
+       arm_iommu_detach_device(dev);
+err_release_mapping:
+       arm_iommu_release_mapping(dev-&gt;archdata.mapping);
+err_config_cleanup:
+       drm_mode_config_cleanup(drm_dev);
+       drm_dev-&gt;dev_private =3D NULL;
+       return ret;
+}
+
+static int rockchip_drm_unload(struct drm_device *drm_dev)
+{
+       struct device *dev =3D drm_dev-&gt;dev;
+
+       drm_kms_helper_poll_fini(drm_dev);
+       component_unbind_all(dev, drm_dev);
+       arm_iommu_detach_device(dev);
+       arm_iommu_release_mapping(dev-&gt;archdata.mapping);
+       drm_mode_config_cleanup(drm_dev);
+       drm_dev-&gt;dev_private =3D NULL;
+
+       return 0;
+}
+
+static int rockchip_drm_suspend(struct drm_device *dev, pm_message_t sta=
te)
+{
+       struct drm_connector *connector;
+
+       drm_modeset_lock_all(dev);
+       list_for_each_entry(connector, &amp;dev-&gt;mode_config.connector=
_list, head) {
+               int old_dpms =3D connector-&gt;dpms;
+
+               if (connector-&gt;funcs-&gt;dpms)
+                       connector-&gt;funcs-&gt;dpms(connector, DRM_MODE_=
DPMS_OFF);
+
+               /* Set the old mode back to the connector for resume */
+               connector-&gt;dpms =3D old_dpms;
+       }
+       drm_modeset_unlock_all(dev);
+
+       return 0;
+}
+
+static int rockchip_drm_resume(struct drm_device *dev)
+{
+       struct drm_connector *connector;
+
+       drm_modeset_lock_all(dev);
+       list_for_each_entry(connector, &amp;dev-&gt;mode_config.connector=
_list, head) {
+               if (connector-&gt;funcs-&gt;dpms)
+                       connector-&gt;funcs-&gt;dpms(connector, connector=
-&gt;dpms);
+       }
+       drm_modeset_unlock_all(dev);
+
+       drm_helper_resume_force_mode(dev);
+
+       return 0;
+}
+
+void rockchip_drm_lastclose(struct drm_device *dev)
+{
+       struct rockchip_drm_private *priv =3D dev-&gt;dev_private;
+
+       if (priv-&gt;fb_helper)
+               drm_fb_helper_restore_fbdev_mode_unlocked(priv-&gt;fb_hel=
per);
+}
+
+static const struct file_operations rockchip_drm_driver_fops =3D {
+       .owner =3D THIS_MODULE,
+       .open =3D drm_open,
+       .mmap =3D rockchip_drm_gem_mmap,
+       .poll =3D drm_poll,
+       .read =3D drm_read,
+       .unlocked_ioctl =3D drm_ioctl,
+#ifdef CONFIG_COMPAT
+       .compat_ioctl =3D drm_compat_ioctl,
+#endif
+       .release =3D drm_release,
+};
+
+const struct vm_operations_struct rockchip_drm_vm_ops =3D {
+       .open =3D drm_gem_vm_open,
+       .close =3D drm_gem_vm_close,
+};
+
+static struct drm_driver rockchip_drm_driver =3D {
+       .driver_features        =3D DRIVER_MODESET | DRIVER_GEM | DRIVER_=
PRIME,
+       .load                   =3D rockchip_drm_load,
+       .unload                 =3D rockchip_drm_unload,
+       .lastclose              =3D rockchip_drm_lastclose,
+       .suspend                =3D rockchip_drm_suspend,
+       .resume                 =3D rockchip_drm_resume,
</pre>
      </blockquote>
      <pre wrap=3D"">
Looking at drm_sysfs.c, the .suspend/.resume callbacks are only
invoked if the driver does not set DRIVER_MODESET in .driver_features.
Since this driver does have DRIVER_MODESET, let's just drop these two ite=
ms.
The platform_driver provides its own suspend/resume callbacks, instead.
</pre>
    </blockquote>
    right, driver_features with DRIVER_MODESET, the suspend/resume do
    not be called. <br>
    I will remove it to platform_driver.
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <blockquote type=3D"cite">
        <pre wrap=3D"">+       .get_vblank_counter     =3D drm_vblank_cou=
nt,
+       .enable_vblank          =3D rockchip_drm_crtc_enable_vblank,
+       .disable_vblank         =3D rockchip_drm_crtc_disable_vblank,
+       .gem_vm_ops             =3D &amp;rockchip_drm_vm_ops,
+       .gem_free_object        =3D rockchip_gem_free_object,
+       .dumb_create            =3D rockchip_gem_dumb_create,
+       .dumb_map_offset        =3D rockchip_gem_dumb_map_offset,
+       .dumb_destroy           =3D drm_gem_dumb_destroy,
+       .prime_handle_to_fd     =3D drm_gem_prime_handle_to_fd,
+       .prime_fd_to_handle     =3D drm_gem_prime_fd_to_handle,
+       .gem_prime_import       =3D drm_gem_prime_import,
+       .gem_prime_export       =3D drm_gem_prime_export,
+       .gem_prime_get_sg_table =3D rockchip_gem_prime_get_sg_table,
+       .gem_prime_vmap         =3D rockchip_gem_prime_vmap,
+       .gem_prime_vunmap       =3D rockchip_gem_prime_vunmap,
+       .gem_prime_mmap         =3D rockchip_gem_prime_mmap,
+       .ioctls                 =3D rockchip_ioctls,
+       .num_ioctls             =3D ARRAY_SIZE(rockchip_ioctls),
+       .fops                   =3D &amp;rockchip_drm_driver_fops,
+       .name   =3D DRIVER_NAME,
+       .desc   =3D DRIVER_DESC,
+       .date   =3D DRIVER_DATE,
+       .major  =3D DRIVER_MAJOR,
+       .minor  =3D DRIVER_MINOR,
+};
+
+#ifdef CONFIG_PM_SLEEP
+static int rockchip_drm_sys_suspend(struct device *dev)
+{
+       struct drm_device *drm_dev =3D dev_get_drvdata(dev);
+       pm_message_t message;
+
+       if (pm_runtime_suspended(dev))
+               return 0;
+
+       message.event =3D PM_EVENT_SUSPEND;
+
+       return rockchip_drm_suspend(drm_dev, message);
+}
+
+static int rockchip_drm_sys_resume(struct device *dev)
+{
+       struct drm_device *drm_dev =3D dev_get_drvdata(dev);
+
+       if (pm_runtime_suspended(dev))
+               return 0;
+
+       return rockchip_drm_resume(drm_dev);
+}
+#endif
+
+static const struct dev_pm_ops rockchip_drm_pm_ops =3D {
+       SET_SYSTEM_SLEEP_PM_OPS(rockchip_drm_sys_suspend,
+                               rockchip_drm_sys_resume)
+};
</pre>
      </blockquote>
      <pre wrap=3D"">
Looks like this is not actually hooked up.
Perhaps you meant to add this to rockchip_drm_platform_driver, see below.=
..

</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+
+int rockchip_drm_add_crtc(struct drm_device *drm, struct drm_crtc *crtc,
+                         struct device_node *np)
+{
+       struct rockchip_drm_private *priv =3D drm-&gt;dev_private;
+       struct device_node *port;
+       int pipe;
+
+       if (priv-&gt;num_pipe &gt;=3D ROCKCHIP_MAX_CRTC)
+               return -EINVAL;
+
+       port =3D of_get_child_by_name(np, "port");
+       if (!port) {
+               dev_err(drm-&gt;dev, "no port node found in %s\n",
+                       np-&gt;full_name);
+               return -ENXIO;
+       }
+       pipe =3D priv-&gt;num_pipe++;
+       crtc-&gt;port =3D port;
+
+       priv-&gt;crtc[pipe] =3D crtc;
+
+       return pipe;
+}
+
+void rockchip_drm_remove_crtc(struct drm_device *drm, int pipe)
+{
+       struct rockchip_drm_private *priv =3D drm-&gt;dev_private;
+
+       priv-&gt;num_pipe--;
+       of_node_put(priv-&gt;crtc[pipe]-&gt;port);
+       priv-&gt;crtc[pipe] =3D NULL;
+}
+
+struct drm_crtc *rockchip_find_crtc(struct drm_device *drm, int pipe)
+{
+       struct rockchip_drm_private *priv =3D drm-&gt;dev_private;
+
+       if (pipe &lt; ROCKCHIP_MAX_CRTC &amp;&amp; priv-&gt;crtc[pipe])
+               return priv-&gt;crtc[pipe];
+
+       return NULL;
+}
+
+/*
+ * @node: device tree node containing encoder input ports
+ * @encoder: drm_encoder
+ */
+int rockchip_drm_encoder_get_mux_id(struct device_node *node,
+                                   struct drm_encoder *encoder)
+{
+       struct device_node *ep =3D NULL;
+       struct drm_crtc *crtc =3D encoder-&gt;crtc;
+       struct of_endpoint endpoint;
+       struct device_node *port;
+       int ret;
+
+       if (!node || !crtc)
+               return -EINVAL;
+
+       do {
+               ep =3D of_graph_get_next_endpoint(node, ep);
+               if (!ep)
+                       break;
+
+               port =3D of_graph_get_remote_port(ep);
+               of_node_put(port);
+               if (port =3D=3D crtc-&gt;port) {
+                       ret =3D of_graph_parse_endpoint(ep, &amp;endpoint=
);
+                       return ret ? ret : endpoint.id;
</pre>
      </blockquote>
      <pre wrap=3D"">
nit:

   return ret ?: endpoint.id;</pre>
    </blockquote>
    OK, I will do it.<br>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">

</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+               }
+       } while (ep);
+
+       return -EINVAL;
+}
+
+static int compare_of(struct device *dev, void *data)
+{
+       struct device_node *np =3D data;
+
+       return dev-&gt;of_node =3D=3D np;
+}
+
+static void rockchip_add_endpoints(struct device *dev,
+                                  struct component_match **match,
+                                  struct device_node *port)
+{
+       struct device_node *ep, *remote;
+
+       for_each_child_of_node(port, ep) {
+               remote =3D of_graph_get_remote_port_parent(ep);
+               if (!remote || !of_device_is_available(remote)) {
+                       of_node_put(remote);
+                       continue;
+               } else if (!of_device_is_available(remote-&gt;parent)) {
+                       dev_warn(dev, "parent device of %s is not availab=
le\n",
+                                remote-&gt;full_name);
+                       of_node_put(remote);
+                       continue;
+               }
+
+               component_match_add(dev, match, compare_of, remote);
+               of_node_put(remote);
+       }
+}
+
+static int rockchip_drm_bind(struct device *dev)
+{
+       struct drm_device *drm;
+       int ret;
+
+       drm =3D drm_dev_alloc(&amp;rockchip_drm_driver, dev);
+       if (!drm)
+               return -ENOMEM;
+
+       ret =3D drm_dev_set_unique(drm, "%s", dev_name(dev));
+       if (ret)
+               goto err_free;
+
+       ret =3D drm_dev_register(drm, 0);
+       if (ret)
+               goto err_free;
+
+       dev_set_drvdata(dev, drm);
+
+       return 0;
+
+err_free:
+       drm_dev_unref(drm);
+       return ret;
+}
+
+static void rockchip_drm_unbind(struct device *dev)
+{
+       struct drm_device *drm =3D dev_get_drvdata(dev);
+
+       drm_dev_unregister(drm);
+       drm_dev_unref(drm);
+}
+
+static const struct component_master_ops rockchip_drm_ops =3D {
+       .bind =3D rockchip_drm_bind,
+       .unbind =3D rockchip_drm_unbind,
+};
+
+static int rockchip_drm_platform_probe(struct platform_device *pdev)
+{
+       struct device *dev =3D &amp;pdev-&gt;dev;
+       struct component_match *match =3D NULL;
+       struct device_node *np =3D dev-&gt;of_node;
+       struct device_node *port;
+       int i;
+       int ret;
+
+       if (!np)
+               return -ENODEV;
+       /*
+        * Bind the crtc ports first, so that
+        * drm_of_find_possible_crtcs called from encoder .bind callbacks
+        * works as expected.
+        */
+       for (i =3D 0;; i++) {
+               port =3D of_parse_phandle(np, "ports", i);
+               if (!port)
+                       break;
</pre>
      </blockquote>
      <pre wrap=3D"">
I think you want to make sure that the parent node of this 'port' (ie,
the VOP node) is not disabled...

  if (!of_device_is_available(port-&gt;parent)) {
    of_node_put(port);
    continue;
  }
</pre>
    </blockquote>
    right, vop node maybe disabled, we should check it.<br>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+
+               component_match_add(dev, &amp;match, compare_of, port-&gt=
;parent);
+               of_node_put(port);
+       }
+
+       if (i =3D=3D 0) {
+               dev_err(dev, "missing 'ports' property\n");
+               return -ENODEV;
+       }
+       /*
+        * For each bound crtc, bind the encoders attached to its
+        * remote endpoint.
+        */
+       for (i =3D 0;; i++) {
+               port =3D of_parse_phandle(np, "ports", i);
+               if (!port)
+                       break;
+
</pre>
      </blockquote>
      <pre wrap=3D"">
Here, too:
  if (!of_device_is_available(port-&gt;parent)) {
    of_node_put(port);
    continue;
  }
</pre>
    </blockquote>
    OK.<br>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+               rockchip_add_endpoints(dev, &amp;m=
atch, port);
+               of_node_put(port);
+       }
+
+       ret =3D dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
+       if (ret)
+               return ret;
+
+       return component_master_add_with_match(dev, &amp;rockchip_drm_ops=
, match);
+}
+
+static int rockchip_drm_platform_remove(struct platform_device *pdev)
+{
+       component_master_del(&amp;pdev-&gt;dev, &amp;rockchip_drm_ops);
+
+       return 0;
+}
+
+static const struct of_device_id rockchip_drm_dt_ids[] =3D {
+       { .compatible =3D "rockchip,display-subsystem", },
+       { /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, rockchip_drm_dt_ids);
+
+static struct platform_driver rockchip_drm_platform_driver =3D {
+       .probe =3D rockchip_drm_platform_probe,
+       .remove =3D rockchip_drm_platform_remove,
+       .driver =3D {
+               .owner =3D THIS_MODULE,
+               .name =3D "rockchip-drm",
+               .of_match_table =3D rockchip_drm_dt_ids,
</pre>
      </blockquote>
      <pre wrap=3D"">
      .pm =3D &amp;rockchip_drm_pm_ops,
</pre>
    </blockquote>
    OK<br>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+       },
+};
+
+module_platform_driver(rockchip_drm_platform_driver);
+
+MODULE_AUTHOR("Mark Yao <a class=3D"moz-txt-link-rfc2396E" href=3D"mailt=
o:mark.yao@rock-chips.com">&lt;mark.yao@rock-chips.com&gt;</a>");
+MODULE_DESCRIPTION("ROCKCHIP DRM Driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_drv.h b/drivers/gpu/dr=
m/rockchip/rockchip_drm_drv.h
new file mode 100644
index 0000000..154b3ec
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_drv.h
@@ -0,0 +1,120 @@
+/*
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:Mark Yao <a class=3D"moz-txt-link-rfc2396E" href=3D"mailto:mar=
k.yao@rock-chips.com">&lt;mark.yao@rock-chips.com&gt;</a>
+ *
+ * based on exynos_drm_drv.h
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _ROCKCHIP_DRM_DRV_H
+#define _ROCKCHIP_DRM_DRV_H
+
+#include &lt;linux/module.h&gt;
+#include &lt;linux/component.h&gt;
+
+#define ROCKCHIP_MAX_FB_BUFFER 4
</pre>
      </blockquote>
      <pre wrap=3D"">
This is only used to size the array of gem object pointers used by a
framebuffer .
What framebuffer pixel format uses 4 planes?  I think the max is 3?
</pre>
    </blockquote>
    right, the max is 3 with YUV format.<br>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+#define ROCKCHIP_MAX_CONNECTOR 2
+
+struct drm_device;
+struct drm_connector;
+
+/*
+ * display output interface supported by rockchip lcdc
</pre>
      </blockquote>
      <pre wrap=3D"">
s/lcdc/vop
</pre>
    </blockquote>
    OK, I will fix it.<br>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+ */
+#define ROCKCHIP_OUTFACE_P888  0
+#define ROCKCHIP_OUTFACE_P666  1
+#define ROCKCHIP_OUTFACE_P565  2
+/* for use special outface */
+#define ROCKCHIP_OUTFACE_AAAA  15
</pre>
      </blockquote>
      <pre wrap=3D"">
"outface" is creative.  It is actually an English word that means "to
disconcert an opponent by bold confrontation", I do not think that is
what you mean here :-).

Rename these to ROCKCHIP_OUT_MODE_, to be consistent with the
corresponding field (dsp_out_mode) of the VOP_DSP_CTRL0 register to
which these are written.
Also, since these are register values written to VOP_DSP_CTRL0, so
move them to the VOP header file.
</pre>
    </blockquote>
    "outface" maybe Chinese English, so you are right, I will change it.
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+
+#define ROCKCHIP_COLOR_SWAP_RG 0x1
+#define ROCKCHIP_COLOR_SWAP_RB 0x2
+#define ROCKCHIP_COLOR_SWAP_GB 0x4
+
+/*
+ * Special mode info for rockchip
+ *
+ * @out_type: lcd controller need to know the sceen type.
+ */
+struct rockchip_display_mode {
+       int out_type;
+};
+
+#define ROCKCHIP_EVENT_HOTPLUG 1
+
+enum rockchip_plane_type {
+       ROCKCHIP_WIN0,
+       ROCKCHIP_WIN1,
+       ROCKCHIP_WIN2,
+       ROCKCHIP_WIN3,
+       ROCKCHIP_CURSOR,
+       ROCKCHIP_MAX_PLANE,
+};
+
+/* This enumerates device type. */
+enum rockchip_drm_device_type {
+       ROCKCHIP_DEVICE_TYPE_NONE,
+       ROCKCHIP_DEVICE_TYPE_CRTC,
+       ROCKCHIP_DEVICE_TYPE_CONNECTOR,
+};
+
+/* this enumerates display type. */
+enum rockchip_drm_output_type {
+       ROCKCHIP_DISPLAY_TYPE_NONE =3D 0,
</pre>
      </blockquote>
      <pre wrap=3D"">
To match the enum name, use ROCKCHIP_OUTPUT_TYPE_*.
Also, no need to explicitly set the first one to 0.
However, see below.  I don't think we to modify the drm_display_mode
to include an output type.
</pre>
    </blockquote>
    but vop devices need know the connector type, connector enable
    register is in vop.<br>
    can I do that like under to=C2=A0 get connector type for crtc?<br>
    <br>
    =C2=A0=C2=A0=C2=A0 static int rockchip_get_connector_type(struct drm_=
crtc *crtc)<br>
    =C2=A0=C2=A0=C2=A0 {<br>
    =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct drm_dev=
ice *dev =3D crtc-&gt;dev;<br>
    =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct drm_con=
nector * connector;<br>
    <br>
    =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 list_for_each_=
entry(connector,
    &amp;dev-&gt;mode_config.connector_list, head) {<br>
    =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!connector-&gt;=
encoder)<br>
    =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 continue;<br>
    =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*<br>
    =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * one cr=
tc only has one connector in my case, so just
    find the first connector at list.<br>
    =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */<br>
    =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (connector-&gt;e=
ncoder-&gt;crtc =3D=3D crtc)<br>
    =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 break;<br>
    =C2=A0=C2=A0=C2=A0 }<br>
    <br>
    =C2=A0=C2=A0=C2=A0 if (!connector)<br>
    =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return =
-EINVAL;<br>
    <br>
    =C2=A0=C2=A0=C2=A0 return connector-&gt;connector_type;<br>
    }
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <blockquote type=3D"cite">
        <pre wrap=3D"">+       /* RGB Interface. */
+       ROCKCHIP_DISPLAY_TYPE_RGB,
+       /* LVDS Interface. */
+       ROCKCHIP_DISPLAY_TYPE_LVDS,
+       /* EDP Interface. */
+       ROCKCHIP_DISPLAY_TYPE_EDP,
+       /* MIPI Interface. */
+       ROCKCHIP_DISPLAY_TYPE_MIPI,
+       /* HDMI Interface. */
+       ROCKCHIP_DISPLAY_TYPE_HDMI,
+};
+
+enum rockchip_crtc_type {
+       ROCKCHIP_CRTC_VOPB,
+       ROCKCHIP_CRTC_VOPL,
+       ROCKCHIP_MAX_CRTC,
+};
</pre>
      </blockquote>
      <pre wrap=3D"">
None of the following defined above are used and they can all be removed:
 ROCKCHIP_EVENT_HOTPLUG
 rockchip_plane_type
 rockchip_drm_device_type
 ROCKCHIP_COLOR_SWAP_*
 rockchip_crtc_type
</pre>
    </blockquote>
    OK, I will drop them.<br>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+
+/*
+ * Rockchip drm private structure.
+ *
+ * @num_pipe: number of pipes for this device.
+ */
+struct rockchip_drm_private {
+       struct drm_fb_helper *fb_helper;
+       /*
+        * created crtc object would be contained at this array and
+        * this array is used to be aware of which crtc did it request vb=
lank.
+        */
</pre>
      </blockquote>
      <pre wrap=3D"">
Move this comment up to the struct comment, above "num_pipe".

@crtc: array of enabled CRTCs, used to map from "pipe" to drm_crtc
</pre>
    </blockquote>
    OK<br>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+       struct drm_crtc *crtc[ROCKCHIP_MAX_CRTC];
+
+       unsigned int num_pipe;
+};
+
+int rockchip_drm_add_crtc(struct drm_device *drm, struct drm_crtc *crtc,
+                         struct device_node *port);
+void rockchip_drm_remove_crtc(struct drm_device *drm, int pipe);
+struct drm_crtc *rockchip_find_crtc(struct drm_device *drm, int pipe);
</pre>
      </blockquote>
      <pre wrap=3D"">
For consistency, this should probably be "rockchip_drm_find_crtc",
although you can probably drop the "_drm" from all of these function
names if you wanted to make them shorter.
Or, perhaps use:  rk_drm_*()
</pre>
    </blockquote>
    OK<br>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+int rockchip_drm_encoder_get_mux_id(struct device=
_node *node,
+                                   struct drm_encoder *encoder);
+void rockchip_drm_crtc_finish_pageflip(struct drm_device *dev, int pipe)=
;
+void rockchip_drm_crtc_cancel_pending_flip(struct drm_device *dev);
+int rockchip_drm_crtc_enable_vblank(struct drm_device *dev, int pipe);
+void rockchip_drm_crtc_disable_vblank(struct drm_device *dev, int pipe);
+int rockchip_drm_dma_attach_device(struct drm_device *drm_dev,
+                                  struct device *dev);
+void rockchip_drm_dma_detach_device(struct drm_device *drm_dev,
+                                   struct device *dev);
</pre>
      </blockquote>
      <pre wrap=3D"">
A blank line here helps.
</pre>
    </blockquote>
    OK<br>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+#endif /* _ROCKCHIP_DRM_DRV_H_ */
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_fb.c b/drivers/gpu/drm=
/rockchip/rockchip_drm_fb.c
new file mode 100644
index 0000000..482f7b8
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_fb.c
@@ -0,0 +1,201 @@
+/*
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:Mark Yao <a class=3D"moz-txt-link-rfc2396E" href=3D"mailto:mar=
k.yao@rock-chips.com">&lt;mark.yao@rock-chips.com&gt;</a>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include &lt;linux/kernel.h&gt;
+#include &lt;drm/drm.h&gt;
+#include &lt;drm/drmP.h&gt;
+#include &lt;drm/drm_fb_helper.h&gt;
+#include &lt;drm/drm_crtc_helper.h&gt;
+
+#include "rockchip_drm_drv.h"
+#include "rockchip_drm_gem.h"
+
+#define to_rockchip_fb(x) container_of(x, struct rockchip_drm_fb, fb)
+
+struct rockchip_drm_fb {
+       struct drm_framebuffer fb;
+       struct drm_gem_object *obj[ROCKCHIP_MAX_FB_BUFFER];
+};
+
+struct drm_gem_object *rockchip_fb_get_gem_obj(struct drm_framebuffer *f=
b,
+                                              unsigned int plane)
+{
+       struct rockchip_drm_fb *rk_fb =3D to_rockchip_fb(fb);
+
+       if (plane &gt;=3D ROCKCHIP_MAX_FB_BUFFER)
+               return NULL;
+
+       return rk_fb-&gt;obj[plane];
+}
+
+static void rockchip_drm_fb_destroy(struct drm_framebuffer *fb)
+{
+       struct rockchip_drm_fb *rockchip_fb =3D to_rockchip_fb(fb);
+       struct drm_gem_object *obj;
+       int i;
+
+       for (i =3D 0; i &lt; ROCKCHIP_MAX_FB_BUFFER; i++) {
+               obj =3D rockchip_fb-&gt;obj[i];
+               if (obj)
+                       drm_gem_object_unreference_unlocked(obj);
+       }
+
+       drm_framebuffer_cleanup(fb);
+       kfree(rockchip_fb);
+}
+
+static int rockchip_drm_fb_create_handle(struct drm_framebuffer *fb,
+                                        struct drm_file *file_priv,
+                                        unsigned int *handle)
+{
+       struct rockchip_drm_fb *rockchip_fb =3D to_rockchip_fb(fb);
+
+       return drm_gem_handle_create(file_priv,
+                                    rockchip_fb-&gt;obj[0], handle);
+}
+
+static struct drm_framebuffer_funcs rockchip_drm_fb_funcs =3D {
+       .destroy        =3D rockchip_drm_fb_destroy,
+       .create_handle  =3D rockchip_drm_fb_create_handle,
+};
+
+static struct rockchip_drm_fb *
+rockchip_fb_alloc(struct drm_device *dev, struct drm_mode_fb_cmd2 *mode_=
cmd,
+                 struct drm_gem_object **obj, unsigned int num_planes)
+{
+       struct rockchip_drm_fb *rockchip_fb;
+       int ret;
+       int i;
+
+       rockchip_fb =3D kzalloc(sizeof(*rockchip_fb), GFP_KERNEL);
+       if (!rockchip_fb)
+               return ERR_PTR(-ENOMEM);
+
+       drm_helper_mode_fill_fb_struct(&amp;rockchip_fb-&gt;fb, mode_cmd)=
;
+
+       for (i =3D 0; i &lt; num_planes; i++)
+               rockchip_fb-&gt;obj[i] =3D obj[i];
+
+       ret =3D drm_framebuffer_init(dev, &amp;rockchip_fb-&gt;fb,
+                                  &amp;rockchip_drm_fb_funcs);
+       if (ret) {
+               dev_err(dev-&gt;dev, "Failed to initialize framebuffer: %=
d\n",
+                       ret);
+               kfree(rockchip_fb);
+               return ERR_PTR(ret);
+       }
+
+       return rockchip_fb;
+}
+
+static struct drm_framebuffer *
+rockchip_user_fb_create(struct drm_device *dev, struct drm_file *file_pr=
iv,
+                       struct drm_mode_fb_cmd2 *mode_cmd)
+{
+       struct rockchip_drm_fb *rockchip_fb;
+       struct drm_gem_object *objs[ROCKCHIP_MAX_FB_BUFFER];
+       struct drm_gem_object *obj;
+       unsigned int hsub;
+       unsigned int vsub;
+       int num_planes;
+       int ret;
+       int i;
+
+       hsub =3D drm_format_horz_chroma_subsampling(mode_cmd-&gt;pixel_fo=
rmat);
+       vsub =3D drm_format_vert_chroma_subsampling(mode_cmd-&gt;pixel_fo=
rmat);
+       num_planes =3D min(drm_format_num_planes(mode_cmd-&gt;pixel_forma=
t),
+                        ROCKCHIP_MAX_FB_BUFFER);
+
+       for (i =3D 0; i &lt; num_planes; i++) {
+               unsigned int width =3D mode_cmd-&gt;width / (i ? hsub : 1=
);
+               unsigned int height =3D mode_cmd-&gt;height / (i ? vsub :=
 1);
+               unsigned int min_size;
+
+               obj =3D drm_gem_object_lookup(dev, file_priv,
+                                           mode_cmd-&gt;handles[i]);
+               if (!obj) {
+                       dev_err(dev-&gt;dev, "Failed to lookup GEM object=
\n");
+                       ret =3D -ENXIO;
+                       goto err_gem_object_unreference;
+               }
+
+               min_size =3D (height - 1) * mode_cmd-&gt;pitches[i] +
+                       mode_cmd-&gt;offsets[i] +
+                       width * drm_format_plane_cpp(mode_cmd-&gt;pixel_f=
ormat, i);
+
+               if (obj-&gt;size &lt; min_size) {
+                       drm_gem_object_unreference_unlocked(obj);
+                       ret =3D -EINVAL;
+                       goto err_gem_object_unreference;
+               }
+               objs[i] =3D obj;
+       }
+
+       rockchip_fb =3D rockchip_fb_alloc(dev, mode_cmd, objs, i);
+       if (IS_ERR(rockchip_fb)) {
+               ret =3D PTR_ERR(rockchip_fb);
+               goto err_gem_object_unreference;
+       }
+
+       return &amp;rockchip_fb-&gt;fb;
+
+err_gem_object_unreference:
+       for (i--; i &gt;=3D 0; i--)
+               drm_gem_object_unreference_unlocked(objs[i]);
+       return ERR_PTR(ret);
+}
+
+static void rockchip_drm_output_poll_changed(struct drm_device *dev)
+{
+       struct rockchip_drm_private *private =3D dev-&gt;dev_private;
+       struct drm_fb_helper *fb_helper =3D private-&gt;fb_helper;
+
+       if (fb_helper)
+               drm_fb_helper_hotplug_event(fb_helper);
+}
+
+static const struct drm_mode_config_funcs rockchip_drm_mode_config_funcs=
 =3D {
+       .fb_create =3D rockchip_user_fb_create,
+       .output_poll_changed =3D rockchip_drm_output_poll_changed,
+};
+
+struct drm_framebuffer *
+rockchip_drm_framebuffer_init(struct drm_device *dev,
+                             struct drm_mode_fb_cmd2 *mode_cmd,
+                             struct drm_gem_object *obj)
+{
+       struct rockchip_drm_fb *rockchip_fb;
+
+       rockchip_fb =3D rockchip_fb_alloc(dev, mode_cmd, &amp;obj, 1);
+       if (IS_ERR(rockchip_fb))
+               return NULL;
+
+       return &amp;rockchip_fb-&gt;fb;
+}
+
+void rockchip_drm_mode_config_init(struct drm_device *dev)
+{
+       dev-&gt;mode_config.min_width =3D 0;
+       dev-&gt;mode_config.min_height =3D 0;
+
+       /*
+        * set max width and height as default value(4096x4096).
+        * this value would be used to check framebuffer size limitation
+        * at drm_mode_addfb().
+        */
+       dev-&gt;mode_config.max_width =3D 4096;
+       dev-&gt;mode_config.max_height =3D 4096;
+
+       dev-&gt;mode_config.funcs =3D &amp;rockchip_drm_mode_config_funcs=
;
+}
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_fb.h b/drivers/gpu/drm=
/rockchip/rockchip_drm_fb.h
new file mode 100644
index 0000000..09574d4
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_fb.h
@@ -0,0 +1,28 @@
+/*
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:Mark Yao <a class=3D"moz-txt-link-rfc2396E" href=3D"mailto:mar=
k.yao@rock-chips.com">&lt;mark.yao@rock-chips.com&gt;</a>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _ROCKCHIP_DRM_FB_H
+#define _ROCKCHIP_DRM_FB_H
+
+struct drm_framebuffer *
+rockchip_drm_framebuffer_init(struct drm_device *dev,
+                             struct drm_mode_fb_cmd2 *mode_cmd,
+                             struct drm_gem_object *obj);
+void rockchip_drm_framebuffer_fini(struct drm_framebuffer *fb);
+
+void rockchip_drm_mode_config_init(struct drm_device *dev);
+
+struct drm_gem_object *rockchip_fb_get_gem_obj(struct drm_framebuffer *f=
b,
+                                              unsigned int plane);
+#endif /* _ROCKCHIP_DRM_FB_H */
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c b/drivers/gpu/=
drm/rockchip/rockchip_drm_fbdev.c
new file mode 100644
index 0000000..ae563f5
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c
@@ -0,0 +1,230 @@
+/*
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:Mark Yao <a class=3D"moz-txt-link-rfc2396E" href=3D"mailto:mar=
k.yao@rock-chips.com">&lt;mark.yao@rock-chips.com&gt;</a>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include &lt;drm/drm.h&gt;
+#include &lt;drm/drmP.h&gt;
+#include &lt;drm/drm_fb_helper.h&gt;
+#include &lt;drm/drm_crtc_helper.h&gt;
+
+#include "rockchip_drm_drv.h"
+#include "rockchip_drm_gem.h"
+#include "rockchip_drm_fb.h"
+
+#define PREFERRED_BPP          32
+#define to_rockchip_fbdev(x) container_of(x, struct rockchip_fbdev, help=
er)
+
+struct rockchip_fbdev {
+       struct drm_fb_helper helper;
+       struct drm_gem_object *bo;
+};
+
+static int rockchip_fbdev_mmap(struct fb_info *info,
+                              struct vm_area_struct *vma)
+{
+       struct drm_fb_helper *helper =3D info-&gt;par;
+       struct rockchip_fbdev *fbdev =3D to_rockchip_fbdev(helper);
+
+       return rockchip_gem_mmap(fbdev-&gt;bo, vma);
+}
+
+static struct fb_ops rockchip_drm_fbdev_ops =3D {
+       .owner          =3D THIS_MODULE,
+       .fb_mmap        =3D rockchip_fbdev_mmap,
+       .fb_fillrect    =3D cfb_fillrect,
+       .fb_copyarea    =3D cfb_copyarea,
+       .fb_imageblit   =3D cfb_imageblit,
+       .fb_check_var   =3D drm_fb_helper_check_var,
+       .fb_set_par     =3D drm_fb_helper_set_par,
+       .fb_blank       =3D drm_fb_helper_blank,
+       .fb_pan_display =3D drm_fb_helper_pan_display,
+       .fb_setcmap     =3D drm_fb_helper_setcmap,
+};
+
+static int rockchip_drm_fbdev_create(struct drm_fb_helper *helper,
+                                    struct drm_fb_helper_surface_size *s=
izes)
+{
+       struct rockchip_fbdev *fbdev =3D to_rockchip_fbdev(helper);
+       struct drm_mode_fb_cmd2 mode_cmd =3D { 0 };
+       struct drm_device *dev =3D helper-&gt;dev;
+       struct rockchip_gem_object *rk_obj;
+       struct drm_framebuffer *fb;
+       unsigned int bytes_per_pixel;
+       unsigned long offset;
+       struct fb_info *fbi;
+       size_t size;
+       int ret;
+
+       bytes_per_pixel =3D DIV_ROUND_UP(sizes-&gt;surface_bpp, 8);
+
+       mode_cmd.width =3D sizes-&gt;surface_width;
+       mode_cmd.height =3D sizes-&gt;surface_height;
+       mode_cmd.pitches[0] =3D sizes-&gt;surface_width * bytes_per_pixel=
;
+       mode_cmd.pixel_format =3D drm_mode_legacy_fb_format(sizes-&gt;sur=
face_bpp,
+               sizes-&gt;surface_depth);
+
+       size =3D mode_cmd.pitches[0] * mode_cmd.height;
+
+       rk_obj =3D rockchip_gem_create_object(dev, size);
+       if (IS_ERR(rk_obj))
+               return -ENOMEM;
+
+       fbdev-&gt;bo =3D &amp;rk_obj-&gt;base;
+
+       fbi =3D framebuffer_alloc(0, dev-&gt;dev);
+       if (!fbi) {
+               dev_err(dev-&gt;dev, "Failed to allocate framebuffer info=
.\n");
+               ret =3D -ENOMEM;
+               goto err_rockchip_gem_free_object;
+       }
+
+       helper-&gt;fb =3D rockchip_drm_framebuffer_init(dev, &amp;mode_cm=
d, fbdev-&gt;bo);
+       if (IS_ERR(helper-&gt;fb)) {
+               dev_err(dev-&gt;dev, "Failed to allocate DRM framebuffer.=
\n");
+               ret =3D PTR_ERR(helper-&gt;fb);
+               goto err_framebuffer_release;
+       }
+
+       helper-&gt;fbdev =3D fbi;
+
+       fbi-&gt;par =3D helper;
+       fbi-&gt;flags =3D FBINFO_FLAG_DEFAULT;
+       fbi-&gt;fbops =3D &amp;rockchip_drm_fbdev_ops;
+
+       ret =3D fb_alloc_cmap(&amp;fbi-&gt;cmap, 256, 0);
+       if (ret) {
+               dev_err(dev-&gt;dev, "Failed to allocate color map.\n");
+               goto err_drm_framebuffer_unref;
+       }
+
+       fb =3D helper-&gt;fb;
+       drm_fb_helper_fill_fix(fbi, fb-&gt;pitches[0], fb-&gt;depth);
+       drm_fb_helper_fill_var(fbi, helper, fb-&gt;width, fb-&gt;height);
+
+       offset =3D fbi-&gt;var.xoffset * bytes_per_pixel;
+       offset +=3D fbi-&gt;var.yoffset * fb-&gt;pitches[0];
+
+       dev-&gt;mode_config.fb_base =3D 0;
+       fbi-&gt;screen_base =3D rk_obj-&gt;kvaddr + offset;
+       fbi-&gt;screen_size =3D rk_obj-&gt;base.size;
+       fbi-&gt;fix.smem_len =3D rk_obj-&gt;base.size;
+
+       DRM_DEBUG_KMS("FB [%dx%d]-%d kvaddr=3D%p offset=3D%ld size=3D%d\n=
",
+                     fb-&gt;width, fb-&gt;height, fb-&gt;depth, rk_obj-&=
gt;kvaddr,
+                     offset, size);
+       return 0;
+
+err_drm_framebuffer_unref:
+       drm_framebuffer_unreference(helper-&gt;fb);
+err_framebuffer_release:
+       framebuffer_release(fbi);
+err_rockchip_gem_free_object:
+       rockchip_gem_free_object(&amp;rk_obj-&gt;base);
+       return ret;
+}
+
+static struct drm_fb_helper_funcs rockchip_drm_fb_helper_funcs =3D {
+       .fb_probe =3D rockchip_drm_fbdev_create,
+};
+
+int rockchip_drm_fbdev_init(struct drm_device *dev)
+{
+       struct rockchip_drm_private *private =3D dev-&gt;dev_private;
+       struct rockchip_fbdev *fbdev;
+       struct drm_fb_helper *helper;
+       unsigned int num_crtc;
+       int ret;
+
+       if (!dev-&gt;mode_config.num_crtc || !dev-&gt;mode_config.num_con=
nector)
+               return -EINVAL;
+
+       if (private-&gt;fb_helper) {
+               DRM_ERROR("no allow to reinit fbdev\n");
+               return -EINVAL;
+       }
+
+       num_crtc =3D dev-&gt;mode_config.num_crtc;
+
+       fbdev =3D kzalloc(sizeof(*fbdev), GFP_KERNEL);
+       if (!fbdev)
+               return -ENOMEM;
+
+       fbdev-&gt;helper.funcs =3D &amp;rockchip_drm_fb_helper_funcs;
+       helper =3D &amp;fbdev-&gt;helper;
+
+       ret =3D drm_fb_helper_init(dev, helper, num_crtc, ROCKCHIP_MAX_CO=
NNECTOR);
+       if (ret &lt; 0) {
+               dev_err(dev-&gt;dev, "Failed to initialize drm fb helper.=
\n");
+               goto err_free;
+       }
+
+       ret =3D drm_fb_helper_single_add_all_connectors(helper);
+       if (ret &lt; 0) {
+               dev_err(dev-&gt;dev, "Failed to add connectors.\n");
+               goto err_drm_fb_helper_fini;
+       }
+
+       /* disable all the possible outputs/crtcs before entering KMS mod=
e */
+       drm_helper_disable_unused_functions(dev);
+
+       ret =3D drm_fb_helper_initial_config(helper, PREFERRED_BPP);
+       if (ret &lt; 0) {
+               dev_err(dev-&gt;dev, "Failed to set initial hw configurat=
ion.\n");
+               goto err_drm_fb_helper_fini;
+       }
+
+       private-&gt;fb_helper =3D helper;
+
+       return 0;
+
+err_drm_fb_helper_fini:
+       drm_fb_helper_fini(helper);
+err_free:
+       kfree(fbdev);
+       return ret;
+}
+
+void rockchip_drm_fbdev_fini(struct drm_device *dev)
+{
+       struct rockchip_drm_private *private =3D dev-&gt;dev_private;
+       struct drm_fb_helper *helper;
+       struct rockchip_fbdev *fbdev;
+
+       if (!private || !private-&gt;fb_helper)
+               return;
+
+       helper =3D private-&gt;fb_helper;
+       fbdev =3D to_rockchip_fbdev(helper);
+
+       if (helper-&gt;fbdev) {
+               struct fb_info *info;
+               int ret;
+
+               info =3D helper-&gt;fbdev;
+               ret =3D unregister_framebuffer(info);
+               if (ret &lt; 0)
+                       DRM_DEBUG_KMS("failed unregister_framebuffer()\n"=
);
+
+               if (info-&gt;cmap.len)
+                       fb_dealloc_cmap(&amp;info-&gt;cmap);
+
+               framebuffer_release(info);
+       }
+
+       if (helper-&gt;fb)
+               drm_framebuffer_unreference(helper-&gt;fb);
+
+       drm_fb_helper_fini(helper);
+       kfree(fbdev);
+       private-&gt;fb_helper =3D NULL;
+}
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h b/drivers/gpu/=
drm/rockchip/rockchip_drm_fbdev.h
new file mode 100644
index 0000000..5edcf6a
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h
@@ -0,0 +1,20 @@
+/*
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:Mark Yao <a class=3D"moz-txt-link-rfc2396E" href=3D"mailto:mar=
k.yao@rock-chips.com">&lt;mark.yao@rock-chips.com&gt;</a>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _ROCKCHIP_DRM_FBDEV_H
+#define _ROCKCHIP_DRM_FBDEV_H
+
+int rockchip_drm_fbdev_init(struct drm_device *dev);
+
+#endif /* _ROCKCHIP_DRM_FBDEV_H */
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c b/drivers/gpu/dr=
m/rockchip/rockchip_drm_gem.c
new file mode 100644
index 0000000..8e7a91c
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
@@ -0,0 +1,341 @@
+/*
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:Mark Yao <a class=3D"moz-txt-link-rfc2396E" href=3D"mailto:mar=
k.yao@rock-chips.com">&lt;mark.yao@rock-chips.com&gt;</a>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include &lt;drm/drm.h&gt;
+#include &lt;drm/drmP.h&gt;
+#include &lt;drm/drm_vma_manager.h&gt;
+
+#include &lt;linux/anon_inodes.h&gt;
+#include &lt;linux/dma-attrs.h&gt;
+
+#include "rockchip_drm_drv.h"
+#include "rockchip_drm_gem.h"
+
+static int rockchip_gem_alloc_buf(struct rockchip_gem_object *rk_obj)
+{
+       struct drm_gem_object *obj =3D &amp;rk_obj-&gt;base;
+       struct drm_device *drm =3D obj-&gt;dev;
+
+       init_dma_attrs(&amp;rk_obj-&gt;dma_attrs);
+       dma_set_attr(DMA_ATTR_WRITE_COMBINE, &amp;rk_obj-&gt;dma_attrs);
+
+       /* TODO(djkurtz): Use DMA_ATTR_NO_KERNEL_MAPPING except for fbdev=
 */
+       rk_obj-&gt;kvaddr =3D dma_alloc_attrs(drm-&gt;dev, obj-&gt;size,
+                                        &amp;rk_obj-&gt;dma_addr, GFP_KE=
RNEL,
+                                        &amp;rk_obj-&gt;dma_attrs);
+       if (IS_ERR(rk_obj-&gt;kvaddr)) {
+               int ret =3D PTR_ERR(rk_obj-&gt;kvaddr);
+
+               DRM_ERROR("failed to allocate %#x byte dma buffer, %d",
+                         obj-&gt;size, ret);
+               return ret;
+       }
+
+       return 0;
+}
+
+static void rockchip_gem_free_buf(struct rockchip_gem_object *rk_obj)
+{
+       struct drm_gem_object *obj =3D &amp;rk_obj-&gt;base;
+       struct drm_device *drm =3D obj-&gt;dev;
+
+       dma_free_attrs(drm-&gt;dev, obj-&gt;size, rk_obj-&gt;kvaddr, rk_o=
bj-&gt;dma_addr,
+                      &amp;rk_obj-&gt;dma_attrs);
+}
+
+/* drm driver mmap file operations */
+int rockchip_drm_gem_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+       struct drm_file *priv =3D filp-&gt;private_data;
+       struct drm_device *dev =3D priv-&gt;minor-&gt;dev;
+       struct drm_gem_object *obj;
+       struct drm_vma_offset_node *node;
+       int ret;
+
+       if (drm_device_is_unplugged(dev))
+               return -ENODEV;
+
+       mutex_lock(&amp;dev-&gt;struct_mutex);
+
+       node =3D drm_vma_offset_exact_lookup(dev-&gt;vma_offset_manager,
+                                          vma-&gt;vm_pgoff,
+                                          vma_pages(vma));
+       if (!node) {
+               mutex_unlock(&amp;dev-&gt;struct_mutex);
+               DRM_ERROR("failed to find vma node.\n");
+               return -EINVAL;
+       } else if (!drm_vma_node_is_allowed(node, filp)) {
+               mutex_unlock(&amp;dev-&gt;struct_mutex);
+               return -EACCES;
+       }
+
+       obj =3D container_of(node, struct drm_gem_object, vma_node);
+       ret =3D rockchip_gem_mmap(obj, vma);
+
+       mutex_unlock(&amp;dev-&gt;struct_mutex);
+
+       return ret;
+}
+
+int rockchip_drm_gem_mmap_buffer(struct file *filp,
+                                struct vm_area_struct *vma)
+{
+       struct drm_gem_object *obj =3D filp-&gt;private_data;
+
+       return rockchip_gem_mmap(obj, vma);
+}
+
+static const struct file_operations rockchip_drm_gem_fops =3D {
+       .mmap =3D rockchip_drm_gem_mmap_buffer,
+};
+
+struct rockchip_gem_object *
+       rockchip_gem_create_object(struct drm_device *drm, unsigned int s=
ize)
+{
+       struct rockchip_gem_object *rk_obj;
+       struct drm_gem_object *obj;
+       struct file *filp;
+       int ret;
+
+       size =3D round_up(size, PAGE_SIZE);
+
+       rk_obj =3D kzalloc(sizeof(*rk_obj), GFP_KERNEL);
+       if (!rk_obj)
+               return ERR_PTR(-ENOMEM);
+
+       obj =3D &amp;rk_obj-&gt;base;
+
+       drm_gem_private_object_init(drm, obj, size);
+
+       filp =3D anon_inode_getfile("rockchip_gem", &amp;rockchip_drm_gem=
_fops,
+                                 obj, 0);
+       if (IS_ERR(filp)) {
+               DRM_ERROR("failed to create anon file object.\n");
+               ret =3D PTR_ERR(filp);
+               goto err_free_rk_obj;
+       }
+       filp-&gt;f_mode =3D FMODE_READ | FMODE_WRITE;
+       obj-&gt;filp =3D filp;
+
+       ret =3D drm_gem_create_mmap_offset(obj);
+       if (ret)
+               goto err_free_obj;
+
+       ret =3D rockchip_gem_alloc_buf(rk_obj);
+       if (ret)
+               goto err_free_mmap_offset;
+
+       return rk_obj;
+
+err_free_mmap_offset:
+       drm_gem_free_mmap_offset(obj);
+err_free_obj:
+       drm_gem_object_release(obj);
+err_free_rk_obj:
+       kfree(rk_obj);
+       return ERR_PTR(ret);
+}
+
+/*
+ * rockchip_gem_free_object - (struct drm_driver)-&gt;gem_free_object ca=
llback
+ * function
+ */
+void rockchip_gem_free_object(struct drm_gem_object *obj)
+{
+       struct rockchip_gem_object *rk_obj;
+
+       drm_gem_free_mmap_offset(obj);
+
+       rk_obj =3D to_rockchip_obj(obj);
+
+       rockchip_gem_free_buf(rk_obj);
+       drm_gem_free_mmap_offset(obj);
+
+       drm_gem_object_release(obj);
+
+       kfree(rk_obj);
+}
+
+int rockchip_gem_mmap(struct drm_gem_object *obj, struct vm_area_struct =
*vma)
+{
+       struct rockchip_gem_object *rk_obj =3D to_rockchip_obj(obj);
+       struct drm_device *drm =3D obj-&gt;dev;
+       unsigned long vm_size;
+
+       vma-&gt;vm_flags |=3D VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
+       vm_size =3D vma-&gt;vm_end - vma-&gt;vm_start;
+
+       if (vm_size &gt; obj-&gt;size)
+               return -EINVAL;
+
+       return dma_mmap_attrs(drm-&gt;dev, vma, rk_obj-&gt;kvaddr, rk_obj=
-&gt;dma_addr,
+                            obj-&gt;size, &amp;rk_obj-&gt;dma_attrs);
+}
+
+/*
+ * rockchip_gem_create_with_handle - allocate an object with the given
+ * size and create a gem handle on it
+ *
+ * returns a struct rockchip_gem_object* on success or ERR_PTR values
+ * on failure.
+ */
+static struct rockchip_gem_object *
+rockchip_gem_create_with_handle(struct drm_file *file_priv,
+                               struct drm_device *drm, unsigned int size=
,
+                               unsigned int *handle)
+{
+       struct rockchip_gem_object *rk_obj;
+       struct drm_gem_object *obj;
+       int ret;
+
+       rk_obj =3D rockchip_gem_create_object(drm, size);
+       if (IS_ERR(rk_obj))
+               return NULL;
+
+       obj =3D &amp;rk_obj-&gt;base;
+
+       /*
+        * allocate a id of idr table where the obj is registered
+        * and handle has the id what user can see.
+        */
+       ret =3D drm_gem_handle_create(file_priv, obj, handle);
+       if (ret)
+               goto err_handle_create;
+
+       /* drop reference from allocate - handle holds it now. */
+       drm_gem_object_unreference_unlocked(obj);
+
+       return rk_obj;
+
+err_handle_create:
+       rockchip_gem_free_object(obj);
+
+       return ERR_PTR(ret);
+}
+
+int rockchip_gem_dumb_map_offset(struct drm_file *file_priv,
+                                struct drm_device *dev, uint32_t handle,
+                                uint64_t *offset)
+{
+       struct drm_gem_object *obj;
+       int ret =3D 0;
+
+       mutex_lock(&amp;dev-&gt;struct_mutex);
+
+       /*
+        * get offset of memory allocated for drm framebuffer.
+        * - this callback would be called by user application
+        * with DRM_IOCTL_MODE_MAP_DUMB command.
+        */
+
+       obj =3D drm_gem_object_lookup(dev, file_priv, handle);
+       if (!obj) {
+               DRM_ERROR("failed to lookup gem object.\n");
+               ret =3D -EINVAL;
+               goto unlock;
+       }
+
+       ret =3D drm_gem_create_mmap_offset(obj);
+       if (ret)
+               goto out;
+
+       *offset =3D drm_vma_node_offset_addr(&amp;obj-&gt;vma_node);
+       DRM_DEBUG_KMS("offset =3D 0x%lx\n", (unsigned long)*offset);
+
+out:
+       drm_gem_object_unreference(obj);
+unlock:
+       mutex_unlock(&amp;dev-&gt;struct_mutex);
+       return ret;
+}
+
+/*
+ * rockchip_gem_dumb_create - (struct drm_driver)-&gt;dumb_create callba=
ck
+ * function
+ *
+ * This aligns the pitch and size arguments to the minimum required. wra=
p
+ * this into your own function if you need bigger alignment.
+ */
+int rockchip_gem_dumb_create(struct drm_file *file_priv,
+                            struct drm_device *dev,
+                            struct drm_mode_create_dumb *args)
+{
+       struct rockchip_gem_object *rk_obj;
+       int min_pitch =3D DIV_ROUND_UP(args-&gt;width * args-&gt;bpp, 8);
+
+       if (args-&gt;pitch &lt; min_pitch)
+               args-&gt;pitch =3D min_pitch;
+
+       if (args-&gt;size &lt; args-&gt;pitch * args-&gt;height)
+               args-&gt;size =3D args-&gt;pitch * args-&gt;height;
+
+       rk_obj =3D rockchip_gem_create_with_handle(file_priv, dev, args-&=
gt;size,
+                                                &amp;args-&gt;handle);
+
+       return PTR_ERR_OR_ZERO(rk_obj);
+}
+
+/*
+ * Allocate a sg_table for this GEM object.
+ * Note: Both the table's contents, and the sg_table itself must be free=
d by
+ *       the caller.
+ * Returns a pointer to the newly allocated sg_table, or an ERR_PTR() er=
ror.
+ */
+struct sg_table *rockchip_gem_prime_get_sg_table(struct drm_gem_object *=
obj)
+{
+       struct rockchip_gem_object *rk_obj =3D to_rockchip_obj(obj);
+       struct drm_device *drm =3D obj-&gt;dev;
+       struct sg_table *sgt =3D NULL;
+       int ret;
+
+       sgt =3D kzalloc(sizeof(*sgt), GFP_KERNEL);
+       if (!sgt)
+               return ERR_PTR(-ENOMEM);
+
+       ret =3D dma_get_sgtable_attrs(drm-&gt;dev, sgt, rk_obj-&gt;kvaddr=
,
+                                   rk_obj-&gt;dma_addr, obj-&gt;size,
+                                   &amp;rk_obj-&gt;dma_attrs);
+       if (ret) {
+               DRM_ERROR("failed to allocate sgt, %d\n", ret);
+               kfree(sgt);
+               return ERR_PTR(ret);
+       }
+
+       return sgt;
+}
+
+void *rockchip_gem_prime_vmap(struct drm_gem_object *obj)
+{
+       struct rockchip_gem_object *rk_obj =3D to_rockchip_obj(obj);
+
+       return rk_obj-&gt;kvaddr;
+}
+
+void rockchip_gem_prime_vunmap(struct drm_gem_object *obj, void *vaddr)
+{
+       /* Nothing to do */
+}
+
+int rockchip_gem_prime_mmap(struct drm_gem_object *obj,
+                           struct vm_area_struct *vma)
+{
+       struct drm_device *dev =3D obj-&gt;dev;
+       int ret;
+
+       mutex_lock(&amp;dev-&gt;struct_mutex);
+       ret =3D drm_gem_mmap_obj(obj, obj-&gt;size, vma);
+       mutex_unlock(&amp;dev-&gt;struct_mutex);
+
+       return ret;
+}
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_gem.h b/drivers/gpu/dr=
m/rockchip/rockchip_drm_gem.h
new file mode 100644
index 0000000..e37b921
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_gem.h
@@ -0,0 +1,55 @@
+/*
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:Mark Yao <a class=3D"moz-txt-link-rfc2396E" href=3D"mailto:mar=
k.yao@rock-chips.com">&lt;mark.yao@rock-chips.com&gt;</a>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _ROCKCHIP_DRM_GEM_H
+#define _ROCKCHIP_DRM_GEM_H
+
+#define to_rockchip_obj(x) container_of(x, struct rockchip_gem_object, b=
ase)
+
+struct rockchip_gem_object {
+       struct drm_gem_object base;
+       unsigned int flags;
+
+       void *kvaddr;
+       dma_addr_t dma_addr;
+       struct dma_attrs dma_attrs;
+};
+
+struct sg_table *rockchip_gem_prime_get_sg_table(struct drm_gem_object *=
obj);
+struct drm_gem_object *
+rockchip_gem_prime_import_sg_table(struct drm_device *dev, size_t size,
+                                  struct sg_table *sgt);
+void *rockchip_gem_prime_vmap(struct drm_gem_object *obj);
+void rockchip_gem_prime_vunmap(struct drm_gem_object *obj, void *vaddr);
+int rockchip_gem_prime_mmap(struct drm_gem_object *obj,
+                           struct vm_area_struct *vma);
+
+/* drm driver mmap file operations */
+int rockchip_drm_gem_mmap(struct file *filp, struct vm_area_struct *vma)=
;
+
+/* mmap a gem object to userspace. */
+int rockchip_gem_mmap(struct drm_gem_object *obj, struct vm_area_struct =
*vma);
+
+struct rockchip_gem_object *
+       rockchip_gem_create_object(struct drm_device *drm, unsigned int s=
ize);
+
+void rockchip_gem_free_object(struct drm_gem_object *obj);
+
+int rockchip_gem_dumb_create(struct drm_file *file_priv,
+                            struct drm_device *dev,
+                            struct drm_mode_create_dumb *args);
+int rockchip_gem_dumb_map_offset(struct drm_file *file_priv,
+                                struct drm_device *dev, uint32_t handle,
+                                uint64_t *offset);
+#endif /* _ROCKCHIP_DRM_GEM_H */
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/gpu/dr=
m/rockchip/rockchip_drm_vop.c
new file mode 100644
index 0000000..24c3946
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -0,0 +1,1373 @@
+/*
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:Mark Yao <a class=3D"moz-txt-link-rfc2396E" href=3D"mailto:mar=
k.yao@rock-chips.com">&lt;mark.yao@rock-chips.com&gt;</a>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include &lt;drm/drm.h&gt;
+#include &lt;drm/drmP.h&gt;
+#include &lt;drm/drm_crtc.h&gt;
+#include &lt;drm/drm_crtc_helper.h&gt;
+
+#include &lt;linux/kernel.h&gt;
+#include &lt;linux/platform_device.h&gt;
+#include &lt;linux/clk.h&gt;
+#include &lt;linux/of.h&gt;
+#include &lt;linux/of_device.h&gt;
+#include &lt;linux/pm_runtime.h&gt;
+#include &lt;linux/component.h&gt;
+
+#include &lt;linux/reset.h&gt;
+#include &lt;linux/iommu.h&gt;
+#include &lt;linux/delay.h&gt;
+
+#include &lt;video/of_display_timing.h&gt;
+#include &lt;video/of_videomode.h&gt;
+
+#include "rockchip_drm_drv.h"
+#include "rockchip_drm_fbdev.h"
+#include "rockchip_drm_gem.h"
+#include "rockchip_drm_fb.h"
+#include "rockchip_drm_vop.h"
+
+#define VOP_DEFAULT_FRAMERATE  60
+#define VOP_MAX_WIN_SUPPORT    5
+#define VOP_DEFAULT_CURSOR     1
+#define VOP_REG(off, _mask, s) \
+               {.offset =3D off, \
+                .mask =3D _mask, \
+                .shift =3D s,}
+
+#define __REG_SET(x, off, mask, shift, v) \
+               vop_mask_write(x, off, (mask) &lt;&lt; shift, (v) &lt;&lt=
; shift)
+
+#define REG_SET(x, base, reg, v) \
+               __REG_SET(x, base + reg.offset, reg.mask, reg.shift, v)
+
+#define VOP_WIN_SET(x, win, name, v) \
+               REG_SET(x, win-&gt;base, win-&gt;phy-&gt;name, v)
+#define VOP_CTRL_SET(x, name, v) \
+               REG_SET(x, 0, (x)-&gt;data-&gt;ctrl-&gt;name, v)
+
+#define VOP_WIN_GET_YRGBADDR(ctx, win) \
+               vop_readl(ctx, win-&gt;base + win-&gt;phy-&gt;yrgb_mst.of=
fset)
+
+#define to_vop_ctx(x) container_of(x, struct vop_context, crtc)
+#define to_rockchip_plane(x) container_of(x, struct rockchip_plane, base=
)
+
+struct rockchip_plane {
+       int id;
+       struct drm_plane base;
+       const struct vop_win *win;
+       struct vop_context *ctx;
</pre>
      </blockquote>
      <pre wrap=3D"">
Isn't ctx just: to_vop_ctx(base-&gt;crtc)

</pre>
    </blockquote>
    OK. we can use to_vop_ctx(base-&gt;crtc) to get ctx.
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <blockquote type=3D"cite">
        <pre wrap=3D"">+
+       uint32_t pending_yrgb_mst;
+       struct drm_framebuffer *front_fb;
+       struct drm_framebuffer *pending_fb;
+       bool enabled;
+};
+
+struct vop_context {
+       struct device *dev;
+       struct drm_device *drm_dev;
+       struct drm_crtc crtc;
+       struct drm_pending_vblank_event *event;
+       struct vop_driver *drv;
+       unsigned int dpms;
+       unsigned int win_mask;
+       wait_queue_head_t wait_vsync_queue;
+       atomic_t wait_vsync_event;
+
+       struct workqueue_struct *vsync_wq;
+       struct work_struct vsync_work;
+
+       /* mutex vsync_ work */
+       struct mutex vsync_mutex;
+       bool vsync_work_pending;
+
+       struct vop_driver_data *data;
+
+       uint32_t *regsbak;
+       void __iomem *regs;
+
+       /* physical map length of vop register */
+       uint32_t len;
+
+       /* one time only one process allowed to config the register */
+       spinlock_t reg_lock;
+       /* lock vop irq reg */
+       spinlock_t irq_lock;
+
+       unsigned int irq;
+
+       /* vop AHP clk */
+       struct clk *hclk;
+       /* vop dclk */
+       struct clk *dclk;
+       /* vop share memory frequency */
+       struct clk *aclk;
+       uint32_t pixclock;
+
+       int pipe;
+       bool clk_on;
+};
+
+enum vop_data_format {
+       VOP_FMT_ARGB8888 =3D 0,
+       VOP_FMT_RGB888,
+       VOP_FMT_RGB565,
+       VOP_FMT_YUV420SP =3D 4,
+       VOP_FMT_YUV422SP,
+       VOP_FMT_YUV444SP,
+};
+
+struct vop_reg_data {
+       uint32_t offset;
+       uint32_t value;
+};
+
+struct vop_reg {
+       uint32_t offset;
+       uint32_t shift;
+       uint32_t mask;
+};
+
+struct vop_ctrl {
+       struct vop_reg standby;
+       struct vop_reg gate_en;
+       struct vop_reg mmu_en;
+       struct vop_reg rgb_en;
+       struct vop_reg edp_en;
+       struct vop_reg hdmi_en;
+       struct vop_reg mipi_en;
+       struct vop_reg out_mode;
+       struct vop_reg dither_down;
+       struct vop_reg dither_up;
+       struct vop_reg pin_pol;
+
+       struct vop_reg htotal_pw;
+       struct vop_reg hact_st_end;
+       struct vop_reg vtotal_pw;
+       struct vop_reg vact_st_end;
+       struct vop_reg hpost_st_end;
+       struct vop_reg vpost_st_end;
+};
+
+struct vop_win_phy {
+       const uint32_t *data_formats;
+       uint32_t nformats;
+
+       struct vop_reg enable;
+       struct vop_reg format;
+       struct vop_reg act_info;
+       struct vop_reg dsp_info;
+       struct vop_reg dsp_st;
+       struct vop_reg yrgb_mst;
+       struct vop_reg uv_mst;
+       struct vop_reg yrgb_vir;
+       struct vop_reg uv_vir;
+
+       struct vop_reg dst_alpha_ctl;
+       struct vop_reg src_alpha_ctl;
+};
+
+struct vop_win {
+       uint32_t base;
+       const struct vop_win_phy *phy;
+};
+
+struct vop_driver_data {
+       const void *init_table;
+       int table_size;
+       const struct vop_ctrl *ctrl;
+       const struct vop_win *win[VOP_MAX_WIN_SUPPORT];
+};
+
+static const uint32_t formats_01[] =3D {
+       DRM_FORMAT_XRGB8888,
+       DRM_FORMAT_ARGB8888,
+       DRM_FORMAT_RGB888,
+       DRM_FORMAT_RGB565,
+       DRM_FORMAT_NV12,
+       DRM_FORMAT_NV16,
+       DRM_FORMAT_NV24,
+};
+
+static const uint32_t formats_234[] =3D {
+       DRM_FORMAT_XRGB8888,
+       DRM_FORMAT_ARGB8888,
+       DRM_FORMAT_RGB888,
+       DRM_FORMAT_RGB565,
+};
+
+static const struct vop_win_phy win01_data =3D {
+       .data_formats =3D formats_01,
+       .nformats =3D ARRAY_SIZE(formats_01),
+       .enable =3D VOP_REG(WIN0_CTRL0, 0x1, 0),
+       .format =3D VOP_REG(WIN0_CTRL0, 0x7, 1),
+       .act_info =3D VOP_REG(WIN0_ACT_INFO, 0x1fff1fff, 0),
+       .dsp_info =3D VOP_REG(WIN0_DSP_INFO, 0x1fff1fff, 0),
+       .dsp_st =3D VOP_REG(WIN0_DSP_ST, 0x1fff1fff, 0),
+       .yrgb_mst =3D VOP_REG(WIN0_YRGB_MST, 0xffffffff, 0),
+       .uv_mst =3D VOP_REG(WIN0_CBR_MST, 0xffffffff, 0),
+       .yrgb_vir =3D VOP_REG(WIN0_VIR, 0x3fff, 0),
+       .uv_vir =3D VOP_REG(WIN0_VIR, 0x3fff, 16),
+       .src_alpha_ctl =3D VOP_REG(WIN0_SRC_ALPHA_CTRL, 0xff, 0),
+       .dst_alpha_ctl =3D VOP_REG(WIN0_DST_ALPHA_CTRL, 0xff, 0),
+};
+
+static const struct vop_win_phy win23_data =3D {
+       .data_formats =3D formats_234,
+       .nformats =3D ARRAY_SIZE(formats_234),
+       .enable =3D VOP_REG(WIN2_CTRL0, 0x1, 0),
+       .format =3D VOP_REG(WIN2_CTRL0, 0x7, 1),
+       .dsp_info =3D VOP_REG(WIN2_DSP_INFO0, 0x0fff0fff, 0),
+       .dsp_st =3D VOP_REG(WIN2_DSP_ST0, 0x1fff1fff, 0),
+       .yrgb_mst =3D VOP_REG(WIN2_MST0, 0xffffffff, 0),
+       .yrgb_vir =3D VOP_REG(WIN2_VIR0_1, 0x1fff, 0),
+       .src_alpha_ctl =3D VOP_REG(WIN2_SRC_ALPHA_CTRL, 0xff, 0),
+       .dst_alpha_ctl =3D VOP_REG(WIN2_DST_ALPHA_CTRL, 0xff, 0),
+};
+
+static const struct vop_win_phy cursor_data =3D {
+       .data_formats =3D formats_234,
+       .nformats =3D ARRAY_SIZE(formats_234),
+       .enable =3D VOP_REG(HWC_CTRL0, 0x1, 0),
+       .format =3D VOP_REG(HWC_CTRL0, 0x7, 1),
+       .dsp_st =3D VOP_REG(HWC_DSP_ST, 0x1fff1fff, 0),
+       .yrgb_mst =3D VOP_REG(HWC_MST, 0xffffffff, 0),
+};
+
+static const struct vop_win win0 =3D {
+       .base =3D 0,
+       .phy =3D &amp;win01_data,
+};
+
+static const struct vop_win win1 =3D {
+       .base =3D 0x40,
+       .phy =3D &amp;win01_data,
+};
+
+static const struct vop_win win2 =3D {
+       .base =3D 0,
+       .phy =3D &amp;win23_data,
+};
+
+static const struct vop_win win3 =3D {
+       .base =3D 0x50,
+       .phy =3D &amp;win23_data,
+};
+
+static const struct vop_win win_cursor =3D {
+       .base =3D 0,
+       .phy =3D &amp;cursor_data,
+};
+
+static const struct vop_ctrl ctrl_data =3D {
+       .standby =3D VOP_REG(SYS_CTRL, 0x1, 22),
+       .gate_en =3D VOP_REG(SYS_CTRL, 0x1, 23),
+       .mmu_en =3D VOP_REG(SYS_CTRL, 0x1, 20),
+       .rgb_en =3D VOP_REG(SYS_CTRL, 0x1, 12),
+       .hdmi_en =3D VOP_REG(SYS_CTRL, 0x1, 13),
+       .edp_en =3D VOP_REG(SYS_CTRL, 0x1, 14),
+       .mipi_en =3D VOP_REG(SYS_CTRL, 0x1, 15),
+       .dither_down =3D VOP_REG(DSP_CTRL1, 0xf, 1),
+       .dither_up =3D VOP_REG(DSP_CTRL1, 0x1, 6),
+       .out_mode =3D VOP_REG(DSP_CTRL0, 0xf, 0),
+       .pin_pol =3D VOP_REG(DSP_CTRL0, 0xf, 4),
+       .htotal_pw =3D VOP_REG(DSP_HTOTAL_HS_END, 0x1fff1fff, 0),
+       .hact_st_end =3D VOP_REG(DSP_HACT_ST_END, 0x1fff1fff, 0),
+       .vtotal_pw =3D VOP_REG(DSP_VTOTAL_VS_END, 0x1fff1fff, 0),
+       .vact_st_end =3D VOP_REG(DSP_VACT_ST_END, 0x1fff1fff, 0),
+       .hpost_st_end =3D VOP_REG(POST_DSP_HACT_INFO, 0x1fff1fff, 0),
+       .vpost_st_end =3D VOP_REG(POST_DSP_VACT_INFO, 0x1fff1fff, 0),
+};
+
+static const struct vop_reg_data vop_init_reg_table[] =3D {
+       {SYS_CTRL, 0x00801000},
+       {DSP_CTRL0, 0x00000000},
+       {WIN0_CTRL0, 0x00000080},
+       {WIN1_CTRL0, 0x00000080},
+};
+
+static const struct vop_driver_data rockchip_rk3288_vop =3D {
+       .init_table =3D vop_init_reg_table,
+       .table_size =3D ARRAY_SIZE(vop_init_reg_table),
+       .ctrl =3D &amp;ctrl_data,
+       .win[0] =3D &amp;win0,
+       .win[1] =3D &amp;win1,
+       .win[2] =3D &amp;win2,
+       .win[3] =3D &amp;win3,
+       .win[4] =3D &amp;win_cursor,
+};
+
+static const struct of_device_id vop_driver_dt_match[] =3D {
+       { .compatible =3D "rockchip,rk3288-vop",
+         .data =3D (void *)&amp;rockchip_rk3288_vop },
+       {},
+};
+
+static inline void vop_writel(struct vop_context *ctx,
+                             uint32_t offset, uint32_t v)
+{
+       writel(v, ctx-&gt;regs + offset);
+       ctx-&gt;regsbak[offset &gt;&gt; 2] =3D v;
+}
+
+static inline uint32_t vop_readl(struct vop_context *ctx, uint32_t offse=
t)
+{
+       return readl(ctx-&gt;regs + offset);
+}
+
+static inline void vop_cfg_done(struct vop_context *ctx)
+{
+       writel(0x01, ctx-&gt;regs + REG_CFG_DONE);
+}
+
+static inline void vop_mask_write(struct vop_context *ctx,
+                                 uint32_t offset, uint32_t mask, uint32_=
t v)
+{
+       if (mask) {
+               uint32_t cached_val =3D ctx-&gt;regsbak[offset &gt;&gt; 2=
];
+
+               cached_val =3D (cached_val &amp; ~mask) | v;
+               writel(cached_val, ctx-&gt;regs + offset);
+               ctx-&gt;regsbak[offset &gt;&gt; 2] =3D cached_val;
+       }
+}
+
+static inline struct vop_driver_data *vop_get_driver_data(struct device =
*dev)
+{
+       const struct of_device_id *of_id =3D
+                       of_match_device(vop_driver_dt_match, dev);
+
+       return (struct vop_driver_data *)of_id-&gt;data;
+}
+
+static enum vop_data_format vop_convert_format(uint32_t format)
+{
+       switch (format) {
+       case DRM_FORMAT_XRGB8888:
+       case DRM_FORMAT_ARGB8888:
+               return VOP_FMT_ARGB8888;
+       case DRM_FORMAT_RGB888:
+               return VOP_FMT_RGB888;
+       case DRM_FORMAT_RGB565:
+               return VOP_FMT_RGB565;
+       case DRM_FORMAT_NV12:
+               return VOP_FMT_YUV420SP;
+       case DRM_FORMAT_NV16:
+               return VOP_FMT_YUV422SP;
+       case DRM_FORMAT_NV24:
+               return VOP_FMT_YUV444SP;
+       default:
+               DRM_ERROR("unsupport format[%08x]\n", format);
+               return -EINVAL;
+       }
+}
+
+static bool is_alpha_support(uint32_t format)
+{
+       switch (format) {
+       case DRM_FORMAT_ARGB8888:
+               return true;
+       default:
+               return false;
+       }
+}
+
+/* TODO(djkurtz): move generic 'setup slave rk_iommu' code somewhere com=
mon */
+int vop_iommu_init(struct vop_context *ctx)
+{
+       struct device *dev =3D ctx-&gt;dev;
+       struct device_node *np =3D dev-&gt;of_node;
+       struct platform_device *pd;
+       int count;
+       int ret;
+       struct of_phandle_args args;
+
+       /* Each VOP must have exactly one iommu node, with no args */
+       count =3D of_count_phandle_with_args(np, "iommus", "#iommu-cells"=
);
+       if (count !=3D 1) {
+               dev_err(dev, "of_count_phandle_with_args(%s) =3D&gt; %d\n=
",
+                       np-&gt;full_name, count);
+               return -EINVAL;
+       }
+
+       ret =3D of_parse_phandle_with_args(np, "iommus", "#iommu-cells", =
0,
+                                        &amp;args);
+       if (ret) {
+               dev_err(dev, "of_parse_phandle_with_args(%s) =3D&gt; %d\n=
",
+                       np-&gt;full_name, ret);
+               return ret;
+       }
+       if (args.args_count !=3D 0) {
+               dev_err(dev, "incorrect number of iommu params found for =
%s (found %d, expected 0)\n",
+                       args.np-&gt;full_name, args.args_count);
+               return -EINVAL;
+       }
+
+       pd =3D of_find_device_by_node(args.np);
+       of_node_put(args.np);
+       if (!pd) {
+               dev_err(dev, "iommu %s not found\n", args.np-&gt;full_nam=
e);
+               return -EPROBE_DEFER;
+       }
+
+       /* TODO(djkurtz): handle multiple slave iommus for a single maste=
r */
+       dev-&gt;archdata.iommu =3D &amp;pd-&gt;dev;
+
+       ret =3D rockchip_drm_dma_attach_device(ctx-&gt;drm_dev, dev);
+       if (ret) {
+               dev_err(dev, "failed to attach to drm dma mapping, %d\n",=
 ret);
+               return ret;
+       }
+
+       return 0;
+}
+
+static void vop_iommu_fini(struct vop_context *ctx)
+{
+       rockchip_drm_dma_detach_device(ctx-&gt;drm_dev, ctx-&gt;dev);
+}
+
+static int rockchip_plane_get_size(int start, unsigned length, unsigned =
last)
</pre>
      </blockquote>
      <pre wrap=3D"">
This function can use some documentation to define the variables which ar=
e
somewhat misleadingly named:
  start:  starting pixel in screen coordinates
  length: length of buffer "row" in pixels
  end:    one pixel past end of buffer in screen coordinates
  last:   width of screen, or one pixel past end of screen
  size:   number of pixels of buffer to display on screen

</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+{
+       int end =3D start + length;
+       int size =3D 0;
+
+       if (start &lt;=3D 0) {
+               if (end &gt; 0)
+                       size =3D min_t(unsigned, end, last);
+       } else if (start &lt;=3D last) {
</pre>
      </blockquote>
      <pre wrap=3D"">
  start &lt; last

/* if (start =3D=3D last), we are starting 1 pixel past the end of the sc=
reen,
   so no need to compute size :-), it will be 0. */
</pre>
    </blockquote>
    right, got it.<br>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+               size =3D min_t(unsigned, last - st=
art, length);
+       }
+
+       return size;
+}
+
+static int vop_clk_enable(struct vop_context *ctx)
+{
+       int ret;
+
+       if (!ctx-&gt;clk_on) {
+               ret =3D clk_prepare_enable(ctx-&gt;hclk);
</pre>
      </blockquote>
      <pre wrap=3D"">
I saw a code review recently that suggested to do
"clk_prepare/_unprepare()" in probe()/remove(), and just do
clk_enable()/clk_disable() at runtime.
</pre>
    </blockquote>
    so , vop_clk_enable is called by probe() and runtime, <br>
    OK, I will change "clk_prepare/_unprepare()"
    / to "clk_enable()/clk_disable()"
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+               if (ret &lt; 0) {
+                       dev_err(ctx-&gt;dev, "failed to enable hclk\n");
+                       return ret;
+               }
+
+               ret =3D clk_prepare_enable(ctx-&gt;dclk);
+               if (ret &lt; 0) {
+                       dev_err(ctx-&gt;dev, "failed to enable dclk\n");
+                       goto err_dclk;
+               }
+
+               ret =3D clk_prepare_enable(ctx-&gt;aclk);
+               if (ret &lt; 0) {
+                       dev_err(ctx-&gt;dev, "failed to enable aclk\n");
+                       goto err_aclk;
+               }
+               ctx-&gt;clk_on =3D true;
+       }
+
+       return ret;
+err_aclk:
+       clk_disable_unprepare(ctx-&gt;aclk);
</pre>
      </blockquote>
      <pre wrap=3D"">
this should be dclk</pre>
    </blockquote>
    Oh, yes, mistake...<br>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">

</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+err_dclk:
+       clk_disable_unprepare(ctx-&gt;hclk);
+       return ret;
+}
+
+static void vop_clk_disable(struct vop_context *ctx)
+{
+       if (ctx-&gt;clk_on) {
+               clk_disable_unprepare(ctx-&gt;dclk);
+               clk_disable_unprepare(ctx-&gt;hclk);
+               clk_disable_unprepare(ctx-&gt;aclk);
</pre>
      </blockquote>
      <pre wrap=3D"">
disable in inverse order from enable:

aclk
dclk
hclk
</pre>
    </blockquote>
    OK.<br>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+               ctx-&gt;clk_on =3D false;
+       }
+}
+
+static void vop_power_on(struct vop_context *ctx)
+{
+       if (vop_clk_enable(ctx) &lt; 0) {
+               dev_err(ctx-&gt;dev, "failed to enable clks\n");
+               return;
+       }
+
+       spin_lock(&amp;ctx-&gt;reg_lock);
+
+       VOP_CTRL_SET(ctx, standby, 0);
+
+       spin_unlock(&amp;ctx-&gt;reg_lock);
+}
+
+static void vop_power_off(struct vop_context *ctx)
+{
+       spin_lock(&amp;ctx-&gt;reg_lock);
+
+       VOP_CTRL_SET(ctx, standby, 1);
+
+       spin_unlock(&amp;ctx-&gt;reg_lock);
+
+       vop_clk_disable(ctx);
+}
+
+static int rockchip_update_plane(struct drm_plane *plane, struct drm_crt=
c *crtc,
+                                struct drm_framebuffer *fb, int crtc_x,
+                                int crtc_y, unsigned int crtc_w,
+                                unsigned int crtc_h, uint32_t src_x,
+                                uint32_t src_y, uint32_t src_w, uint32_t=
 src_h)
+{
+       struct rockchip_plane *rockchip_plane =3D to_rockchip_plane(plane=
);
+       const struct vop_win *win =3D rockchip_plane-&gt;win;
+       struct vop_context *ctx =3D to_vop_ctx(crtc);
+       struct drm_gem_object *obj;
+       struct rockchip_gem_object *rk_obj;
+       unsigned long offset;
+       unsigned int actual_w;
+       unsigned int actual_h;
+       unsigned int dsp_stx;
+       unsigned int dsp_sty;
+       unsigned int y_vir_stride;
+       dma_addr_t yrgb_mst;
+       enum vop_data_format format;
+       uint32_t val;
+       bool is_alpha;
+
+       if (!win) {
+               DRM_ERROR("can't find win data for vop, failed\n");
+               return -EINVAL;
+       }
</pre>
      </blockquote>
      <pre wrap=3D"">
There should be no need for this error checking.
</pre>
    </blockquote>
    right, rockchip_plane always has a vop_win, no need check here, I
    will remove the check.<br>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+
+       obj =3D rockchip_fb_get_gem_obj(fb, 0);
+       if (!obj) {
+               DRM_ERROR("fail to get rockchip gem object from framebuff=
er\n");
+               return -EINVAL;
+       }
</pre>
      </blockquote>
      <pre wrap=3D"">
Nor this.

</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+
+       rk_obj =3D to_rockchip_obj(obj);
+
+       yrgb_mst =3D rk_obj-&gt;dma_addr;
+       if (yrgb_mst &lt;=3D 0)
+               return -ENOMEM;
</pre>
      </blockquote>
      <pre wrap=3D"">
Nor this:
I don't think dma_addr_t can be less than 0.
Also, dma_addr_t =3D=3D 0 could be a valid iova.
</pre>
    </blockquote>
    right.<br>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">
src_* are actually 16.16 fixed point 'subpixel' units, but crtc_x is in p=
ixels.

However, since you aren't implementing sub-pixel positioning, you can do:

 if (src_x &amp; 0xffff || src_y &amp; 0xffff || src_w &amp; 0xffff || sr=
c_h &amp; 0xffff)
    return -EINVAL;

And, since you aren't implementing plane scaling:

 src_w &gt;&gt;=3D 16;
 src_h &gt;&gt;=3D 16;
 src_x &gt;&gt;=3D 16;
 src_y &gt;&gt;=3D 16;

 if (crtc_w !=3D src_w || crtc_h !=3D src_h)
   return -EINVAL;
</pre>
    </blockquote>
    OK, got it.<br>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+
+       actual_w =3D rockchip_plane_get_size(crtc_x,
+                                          crtc_w, crtc-&gt;mode.hdisplay=
);
+       actual_h =3D rockchip_plane_get_size(crtc_y,
+                                          crtc_h, crtc-&gt;mode.vdisplay=
);
</pre>
      </blockquote>
      <pre wrap=3D"">
crtc_w and crtc_h seem to imply the width &amp; height of the crtc, but
really they are they are
desired width and height of the framebuffer in crtc pixel units.

actual_w and actual_h are the number of pixels of this framebuffer that w=
ill
actually be shown on the crtc.  What happens if one of them is 0?  Perhap=
s we
should just return -EINVAL.  Otherwise you might compute -1 below when se=
tting
act_info/dsp_info, and end up programming a very large number.
</pre>
    </blockquote>
    correct, got it.<br>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+       if (crtc_x &lt; 0) {
+               if (actual_w)
+                       src_x -=3D crtc_x;
+               crtc_x =3D 0;
+       }
+
+       if (crtc_y &lt; 0) {
+               if (actual_h)
+                       src_y -=3D crtc_y;
+               crtc_y =3D 0;
+       }
+
+       dsp_stx =3D crtc_x + crtc-&gt;mode.htotal - crtc-&gt;mode.hsync_s=
tart;
+       dsp_sty =3D crtc_y + crtc-&gt;mode.vtotal - crtc-&gt;mode.vsync_s=
tart;
</pre>
      </blockquote>
      <pre wrap=3D"">
The additions herer are because you have the vblank at the beginning
of the frame.
Can you simplify this by moving vblank to the end of the frame? (see belo=
w)

</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+
+       offset =3D src_x * (fb-&gt;bits_per_pixel &gt;&gt; 3);
+       offset +=3D src_y * fb-&gt;pitches[0];
+
+       y_vir_stride =3D fb-&gt;pitches[0] / (fb-&gt;bits_per_pixel &gt;&=
gt; 3);
+       is_alpha =3D is_alpha_support(fb-&gt;pixel_format);
+       format =3D vop_convert_format(fb-&gt;pixel_format);
</pre>
      </blockquote>
      <pre wrap=3D"">
This function would return &lt; 0 if the format not supported. Check this=
 earlier.
Although, it should not be possible to get an invalid format, since it is
already verified by drm core.
</pre>
    </blockquote>
    OK. got it.<br>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+
+       spin_lock(&amp;ctx-&gt;reg_lock);
+
+       VOP_WIN_SET(ctx, win, format, format);
+       VOP_WIN_SET(ctx, win, yrgb_vir, y_vir_stride);
+       yrgb_mst +=3D offset;
+       VOP_WIN_SET(ctx, win, yrgb_mst, yrgb_mst);
+       VOP_WIN_SET(ctx, win, act_info,
+                   ((actual_h - 1) &lt;&lt; 16) | (actual_w - 1));
</pre>
      </blockquote>
      <pre wrap=3D"">
Nit: You should probably be masking the individual h/w fields to 13-bits =
each
before or'ing them together.
Same with dsp_st.
</pre>
    </blockquote>
    OK, got it.<br>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+       VOP_WIN_SET(ctx, win, dsp_info,
+                   ((actual_h - 1) &lt;&lt; 16) | (actual_w - 1));
+       VOP_WIN_SET(ctx, win, dsp_st, (dsp_sty &lt;&lt; 16) | dsp_stx);
+       if (is_alpha) {
+               VOP_WIN_SET(ctx, win, dst_alpha_ctl,
+                           DST_FACTOR_M0(ALPHA_SRC_INVERSE));
+               val =3D SRC_ALPHA_EN(1) | SRC_COLOR_M0(ALPHA_SRC_PRE_MUL)=
 |
+                       SRC_ALPHA_M0(ALPHA_STRAIGHT) |
+                       SRC_BLEND_M0(ALPHA_PER_PIX) |
+                       SRC_ALPHA_CAL_M0(ALPHA_NO_SATURATION) |
+                       SRC_FACTOR_M0(ALPHA_ONE);
+               VOP_WIN_SET(ctx, win, src_alpha_ctl, val);
+       } else {
+               VOP_WIN_SET(ctx, win, src_alpha_ctl, SRC_ALPHA_EN(0));
+       }
+
+       VOP_WIN_SET(ctx, win, enable, 1);
+
+       spin_unlock(&amp;ctx-&gt;reg_lock);
+
+       mutex_lock(&amp;ctx-&gt;vsync_mutex);
+
+       /*
+        * Because the buffer set to vop take effect at frame start time,
+        * we need make sure old buffer is not in use before we release
+        * it.
+        * reference the framebuffer, and unference it when it swap out o=
f vop.
+        */
+       if (fb !=3D rockchip_plane-&gt;front_fb) {
+               drm_framebuffer_reference(fb);
+               rockchip_plane-&gt;pending_fb =3D fb;
+               rockchip_plane-&gt;pending_yrgb_mst =3D yrgb_mst;
+               ctx-&gt;vsync_work_pending =3D true;
+       }
+       rockchip_plane-&gt;enabled =3D true;
+
+       mutex_unlock(&amp;ctx-&gt;vsync_mutex);
+
+       spin_lock(&amp;ctx-&gt;reg_lock);
+       vop_cfg_done(ctx);
+       spin_unlock(&amp;ctx-&gt;reg_lock);
+
+       return 0;
+}
+
+static int rockchip_disable_plane(struct drm_plane *plane)
+{
+       struct rockchip_plane *rockchip_plane =3D to_rockchip_plane(plane=
);
+       struct vop_context *ctx =3D rockchip_plane-&gt;ctx;
+       const struct vop_win *win =3D rockchip_plane-&gt;win;
+
+       spin_lock(&amp;ctx-&gt;reg_lock);
+
+       VOP_WIN_SET(ctx, win, enable, 0);
+       vop_cfg_done(ctx);
+
+       spin_unlock(&amp;ctx-&gt;reg_lock);
+
+       mutex_lock(&amp;ctx-&gt;vsync_mutex);
+
+       /*
+       * clear the pending framebuffer and set vsync_work_pending true,
+       * so that the framebuffer will unref at the next vblank.
+       */
+       if (rockchip_plane-&gt;pending_fb) {
+               drm_framebuffer_unreference(rockchip_plane-&gt;pending_fb=
);
+               rockchip_plane-&gt;pending_fb =3D NULL;
+       }
+
+       rockchip_plane-&gt;enabled =3D false;
+       ctx-&gt;vsync_work_pending =3D true;
+
+       mutex_unlock(&amp;ctx-&gt;vsync_mutex);
+
+       return 0;
+}
+
+static void rockchip_plane_destroy(struct drm_plane *plane)
+{
+       struct rockchip_plane *rockchip_plane =3D to_rockchip_plane(plane=
);
+       struct vop_context *ctx =3D rockchip_plane-&gt;ctx;
+
+       rockchip_disable_plane(plane);
+       drm_plane_cleanup(plane);
+       ctx-&gt;win_mask &amp;=3D ~(1 &lt;&lt; rockchip_plane-&gt;id);
+       kfree(rockchip_plane);
+}
+
+static const struct drm_plane_funcs rockchip_plane_funcs =3D {
+       .update_plane =3D rockchip_update_plane,
+       .disable_plane =3D rockchip_disable_plane,
+       .destroy =3D rockchip_plane_destroy,
+};
+
+struct drm_plane *rockchip_plane_init(struct vop_context *ctx,
+                                     unsigned long possible_crtcs,
+                                     enum drm_plane_type type)
+{
+       struct rockchip_plane *rockchip_plane;
+       struct vop_driver_data *vop_data =3D ctx-&gt;data;
+       const struct vop_win *win;
+       int i;
+       int err;
+
+       rockchip_plane =3D kzalloc(sizeof(*rockchip_plane), GFP_KERNEL);
+       if (!rockchip_plane)
+               return NULL;
</pre>
      </blockquote>
      <pre wrap=3D"">
Let's propagate errors from this function, like this...

return ERR_PTR(-ENOMEM);
</pre>
    </blockquote>
    OK.<br>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+
+       for (i =3D 0; i &lt; VOP_MAX_WIN_SUPPORT; i++) {
+               if (!(ctx-&gt;win_mask &amp; (1 &lt;&lt; i))) {
+                       win =3D vop_data-&gt;win[i];
+                       break;
+               }
+       }
</pre>
      </blockquote>
      <pre wrap=3D"">
The caller already knows for which window index they are init'ing the pla=
ne.
Just have the caller pass it in.
</pre>
    </blockquote>
    OK.<br>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+
+       if (VOP_MAX_WIN_SUPPORT =3D=3D i) {
+               DRM_ERROR("failed to find win\n");
+               kfree(rockchip_plane);
+               return NULL;
+       }
+
+       ctx-&gt;win_mask |=3D (1 &lt;&lt; i);
+       rockchip_plane-&gt;id =3D i;
+       rockchip_plane-&gt;win =3D win;
+       rockchip_plane-&gt;ctx =3D ctx;
+
+       err =3D drm_universal_plane_init(ctx-&gt;drm_dev, &amp;rockchip_p=
lane-&gt;base,
+                                      possible_crtcs, &amp;rockchip_plan=
e_funcs,
+                                      win-&gt;phy-&gt;data_formats,
+                                      win-&gt;phy-&gt;nformats, type);
+       if (err) {
+               DRM_ERROR("failed to initialize plane\n");
+               kfree(rockchip_plane);
+               return NULL;
</pre>
      </blockquote>
      <pre wrap=3D"">
return ERR_PTR(err);
</pre>
    </blockquote>
    OK.<br>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+       }
+
+       return &amp;rockchip_plane-&gt;base;
+}
+
+int rockchip_drm_crtc_enable_vblank(struct drm_device *dev, int pipe)
+{
+       struct vop_context *ctx =3D to_vop_ctx(rockchip_find_crtc(dev, pi=
pe));
+       unsigned long flags;
+
+       if (ctx-&gt;dpms !=3D DRM_MODE_DPMS_ON)
+               return -EPERM;
+
+       spin_lock_irqsave(&amp;ctx-&gt;irq_lock, flags);
+
+       vop_mask_write(ctx, INTR_CTRL0, LINE_FLAG_INTR_MASK,
+                      LINE_FLAG_INTR_EN(1));
+
+       spin_unlock_irqrestore(&amp;ctx-&gt;irq_lock, flags);
+
+       return 0;
+}
+
+void rockchip_drm_crtc_disable_vblank(struct drm_device *dev, int pipe)
+{
+       struct vop_context *ctx =3D to_vop_ctx(rockchip_find_crtc(dev, pi=
pe));
+       unsigned long flags;
+
+       if (ctx-&gt;dpms !=3D DRM_MODE_DPMS_ON)
+               return;
+       spin_lock_irqsave(&amp;ctx-&gt;irq_lock, flags);
+       vop_mask_write(ctx, INTR_CTRL0, LINE_FLAG_INTR_MASK,
+                      LINE_FLAG_INTR_EN(0));
+       spin_unlock_irqrestore(&amp;ctx-&gt;irq_lock, flags);
+}
+
+static void rockchip_drm_crtc_dpms(struct drm_crtc *crtc, int mode)
+{
+       struct vop_context *ctx =3D to_vop_ctx(crtc);
+
+       DRM_DEBUG_KMS("crtc[%d] mode[%d]\n", crtc-&gt;base.id, mode);
+
+       if (ctx-&gt;dpms =3D=3D mode) {
+               DRM_DEBUG_KMS("desired dpms mode is same as previous one.=
\n");
+               return;
+       }
+       if (mode &gt; DRM_MODE_DPMS_ON) {
+               /* wait for the completion of page flip. */
+               if (!wait_event_timeout(ctx-&gt;wait_vsync_queue,
+                                       !atomic_read(&amp;ctx-&gt;wait_vs=
ync_event),
+                                       HZ/20))
+                       DRM_DEBUG_KMS("vblank wait timed out.\n");
+               drm_vblank_off(crtc-&gt;dev, ctx-&gt;pipe);
+       }
+
+       switch (mode) {
+       case DRM_MODE_DPMS_ON:
+               vop_power_on(ctx);
+               break;
+       case DRM_MODE_DPMS_STANDBY:
+       case DRM_MODE_DPMS_SUSPEND:
+       case DRM_MODE_DPMS_OFF:
+               vop_power_off(ctx);
+               break;
+       default:
+               DRM_DEBUG_KMS("unspecified mode %d\n", mode);
+               break;
+       }
+
+       ctx-&gt;dpms =3D mode;
+}
+
+static void rockchip_drm_crtc_prepare(struct drm_crtc *crtc)
+{
+       rockchip_drm_crtc_dpms(crtc, DRM_MODE_DPMS_ON);
+}
+
+static bool rockchip_drm_crtc_mode_fixup(struct drm_crtc *crtc,
+                                        const struct drm_display_mode *m=
ode,
+                                        struct drm_display_mode *adjuste=
d_mode)
+{
+       /* just do dummy now */
+
+       return true;
+}
+
+static int rockchip_drm_crtc_mode_set_base(struct drm_crtc *crtc, int x,=
 int y,
+                                          struct drm_framebuffer *old_fb=
);
+
+static int rockchip_drm_crtc_mode_set(struct drm_crtc *crtc,
+                                     struct drm_display_mode *mode,
+                                     struct drm_display_mode *adjusted_m=
ode,
+                                     int x, int y,
+                                     struct drm_framebuffer *fb)
+{
+       struct vop_context *ctx =3D to_vop_ctx(crtc);
+       u16 hsync_len =3D adjusted_mode-&gt;hsync_end - adjusted_mode-&gt=
;hsync_start;
+       u16 left_margin =3D adjusted_mode-&gt;htotal - adjusted_mode-&gt;=
hsync_end;
+       u16 vsync_len =3D adjusted_mode-&gt;vsync_end - adjusted_mode-&gt=
;vsync_start;
+       u16 upper_margin =3D adjusted_mode-&gt;vtotal - adjusted_mode-&gt=
;vsync_end;
</pre>
      </blockquote>
      <pre wrap=3D"">
This moves the vblank/hblank to the front of the frame rather than the en=
d.
Is that necessary on this hardware?
If you leave the active area origin at (0,0), it makes it a little bit si=
mpler
to locate overlays.
</pre>
    </blockquote>
    in fact, the hardware define is different with drm_display_mode
    define:<br>
    drm_display_mode define that:<br>
    =C2=A0=C2=A0=C2=A0
    <meta http-equiv=3D"content-type" content=3D"text/html; charset=3DUTF=
-8">
    <pre class=3D"screen" style=3D"color: rgb(0, 0, 0); font-style: norma=
l; font-variant: normal; font-weight: normal; letter-spacing: normal; lin=
e-height: normal; orphans: auto; text-align: left; text-indent: 0px; text=
-transform: none; widows: auto; word-spacing: 0px; -webkit-text-stroke-wi=
dth: 0px; background-color: rgb(255, 255, 255);">             Active     =
            Front           Sync           Back
             Region                 Porch                          Porch
    &lt;-----------------------&gt;&lt;----------------&gt;&lt;----------=
---&gt;&lt;--------------&gt;

      //////////////////////|
     ////////////////////// |
    //////////////////////  |..................               ...........=
.....
                                               _______________

    &lt;----- [hv]display -----&gt;
    &lt;------------- [hv]sync_start ------------&gt;
    &lt;--------------------- [hv]sync_end ---------------------&gt;
    &lt;-------------------------------- [hv]total ----------------------=
-------&gt;</pre>
    but vop hardware define is that:<br>
    =C2=A0=C2=A0=C2=A0 <br>
    <pre class=3D"screen" style=3D"color: rgb(0, 0, 0); font-style: norma=
l; font-variant: normal; font-weight: normal; letter-spacing: normal; lin=
e-height: normal; orphans: auto; text-align: left; text-indent: 0px; text=
-transform: none; widows: auto; word-spacing: 0px; -webkit-text-stroke-wi=
dth: 0px; background-color: rgb(255, 255, 255);">      Sync          Back=
              Active                 Front        =20
                    Porch              Region                 Porch      =
               =20
    &lt;-----------&gt;&lt;-------------&gt;&lt;--------------------&gt;&=
lt;--------------&gt;

                               |//////////////////////|
                               |//////////////////////|
                 ..............|//////////////////////|...............
    |____________|

    &lt;-dsp_hs_end-&gt;
    &lt;------ dsp_hact_st-------&gt;
    &lt;----------------dsp_hact_end--------------------&gt;
    &lt;-------------------------------- dsp_hact_end--------------------=
&gt;</pre>
    So, we need to convert the setting.<span style=3D"color: rgb(38, 38,
      38); font-family: arial, sans-serif; font-size: 13px; font-style:
      normal; font-variant: normal; font-weight: normal; letter-spacing:
      normal; line-height: 16px; orphans: auto; text-align: start;
      text-indent: 0px; text-transform: none; white-space: normal;
      widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px;
      display: inline !important; float: none;"><br>
    </span>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+       u16 hdisplay =3D adjusted_mode-&gt;hdispla=
y;
+       u16 vdisplay =3D adjusted_mode-&gt;vdisplay;
+       u16 htotal =3D adjusted_mode-&gt;htotal;
+       u16 vtotal =3D adjusted_mode-&gt;vtotal;
+       struct rockchip_display_mode *priv_mode =3D
+                                       (void *)adjusted_mode-&gt;private=
;
+       unsigned long flags;
+       int ret;
+       uint32_t val;
+
+       /* nothing to do if we haven't set the mode yet */
+       if (adjusted_mode-&gt;htotal =3D=3D 0 || adjusted_mode-&gt;vtotal=
 =3D=3D 0)
+               return -EINVAL;
</pre>
      </blockquote>
      <pre wrap=3D"">
How is it possible to be given a mode with htotal or vtotal =3D=3D 0?
How could we be doing a mode set without a mode to set?
Can you do these verification checks to mode_fixup() instead?
</pre>
    </blockquote>
    OK, I will move it to mode_fixup().<br>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+
+       if (!priv_mode) {
+               DRM_ERROR("fail to found display output type[%d]\n",
+                         priv_mode-&gt;out_type);
+               return -EINVAL;
+       }
+
+       ret =3D rockchip_drm_crtc_mode_set_base(crtc, x, y, fb);
+       if (ret)
+               return ret;
+
+       switch (priv_mode-&gt;out_type) {
+       case ROCKCHIP_DISPLAY_TYPE_RGB:
+       case ROCKCHIP_DISPLAY_TYPE_LVDS:
+               VOP_CTRL_SET(ctx, rgb_en, 1);
+               VOP_CTRL_SET(ctx, out_mode, ROCKCHIP_OUTFACE_P888);
+               break;
+       case ROCKCHIP_DISPLAY_TYPE_EDP:
+               VOP_CTRL_SET(ctx, edp_en, 1);
+               VOP_CTRL_SET(ctx, out_mode, ROCKCHIP_OUTFACE_AAAA);
+               break;
+       case ROCKCHIP_DISPLAY_TYPE_HDMI:
+               VOP_CTRL_SET(ctx, out_mode, ROCKCHIP_OUTFACE_AAAA);
+               VOP_CTRL_SET(ctx, hdmi_en, 1);
+               break;
+       default:
+               DRM_ERROR("unsupport out type[%d]\n", priv_mode-&gt;out_t=
ype);
+               return -EINVAL;
+       };
</pre>
      </blockquote>
      <pre wrap=3D"">
This switch is directing the vop output to a particular output (edp,
lvds, hdmi, etc)
based on a private field added to the drm_display_mode by the down-pipe e=
ncoder.
However, on other hardware, it is possible to drive multiple outputs
from the same crtc.
This is a useful feature, for mirroring one framebuffer to multiple displ=
ays.

Is that possible for rk3288 too?
It looks like it should be possible to set multiple rgb_en, edp_en, hdmi_=
en, etc
bits at the same time.

If so, then we can't really make the encoder selection part of the mode.
Instead, what we can try to do is implement this output selection step by
providing a helper function from the vop for the encoders to call in thei=
r own
mode_set() callback.

Also, vop can expose another helper for allowing the encoder to select th=
e vop
pixel output format that it requires (ie, LVDS panel encoder can select 5=
65).
</pre>
    </blockquote>
    OK, I would provide a helper function for encoders to call instead
    of using drm_display_mode private.<br>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+
+       val =3D 0x8;
+       val |=3D (adjusted_mode-&gt;flags &amp; DRM_MODE_FLAG_NHSYNC) ? 1=
 : 0;
+       val |=3D (adjusted_mode-&gt;flags &amp; DRM_MODE_FLAG_NVSYNC) ? (=
1 &lt;&lt; 1) : 0;
+       VOP_CTRL_SET(ctx, pin_pol, val);
+
+       VOP_CTRL_SET(ctx, htotal_pw, (htotal &lt;&lt; 16) | hsync_len);
+       val =3D (hsync_len + left_margin) &lt;&lt; 16;
+       val |=3D hsync_len + left_margin + hdisplay;
+       VOP_CTRL_SET(ctx, hact_st_end, val);
+       VOP_CTRL_SET(ctx, hpost_st_end, val);
+
+       VOP_CTRL_SET(ctx, vtotal_pw, (vtotal &lt;&lt; 16) | vsync_len);
+       val =3D (vsync_len + upper_margin) &lt;&lt; 16;
+       val |=3D vsync_len + upper_margin + vdisplay;
+       VOP_CTRL_SET(ctx, vact_st_end, val);
+       VOP_CTRL_SET(ctx, vpost_st_end, val);
+
+       spin_lock_irqsave(&amp;ctx-&gt;irq_lock, flags);
+
+       vop_mask_write(ctx, INTR_CTRL0, DSP_LINE_NUM_MASK,
+                      DSP_LINE_NUM(vsync_len + upper_margin + vdisplay))=
;
+
+       spin_unlock_irqrestore(&amp;ctx-&gt;irq_lock, flags);
+
+       clk_set_rate(ctx-&gt;dclk, adjusted_mode-&gt;clock * 1000);
</pre>
      </blockquote>
      <pre wrap=3D"">
When we are changing modes, can we just change the dclk like this while a
previous frame is already being scanned out using the old clock?
Shouldn't we synchronize changing clocks:

 - schedule any current scanout to stop at next vblank
 - wait for that vblank
 - disable clock
 - program new mode
 - program new framebuffer(s) to match that new mode.
 - start clock

Or maybe like what you do in initial before turning on the iommu:

  - disable dclk
  - do a dclk &amp; ahb reset
  - program new mode
  - program new fb(s)
  - enable dclk.
</pre>
    </blockquote>
    right, and there is another problem:<br>
    all mode config will take effect at frame start, and at runtime,
    frame start event maybe happen at any=C2=A0 place<br>
    when setting mode config:<br>
    =C2=A0=C2=A0=C2=A0=C2=A0 VOP_CTRL_SET(ctx, htotal_pw, (htotal &lt;&lt=
; 16) | hsync_len);<br>
    =C2=A0=C2=A0=C2=A0 =C2=A0 ----&gt; frame start<br>
    =C2=A0=C2=A0=C2=A0=C2=A0 VOP_CTRL_SET(ctx, hact_st_end, val);<br>
    =C2=A0=C2=A0=C2=A0=C2=A0 then htotal_pw take effect, but hact_st_end =
should wait for
    next frame start, so we got a wrong frame.<br>
    <br>
    so I want to change it like your advices :<br>
    mode_set:<br>
    - disable dclk<br>
    - program new fb(s)<br>
    - program new mode<br>
    - do a dclk reset, reset the frame scan point to the beginning, then
    all setting will take effect.<br>
    - dclk set rate.<br>
    - enable dclk<br>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <blockquote type=3D"cite">
        <pre wrap=3D"">+
+       return 0;
+}
+
+static int rockchip_drm_crtc_mode_set_base(struct drm_crtc *crtc, int x,=
 int y,
+                                          struct drm_framebuffer *old_fb=
)
+{
+       unsigned int crtc_w;
+       unsigned int crtc_h;
+       int ret;
+
+       crtc_w =3D crtc-&gt;primary-&gt;fb-&gt;width - crtc-&gt;x;
+       crtc_h =3D crtc-&gt;primary-&gt;fb-&gt;height - crtc-&gt;y;
+
+       ret =3D rockchip_update_plane(crtc-&gt;primary, crtc, crtc-&gt;pr=
imary-&gt;fb, 0,
+                                   0, crtc_w, crtc_h, crtc-&gt;x, crtc-&=
gt;y, crtc_w,
+                                   crtc_h);
</pre>
      </blockquote>
      <pre wrap=3D"">

rockchip_update_plane expects its src_x, src_y, src_h, src_w to be in 16.=
16
'sub-pixel' units, so you need to &lt;&lt; 16 the last 4 parameters here.

It might be more convenient to split rockchip_update_plane() into two fun=
ctions:
 (1) rockchip_update_plane() which takes 16.16 src_ and is used for the
    drm_plane_funcs.update_plane.  This function converts src_* from 16.1=
6 to
    pixels, and then calls:
 (2) a helper function which just takes src_ in whole pixel units.  The h=
elper
    function you can call from rockchip_drm_crtc_mode_set_base() and
    rockchip_drm_crtc_page_flip().  In fact, since we do not support scal=
ing,
    the helper probably does not even need src_w and src_h arguments.
</pre>
    </blockquote>
    OK, Got it.<br>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+       if (ret &lt; 0) {
+               DRM_ERROR("fail to update plane\n");
+               return -EINVAL;
</pre>
      </blockquote>
      <pre wrap=3D"">
return ret;
</pre>
    </blockquote>
    OK.<br>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+       }
+
+       return 0;
+}
+
+static void rockchip_drm_crtc_commit(struct drm_crtc *crtc)
+{
+       /* just do dummy now */
+}
+
+static const struct drm_crtc_helper_funcs rockchip_crtc_helper_funcs =3D=
 {
+       .dpms =3D rockchip_drm_crtc_dpms,
+       .prepare =3D rockchip_drm_crtc_prepare,
+       .mode_fixup =3D rockchip_drm_crtc_mode_fixup,
+       .mode_set =3D rockchip_drm_crtc_mode_set,
+       .mode_set_base =3D rockchip_drm_crtc_mode_set_base,
+       .commit =3D rockchip_drm_crtc_commit,
+};
+
+static int rockchip_drm_crtc_page_flip(struct drm_crtc *crtc,
+                                      struct drm_framebuffer *fb,
+                                      struct drm_pending_vblank_event *e=
vent,
+                                      uint32_t page_flip_flags)
+{
+       struct drm_device *dev =3D crtc-&gt;dev;
+       struct vop_context *ctx =3D to_vop_ctx(crtc);
+       struct drm_framebuffer *old_fb =3D crtc-&gt;primary-&gt;fb;
+       unsigned int crtc_w;
+       unsigned int crtc_h;
+       int ret;
+
+       /* when the page flip is requested, crtc's dpms should be on */
+       if (ctx-&gt;dpms &gt; DRM_MODE_DPMS_ON) {
+               DRM_DEBUG("failed page flip request at dpms[%d].\n", ctx-=
&gt;dpms);
+               return 0;
+       }
+
+       ret =3D drm_vblank_get(dev, ctx-&gt;pipe);
+       if (ret) {
+               DRM_DEBUG("failed to acquire vblank counter\n");
+               return ret;
+       }
+
+       spin_lock_irq(&amp;dev-&gt;event_lock);
+       if (ctx-&gt;event) {
+               spin_unlock_irq(&amp;dev-&gt;event_lock);
+               DRM_ERROR("already pending flip!\n");
+               return -EBUSY;
+       }
+       ctx-&gt;event =3D event;
+       atomic_set(&amp;ctx-&gt;wait_vsync_event, 1);
+       spin_unlock_irq(&amp;dev-&gt;event_lock);
+
+       crtc-&gt;primary-&gt;fb =3D fb;
+       crtc_w =3D crtc-&gt;primary-&gt;fb-&gt;width - crtc-&gt;x;
+       crtc_h =3D crtc-&gt;primary-&gt;fb-&gt;height - crtc-&gt;y;
+
+       ret =3D rockchip_update_plane(crtc-&gt;primary, crtc, fb, 0, 0, c=
rtc_w,
+                                   crtc_h, crtc-&gt;x, crtc-&gt;y, crtc_=
w, crtc_h);
+       if (ret) {
+               crtc-&gt;primary-&gt;fb =3D old_fb;
+
+               spin_lock_irq(&amp;dev-&gt;event_lock);
+               drm_vblank_put(dev, ctx-&gt;pipe);
+               atomic_set(&amp;ctx-&gt;wait_vsync_event, 0);
+               ctx-&gt;event =3D NULL;
+               spin_unlock_irq(&amp;dev-&gt;event_lock);
+       }
+
+       return ret;
+}
+
+void rockchip_drm_crtc_finish_pageflip(struct drm_device *dev, int pipe)
+{
+       struct rockchip_drm_private *dev_priv =3D dev-&gt;dev_private;
+       struct drm_crtc *drm_crtc =3D dev_priv-&gt;crtc[pipe];
+       struct vop_context *ctx;
+       unsigned long flags;
+
+       if (!drm_crtc)
+               return;
</pre>
      </blockquote>
      <pre wrap=3D"">
Can you add a comment describing when this can happen?
</pre>
    </blockquote>
    nothing would happen, I think drm_crtc would not be NULL, I will
    just remove it.<br>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+
+       ctx =3D to_vop_ctx(drm_crtc);
+
+       spin_lock_irqsave(&amp;dev-&gt;event_lock, flags);
+
+       if (ctx-&gt;event) {
+               drm_send_vblank_event(dev, -1, ctx-&gt;event);
+               drm_vblank_put(dev, pipe);
+               atomic_set(&amp;ctx-&gt;wait_vsync_event, 0);
+               wake_up(&amp;ctx-&gt;wait_vsync_queue);
+               ctx-&gt;event =3D NULL;
+       }
+
+       spin_unlock_irqrestore(&amp;dev-&gt;event_lock, flags);
+}
+
+void rockchip_drm_crtc_cancel_pending_flip(struct drm_device *dev)
+{
+       int i;
+
+       for (i =3D 0; i &lt; dev-&gt;num_crtcs; i++)
+               rockchip_drm_crtc_finish_pageflip(dev, i);
+}
+
+static void rockchip_drm_crtc_destroy(struct drm_crtc *crtc)
+{
+       struct vop_context *ctx =3D to_vop_ctx(crtc);
+       struct rockchip_drm_private *private =3D crtc-&gt;dev-&gt;dev_pri=
vate;
+
+       private-&gt;crtc[ctx-&gt;pipe] =3D NULL;
+       drm_crtc_cleanup(crtc);
+}
+
+static const struct drm_crtc_funcs rockchip_crtc_funcs =3D {
+       .set_config =3D drm_crtc_helper_set_config,
+       .page_flip =3D rockchip_drm_crtc_page_flip,
+       .destroy =3D rockchip_drm_crtc_destroy,
+};
+
+static void rockchip_vsync_worker(struct work_struct *work)
+{
+       struct vop_context *ctx =3D container_of(work, struct vop_context=
,
+                                              vsync_work);
+       struct drm_device *drm =3D ctx-&gt;drm_dev;
+       struct rockchip_drm_private *dev_priv =3D drm-&gt;dev_private;
+       struct drm_crtc *crtc =3D dev_priv-&gt;crtc[ctx-&gt;pipe];
+       struct rockchip_plane *rockchip_plane;
+       struct drm_plane *plane;
+       uint32_t yrgb_mst;
+
+       mutex_lock(&amp;ctx-&gt;vsync_mutex);
+
+       ctx-&gt;vsync_work_pending =3D false;
+
+       list_for_each_entry(plane, &amp;drm-&gt;mode_config.plane_list, h=
ead) {
+               rockchip_plane =3D to_rockchip_plane(plane);
+
+               if (rockchip_plane-&gt;ctx !=3D ctx)
+                       continue;
+               if (rockchip_plane-&gt;enabled &amp;&amp; !rockchip_plane=
-&gt;pending_fb)
+                       continue;
+               if (!rockchip_plane-&gt;enabled &amp;&amp; !rockchip_plan=
e-&gt;front_fb)
+                       continue;
+               /*
+                * make sure the yrgb_mst take effect, so that
+                * we can unreference the old framebuffer.
+                */
+               yrgb_mst =3D VOP_WIN_GET_YRGBADDR(ctx, rockchip_plane-&gt=
;win);
+               if (rockchip_plane-&gt;pending_yrgb_mst !=3D yrgb_mst) {
+                       /*
+                        * some plane no complete, unref at next vblank
+                        */
+                       ctx-&gt;vsync_work_pending =3D true;
+                       continue;
+               }
+
+               /*
+                * drm_framebuffer_unreference maybe call iommu unmap,
+                * and iommu not allow unmap buffer at irq context,
+                * so we do drm_framebuffer_unreference at queue_work.
+                */
+               if (rockchip_plane-&gt;front_fb)
+                       drm_framebuffer_unreference(rockchip_plane-&gt;fr=
ont_fb);
+
+               rockchip_plane-&gt;front_fb =3D rockchip_plane-&gt;pendin=
g_fb;
+               rockchip_plane-&gt;pending_fb =3D NULL;
+
+               /*
+                * if primary plane flip complete, sending the event to
+                * userspace
+                */
+               if (&amp;rockchip_plane-&gt;base =3D=3D crtc-&gt;primary)
+                       rockchip_drm_crtc_finish_pageflip(ctx-&gt;drm_dev=
,
+                                                         ctx-&gt;pipe);
+       }
+
+       mutex_unlock(&amp;ctx-&gt;vsync_mutex);
+}
+
+static irqreturn_t rockchip_vop_isr(int irq, void *data)
+{
+       struct vop_context *ctx =3D data;
+       uint32_t intr0_reg;
+       unsigned long flags;
+
+       intr0_reg =3D vop_readl(ctx, INTR_CTRL0);
+       if (intr0_reg &amp; LINE_FLAG_INTR) {
+               spin_lock_irqsave(&amp;ctx-&gt;irq_lock, flags);
+               vop_writel(ctx, INTR_CTRL0, intr0_reg | LINE_FLAG_INTR_CL=
R);
+               spin_unlock_irqrestore(&amp;ctx-&gt;irq_lock, flags);
+       } else {
+               return IRQ_NONE;
+       }
+
+       drm_handle_vblank(ctx-&gt;drm_dev, ctx-&gt;pipe);
+       if (ctx-&gt;vsync_work_pending)
+               queue_work(ctx-&gt;vsync_wq, &amp;ctx-&gt;vsync_work);
+
+       return IRQ_HANDLED;
+}
+
+static int vop_create_crtc(struct vop_context *ctx)
+{
+       struct device *dev =3D ctx-&gt;dev;
+       struct drm_device *drm_dev =3D ctx-&gt;drm_dev;
+       struct drm_plane *primary, *cursor;
+       unsigned long possible_crtcs;
+       struct drm_crtc *crtc;
+       int ret;
+       int nr;
+
+       ctx-&gt;win_mask =3D 0;
+       crtc =3D &amp;ctx-&gt;crtc;
+
+       ret =3D rockchip_drm_add_crtc(drm_dev, crtc, dev-&gt;of_node);
+       if (ret &lt; 0)
+               return ret;
+       ctx-&gt;pipe =3D ret;
+
+       possible_crtcs =3D (1 &lt;&lt; ctx-&gt;pipe);
+
+       primary =3D rockchip_plane_init(ctx, possible_crtcs,
+                                     DRM_PLANE_TYPE_PRIMARY);
+       if (!primary) {
+               DRM_ERROR("fail to init primary plane\n");
+               return -EINVAL;
+       }
+
+       for (nr =3D 1; nr &lt; ROCKCHIP_MAX_PLANE; nr++) {
+               if (nr =3D=3D VOP_DEFAULT_CURSOR) {
+                       cursor =3D rockchip_plane_init(ctx, possible_crtc=
s,
+                                                    DRM_PLANE_TYPE_CURSO=
R);
+                       if (!cursor) {
+                               DRM_ERROR("fail to init cursor plane\n");
+                               return -EINVAL;
+                       }
+               } else {
+                       struct drm_plane *plane;
+
+                       plane =3D rockchip_plane_init(ctx, possible_crtcs=
,
+                                                   DRM_PLANE_TYPE_OVERLA=
Y);
+                       if (!plane) {
+                               DRM_ERROR("fail to init overlay plane\n")=
;
+                               return -EINVAL;
+                       }
+               }
+       }
+
+       drm_crtc_init_with_planes(drm_dev, crtc, primary, cursor,
+                                 &amp;rockchip_crtc_funcs);
+       drm_crtc_helper_add(crtc, &amp;rockchip_crtc_helper_funcs);
+
+       return 0;
+}
+
+static int rockchip_vop_initial(struct vop_context *ctx)
+{
+       struct vop_driver_data *vop_data =3D ctx-&gt;data;
+       const struct vop_reg_data *init_table =3D vop_data-&gt;init_table=
;
+       struct reset_control *rst;
+       int i, ret;
+
+       ctx-&gt;hclk =3D devm_clk_get(ctx-&gt;dev, "hclk_vop");
+       if (IS_ERR(ctx-&gt;hclk)) {
+               dev_err(ctx-&gt;dev, "failed to get hclk source\n");
+               return PTR_ERR(ctx-&gt;hclk);
+       }
+       ctx-&gt;aclk =3D devm_clk_get(ctx-&gt;dev, "aclk_vop");
+       if (IS_ERR(ctx-&gt;aclk)) {
+               dev_err(ctx-&gt;dev, "failed to get aclk source\n");
+               return PTR_ERR(ctx-&gt;aclk);
+       }
+       ctx-&gt;dclk =3D devm_clk_get(ctx-&gt;dev, "dclk_vop");
+       if (IS_ERR(ctx-&gt;dclk)) {
+               dev_err(ctx-&gt;dev, "failed to get dclk source\n");
+               return PTR_ERR(ctx-&gt;dclk);
+       }
+
+       ret =3D vop_clk_enable(ctx);
+       if (ret &lt; 0)
+               return ret;
</pre>
      </blockquote>
      <pre wrap=3D"">
if anything fails after this, remember to disable the clk...
</pre>
    </blockquote>
    oh, yes, I will do disable clk if fail.<br>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">
Ok, that is enough for now :-)

Thanks,
-djk
</pre>
    </blockquote>
    Thanks very much for your review,=C2=A0 nice suggestions.<br>
    -Mark <span style=3D"color: rgb(33, 33, 33); font-family: arial,
      sans-serif; font-size: 14px; font-style: normal; font-variant:
      normal; font-weight: bold; letter-spacing: normal; line-height:
      16px; orphans: auto; text-align: left; text-indent: 0px;
      text-transform: none; white-space: normal; widows: auto;
      word-spacing: 0px; -webkit-text-stroke-width: 0px;
      background-color: rgb(255, 255, 255); display: inline !important;
      float: none;"></span>
    <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
      type=3D"cite">
      <pre wrap=3D"">

</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">+
+       /*
+        * do hclk_reset, reset all vop registers.
+        */
+       rst =3D devm_reset_control_get(ctx-&gt;dev, "ahb");
+       if (IS_ERR(rst)) {
+               dev_err(ctx-&gt;dev, "failed to get ahb reset\n");
+               return PTR_ERR(rst);
+       }
+       reset_control_assert(rst);
+       usleep_range(10, 20);
+       reset_control_deassert(rst);
+
+       memcpy(ctx-&gt;regsbak, ctx-&gt;regs, ctx-&gt;len);
+
+       for (i =3D 0; i &lt; vop_data-&gt;table_size; i++)
+               vop_writel(ctx, init_table[i].offset, init_table[i].value=
);
+
+       for (i =3D 0; i &lt; VOP_MAX_WIN_SUPPORT; i++)
+               VOP_WIN_SET(ctx, vop_data-&gt;win[i], enable, 0);
+
+       vop_cfg_done(ctx);
+
+       /*
+        * do dclk_reset, let all win config take affect, and then we can=
 enable
+        * iommu safe.
+        */
+       rst =3D devm_reset_control_get(ctx-&gt;dev, "dclk");
+       if (IS_ERR(rst)) {
+               dev_err(ctx-&gt;dev, "failed to get dclk reset\n");
+               return PTR_ERR(rst);
+       }
+       reset_control_assert(rst);
+       usleep_range(10, 20);
+       reset_control_deassert(rst);
+
+       ctx-&gt;dpms =3D DRM_MODE_DPMS_ON;
+
+       return 0;
+}
+
+static int vop_bind(struct device *dev, struct device *master, void *dat=
a)
+{
+       struct platform_device *pdev =3D to_platform_device(dev);
+       struct vop_driver_data *vop_data =3D vop_get_driver_data(dev);
+       struct drm_device *drm_dev =3D data;
+       struct vop_context *ctx;
+       struct resource *res;
+       int ret;
+
+       if (!vop_data)
+               return -ENODEV;
+
+       ctx =3D devm_kzalloc(dev, sizeof(*ctx), GFP_KERNEL);
+       if (!ctx)
+               return -ENOMEM;
+
+       ctx-&gt;dev =3D dev;
+       ctx-&gt;data =3D vop_data;
+       ctx-&gt;drm_dev =3D drm_dev;
+       dev_set_drvdata(dev, ctx);
+
+       res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
+       ctx-&gt;len =3D resource_size(res);
+       ctx-&gt;regs =3D devm_ioremap_resource(dev, res);
+       if (IS_ERR(ctx-&gt;regs))
+               return PTR_ERR(ctx-&gt;regs);
+
+       ctx-&gt;regsbak =3D devm_kzalloc(dev, ctx-&gt;len, GFP_KERNEL);
+       if (!ctx-&gt;regsbak)
+               return -ENOMEM;
+
+       ret =3D rockchip_vop_initial(ctx);
+       if (ret &lt; 0) {
+               dev_err(&amp;pdev-&gt;dev, "cannot initial vop dev - err =
%d\n", ret);
+               return ret;
+       }
+
+       ctx-&gt;irq =3D platform_get_irq(pdev, 0);
+       if (ctx-&gt;irq &lt; 0) {
+               dev_err(dev, "cannot find irq for vop\n");
+               return ctx-&gt;irq;
+       }
+
+       spin_lock_init(&amp;ctx-&gt;reg_lock);
+       spin_lock_init(&amp;ctx-&gt;irq_lock);
+
+       init_waitqueue_head(&amp;ctx-&gt;wait_vsync_queue);
+       atomic_set(&amp;ctx-&gt;wait_vsync_event, 0);
+
+       ret =3D vop_iommu_init(ctx);
+       if (ret) {
+               DRM_ERROR("Failed to setup iommu, %d\n", ret);
+               return ret;
+       }
+
+       ctx-&gt;vsync_wq =3D create_singlethread_workqueue("vsync");
+       if (!ctx-&gt;vsync_wq) {
+               dev_err(dev, "failed to create workqueue\n");
+               return -EINVAL;
+       }
+       INIT_WORK(&amp;ctx-&gt;vsync_work, rockchip_vsync_worker);
+
+       mutex_init(&amp;ctx-&gt;vsync_mutex);
+       pm_runtime_enable(&amp;pdev-&gt;dev);
+
+       ret =3D devm_request_irq(dev, ctx-&gt;irq, rockchip_vop_isr,
+                              IRQF_SHARED, dev_name(dev), ctx);
+       if (ret) {
+               dev_err(dev, "cannot requeset irq%d - err %d\n", ctx-&gt;=
irq, ret);
+               return ret;
+       }
+
+       return vop_create_crtc(ctx);
+}
+
+static void vop_unbind(struct device *dev, struct device *master,
+                      void *data)
+{
+       struct drm_device *drm_dev =3D data;
+       struct vop_context *ctx =3D dev_get_drvdata(dev);
+       struct drm_crtc *crtc =3D &amp;ctx-&gt;crtc;
+
+       drm_crtc_cleanup(crtc);
+       pm_runtime_disable(dev);
+       rockchip_drm_remove_crtc(drm_dev, ctx-&gt;pipe);
+
+       vop_iommu_fini(ctx);
+}
+
+static const struct component_ops vop_component_ops =3D {
+       .bind =3D vop_bind,
+       .unbind =3D vop_unbind,
+};
+
+static int vop_probe(struct platform_device *pdev)
+{
+       struct device *dev =3D &amp;pdev-&gt;dev;
+       struct vop_context *ctx;
+
+       if (!dev-&gt;of_node) {
+               dev_err(dev, "can't find vop devices\n");
+               return -ENODEV;
+       }
+
+       platform_set_drvdata(pdev, ctx);
+
+       return component_add(dev, &amp;vop_component_ops);
+}
+
+static int vop_remove(struct platform_device *pdev)
+{
+       component_del(&amp;pdev-&gt;dev, &amp;vop_component_ops);
+
+       return 0;
+}
+
+struct platform_driver rockchip_vop_platform_driver =3D {
+       .probe =3D vop_probe,
+       .remove =3D vop_remove,
+       .driver =3D {
+               .name =3D "rockchip-vop",
+               .owner =3D THIS_MODULE,
+               .of_match_table =3D of_match_ptr(vop_driver_dt_match),
+       },
+};
+
+module_platform_driver(rockchip_vop_platform_driver);
+
+MODULE_AUTHOR("Mark Yao <a class=3D"moz-txt-link-rfc2396E" href=3D"mailt=
o:mark.yao@rock-chips.com">&lt;mark.yao@rock-chips.com&gt;</a>");
+MODULE_DESCRIPTION("ROCKCHIP VOP Driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.h b/drivers/gpu/dr=
m/rockchip/rockchip_drm_vop.h
new file mode 100644
index 0000000..2343760
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.h
@@ -0,0 +1,187 @@
+/*
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:Mark Yao <a class=3D"moz-txt-link-rfc2396E" href=3D"mailto:mar=
k.yao@rock-chips.com">&lt;mark.yao@rock-chips.com&gt;</a>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _ROCKCHIP_DRM_VOP_H
+#define _ROCKCHIP_DRM_VOP_H
+
+/* register definition */
+#define REG_CFG_DONE                   0x0000
+#define VERSION_INFO                   0x0004
+#define SYS_CTRL                       0x0008
+#define SYS_CTRL1                      0x000c
+#define DSP_CTRL0                      0x0010
+#define DSP_CTRL1                      0x0014
+#define DSP_BG                         0x0018
+#define MCU_CTRL                       0x001c
+#define INTR_CTRL0                     0x0020
+#define INTR_CTRL1                     0x0024
+#define WIN0_CTRL0                     0x0030
+#define WIN0_CTRL1                     0x0034
+#define WIN0_COLOR_KEY                 0x0038
+#define WIN0_VIR                       0x003c
+#define WIN0_YRGB_MST                  0x0040
+#define WIN0_CBR_MST                   0x0044
+#define WIN0_ACT_INFO                  0x0048
+#define WIN0_DSP_INFO                  0x004c
+#define WIN0_DSP_ST                    0x0050
+#define WIN0_SCL_FACTOR_YRGB           0x0054
+#define WIN0_SCL_FACTOR_CBR            0x0058
+#define WIN0_SCL_OFFSET                        0x005c
+#define WIN0_SRC_ALPHA_CTRL            0x0060
+#define WIN0_DST_ALPHA_CTRL            0x0064
+#define WIN0_FADING_CTRL               0x0068
+/* win1 register */
+#define WIN1_CTRL0                     0x0070
+#define WIN1_CTRL1                     0x0074
+#define WIN1_COLOR_KEY                 0x0078
+#define WIN1_VIR                       0x007c
+#define WIN1_YRGB_MST                  0x0080
+#define WIN1_CBR_MST                   0x0084
+#define WIN1_ACT_INFO                  0x0088
+#define WIN1_DSP_INFO                  0x008c
+#define WIN1_DSP_ST                    0x0090
+#define WIN1_SCL_FACTOR_YRGB           0x0094
+#define WIN1_SCL_FACTOR_CBR            0x0098
+#define WIN1_SCL_OFFSET                        0x009c
+#define WIN1_SRC_ALPHA_CTRL            0x00a0
+#define WIN1_DST_ALPHA_CTRL            0x00a4
+#define WIN1_FADING_CTRL               0x00a8
+/* win2 register */
+#define WIN2_CTRL0                     0x00b0
+#define WIN2_CTRL1                     0x00b4
+#define WIN2_VIR0_1                    0x00b8
+#define WIN2_VIR2_3                    0x00bc
+#define WIN2_MST0                      0x00c0
+#define WIN2_DSP_INFO0                 0x00c4
+#define WIN2_DSP_ST0                   0x00c8
+#define WIN2_COLOR_KEY                 0x00cc
+#define WIN2_MST1                      0x00d0
+#define WIN2_DSP_INFO1                 0x00d4
+#define WIN2_DSP_ST1                   0x00d8
+#define WIN2_SRC_ALPHA_CTRL            0x00dc
+#define WIN2_MST2                      0x00e0
+#define WIN2_DSP_INFO2                 0x00e4
+#define WIN2_DSP_ST2                   0x00e8
+#define WIN2_DST_ALPHA_CTRL            0x00ec
+#define WIN2_MST3                      0x00f0
+#define WIN2_DSP_INFO3                 0x00f4
+#define WIN2_DSP_ST3                   0x00f8
+#define WIN2_FADING_CTRL               0x00fc
+/* win3 register */
+#define WIN3_CTRL0                     0x0100
+#define WIN3_CTRL1                     0x0104
+#define WIN3_VIR0_1                    0x0108
+#define WIN3_VIR2_3                    0x010c
+#define WIN3_MST0                      0x0110
+#define WIN3_DSP_INFO0                 0x0114
+#define WIN3_DSP_ST0                   0x0118
+#define WIN3_COLOR_KEY                 0x011c
+#define WIN3_MST1                      0x0120
+#define WIN3_DSP_INFO1                 0x0124
+#define WIN3_DSP_ST1                   0x0128
+#define WIN3_SRC_ALPHA_CTRL            0x012c
+#define WIN3_MST2                      0x0130
+#define WIN3_DSP_INFO2                 0x0134
+#define WIN3_DSP_ST2                   0x0138
+#define WIN3_DST_ALPHA_CTRL            0x013c
+#define WIN3_MST3                      0x0140
+#define WIN3_DSP_INFO3                 0x0144
+#define WIN3_DSP_ST3                   0x0148
+#define WIN3_FADING_CTRL               0x014c
+/* hwc register */
+#define HWC_CTRL0                      0x0150
+#define HWC_CTRL1                      0x0154
+#define HWC_MST                                0x0158
+#define HWC_DSP_ST                     0x015c
+#define HWC_SRC_ALPHA_CTRL             0x0160
+#define HWC_DST_ALPHA_CTRL             0x0164
+#define HWC_FADING_CTRL                        0x0168
+/* post process register */
+#define POST_DSP_HACT_INFO             0x0170
+#define POST_DSP_VACT_INFO             0x0174
+#define POST_SCL_FACTOR_YRGB           0x0178
+#define POST_SCL_CTRL                  0x0180
+#define POST_DSP_VACT_INFO_F1          0x0184
+#define DSP_HTOTAL_HS_END              0x0188
+#define DSP_HACT_ST_END                        0x018c
+#define DSP_VTOTAL_VS_END              0x0190
+#define DSP_VACT_ST_END                        0x0194
+#define DSP_VS_ST_END_F1               0x0198
+#define DSP_VACT_ST_END_F1             0x019c
+/* register definition end */
+
+/* interrupt define */
+#define DSP_HOLD_VALID_INTR            (1 &lt;&lt; 0)
+#define FS_INTR                                (1 &lt;&lt; 1)
+#define LINE_FLAG_INTR                 (1 &lt;&lt; 2)
+#define BUS_ERROR_INTR                 (1 &lt;&lt; 3)
+
+#define DSP_HOLD_VALID_INTR_EN(x)      ((x) &lt;&lt; 4)
+#define FS_INTR_EN(x)                  ((x) &lt;&lt; 5)
+#define LINE_FLAG_INTR_EN(x)           ((x) &lt;&lt; 6)
+#define BUS_ERROR_INTR_EN(x)           ((x) &lt;&lt; 7)
+#define DSP_HOLD_VALID_INTR_MASK       (1 &lt;&lt; 4)
+#define FS_INTR_EN_MASK                        (1 &lt;&lt; 5)
+#define LINE_FLAG_INTR_MASK            (1 &lt;&lt; 6)
+#define BUS_ERROR_INTR_MASK            (1 &lt;&lt; 7)
+
+#define DSP_HOLD_VALID_INTR_CLR                (1 &lt;&lt; 8)
+#define FS_INTR_EN_CLR                 (1 &lt;&lt; 9)
+#define LINE_FLAG_INTR_CLR             (1 &lt;&lt; 10)
+#define BUS_ERROR_INTR_CLR             (1 &lt;&lt; 11)
+#define DSP_LINE_NUM(x)                        (((x) &amp; 0x1fff) &lt;&=
lt; 12)
+#define DSP_LINE_NUM_MASK              (0x1fff &lt;&lt; 12)
+
+/* src alpha ctrl define */
+#define SRC_FADING_VALUE(x)            (((x) &amp; 0xff) &lt;&lt; 24)
+#define SRC_GLOBAL_ALPHA(x)            (((x) &amp; 0xff) &lt;&lt; 16)
+#define SRC_FACTOR_M0(x)               (((x) &amp; 0x7) &lt;&lt; 6)
+#define SRC_ALPHA_CAL_M0(x)            (((x) &amp; 0x1) &lt;&lt; 5)
+#define SRC_BLEND_M0(x)                        (((x) &amp; 0x3) &lt;&lt;=
 3)
+#define SRC_ALPHA_M0(x)                        (((x) &amp; 0x1) &lt;&lt;=
 2)
+#define SRC_COLOR_M0(x)                        (((x) &amp; 0x1) &lt;&lt;=
 1)
+#define SRC_ALPHA_EN(x)                        (((x) &amp; 0x1) &lt;&lt;=
 0)
+/* dst alpha ctrl define */
+#define DST_FACTOR_M0(x)               (((x) &amp; 0x7) &lt;&lt; 6)
+
+enum alpha_mode {
+       ALPHA_STRAIGHT,
+       ALPHA_INVERSE,
+};
+
+enum global_blend_mode {
+       ALPHA_GLOBAL,
+       ALPHA_PER_PIX,
+       ALPHA_PER_PIX_GLOBAL,
+};
+
+enum alpha_cal_mode {
+       ALPHA_SATURATION,
+       ALPHA_NO_SATURATION,
+};
+
+enum color_mode {
+       ALPHA_SRC_PRE_MUL,
+       ALPHA_SRC_NO_PRE_MUL,
+};
+
+enum factor_mode {
+       ALPHA_ZERO,
+       ALPHA_ONE,
+       ALPHA_SRC,
+       ALPHA_SRC_INVERSE,
+       ALPHA_SRC_GLOBAL,
+};
+
+#endif /* _ROCKCHIP_DRM_VOP_H */
--
1.7.9.5

</pre>
      </blockquote>
      <pre wrap=3D"">


</pre>
    </blockquote>
    <br>
  </body>
</html>

--------------020302040903060005080105--


--===============0892311294==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
dri-devel mailing list
dri-devel@lists.freedesktop.org
http://lists.freedesktop.org/mailman/listinfo/dri-devel

--===============0892311294==--
