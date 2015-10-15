From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [dm-devel] [PATCH 3/6] sd: implement the Persistent
	Reservation API
Date: Thu, 15 Oct 2015 17:32:27 +0200
Message-ID: <20151015153227.GA3536@lst.de>
References: <1444911052-9423-1-git-send-email-hch@lst.de> <1444911052-9423-4-git-send-email-hch@lst.de> <561FC6AA.3080508@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <561FC6AA.3080508-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Oct 15, 2015 at 08:30:50AM -0700, Bart Van Assche wrote:
> Can you explain why this functionality has been added to the sd driver 
> instead of the SCSI core ? Aren't persistent reservations a concept that 
> applies to all SCSI device types ?

In theory it does.  In practice it's only used by disks/arrays and tapes,
and as tapes don't have a struct block_device this isn't going to be useful
for them.
