From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH 08/31] media: v4l-core add
 v4l_enable/disable_media_tuner() helper functions
Date: Thu, 28 Jan 2016 10:12:12 -0700
Message-ID: <56AA4BEC.8080807@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
 <e642fee6e443170b33a8c69fbc21b409f7be5583.1452105878.git.shuahkh@osg.samsung.com>
 <20160128132651.748a1271@recife.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160128132651.748a1271-+RedX5hVuTR+urZeOPWqwQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: tiwai-IBi9RG/b67k@public.gmane.org, clemens-P6GI/4k7KOmELgA04lAiVw@public.gmane.org, hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, javier-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org, m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, perex-/Fr2/VpizcU@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, tvboxspy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, crope-X3B1VOXEql0@public.gmane.org, ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, chehabrafael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org, inki.dae-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, jh1009.sung-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sw0312.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, labbott-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org, pierre-louis.bossart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, ricard.wanderlof-VrBV9hrLPhE@public.gmane.org, julian-SZMMDGyaqes@public.gmane.org, takamichiho-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dominic.sacre-Mmb7MZpHnFY@public.gmane.org, misterpib-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, gtmkramer-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, joe-amhYAVlgbXj10XsdtD+oqA@public.gmane.org, linuxbugs@vittga
List-Id: linux-api@vger.kernel.org

On 01/28/2016 08:26 AM, Mauro Carvalho Chehab wrote:
> Em Wed,  6 Jan 2016 13:26:57 -0700
> Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> escreveu:
> 
>> Add a new interfaces to be used by v4l-core to invoke enable
>> source and disable_source handlers in the media_device. The
>> enable_source helper function invokes the enable_source handler
>> to find tuner entity connected to the decoder and check is it
>> is available or busy. If tuner is available, link is activated
>> and pipeline is started. The disable_source helper function
>> invokes the disable_source handler to deactivate and stop the
>> pipeline.
>>
>> Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
>> ---
>>  drivers/media/v4l2-core/v4l2-dev.c | 27 +++++++++++++++++++++++++++
>>  include/media/v4l2-dev.h           |  4 ++++
>>  2 files changed, 31 insertions(+)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
>> index d8e5994..f06da6e 100644
>> --- a/drivers/media/v4l2-core/v4l2-dev.c
>> +++ b/drivers/media/v4l2-core/v4l2-dev.c
>> @@ -233,6 +233,33 @@ struct video_device *video_devdata(struct file *file)
>>  }
>>  EXPORT_SYMBOL(video_devdata);
>>  
>> +int v4l_enable_media_tuner(struct video_device *vdev)
> 
> IMHO, the better is to put those MC ancillary routines on a separate file.
> Hans suggested to add them at v4l2-mc.h and v4l2-mc.h.

ok I can do that.

> 
>> +{
>> +#ifdef CONFIG_MEDIA_CONTROLLER
>> +	struct media_device *mdev = vdev->entity.graph_obj.mdev;
>> +	int ret;
>> +
>> +	if (!mdev || !mdev->enable_source)
>> +		return 0;
>> +	ret = mdev->enable_source(&vdev->entity, &vdev->pipe);
>> +	if (ret)
>> +		return -EBUSY;
>> +	return 0;
>> +#endif /* CONFIG_MEDIA_CONTROLLER */
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(v4l_enable_media_tuner);
>> +
>> +void v4l_disable_media_tuner(struct video_device *vdev)
>> +{
>> +#ifdef CONFIG_MEDIA_CONTROLLER
>> +	struct media_device *mdev = vdev->entity.graph_obj.mdev;
>> +
>> +	if (mdev && mdev->disable_source)
>> +		mdev->disable_source(&vdev->entity);
>> +#endif /* CONFIG_MEDIA_CONTROLLER */
>> +}
>> +EXPORT_SYMBOL_GPL(v4l_disable_media_tuner);
>>  
>>  /* Priority handling */
>>  
>> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
>> index eeabf20..68999a3 100644
>> --- a/include/media/v4l2-dev.h
>> +++ b/include/media/v4l2-dev.h
>> @@ -87,6 +87,7 @@ struct video_device
>>  #if defined(CONFIG_MEDIA_CONTROLLER)
>>  	struct media_entity entity;
>>  	struct media_intf_devnode *intf_devnode;
>> +	struct media_pipeline pipe;
>>  #endif
>>  	/* device ops */
>>  	const struct v4l2_file_operations *fops;
>> @@ -176,6 +177,9 @@ void video_unregister_device(struct video_device *vdev);
>>     latter can also be used for video_device->release(). */
>>  struct video_device * __must_check video_device_alloc(void);
>>  
>> +int v4l_enable_media_tuner(struct video_device *vdev);
>> +void v4l_disable_media_tuner(struct video_device *vdev);
> 
> Documentation?

Since I am going to be adding a new source file, I can
add documentation in the same patch.

thanks,
-- Shuah

> 
>> +
>>  /* this release function frees the vdev pointer */
>>  void video_device_release(struct video_device *vdev);
>>  


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
