From: =?UTF-8?Q?St=C3=A9phane_Marchesin?= <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 3/4] drm/tegra: Add SET/GET_FLAGS IOCTLs
Date: Wed, 11 Jun 2014 09:21:21 -0700
Message-ID: <CADMs+9Y+i7H9GGpMKJNs2kkxzyruOjiXEv2O1_SipudPGZW-8g@mail.gmail.com>
References: <1402398294-10252-1-git-send-email-thierry.reding@gmail.com> <1402398294-10252-3-git-send-email-thierry.reding@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1402398294-10252-3-git-send-email-thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erik Faye-Lund <kusmabite-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 10, 2014 at 4:04 AM, Thierry Reding
<thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Thierry Reding <treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
>
> The DRM_TEGRA_GEM_SET_FLAGS IOCTL can be used to set the flags of a
> buffer object after it has been allocated or imported. Flags associated
> with a buffer object can be queried using the DRM_TEGRA_GEM_GET_FLAGS
> IOCTL.
>
> Signed-off-by: Thierry Reding <treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/gpu/drm/tegra/drm.c  | 48 ++++++++++++++++++++++++++++++++++++++++++++
>  include/uapi/drm/tegra_drm.h | 21 +++++++++++++++++++
>  2 files changed, 69 insertions(+)
>
> diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
> index 5dca20982f3b..f292c29ef62f 100644
> --- a/drivers/gpu/drm/tegra/drm.c
> +++ b/drivers/gpu/drm/tegra/drm.c
> @@ -548,6 +548,52 @@ static int tegra_gem_get_tiling(struct drm_device *drm, void *data,
>
>         return err;
>  }
> +
> +static int tegra_gem_set_flags(struct drm_device *drm, void *data,
> +                              struct drm_file *file)
> +{
> +       struct drm_tegra_gem_set_flags *args = data;
> +       struct drm_tegra_bo *bo;
> +       unsigned long flags = 0;
> +
> +       if (args->flags & ~DRM_TEGRA_GEM_FLAGS)
> +               return -EINVAL;
> +
> +       gem = drm_gem_object_lookup(drm, file, args->handle);
> +       if (!gem)
> +               return -EINVAL;

Usually -ENOENT is returned for unknown objects I think?

> +
> +       bo = to_tegra_bo(gem);
> +       bo->flags = 0;
> +
> +       if (args->flags & DRM_TEGRA_GEM_BOTTOM_UP)
> +               bo->flags |= TEGRA_BO_BOTTOM_UP;
> +
> +       drm_gem_object_unreference(gem);
> +
> +       return 0;
> +}
> +
> +static int tegra_gem_get_flags(struct drm_device *drm, void *data,
> +                              struct drm_file *file)
> +{
> +       struct drm_tegra_gem_get_flags *args = data;
> +       struct drm_tegra_bo *bo;
> +
> +       gem = drm_gem_object_lookup(drm, file, args->handle);
> +       if (!gem)
> +               return -EINVAL;
> +
> +       bo = to_tegra_bo(gem);
> +       args->flags = 0;
> +
> +       if (bo->flags & TEGRA_BO_BOTTOM_UP)
> +               args->flags |= DRM_TEGRA_GEM_BOTTOM_UP;
> +
> +       drm_gem_object_unreference(gem);
> +
> +       return 0;
> +}
>  #endif
>
>  static const struct drm_ioctl_desc tegra_drm_ioctls[] = {
> @@ -564,6 +610,8 @@ static const struct drm_ioctl_desc tegra_drm_ioctls[] = {
>         DRM_IOCTL_DEF_DRV(TEGRA_GET_SYNCPT_BASE, tegra_get_syncpt_base, DRM_UNLOCKED),
>         DRM_IOCTL_DEF_DRV(TEGRA_GEM_SET_TILING, tegra_gem_set_tiling, DRM_UNLOCKED),
>         DRM_IOCTL_DEF_DRV(TEGRA_GEM_GET_TILING, tegra_gem_get_tiling, DRM_UNLOCKED),
> +       DRM_IOCTL_DEF_DRV(TEGRA_GEM_SET_FLAGS, tegra_gem_set_flags, DRM_UNLOCKED),
> +       DRM_IOCTL_DEF_DRV(TEGRA_GEM_GET_FLAGS, tegra_gem_get_flags, DRM_UNLOCKED),
>  #endif
>  };
>
> diff --git a/include/uapi/drm/tegra_drm.h b/include/uapi/drm/tegra_drm.h
> index 0829f75eb986..c15d781ecc0f 100644
> --- a/include/uapi/drm/tegra_drm.h
> +++ b/include/uapi/drm/tegra_drm.h
> @@ -150,6 +150,23 @@ struct drm_tegra_gem_get_tiling {
>         __u32 pad;
>  };
>
> +#define DRM_TEGRA_GEM_BOTTOM_UP                (1 << 0)
> +#define DRM_TEGRA_GEM_FLAGS            (DRM_TEGRA_GEM_BOTTOM_UP)
> +
> +struct drm_tegra_gem_set_flags {
> +       /* input */
> +       __u32 handle;
> +       /* output */
> +       __u32 flags;
> +};
> +
> +struct drm_tegra_gem_get_flags {
> +       /* input */
> +       __u32 handle;
> +       /* output */
> +       __u32 flags;
> +};
> +
>  #define DRM_TEGRA_GEM_CREATE           0x00
>  #define DRM_TEGRA_GEM_MMAP             0x01
>  #define DRM_TEGRA_SYNCPT_READ          0x02
> @@ -162,6 +179,8 @@ struct drm_tegra_gem_get_tiling {
>  #define DRM_TEGRA_GET_SYNCPT_BASE      0x09
>  #define DRM_TEGRA_GEM_SET_TILING       0x0a
>  #define DRM_TEGRA_GEM_GET_TILING       0x0b
> +#define DRM_TEGRA_GEM_SET_FLAGS                0x0c
> +#define DRM_TEGRA_GEM_GET_FLAGS                0x0d
>
>  #define DRM_IOCTL_TEGRA_GEM_CREATE DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_GEM_CREATE, struct drm_tegra_gem_create)
>  #define DRM_IOCTL_TEGRA_GEM_MMAP DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_GEM_MMAP, struct drm_tegra_gem_mmap)
> @@ -175,5 +194,7 @@ struct drm_tegra_gem_get_tiling {
>  #define DRM_IOCTL_TEGRA_GET_SYNCPT_BASE DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_GET_SYNCPT_BASE, struct drm_tegra_get_syncpt_base)
>  #define DRM_IOCTL_TEGRA_GEM_SET_TILING DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_GEM_SET_TILING, struct drm_tegra_gem_set_tiling)
>  #define DRM_IOCTL_TEGRA_GEM_GET_TILING DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_GEM_GET_TILING, struct drm_tegra_gem_get_tiling)
> +#define DRM_IOCTL_TEGRA_GEM_SET_FLAGS DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_GEM_SET_FLAGS, struct drm_tegra_gem_set_flags)
> +#define DRM_IOCTL_TEGRA_GEM_GET_FLAGS DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_GEM_GET_FLAGS, struct drm_tegra_gem_get_flags)
>
>  #endif
> --
> 1.9.2
>
