From: Daniel Stone <daniel-rLtY4a/8tF1rovVCs/uTlw@public.gmane.org>
Subject: Re: [RFC][PATCH 2/2] drm/mediatek: Add DRM Driver for Mediatek SoC MT8173.
Date: Wed, 13 May 2015 17:01:50 +0100
Message-ID: <CAPj87rMCHK7FFgeHVwFNTwx7s6WHKx9-s70MbDsuc6WfwxVoSw@mail.gmail.com>
References: <1431530626-31493-1-git-send-email-ck.hu@mediatek.com>
	<1431530626-31493-3-git-send-email-ck.hu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431530626-31493-3-git-send-email-ck.hu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: CK Hu <ck.hu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Cc: Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Matthias Brugger <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jitao Shi <jitao.shi-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, srv_heupstream-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, Graeme Gregory <graeme.gregory-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Cawa Cheng <cawa.cheng-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, YT Shen <yt.shen-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, Ashwin Chaugule <ashwin.chaugule-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Sascha Hauer <kernel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TaqPxH82wqD4g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,

On 13 May 2015 at 16:23, CK Hu <ck.hu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org> wrote:
> +       /*
> +        * copy the mode data adjusted by mode_fixup() into crtc->mode
> +        * so that hardware can be seet to proper mode.
> +        */
> +       memcpy(&crtc->mode, adjusted_mode, sizeof(*adjusted_mode));

Please do not do this. adjusted_mode is already available in crtc->hwmode.

Please also restructure this driver to use the atomic infrastructure.
A good example of how to do this can be found in the Rockchip RK3288
driver which was submitted a while ago: it started off as a legacy
driver like this, but was converted during the submission phase.

I'm sure there are many more comments to come, but certainly
converting to be an atomic driver is the very first step.

Cheers,
Daniel
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
