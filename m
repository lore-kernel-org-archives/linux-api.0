From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v7 0/5] vfs: Non-blockling buffered fs read (page cache
 only)
Date: Fri, 27 Mar 2015 09:30:46 -0700
Message-ID: <20150327093046.53c2769a.akpm@linux-foundation.org>
References: <cover.1426528417.git.milosz@adfin.com>
	<20150326202824.65d03787.akpm@linux-foundation.org>
	<20150327081822.GA28669@infradead.org>
	<20150327013516.8c6788be.akpm@linux-foundation.org>
	<20150327084833.GA7689@infradead.org>
	<20150327020159.eadd0ce1.akpm@linux-foundation.org>
	<20150327155854.GA5548@samba2>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150327155854.GA5548@samba2>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-aio-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Volker Lendecke <Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 27 Mar 2015 08:58:54 -0700 Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> On Fri, Mar 27, 2015 at 02:01:59AM -0700, Andrew Morton wrote:
> > On Fri, 27 Mar 2015 01:48:33 -0700 Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> > 
> > > On Fri, Mar 27, 2015 at 01:35:16AM -0700, Andrew Morton wrote:
> > > > fincore() doesn't have to be ugly.  Please address the design issues I
> > > > raised.  How is pread2() useful to the class of applications which
> > > > cannot proceed until all data is available?
> > > 
> > > It actually makes them work correctly?  preadv2( ..., DONTWAIT) will
> > > return -EGAIN, which causes them to bounce to the threadpool where
> > > they call preadv(...).
> > 
> > (I assume you mean RWF_NONBLOCK)
> > 
> > That isn't how pread2() works.  If the leading one or more pages are
> > uptodate, pread2() will return a partial read.  Now what?  Either the
> > application reads the same data a second time via the worker thread
> > (dumb, but it will usually be a rare case)
> 
> The problem with the above is that we can't tell the difference
> between pread2() returning a short read because the pages are not
> in cache, or because someone truncated the file. So we need some
> way to differentiate this.
> 
> My preference from userspace would be for pread2() to return
> EAGAIN if *all* the data requested is not available (where
> 'all' can be less than the size requested if the file has
> been truncated in the meantime).
> 
> ...
> 
> The thing I want to avoid is the case where
> ret < size_wanted means only part of the file
> is in cache.

>From my reading of the code, pread2() will return -EAGAIN only when it
copied zero bytes to userspace.  ie, the very first page wasn't in
cache.  If pread2() does copy some data to userspace then it will
return the amount of data copied.  This is traditional read()
behaviour.

Maybe there's some other code somewhere in the patch which converts
that short read into -EAGAIN, dunno - the changelogs don't appear to
mention it and the manpage update is ambiguous about this.

But from an interface perspective the behaviour you're asking for is
insane, frankly - if the kernel copied out 8k of data then pread2()
should return 8k.  Otherwise there's no way for userspace to know that
the 8k copy actually happened and we have just wasted a great pile of
CPU doing a pointless memcpy.

I expect that this situation (first part in cache, latter part not in
cache) is rare - for reasonably small requests the common cases will be
"all cached" and "nothing cached".  So perhaps the best approach here
is for samba to add special handling for the short read, to work out
the reason for its occurrence.

Alternatively we could add another flag to pread2() to select this
"throw away my data and return -EAGAIN" behaviour.  Presumably
implemented with an i_size check, but it's gonna be racy.



I take it from your comments that nobody has actually wired up pread2()
into samba yet?  That's a bit disturbing, because if we later want to
go and change something like this short-read behaviour, we're screwed -
it's a non back-compat userspace-visible change.


And a note on cosmetics: why are we using EAGAIN here rather than
EWOULDBLOCK?  They have the same numerical value, but EWOULDBLOCK is a
better name - EAGAIN says "run it again", but that won't work.
