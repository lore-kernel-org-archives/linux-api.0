From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Subject: Re: [PATCH v15 0/3] Add drm driver for Rockchip Socs
Date: Tue, 02 Dec 2014 10:31:14 +0100
Message-ID: <2556534.qktPW9tbxy@diego>
References: <1417511600-7054-1-git-send-email-mark.yao@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1417511600-7054-1-git-send-email-mark.yao@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Yao <mark.yao@rock-chips.com>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>, David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>, Daniel Vetter <daniel@ffwll.ch>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Randy Dunlap <rdunlap@infradead.org>, Grant Likely <grant.likely@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, John Stultz <john.stultz@linaro.org>, Rom Lemarchand <romlem@google.com>, devicetree@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org, linux-rockchip@lists.infradead.org, dianders@chromium.org, marcheu@chromium.org, dbehr@chromium.org, olof@lixom.net, djkurtz@chromium.org, cf@rock-chips.com, xxm@rock-chips.com, huangtao@rock-
List-Id: linux-api@vger.kernel.org

Hi Mark,

Am Dienstag, 2. Dezember 2014, 17:13:20 schrieb Mark Yao:
> This a series of patches is a DRM Driver for Rockchip Socs, add support
> for vop devices. Future patches will add additional encoders/connectors,
> such as eDP, HDMI.
> 
> The basic "crtc" for rockchip is a "VOP" - Video Output Processor.
> the vop devices found on Rockchip rk3288 Soc, rk3288 soc have two similar
> Vop devices. Vop devices support iommu mapping, we use dma-mapping API with
> ARM_DMA_USE_IOMMU.

[...]

> Changes in v15:
> - remove depends on ARM_DMA_USE_IOMMU & IOMMU_API which cause
>   recursive dependency problem
> - fix compile problems when build as a module.

maybe you could also already create a new pull request for this version [like 
the last one based on the iommu branch], so that we save time and Dave can 
pull it in easily for testing if he likes.


Heiko
