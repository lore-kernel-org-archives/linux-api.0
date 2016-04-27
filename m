From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: O_DIRECT as a hint, was: Re: [PATCH] ext4: refuse O_DIRECT opens
 for mode where DIO doesn't work
Date: Wed, 27 Apr 2016 13:37:46 +1000
Message-ID: <20160427033746.GL18496@dastard>
References: <1461472078-20104-1-git-send-email-tytso@mit.edu>
 <877ffmhvzt.fsf@openvz.org>
 <20160425234946.GB26977@dastard>
 <20160426081451.GA25616@infradead.org>
 <20160427022746.GJ18496@dastard>
 <20160427032526.GC30021@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160427032526.GC30021-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Dmitry Monakhov <dmonlist-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ext4 Developers List <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Apr 26, 2016 at 11:25:26PM -0400, Theodore Ts'o wrote:
> On Wed, Apr 27, 2016 at 12:27:46PM +1000, Dave Chinner wrote:
> > > At this point I wonder if we should simply treat O_DIRECT as a hint
> > > and always allow it, and just let the file system optimize for it
> > > (skip buffering, require alignment, relaxed Posix atomicy requirements)
> > > if it is set.
> > 
> > I thought that's how most filesystems treated it, anyway. i.e.
> > anything they can't do via direct IO, they fell back to buffered IO
> > to complete (e.g. for allocation or append writes, etc). Hence why I
> > suggested the fallback rather than erroring out....
> 
> No, some file systems return EINVAL on the open.  In fact that's what
> the _require_odirect test in xfstests relies upon....

Sure, but that doesn't change the fact that many of the filesystems
that "support O_DIRECT" don't always do O_DIRECT - they
transparently do buffered IO instead and hence are treating O_DIRECT
as a hint once the file has been opened.

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
