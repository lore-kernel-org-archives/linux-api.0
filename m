From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH 29/31] media: track media device unregister in progress
Date: Thu, 28 Jan 2016 15:28:43 -0200
Message-ID: <20160128152843.5ce581fa@recife.lan>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
	<151cfbe0e59b3d5396951bdcc29666614575f5bc.1452105878.git.shuahkh@osg.samsung.com>
	<20160128150105.06a9a18d@recife.lan>
	<56AA4A18.8030303@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56AA4A18.8030303-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: tiwai-IBi9RG/b67k@public.gmane.org, clemens-P6GI/4k7KOmELgA04lAiVw@public.gmane.org, hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, javier-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org, m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, perex-/Fr2/VpizcU@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, tvboxspy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, crope-X3B1VOXEql0@public.gmane.org, ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, chehabrafael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org, inki.dae-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, jh1009.sung-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sw0312.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, labbott-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org, pierre-louis.bossart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, ricard.wanderlof-VrBV9hrLPhE@public.gmane.org, julian-SZMMDGyaqes@public.gmane.org, takamichiho-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dominic.sacre-Mmb7MZpHnFY@public.gmane.org, misterpib-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, gtmkramer-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, joe-amhYAVlgbXj10XsdtD+oqA@public.gmane.org, linuxbugs@vittga
List-Id: linux-api@vger.kernel.org

Em Thu, 28 Jan 2016 10:04:24 -0700
Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> escreveu:

> On 01/28/2016 10:01 AM, Mauro Carvalho Chehab wrote:
> > Em Wed,  6 Jan 2016 13:27:18 -0700
> > Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> escreveu:
> >   
> >> Add support to track media device unregister in progress
> >> state to prevent more than one driver entering unregister.
> >> This enables fixing the general protection faults while
> >> snd-usb-audio was cleaning up media resources for pcm
> >> streams and mixers. In this patch a new interface is added
> >> to return the unregister in progress state. Subsequent
> >> patches to snd-usb-audio and au0828-core use this interface
> >> to avoid entering unregister and attempting to unregister
> >> entities and remove devnodes while unregister is in progress.
> >> Media device unregister removes entities and interface nodes.  
> > 
> > Hmm... isn't the spinlock enough to serialize it? It seems weird the
> > need of an extra bool here to warrant that this is really serialized.
> >   
> 
> The spinlock and check for media_devnode_is_registered(&mdev->devnode)
> aren't enough to ensure only one driver enters the unregister. 
>
> Please
> note that the devnode isn't marked unregistered until the end in
> media_device_unregister().

I guess the call to:
	device_remove_file(&mdev->devnode.dev, &dev_attr_model);

IMO, This should be, instead, at media_devnode_unregister().

Then, we can change the logic at media_devnode_unregister() to:

void media_devnode_unregister(struct media_devnode *mdev)
{
	mutex_lock(&media_devnode_lock);

	/* Check if mdev was ever registered at all */
	if (!media_devnode_is_registered(mdev)) {
		mutex_unlock(&media_devnode_lock);
		return;
	}

	clear_bit(MEDIA_FLAG_REGISTERED, &mdev->flags);
	mutex_unlock(&media_devnode_lock);
	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
	device_unregister(&mdev->dev);
}

This sounds enough to avoid device_unregister() or device_remove_file()
to be called twice.

> 
> 
> >>
> >> Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> >> ---
> >>  drivers/media/media-device.c |  5 ++++-
> >>  include/media/media-device.h | 17 +++++++++++++++++
> >>  2 files changed, 21 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> >> index 20c85a9..1bb9a5f 100644
> >> --- a/drivers/media/media-device.c
> >> +++ b/drivers/media/media-device.c
> >> @@ -749,10 +749,13 @@ void media_device_unregister(struct media_device *mdev)
> >>  	spin_lock(&mdev->lock);
> >>  
> >>  	/* Check if mdev was ever registered at all */
> >> -	if (!media_devnode_is_registered(&mdev->devnode)) {
> >> +	/* check if unregister is in progress */
> >> +	if (!media_devnode_is_registered(&mdev->devnode) ||
> >> +	    mdev->unregister_in_progress) {
> >>  		spin_unlock(&mdev->lock);
> >>  		return;
> >>  	}
> >> +	mdev->unregister_in_progress = true;
> >>  
> >>  	/* Remove all entities from the media device */
> >>  	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
> >> diff --git a/include/media/media-device.h b/include/media/media-device.h
> >> index 04b6c2e..0807292 100644
> >> --- a/include/media/media-device.h
> >> +++ b/include/media/media-device.h
> >> @@ -332,6 +332,10 @@ struct media_device {
> >>  	spinlock_t lock;
> >>  	/* Serializes graph operations. */
> >>  	struct mutex graph_mutex;
> >> +	/* Tracks unregister in progress state to prevent
> >> +	 * more than one driver entering unregister
> >> +	*/
> >> +	bool unregister_in_progress;
> >>  
> >>  	/* Handlers to find source entity for the sink entity and
> >>  	 * check if it is available, and activate the link using
> >> @@ -365,6 +369,7 @@ struct media_device {
> >>  /* media_devnode to media_device */
> >>  #define to_media_device(node) container_of(node, struct media_device, devnode)
> >>  
> >> +
> >>  /**
> >>   * media_entity_enum_init - Initialise an entity enumeration
> >>   *
> >> @@ -553,6 +558,12 @@ struct media_device *media_device_get_devres(struct device *dev);
> >>   * @dev: pointer to struct &device.
> >>   */
> >>  struct media_device *media_device_find_devres(struct device *dev);
> >> +/* return unregister in progress state */
> >> +static inline bool media_device_is_unregister_in_progress(
> >> +					struct media_device *mdev)
> >> +{
> >> +	return mdev->unregister_in_progress;
> >> +}
> >>  
> >>  /* Iterate over all entities. */
> >>  #define media_device_for_each_entity(entity, mdev)			\
> >> @@ -569,6 +580,7 @@ struct media_device *media_device_find_devres(struct device *dev);
> >>  /* Iterate over all links. */
> >>  #define media_device_for_each_link(link, mdev)			\
> >>  	list_for_each_entry(link, &(mdev)->links, graph_obj.list)
> >> +
> >>  #else
> >>  static inline int media_device_register(struct media_device *mdev)
> >>  {
> >> @@ -604,5 +616,10 @@ static inline struct media_device *media_device_find_devres(struct device *dev)
> >>  {
> >>  	return NULL;
> >>  }
> >> +static inline bool media_device_is_unregister_in_progress(
> >> +					struct media_device *mdev)
> >> +{
> >> +	return false;
> >> +}
> >>  #endif /* CONFIG_MEDIA_CONTROLLER */
> >>  #endif  
> 
> 
