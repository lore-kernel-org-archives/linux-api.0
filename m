From: "Seymour, Shane M" <shane.seymour@hpe.com>
Subject: RE: [PATCH] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Wed, 11 Nov 2015 23:30:57 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB444D1AFC@G9W0766.americas.hpqcorp.net>
References: <20151110051526.GA2217@birch.djwong.org>
 <DDB9C85B850785449757F9914A034FCB444D1676@G9W0766.americas.hpqcorp.net>
 <20151111061435.GA32272@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151111061435.GA32272@birch.djwong.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, "J. Bruce Fields" <bfields@fieldses.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-api@vger.kernel.org

> I don't have a device large enough to test for signedness errors, since passing
> huge values for start and len never make it past the i_size_read check.
> However, I do see that I forgot to check the padding values, so I'll update that.

Then do you want to at least consider converting end to be of type loff_t to
match the type of value returned by i_get_size() and the type of the value
passed to truncate_inode_pages_range()? Then you only need one additional
check, something like:

/* Check for an overflow when adding start+len into end */
	if (start > (uint64_t)LLONG_MAX - len)
		return -EINVAL;

Looking at the maximum values if we have start=0 and
len=(uint64_t)LLONG_MAX we would still continue but
len=(uint64_t)LLONG_MAX+1 would return -EINVAL. Similarly for
start=(uint64_t)LLONG_MAX and len=0 it would continue
but start=(uint64_t)LLONG_MAX+1 would return -EINVAL and that 
should allow start + len to be safely added and stored into an loff_t without
overflow. With this check start+len can never be more than (uint64_t)LLONG_MAX
which would make the other checks I suggested to ensure that neither start or end
were more than (uint64_t)LLONG_MAX unnecessary.
