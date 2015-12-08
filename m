From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Mon, 7 Dec 2015 18:40:15 -0800
Message-ID: <20151208024015.GA18458@infradead.org>
References: <20151113220143.GE2217@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151113220143.GE2217@birch.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, "Seymour, Shane M" <shane.seymour@hpe.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, "J. Bruce Fields" <bfields@fieldses.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 13, 2015 at 02:01:43PM -0800, Darrick J. Wong wrote:
> Create a new ioctl to expose the block layer's newfound ability to
> issue either a zeroing discard, a WRITE SAME with a zero page, or a
> regular write with the zero page.  This BLKZEROOUT2 ioctl takes
> {start, length, flags} as parameters.  So far, the only flag available
> is to enable the zeroing discard part -- without it, the call invokes
> the old BLKZEROOUT behavior.  start and length have the same meaning
> as in BLKZEROOUT.
> 
> Furthermore, because BLKZEROOUT2 issues commands directly to the
> storage device, we must invalidate the page cache (as a regular
> O_DIRECT write would do) to avoid returning stale cache contents at a
> later time.

So does BLKZEROOUT.  Seems like adding the cache invalidation should
be one patch and the ioctl another one.  Otherwise this looks fine
except that I kinda hate BLKZEROOUT2 name, but can't come up with
anything better.
