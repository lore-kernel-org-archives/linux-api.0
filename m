From: Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH v4 1/5] drm/rockchip: Add basic drm driver
Date: Wed, 24 Sep 2014 13:20:47 +0200
Message-ID: <CAKMK7uHiQFDH-qyPBsyVa953F5SY2UgSv7Nbsu73AKvjqUm1jw@mail.gmail.com>
References: <1411382820-1615-1-git-send-email-mark.yao@rock-chips.com>
	<1411382934-1763-1-git-send-email-mark.yao@rock-chips.com>
	<20140924082037.GJ15734@phenom.ffwll.local>
	<54228F7B.2050608@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <54228F7B.2050608@rock-chips.com>
Sender: linux-doc-owner@vger.kernel.org
To: Mark yao <mark.yao@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>, Boris BREZILLON <boris.brezillon@free-electrons.com>, David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Randy Dunlap <rdunlap@infradead.org>, Grant Likely <grant.likely@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, John Stultz <john.stultz@linaro.org>, Rom Lemarchand <romlem@google.com>, linux-doc@vger.kernel.org, Kever Yang <kever.yang@rock-chips.com>, dri-devel <dri-devel@lists.freedesktop.org>, Douglas Anderson <dianders@chromium.org>, Jianqun Xu <xjq@rock-chips.com>, Chris Zhong <zyw@rock-chips.com>, jeff chen <cym@rock-chips.com>, linux-rockchip@lists.infradead.org, kfx@rock-chips.com, =?UTF-8?B
List-Id: linux-api@vger.kernel.org

On Wed, Sep 24, 2014 at 11:31 AM, Mark yao <mark.yao@rock-chips.com> wr=
ote:
> On 2014=E5=B9=B409=E6=9C=8824=E6=97=A5 16:20, Daniel Vetter wrote:
>>
>> On Mon, Sep 22, 2014 at 06:48:54PM +0800, Mark yao wrote:
>>>
>>> This patch adds the basic structure of a DRM Driver for Rockchip So=
cs.
>>>
>>> Signed-off-by: Mark yao <mark.yao@rock-chips.com>
>>> ---
>>> Changes in v2:
>>> - use the component framework to defer main drm driver probe
>>>    until all VOP devices have been probed.
>>> - use dma-mapping API with ARM_DMA_USE_IOMMU, create dma mapping by
>>>    master device and each vop device can shared the drm dma mapping=
=2E
>>> - use drm_crtc_init_with_planes and drm_universal_plane_init.
>>> - remove unnecessary middle layers.
>>> - add cursor set, move funcs to rockchip drm crtc.
>>> - use vop reset at first init
>>> - reference framebuffer when used and unreference when swap out vop
>>>
>>> Changes in v3:
>>> - change "crtc->fb" to "crtc->primary-fb"
>>> Adviced by Daniel Vetter
>>> - init cursor plane with universal api, remove unnecessary cursor
>>> set,move
>>>
>>> Changes in v4:
>>> Adviced by David Herrmann
>>> - remove drm_platform_*() usage, use register drm device directly.
>>> Adviced by Rob Clark
>>> - remove special mmap ioctl, do userspace mmap with normal mmap() o=
r mmap
>>> offset
>>>
>>>   drivers/gpu/drm/Kconfig                       |    2 +
>>>   drivers/gpu/drm/Makefile                      |    1 +
>>>   drivers/gpu/drm/rockchip/Kconfig              |   19 +
>>>   drivers/gpu/drm/rockchip/Makefile             |   10 +
>>>   drivers/gpu/drm/rockchip/rockchip_drm_drv.c   |  524 ++++++++++
>>>   drivers/gpu/drm/rockchip/rockchip_drm_drv.h   |  120 +++
>>>   drivers/gpu/drm/rockchip/rockchip_drm_fb.c    |  201 ++++
>>>   drivers/gpu/drm/rockchip/rockchip_drm_fb.h    |   28 +
>>>   drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c |  231 +++++
>>>   drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h |   20 +
>>>   drivers/gpu/drm/rockchip/rockchip_drm_gem.c   |  404 ++++++++
>>>   drivers/gpu/drm/rockchip/rockchip_drm_gem.h   |   72 ++
>>>   drivers/gpu/drm/rockchip/rockchip_drm_vop.c   | 1372
>>> +++++++++++++++++++++++++
>>>   drivers/gpu/drm/rockchip/rockchip_drm_vop.h   |  187 ++++
>>>   include/uapi/drm/rockchip_drm.h               |   75 ++
>>
>> uapi is still here ... Was this an oversight?
>> -Daniel
>>
> Hi, Daniel
> this version is old, newest is v5. and I remove uapi at v5.
> you can see v5 patch at:
> https://lkml.org/lkml/2014/9/23/1061
> thanks

This version doesn't seem to be cc'ed to dri-devel, at least it didn't
yet show up. Can you please double-check?

Thanks, Daniel
