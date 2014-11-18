From: Mark Yao <mark.yao@rock-chips.com>
Subject: [PATCH v13 0/3] Add drm driver for Rockchip Socs
Date: Tue, 18 Nov 2014 18:09:11 +0800
Message-ID: <1416305354-27789-1-git-send-email-mark.yao@rock-chips.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: heiko@sntech.de, Boris BREZILLON <boris.brezillon@free-electrons.com>, David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>, Daniel Vetter <daniel@ffwll.ch>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Randy Dunlap <rdunlap@infradead.org>, Grant Likely <grant.likely@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, John Stultz <john.stultz@linaro.org>, Rom Lemarchand <romlem@google.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org, linux-rockchip@lists.infradead.org, dianders@chromium.org, marcheu@chromium.org, dbehr@chromium.org, olof@lixom.net, djkurtz@chromium.org, cf@rock-chips.com, xxm@rock-chips.com, huangtao@rock-chips.com, kever.yang@rock-chips.com, yxj@rock-chips.com, xw@rock-chips.com, Mark Yao <mark.yao@rock-chips.com>
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
because the win config take affect at frame start time, if we use ling flag
interrupt, the address check often failed.
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
 drivers/gpu/drm/rockchip/rockchip_drm_drv.c        |  485 +++++++
 drivers/gpu/drm/rockchip/rockchip_drm_drv.h        |   55 +
 drivers/gpu/drm/rockchip/rockchip_drm_fb.c         |  200 +++
 drivers/gpu/drm/rockchip/rockchip_drm_fb.h         |   28 +
 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c      |  210 +++
 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h      |   20 +
 drivers/gpu/drm/rockchip/rockchip_drm_gem.c        |  294 ++++
 drivers/gpu/drm/rockchip/rockchip_drm_gem.h        |   54 +
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c        | 1459 ++++++++++++++++++++
 drivers/gpu/drm/rockchip/rockchip_drm_vop.h        |  201 +++
 16 files changed, 3111 insertions(+)

-- 
1.7.9.5
