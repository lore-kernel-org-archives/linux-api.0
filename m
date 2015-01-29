From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RESEND] [PATCH] block: create ioctl to discard-or-zeroout a range of blocks
Date: Thu, 29 Jan 2015 23:19:11 +0100
Message-ID: <6288705.r5DnSskuxD@wuerfel>
References: <20150129020025.GE9981@birch.djwong.org> <2747023.BlTyJ4fNVf@wuerfel> <20150129190102.GF9981@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150129190102.GF9981@birch.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, "J. Bruce Fields" <bfields@fieldses.org>
List-Id: linux-api@vger.kernel.org

On Thursday 29 January 2015 11:01:02 Darrick J. Wong wrote:
> It won't do all-ones, because the underlying blkdev_issue_zeroout call only
> knows how to tell the device to write zeroes or perform a discard if the flag
> is set and the device is whitelisted.  This patch only exposes the existing
> kernel call to userspace.
>
> (All-ones could be plumbed into the storage stack, but that would have to be a
> separate patch.)

I see. I've just checked the code in the mmc core and it seems to
get the correct information for both mmc and sd devices (they use
different bits to announce the feature).

So as long as the devices follow the spec, everything is fine here.

Thanks Darrick and Robert for the quick reply!

	Arnd
