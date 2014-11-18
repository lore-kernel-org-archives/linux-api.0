From: Mark yao <mark.yao@rock-chips.com>
Subject: Re: [PATCH v12 1/3] drm: rockchip: Add basic drm driver
Date: Tue, 18 Nov 2014 17:57:44 +0800
Message-ID: <546B1818.20907@rock-chips.com>
References: <1416297587-18959-1-git-send-email-mark.yao@rock-chips.com> <1416297629-19024-1-git-send-email-mark.yao@rock-chips.com> <20141118083234.GZ25711@phenom.ffwll.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141118083234.GZ25711@phenom.ffwll.local>
Sender: linux-kernel-owner@vger.kernel.org
To: heiko@sntech.de, Boris BREZILLON <boris.brezillon@free-electrons.com>, David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Randy Dunlap <rdunlap@infradead.org>, Grant Likely <grant.likely@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, John Stultz <john.stultz@linaro.org>, Rom Lemarchand <romlem@google.com>, devicetree@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org, linux-rockchip@lists.infradead.org, dianders@chromium.org, marcheu@chromium.org, dbehr@chromium.org, olof@lixom.net, djkurtz@chromium.org, cf@rock-chips.com, xxm@rock-chips.com, huangtao@rock-chips.com, kever
List-Id: linux-api@vger.kernel.org

On 2014=E5=B9=B411=E6=9C=8818=E6=97=A5 16:32, Daniel Vetter wrote:
> On Tue, Nov 18, 2014 at 04:00:29PM +0800, Mark Yao wrote:
>> From: Mark yao <mark.yao@rock-chips.com>
>>
>> This patch adds the basic structure of a DRM Driver for Rockchip Soc=
s.
>>
>> Signed-off-by: Mark Yao <mark.yao@rock-chips.com>
>> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
>> Acked-by: Daniel Vetter <daniel@ffwll.ch>
>> Reviewed-by: Rob Clark <robdclark@gmail.com>
>> ---
>> Changes in v2:
>> - use the component framework to defer main drm driver probe
>>    until all VOP devices have been probed.
>> - use dma-mapping API with ARM_DMA_USE_IOMMU, create dma mapping by
>>    master device and each vop device can shared the drm dma mapping.
>> - use drm_crtc_init_with_planes and drm_universal_plane_init.
>> - remove unnecessary middle layers.
>> - add cursor set, move funcs to rockchip drm crtc.
>> - use vop reset at first init
>> - reference framebuffer when used and unreference when swap out vop
>>
>> Changes in v3:
>> - change "crtc->fb" to "crtc->primary-fb"
>> Adviced by Daniel Vetter
>> - init cursor plane with universal api, remove unnecessary cursor se=
t,move
>>
>> Changes in v4:
>> Adviced by David Herrmann
>> - remove drm_platform_*() usage, use register drm device directly.
> Minor fixup for that part below.
>
> [snip]
>
>> +static int rockchip_drm_bind(struct device *dev)
>> +{
>> +	struct drm_device *drm;
>> +	int ret;
>> +
>> +	drm =3D drm_dev_alloc(&rockchip_drm_driver, dev);
>> +	if (!drm)
>> +		return -ENOMEM;
>> +
>> +	ret =3D drm_dev_set_unique(drm, "%s", dev_name(dev));
>> +	if (ret)
>> +		goto err_free;
> Please call rockchip_drm_load here directly and don't put it as the -=
>load
> function into the driver vtable. The point of the alloc/register spli=
t is
> that the driver can be completely set up _before_ we register anythin=
g.
> But for backwards compat and historical reasons ->load is called some=
where
> in the middle (so that you could access the minor nodes if needed, si=
nce
> some drivers do that).
>
> Cheers, Daniel
OK, got it.
