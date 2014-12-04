From: Daniel Kurtz <djkurtz-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v15 0/3] Add drm driver for Rockchip Socs
Date: Thu, 4 Dec 2014 11:29:51 -0800
Message-ID: <CAGS+omAqkQaK99OX_uAf2Z6-fep2Euwn112Oj5gFpRca8ZAgew@mail.gmail.com>
References: <1417511600-7054-1-git-send-email-mark.yao@rock-chips.com> <2556534.qktPW9tbxy@diego>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2556534.qktPW9tbxy@diego>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>
Cc: Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kever Yang <kever.yang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, simon xue <xxm-TNX95d0MmH7DzftRWevZcw@public.gmane.org>, "open list:ARM/Rockchip SoC..." <linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tao Huang <huangtao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>, "open list:OPEN FIRMWARE AND..." <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Dominik Behr <dbehr-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?UTF-8?B?6Zer5a2d5Yab?= <yxj-TNX95d0MmH7DzftRWevZcw@public.gmane.org>, Eddie Cai <cf-TNX95d0MmH7DzftRWevZcw@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>=?UTF-8?
List-Id: linux-api@vger.kernel.org

On Tue, Dec 2, 2014 at 1:31 AM, Heiko St=C3=BCbner <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org> wr=
ote:
> Hi Mark,
>
> Am Dienstag, 2. Dezember 2014, 17:13:20 schrieb Mark Yao:
>> This a series of patches is a DRM Driver for Rockchip Socs, add supp=
ort
>> for vop devices. Future patches will add additional encoders/connect=
ors,
>> such as eDP, HDMI.
>>
>> The basic "crtc" for rockchip is a "VOP" - Video Output Processor.
>> the vop devices found on Rockchip rk3288 Soc, rk3288 soc have two si=
milar
>> Vop devices. Vop devices support iommu mapping, we use dma-mapping A=
PI with
>> ARM_DMA_USE_IOMMU.
>
> [...]
>
>> Changes in v15:
>> - remove depends on ARM_DMA_USE_IOMMU & IOMMU_API which cause
>>   recursive dependency problem

I thought the recommended solution for this was to fix OMAP3 to not
select  ARM_DMA_USE_IOMMU and OMAP_IOMMU, not to drop the 'depends on'
in drm/rockchip?

>> - fix compile problems when build as a module.
>
> maybe you could also already create a new pull request for this versi=
on [like
> the last one based on the iommu branch], so that we save time and Dav=
e can
> pull it in easily for testing if he likes.
>
>
> Heiko
>
> _______________________________________________
> Linux-rockchip mailing list
> Linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> http://lists.infradead.org/mailman/listinfo/linux-rockchip
