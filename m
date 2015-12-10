From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 2/2] block: create ioctl to discard-or-zeroout a range of blocks
Date: Thu, 10 Dec 2015 12:38:18 -0500
Message-ID: <yq1y4d22ohh.fsf@sermon.lab.mkp.net>
References: <20151208062104.21427.91134.stgit@birch.djwong.org>
	<20151208062111.21427.30921.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151208062111.21427.30921.stgit-PTl6brltDGh4DFYR7WNSRA@public.gmane.org> (Darrick
	J. Wong's message of "Mon, 07 Dec 2015 22:21:11 -0800")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shane.seymour-ZPxbGqLxI0U@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

>>>>> "Darrick" == Darrick J Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> writes:

Darrick> Create a new ioctl to expose the block layer's newfound ability
Darrick> to issue either a zeroing discard, a WRITE SAME with a zero
Darrick> page, or a regular write with the zero page.  This BLKZEROOUT2
Darrick> ioctl takes {start, length, flags} as parameters.  So far, the
Darrick> only flag available is to enable the zeroing discard part --
Darrick> without it, the call invokes the old BLKZEROOUT behavior.
Darrick> start and length have the same meaning as in BLKZEROOUT.

Darrick> This new ioctl also invalidates the page cache correctly on
Darrick> account of the previous patch in the series.

Reviewed-by: Martin K. Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

-- 
Martin K. Petersen	Oracle Linux Engineering
