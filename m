From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 5/6] dm: split out a helper to find the ioctl target
Date: Thu, 6 Aug 2015 15:45:43 +0200
Message-ID: <20150806134543.GC1646@lst.de>
References: <1438672271-11309-1-git-send-email-hch@lst.de> <1438672271-11309-6-git-send-email-hch@lst.de> <20150804180558.GB28971@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150804180558.GB28971-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Aug 04, 2015 at 02:05:59PM -0400, Mike Snitzer wrote:
> static int dm_get_live_table_for_ioctl(struct mapped_device *md, int *srcu_idx,
> 	     struct dm_target **tgt, struct block_device **bdev, fmode_t *mode)
> 
> Otherwise, looks good.

I'll update it.
