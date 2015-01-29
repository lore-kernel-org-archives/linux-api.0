From: "Elliott, Robert (Server Storage)" <Elliott-VXdhtT5mjnY@public.gmane.org>
Subject: RE: [RESEND] [PATCH] block: create ioctl to discard-or-zeroout a
 range of blocks
Date: Thu, 29 Jan 2015 16:28:13 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295A764B84@G9W0745.americas.hpqcorp.net>
References: <20150129020025.GE9981@birch.djwong.org>
 <2747023.BlTyJ4fNVf@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2747023.BlTyJ4fNVf@wuerfel>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
List-Id: linux-api@vger.kernel.org



> -----Original Message-----
> From: linux-kernel-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-kernel-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Arnd Bergmann
> Sent: Thursday, 29 January, 2015 4:03 AM
> To: Darrick J. Wong
> Cc: Jens Axboe; Christoph Hellwig; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-
> fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Jeff Layton; J. Bruce
> Fields
> Subject: Re: [RESEND] [PATCH] block: create ioctl to discard-or-zeroout a
> range of blocks
> 
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
> 
> 	Arnd

RAID software stacks need predictable data, and 0 is a lot easier to
deal with than 0xff in Galois field (XOR-based) math.

The SCSI and ATA standards both define bits to report if the device is
designed to return 0 after discard; they don't have a way to report
that any other particular non-zero value is returned.

---
Rob Elliott    HP Server Storage
