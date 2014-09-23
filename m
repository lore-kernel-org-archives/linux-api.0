From: Mark yao <mark.yao@rock-chips.com>
Subject: Re: [PATCH v4 1/5] drm/rockchip: Add basic drm driver
Date: Tue, 23 Sep 2014 15:05:41 +0800
Message-ID: <54211BC5.8050700@rock-chips.com>
References: <1411382820-1615-1-git-send-email-mark.yao@rock-chips.com> <1411382934-1763-1-git-send-email-mark.yao@rock-chips.com> <3036415.u40f3Xnhod@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <3036415.u40f3Xnhod@wuerfel>
Sender: linux-doc-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: heiko@sntech.de, Boris BREZILLON <boris.brezillon@free-electrons.com>, David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Randy Dunlap <rdunlap@infradead.org>, Grant Likely <grant.likely@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, John Stultz <john.stultz@linaro.org>, Rom Lemarchand <romlem@google.com>, devicetree@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org, linux-rockchip@lists.infradead.org, dianders@chromium.org, marcheu@chromium.org, dbehr@chromium.org, olof@lixom.net, djkurtz@chromium.org, xjq@rock-chips.com, kfx@rock-chips.com, cym@rock-chips.com, cf@rock-c
List-Id: linux-api@vger.kernel.org

On 2014=E5=B9=B409=E6=9C=8822=E6=97=A5 22:43, Arnd Bergmann wrote:
> On Monday 22 September 2014 18:48:54 Mark yao wrote:
>> diff --git a/drivers/gpu/drm/rockchip/Kconfig b/drivers/gpu/drm/rock=
chip/Kconfig
>> new file mode 100644
>> index 0000000..7146c80
>> --- /dev/null
>> +++ b/drivers/gpu/drm/rockchip/Kconfig
>> @@ -0,0 +1,19 @@
>> +config DRM_ROCKCHIP
>> +	tristate "DRM Support for Rockchip"
>> +	depends on DRM && ROCKCHIP_IOMMU
>> +	select ARM_DMA_USE_IOMMU
>> +	select IOMMU_API
>> +	select DRM_KMS_HELPER
>> +	select DRM_KMS_FB_HELPER
>> +	select DRM_PANEL
>> +	select FB_CFB_FILLRECT
>> +	select FB_CFB_COPYAREA
>> +	select FB_CFB_IMAGEBLIT
>> +	select VT_HW_CONSOLE_BINDING if FRAMEBUFFER_CONSOLE
>> +	select VIDEOMODE_HELPERS
> Be careful with 'select', at least some of these should be 'depends o=
n'.
> In particular IOMMU_API and ARM_DMA_USE_IOMMU, but possibly others
> as well. Just check how the symbols are used normally, if you get thi=
s
> wrong, we can end up with incorrect dependencies or loops.
>
I see, I will change it.
>> diff --git a/drivers/gpu/drm/rockchip/Makefile b/drivers/gpu/drm/roc=
kchip/Makefile
>> new file mode 100644
>> index 0000000..6e6d468
>> --- /dev/null
>> +++ b/drivers/gpu/drm/rockchip/Makefile
>> @@ -0,0 +1,10 @@
>> +#
>> +# Makefile for the drm device driver.  This driver provides support=
 for the
>> +# Direct Rendering Infrastructure (DRI) in XFree86 4.1.0 and higher=
=2E
>> +
>> +ccflags-y :=3D -Iinclude/drm -Idrivers/gpu/drm/rockchip
> The second one should not be required.
Sure, I will change it.
>> +static int rockchip_drm_load(struct drm_device *drm_dev, unsigned l=
ong flags)
>> +{
>> +	struct rockchip_drm_private *private;
>> +	struct dma_iommu_mapping *mapping;
>> +	struct device *dev =3D drm_dev->dev;
>> +	int ret;
>> +
>> +	private =3D devm_kzalloc(drm_dev->dev, sizeof(*private), GFP_KERNE=
L);
>> +	if (!private)
>> +		return -ENOMEM;
>> +
>> +	dev_set_drvdata(drm_dev->dev, dev);
>> +	drm_dev->dev_private =3D private;
>> +
>> +	drm_mode_config_init(drm_dev);
>> +
>> +	rockchip_drm_mode_config_init(drm_dev);
>> +
>> +	dev->dma_parms =3D devm_kzalloc(dev, sizeof(*dev->dma_parms),
>> +				      GFP_KERNEL);
>> +	if (!dev->dma_parms) {
>> +		ret =3D -ENOMEM;
>> +		goto err_config_cleanup;
>> +	}
>> +
>> +	/* TODO(djkurtz): fetch the mapping start/size from somewhere */
>> +	mapping =3D arm_iommu_create_mapping(&platform_bus_type, 0x1000000=
0,
>> +					   SZ_1G);
>> +	if (IS_ERR(mapping)) {
>> +		ret =3D PTR_ERR(mapping);
>> +		goto err_config_cleanup;
>> +	}
>> +
>> +	dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
> This is the default coherent mask. If you call this function, you
> should normally check the return value, or call dma_set_mask first,
> which you apparently don't do here, and in another place in this
> patch.
>
> 	Arnd
>
>
>


