From: Cornelia Huck <cornelia.huck-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC v3 09/16] virtio: set FEATURES_OK
Date: Thu, 23 Oct 2014 14:28:08 +0200
Message-ID: <20141023142808.377551d8.cornelia.huck@de.ibm.com>
References: <1414003404-505-1-git-send-email-mst@redhat.com>
	<1414003404-505-10-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414003404-505-10-git-send-email-mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 22 Oct 2014 21:44:44 +0300
"Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> set FEATURES_OK as per virtio 1.0 spec
> 
> Signed-off-by: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  include/uapi/linux/virtio_config.h |  2 ++
>  drivers/virtio/virtio.c            | 29 ++++++++++++++++++++++-------
>  2 files changed, 24 insertions(+), 7 deletions(-)
> 

>  	dev->config->finalize_features(dev);
> 
> +	if (virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
> +		add_status(dev, VIRTIO_CONFIG_S_FEATURES_OK);
> +		status = dev->config->get_status(dev);
> +		if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
> +			printk(KERN_ERR "virtio: device refuses features: %x\n",
> +			       status);
> +			err = -ENODEV;
> +			goto err;
> +		}
> +	}
> +

Ugh, I just realize that virtio-ccw has a problem with that mechanism :(

Up to now, the driver only propagated status to the device: For
virtio-ccw, this was easily implemented via a ccw that transmitted
"status" to the device. However, the "read back status" part now
actually requires that the driver can get "status" from the device, or
has a comparable way to find out that the device won't accept the
status it tried to write.

I can think of two solutions:

(1) Introduce a new ccw that actually reads the device status.
(2) Make the WRITE_STATUS ccw fail (with a unit check) if the driver
    sets FEATURES_OK after it tried to set features the device won't
    accept.

(1) is probably more generic, while (2) is more straightforward to
implement.

Good thing we actually try to finally implement this, I did not notice
this problem during the review :(
