From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH v2 22/22] media: Ensure media device unregister is done
 only once
Date: Thu, 4 Feb 2016 08:40:44 -0200
Message-ID: <20160204084044.234f1867@recife.lan>
References: <cover.1454557589.git.shuahkh@osg.samsung.com>
	<9c22d4395f92102051383110cae9de09494d7257.1454557589.git.shuahkh@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9c22d4395f92102051383110cae9de09494d7257.1454557589.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittga
List-Id: linux-api@vger.kernel.org

Em Wed, 03 Feb 2016 21:03:54 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> media_device_unregister() checks if the media device
> is registered or not as the first step. However, the
> MEDIA_FLAG_REGISTERED bit doesn't get cleared until
> the end leaving a large window for two drivers to
> attempt media device unregister.
> 
> The above leads to general protection faults when
> device is removed.
> 
> Fix the problem with two phase media device unregister.
> Add a new interface media_devnode_start_unregister()
> to clear the MEDIA_FLAG_REGISTERED bit. Change
> media_device_unregister() call this interface to mark
> the start of unregister. This will ensure that media
> device unregister is done only once.

Hmm... it sounds simpler to use a kref at device register
and when other drivers need instantiate media_dev. We can
then do a kref_put() at unregister, and run the actual
unregister code and media_ctl kfree only when kref is
decremented on all drivers.

Regards,
Mauro
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  drivers/media/media-device.c  | 12 ++++++------
>  drivers/media/media-devnode.c | 15 ++++++++++-----
>  include/media/media-devnode.h | 17 +++++++++++++++++
>  3 files changed, 33 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 1f5d67e..584d46e 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -747,17 +747,17 @@ void media_device_unregister(struct media_device *mdev)
>  	struct media_entity *next;
>  	struct media_interface *intf, *tmp_intf;
>  	struct media_entity_notify *notify, *nextp;
> +	int ret;
>  
>  	if (mdev == NULL)
>  		return;
>  
> -	spin_lock(&mdev->lock);
> -
> -	/* Check if mdev was ever registered at all */
> -	if (!media_devnode_is_registered(&mdev->devnode)) {
> -		spin_unlock(&mdev->lock);
> +	/* Start unregister - continue if necessary */
> +	ret = media_devnode_start_unregister(&mdev->devnode);
> +	if (ret)
>  		return;
> -	}
> +
> +	spin_lock(&mdev->lock);
>  
>  	/* Remove all entities from the media device */
>  	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
> diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
> index 29409f4..c27f9e7 100644
> --- a/drivers/media/media-devnode.c
> +++ b/drivers/media/media-devnode.c
> @@ -272,15 +272,20 @@ error:
>  	return ret;
>  }
>  
> -void media_devnode_unregister(struct media_devnode *mdev)
> +int __must_check media_devnode_start_unregister(struct media_devnode *mdev)
>  {
> -	/* Check if mdev was ever registered at all */
> -	if (!media_devnode_is_registered(mdev))
> -		return;
> -
>  	mutex_lock(&media_devnode_lock);
> +	if (!media_devnode_is_registered(mdev)) {
> +		mutex_unlock(&media_devnode_lock);
> +		return -EINVAL;
> +	}
>  	clear_bit(MEDIA_FLAG_REGISTERED, &mdev->flags);
>  	mutex_unlock(&media_devnode_lock);
> +	return 0;
> +}
> +
> +void media_devnode_unregister(struct media_devnode *mdev)
> +{
>  	device_unregister(&mdev->dev);
>  }
>  
> diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
> index fe42f08..6f08677 100644
> --- a/include/media/media-devnode.h
> +++ b/include/media/media-devnode.h
> @@ -120,6 +120,23 @@ int __must_check media_devnode_register(struct media_devnode *mdev,
>  					struct module *owner);
>  
>  /**
> + * media_devnode_start_unregister - start unregister on a media device node
> + * @mdev: the device node to start unregister
> + *
> + * This clears the MEDIA_FLAG_REGISTERED bit to indicate that unregister
> + * is in progress.
> + *
> + * This function can safely be called if the device node has never been
> + * registered or has already been unregistered.
> + *
> + * Zero is returned on success.
> + *
> + * -EINVAL is returned if the device node has never been
> + * registered or has already been unregistered.
> + */
> +int __must_check media_devnode_start_unregister(struct media_devnode *mdev);
> +
> +/**
>   * media_devnode_unregister - unregister a media device node
>   * @mdev: the device node to unregister
>   *
