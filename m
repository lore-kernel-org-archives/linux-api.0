From: Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 1/5] drm/rockchip: Add basic drm driver
Date: Fri, 19 Sep 2014 20:03:09 -0400
Message-ID: <CAF6AEGsPoj6+PdKCJk5BPPzHS51Tz1FGqS2SjpartaRw7i=Pxg@mail.gmail.com>
References: <1411105668-32722-1-git-send-email-mark.yao@rock-chips.com>
	<1411105668-32722-2-git-send-email-mark.yao@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1411105668-32722-2-git-send-email-mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>, Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, David Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rom Lemarchand <romlem-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, =?UTF-8?Q?St=C3=A9phane_Marchesin?= <marcheu@chromium.>
List-Id: linux-api@vger.kernel.org

On Fri, Sep 19, 2014 at 1:47 AM, Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org> wrote:
> diff --git a/include/uapi/drm/rockchip_drm.h b/include/uapi/drm/rockchip_drm.h
> new file mode 100644
> index 0000000..8f8e60e
> --- /dev/null
> +++ b/include/uapi/drm/rockchip_drm.h
> @@ -0,0 +1,97 @@
> +/*
> + *
> + * Copyright (c) Fuzhou Rockchip Electronics Co.Ltd
> + * Authors:
> + *       Mark Yao <yzq-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
> + *
> + * base on exynos_drm.h
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#ifndef _UAPI_ROCKCHIP_DRM_H
> +#define _UAPI_ROCKCHIP_DRM_H
> +
> +#include <drm/drm.h>
> +
> +/**
> + * User-desired buffer creation information structure.
> + *
> + * @size: user-desired memory allocation size.
> + * @flags: user request for setting memory type or cache attributes.
> + * @handle: returned a handle to created gem object.
> + *     - this handle will be set by gem module of kernel side.
> + */
> +struct drm_rockchip_gem_create {
> +       uint64_t size;
> +       uint32_t flags;
> +       uint32_t handle;
> +};
> +
> +/**
> + * A structure for getting buffer offset.
> + *
> + * @handle: a pointer to gem object created.
> + * @pad: just padding to be 64-bit aligned.
> + * @offset: relatived offset value of the memory region allocated.
> + *     - this value should be set by user.
> + */
> +struct drm_rockchip_gem_map_off {
> +       uint32_t handle;
> +       uint32_t pad;
> +       uint64_t offset;
> +};
> +
> +/**
> + * A structure for mapping buffer.
> + *
> + * @handle: a handle to gem object created.
> + * @pad: just padding to be 64-bit aligned.
> + * @size: memory size to be mapped.
> + * @mapped: having user virtual address mmaped.
> + *      - this variable would be filled by rockchip gem module
> + *      of kernel side with user virtual address which is allocated
> + *      by do_mmap().
> + */
> +struct drm_rockchip_gem_mmap {
> +       uint32_t handle;
> +       uint32_t pad;
> +       uint64_t size;
> +       uint64_t mapped;
> +};

Could we do without the mmap ioctl?  It has been a source of problems
in other drivers, and the ioctl to get mmap offset, plus normal mmap()
on drm device file should be sufficient

BR,
-R


> +/**
> + * A structure to gem information.
> + *
> + * @handle: a handle to gem object created.
> + * @flags: flag value including memory type and cache attribute and
> + *      this value would be set by driver.
> + * @size: size to memory region allocated by gem and this size would
> + *      be set by driver.
> + */
> +struct drm_rockchip_gem_info {
> +       uint32_t handle;
> +       uint32_t flags;
> +       uint64_t size;
> +};
> +
> +#define DRM_ROCKCHIP_GEM_CREATE                0x00
> +#define DRM_ROCKCHIP_GEM_MAP_OFFSET    0x01
> +#define DRM_ROCKCHIP_GEM_MMAP          0x02
> +#define DRM_ROCKCHIP_GEM_GET           0x04
> +
> +#define DRM_IOCTL_ROCKCHIP_GEM_CREATE  DRM_IOWR(DRM_COMMAND_BASE + \
> +               DRM_ROCKCHIP_GEM_CREATE, struct drm_rockchip_gem_create)
> +
> +#define DRM_IOCTL_ROCKCHIP_GEM_MAP_OFFSET      DRM_IOWR(DRM_COMMAND_BASE + \
> +               DRM_ROCKCHIP_GEM_MAP_OFFSET, struct drm_rockchip_gem_map_off)
> +
> +#define DRM_IOCTL_ROCKCHIP_GEM_MMAP    DRM_IOWR(DRM_COMMAND_BASE + \
> +               DRM_ROCKCHIP_GEM_MMAP, struct drm_rockchip_gem_mmap)
> +
> +#define DRM_IOCTL_ROCKCHIP_GEM_GET     DRM_IOWR(DRM_COMMAND_BASE + \
> +               DRM_ROCKCHIP_GEM_GET, struct drm_rockchip_gem_info)
> +#endif /* _UAPI_ROCKCHIP_DRM_H */
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
