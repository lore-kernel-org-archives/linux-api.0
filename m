From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/3] block: invalidate the page cache when issuing
 BLKZEROOUT.
Date: Tue, 15 Mar 2016 00:35:22 -0700
Message-ID: <20160315073522.GI11669@infradead.org>
References: <20160305005556.29738.66782.stgit@birch.djwong.org>
 <20160305005603.29738.58460.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160305005603.29738.58460.stgit-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shane.seymour-ZPxbGqLxI0U@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Mar 04, 2016 at 04:56:03PM -0800, Darrick J. Wong wrote:
> Invalidate the page cache (as a regular O_DIRECT write would do) to avoid
> returning stale cache contents at a later time.
> 
> v5: Refactor the 4.4 refactoring of the ioctl code into separate functions.
> Split the page invalidation and the new ioctl into separate patches.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Didn't I review this already?  If not:

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
