From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v5.1 0/2] create BLKZEROOUT ioctl that invalidates page
 cache
Date: Wed, 2 Mar 2016 01:44:16 -0800
Message-ID: <20160302094416.GA16631@infradead.org>
References: <20160302040932.16685.62789.stgit@birch.djwong.org>
 <1889689.0axyUkdxkf@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1889689.0axyUkdxkf@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shane.seymour-ZPxbGqLxI0U@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 02, 2016 at 10:15:02AM +0100, Arnd Bergmann wrote:
> I'm missing the background on this, just saw the patch fly by,
> so sorry if this has been asked before:
> 
> Why do you want to invalidate the cache? Is this to save RAM
> or is something else going to write here and you have to invalidate
> it for correctness?

BLKZEROOUT can be though as a direct I/O operation - it issues a 
WRITE SAME (or similar) command straight to the device to zero
the specified range.  If there was cached data for this range it would
now be stale.
