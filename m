From: Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 1/3] drm/rockchip: Add basic drm driver
Date: Thu, 25 Sep 2014 19:56:34 -0400
Message-ID: <CAF6AEGu+EBtYyfpthk8NaPuh6cAQXDc+=hnNORRZqb4t=yO00g@mail.gmail.com>
References: <1411524672-14524-1-git-send-email-mark.yao@rock-chips.com>
	<1411524746-14635-1-git-send-email-mark.yao@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1411524746-14635-1-git-send-email-mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>, Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, David Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rom Lemarchand <romlem-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Douglas Anderson <dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?UTF-8?Q?St=C3=A9phane_Marchesin?=
List-Id: linux-api@vger.kernel.org

On Tue, Sep 23, 2014 at 10:12 PM, Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org> wrote:
> This patch adds the basic structure of a DRM Driver for Rockchip Socs.
>
> Signed-off-by: Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>

Looks like my comments are addressed, so:

Reviewed-by: Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

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
>  drivers/gpu/drm/Kconfig                       |    2 +
>  drivers/gpu/drm/Makefile                      |    1 +
>  drivers/gpu/drm/rockchip/Kconfig              |   17 +
>  drivers/gpu/drm/rockchip/Makefile             |    8 +
>  drivers/gpu/drm/rockchip/rockchip_drm_drv.c   |  509 +++++++++
>  drivers/gpu/drm/rockchip/rockchip_drm_drv.h   |  120 +++
>  drivers/gpu/drm/rockchip/rockchip_drm_fb.c    |  201 ++++
>  drivers/gpu/drm/rockchip/rockchip_drm_fb.h    |   28 +
>  drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c |  230 +++++
>  drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h |   20 +
>  drivers/gpu/drm/rockchip/rockchip_drm_gem.c   |  341 ++++++
>  drivers/gpu/drm/rockchip/rockchip_drm_gem.h   |   55 +
>  drivers/gpu/drm/rockchip/rockchip_drm_vop.c   | 1373 +++++++++++++++++++++++++
>  drivers/gpu/drm/rockchip/rockchip_drm_vop.h   |  187 ++++
>  14 files changed, 3092 insertions(+)
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
