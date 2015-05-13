From: CK Hu <ck.hu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: [RFC][PATCH 0/2] MT8173 DRM support
Date: Wed, 13 May 2015 23:23:44 +0800
Message-ID: <1431530626-31493-1-git-send-email-ck.hu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Matthias Brugger <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ashwin Chaugule <ashwin.chaugule-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Graeme Gregory <graeme.gregory-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, srv_heupstream-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, Sascha Hauer <kernel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Cawa Cheng <cawa.cheng-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, YT Shen <yt.shen-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, Jitao Shi <jitao.shi-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

MT8173 DRM include one master drm device and three sub device: dsi device,
crtc main device, and ddp device.

Master drm device control the drm sub device and memory management.
dsi device is a drm connector/encoder device which control MIPI/DSI hw block.
crtc main is a drm crtc device which control hw components in the display data
path.
ddp is a device which control display data path.

Display data path of crtc main is:
[OVL0] -> [COLOR0] -> [AAL] -> [OD] -> [UFOE] -> [RDMA0]

This patch depends on the other patches:
1. MT8173 IOMMU support
	http://lists.infradead.org/pipermail/linux-mediatek/2015-March/000058.html
2. add IOMMU dma_ops
	cherry picked from git://linux-arm.org/linux-rm iommu/dma
		commit d76a1911b02185bdc5f8b5525f9228cf266725c5

CK Hu (2):
  dt-bindings: drm/mediatek: Add Mediatek DRM dts binding
  drm/mediatek: Add DRM Driver for Mediatek SoC MT8173.

 .../bindings/drm/mediatek/mediatek,crtc-main.txt   |   38 +
 .../bindings/drm/mediatek/mediatek,ddp.txt         |   22 +
 .../bindings/drm/mediatek/mediatek,drm.txt         |   27 +
 .../bindings/drm/mediatek/mediatek,dsi.txt         |   20 +
 drivers/gpu/drm/Kconfig                            |    2 +
 drivers/gpu/drm/Makefile                           |    1 +
 drivers/gpu/drm/mediatek/Kconfig                   |   28 +
 drivers/gpu/drm/mediatek/Makefile                  |   13 +
 drivers/gpu/drm/mediatek/mediatek_drm_crtc.c       |  246 ++++
 drivers/gpu/drm/mediatek/mediatek_drm_crtc.h       |   80 ++
 drivers/gpu/drm/mediatek/mediatek_drm_crtc_main.c  |  420 ++++++
 drivers/gpu/drm/mediatek/mediatek_drm_ddp.c        |  202 +++
 drivers/gpu/drm/mediatek/mediatek_drm_ddp.h        |   23 +
 drivers/gpu/drm/mediatek/mediatek_drm_ddp_comp.c   |  346 +++++
 drivers/gpu/drm/mediatek/mediatek_drm_ddp_comp.h   |   33 +
 drivers/gpu/drm/mediatek/mediatek_drm_drv.c        |  369 ++++++
 drivers/gpu/drm/mediatek/mediatek_drm_drv.h        |   37 +
 drivers/gpu/drm/mediatek/mediatek_drm_dsi.c        | 1333 ++++++++++++++++++++
 drivers/gpu/drm/mediatek/mediatek_drm_dsi.h        |   71 ++
 drivers/gpu/drm/mediatek/mediatek_drm_fb.c         |  339 +++++
 drivers/gpu/drm/mediatek/mediatek_drm_fb.h         |   43 +
 drivers/gpu/drm/mediatek/mediatek_drm_gem.c        |  315 +++++
 drivers/gpu/drm/mediatek/mediatek_drm_gem.h        |   94 ++
 include/uapi/drm/mediatek_drm.h                    |   59 +
 24 files changed, 4161 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/drm/mediatek/mediatek,crtc-main.txt
 create mode 100644 Documentation/devicetree/bindings/drm/mediatek/mediatek,ddp.txt
 create mode 100644 Documentation/devicetree/bindings/drm/mediatek/mediatek,drm.txt
 create mode 100644 Documentation/devicetree/bindings/drm/mediatek/mediatek,dsi.txt
 create mode 100644 drivers/gpu/drm/mediatek/Kconfig
 create mode 100644 drivers/gpu/drm/mediatek/Makefile
 create mode 100644 drivers/gpu/drm/mediatek/mediatek_drm_crtc.c
 create mode 100644 drivers/gpu/drm/mediatek/mediatek_drm_crtc.h
 create mode 100644 drivers/gpu/drm/mediatek/mediatek_drm_crtc_main.c
 create mode 100644 drivers/gpu/drm/mediatek/mediatek_drm_ddp.c
 create mode 100644 drivers/gpu/drm/mediatek/mediatek_drm_ddp.h
 create mode 100644 drivers/gpu/drm/mediatek/mediatek_drm_ddp_comp.c
 create mode 100644 drivers/gpu/drm/mediatek/mediatek_drm_ddp_comp.h
 create mode 100644 drivers/gpu/drm/mediatek/mediatek_drm_drv.c
 create mode 100644 drivers/gpu/drm/mediatek/mediatek_drm_drv.h
 create mode 100644 drivers/gpu/drm/mediatek/mediatek_drm_dsi.c
 create mode 100644 drivers/gpu/drm/mediatek/mediatek_drm_dsi.h
 create mode 100644 drivers/gpu/drm/mediatek/mediatek_drm_fb.c
 create mode 100644 drivers/gpu/drm/mediatek/mediatek_drm_fb.h
 create mode 100644 drivers/gpu/drm/mediatek/mediatek_drm_gem.c
 create mode 100644 drivers/gpu/drm/mediatek/mediatek_drm_gem.h
 create mode 100644 include/uapi/drm/mediatek_drm.h

-- 
1.8.1.1.dirty


--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
