From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v7 0/5] vfs: Non-blockling buffered fs read (page cache
 only)
Date: Fri, 27 Mar 2015 01:35:16 -0700
Message-ID: <20150327013516.8c6788be.akpm@linux-foundation.org>
References: <cover.1426528417.git.milosz@adfin.com>
	<20150326202824.65d03787.akpm@linux-foundation.org>
	<20150327081822.GA28669@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150327081822.GA28669-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-aio-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Volker Lendecke <Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 27 Mar 2015 01:18:22 -0700 Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> On Thu, Mar 26, 2015 at 08:28:24PM -0700, Andrew Morton wrote:
> > I still don't understand why pwritev() exists.  We discussed this last
> > time but it seems nothing has changed.  I'm not seeing here an adequate
> > description of why it exists nor a justification for its addition.
> 
> pwritev2?  I have patches to support per-I/O O_DSYNC with it, lots of
> folks including Samba and SCSI targets want this because their protocols
> support it.  The patches were posted with earlier versions of Miklos
> series.
> 
> It's cleaner to add the two system calls in go when we plan using them
> anyway and have symmetric infrastructure, and I did not hear any
> disagreement with that on LSF.  Did you skip this session?

Put it in the changelogs.  All of it.  A conference discussion
is no use to people who weren't there.

> > And (again) we've discussed this before, but the patchset gets resent
> > as if nothing had happened.
> 
> We had long discussiosn about it both here and at LSF.  We had everyone
> agree and nod there, and only your repeated argument here, so maybe it's
> not Miklos who is disonnected but you?

I don't find conferences to be a good place to conduct code and design
review.

> Also that whole fincore argument is rather hypothetic - it's only been
> pushed in to ugly to live multiplexers that also expose things like
> pfns,  while with preadv2 we have a trivial and easy to use API read to
> merge, and various consumerms just waiting for it.

fincore() doesn't have to be ugly.  Please address the design issues I
raised.  How is pread2() useful to the class of applications which
cannot proceed until all data is available?
