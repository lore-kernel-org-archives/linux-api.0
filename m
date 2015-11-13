From: "Seymour, Shane M" <shane.seymour@hpe.com>
Subject: RE: [PATCH] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Fri, 13 Nov 2015 03:36:21 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB444D242C@G9W0766.americas.hpqcorp.net>
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

If you have someone trying to bypass your sanity checks then if start=18446744073709551104 and len=1024 the result of adding them together will be 512 (subtracting an extra 1 in the patched code to get 511 for end). That will pass the i_size_read check won't it? If so that would cause lstart in truncate_inode_pages_range() to be -512. I don't know what truncate_inode_pages_range() will do with a negative lstart value like that but it seems like an unusual value for your code to be willing to pass into truncate_inode_pages_range().

Shane
