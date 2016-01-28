From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH 20/31] media: au0828 change to register/unregister
 entity_notify hook
Date: Thu, 28 Jan 2016 13:05:35 -0700
Message-ID: <56AA748F.9040209@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
 <8ba7a2bcf7cde4d9361205c08ef5fca116b3973f.1452105878.git.shuahkh@osg.samsung.com>
 <20160128143610.154ce103@recife.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160128143610.154ce103-+RedX5hVuTR+urZeOPWqwQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: tiwai-IBi9RG/b67k@public.gmane.org, clemens-P6GI/4k7KOmELgA04lAiVw@public.gmane.org, hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, javier-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org, m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, perex-/Fr2/VpizcU@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, tvboxspy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, crope-X3B1VOXEql0@public.gmane.org, ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, chehabrafael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org, inki.dae-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, jh1009.sung-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sw0312.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, labbott-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org, pierre-louis.bossart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, ricard.wanderlof-VrBV9hrLPhE@public.gmane.org, julian-SZMMDGyaqes@public.gmane.org, takamichiho-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dominic.sacre-Mmb7MZpHnFY@public.gmane.org, misterpib-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, gtmkramer-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, joe-amhYAVlgbXj10XsdtD+oqA@public.gmane.org, linuxbugs@vittga
List-Id: linux-api@vger.kernel.org

On 01/28/2016 09:36 AM, Mauro Carvalho Chehab wrote:
> Em Wed,  6 Jan 2016 13:27:09 -0700
> Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> escreveu:
> 
>> au0828 registers entity_notify hook to create media graph for
>> the device. This handler runs whenvere a new entity gets added
> 
> typo: whenever.

ok

> 
>> to the media device. It creates necessary links from video, vbi,
>> and ALSA entities to decoder and links tuner and decoder entities.
>> As this handler runs as entities get added, it has to maintain
>> state on the links it already created. New fields are added to
>> au0828_dev to keep this state information. entity_notify gets
>> unregistered before media_device unregister.
> 
> Bty, please avoid long paragraphs at the patch description, 
> and please try to be clearer on your patch descriptions... That
> makes boring to read everything. :-;

Yeah I like to add details I consider relevant to the log.
I will try to be concise.

> 
>>
>> Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
>> ---
>>  drivers/media/usb/au0828/au0828-core.c | 104 +++++++++++++++++++++++----------
>>  drivers/media/usb/au0828/au0828.h      |   6 ++
>>  2 files changed, 78 insertions(+), 32 deletions(-)
>>
>> diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
>> index 6ef177c..a381660 100644
>> --- a/drivers/media/usb/au0828/au0828-core.c
>> +++ b/drivers/media/usb/au0828/au0828-core.c
>> @@ -137,6 +137,8 @@ static void au0828_unregister_media_device(struct au0828_dev *dev)
>>  #ifdef CONFIG_MEDIA_CONTROLLER
>>  	if (dev->media_dev &&
>>  		media_devnode_is_registered(&dev->media_dev->devnode)) {
>> +		media_device_unregister_entity_notify(dev->media_dev,
>> +						      &dev->entity_notify);
>>  		media_device_unregister(dev->media_dev);
>>  		media_device_cleanup(dev->media_dev);
>>  		dev->media_dev = NULL;
>> @@ -263,11 +265,16 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
>>  	struct media_device *mdev = dev->media_dev;
>>  	struct media_entity *entity;
>>  	struct media_entity *tuner = NULL, *decoder = NULL;
>> +	struct media_entity *audio_capture = NULL;
>>  	int i, ret;
>>  
>>  	if (!mdev)
>>  		return 0;
>>  
>> +	if (dev->tuner_linked && dev->vdev_linked && dev->vbi_linked &&
>> +	    dev->audio_capture_linked)
>> +		return 0;
>> +
>>  	media_device_for_each_entity(entity, mdev) {
>>  		switch (entity->function) {
>>  		case MEDIA_ENT_F_TUNER:
>> @@ -276,6 +283,9 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
>>  		case MEDIA_ENT_F_ATV_DECODER:
>>  			decoder = entity;
>>  			break;
>> +		case MEDIA_ENT_F_AUDIO_CAPTURE:
>> +			audio_capture = entity;
>> +			break;
>>  		}
>>  	}
>>  
>> @@ -285,60 +295,77 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
>>  	if (!decoder)
>>  		return -EINVAL;
>>  
>> -	if (tuner) {
>> +	if (tuner  && !dev->tuner_linked) {
>> +		dev->tuner = tuner;
>>  		ret = media_create_pad_link(tuner, TUNER_PAD_IF_OUTPUT,
>>  					    decoder, 0,
>>  					    MEDIA_LNK_FL_ENABLED);
>>  		if (ret)
>>  			return ret;
>> +		dev->tuner_linked = 1;
>>  	}
>> -	if (dev->vdev.entity.graph_obj.mdev) {
>> +	if (dev->vdev.entity.graph_obj.mdev && !dev->vdev_linked) {
>>  		ret = media_create_pad_link(decoder, AU8522_PAD_VID_OUT,
>>  					    &dev->vdev.entity, 0,
>>  					    MEDIA_LNK_FL_ENABLED);
>>  		if (ret)
>>  			return ret;
>> +		dev->vdev_linked = 1;
>>  	}
>> -	if (dev->vbi_dev.entity.graph_obj.mdev) {
>> +	if (dev->vbi_dev.entity.graph_obj.mdev && !dev->vbi_linked) {
>>  		ret = media_create_pad_link(decoder, AU8522_PAD_VBI_OUT,
>>  					    &dev->vbi_dev.entity, 0,
>>  					    MEDIA_LNK_FL_ENABLED);
>>  		if (ret)
>>  			return ret;
>> -	}
>> -
>> -	for (i = 0; i < AU0828_MAX_INPUT; i++) {
>> -		struct media_entity *ent = &dev->input_ent[i];
>> +		dev->vbi_linked = 1;
>>  
>> -		if (!ent->graph_obj.mdev)
>> -			continue;
>> +		/*
>> +		 * Input entities are registered before vbi entity,
>> +		 * create graph nodes for them after vbi is created
>> +		*/
>> +		for (i = 0; i < AU0828_MAX_INPUT; i++) {
>> +			struct media_entity *ent = &dev->input_ent[i];
>>  
>> -		if (AUVI_INPUT(i).type == AU0828_VMUX_UNDEFINED)
>> -			break;
>> +			if (!ent->graph_obj.mdev)
>> +				continue;
>>  
>> -		switch (AUVI_INPUT(i).type) {
>> -		case AU0828_VMUX_CABLE:
>> -		case AU0828_VMUX_TELEVISION:
>> -		case AU0828_VMUX_DVB:
>> -			if (!tuner)
>> +			if (AUVI_INPUT(i).type == AU0828_VMUX_UNDEFINED)
>>  				break;
>>  
>> -			ret = media_create_pad_link(ent, 0, tuner,
>> -						    TUNER_PAD_RF_INPUT,
>> -						    MEDIA_LNK_FL_ENABLED);
>> -			if (ret)
>> -				return ret;
>> -			break;
>> -		case AU0828_VMUX_COMPOSITE:
>> -		case AU0828_VMUX_SVIDEO:
>> -		default: /* AU0828_VMUX_DEBUG */
>> -			/* FIXME: fix the decoder PAD */
>> -			ret = media_create_pad_link(ent, 0, decoder, 0, 0);
>> -			if (ret)
>> -				return ret;
>> -			break;
>> +			switch (AUVI_INPUT(i).type) {
>> +			case AU0828_VMUX_CABLE:
>> +			case AU0828_VMUX_TELEVISION:
>> +			case AU0828_VMUX_DVB:
>> +				if (!tuner)
>> +					break;
>> +
>> +				ret = media_create_pad_link(ent, 0, tuner,
>> +							TUNER_PAD_RF_INPUT,
>> +							MEDIA_LNK_FL_ENABLED);
>> +				if (ret)
>> +					return ret;
>> +				break;
>> +			case AU0828_VMUX_COMPOSITE:
>> +			case AU0828_VMUX_SVIDEO:
>> +			default: /* AU0828_VMUX_DEBUG */
>> +				/* FIXME: fix the decoder PAD */
>> +				ret = media_create_pad_link(ent, 0, decoder,
>> +							    0, 0);
>> +				if (ret)
>> +					return ret;
>> +				break;
>> +			}
>>  		}
>>  	}
>> +	if (audio_capture && !dev->audio_capture_linked) {
>> +		ret = media_create_pad_link(decoder, AU8522_PAD_AUDIO_OUT,
>> +					    audio_capture, 0,
>> +					    MEDIA_LNK_FL_ENABLED);
>> +		if (ret)
>> +			return ret;
>> +		dev->audio_capture_linked = 1;
>> +	}
>>  #endif
>>  	return 0;
>>  }
>> @@ -349,8 +376,10 @@ static int au0828_media_device_register(struct au0828_dev *dev,
>>  #ifdef CONFIG_MEDIA_CONTROLLER
>>  	int ret;
>>  
>> -	if (dev->media_dev &&
>> -		!media_devnode_is_registered(&dev->media_dev->devnode)) {
>> +	if (!dev->media_dev)
>> +		return 0;
>> +
>> +	if (!media_devnode_is_registered(&dev->media_dev->devnode)) {
>>  
>>  		/* register media device */
>>  		ret = media_device_register(dev->media_dev);
>> @@ -360,6 +389,17 @@ static int au0828_media_device_register(struct au0828_dev *dev,
>>  			return ret;
>>  		}
>>  	}
>> +	/* register entity_notify callback */
>> +	dev->entity_notify.notify_data = (void *) dev;
>> +	dev->entity_notify.notify = (void *) au0828_create_media_graph;
>> +	ret = media_device_register_entity_notify(dev->media_dev,
>> +						  &dev->entity_notify);
>> +	if (ret) {
>> +		dev_err(&udev->dev,
>> +			"Media Device register entity_notify Error: %d\n",
>> +			ret);
>> +		return ret;
>> +	}
>>  #endif
>>  	return 0;
>>  }
>> diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
>> index 8276072..cfb6d58 100644
>> --- a/drivers/media/usb/au0828/au0828.h
>> +++ b/drivers/media/usb/au0828/au0828.h
>> @@ -283,6 +283,12 @@ struct au0828_dev {
>>  	struct media_entity *decoder;
>>  	struct media_entity input_ent[AU0828_MAX_INPUT];
>>  	struct media_pad input_pad[AU0828_MAX_INPUT];
>> +	struct media_entity_notify entity_notify;
>> +	struct media_entity *tuner;
>> +	bool tuner_linked;
>> +	bool vdev_linked;
>> +	bool vbi_linked;
>> +	bool audio_capture_linked;
> 
> Hmm... now I understood why you did the changes on patch 13/31.
> 
> I see what you're doing, but not sure if this is a good idea
> to have one bool for each possible device. On au0828, the
> topology is actually simpler than on other devices, as it
> currently supports a very few set of I2C devices, but on other
> drivers, things can be messier.
> 
> See, for example, two graphs for em28xx-based devices:
> 	https://mchehab.fedorapeople.org/mc-next-gen/wintv_usb2.png
> 	https://mchehab.fedorapeople.org/mc-next-gen/hvr_950.png
> 
> On the first graph, the tuner is not connected directly to the
> analog demod, but, instead, to two other elements:
> 	- tda9887 - for video
> 	- msp3400 - for audio
> 
> IMHO, the best way to handle graph setup is that each driver
> should handle the links that belong only to them synchronously,
> after creating/registering all the entities.

Except for the ALSA part of the graph, we are close
to drivers creating their graphs. You are right that
au0828 graph creation routine shouldn't need to create
links from Alsa mixer to Alsa capture nodes.
 
> 
> So, only the links between two drivers would be asynchronously
> created. So, In the case of au0828:
> 
> - au0828 core will create the connector entities;
> 
> - I2C drivers will create their own entities;
> 
> - DVB core will create the DVB entities/interfaces;
> 
> - V4L core will create V4L interfaces and I/O entities;
> 
> - au0828 V4L driver will create all V4L links, after
>   ensuring that the needed I2C drivers were bound;
> 
> - snd-usb-audio will create all ALSA-specific entities links;
> 
> The V4L->ALSA links will either be created by au0828-core,
> via the notification handler.

Right - that is part of what au0828_create_media_graph()
is doing now.

> 
> With that in mind, I don't see any need to touch at
> au0828_create_media_graph(). It will need an extra function
> to handle the notification when ALSA gets registered
> (or when the entities there are added, whatever works best).
> 

If I understand correctly, what you are saying is:

Don't add async handling that creates V4L->ALSA
to au0828_create_media_graph() and keep that in
an async handler.

I will make changes to address this.

thanks,
-- Shuah
> 
> 
> 
> 
> 
>>  #endif
>>  };
>>  


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
