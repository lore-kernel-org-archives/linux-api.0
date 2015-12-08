From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4] block: create ioctl to discard-or-zeroout a range of blocks
Date: Mon, 07 Dec 2015 20:16:37 -0500
Message-ID: <yq1io497n9m.fsf@sermon.lab.mkp.net>
References: <20151113220143.GE2217@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151113220143.GE2217-PTl6brltDGh4DFYR7WNSRA@public.gmane.org> (Darrick J. Wong's
	message of "Fri, 13 Nov 2015 14:01:43 -0800")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Seymour, Shane M" <shane.seymour-ZPxbGqLxI0U@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api@vger.kernel.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, "martin.petersen@oracle.com" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

>>>>> "Darrick" == Darrick J Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> writes:

Darrick> Create a new ioctl to expose the block layer's newfound ability
Darrick> to issue either a zeroing discard, a WRITE SAME with a zero
Darrick> page, or a regular write with the zero page.  This BLKZEROOUT2
Darrick> ioctl takes {start, length, flags} as parameters.  So far, the
Darrick> only flag available is to enable the zeroing discard part --
Darrick> without it, the call invokes the old BLKZEROOUT behavior.
Darrick> start and length have the same meaning as in BLKZEROOUT.

Darrick> Furthermore, because BLKZEROOUT2 issues commands directly to
Darrick> the storage device, we must invalidate the page cache (as a
Darrick> regular O_DIRECT write would do) to avoid returning stale cache
Darrick> contents at a later time.

Jens? Christoph?

-- 
Martin K. Petersen	Oracle Linux Engineering
