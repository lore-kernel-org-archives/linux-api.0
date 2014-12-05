From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v15 0/3] Add drm driver for Rockchip Socs
Date: Fri, 05 Dec 2014 09:33:56 +0100
Message-ID: <1435911.OORE5v4bbE@diego>
References: <1417511600-7054-1-git-send-email-mark.yao@rock-chips.com> <CAGS+omAqkQaK99OX_uAf2Z6-fep2Euwn112Oj5gFpRca8ZAgew@mail.gmail.com> <CAPM=9tzcB0XaenK1RjJoOBpJjrq84atJP59=kh6WMA2-OcFpEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPM=9tzcB0XaenK1RjJoOBpJjrq84atJP59=kh6WMA2-OcFpEA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Daniel Kurtz <djkurtz-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kever Yang <kever.yang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, simon xue <xxm-TNX95d0MmH7DzftRWevZcw@public.gmane.org>, "open list:ARM/Rockchip SoC..." <linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tao Huang <huangtao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>, "open list:OPEN FIRMWARE AND..." <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Dominik Behr <dbehr-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?utf-8?B?6Zer5a2d5Yab?= <yxj-TNX95d0MmH7DzftRWevZcw@public.gmane.org>, Eddie Cai <cf-TNX95d0MmH7DzftRWevZcw@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, =?IS
List-Id: linux-api@vger.kernel.org

Hi Dave,

Am Freitag, 5. Dezember 2014, 17:26:04 schrieb Dave Airlie:
> On 5 December 2014 at 05:29, Daniel Kurtz <djkurtz-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
> > I thought the recommended solution for this was to fix OMAP3 to not
> > select  ARM_DMA_USE_IOMMU and OMAP_IOMMU, not to drop the 'depends on'
> > in drm/rockchip?
> 
> Lets fix that up once we get this merged, if I had a tree based on the
> iommu I'd have
> it -next now.
> 
> can I get a pull for that?

Mark sent a pull on tuesday as reply to the cover-letter.
Message-ID: <547D88D7.5080005-TNX95d0MmH7DzftRWevZcw@public.gmane.org>

Replicated here, if you don't want to search.


Heiko

---------------- 8< -------------------------------------

Hi Dave

The following changes since commit 656d7077d8ffd1c2492d4a0a354367ab2e545059:

   dt-bindings: iommu: Add documentation for rockchip iommu (2014-11-03 
17:29:09 +0100)

are available in the git repository at:

   https://github.com/markyzq/kernel-drm-rockchip.git drm_iommu_v15

for you to fetch changes up to 5ac4837b12f533de5d9f8f66b45494c58e805536:

   dt-bindings: video: Add documentation for rockchip vop (2014-12-02 
17:29:33 +0800)

----------------------------------------------------------------
Mark Yao (3):
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
  create mode 100644 Documentation/devicetree/bindings/video/rockchip-drm.txt
  create mode 100644 Documentation/devicetree/bindings/video/rockchip-vop.txt
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
