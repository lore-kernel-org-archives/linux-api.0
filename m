From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH v2 14/22] media: au0828 change to use Managed Media
 Controller API
Date: Thu, 4 Feb 2016 08:05:00 -0200
Message-ID: <20160204080500.5c5eaa90@recife.lan>
References: <cover.1454557589.git.shuahkh@osg.samsung.com>
	<94d3a1146cea1999dea2a7a55c18f848897f4e6d.1454557589.git.shuahkh@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <94d3a1146cea1999dea2a7a55c18f848897f4e6d.1454557589.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittga
List-Id: linux-api@vger.kernel.org

Em Wed, 03 Feb 2016 21:03:46 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> Change au0828 to use Managed Media Controller API to
> share media device and coordinate creating/deleting
> the shared media device with the snd-usb-audio driver.
> The shared media device is created as device resource
> of the parent usb device of the two drivers.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  drivers/media/usb/au0828/au0828-core.c | 29 +++++++++++++++--------------
>  1 file changed, 15 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
> index df2bc3f..b8c4bdd 100644
> --- a/drivers/media/usb/au0828/au0828-core.c
> +++ b/drivers/media/usb/au0828/au0828-core.c
> @@ -134,10 +134,10 @@ static void au0828_unregister_media_device(struct au0828_dev *dev)
>  {
>  
>  #ifdef CONFIG_MEDIA_CONTROLLER
> -	if (dev->media_dev) {
> +	if (dev->media_dev &&
> +		media_devnode_is_registered(&dev->media_dev->devnode)) {
>  		media_device_unregister(dev->media_dev);
>  		media_device_cleanup(dev->media_dev);
> -		kfree(dev->media_dev);
>  		dev->media_dev = NULL;
>  	}
>  #endif
> @@ -223,23 +223,24 @@ static int au0828_media_device_init(struct au0828_dev *dev,
>  #ifdef CONFIG_MEDIA_CONTROLLER
>  	struct media_device *mdev;
>  
> -	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
> +	mdev = media_device_get_devres(&udev->dev);
>  	if (!mdev)
>  		return -ENOMEM;
>  
> -	mdev->dev = &udev->dev;
> +	if (!media_devnode_is_registered(&mdev->devnode)) {
> +		mdev->dev = &udev->dev;
>  
> -	if (!dev->board.name)
> -		strlcpy(mdev->model, "unknown au0828", sizeof(mdev->model));
> -	else
> -		strlcpy(mdev->model, dev->board.name, sizeof(mdev->model));
> -	if (udev->serial)
> -		strlcpy(mdev->serial, udev->serial, sizeof(mdev->serial));
> -	strcpy(mdev->bus_info, udev->devpath);
> -	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
> -	mdev->driver_version = LINUX_VERSION_CODE;
> +		if (udev->product)
> +			strlcpy(mdev->model, udev->product,
> +				sizeof(mdev->model));

Why did you change that? On some boards, udev->product doesn't reflect
the brand name, but have just some random generic data.

Also, as the other logs associated with the device uses dev->board.name,
we want the media controller to use the same name here. Ok, if this
is null, we could use udev->product as a replacement.

> +		if (udev->serial)
> +			strlcpy(mdev->serial, udev->serial,
> +				sizeof(mdev->serial));
> +		strcpy(mdev->bus_info, udev->devpath);
> +		mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
>  
> -	media_device_init(mdev);
> +		media_device_init(mdev);
> +	}
>  
>  	dev->media_dev = mdev;
>  #endif
