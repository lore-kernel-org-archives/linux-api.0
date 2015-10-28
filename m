From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Persistent Reservation API V4
Date: Wed, 28 Oct 2015 14:43:56 -0400
Message-ID: <20151028184356.GA21933@redhat.com>
References: <1444911052-9423-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1444911052-9423-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Oct 15 2015 at  8:10am -0400,
Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:

> This series adds support for a simplified Persistent Reservation API
> to the block layer.  The intent is that both in-kernel and userspace
> consumers can use the API instead of having to hand craft SCSI or NVMe
> command through the various pass through interfaces.  It also adds
> DM support as getting reservations through dm-multipath is a major
> pain with the current scheme.
> 
> The ioctl API is documented in Documentation/block/pr.txt, but to
> fully understand the concept you'll have to read up the SPC spec,
> PRs are too complicated that trying to rephrase them into different
> terminology is just going to create confusion.
> 
> Note that Mike wants to include the DM patches so through the DM
> tree, so they are only included for reference.

I looked at these again and the DM changes look good.  Any update on
if/when the block changes will land?
