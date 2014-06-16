From: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>
Subject: Re: [RFC PATCH 2/2] block: virtio-blk: support multi virt queues per virtio-blk device
Date: Mon, 16 Jun 2014 22:17:05 +0930
Message-ID: <877g4hnhrq.fsf@rustcorp.com.au>
References: <1402680562-8328-1-git-send-email-ming.lei@canonical.com> <1402680562-8328-3-git-send-email-ming.lei@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1402680562-8328-3-git-send-email-ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Stefan Hajnoczi <stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> writes:
> +	if (virtio_has_feature(vdev, VIRTIO_BLK_F_MQ))
> +		err = virtio_cread_feature(vdev, VIRTIO_BLK_F_MQ,
> +				   struct virtio_blk_config, num_queues,
> +				   &num_vqs);
> +	else
> +		num_vqs = 1;

This is redundant: virtio_cread_feature() checks the feature.

So, either:
        if (virtio_has_feature(vdev, VIRTIO_BLK_F_MQ))
                virtio_cread(vdev, struct virtio_blk_config, num_queues,
          		     &num_vqs);
        else
                num_vqs = 1;

Or:
	err = virtio_cread_feature(vdev, VIRTIO_BLK_F_MQ,
			   struct virtio_blk_config, num_queues,
			   &num_vqs);
        if (err)
                num_vqs = 1;

Otherwise, the patch looks pretty straight-forward.

Cheers,
Rusty.
