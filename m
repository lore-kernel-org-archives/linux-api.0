From: Milosz Tanski <milosz@adfin.com>
Subject: Re: [PATCH v6 0/7] vfs: Non-blockling buffered fs read (page cache only)
Date: Tue, 2 Dec 2014 17:17:42 -0500
Message-ID: <CANP1eJEALZTwMv0Z1udmPWKhfGmpe+idtdRASp62Jm_V0N2HcQ@mail.gmail.com>
References: <cover.1415636409.git.milosz@adfin.com>
	<20141125150101.9596a09e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20141125150101.9596a09e.akpm@linux-foundation.org>
Sender: owner-linux-aio@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Nov 25, 2014 at 6:01 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Mon, 10 Nov 2014 11:40:23 -0500 Milosz Tanski <milosz@adfin.com> wrote:
>
> > This patcheset introduces an ability to perform a non-blocking read from
> > regular files in buffered IO mode. This works by only for those filesystems
> > that have data in the page cache.
> >
> > It does this by introducing new syscalls new syscalls preadv2/pwritev2. These
> > new syscalls behave like the network sendmsg, recvmsg syscalls that accept an
> > extra flag argument (RWF_NONBLOCK).
> >
> > It's a very common patern today (samba, libuv, etc..) use a large threadpool to
> > perform buffered IO operations. They submit the work form another thread
> > that performs network IO and epoll or other threads that perform CPU work. This
> > leads to increased latency for processing, esp. in the case of data that's
> > already cached in the page cache.
>
> It would be extremely useful if we could get input from the developers
> of "samba, libuv, etc.." about this.  Do they think it will be useful,
> will they actually use it, can they identify any shortcomings, etc.
>
> Because it would be terrible if we were to merge this then discover
> that major applications either don't use it, or require
> userspace-visible changes.
>
> Ideally, someone would whip up pread2() support into those apps and
> report on the result.

The Samba folks did express an interest in the functionality when I
originally brought up the idea of having a non-blocking page cache
only when I was getting my mind around the concept. This was
unsolicited on my part. https://lkml.org/lkml/2014/9/7/103 It should
be good enough at this point to enable a "fast path" read without
deferring to their AIO pool.

>
> > With the new interface the applications will now be able to fetch the data in
> > their network / cpu bound thread(s) and only defer to a threadpool if it's not
> > there. In our own application (VLDB) we've observed a decrease in latency for
> > "fast" request by avoiding unnecessary queuing and having to swap out current
> > tasks in IO bound work threads.
>
> I haven't read the patches yet, but I'm scratching my head over
> pwritev2().  There's much talk and testing results here about
> preadv2(), but nothing about how pwritev() works, what its semantics
> are, testing results, etc.

Essentially preadv2 and pwritev2 are same syscalls as preadv/writrev
but support an extra flags argument. With preadv2 the only flag
implemented right now is RWF_NONBLOCK, that allows perform a page
cache only read on a per call basis. Christoph, implemented the
RWF_DSYNC flag for pwritev2 which has the same effect as O_DSYNC but
on per write call basis.

Christoph has included example of the usage of this pwritev2 with
RWF_DSYNC in the commit msg in patch #7. I am currently working on
wiring up test cases as part of xfstests for both pwritev2/preadv2
functionality.

>
> > Version 6 highlight:
> >  - Compat syscall flag checks, per. Jeff.
> >  - Minor stylistic suggestions.
> >
> > Version 5 highlight:
> >  - XFS support for RWF_NONBLOCK. from Christoph.
> >  - RWF_DSYNC flag and support for pwritev2, from Christoph.
> >  - Implemented compat syscalls, per. Jeff.
> >  - Missing nfs, ceph changes from older patchset.
> >
> > Version 4 highlight:
> >  - Updated for 3.18-rc1.
> >  - Performance data from our application.
> >  - First stab at man page with Jeff's help. Patch is in-reply to.
>
> I can't find that manpage.  It is important.  Please include it in the
> patch series.
>
> I'm particularly interested in details regarding
>
> - behaviour and userspace return values when data is not found in pagecache
>
> - how it handles partially uptodate pages (blocksize < pagesize).
>   For both reads and writes.  This sort of thing gets intricate so
>   let's spell the design out with great specificity.
>
> - behaviour at EOF.
>
> - details regarding handling of file holes.

I have replied with the man page update patches with the last two
submissions. Here's an archive link:
https://lkml.org/lkml/2014/11/6/447. I'll re-reply it to the parent
thread of the latest as well. The man page updates cover
preadv2/pwritev2 and their new flags RWF_NONBLOCK/RWF_DSYNC
respectively.

- Behavior on data not in page cache is documented in man page (EAGAIN).
- Since we defer to normal preadv (and thus read) behavior things like
end of file (0 length return value), partial up to date pages, and
hole behavior is the same as in those calls.

Further, the behavior of the logic for RWF_NONBLOCK is primarily
located is mostly contained do_generic_file_read in filemap.c. It does
is bail early if we have to make a call to aops->readpage() returning
a full or partial read if there's data in the page cache EAGAIN if
there's nothing starting at offset in the page cache. So it makes why
it behaves like regular preadv at the end of file file / holes /
etc...

>
> > RFC Version 3 highlights:
> >  - Down to 2 syscalls from 4; can user fp or argument position.
> >  - RWF_NONBLOCK value flag is not the same O_NONBLOCK, per Jeff.
> >
> > RFC Version 2 highlights:
> >  - Put the flags argument into kiocb (less noise), per. Al Viro
> >  - O_DIRECT checking early in the process, per. Jeff Moyer
> >  - Resolved duplicate (c&p) code in syscall code, per. Jeff
> >  - Included perf data in thread cover letter, per. Jeff
> >  - Created a new flag (not O_NONBLOCK) for readv2, perf Jeff
> >
> >
> > Some perf data generated using fio comparing the posix aio engine to a version
> > of the posix AIO engine that attempts to performs "fast" reads before
> > submitting the operations to the queue. This workflow is on ext4 partition on
> > raid0 (test / build-rig.) Simulating our database access patern workload using
> > 16kb read accesses. Our database uses a home-spun posix aio like queue (samba
> > does the same thing.)
> >
> > f1: ~73% rand read over mostly cached data (zipf med-size dataset)
> > f2: ~18% rand read over mostly un-cached data (uniform large-dataset)
> > f3: ~9% seq-read over large dataset
> >
> > before:
> >
> > f1:
> >     bw (KB  /s): min=   11, max= 9088, per=0.56%, avg=969.54, stdev=827.99
> >     lat (msec) : 50=0.01%, 100=1.06%, 250=5.88%, 500=4.08%, 750=12.48%
> >     lat (msec) : 1000=17.27%, 2000=49.86%, >=2000=9.42%
> > f2:
> >     bw (KB  /s): min=    2, max= 1882, per=0.16%, avg=273.28, stdev=220.26
> >     lat (msec) : 250=5.65%, 500=3.31%, 750=15.64%, 1000=24.59%, 2000=46.56%
> >     lat (msec) : >=2000=4.33%
> > f3:
> >     bw (KB  /s): min=    0, max=265568, per=99.95%, avg=174575.10,
> >                  stdev=34526.89
> >     lat (usec) : 2=0.01%, 4=0.01%, 10=0.02%, 20=0.27%, 50=10.82%
> >     lat (usec) : 100=50.34%, 250=5.05%, 500=7.12%, 750=6.60%, 1000=4.55%
> >     lat (msec) : 2=8.73%, 4=3.49%, 10=1.83%, 20=0.89%, 50=0.22%
> >     lat (msec) : 100=0.05%, 250=0.02%, 500=0.01%
> > total:
> >    READ: io=102365MB, aggrb=174669KB/s, minb=240KB/s, maxb=173599KB/s,
> >          mint=600001msec, maxt=600113msec
> >
> > after (with fast read using preadv2 before submit):
> >
> > f1:
> >     bw (KB  /s): min=    3, max=14897, per=1.28%, avg=2276.69, stdev=2930.39
> >     lat (usec) : 2=70.63%, 4=0.01%
> >     lat (msec) : 250=0.20%, 500=2.26%, 750=1.18%, 2000=0.22%, >=2000=25.53%
> > f2:
> >     bw (KB  /s): min=    2, max= 2362, per=0.14%, avg=249.83, stdev=222.00
> >     lat (msec) : 250=6.35%, 500=1.78%, 750=9.29%, 1000=20.49%, 2000=52.18%
> >     lat (msec) : >=2000=9.99%
> > f3:
> >     bw (KB  /s): min=    1, max=245448, per=100.00%, avg=177366.50,
> >                  stdev=35995.60
> >     lat (usec) : 2=64.04%, 4=0.01%, 10=0.01%, 20=0.06%, 50=0.43%
> >     lat (usec) : 100=0.20%, 250=1.27%, 500=2.93%, 750=3.93%, 1000=7.35%
> >     lat (msec) : 2=14.27%, 4=2.88%, 10=1.54%, 20=0.81%, 50=0.22%
> >     lat (msec) : 100=0.05%, 250=0.02%
> > total:
> >    READ: io=103941MB, aggrb=177339KB/s, minb=213KB/s, maxb=176375KB/s,
> >          mint=600020msec, maxt=600178msec
> >
> > Interpreting the results you can see total bandwidth stays the same but overall
> > request latency is decreased in f1 (random, mostly cached) and f3 (sequential)
> > workloads. There is a slight bump in latency for since it's random data that's
>
> s/for/for f2/
>
> > unlikely to be cached but we're always trying "fast read".
> >
> > In our application we have starting keeping track of "fast read" hits/misses
> > and for files / requests that have a lot hit ratio we don't do "fast reads"
> > mostly getting rid of extra latency in the uncached cases. In our real world
> > work load we were able to reduce average response time by 20 to 30% (depends
> > on amount of IO done by request).
> >
> > I've performed other benchmarks and I have no observed any perf regressions in
> > any of the normal (old) code paths.
> >
> > I have co-developed these changes with Christoph Hellwig.
> >
>
> There have been several incomplete attempts to implement fincore().  If
> we were to complete those attempts, preadv2() could be implemented
> using fincore()+pread().  Plus we get fincore(), which is useful for
> other (but probably similar) reasons.  Probably fincore()+pwrite() could
> be used to implement pwritev2(), but I don't know what pwritev2() does
> yet.
>
> Implementing fincore() is more flexible, requires less code and is less
> likely to have bugs.  So why not go that way?  Yes, it's more CPU
> intensive, but how much?  Is the difference sufficient to justify the
> preadv2()/pwritev2() approach?

I would like to see a fincore() functionality (for other reasons) I
don't think it does the job here. fincore() + preadv() is inherently
racy as there's no guarantee that the data becomes uncached between
the two calls. This may not matter in some cases, but in others (ones
that I'm trying to solve) it will introduce unexpected latency.

There's no overlap between prwritev2 and fincore() functionality.

Sorry that this took longer then expected to reply. Got busy with
holidays / unrelated things. Let me know if I missed anything.

-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
