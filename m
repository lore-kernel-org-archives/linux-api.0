From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: O_DIRECT as a hint, was: Re: [PATCH] ext4: refuse O_DIRECT opens
 for mode where DIO doesn't work
Date: Wed, 27 Apr 2016 12:27:46 +1000
Message-ID: <20160427022746.GJ18496@dastard>
References: <1461472078-20104-1-git-send-email-tytso@mit.edu>
 <877ffmhvzt.fsf@openvz.org>
 <20160425234946.GB26977@dastard>
 <20160426081451.GA25616@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160426081451.GA25616-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Dmitry Monakhov <dmonlist-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Ext4 Developers List <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Apr 26, 2016 at 01:14:51AM -0700, Christoph Hellwig wrote:
> On Tue, Apr 26, 2016 at 09:49:46AM +1000, Dave Chinner wrote:
> > Why not just transparently fall back to buffered IO if direct IO
> > cannot be done? Saves people from wondering why applications fail
> > on one ext4 filesystem and not another....
> 
> I've been doing an audit of our direct I/O implementations, and most
> of them does some form of transparent fallback, including some that
> only pretend to support O_DIRECT, but do anything special for it at all,
> while at the same time we go through greast efforts to check a file
> system actualy supports direct I/O, leading to nasty no-op ->direct_IO
> implementations as we even got that abstraction wrong.
> 
> At this point I wonder if we should simply treat O_DIRECT as a hint
> and always allow it, and just let the file system optimize for it
> (skip buffering, require alignment, relaxed Posix atomicy requirements)
> if it is set.

I thought that's how most filesystems treated it, anyway. i.e.
anything they can't do via direct IO, they fell back to buffered IO
to complete (e.g. for allocation or append writes, etc). Hence why I
suggested the fallback rather than erroring out....

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
