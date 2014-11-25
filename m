From: Dave Airlie <airlied@gmail.com>
Subject: Re: [PATCH v14 0/3] Add drm driver for Rockchip Socs
Date: Wed, 26 Nov 2014 09:12:56 +1000
Message-ID: <CAPM=9tzvvb5U+8KaCO+K6CJi=rwWOkoW+4ZSFW_Oo9gTncvkWA@mail.gmail.com>
References: <1416447994-9921-1-git-send-email-mark.yao@rock-chips.com>
	<23617908.6oA5uRuO3l@diego>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <23617908.6oA5uRuO3l@diego>
Sender: linux-doc-owner@vger.kernel.org
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc: Mark Yao <mark.yao@rock-chips.com>, Boris BREZILLON <boris.brezillon@free-electrons.com>, Rob Clark <robdclark@gmail.com>, Daniel Vetter <daniel@ffwll.ch>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Randy Dunlap <rdunlap@infradead.org>, Grant Likely <grant.likely@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, John Stultz <john.stultz@linaro.org>, Rom Lemarchand <romlem@google.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, dri-devel <dri-devel@lists.freedesktop.org>, linux-api@vger.kernel.org, linux-rockchip@lists.infradead.org, Douglas Anderson <dianders@chromium.org>, =?UTF-8?Q?St=C3=A9phane_Marchesin?= <marcheu@chromium.org>d
List-Id: linux-api@vger.kernel.org

On 26 November 2014 at 02:38, Heiko St=C3=BCbner <heiko@sntech.de> wrot=
e:
> Mark,
>
> Am Donnerstag, 20. November 2014, 09:46:34 schrieb Mark Yao:
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
> it looks like everybody is more or less happy with this version - in =
past
> versions responses voicing concerns where quite swift.
>
> As David requested a pull request the last time, it might be time to =
do so, so
> that we maybe still reach 3.19.
>

I need the iommu changes the drm driver depends on in a stable
maintainer git tree,
I'm not pulling in code I can't build.

I'm happy if the rockchip drm pull stays static and I can pull it in
once the iommu bits
are done.

Dave.
