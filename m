From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 0/5] vfs: Non-blockling buffered fs read (page cache
 only)
Date: Fri, 27 Mar 2015 10:04:11 -0700
Message-ID: <20150327100411.6823b9d7.akpm@linux-foundation.org>
References: <cover.1426528417.git.milosz@adfin.com>
	<20150326202824.65d03787.akpm@linux-foundation.org>
	<CANP1eJEbDusq_Gda35dGKiacC+2tbvb_bQEEHpi6PmgnNoWDFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CANP1eJEbDusq_Gda35dGKiacC+2tbvb_bQEEHpi6PmgnNoWDFw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Milosz Tanski <milosz@adfin.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, Dave Chinner <david@fromorbit.com>
List-Id: linux-api@vger.kernel.org

On Fri, 27 Mar 2015 11:21:26 -0400 Milosz Tanski <milosz@adfin.com> wrote:

> On Thu, Mar 26, 2015 at 11:28 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Mon, 16 Mar 2015 14:27:10 -0400 Milosz Tanski <milosz@adfin.com> wrote:
> >
> >> This patchset introduces two new syscalls preadv2 and pwritev2. They are the
> >> same syscalls as preadv and pwrite but with a flag argument. Additionally,
> >> preadv2 implements an extra RWF_NONBLOCK flag.
> >
> > I still don't understand why pwritev() exists.  We discussed this last
> > time but it seems nothing has changed.  I'm not seeing here an adequate
> > description of why it exists nor a justification for its addition.
> 
> In the "Forward Looking" section there's a description of why we want
> pwritev2 and what we're doing to do with it in the future. The goal is
> to have two additional flags for those calls RWF_DSYNC and
> RWF_NONBLOCK. As Christop mentioned modern network filesystem
> protocols have per operation sync flags. And there's use cases for
> guaranteeing of write dirtying pages without triggering a writeout.
> 
> The consensus from our discussion at LSF fs tack was 1) that both
> preadv and pwritev should have flags to begin with, inline with the
> API syscall design guidelines 2) if we're adding preadv2 we should add
> a matching pwritev2 3) especially that we plan on introducing further
> flags to preadv in the near future.

mm...  I don't think we should be adding placeholders to the kernel API
to support code which hasn't been written, tested, reviewed, merged,
etc.  It's possible none of this will ever happen and we end up with a
syscall nobody needs or uses.  Plus it's always possible that during
this development we decide the pwrite2() interface needs alteration but
it's too late.

What would be the downside of deferring pwrite2() until it's all
implemented?

> >
> > Also, why are we adding new syscalls instead of using O_NONBLOCK?  I
> > think this might have been discussed before, but the changelogs haven't
> > been updated to reflect it - please do so.
> 
> In a much earlier patch series we already had the discussion on why we
> can't use O_NONBLOCK for regular files. It comes down to that it
> breaks some userspace applications. Link for further reference to the
> thread:
> 
> https://lkml.org/lkml/2014/9/22/294
> http://thread.gmane.org/gmane.linux.kernel.aio.general/4242
> 
> I will include the background in the next patchset.

Cool, thanks.

> >
> >> The RWF_NONBLOCK flag in preadv2 introduces an ability to perform a
> >> non-blocking read from regular files in buffered IO mode. This works by only
> >> for those filesystems that have data in the page cache.
> >>
> >> We discussed these changes at this year's LSF/MM summit in Boston. More details
> >> on the Samba use case, the numbers, and presentation is available at this link:
> >> https://lists.samba.org/archive/samba-technical/2015-March/106290.html
> >
> > https://drive.google.com/file/d/0B3maCn0jCvYncndGbXJKbGlhejQ/view?usp=sharing
> > talks about "sync" but I can't find a description of what this actually
> > is.  It appears to perform better than anything else?
> 
> Sync is the samba mode where we do not use threadpool just service the
> IO request in the network thread. In a single client case if
> everything is in the page cache we are aiming to be as close in
> latency as sync. The reason it isn't is because the threadpool path in
> samba has some additional over head. I did bring it up to the Samba
> folks on their technical mailing list, they can investigate it further
> if they want it.
> 
> It's impractical to use Sync anywhere we have modern SMB3 clients that
> can multiplex > 100 operations over a single connection. Head-of-line
> blocking would kill performance, why we need the threadpool. With the
> threadpool we increase the mean (and tail) latency even if the data is
> handy and we can answer it right away.

OK, all makes sense.

> >
> >> Background:
> >>
> >>  Using a threadpool to emulate non-blocking operations on regular buffered
> >>  files is a common pattern today (samba, libuv, etc...) Applications split the
> >>  work between network bound threads (epoll) and IO threadpool. Not every
> >>  application can use sendfile syscall (TLS / post-processing).
> >>
> >>  This common pattern leads to increased request latency. Latency can be due to
> >>  additional synchronization between the threads or fast (cached data) request
> >>  stuck behind slow request (large / uncached data).
> >>
> >>  The preadv2 syscall with RWF_NONBLOCK lets userspace applications bypass
> >>  enqueuing operation in the threadpool if it's already available in the
> >>  pagecache.
> >
> > A thing which bugs me about pread2() is that it is specifically
> > tailored to applications which are able to use a partial read result.
> > ie, by sending it over the network.
> >
> > But it is not very useful for the class of applications which require
> > that the entire read be completed before they can proceed with using
> > the data.  Such applications will have to run pread2(), see the short
> > result, save away the partial data, perform some IO then fetch the
> > remaining data then proceed.  By this time, the original partially read
> > data may have fallen out of CPU cache (or we're on a different CPU) and
> > the data will need to be fetched into cache a second time.
> >
> > Such applications would be better served if they were able to query for
> > pagecache presence _before_ doing the big copy_to_user(), so they can
> > ensure that all the data is in pagecache before copying it in.  ie:
> > fincore(), perhaps supported by a synchronous POSIX_FADV_WILLNEED.
> >
> > And of course fincore could be used by Samba etc to avoid blocking on
> > reads.  It wouldn't perform quite as well as pread2(), but I bet it's
> > good enough.
> 
> The RWF_NONBLOCK is aimed primarily at network applications. Some of
> them can send a partial result down the network, and then they can
> enqueue the rest in the threadpool. For applications that need the
> whole value, they clearly have to wait to read in the rest, but it's
> behavior that are opting into.

Right.  But these applications would prefer "all or nothing" behaviour.
They can get that with fincore()+pread() but they can't get it with
pread2().  Because pread2() takes the two separate concepts of "are
these pages in cache" and "copy these pages to me" and joins them
together in a single operation.

> >
> > Bottom line: with pread2() there's still a need for fincore(), but with
> > fincore() there probably isn't a need for pread2().
> 
> I see fincore() and preadv2() with RWF_NONBLOCK as tangential
> syscalls. You can implement a poor man's RWF_NONBLOCK in userspace
> with fincore() but not all of us are fine with it's racy nature or
> requiring 2 syscalls in the best case.

I find this to be too handwavy to be able to process it, sorry.

- WHY is the raciness unacceptable?  If 0.0001% of pread2() calls
  inadvertently block, what problem does this cause?  0.01%?  Details
  please, lots of them.

- Yes, 2 syscalls is more expensive.  But 

  a) we don't know *how* expensive.  It might be negligible.

  b) bear in mind that this patchset is adding minor additional overhead
     to every linux application that does read().  To benefit the teeny
     teeny minority of apps which use pread2().

btw, that overhead might be slightly reduced by doing

-	if (iocb->ki_rwflags & RWF_NONBLOCK)
+	if (unlikely(iocb->ki_rwflags & RWF_NONBLOCK))
		return -EAGAIN;

in the appropriate places.
