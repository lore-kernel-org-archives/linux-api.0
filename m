From: "Seymour, Shane M" <shane.seymour@hpe.com>
Subject: RE: [PATCH] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Wed, 11 Nov 2015 05:30:07 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB444D1676@G9W0766.americas.hpqcorp.net>
References: <20151110051526.GA2217@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20151110051526.GA2217@birch.djwong.org>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, "J. Bruce Fields" <bfields@fieldses.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-api@vger.kernel.org

A quick question about this part of the patch:

> +	uint64_t end = start + len - 1;

> +	if (end >= i_size_read(bdev->bd_inode))
 		return -EINVAL;
 
> +	/* Invalidate the page cache, including dirty pages */
> +	mapping = bdev->bd_inode->i_mapping;
> +	truncate_inode_pages_range(mapping, start, end);

blk_ioctl_zeroout accepts unsigned values for start and end (uint64_t) but loff_t types are turned from i_size_read() and passed as the 2nd and 3rd values to truncate_inode_pages_range() and loff_t is a signed value. It should be possible to pass in some values would overflow the calculation of end causing the test on the value of end and the result of i_size_read to pass but then end up passing a large unsigned value for in start that would be implicitly converted to signed in truncate_inode_pages_range. I was wondering if you'd tested passing in data that would cause sign conversion issues when passed into truncate_inode_pages_range (does it handle it gracefully?) or should this code:

	if (start & 511)
 		return -EINVAL;
 	if (len & 511)
 		return -EINVAL;

be something more like this (for better sanity checking of your arguments) which will ensure that you don't have implicit conversion issues from unsigned to signed and ensure that the result of adding them together won't either:

	if ((start & 511) || (start > (uint64_t)LLONG_MAX))
 		return -EINVAL;
 	if ((len & 511) ) || (len > (uint64_t)LLONG_MAX))
 		return -EINVAL;
	if (end > (uint64_t)LLONG_MAX)
		return -EINVAL;

My apologies in advance if I've made a mistake when looking at this and my concerns about unsigned values being implicitly converted to signed are unfounded (I would have hoped for compiler warnings about any implicit conversions though).

Thanks
Shane
