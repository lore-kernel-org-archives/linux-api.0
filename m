From: Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 5/5] drm/rockchip: Add support for Rockchip Soc EDP
Date: Tue, 23 Sep 2014 19:35:04 -0400
Message-ID: <CAF6AEGtZGypyV4EnWZr4LziEnOriKZr1ggn+AtkuPnf2ud5gBw@mail.gmail.com>
References: <1411382820-1615-1-git-send-email-mark.yao@rock-chips.com>
	<1411383728-2075-1-git-send-email-mark.yao@rock-chips.com>
	<CAF6AEGtxUGr2i+mK7dtfTXaf2SxHkokxw2sNCviwRR6Hn7RE2w@mail.gmail.com>
	<5421338B.3020302@rock-chips.com>
	<CAF6AEGuGKitXGE8S-fE-d+-MWDBxU-XqG_AH7q9FD0y5YkBFVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAF6AEGuGKitXGE8S-fE-d+-MWDBxU-XqG_AH7q9FD0y5YkBFVQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: cym <cym-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Cc: Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>, =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>, Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, David Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rom Lemarchand <romlem-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Douglas Anderson <dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Sep 23, 2014 at 9:56 AM, Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Tue, Sep 23, 2014 at 4:47 AM, cym <cym-TNX95d0MmH7DzftRWevZcw@public.gmane.org> wrote:
>>
>> On Tuesday, September 23, 2014 03:20 AM, Rob Clark wrote:
>>>
>>> On Mon, Sep 22, 2014 at 7:02 AM, Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org> wrote:
>>>>
>>>> This adds support for Rockchip soc edp found on rk3288
>>>>
>>>> Signed-off-by: Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
>>>> Signed-off-by: Jeff Chen <jeff.chen-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
>>>> ---
>>>> Changes in v2:
>>>> - fix code sytle
>>>> - use some define from drm_dp_helper.h
>>>> - use panel-simple driver for primary display.
>>>> - remove unnecessary clock clk_24m_parent.
>>>>
>>>> Changes in v3: None
>>>>
>>>> Changes in v4: None
>>>>
>>>>   drivers/gpu/drm/rockchip/Kconfig             |    9 +
>>>>   drivers/gpu/drm/rockchip/Makefile            |    2 +
>>>>   drivers/gpu/drm/rockchip/rockchip_edp_core.c |  853 ++++++++++++++++++
>>>>   drivers/gpu/drm/rockchip/rockchip_edp_core.h |  309 +++++++
>>>>   drivers/gpu/drm/rockchip/rockchip_edp_reg.c  | 1202
>>>> ++++++++++++++++++++++++++
>>>>   drivers/gpu/drm/rockchip/rockchip_edp_reg.h  |  345 ++++++++
>>>>   6 files changed, 2720 insertions(+)
>>>>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_edp_core.c
>>>>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_edp_core.h
>>>>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_edp_reg.c
>>>>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_edp_reg.h
>>>>
>>>> diff --git a/drivers/gpu/drm/rockchip/Kconfig
>>>> b/drivers/gpu/drm/rockchip/Kconfig
>>>> index 7146c80..04b1f8c 100644
>>>> --- a/drivers/gpu/drm/rockchip/Kconfig
>>>> +++ b/drivers/gpu/drm/rockchip/Kconfig
>>>> @@ -17,3 +17,12 @@ config DRM_ROCKCHIP
>>>>            management to userspace. This driver does not provides
>>>>            2D or 3D acceleration; acceleration is performed by other
>>>>            IP found on the SoC.
>>>> +
>>>> +config ROCKCHIP_EDP
>>>> +       bool "Rockchip edp support"
>>>> +       depends on DRM_ROCKCHIP
>>>> +       help
>>>> +         Choose this option if you have a Rockchip eDP.
>>>> +         Rockchip rk3288 SoC has eDP TX Controller can be used.
>>>> +         If you have an Embedded DisplayPort Panel, say Y to enable its
>>>> +         driver.
>>>> diff --git a/drivers/gpu/drm/rockchip/Makefile
>>>> b/drivers/gpu/drm/rockchip/Makefile
>>>> index 6e6d468..a0fc3a1 100644
>>>> --- a/drivers/gpu/drm/rockchip/Makefile
>>>> +++ b/drivers/gpu/drm/rockchip/Makefile
>>>> @@ -7,4 +7,6 @@ ccflags-y := -Iinclude/drm -Idrivers/gpu/drm/rockchip
>>>>   rockchipdrm-y := rockchip_drm_drv.o rockchip_drm_fb.o
>>>> rockchip_drm_fbdev.o \
>>>>                  rockchip_drm_gem.o rockchip_drm_vop.o
>>>>
>>>> +rockchipdrm-$(CONFIG_ROCKCHIP_EDP) += rockchip_edp_core.o
>>>> rockchip_edp_reg.o
>>>> +
>>>>   obj-$(CONFIG_DRM_ROCKCHIP) += rockchipdrm.o
>>>> diff --git a/drivers/gpu/drm/rockchip/rockchip_edp_core.c
>>>> b/drivers/gpu/drm/rockchip/rockchip_edp_core.c
>>>> new file mode 100644
>>>> index 0000000..5450d1fa
>>>> --- /dev/null
>>>> +++ b/drivers/gpu/drm/rockchip/rockchip_edp_core.c
>>>> @@ -0,0 +1,853 @@
>>>> +/*
>>>> +* Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
>>>> +* Author:
>>>> +*      Andy yan <andy.yan-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
>>>> +*      Jeff chen <jeff.chen-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
>>>> +*
>>>> +* based on exynos_dp_core.c
>>>> +*
>>>
>>> hmm, did you look at all at drm_dp_helpers?  The exynos code probably
>>> pre-dates the helpers, so might not be the best example to work off
>>> of..
>>>
>>> If there is actually a valid reason not to use the dp-helpers, then
>>> you should mention the reasons, at least in the commit msg if not the
>>> code
>>>
>>> BR,
>>> -R
>>
>> Thanks Rob,Because RK3288 eDP controller IP design is similar to exynos.They
>> from same IP vendors but have some difference.
>> So we choosed exynos_dp as example to work off of.exynos_dp only used some
>> defines from drm_dp_helper.h like DPCD.
>>
>
>
> Hmm, it sounds like it perhaps should be refactored out into a
> drm_bridge so more of it can be shared between rockchip and exynos.
>
> Either way, it should be using the drm_dp_helpers..  That "the code I
> copied did it wrong" isn't a terribly good reason for new drivers to
> do it wrong.
>
> So NAK for the eDP part until you use the helpers.

and btw, if it wasn't clear, go ahead and at least repost the core
part of the driver.. the first patch just needed a few small tweaks to
get my r-b even if it takes longer to sort out something sane for the
DP part..

BR,
-R
