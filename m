From: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>
Subject: Re: [PATCH v2 1/6] virtio_balloon: transitional interface
Date: Wed, 01 Apr 2015 14:17:23 +1030
Message-ID: <87mw2sy0fo.fsf@rustcorp.com.au>
References: <1427831230-28044-1-git-send-email-mst@redhat.com> <1427831230-28044-2-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427831230-28044-2-git-send-email-mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

"Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
> Virtio 1.0 doesn't include a modern balloon device.
> But it's not a big change to support a transitional
> balloon device: this has the advantage of supporting
> existing drivers, transparently.

You decided to fix the packed struct...

> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 6a356e3..574267f 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -77,7 +77,7 @@ struct virtio_balloon {
>  
>  	/* Memory statistics */
>  	int need_stats_update;
> -	struct virtio_balloon_stat stats[VIRTIO_BALLOON_S_NR];
> +	struct virtio_balloon_stat_modern stats[VIRTIO_BALLOON_S_NR];
>  
>  	/* To register callback in oom notifier call chain */
>  	struct notifier_block nb;
> @@ -269,7 +269,11 @@ static void stats_handle_request(struct virtio_balloon *vb)
>  	vq = vb->stats_vq;
>  	if (!virtqueue_get_buf(vq, &len))
>  		return;
> -	sg_init_one(&sg, vb->stats, sizeof(vb->stats));
> +	if (virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
> +		sg_init_one(&sg, vb->stats, sizeof(vb->stats));
> +	else
> +		sg_init_one(&sg, &vb->stats->tag, sizeof(vb->stats) -
> +			    offsetof(typeof(*vb->stats, tag);

This makes it compile, but definitely won't work.

>  	virtqueue_add_outbuf(vq, &sg, 1, vb, GFP_KERNEL);
>  	virtqueue_kick(vq);
>  }
> @@ -283,21 +287,30 @@ static void virtballoon_changed(struct virtio_device *vdev)
>  
>  static inline s64 towards_target(struct virtio_balloon *vb)
>  {
> -	__le32 v;
>  	s64 target;
> +	u32 num_pages;
>  
> -	virtio_cread(vb->vdev, struct virtio_balloon_config, num_pages, &v);
> +	virtio_cread(vb->vdev, struct virtio_balloon_config,
> +		     num_pages, &num_pages);
>  
> -	target = le32_to_cpu(v);
> +	/* Legacy balloon config space is LE, unlike all other devices. */
> +	if (!virtio_has_feature(vb->vdev, VIRTIO_F_VERSION_1))
> +		num_pages = le32_to_cpu((__force le32)num_pages);
> +
> +	target = num_pages;
>  	return target - vb->num_pages;
>  }
>  
>  static void update_balloon_size(struct virtio_balloon *vb)
>  {
> -	__le32 actual = cpu_to_le32(vb->num_pages);
> +	u32 actual = vb->num_pages;
> +
> +	/* Legacy balloon config space is LE, unlike all other devices. */
> +	if (!virtio_has_feature(vb->vdev, VIRTIO_F_VERSION_1))
> +		actual = (__force u32)cpu_to_le32(num_pages);
>  
> -	virtio_cwrite(vb->vdev, struct virtio_balloon_config, actual,
> -		      &actual);
> +	virtio_cwrite(vb->vdev, struct virtio_balloon_config,
> +		      actual, &actual);
>  }

Final line is gratitous reformatting.

I would leave the device *exactly* as is, ugly structure packing and
all.

Cheers,
Rusty.
