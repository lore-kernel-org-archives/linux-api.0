From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH 5/8] nowait aio: return on congested block device
Date: Fri, 17 Mar 2017 08:31:34 +1100
Message-ID: <20170316213134.GV17542@dastard>
References: <20170315215107.5628-1-rgoldwyn@suse.de>
 <20170315215107.5628-6-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170315215107.5628-6-rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-IBi9RG/b67k@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 15, 2017 at 04:51:04PM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
> 
> A new flag BIO_NOWAIT is introduced to identify bio's
> orignating from iocb with IOCB_NOWAIT. This flag indicates
> to return immediately if a request cannot be made instead
> of retrying.

So this makes a congested block device run the bio IO completion
callback with an -EAGAIN error present? Are all the filesystem
direct IO submission and completion routines OK with that? i.e. does
such a congestion case cause filesystems to temporarily expose stale
data to unprivileged users when the IO is requeued in this way?

e.g. filesystem does allocation without blocking, submits bio,
device is congested, runs IO completion with error, so nothing
written to allocated blocks, write gets queued, so other read
comes in while the write is queued, reads data from uninitialised
blocks that were allocated during the write....

Seems kinda problematic to me to have a undocumented design
constraint (i.e a landmine) where we submit the AIO only to have it
error out and then expect the filesystem to do something special and
different /without blocking/ on EAGAIN.

Why isn't the congestion check at a higher layer like we do for page
cache readahead? i.e. using the bdi*congested() API at the time we
are doing all the other filesystem blocking checks.

-Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
