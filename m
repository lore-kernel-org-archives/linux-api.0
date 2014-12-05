From: Dave Airlie <airlied@gmail.com>
Subject: Re: [PATCH v15 0/3] Add drm driver for Rockchip Socs
Date: Fri, 5 Dec 2014 17:26:04 +1000
Message-ID: <CAPM=9tzcB0XaenK1RjJoOBpJjrq84atJP59=kh6WMA2-OcFpEA@mail.gmail.com>
References: <1417511600-7054-1-git-send-email-mark.yao@rock-chips.com>
	<2556534.qktPW9tbxy@diego>
	<CAGS+omAqkQaK99OX_uAf2Z6-fep2Euwn112Oj5gFpRca8ZAgew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <CAGS+omAqkQaK99OX_uAf2Z6-fep2Euwn112Oj5gFpRca8ZAgew@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>, Mark Yao <mark.yao@rock-chips.com>, Mark Rutland <mark.rutland@arm.com>, linux-doc@vger.kernel.org, Kever Yang <kever.yang@rock-chips.com>, dri-devel <dri-devel@lists.freedesktop.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Boris BREZILLON <boris.brezillon@free-electrons.com>, simon xue <xxm@rock-chips.com>, "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>, Grant Likely <grant.likely@linaro.org>, Tao Huang <huangtao@rock-chips.com>, "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Dominik Behr <dbehr@chromium.org>, =?UTF-8?B?6Zer5a2d5Yab?= <yxj@rock-chips.com>, Eddie Cai <cf@rock-chips.com>, Rob Herring <robh+dt@kernel.org>, John Stultz <john.stultz@linar>
List-Id: linux-api@vger.kernel.org

On 5 December 2014 at 05:29, Daniel Kurtz <djkurtz@chromium.org> wrote:
> On Tue, Dec 2, 2014 at 1:31 AM, Heiko St=C3=BCbner <heiko@sntech.de> =
wrote:
>> Hi Mark,
>>
>> Am Dienstag, 2. Dezember 2014, 17:13:20 schrieb Mark Yao:
>>> This a series of patches is a DRM Driver for Rockchip Socs, add sup=
port
>>> for vop devices. Future patches will add additional encoders/connec=
tors,
>>> such as eDP, HDMI.
>>>
>>> The basic "crtc" for rockchip is a "VOP" - Video Output Processor.
>>> the vop devices found on Rockchip rk3288 Soc, rk3288 soc have two s=
imilar
>>> Vop devices. Vop devices support iommu mapping, we use dma-mapping =
API with
>>> ARM_DMA_USE_IOMMU.
>>
>> [...]
>>
>>> Changes in v15:
>>> - remove depends on ARM_DMA_USE_IOMMU & IOMMU_API which cause
>>>   recursive dependency problem
>
> I thought the recommended solution for this was to fix OMAP3 to not
> select  ARM_DMA_USE_IOMMU and OMAP_IOMMU, not to drop the 'depends on=
'
> in drm/rockchip?

Lets fix that up once we get this merged, if I had a tree based on the
iommu I'd have
it -next now.

can I get a pull for that?
Dave.
