From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RESEND] [PATCH] block: create ioctl to discard-or-zeroout a
 range of blocks
Date: Thu, 29 Jan 2015 11:01:02 -0800
Message-ID: <20150129190102.GF9981@birch.djwong.org>
References: <20150129020025.GE9981@birch.djwong.org>
 <2747023.BlTyJ4fNVf@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2747023.BlTyJ4fNVf@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 29, 2015 at 11:02:58AM +0100, Arnd Bergmann wrote:
> On Wednesday 28 January 2015 18:00:25 Darrick J. Wong wrote:
> > Create a new ioctl to expose the block layer's newfound ability to
> > issue either a zeroing discard, a WRITE SAME with a zero page, or a
> > regular write with the zero page.  This BLKZEROOUT2 ioctl takes
> > {start, length, flags} as parameters.  So far, the only flag available
> > is to enable the zeroing discard part -- without it, the call invokes
> > the old BLKZEROOUT behavior.  start and length have the same meaning
> > as in BLKZEROOUT.
> > 
> > Furthermore, because BLKZEROOUT2 issues commands directly to the
> > storage device, we must invalidate the page cache (as a regular
> > O_DIRECT write would do) to avoid returning stale cache contents at a
> > later time.
> > 
> > This patch depends on "block: Add discard flag to
> > blkdev_issue_zeroout() function" in Jens' for-3.20/core branch.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > 
> 
> Would this work ok for devices that fill discarded areas with all-ones
> instead of all-zeroes? I believe SD cards can do either.

It won't do all-ones, because the underlying blkdev_issue_zeroout call only
knows how to tell the device to write zeroes or perform a discard if the flag
is set and the device is whitelisted.  This patch only exposes the existing
kernel call to userspace.

(All-ones could be plumbed into the storage stack, but that would have to be a
separate patch.)

--D

> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
