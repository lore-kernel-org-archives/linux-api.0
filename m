From: "Seymour, Shane M" <shane.seymour@hpe.com>
Subject: RE: [PATCH] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Thu, 12 Nov 2015 00:56:02 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB444D1C18@G9W0766.americas.hpqcorp.net>
References: <20151110051526.GA2217@birch.djwong.org>
 <DDB9C85B850785449757F9914A034FCB444D1676@G9W0766.americas.hpqcorp.net>
 <20151111061435.GA32272@birch.djwong.org>
 <DDB9C85B850785449757F9914A034FCB444D1AFC@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <DDB9C85B850785449757F9914A034FCB444D1AFC@G9W0766.americas.hpqcorp.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, "J. Bruce Fields" <bfields@fieldses.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-api@vger.kernel.org

> which would make the other checks I suggested to ensure that neither start
> or end were more than (uint64_t)LLONG_MAX unnecessary.

My apologies I was wrong about what I said above - after thinking about it for longer you still need to make sure that at least len is not greater than (uint64_t)LLONG_MAX because in the calculation:

	if (start > (uint64_t)LLONG_MAX - len)
		return -EINVAL;

if len was more than (uint64_t)LLONG_MAX it would underflow and become a very large positive number and start would never be greater than that (and I said end when I should have said len).
