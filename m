From: yaozq <yzq@rock-chips.com>
Subject: Re: [PATCH v2 1/5] drm/rockchip: Add basic drm driver
Date: Fri, 19 Sep 2014 10:03:09 +0800
Message-ID: <541B8EDD.4090809@rock-chips.com>
References: <1411032884-9233-1-git-send-email-mark.yao@rock-chips.com> <1411032991-9280-1-git-send-email-mark.yao@rock-chips.com> <20140918145214.GA15734@phenom.ffwll.local> <20140918145354.GB15734@phenom.ffwll.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20140918145354.GB15734@phenom.ffwll.local>
Sender: linux-doc-owner@vger.kernel.org
To: Mark yao <mark.yao@rock-chips.com>, heiko@sntech.de, Boris BREZILLON <boris.brezillon@free-electrons.com>, David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Randy Dunlap <rdunlap@infradead.org>, Grant Likely <grant.likely@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, John Stultz <john.stultz@linaro.org>, Rom Lemarchand <romlem@google.com>, linux-doc@vger.kernel.org, kever.yang@rock-chips.com, dri-devel@lists.freedesktop.org, dianders@chromium.org, xjq@rock-chips.com, zyw@rock-chips.com, cym@rock-chips.com, linux-rockchip@lists.infradead.org, kfx@rock-chips.com, wxt@rock-chips.com, huangtao@rock-chips.com, devicetree@vger.kernel.org, yxj@rock-chips.com
List-Id: linux-api@vger.kernel.org

On 2014=E5=B9=B409=E6=9C=8818=E6=97=A5 22:53, Daniel Vetter wrote:
> On Thu, Sep 18, 2014 at 04:52:14PM +0200, Daniel Vetter wrote:
>> On Thu, Sep 18, 2014 at 05:36:31PM +0800, Mark yao wrote:
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
>>> +static const struct drm_crtc_funcs rockchip_crtc_funcs =3D {
>>> +	.set_config =3D drm_crtc_helper_set_config,
>>> +	.page_flip =3D rockchip_drm_crtc_page_flip,
>>> +	.destroy =3D rockchip_drm_crtc_destroy,
>>> +	.cursor_set =3D vop_crtc_cursor_set,
>>> +	.cursor_move =3D vop_crtc_cursor_move,
>> If you expose your cursor plane as a universal you don't need to imp=
lement
>> these two cursor functions at all. Actually the core never calls the=
m, see
>> drm_mode_cursor_universal. So if you want to expose cursors, please =
use
>> universal cursor plane support (like i915).
>>
>> In general that's how new drivers should expose cursors since withou=
t
>> universal planes support cursors will not be supported with the atom=
ic
>> ioctl. Since your cursor code just calls the relevant plane function=
s that
>> should even simplify your driver ;-)
> Actually you already initialize with cursor universal planes, so all =
this
> code can simply be removed.
> -Daniel
I see, drm_mode_cursor_universal is nice, I would test and use it.
-Mark

