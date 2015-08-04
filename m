From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/6] dm: refactor ioctl handling
Date: Tue, 4 Aug 2015 13:56:16 -0400
Message-ID: <20150804175616.GA28971@redhat.com>
References: <1438672271-11309-1-git-send-email-hch@lst.de>
 <1438672271-11309-5-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1438672271-11309-5-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Aug 04 2015 at  3:11am -0400,
Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:

> This moves the call to blkdev_ioctl and the argument checking to core code,
> and only leaves a callout to find the block device to operate on it the
> targets.  This will simplifies the code and will allow us to pass through
> ioctl-like command using other methods in the next patch.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
...
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index f331d88..c68eb91 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -584,7 +584,17 @@ retry:
>  		goto out;
>  	}
>  
> -	r = tgt->type->ioctl(tgt, cmd, arg);
> +	r = tgt->type->ioctl(tgt, &bdev, &mode);
> +	if (r < 0)
> +		goto out;
> +
> +	if (r > 0) {
> +		r = scsi_verify_blk_ioctl(NULL, cmd);
> +		if (r)
> +			goto out;
> +	}
> +
> +	r =  __blkdev_driver_ioctl(bdev, mode, cmd, arg);
>  
>  out:
>  	dm_put_live_table(md, srcu_idx);
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index 51cc1de..9b73138 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -79,8 +79,8 @@ typedef void (*dm_status_fn) (struct dm_target *ti, status_type_t status_type,
>  
>  typedef int (*dm_message_fn) (struct dm_target *ti, unsigned argc, char **argv);
>  
> -typedef int (*dm_ioctl_fn) (struct dm_target *ti, unsigned int cmd,
> -			    unsigned long arg);
> +typedef int (*dm_ioctl_fn) (struct dm_target *ti,
> +			    struct block_device **bdev, fmode_t *mode);
>  
>  typedef int (*dm_merge_fn) (struct dm_target *ti, struct bvec_merge_data *bvm,
>  			    struct bio_vec *biovec, int max_size);

This should be renamed to dm_prepare_ioctl_fn and the targets' hook
would be .prepare_ioctl

Open to other names but if the targets no longer issue the ioctl there
is little point to call it .ioctl
