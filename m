From: Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Subject: Re: [PATCH v14 0/3] Add drm driver for Rockchip Socs
Date: Thu, 27 Nov 2014 15:08:39 +0800
Message-ID: <5476CDF7.60208@rock-chips.com>
References: <1416447994-9921-1-git-send-email-mark.yao@rock-chips.com>	<23617908.6oA5uRuO3l@diego>	<CAPM=9tzvvb5U+8KaCO+K6CJi=rwWOkoW+4ZSFW_Oo9gTncvkWA@mail.gmail.com>	<1557742.FTdLsE0bVs@diego>	<20141126073430.GD3156@suse.de>	<CAPM=9tzhZLShA5=ShGTKhyZR6ddKycQDUWBZxXpUBb+1tGp-mQ@mail.gmail.com>	<54768107.2090402@rock-chips.com> <CAPM=9tyZpDEPcipYDq2_qdQ9zK2bnPFYTUL2qDvAd7QoUOm-QQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPM=9tyZpDEPcipYDq2_qdQ9zK2bnPFYTUL2qDvAd7QoUOm-QQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Joerg Roedel <jroedel-l3A5Bk7waGM@public.gmane.org>, =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>, Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rom Lemarchand <romlem-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Douglas Anderson <dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?UTF-8?B?U3T
List-Id: linux-api@vger.kernel.org

On 2014=E5=B9=B411=E6=9C=8827=E6=97=A5 10:12, Dave Airlie wrote:
>>>
>> Hi Dave
>>      Do you mean that I need send you a branch, based on drm-next, m=
erge with
>> iommu tree and rockchip drm?
> Yes, grab drm-next, git pull the arm/rockchip branch from Joerg's
> tree, put rockchip drm
> patches on top, send me pull request.
>
> I'll validate it then.
>
> Dave.
>
Hi Dave
     I have send a pull request to you, with Joerg's iommu arm/rockchip=
=20
branch.

     I got a same problem when use "make multi_v7_defconfig" as Heiko s=
aid:
         drivers/video/fbdev/Kconfig:5:error: recursive dependency dete=
cted!
         drivers/video/fbdev/Kconfig:5:    symbol FB is selected by=20
DRM_KMS_FB_HELPER
         drivers/gpu/drm/Kconfig:34:    symbol DRM_KMS_FB_HELPER is=20
selected by DRM_ROCKCHIP
         drivers/gpu/drm/rockchip/Kconfig:1:    symbol DRM_ROCKCHIP=20
depends on ARM_DMA_USE_IOMMU
         arch/arm/Kconfig:95:    symbol ARM_DMA_USE_IOMMU is selected b=
y=20
VIDEO_OMAP3
         drivers/media/platform/Kconfig:96:    symbol VIDEO_OMAP3=20
depends on VIDEO_V4L2
         drivers/media/v4l2-core/Kconfig:6:    symbol VIDEO_V4L2 depend=
s=20
on I2C
         drivers/i2c/Kconfig:7:    symbol I2C is selected by FB_DDC
         drivers/video/fbdev/Kconfig:59:    symbol FB_DDC is selected b=
y=20
=46B_CYBER2000_DDC
         drivers/video/fbdev/Kconfig:374:    symbol FB_CYBER2000_DDC=20
depends on FB_CYBER2000
         drivers/video/fbdev/Kconfig:362:    symbol FB_CYBER2000 depend=
s=20
on FB

     I was confused how to solve the recursive dependency, remove=20
depends on ARM_DMA_USE_IOMMU & IOMMU_API?

- Mark



--
To unsubscribe from this list: send the line "unsubscribe devicetree" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
