From: jeff chen <jeff.chen@rock-chips.com>
Subject: Re: [PATCH v4 5/5] drm/rockchip: Add support for Rockchip Soc EDP
Date: Wed, 24 Sep 2014 18:30:33 +0800
Message-ID: <54229D49.4070008@rock-chips.com>
References: <1411382820-1615-1-git-send-email-mark.yao@rock-chips.com> <1411383728-2075-1-git-send-email-mark.yao@rock-chips.com> <CAF6AEGtxUGr2i+mK7dtfTXaf2SxHkokxw2sNCviwRR6Hn7RE2w@mail.gmail.com> <5421338B.3020302@rock-chips.com> <CAF6AEGuGKitXGE8S-fE-d+-MWDBxU-XqG_AH7q9FD0y5YkBFVQ@mail.gmail.com> <CAF6AEGtZGypyV4EnWZr4LziEnOriKZr1ggn+AtkuPnf2ud5gBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAF6AEGtZGypyV4EnWZr4LziEnOriKZr1ggn+AtkuPnf2ud5gBw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Clark <robdclark@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>, =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>, linux-doc@vger.kernel.org, Kever Yang <kever.yang@rock-chips.com>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jianqun Xu <xjq@rock-chips.com>, Chris Zhong <zyw@rock-chips.com>, linux-api@vger.kernel.org, David Airlie <airlied@gmail.com>, Boris BREZILLON <boris.brezillon@free-electrons.com>, simon xue <xxm@rock-chips.com>, linux-rockchip@lists.infradead.org, kfx@rock-chips.com, Grant Likely <grant.likely@linaro.org>, =?UTF-8?B?546L5pmT6IW+?= <wxt@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, dbehr@chromium.org, yxj@rock-chips.com, Eddie Cai <cf@rock-chip>
List-Id: linux-api@vger.kernel.org


On 2014/9/24 7:35, Rob Clark wrote:
> On Tue, Sep 23, 2014 at 9:56 AM, Rob Clark <robdclark@gmail.com> wrote:
>> On Tue, Sep 23, 2014 at 4:47 AM, cym <cym@rock-chips.com> wrote:
>>> On Tuesday, September 23, 2014 03:20 AM, Rob Clark wrote:
>>>> On Mon, Sep 22, 2014 at 7:02 AM, Mark yao <mark.yao@rock-chips.com> wrote:
>>>>> This adds support for Rockchip soc edp found on rk3288
>>>>>
>>>>> Signed-off-by: Mark Yao <mark.yao@rock-chips.com>
>>>>> Signed-off-by: Jeff Chen <jeff.chen@rock-chips.com>
>>>>> ---
>>>>> Changes in v2:
>>>>> - fix code sytle
>>>>> - use some define from drm_dp_helper.h
>>>>> - use panel-simple driver for primary display.
>>>>> - remove unnecessary clock clk_24m_parent.
>>>>>
>>>>> Changes in v3: None
>>>>>
>>>>> Changes in v4: None
>>>>>
>>>>>    drivers/gpu/drm/rockchip/Kconfig             |    9 +
>>>>>    drivers/gpu/drm/rockchip/Makefile            |    2 +
>>>>>    drivers/gpu/drm/rockchip/rockchip_edp_core.c |  853 ++++++++++++++++++
>>>>>    drivers/gpu/drm/rockchip/rockchip_edp_core.h |  309 +++++++
>>>>>    drivers/gpu/drm/rockchip/rockchip_edp_reg.c  | 1202
>>>>> ++++++++++++++++++++++++++
>>>>>    drivers/gpu/drm/rockchip/rockchip_edp_reg.h  |  345 ++++++++
>>>>>    6 files changed, 2720 insertions(+)
>>>>>    create mode 100644 drivers/gpu/drm/rockchip/rockchip_edp_core.c
>>>>>    create mode 100644 drivers/gpu/drm/rockchip/rockchip_edp_core.h
>>>>>    create mode 100644 drivers/gpu/drm/rockchip/rockchip_edp_reg.c
>>>>>    create mode 100644 drivers/gpu/drm/rockchip/rockchip_edp_reg.h
>>>>>
>>>>> diff --git a/drivers/gpu/drm/rockchip/Kconfig
>>>>> b/drivers/gpu/drm/rockchip/Kconfig
>>>>> index 7146c80..04b1f8c 100644
>>>>> --- a/drivers/gpu/drm/rockchip/Kconfig
>>>>> +++ b/drivers/gpu/drm/rockchip/Kconfig
>>>>> @@ -17,3 +17,12 @@ config DRM_ROCKCHIP
>>>>>             management to userspace. This driver does not provides
>>>>>             2D or 3D acceleration; acceleration is performed by other
>>>>>             IP found on the SoC.
>>>>> +
>>>>> +config ROCKCHIP_EDP
>>>>> +       bool "Rockchip edp support"
>>>>> +       depends on DRM_ROCKCHIP
>>>>> +       help
>>>>> +         Choose this option if you have a Rockchip eDP.
>>>>> +         Rockchip rk3288 SoC has eDP TX Controller can be used.
>>>>> +         If you have an Embedded DisplayPort Panel, say Y to enable its
>>>>> +         driver.
>>>>> diff --git a/drivers/gpu/drm/rockchip/Makefile
>>>>> b/drivers/gpu/drm/rockchip/Makefile
>>>>> index 6e6d468..a0fc3a1 100644
>>>>> --- a/drivers/gpu/drm/rockchip/Makefile
>>>>> +++ b/drivers/gpu/drm/rockchip/Makefile
>>>>> @@ -7,4 +7,6 @@ ccflags-y := -Iinclude/drm -Idrivers/gpu/drm/rockchip
>>>>>    rockchipdrm-y := rockchip_drm_drv.o rockchip_drm_fb.o
>>>>> rockchip_drm_fbdev.o \
>>>>>                   rockchip_drm_gem.o rockchip_drm_vop.o
>>>>>
>>>>> +rockchipdrm-$(CONFIG_ROCKCHIP_EDP) += rockchip_edp_core.o
>>>>> rockchip_edp_reg.o
>>>>> +
>>>>>    obj-$(CONFIG_DRM_ROCKCHIP) += rockchipdrm.o
>>>>> diff --git a/drivers/gpu/drm/rockchip/rockchip_edp_core.c
>>>>> b/drivers/gpu/drm/rockchip/rockchip_edp_core.c
>>>>> new file mode 100644
>>>>> index 0000000..5450d1fa
>>>>> --- /dev/null
>>>>> +++ b/drivers/gpu/drm/rockchip/rockchip_edp_core.c
>>>>> @@ -0,0 +1,853 @@
>>>>> +/*
>>>>> +* Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
>>>>> +* Author:
>>>>> +*      Andy yan <andy.yan@rock-chips.com>
>>>>> +*      Jeff chen <jeff.chen@rock-chips.com>
>>>>> +*
>>>>> +* based on exynos_dp_core.c
>>>>> +*
>>>> hmm, did you look at all at drm_dp_helpers?  The exynos code probably
>>>> pre-dates the helpers, so might not be the best example to work off
>>>> of..
>>>>
>>>> If there is actually a valid reason not to use the dp-helpers, then
>>>> you should mention the reasons, at least in the commit msg if not the
>>>> code
>>>>
>>>> BR,
>>>> -R
>>> Thanks Rob,Because RK3288 eDP controller IP design is similar to exynos.They
>>> from same IP vendors but have some difference.
>>> So we choosed exynos_dp as example to work off of.exynos_dp only used some
>>> defines from drm_dp_helper.h like DPCD.
>>>
>>
>> Hmm, it sounds like it perhaps should be refactored out into a
>> drm_bridge so more of it can be shared between rockchip and exynos.
>>
>> Either way, it should be using the drm_dp_helpers..  That "the code I
>> copied did it wrong" isn't a terribly good reason for new drivers to
>> do it wrong.
>>
>> So NAK for the eDP part until you use the helpers.
> and btw, if it wasn't clear, go ahead and at least repost the core
> part of the driver.. the first patch just needed a few small tweaks to
> get my r-b even if it takes longer to sort out something sane for the
> DP part..
>
> BR,
> -R
thanks,I will modify the core part of the driver.

BR,
-Jeff
> _______________________________________________
> Linux-rockchip mailing list
> Linux-rockchip@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-rockchip
>
>
>
