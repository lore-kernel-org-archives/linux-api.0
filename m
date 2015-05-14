From: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Subject: Re: [RFC][PATCH 2/2] drm/mediatek: Add DRM Driver for Mediatek SoC
 MT8173.
Date: Thu, 14 May 2015 11:16:54 +0200
Message-ID: <1431595014.2650.50.camel@x220>
References: <1431530626-31493-1-git-send-email-ck.hu@mediatek.com>
	 <1431530626-31493-3-git-send-email-ck.hu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431530626-31493-3-git-send-email-ck.hu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: CK Hu <ck.hu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Cc: Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Matthias Brugger <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ashwin Chaugule <ashwin.chaugule-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Graeme Gregory <graeme.gregory-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, srv_heupstream-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, Sascha Hauer <kernel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Cawa Cheng <cawa.cheng-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, YT Shen <yt.shen-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, Jitao Shi <jitao.shi-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

A naive question and a nit follow. That's probably not what you'd like
to see for an RFC, but the patch got tangled up in my mail filter
anyhow.

On Wed, 2015-05-13 at 23:23 +0800, CK Hu wrote:
> --- /dev/null
> +++ b/drivers/gpu/drm/mediatek/Kconfig

> +config DRM_MEDIATEK_FBDEV
> +	bool "Enable legacy fbdev support for Mediatek DRM"
> +	depends on DRM_MEDIATEK
> +	select FB_SYS_FILLRECT
> +	select FB_SYS_COPYAREA
> +	select FB_SYS_IMAGEBLIT
> +	select DRM_KMS_FB_HELPER
> +	help
> +	  Choose this option if you have a need for the legacy
> +	  fbdev support.  Note that this support also provides
> +	  the Linux console on top of the Mediatek DRM mode
> +	  setting driver.

Naive question, as I know next to nothing about drivers/gpu/drm.
DRM_MEDIATEK_FBDEV isn't used anywhere, as far as I can see. So all that
setting this Kconfig symbol does is selecting four other Kconfig
symbols. Is selecting those four symbols enough to get fbdev support?
Taking the Cargo Cult approach of looking at similar symbols
(DRM_I915_FBDEV, DRM_MSM_FBDEV, DRM_STI_FBDEV, and DRM_TEGRA_FBDEV) I
noticed that they all do a bit more than just selecting other symbols.

> --- /dev/null
> +++ b/drivers/gpu/drm/mediatek/mediatek_drm_drv.c

> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.

This states the license of this driver is GPL v2. (Identical comments
seem to be part of all files added in this patch.)

> +MODULE_LICENSE("GPL");

And, according to include/linux/module.h, this states the license is GPL
v2 or later. So I think that either the comment at the top of these
files or the ident used in the MODULE_LICENSE() macro needs to be
changed.

Thanks,


Paul Bolle
