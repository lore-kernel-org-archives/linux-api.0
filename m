From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RESEND] [PATCH] block: create ioctl to discard-or-zeroout a range of blocks
Date: Thu, 29 Jan 2015 11:02:58 +0100
Message-ID: <2747023.BlTyJ4fNVf@wuerfel>
References: <20150129020025.GE9981@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150129020025.GE9981@birch.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, "J. Bruce Fields" <bfields@fieldses.org>
List-Id: linux-api@vger.kernel.org

On Wednesday 28 January 2015 18:00:25 Darrick J. Wong wrote:
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
> 
> This patch depends on "block: Add discard flag to
> blkdev_issue_zeroout() function" in Jens' for-3.20/core branch.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 

Would this work ok for devices that fill discarded areas with all-ones
instead of all-zeroes? I believe SD cards can do either.

	Arnd
