From: Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Subject: [PATCH v15 0/3] Add drm driver for Rockchip Socs
Date: Tue,  2 Dec 2014 17:13:20 +0800
Message-ID: <1417511600-7054-1-git-send-email-mark.yao@rock-chips.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org, Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, David Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rom Lemarchand <romlem-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, dbehr-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org, djkurtz-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, cf-TNX95d0MmH7DzftRWevZcw@public.gmane.org, xxm-TNX95d0MmH7DzftRWevZcw@public.gmane.org, huangtao-TNX95d0MmH7DzftRWevZcw@public.gmane.org, kever.yang-TNX95d0MmH7DzftRWevZcw@public.gmane.org, yxj-TNX95d0MmH7DzftRWevZcw@public.gmane.org, xw-TNX95d0MmH7DzftRWevZcw@public.gmane.org, Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This a series of patches is a DRM Driver for Rockchip Socs, add support
for vop devices. Future patches will add additional encoders/connectors,
such as eDP, HDMI.

The basic "crtc" for rockchip is a "VOP" - Video Output Processor.
the vop devices found on Rockchip rk3288 Soc, rk3288 soc have two similar
Vop devices. Vop devices support iommu mapping, we use dma-mapping API with
ARM_DMA_USE_IOMMU.

Changes in v2:
- add DRM master device node to list all display nodes that comprise
  the graphics subsystem.
- use the component framework to defer main drm driver probe
  until all VOP devices have been probed.
- use dma-mapping API with ARM_DMA_USE_IOMMU, create dma mapping by
  master device and each vop device can shared the drm dma mapping.
- use drm_crtc_init_with_planes and drm_universal_plane_init.
- remove unnecessary middle layers.
- add cursor set, move funcs to rockchip drm crtc.
- add vop reset.

Changes in v3:
- change "crtc->fb" to "crtc->primary-fb"
Adviced by Daniel Vetter
- init cursor plane with universal api, remove unnecessary cursor set,move 

Changes in v4:
Adviced by David Herrmann
- remove drm_platform_*() usage, use register drm device directly.
Adviced by Rob Clark
- remove special mmap ioctl, do userspace mmap with normal mmap() or mmap offset

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

Changes in v6:
- set gem buffer pitch 64 bytes align, needed by mali gpu.
Adviced by Daniel Kurtz
- fix some mistake, bugs, remove unused define, more better code style etc. 
- use clk_prepare()/unprepare() at probe()/remove() and clk_enable()/disable()
  at runtime instead of clk_prepare_enable().
- provide a help function from vop for encoder to do mode config, instead of
  using drm_diaplay_mode private method.
- change vop mode_set timing to make it more safely. 

Changes in v7:
- fix memory leakage problem.

Changes in v8:
- fix iommu crash when use dual crtc.
- use frame start interrupt for vsync instead of line flag interrupt,
  because the win config take affect at frame start time, if we use
  ling flag interrupt, the address check often failed.
Adviced by Daniel Kurtz
- fix some bugs, mistake, remove unused function
- keep clock and vop disabled when probe end
- use drm_plane_helper_check_update to check update_plane if vaild

Changes in v9:
- fix suspend and resume bug, make iommu attach and detach safely.
- fix mail info style.

Changes in v10:
Adviced by Andrzej Hajda
- check drm_dev if it's NULL at PM suspend/resume
Adviced by Sean Paul
- use drm_fb_helper_prepare to init fb_helper funcs
- Optimized code structure and remove some unnecessary Variables.

Changes in v11:
- fix mistake that use wrong variable at rockchip sys_resume/sys_suspend

Changes in v12:
- fix compile problem with drm-next
- Optimization framebuffer reference/unreference
- Optimization Code structure
- fix pm suspend/resume problem
- fix vblank irq can't close problem

Changes in v13:
- fix vop compile warning.
Adviced by Daniel Vetter
- directly call rockchip_drm_load before register instead of
  call ->load at the middle of drm register.

Changes in v14:
- revert v13 directly call rockchip_drm_load at bind, connector,
  crtc _init should before dev-node kms object lookup idr and
  conector sysfs need below minor node register, I don't like 
  split the connector init and register, so just call ->load at
  the midile of drm register.

Changes in v15:
- remove depends on ARM_DMA_USE_IOMMU & IOMMU_API which cause 
  recursive dependency problem
- fix compile problems when build as a module.

Mark yao (3):
  drm: rockchip: Add basic drm driver
  dt-bindings: video: Add for rockchip display subsytem
  dt-bindings: video: Add documentation for rockchip vop

 .../devicetree/bindings/video/rockchip-drm.txt     |   19 +
 .../devicetree/bindings/video/rockchip-vop.txt     |   58 +
 drivers/gpu/drm/Kconfig                            |    2 +
 drivers/gpu/drm/Makefile                           |    1 +
 drivers/gpu/drm/rockchip/Kconfig                   |   17 +
 drivers/gpu/drm/rockchip/Makefile                  |    8 +
 drivers/gpu/drm/rockchip/rockchip_drm_drv.c        |  551 ++++++++
 drivers/gpu/drm/rockchip/rockchip_drm_drv.h        |   68 +
 drivers/gpu/drm/rockchip/rockchip_drm_fb.c         |  201 +++
 drivers/gpu/drm/rockchip/rockchip_drm_fb.h         |   28 +
 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c      |  210 +++
 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h      |   21 +
 drivers/gpu/drm/rockchip/rockchip_drm_gem.c        |  294 ++++
 drivers/gpu/drm/rockchip/rockchip_drm_gem.h        |   54 +
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c        | 1455 ++++++++++++++++++++
 drivers/gpu/drm/rockchip/rockchip_drm_vop.h        |  201 +++
 16 files changed, 3188 insertions(+)

-- 
1.7.9.5
