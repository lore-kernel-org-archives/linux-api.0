From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v4] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Mon, 7 Dec 2015 21:28:30 -0800
Message-ID: <20151208052830.GC10584@birch.djwong.org>
References: <20151113220143.GE2217@birch.djwong.org>
 <20151208024015.GA18458@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151208024015.GA18458@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, "Seymour, Shane M" <shane.seymour@hpe.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, "J. Bruce Fields" <bfields@fieldses.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-api@vger.kernel.org

On Mon, Dec 07, 2015 at 06:40:15PM -0800, Christoph Hellwig wrote:
> On Fri, Nov 13, 2015 at 02:01:43PM -0800, Darrick J. Wong wrote:
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
> 
> So does BLKZEROOUT.  Seems like adding the cache invalidation should
> be one patch and the ioctl another one.  Otherwise this looks fine
> except that I kinda hate BLKZEROOUT2 name, but can't come up with
> anything better.

I should've sent the 4.4 version -- since the ioctl code was refactored into
separate functions and the new function modifies its arguments, I ended up
rewriting most of the function body just to set up the page cache invalidation.

(Ah, I see -- 4.4-rc1 came out and I forgot to resend.)

Blergh, v5 on its way...

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
