From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 23/31] media: au0828 implement enable_source and
 disable_source handlers
Date: Thu, 28 Jan 2016 13:14:25 -0700
Message-ID: <56AA76A1.7040107@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
 <6d1f10b616fc3c8b016cf0e335de569012400de8.1452105878.git.shuahkh@osg.samsung.com>
 <20160128144332.39dc8b4b@recife.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <20160128144332.39dc8b4b@recife.lan>
Sender: linux-media-owner@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, hans.verkuil@cisco.com
Cc: tiwai@suse.com, clemens@ladisch.de, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net, johan@oljud.se
List-Id: linux-api@vger.kernel.org

On 01/28/2016 09:43 AM, Mauro Carvalho Chehab wrote:
> Em Wed,  6 Jan 2016 13:27:12 -0700
> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> 
>> Implements enable_source and disable_source handlers for other
>> drivers (v4l2-core, dvb-core, and ALSA) to use to check for
>> tuner connected to the decoder and activate the link if tuner
>> is free, and deactivate and free the tuner when it is no longer
>> needed.
>>
>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>> ---
>>  drivers/media/usb/au0828/au0828-core.c | 148 +++++++++++++++++++++++++++++++++
>>  drivers/media/usb/au0828/au0828.h      |   2 +
>>  2 files changed, 150 insertions(+)
>>
>> diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
>> index a15a61a..f8d2db3 100644
>> --- a/drivers/media/usb/au0828/au0828-core.c
>> +++ b/drivers/media/usb/au0828/au0828-core.c
>> @@ -370,6 +370,150 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
>>  	return 0;
>>  }
>>  
>> +static int au0828_enable_source(struct media_entity *entity,
>> +				struct media_pipeline *pipe)
>> +{
> 
> The best would be to put those enable source stuff at the core, in a way
> that other drivers could share it.

Hans and I discussed this at the Media Summit in Finland.
It will be very difficult to make this work in a generic
way. Besides, bridge driver knows the hardware it has and
it would make sense for it to implement enable and disable
source handlers.

> 
> Not sure about the implementation, as this requires testing ;)
> Did you consider the cases where the source connector is S-Video
> or Composite?

I think you asked this question on another patch and Devin
responded to that thread. Let's discuss it there.

thanks,
-- Shuah
> 
>> +#ifdef CONFIG_MEDIA_CONTROLLER
>> +	struct media_entity  *source;
>> +	struct media_entity *sink;
>> +	struct media_link *link, *found_link = NULL;
>> +	int ret = 0;
>> +	struct media_device *mdev = entity->graph_obj.mdev;
>> +	struct au0828_dev *dev;
>> +
>> +	if (!mdev)
>> +		return -ENODEV;
>> +
>> +	/* for Audio and Video entities, source is the decoder */
>> +	mutex_lock(&mdev->graph_mutex);
>> +
>> +	dev = mdev->source_priv;
>> +	if (!dev->tuner || !dev->decoder) {
>> +		ret = -ENODEV;
>> +		goto end;
>> +	}
>> +
>> +	/*
>> +	 * For Audio and V4L2 entity, find the link to which decoder
>> +	 * is the sink. Look for an active link between decoder and
>> +	 * tuner, if one exists, nothing to do. If not, look for any
>> +	 * active links between tuner and any other entity. If one
>> +	 * exists, tuner is busy. If tuner is free, setup link and
>> +	 * start pipeline from source (tuner).
>> +	 * For DVB FE entity, the source for the link is the tuner.
>> +	 * Check if tuner is available and setup link and start
>> +	 * pipeline.
>> +	*/
>> +	if (entity->function != MEDIA_ENT_F_DTV_DEMOD)
>> +		sink = dev->decoder;
>> +	else
>> +		sink = entity;
>> +
>> +	/* Is an active link between sink and tuner */
>> +	if (dev->active_link) {
>> +		if (dev->active_link->sink->entity == sink &&
>> +		    dev->active_link->source->entity == dev->tuner) {
>> +			ret = 0;
>> +			goto end;
>> +		} else {
>> +			ret = -EBUSY;
>> +			goto end;
>> +		}
>> +	}
>> +
>> +	list_for_each_entry(link, &sink->links, list) {
>> +		/* Check sink, and source */
>> +		if (link->sink->entity == sink &&
>> +		    link->source->entity == dev->tuner) {
>> +			found_link = link;
>> +			break;
>> +		}
>> +	}
>> +
>> +	if (!found_link) {
>> +		ret = -ENODEV;
>> +		goto end;
>> +	}
>> +
>> +	/* activate link between source and sink and start pipeline */
>> +	source = found_link->source->entity;
>> +	ret = __media_entity_setup_link(found_link, MEDIA_LNK_FL_ENABLED);
>> +	if (ret) {
>> +		pr_err(
>> +			"Activate tuner link %s->%s. Error %d\n",
>> +			source->name, sink->name, ret);
>> +		goto end;
>> +	}
>> +
>> +	ret = __media_entity_pipeline_start(entity, pipe);
>> +	if (ret) {
>> +		pr_err("Start Pipeline: %s->%s Error %d\n",
>> +			source->name, entity->name, ret);
>> +		ret = __media_entity_setup_link(found_link, 0);
>> +		pr_err("Deactive link Error %d\n", ret);
>> +		goto end;
>> +	}
>> +	/*
>> +	 * save active link and active link owner to avoid audio
>> +	 * deactivating video owned link from disable_source and
>> +	 * vice versa
>> +	*/
>> +	dev->active_link = found_link;
>> +	dev->active_link_owner = entity;
>> +end:
>> +	mutex_unlock(&mdev->graph_mutex);
>> +	pr_debug("au0828_enable_source() end %s %d %d\n",
>> +		entity->name, entity->function, ret);
>> +	return ret;
>> +#endif
>> +	return 0;
>> +}
>> +
>> +static void au0828_disable_source(struct media_entity *entity)
>> +{
>> +#ifdef CONFIG_MEDIA_CONTROLLER
>> +	struct media_entity *sink;
>> +	int ret = 0;
>> +	struct media_device *mdev = entity->graph_obj.mdev;
>> +	struct au0828_dev *dev;
>> +
>> +	if (!mdev)
>> +		return;
>> +
>> +	mutex_lock(&mdev->graph_mutex);
>> +	dev = mdev->source_priv;
>> +	if (!dev->tuner || !dev->decoder || !dev->active_link) {
>> +		ret = -ENODEV;
>> +		goto end;
>> +	}
>> +
>> +	if (entity->function != MEDIA_ENT_F_DTV_DEMOD)
>> +		sink = dev->decoder;
>> +	else
>> +		sink = entity;
>> +
>> +	/* link is active - stop pipeline from source (tuner) */
>> +	if (dev->active_link && dev->active_link->sink->entity == sink &&
>> +	    dev->active_link->source->entity == dev->tuner) {
>> +		/*
>> +		 * prevent video from deactivating link when audio
>> +		 * has active pipeline
>> +		*/
>> +		if (dev->active_link_owner != entity)
>> +			goto end;
>> +		__media_entity_pipeline_stop(entity);
>> +		ret = __media_entity_setup_link(dev->active_link, 0);
>> +		if (ret)
>> +			pr_err("Deactive link Error %d\n", ret);
>> +		dev->active_link = NULL;
>> +		dev->active_link_owner = NULL;
>> +	}
>> +
>> +end:
>> +	mutex_unlock(&mdev->graph_mutex);
>> +#endif
>> +}
>> +
>>  static int au0828_media_device_register(struct au0828_dev *dev,
>>  					struct usb_device *udev)
>>  {
>> @@ -400,6 +544,10 @@ static int au0828_media_device_register(struct au0828_dev *dev,
>>  			ret);
>>  		return ret;
>>  	}
>> +	/* set enable_source */
>> +	dev->media_dev->source_priv = (void *) dev;
>> +	dev->media_dev->enable_source = au0828_enable_source;
>> +	dev->media_dev->disable_source = au0828_disable_source;
>>  #endif
>>  	return 0;
>>  }
>> diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
>> index cfb6d58..3707664 100644
>> --- a/drivers/media/usb/au0828/au0828.h
>> +++ b/drivers/media/usb/au0828/au0828.h
>> @@ -289,6 +289,8 @@ struct au0828_dev {
>>  	bool vdev_linked;
>>  	bool vbi_linked;
>>  	bool audio_capture_linked;
>> +	struct media_link *active_link;
>> +	struct media_entity *active_link_owner;
>>  #endif
>>  };
>>  


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
