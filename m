From: =?UTF-8?Q?St=C3=A9phane_Marchesin?= <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 4/4] drm/tegra: Allow non-authenticated processes to
 create buffer objects
Date: Wed, 11 Jun 2014 09:17:03 -0700
Message-ID: <CADMs+9ZufFewFLEgXqHp=dDbPuHSQY6_4FRroYG+QSnYLhfxTg@mail.gmail.com>
References: <1402398294-10252-1-git-send-email-thierry.reding@gmail.com> <1402398294-10252-4-git-send-email-thierry.reding@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1402398294-10252-4-git-send-email-thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erik Faye-Lund <kusmabite-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 10, 2014 at 4:04 AM, Thierry Reding
<thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Thierry Reding <treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
>
> This matches what other drivers do for equivalent IOCTLs.
>
> Signed-off-by: Thierry Reding <treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>

Reviewed-by: St=C3=A9phane Marchesin <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

> ---
>  drivers/gpu/drm/tegra/drm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.=
c
> index f292c29ef62f..56ef81a6f28f 100644
> --- a/drivers/gpu/drm/tegra/drm.c
> +++ b/drivers/gpu/drm/tegra/drm.c
> @@ -598,7 +598,7 @@ static int tegra_gem_get_flags(struct drm_device =
*drm, void *data,
>
>  static const struct drm_ioctl_desc tegra_drm_ioctls[] =3D {
>  #ifdef CONFIG_DRM_TEGRA_STAGING
> -       DRM_IOCTL_DEF_DRV(TEGRA_GEM_CREATE, tegra_gem_create, DRM_UNL=
OCKED | DRM_AUTH),
> +       DRM_IOCTL_DEF_DRV(TEGRA_GEM_CREATE, tegra_gem_create, DRM_UNL=
OCKED),
>         DRM_IOCTL_DEF_DRV(TEGRA_GEM_MMAP, tegra_gem_mmap, DRM_UNLOCKE=
D),
>         DRM_IOCTL_DEF_DRV(TEGRA_SYNCPT_READ, tegra_syncpt_read, DRM_U=
NLOCKED),
>         DRM_IOCTL_DEF_DRV(TEGRA_SYNCPT_INCR, tegra_syncpt_incr, DRM_U=
NLOCKED),
> --
> 1.9.2
>
