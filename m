From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: O_DIRECT as a hint, was: Re: [PATCH] ext4: refuse O_DIRECT opens
 for mode where DIO doesn't work
Date: Tue, 26 Apr 2016 22:16:49 -0400
Message-ID: <20160427021649.GA30021@thunk.org>
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
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Dmitry Monakhov <dmonlist-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ext4 Developers List <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Apr 26, 2016 at 01:14:51AM -0700, Christoph Hellwig wrote:
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

That's fine with me, but there ought to be some way for a program to
query whether a particular file / file system is one where DIO is
supported, and if so, what the alignment requirements would be.  That
way applications who care can get the information they need (and we
can use it for xfstests's _require_odirect :-).

						- Ted
