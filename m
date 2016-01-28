From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH 09/31] media: v4l2-core add
 v4l_vb2q_enable_media_tuner() helper
Date: Thu, 28 Jan 2016 13:29:37 -0200
Message-ID: <20160128132937.3305eff3@recife.lan>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
	<ac1ad6fc9832cb922ac02eba1f916a6fb4ef97a8.1452105878.git.shuahkh@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ac1ad6fc9832cb922ac02eba1f916a6fb4ef97a8.1452105878.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: tiwai-IBi9RG/b67k@public.gmane.org, clemens-P6GI/4k7KOmELgA04lAiVw@public.gmane.org, hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, javier-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org, m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, perex-/Fr2/VpizcU@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, tvboxspy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, crope-X3B1VOXEql0@public.gmane.org, ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, chehabrafael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org, inki.dae-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, jh1009.sung-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sw0312.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, labbott-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org, pierre-louis.bossart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, ricard.wanderlof-VrBV9hrLPhE@public.gmane.org, julian-SZMMDGyaqes@public.gmane.org, takamichiho-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dominic.sacre-Mmb7MZpHnFY@public.gmane.org, misterpib-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, gtmkramer-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, joe-amhYAVlgbXj10XsdtD+oqA@public.gmane.org, linuxbugs@vittga
List-Id: linux-api@vger.kernel.org

Em Wed,  6 Jan 2016 13:26:58 -0700
Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> escreveu:

> Add a new v4l_vb2q_enable_media_tuner() wrapper function
> to be called from v4l2-core to enable the media tuner with
> videobuf2 queue, when the calling frunction has the videobuf2
> queue and doesn't have the struct video_device associated with
> the queue handy as in the case of vb2_core_streamon(). This
> function simply calls v4l_enable_media_tuner() passing in the
> pointer to struct video_device.
> 
> Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> ---
>  drivers/media/v4l2-core/v4l2-dev.c | 21 +++++++++++++++++++++
>  include/media/v4l2-dev.h           |  1 +
>  2 files changed, 22 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> index f06da6e..9ef675a 100644
> --- a/drivers/media/v4l2-core/v4l2-dev.c
> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> @@ -30,6 +30,7 @@
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ioctl.h>
> +#include <media/videobuf2-core.h>
>  
>  #define VIDEO_NUM_DEVICES	256
>  #define VIDEO_NAME              "video4linux"
> @@ -261,6 +262,26 @@ void v4l_disable_media_tuner(struct video_device *vdev)
>  }
>  EXPORT_SYMBOL_GPL(v4l_disable_media_tuner);
>  
> +/**
> + * v4l_vb2q_enable_media_tuner - Wrapper for v4l_enable_media_tuner()
> + * @q:         videobuf2 queue
> + *
> + * This function is intended to be called from v4l2-core
> + * to enable the media tuner with videobuf2 queue, when
> + * the calling frunction has the videobuf2 queue and doesn't

	typo: function

> + * have the struct video_device associated with the
> + * queue handy as in the case of vb2_core_streamon(). This
> + * function simply calls v4l_enable_media_tuner() passing
> + * in the pointer to struct video_device.

The hole description seems confusing. I'm not seeing the light
about why this is needed.

> + */
> +int v4l_vb2q_enable_media_tuner(struct vb2_queue *q)
> +{
> +	struct v4l2_fh *fh = q->owner;
> +
> +	return v4l_enable_media_tuner(fh->vdev);
> +}
> +EXPORT_SYMBOL_GPL(v4l_vb2q_enable_media_tuner);
> +
>  /* Priority handling */
>  
>  static inline bool prio_is_valid(enum v4l2_priority prio)
> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> index 68999a3..1948097 100644
> --- a/include/media/v4l2-dev.h
> +++ b/include/media/v4l2-dev.h
> @@ -179,6 +179,7 @@ struct video_device * __must_check video_device_alloc(void);
>  
>  int v4l_enable_media_tuner(struct video_device *vdev);
>  void v4l_disable_media_tuner(struct video_device *vdev);
> +int v4l_vb2q_enable_media_tuner(struct vb2_queue *q);

Documentation?

>  
>  /* this release function frees the vdev pointer */
>  void video_device_release(struct video_device *vdev);
