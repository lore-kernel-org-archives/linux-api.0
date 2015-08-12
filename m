From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/6] block: cleanup blkdev_ioctl
Date: Tue, 11 Aug 2015 20:29:55 -0400
Message-ID: <yq1y4hhe4cc.fsf@sermon.lab.mkp.net>
References: <1438672271-11309-1-git-send-email-hch@lst.de>
	<1438672271-11309-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438672271-11309-2-git-send-email-hch-jcswGhMUV9g@public.gmane.org> (Christoph
	Hellwig's message of "Tue, 4 Aug 2015 09:11:06 +0200")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> writes:

Christoph> Split out helpers for all non-trivial ioctls to make this
Christoph> function simpler, and also start passing around a pointer
Christoph> version of the argument, as that's what most ioctl handlers
Christoph> actually need.

Looks good.

Reviewed-by: Martin K. Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

-- 
Martin K. Petersen	Oracle Linux Engineering
