From: "Seymour, Shane M" <shane.seymour@hpe.com>
Subject: RE: [PATCH v4] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Mon, 16 Nov 2015 22:56:29 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB444D32C8@G9W0766.americas.hpqcorp.net>
References: <20151113220143.GE2217@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20151113220143.GE2217@birch.djwong.org>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, "J. Bruce Fields" <bfields@fieldses.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-api@vger.kernel.org


> v4: Check the start/len arguments for overflows prior to feeding the page
>     cache bogus numbers (that it'll ignore anyway).

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Shane Seymour <shane.seymour@hpe.com>
