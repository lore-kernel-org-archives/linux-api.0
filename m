From: Tomeu Vizoso <tomeu-XCtybt49RKsYaV1qd6yewg@public.gmane.org>
Subject: Re: [PATCH v15 1/3] drm: rockchip: Add basic drm driver
Date: Mon, 14 Mar 2016 14:35:22 +0100
Message-ID: <CAAObsKANPWAHdoFG3SHK_RAwzZ6d=TVKGZP8ukk3a6CxewOajw@mail.gmail.com>
References: <1417511600-7054-1-git-send-email-mark.yao@rock-chips.com>
 <1417511739-7141-1-git-send-email-mark.yao@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rockchip-bounces+glpar-linux-rockchip=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1417511739-7141-1-git-send-email-mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-rockchip>,
 <mailto:linux-rockchip-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-rockchip/>
List-Post: <mailto:linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-rockchip-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-rockchip>,
 <mailto:linux-rockchip-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-rockchip" <linux-rockchip-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-rockchip-bounces+glpar-linux-rockchip=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kever Yang <kever.yang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, xxm-TNX95d0MmH7DzftRWevZcw@public.gmane.org, "open list:ARM/Rockchip SoC..." <linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tao Huang <huangtao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, dbehr-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, yxj-TNX95d0MmH7DzftRWevZcw@public.gmane.org, Eddie Cai <cf-TNX95d0MmH7DzftRWevZcw@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John
List-Id: linux-api@vger.kernel.org

On 2 December 2014 at 10:15, Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org> wrote:
> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
> new file mode 100644
> index 0000000..e7ca25b
> --- /dev/null
> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
> @@ -0,0 +1,1455 @@
...
> +static bool vop_crtc_mode_fixup(struct drm_crtc *crtc,
> +                               const struct drm_display_mode *mode,
> +                               struct drm_display_mode *adjusted_mode)
> +{
> +       if (adjusted_mode->htotal == 0 || adjusted_mode->vtotal == 0)
> +               return false;

Hi Mark,

what's the rationale for this?

Disabling a CRTC as in [0] will cause mode_fixup() to be called with
an empty mode, failing that test.

Removing the check seems to get things working fine for a short while,
but a later modeset invariably gets the VOP to hang (as reported by
[1]).

Do you know why that check was put in place and what exactly could be
causing the hw to hang?

[0] https://cgit.freedesktop.org/xorg/app/intel-gpu-tools/tree/lib/igt_kms.c#n1616
[1] https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/drivers/gpu/drm/rockchip/rockchip_drm_vop.c#n873

Thanks,

Tomeu

> +
> +       return true;
> +}
