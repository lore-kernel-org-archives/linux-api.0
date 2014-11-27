From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Subject: Re: [PATCH v14 0/3] Add drm driver for Rockchip Socs
Date: Thu, 27 Nov 2014 23:17:54 +0100
Message-ID: <3170288.yzWC52s6pC@diego>
References: <1416447994-9921-1-git-send-email-mark.yao@rock-chips.com> <5476CDF7.60208@rock-chips.com> <CAGS+omDDAYtx+02ZBMGnLXygWpfBa283pCU00vP-sahwNnoyFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <CAGS+omDDAYtx+02ZBMGnLXygWpfBa283pCU00vP-sahwNnoyFA@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Mark yao <mark.yao@rock-chips.com>, Arnd Bergmann <arnd@arndb.de>, Dave Airlie <airlied@gmail.com>, Joerg Roedel <jroedel@suse.de>, Boris BREZILLON <boris.brezillon@free-electrons.com>, Rob Clark <robdclark@gmail.com>, Daniel Vetter <daniel@ffwll.ch>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Randy Dunlap <rdunlap@infradead.org>, Grant Likely <grant.likely@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, John Stultz <john.stultz@linaro.org>, Rom Lemarchand <romlem@google.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, dri-devel <dri-devel@lists.freedesktop.org>, linux-api@vger.kernel.org, "open list:ARM/Rockchip SoC..." <linux-rock>
List-Id: linux-api@vger.kernel.org

Am Donnerstag, 27. November 2014, 14:05:00 schrieb Daniel Kurtz:
> On Thu, Nov 27, 2014 at 2:08 AM, Mark yao <mark.yao@rock-chips.com> w=
rote:
> > On 2014=E5=B9=B411=E6=9C=8827=E6=97=A5 10:12, Dave Airlie wrote:
> >>> Hi Dave
> >>>=20
> >>>      Do you mean that I need send you a branch, based on drm-next=
, merge
> >>>      with
> >>>=20
> >>> iommu tree and rockchip drm?
> >>=20
> >> Yes, grab drm-next, git pull the arm/rockchip branch from Joerg's
> >> tree, put rockchip drm
> >> patches on top, send me pull request.
> >>=20
> >> I'll validate it then.
> >>=20
> >> Dave.
> >=20
> > Hi Dave
> >=20
> >     I have send a pull request to you, with Joerg's iommu arm/rockc=
hip
> >     branch.
> >    =20
> >     I got a same problem when use "make multi_v7_defconfig" as Heik=
o said:
> >         drivers/video/fbdev/Kconfig:5:error: recursive dependency
> >         detected!
> >         drivers/video/fbdev/Kconfig:5:    symbol FB is selected by
> >         DRM_KMS_FB_HELPER drivers/gpu/drm/Kconfig:34:    symbol
> >         DRM_KMS_FB_HELPER is selected by DRM_ROCKCHIP
> >         drivers/gpu/drm/rockchip/Kconfig:1:    symbol DRM_ROCKCHIP
> >         depends on ARM_DMA_USE_IOMMU arch/arm/Kconfig:95:    symbol
> >         ARM_DMA_USE_IOMMU is selected by VIDEO_OMAP3
> >         drivers/media/platform/Kconfig:96:    symbol VIDEO_OMAP3 de=
pends
> >         on VIDEO_V4L2 drivers/media/v4l2-core/Kconfig:6:    symbol
> >         VIDEO_V4L2 depends on I2C drivers/i2c/Kconfig:7:    symbol =
I2C is
> >         selected by FB_DDC
> >         drivers/video/fbdev/Kconfig:59:    symbol FB_DDC is selecte=
d by
> >         FB_CYBER2000_DDC drivers/video/fbdev/Kconfig:374:    symbol
> >         FB_CYBER2000_DDC depends on FB_CYBER2000
> >         drivers/video/fbdev/Kconfig:362:    symbol FB_CYBER2000 dep=
ends
> >         on FB>    =20
> >     I was confused how to solve the recursive dependency, remove de=
pends
> >     on ARM_DMA_USE_IOMMU & IOMMU_API?
> The "depends on ARM_DMA_USE_IOMMU & IOMMU_API" was suggested by Arnd
> Bergmann during code review (originally they were selected).
>=20
> Removing them definitely fixes the dependency recursion.
> Also, since they are both already selected by ROCKCHIP_IOMMU,
> everything will build correctly.
> So, this sounds good to me, but I am no expert on Kconfig.

personally I'd think the omap v4l stuff is at fault here. It is selecti=
ng=20
ARM_DMA_USE_IOMMU and OMAP_IOMMU instead of depending on them.

And OMAP_IOMMU is a regular driver option which can be selected through=
=20
Kconfig, so I don't think it should get selected but enabled by choice.

It would be interesting to know if the Exynos drm is also affected by t=
his, as=20
it is using a similar depency-structure by depending on the iommu and=20
ARM_DMA_USE_IOMMU.


Heiko
