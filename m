From: =?UTF-8?Q?St=C3=A9phane_Marchesin?= <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 2/4] drm/tegra: Add SET/GET_TILING IOCTLs
Date: Wed, 11 Jun 2014 10:43:30 -0700
Message-ID: <CADMs+9YJgP7GqG0qhaTzd8QtANnTb4yFq2GkAYiS_U+HFw+e0w@mail.gmail.com>
References: <1402398294-10252-1-git-send-email-thierry.reding@gmail.com> <1402398294-10252-2-git-send-email-thierry.reding@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1402398294-10252-2-git-send-email-thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erik Faye-Lund <kusmabite-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 10, 2014 at 4:04 AM, Thierry Reding
<thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Thierry Reding <treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
>
> Currently the tiling parameters of buffer objects can only be set at
> allocation time, and only a single tiled mode is supported. This new
> DRM_TEGRA_GEM_SET_TILING IOCTL allows more modes to be set and also
> allows the tiling mode to be changed after the allocation. This will
> enable the Tegra DRM driver to import buffers from a GPU and directly
> scan them out by configuring the display controller appropriately.

I was wondering why not support the new tiling modes on creation as
well, I guess because you don't have room for height in the creation
ioctl?

>
> To complement this, the DRM_TEGRA_GEM_GET_TILING IOCTL can query the
> current tiling mode of a buffer object. This is necessary when import=
ing
> buffers via handle (as is done in Mesa for example) so that userspace
> can determine the proper parameters for the 2D or 3D engines.
>
> Signed-off-by: Thierry Reding <treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/gpu/drm/tegra/drm.c  | 95 ++++++++++++++++++++++++++++++++++=
++++++++++
>  include/uapi/drm/tegra_drm.h | 25 ++++++++++++
>  2 files changed, 120 insertions(+)
>
> diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.=
c
> index fd736efd14bd..5dca20982f3b 100644
> --- a/drivers/gpu/drm/tegra/drm.c
> +++ b/drivers/gpu/drm/tegra/drm.c
> @@ -455,6 +455,99 @@ static int tegra_get_syncpt_base(struct drm_devi=
ce *drm, void *data,
>
>         return 0;
>  }
> +
> +static int tegra_gem_set_tiling(struct drm_device *drm, void *data,
> +                               struct drm_file *file)
> +{
> +       struct drm_tegra_gem_set_tiling *args =3D data;
> +       enum tegra_bo_tiling_mode mode;
> +       struct drm_gem_object *gem;
> +       unsigned long value =3D 0;
> +       struct tegra_bo *bo;
> +
> +       switch (args->mode) {
> +       case DRM_TEGRA_GEM_TILING_MODE_PITCH:
> +               mode =3D TEGRA_BO_TILING_MODE_PITCH;
> +
> +               if (args->value !=3D 0)
> +                       return -EINVAL;
> +
> +               break;
> +
> +       case DRM_TEGRA_GEM_TILING_MODE_TILED:
> +               mode =3D TEGRA_BO_TILING_MODE_TILED;
> +
> +               if (args->value !=3D 0)
> +                       return -EINVAL;
> +
> +               break;
> +
> +       case DRM_TEGRA_GEM_TILING_MODE_BLOCK:
> +               mode =3D TEGRA_BO_TILING_MODE_BLOCK;
> +
> +               if (args->value > 5)
> +                       return -EINVAL;
> +
> +               value =3D args->value;
> +               break;
> +
> +       default:
> +               return -EINVAL;
> +       }
> +
> +       gem =3D drm_gem_object_lookup(drm, file, args->handle);
> +       if (!gem)
> +               return -EINVAL;
> +
> +       bo =3D to_tegra_bo(gem);
> +
> +       bo->tiling.mode =3D mode;
> +       bo->tiling.value =3D value;
> +
> +       drm_gem_object_unreference(gem);
> +
> +       return 0;
> +}
> +
> +static int tegra_gem_get_tiling(struct drm_device *drm, void *data,
> +                               struct drm_file *file)
> +{
> +       struct drm_tegra_gem_get_tiling *args =3D data;
> +       struct drm_gem_object *gem;
> +       struct tegra_bo *bo;
> +       int err =3D 0;
> +
> +       gem =3D drm_gem_object_lookup(drm, file, args->handle);
> +       if (!gem)
> +               return -EINVAL;
> +
> +       bo =3D to_tegra_bo(gem);
> +
> +       switch (bo->tiling.mode) {
> +       case TEGRA_BO_TILING_MODE_PITCH:
> +               args->mode =3D DRM_TEGRA_GEM_TILING_MODE_PITCH;
> +               args->value =3D 0;
> +               break;
> +
> +       case TEGRA_BO_TILING_MODE_TILED:
> +               args->mode =3D DRM_TEGRA_GEM_TILING_MODE_TILED;
> +               args->value =3D 0;
> +               break;
> +
> +       case TEGRA_BO_TILING_MODE_BLOCK:
> +               args->mode =3D DRM_TEGRA_GEM_TILING_MODE_BLOCK;
> +               args->value =3D bo->tiling.value;
> +               break;
> +
> +       default:
> +               err =3D -EINVAL;
> +               break;
> +       }
> +
> +       drm_gem_object_unreference(gem);
> +
> +       return err;
> +}
>  #endif
>
>  static const struct drm_ioctl_desc tegra_drm_ioctls[] =3D {
> @@ -469,6 +562,8 @@ static const struct drm_ioctl_desc tegra_drm_ioct=
ls[] =3D {
>         DRM_IOCTL_DEF_DRV(TEGRA_GET_SYNCPT, tegra_get_syncpt, DRM_UNL=
OCKED),
>         DRM_IOCTL_DEF_DRV(TEGRA_SUBMIT, tegra_submit, DRM_UNLOCKED),
>         DRM_IOCTL_DEF_DRV(TEGRA_GET_SYNCPT_BASE, tegra_get_syncpt_bas=
e, DRM_UNLOCKED),
> +       DRM_IOCTL_DEF_DRV(TEGRA_GEM_SET_TILING, tegra_gem_set_tiling,=
 DRM_UNLOCKED),
> +       DRM_IOCTL_DEF_DRV(TEGRA_GEM_GET_TILING, tegra_gem_get_tiling,=
 DRM_UNLOCKED),
>  #endif
>  };
>
> diff --git a/include/uapi/drm/tegra_drm.h b/include/uapi/drm/tegra_dr=
m.h
> index b75482112428..0829f75eb986 100644
> --- a/include/uapi/drm/tegra_drm.h
> +++ b/include/uapi/drm/tegra_drm.h
> @@ -129,6 +129,27 @@ struct drm_tegra_submit {
>         __u32 reserved[5];      /* future expansion */
>  };
>
> +#define DRM_TEGRA_GEM_TILING_MODE_PITCH 0
> +#define DRM_TEGRA_GEM_TILING_MODE_TILED 1
> +#define DRM_TEGRA_GEM_TILING_MODE_BLOCK 2
> +
> +struct drm_tegra_gem_set_tiling {
> +       /* input */
> +       __u32 handle;
> +       __u32 mode;
> +       __u32 value;

This seems to only be used for height, if so should it be called height=
?

St=C3=A9phane


> +       __u32 pad;
> +};
> +
> +struct drm_tegra_gem_get_tiling {
> +       /* input */
> +       __u32 handle;
> +       /* output */
> +       __u32 mode;
> +       __u32 value;
> +       __u32 pad;
> +};
> +
>  #define DRM_TEGRA_GEM_CREATE           0x00
>  #define DRM_TEGRA_GEM_MMAP             0x01
>  #define DRM_TEGRA_SYNCPT_READ          0x02
> @@ -139,6 +160,8 @@ struct drm_tegra_submit {
>  #define DRM_TEGRA_GET_SYNCPT           0x07
>  #define DRM_TEGRA_SUBMIT               0x08
>  #define DRM_TEGRA_GET_SYNCPT_BASE      0x09
> +#define DRM_TEGRA_GEM_SET_TILING       0x0a
> +#define DRM_TEGRA_GEM_GET_TILING       0x0b
>
>  #define DRM_IOCTL_TEGRA_GEM_CREATE DRM_IOWR(DRM_COMMAND_BASE + DRM_T=
EGRA_GEM_CREATE, struct drm_tegra_gem_create)
>  #define DRM_IOCTL_TEGRA_GEM_MMAP DRM_IOWR(DRM_COMMAND_BASE + DRM_TEG=
RA_GEM_MMAP, struct drm_tegra_gem_mmap)
> @@ -150,5 +173,7 @@ struct drm_tegra_submit {
>  #define DRM_IOCTL_TEGRA_GET_SYNCPT DRM_IOWR(DRM_COMMAND_BASE + DRM_T=
EGRA_GET_SYNCPT, struct drm_tegra_get_syncpt)
>  #define DRM_IOCTL_TEGRA_SUBMIT DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA=
_SUBMIT, struct drm_tegra_submit)
>  #define DRM_IOCTL_TEGRA_GET_SYNCPT_BASE DRM_IOWR(DRM_COMMAND_BASE + =
DRM_TEGRA_GET_SYNCPT_BASE, struct drm_tegra_get_syncpt_base)
> +#define DRM_IOCTL_TEGRA_GEM_SET_TILING DRM_IOWR(DRM_COMMAND_BASE + D=
RM_TEGRA_GEM_SET_TILING, struct drm_tegra_gem_set_tiling)
> +#define DRM_IOCTL_TEGRA_GEM_GET_TILING DRM_IOWR(DRM_COMMAND_BASE + D=
RM_TEGRA_GEM_GET_TILING, struct drm_tegra_gem_get_tiling)
>
>  #endif
> --
> 1.9.2
>
