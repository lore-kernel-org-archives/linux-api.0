From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v7 0/5] vfs: Non-blockling buffered fs read (page cache
 only)
Date: Mon, 30 Mar 2015 15:50:33 -0700
Message-ID: <20150330155033.2cdc8d9a4a2c4ecf6a9ad154@linux-foundation.org>
References: <cover.1426528417.git.milosz@adfin.com>
	<20150326202824.65d03787.akpm@linux-foundation.org>
	<CANP1eJEbDusq_Gda35dGKiacC+2tbvb_bQEEHpi6PmgnNoWDFw@mail.gmail.com>
	<20150327100411.6823b9d7.akpm@linux-foundation.org>
	<20150330074020.GC22229@infradead.org>
	<20150330115414.f7900c7062fe6370cb2aea8d@linux-foundation.org>
	<CANP1eJH4BcZ0vgZ6pZdKOd4orEzfKUqjpKXb3m=WMy0mbK+PFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANP1eJH4BcZ0vgZ6pZdKOd4orEzfKUqjpKXb3m=WMy0mbK+PFA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-aio-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-aio-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Volker Lendecke <Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, 30 Mar 2015 18:40:16 -0400 Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org> wrote:

> On Mon, Mar 30, 2015 at 2:54 PM, Andrew Morton
> <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> > On Mon, 30 Mar 2015 00:40:20 -0700 Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> >
> >> On Fri, Mar 27, 2015 at 10:04:11AM -0700, Andrew Morton wrote:
> >> > mm...  I don't think we should be adding placeholders to the kernel API
> >> > to support code which hasn't been written, tested, reviewed, merged,
> >> > etc.  It's possible none of this will ever happen and we end up with a
> >> > syscall nobody needs or uses.  Plus it's always possible that during
> >> > this development we decide the pwrite2() interface needs alteration but
> >> > it's too late.
> >> >
> >> > What would be the downside of deferring pwrite2() until it's all
> >> > implemented?
> >>
> >> It _is_ implemented.  I just decided to submit it separately as Miklos
> >> already has to deal with enough bikeshedding for his feature that I
> >> don't want to put the burden of dealing with the BS for the one I wrote
> >> on him.
> >
> > afacit the only difference between this pwritev2() and the existing
> > pwritev() is that pwritev2() interprets pos==-1 as "current position",
> > which duplicates writev()?
> >
> > Unless I've missed something, there's no point in merging this
> > pwritev2() and it would be better to separate this syscall out into a
> > pwritev2() patchset which can be considered and merged separately.  For
> > the reasons described above.
> >
> 
> At the LSF/MM session, the agreement form the active participants
> (James Bottomley, Ted Tso, Christoph, and I forget the last guy's
> name) that we should ship both syscalls in the first patch.

I was over in the mm session and probably wouldn't have objected either
because because you can't sit down, think, carefully inspect code and
evaluate arguments in such a context.

I've explained my reasoning.  If there's something wrong with that
reasoning or if there are contradictory reasons which I'm not aware of
then let's hear them!
