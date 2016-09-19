From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH 4/6] fs: add iomap_file_dirty
Date: Mon, 19 Sep 2016 10:11:44 +1000
Message-ID: <20160919001143.GU30497@dastard>
References: <147216784041.525.7722906502172299465.stgit@birch.djwong.org>
 <147216786712.525.5901639662288553230.stgit@birch.djwong.org>
 <20160905145751.GC7662@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160905145751.GC7662-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Sep 05, 2016 at 07:57:51AM -0700, Christoph Hellwig wrote:
> On Thu, Aug 25, 2016 at 04:31:07PM -0700, Christoph Hellwig wrote:
> > Originally-from: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> 
> This should be a
> 
> From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> 
> so that git picks up authorship information correctly.
> 
> > XXX: might want a bigger name, and possible a better implementation
> > that doesn't require two lookups in the radix tree.
> 
> And these need to be looked into.  I can take a stab at it, but I need
> to get a few other things off my plate first.

Seeing as it works and isn't too ugly to live, I think I'm going to
merge this as is. When a better implementation comes along we
can replace it with that...

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
