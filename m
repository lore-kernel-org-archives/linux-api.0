From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v6 0/7] vfs: Non-blockling buffered fs read (page cache
 only)
Date: Thu, 4 Dec 2014 15:11:02 -0800
Message-ID: <20141204151102.2d7e11dca39f130c2dff2294@linux-foundation.org>
References: <cover.1415636409.git.milosz@adfin.com>
	<20141125150101.9596a09e.akpm@linux-foundation.org>
	<CANP1eJEALZTwMv0Z1udmPWKhfGmpe+idtdRASp62Jm_V0N2HcQ@mail.gmail.com>
	<20141202144200.a4ca81a46a43563a8874fd8e@linux-foundation.org>
	<CANP1eJGVyBOt1rQ8jA4tMrNGX5X61-UWbVy6kKj_ByeTqAEOBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANP1eJGVyBOt1rQ8jA4tMrNGX5X61-UWbVy6kKj_ByeTqAEOBQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-aio-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-aio-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Volker Lendecke <Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 3 Dec 2014 11:48:28 -0500 Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Dec 2, 2014 at 5:42 PM, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> >
> > On Tue, 2 Dec 2014 17:17:42 -0500 Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org> wrote:
> >
> > > > There have been several incomplete attempts to implement fincore().  If
> > > > we were to complete those attempts, preadv2() could be implemented
> > > > using fincore()+pread().  Plus we get fincore(), which is useful for
> > > > other (but probably similar) reasons.  Probably fincore()+pwrite() could
> > > > be used to implement pwritev2(), but I don't know what pwritev2() does
> > > > yet.
> > > >
> > > > Implementing fincore() is more flexible, requires less code and is less
> > > > likely to have bugs.  So why not go that way?  Yes, it's more CPU
> > > > intensive, but how much?  Is the difference sufficient to justify the
> > > > preadv2()/pwritev2() approach?
> > >
> > > I would like to see a fincore() functionality (for other reasons) I
> > > don't think it does the job here. fincore() + preadv() is inherently
> > > racy as there's no guarantee that the data becomes uncached between
> > > the two calls.
> >
> > There will always be holes.  For example find_get_page() could block on
> > lock_page() while some other process is doing IO.
> > page_cache_async_readahead() does lots of memory allocation which can
> > get blocked for long periods in the page allocator.
> > page_cache_async_readahead() can block on synchronous metadata reads,
> > etc.
> 
> Andrew I think it would helpful if you did read through the patches.
> The first 3 are somewhat uninteresting as it's just wiring up the new
> syscalls and plumbing the flag argument through. The core of the
> RWF_NONBLOCK is patch 4: https://lkml.org/lkml/2014/11/10/463 and if
> you strip away the fs specific changes the core of it is very simple.
> 
> The core is mostly contained in do_generic_file_read() in filemap.c,
> and is very short and easy to understand. It boils down to we read as
> much data as we can given what's in the page cache. There's no
> fallback to diskio for readpage() in case of missing pages and we bail
> before any calls to page_cache_async_readahead(). And to the best of
> my knowledge lock_page() does not lock the page, all it does is call
> pagecache_get_page() without the FGP_LOCK flag.
> 
> I've spent time a decent amount of time looking at this to make sure
> we cover all our major bases. It's possible I missed something but the
> biggest offenders should be covered and if I missed something I'd love
> to cover that as well.

OK.

> >
> >
> > > There's no overlap between prwritev2 and fincore() functionality.
> >
> > Do we actually need pwritev2()?  What's the justification for that?
> 
> 
> I'm okay with splitting up the pwritev2 and preadv2 into two
> independent patchsets to be considered on their own merits.

Well, we can do both together if both are wanted.  The changelogs are
very skimpy on pwritev2().  A full description and careful
justification in the [0/n] changelog would be useful - something that
tells us "what's wrong with O_DSYNC+pwrite".


> >
> >
> >
> > Please let's examine the alternative(s) seriously.  It would be mistake
> > to add preadv2/pwritev2 if fincore+pread would have sufficed.
> 
> 
>  What the motivation for my change and also approach is a very common
> pattern to async buffered disk IO in userspace server applications. It
> comes down to having one thread to handle the network and a thread
> pool to perform IO requests. Why a threadpool and not something like a
> sendfile() for reads? Many non-trivial applications perform additional
> processing (ssl, checksuming, transformation). Unfortunately this has
> a inherent increase in average latency due to increased
> synchronization penalties (enqueue and notify) but primarily due to
> fast requests (already in cache) behind stuck behind slow request.
> 
> Here's the illustration of the common architecture:
> http://i.imgur.com/f8Pla7j.png. In fact, most apps are even simpler
> where they replace the request queue, task worker with a single thread
> doing network IO using epoll or such.
> 
> preadv2 with RWF_NONBLOCK is analogous to the kernel recvmsg() with
> the MSG_NOWAIT flag. It's really frustrating that such capacity
> doesn't exist today. As with the user space application design we can
> skip the io threadpool and decrease average request latency in many
> common workloads (linear reads or zipf data accesses).
> 
> preadv2 with RWF_NONBLOCK as implemented does not suffer the same
> eviction races as fincore + pread because it's not implemented as two
> syscalls. It also has a much lower surface of possible blocking /
> locking then fincore + pread because it cannot fallback to reading
> from disk, it does not trigger read-ahead, and does not wait for page
> lock.

I can see all that, but it's handwaving.  Yes, preadv2() will perform
better in some circumstances than fincore+pread.  But how much better? 
Enough to justify this approach, or not?

Alas, the only way to really settle that is to implement fincore() and
to subject it to a decent amount of realistic quantitative testing.

Ho hum.

Could you please hunt down some libuv developers, see if we can solicit
some quality input from them?  As I said, we really don't want to merge
this then find that people don't use it for some reason, or that it
needs changes.
