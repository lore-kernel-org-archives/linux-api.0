From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH 03/31] media: Media Controller register/unregister
 entity_notify API
Date: Thu, 28 Jan 2016 13:13:58 -0200
Message-ID: <20160128131358.40fb3521@recife.lan>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
	<01a8373c514c6728094056532e82f13192dcbb3f.1452105878.git.shuahkh@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <01a8373c514c6728094056532e82f13192dcbb3f.1452105878.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: tiwai-IBi9RG/b67k@public.gmane.org, clemens-P6GI/4k7KOmELgA04lAiVw@public.gmane.org, hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, javier-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org, m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, perex-/Fr2/VpizcU@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, tvboxspy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, crope-X3B1VOXEql0@public.gmane.org, ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, chehabrafael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org, inki.dae-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, jh1009.sung-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sw0312.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, labbott-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org, pierre-louis.bossart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, ricard.wanderlof-VrBV9hrLPhE@public.gmane.org, julian-SZMMDGyaqes@public.gmane.org, takamichiho-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dominic.sacre-Mmb7MZpHnFY@public.gmane.org, misterpib-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, gtmkramer-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, joe-amhYAVlgbXj10XsdtD+oqA@public.gmane.org, linuxbugs@vittga
List-Id: linux-api@vger.kernel.org

Em Wed,  6 Jan 2016 13:26:52 -0700
Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> escreveu:

> Add new interfaces to register and unregister entity_notify
> hook to media device to allow drivers to take appropriate
> actions when as new entities get added to the shared media
> device.When a new entity is registered, all registered
> entity_notify hooks are invoked to allow drivers or modules
> that registered hook to take appropriate action. For example,
> ALSA driver registers an entity_notify hook to parse the list
> of registered entities to determine if decoder has been linked
> to ALSA entity. au0828 bridge driver registers an entity_notify
> hook to create media graph for the device.
> 
> Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> ---
>  drivers/media/media-device.c | 61 ++++++++++++++++++++++++++++++++++++++++++++
>  include/media/media-device.h | 25 ++++++++++++++++++
>  2 files changed, 86 insertions(+)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index b786b10..20c85a9 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -536,6 +536,7 @@ static void media_device_release(struct media_devnode *mdev)
>  int __must_check media_device_register_entity(struct media_device *mdev,
>  					      struct media_entity *entity)
>  {
> +	struct media_entity_notify *notify, *next;
>  	unsigned int i;
>  	int ret;
>  
> @@ -575,6 +576,11 @@ int __must_check media_device_register_entity(struct media_device *mdev,
>  		media_gobj_create(mdev, MEDIA_GRAPH_PAD,
>  			       &entity->pads[i].graph_obj);
>  
> +	/* invoke entity_notify callbacks */
> +	list_for_each_entry_safe(notify, next, &mdev->entity_notify, list) {
> +		(notify)->notify(entity, notify->notify_data);
> +	}
> +
>  	spin_unlock(&mdev->lock);
>  
>  	return 0;
> @@ -608,6 +614,8 @@ static void __media_device_unregister_entity(struct media_entity *entity)
>  	/* Remove the entity */
>  	media_gobj_destroy(&entity->graph_obj);
>  
> +	/* invoke entity_notify callbacks to handle entity removal?? */
> +
>  	entity->graph_obj.mdev = NULL;
>  }
>  
> @@ -633,6 +641,7 @@ int __must_check media_device_init(struct media_device *mdev)
>  	INIT_LIST_HEAD(&mdev->interfaces);
>  	INIT_LIST_HEAD(&mdev->pads);
>  	INIT_LIST_HEAD(&mdev->links);
> +	INIT_LIST_HEAD(&mdev->entity_notify);
>  	spin_lock_init(&mdev->lock);
>  	mutex_init(&mdev->graph_mutex);
>  	ida_init(&mdev->entity_internal_idx);
> @@ -680,11 +689,59 @@ int __must_check __media_device_register(struct media_device *mdev,
>  }
>  EXPORT_SYMBOL_GPL(__media_device_register);
>  
> +/**
> + * media_device_register_entity_notify - Register a media entity notify
> + * callback with a media device. When a new entity is registered, all
> + * the registered media_entity_notify callbacks are invoked.
> + * @mdev:      The media device
> + * @nptr:      The media_entity_notify
> + */

Please put the documentation only at the header files. Please mention that
it locks the addition using the mdev->lock spinlock.

Also, please follow the format that we're using with other KernelDoc
tags:

/**
 * function() - short description
 *
 * @foo:	foo description
 * @bar:	bar description
 *
 * detailed description
 */

In case of doubts, please check Documentation/kernel-doc-nano-HOWTO.txt.

Don't forget to check if the documentation looks sane by compiling it
with:
	make cleandocs
	make DOCBOOKS=device-drivers.xml htmldocs

Same applies to other documentation below and on other patches in this
series.

> +int __must_check media_device_register_entity_notify(struct media_device *mdev,
> +					struct media_entity_notify *nptr)
> +{
> +	spin_lock(&mdev->lock);
> +	list_add_tail(&nptr->list, &mdev->entity_notify);
> +	spin_unlock(&mdev->lock);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(media_device_register_entity_notify);
> +
> +/**
> + * __media_device_unregister_entity_notify - Unregister a media entity notify
> + * callback with a media device. When a new entity is registered, all
> + * the registered media_entity_notify callbacks are invoked.
> + * @mdev:      The media device
> + * @nptr:      The media_entity_notify
> + * Non-locking version. Should be called with mdev->lock held.
> + */
> +static void __media_device_unregister_entity_notify(struct media_device *mdev,
> +					struct media_entity_notify *nptr)

__must_check

> +{
> +	list_del(&nptr->list);
> +}
> +
> +/**
> + * media_device_unregister_entity_notify - Unregister a media entity notify
> + * callback with a media device. When a new entity is registered, all
> + * the registered media_entity_notify callbacks are invoked.
> + * @mdev:      The media device
> + * @nptr:      The media_entity_notify
> + */
> +void media_device_unregister_entity_notify(struct media_device *mdev,
> +					struct media_entity_notify *nptr)
> +{
> +	spin_lock(&mdev->lock);
> +	__media_device_unregister_entity_notify(mdev, nptr);
> +	spin_unlock(&mdev->lock);
> +}
> +EXPORT_SYMBOL_GPL(media_device_unregister_entity_notify);
> +
>  void media_device_unregister(struct media_device *mdev)
>  {
>  	struct media_entity *entity;
>  	struct media_entity *next;
>  	struct media_interface *intf, *tmp_intf;
> +	struct media_entity_notify *notify, *nextp;
>  
>  	if (mdev == NULL)
>  		return;
> @@ -701,6 +758,10 @@ void media_device_unregister(struct media_device *mdev)
>  	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
>  		__media_device_unregister_entity(entity);
>  
> +	/* Remove all entity_notify callbacks from the media device */
> +	list_for_each_entry_safe(notify, nextp, &mdev->entity_notify, list)
> +		__media_device_unregister_entity_notify(mdev, notify);
> +
>  	/* Remove all interfaces from the media device */
>  	list_for_each_entry_safe(intf, tmp_intf, &mdev->interfaces,
>  				 graph_obj.list) {
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index 122963a..6520d1c 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -264,6 +264,12 @@
>  struct ida;
>  struct device;
>  
> +struct media_entity_notify {
> +	struct list_head list;
> +	void *notify_data;
> +	void (*notify)(struct media_entity *entity, void *notify_data);
> +};

Please document the structure.

> +
>  /**
>   * struct media_device - Media device
>   * @dev:	Parent device
> @@ -319,6 +325,9 @@ struct media_device {
>  	struct list_head pads;
>  	struct list_head links;
>  
> +	/* notify callback list invoked when a new entity is registered */
> +	struct list_head entity_notify;
> +

Please document the new field at the Kernel-doc header.

>  	/* Protects the graph objects creation/removal */
>  	spinlock_t lock;
>  	/* Serializes graph operations. */
> @@ -497,6 +506,11 @@ int __must_check media_device_register_entity(struct media_device *mdev,
>   */
>  void media_device_unregister_entity(struct media_entity *entity);
>  
> +int __must_check media_device_register_entity_notify(struct media_device *mdev,
> +					struct media_entity_notify *nptr);
> +void media_device_unregister_entity_notify(struct media_device *mdev,
> +					struct media_entity_notify *nptr);
> +

Documentation?

>  /**
>   * media_device_get_devres() -	get media device as device resource
>   *				creates if one doesn't exist
> @@ -552,6 +566,17 @@ static inline int media_device_register_entity(struct media_device *mdev,
>  static inline void media_device_unregister_entity(struct media_entity *entity)
>  {
>  }
> +static inline int media_device_register_entity_notify(
> +					struct media_device *mdev,
> +					struct media_entity_notify *nptr)
> +{
> +	return 0;
> +}
> +static inline void media_device_unregister_entity_notify(
> +					struct media_device *mdev,
> +					struct media_entity_notify *nptr)
> +{
> +}
>  static inline struct media_device *media_device_get_devres(struct device *dev)
>  {
>  	return NULL;

Documentation?

Regards,
Mauro
