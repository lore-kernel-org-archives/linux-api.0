From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v2 07/22] media: v4l-core add enable/disable source
 common interfaces
Date: Thu, 4 Feb 2016 07:25:13 -0200
Message-ID: <20160204072513.02619079@recife.lan>
References: <cover.1454557589.git.shuahkh@osg.samsung.com>
	<7df34ecdf35d473535abefa6643b2db24457b8e6.1454557589.git.shuahkh@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7df34ecdf35d473535abefa6643b2db24457b8e6.1454557589.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: tiwai-IBi9RG/b67k@public.gmane.org, clemens-P6GI/4k7KOmELgA04lAiVw@public.gmane.org, hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, javier-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org, m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, perex-/Fr2/VpizcU@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, tvboxspy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, crope-X3B1VOXEql0@public.gmane.org, ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, chehabrafael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org, inki.dae-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, jh1009.sung-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sw0312.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, labbott-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org, pierre-louis.bossart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, ricard.wanderlof-VrBV9hrLPhE@public.gmane.org, julian-SZMMDGyaqes@public.gmane.org, takamichiho-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dominic.sacre-Mmb7MZpHnFY@public.gmane.org, misterpib-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, gtmkramer-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, joe-amhYAVlgbXj10XsdtD+oqA@public.gmane.org, linuxbugs@vittga
List-Id: linux-api@vger.kernel.org

Em Wed, 03 Feb 2016 21:03:39 -0700
Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> escreveu:

> Add a new interfaces to be used by v4l-core to invoke enable
> source and disable_source handlers in the media_device. The
> enable_source helper function invokes the enable_source handler
> to find media source entity connected to the entity and check
> is it is available or busy. If source is available, link is
> activated and pipeline is started. The disable_source helper
> function invokes the disable_source handler to deactivate and
> stop the pipeline.
> 
> Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> ---
>  drivers/media/v4l2-core/Makefile  |  2 +-
>  drivers/media/v4l2-core/v4l2-mc.c | 60 +++++++++++++++++++++++++++++++++++++++
>  include/media/v4l2-dev.h          |  1 +
>  include/media/v4l2-mc.h           | 52 +++++++++++++++++++++++++++++++++
>  4 files changed, 114 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/media/v4l2-core/v4l2-mc.c
> 
> diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
> index 1dc8bba..c6acc01 100644
> --- a/drivers/media/v4l2-core/Makefile
> +++ b/drivers/media/v4l2-core/Makefile
> @@ -6,7 +6,7 @@ tuner-objs	:=	tuner-core.o
>  
>  videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
>  			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o v4l2-clk.o \
> -			v4l2-async.o
> +			v4l2-async.o v4l2-mc.o
>  ifeq ($(CONFIG_COMPAT),y)
>    videodev-objs += v4l2-compat-ioctl32.o
>  endif
> diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
> new file mode 100644
> index 0000000..87416df
> --- /dev/null
> +++ b/drivers/media/v4l2-core/v4l2-mc.c
> @@ -0,0 +1,60 @@
> +/*
> + * v4l2-mc.c - Media Controller V4L2 Common Interfaces
> + *
> + * Copyright (C) 2016 Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <media/v4l2-mc.h>
> +#include <media/media-device.h>
> +#include <media/videobuf2-core.h>
> +#include <media/v4l2-fh.h>
> +
> +int v4l_enable_media_source(struct video_device *vdev)
> +{
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +	struct media_device *mdev = vdev->entity.graph_obj.mdev;
> +	int ret;
> +
> +	if (!mdev || !mdev->enable_source)
> +		return 0;
> +	ret = mdev->enable_source(&vdev->entity, &vdev->pipe);
> +	if (ret)
> +		return -EBUSY;
> +	return 0;
> +#endif /* CONFIG_MEDIA_CONTROLLER */
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(v4l_enable_media_source);
> +
> +void v4l_disable_media_source(struct video_device *vdev)
> +{
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +	struct media_device *mdev = vdev->entity.graph_obj.mdev;
> +
> +	if (mdev && mdev->disable_source)
> +		mdev->disable_source(&vdev->entity);
> +#endif /* CONFIG_MEDIA_CONTROLLER */
> +}
> +EXPORT_SYMBOL_GPL(v4l_disable_media_source);
> +
> +int v4l_vb2q_enable_media_source(struct vb2_queue *q)
> +{
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +	struct v4l2_fh *fh = q->owner;
> +
> +	return v4l_enable_media_source(fh->vdev);
> +#endif /* CONFIG_MEDIA_CONTROLLER */
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(v4l_vb2q_enable_media_source);
> +

The code itself is ok. However, the above code would work better if you
declare them as static inline at the header file (v4l2-mc.h). That would
allow the compiler to optimize them with the caller codr (where the
declared structs like mdev, fh are likely already stored on some registers), 
and even removing the function completely if compiled without the media
controller.

> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> index eeabf20..76056ab 100644
> --- a/include/media/v4l2-dev.h
> +++ b/include/media/v4l2-dev.h
> @@ -87,6 +87,7 @@ struct video_device
>  #if defined(CONFIG_MEDIA_CONTROLLER)
>  	struct media_entity entity;
>  	struct media_intf_devnode *intf_devnode;
> +	struct media_pipeline pipe;
>  #endif
>  	/* device ops */
>  	const struct v4l2_file_operations *fops;
> diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
> index df11519..df1a98f 100644
> --- a/include/media/v4l2-mc.h
> +++ b/include/media/v4l2-mc.h
> @@ -14,6 +14,11 @@
>   * GNU General Public License for more details.
>   */
>  
> +#ifndef _V4L2_MC_H
> +#define _V4L2_MC_H
> +
> +#include <media/v4l2-dev.h>
> +
>  /**
>   * enum tuner_pad_index - tuner pad index for MEDIA_ENT_F_TUNER
>   *
> @@ -89,3 +94,50 @@ enum demod_pad_index {
>  	DEMOD_PAD_VBI_OUT,
>  	DEMOD_NUM_PADS
>  };
> +
> +/**
> + * v4l_enable_media_source() -	Hold media source for exclusive use
> + *				if free
> + *
> + * @vdev - poniter to struct video_device
> + *
> + * This interface calls enable_source handler to determine if
> + * media source is free for use. The enable_source handler is
> + * responsible for checking is the media source is free and
> + * start a pipeline between the media source and the media
> + * entity associated with the video device. This interface
> + * should be called from v4l2-core and dvb-core interfaces
> + * that change the source configuration.
> + *
> + * Return: returns zero on success or a negative error code.
> + */
> +int v4l_enable_media_source(struct video_device *vdev);
> +
> +/**
> + * v4l_disable_media_source() -	Release media source
> + *
> + * @vdev - poniter to struct video_device
> + *
> + * This interface calls disable_source handler to release
> + * the media source. The disable_source handler stops the
> + * active media pipeline between the media source and the
> + * media entity associated with the video device.
> + *
> + * Return: returns zero on success or a negative error code.
> + */
> +void v4l_disable_media_source(struct video_device *vdev);
> +/*
> + * v4l_vb2q_enable_media_tuner -  Hold media source for exclusive use
> + *				  if free.
> + * @q - pointer to struct vb2_queue
> + *
> + * Wrapper for v4l_enable_media_source(). This function should
> + * be called from v4l2-core to enable the media source with
> + * pointer to struct vb2_queue as the input argument. Some
> + * v4l2-core interfaces don't have access to video device and
> + * this interface finds the struct video_device for the q and
> + * calls v4l_enable_media_source().
> + */
> +int v4l_vb2q_enable_media_source(struct vb2_queue *q);
> +
> +#endif /* _V4L2_MC_H */
