From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/6] dm: split out a helper to find the ioctl target
Date: Tue, 4 Aug 2015 14:05:59 -0400
Message-ID: <20150804180558.GB28971@redhat.com>
References: <1438672271-11309-1-git-send-email-hch@lst.de>
 <1438672271-11309-6-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1438672271-11309-6-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Aug 04 2015 at  3:11am -0400,
Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:

> We want to reuse this code for the persistent reservation handling,
> so move it into a helper.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  drivers/md/dm.c | 50 ++++++++++++++++++++++++++++++++------------------
>  1 file changed, 32 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index c68eb91..8dfc760 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -556,18 +556,16 @@ static int dm_blk_getgeo(struct block_device *bdev, struct hd_geometry *geo)
>  	return dm_get_geometry(md, geo);
>  }
>  
> -static int dm_blk_ioctl(struct block_device *bdev, fmode_t mode,
> -			unsigned int cmd, unsigned long arg)
> +static int dm_get_ioctl_table(struct mapped_device *md,
> +		struct dm_target **tgt, struct block_device **bdev,
> +		fmode_t *mode, int *srcu_idx)

Would prefer to see something like:

static int dm_get_live_table_for_ioctl(struct mapped_device *md, int *srcu_idx,
	     struct dm_target **tgt, struct block_device **bdev, fmode_t *mode)

Otherwise, looks good.
