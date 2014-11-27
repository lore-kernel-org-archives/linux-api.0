From: Rob Clark <robdclark@gmail.com>
Subject: Re: [PATCH v14 0/3] Add drm driver for Rockchip Socs
Date: Thu, 27 Nov 2014 17:16:45 -0500
Message-ID: <CAF6AEGvqk20XDQMzzcoAW+nxPuwbHHBQ6FyXahYMk+2MjUE_ag@mail.gmail.com>
References: <1416447994-9921-1-git-send-email-mark.yao@rock-chips.com>
	<5476CDF7.60208@rock-chips.com>
	<CAGS+omDDAYtx+02ZBMGnLXygWpfBa283pCU00vP-sahwNnoyFA@mail.gmail.com>
	<3124625.mkxyU0zW0C@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <3124625.mkxyU0zW0C@wuerfel>
Sender: linux-doc-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Mark yao <mark.yao@rock-chips.com>, Dave Airlie <airlied@gmail.com>, Joerg Roedel <jroedel@suse.de>, =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>, Boris BREZILLON <boris.brezillon@free-electrons.com>, Daniel Vetter <daniel@ffwll.ch>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Randy Dunlap <rdunlap@infradead.org>, Grant Likely <grant.likely@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, John Stultz <john.stultz@linaro.org>, Rom Lemarchand <romlem@google.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, dri-devel <dri-devel@lists.freedesktop.org>, linux-api@vger.kernel.org, open list:ARM/Rock
List-Id: linux-api@vger.kernel.org

On Thu, Nov 27, 2014 at 4:56 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 27 November 2014 14:05:00 Daniel Kurtz wrote:
>> On Thu, Nov 27, 2014 at 2:08 AM, Mark yao <mark.yao@rock-chips.com> =
wrote:
>> >
>> > On 2014=E5=B9=B411=E6=9C=8827=E6=97=A5 10:12, Dave Airlie wrote:
>> >>>>
>> >>>>
>> >>> Hi Dave
>> >>>      Do you mean that I need send you a branch, based on drm-nex=
t, merge with
>> >>> iommu tree and rockchip drm?
>> >>
>> >> Yes, grab drm-next, git pull the arm/rockchip branch from Joerg's
>> >> tree, put rockchip drm
>> >> patches on top, send me pull request.
>> >>
>> >> I'll validate it then.
>> >>
>> >> Dave.
>> >>
>> > Hi Dave
>> >     I have send a pull request to you, with Joerg's iommu arm/rock=
chip branch.
>> >
>> >     I got a same problem when use "make multi_v7_defconfig" as Hei=
ko said:
>> >         drivers/video/fbdev/Kconfig:5:error: recursive dependency =
detected!
>> >         drivers/video/fbdev/Kconfig:5:    symbol FB is selected by=
 DRM_KMS_FB_HELPER
>> >         drivers/gpu/drm/Kconfig:34:    symbol DRM_KMS_FB_HELPER is=
 selected by DRM_ROCKCHIP
>> >         drivers/gpu/drm/rockchip/Kconfig:1:    symbol DRM_ROCKCHIP=
 depends on ARM_DMA_USE_IOMMU
>> >         arch/arm/Kconfig:95:    symbol ARM_DMA_USE_IOMMU is select=
ed by VIDEO_OMAP3
>> >         drivers/media/platform/Kconfig:96:    symbol VIDEO_OMAP3 d=
epends on VIDEO_V4L2
>> >         drivers/media/v4l2-core/Kconfig:6:    symbol VIDEO_V4L2 de=
pends on I2C
>> >         drivers/i2c/Kconfig:7:    symbol I2C is selected by FB_DDC
>> >         drivers/video/fbdev/Kconfig:59:    symbol FB_DDC is select=
ed by FB_CYBER2000_DDC
>> >         drivers/video/fbdev/Kconfig:374:    symbol FB_CYBER2000_DD=
C depends on FB_CYBER2000
>> >         drivers/video/fbdev/Kconfig:362:    symbol FB_CYBER2000 de=
pends on FB
>> >
>> >     I was confused how to solve the recursive dependency, remove d=
epends on ARM_DMA_USE_IOMMU & IOMMU_API?
>>
>> The "depends on ARM_DMA_USE_IOMMU & IOMMU_API" was suggested by Arnd
>> Bergmann during code review (originally they were selected).
>>
>> Removing them definitely fixes the dependency recursion.
>> Also, since they are both already selected by ROCKCHIP_IOMMU,
>> everything will build correctly.
>> So, this sounds good to me, but I am no expert on Kconfig.
>>
>
> I think the problem here is VIDEO_OMAP3 (among others), it should do =
the
> same as rockchips and use 'depends on' instead of 'select'.
>
> Another problem is the 'select I2C' in FB_DDC, but that would be much=
 harder
> to fix.

that 'select I2C' is the source of many loops..  I'd looked at it
briefly before, but then ran away in despair.

BR,
-R

>         Arnd
