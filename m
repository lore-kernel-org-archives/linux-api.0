From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v2 12/22] media: au0828 video remove
 au0828_enable_analog_tuner()
Date: Thu, 4 Feb 2016 07:37:12 -0200
Message-ID: <20160204073712.25d96fcd@recife.lan>
References: <cover.1454557589.git.shuahkh@osg.samsung.com>
	<8d43a2cfe4dcdf843d2e587e35a4bd4681eebe36.1454557589.git.shuahkh@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8d43a2cfe4dcdf843d2e587e35a4bd4681eebe36.1454557589.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: tiwai-IBi9RG/b67k@public.gmane.org, clemens-P6GI/4k7KOmELgA04lAiVw@public.gmane.org, hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, javier-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org, m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, perex-/Fr2/VpizcU@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, tvboxspy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, crope-X3B1VOXEql0@public.gmane.org, ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, chehabrafael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org, inki.dae-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, jh1009.sung-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sw0312.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, labbott-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org, pierre-louis.bossart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, ricard.wanderlof-VrBV9hrLPhE@public.gmane.org, julian-SZMMDGyaqes@public.gmane.org, takamichiho-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dominic.sacre-Mmb7MZpHnFY@public.gmane.org, misterpib-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, gtmkramer-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, joe-amhYAVlgbXj10XsdtD+oqA@public.gmane.org, linuxbugs@vittga
List-Id: linux-api@vger.kernel.org

Em Wed, 03 Feb 2016 21:03:44 -0700
Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> escreveu:

> Remove au0828_enable_analog_tuner() as it is
> no longer needed because v4l2-core implements
> common interfaces to check for media source
> availability.

I didn't see such code at v4l2-core yet. Missing patch?

> 
> In addition, queue_setup() no longer needs the
> tuner availability check since v4l2-core does it.
> 
> Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> ---
>  drivers/media/usb/au0828/au0828-video.c | 61 ---------------------------------
>  1 file changed, 61 deletions(-)
> 
> diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
> index 8c54fd2..81952c8 100644
> --- a/drivers/media/usb/au0828/au0828-video.c
> +++ b/drivers/media/usb/au0828/au0828-video.c
> @@ -638,64 +638,6 @@ static inline int au0828_isoc_copy(struct au0828_dev *dev, struct urb *urb)
>  	return rc;
>  }
>  
> -static int au0828_enable_analog_tuner(struct au0828_dev *dev)
> -{
> -#ifdef CONFIG_MEDIA_CONTROLLER
> -	struct media_device *mdev = dev->media_dev;
> -	struct media_entity *source;
> -	struct media_link *link, *found_link = NULL;
> -	int ret, active_links = 0;
> -
> -	if (!mdev || !dev->decoder)
> -		return 0;
> -
> -	/*
> -	 * This will find the tuner that is connected into the decoder.
> -	 * Technically, this is not 100% correct, as the device may be
> -	 * using an analog input instead of the tuner. However, as we can't
> -	 * do DVB streaming while the DMA engine is being used for V4L2,
> -	 * this should be enough for the actual needs.
> -	 */
> -	list_for_each_entry(link, &dev->decoder->links, list) {
> -		if (link->sink->entity == dev->decoder) {
> -			found_link = link;
> -			if (link->flags & MEDIA_LNK_FL_ENABLED)
> -				active_links++;
> -			break;
> -		}
> -	}
> -
> -	if (active_links == 1 || !found_link)
> -		return 0;
> -
> -	source = found_link->source->entity;
> -	list_for_each_entry(link, &source->links, list) {
> -		struct media_entity *sink;
> -		int flags = 0;
> -
> -		sink = link->sink->entity;
> -
> -		if (sink == dev->decoder)
> -			flags = MEDIA_LNK_FL_ENABLED;
> -
> -		ret = media_entity_setup_link(link, flags);
> -		if (ret) {
> -			pr_err(
> -				"Couldn't change link %s->%s to %s. Error %d\n",
> -				source->name, sink->name,
> -				flags ? "enabled" : "disabled",
> -				ret);
> -			return ret;
> -		} else
> -			au0828_isocdbg(
> -				"link %s->%s was %s\n",
> -				source->name, sink->name,
> -				flags ? "ENABLED" : "disabled");
> -	}
> -#endif
> -	return 0;
> -}
> -
>  static int queue_setup(struct vb2_queue *vq,
>  		       unsigned int *nbuffers, unsigned int *nplanes,
>  		       unsigned int sizes[], void *alloc_ctxs[])
> @@ -707,9 +649,6 @@ static int queue_setup(struct vb2_queue *vq,
>  		return sizes[0] < size ? -EINVAL : 0;
>  	*nplanes = 1;
>  	sizes[0] = size;
> -
> -	au0828_enable_analog_tuner(dev);
> -
>  	return 0;
>  }
>  
