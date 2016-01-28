From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH 23/31] media: au0828 implement enable_source and
 disable_source handlers
Date: Thu, 28 Jan 2016 14:43:32 -0200
Message-ID: <20160128144332.39dc8b4b@recife.lan>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
	<6d1f10b616fc3c8b016cf0e335de569012400de8.1452105878.git.shuahkh@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6d1f10b616fc3c8b016cf0e335de569012400de8.1452105878.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: tiwai-IBi9RG/b67k@public.gmane.org, clemens-P6GI/4k7KOmELgA04lAiVw@public.gmane.org, hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, javier-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org, m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, perex-/Fr2/VpizcU@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, tvboxspy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, crope-X3B1VOXEql0@public.gmane.org, ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, chehabrafael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org, inki.dae-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, jh1009.sung-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sw0312.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, labbott-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org, pierre-louis.bossart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, ricard.wanderlof-VrBV9hrLPhE@public.gmane.org, julian-SZMMDGyaqes@public.gmane.org, takamichiho-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dominic.sacre-Mmb7MZpHnFY@public.gmane.org, misterpib-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, gtmkramer-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, joe-amhYAVlgbXj10XsdtD+oqA@public.gmane.org, linuxbugs@vittga
List-Id: linux-api@vger.kernel.org

Em Wed,  6 Jan 2016 13:27:12 -0700
Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> escreveu:

> Implements enable_source and disable_source handlers for other
> drivers (v4l2-core, dvb-core, and ALSA) to use to check for
> tuner connected to the decoder and activate the link if tuner
> is free, and deactivate and free the tuner when it is no longer
> needed.
> 
> Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> ---
>  drivers/media/usb/au0828/au0828-core.c | 148 +++++++++++++++++++++++++++++++++
>  drivers/media/usb/au0828/au0828.h      |   2 +
>  2 files changed, 150 insertions(+)
> 
> diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
> index a15a61a..f8d2db3 100644
> --- a/drivers/media/usb/au0828/au0828-core.c
> +++ b/drivers/media/usb/au0828/au0828-core.c
> @@ -370,6 +370,150 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
>  	return 0;
>  }
>  
> +static int au0828_enable_source(struct media_entity *entity,
> +				struct media_pipeline *pipe)
> +{

The best would be to put those enable source stuff at the core, in a way
that other drivers could share it.

Not sure about the implementation, as this requires testing ;)
Did you consider the cases where the source connector is S-Video
or Composite?

> +#ifdef CONFIG_MEDIA_CONTROLLER
> +	struct media_entity  *source;
> +	struct media_entity *sink;
> +	struct media_link *link, *found_link = NULL;
> +	int ret = 0;
> +	struct media_device *mdev = entity->graph_obj.mdev;
> +	struct au0828_dev *dev;
> +
> +	if (!mdev)
> +		return -ENODEV;
> +
> +	/* for Audio and Video entities, source is the decoder */
> +	mutex_lock(&mdev->graph_mutex);
> +
> +	dev = mdev->source_priv;
> +	if (!dev->tuner || !dev->decoder) {
> +		ret = -ENODEV;
> +		goto end;
> +	}
> +
> +	/*
> +	 * For Audio and V4L2 entity, find the link to which decoder
> +	 * is the sink. Look for an active link between decoder and
> +	 * tuner, if one exists, nothing to do. If not, look for any
> +	 * active links between tuner and any other entity. If one
> +	 * exists, tuner is busy. If tuner is free, setup link and
> +	 * start pipeline from source (tuner).
> +	 * For DVB FE entity, the source for the link is the tuner.
> +	 * Check if tuner is available and setup link and start
> +	 * pipeline.
> +	*/
> +	if (entity->function != MEDIA_ENT_F_DTV_DEMOD)
> +		sink = dev->decoder;
> +	else
> +		sink = entity;
> +
> +	/* Is an active link between sink and tuner */
> +	if (dev->active_link) {
> +		if (dev->active_link->sink->entity == sink &&
> +		    dev->active_link->source->entity == dev->tuner) {
> +			ret = 0;
> +			goto end;
> +		} else {
> +			ret = -EBUSY;
> +			goto end;
> +		}
> +	}
> +
> +	list_for_each_entry(link, &sink->links, list) {
> +		/* Check sink, and source */
> +		if (link->sink->entity == sink &&
> +		    link->source->entity == dev->tuner) {
> +			found_link = link;
> +			break;
> +		}
> +	}
> +
> +	if (!found_link) {
> +		ret = -ENODEV;
> +		goto end;
> +	}
> +
> +	/* activate link between source and sink and start pipeline */
> +	source = found_link->source->entity;
> +	ret = __media_entity_setup_link(found_link, MEDIA_LNK_FL_ENABLED);
> +	if (ret) {
> +		pr_err(
> +			"Activate tuner link %s->%s. Error %d\n",
> +			source->name, sink->name, ret);
> +		goto end;
> +	}
> +
> +	ret = __media_entity_pipeline_start(entity, pipe);
> +	if (ret) {
> +		pr_err("Start Pipeline: %s->%s Error %d\n",
> +			source->name, entity->name, ret);
> +		ret = __media_entity_setup_link(found_link, 0);
> +		pr_err("Deactive link Error %d\n", ret);
> +		goto end;
> +	}
> +	/*
> +	 * save active link and active link owner to avoid audio
> +	 * deactivating video owned link from disable_source and
> +	 * vice versa
> +	*/
> +	dev->active_link = found_link;
> +	dev->active_link_owner = entity;
> +end:
> +	mutex_unlock(&mdev->graph_mutex);
> +	pr_debug("au0828_enable_source() end %s %d %d\n",
> +		entity->name, entity->function, ret);
> +	return ret;
> +#endif
> +	return 0;
> +}
> +
> +static void au0828_disable_source(struct media_entity *entity)
> +{
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +	struct media_entity *sink;
> +	int ret = 0;
> +	struct media_device *mdev = entity->graph_obj.mdev;
> +	struct au0828_dev *dev;
> +
> +	if (!mdev)
> +		return;
> +
> +	mutex_lock(&mdev->graph_mutex);
> +	dev = mdev->source_priv;
> +	if (!dev->tuner || !dev->decoder || !dev->active_link) {
> +		ret = -ENODEV;
> +		goto end;
> +	}
> +
> +	if (entity->function != MEDIA_ENT_F_DTV_DEMOD)
> +		sink = dev->decoder;
> +	else
> +		sink = entity;
> +
> +	/* link is active - stop pipeline from source (tuner) */
> +	if (dev->active_link && dev->active_link->sink->entity == sink &&
> +	    dev->active_link->source->entity == dev->tuner) {
> +		/*
> +		 * prevent video from deactivating link when audio
> +		 * has active pipeline
> +		*/
> +		if (dev->active_link_owner != entity)
> +			goto end;
> +		__media_entity_pipeline_stop(entity);
> +		ret = __media_entity_setup_link(dev->active_link, 0);
> +		if (ret)
> +			pr_err("Deactive link Error %d\n", ret);
> +		dev->active_link = NULL;
> +		dev->active_link_owner = NULL;
> +	}
> +
> +end:
> +	mutex_unlock(&mdev->graph_mutex);
> +#endif
> +}
> +
>  static int au0828_media_device_register(struct au0828_dev *dev,
>  					struct usb_device *udev)
>  {
> @@ -400,6 +544,10 @@ static int au0828_media_device_register(struct au0828_dev *dev,
>  			ret);
>  		return ret;
>  	}
> +	/* set enable_source */
> +	dev->media_dev->source_priv = (void *) dev;
> +	dev->media_dev->enable_source = au0828_enable_source;
> +	dev->media_dev->disable_source = au0828_disable_source;
>  #endif
>  	return 0;
>  }
> diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
> index cfb6d58..3707664 100644
> --- a/drivers/media/usb/au0828/au0828.h
> +++ b/drivers/media/usb/au0828/au0828.h
> @@ -289,6 +289,8 @@ struct au0828_dev {
>  	bool vdev_linked;
>  	bool vbi_linked;
>  	bool audio_capture_linked;
> +	struct media_link *active_link;
> +	struct media_entity *active_link_owner;
>  #endif
>  };
>  
