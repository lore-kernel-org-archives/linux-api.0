From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 13/18] io_uring: add file set registration
Date: Thu, 7 Feb 2019 13:31:35 +0000
Message-ID: <20190207133135.GZ2217@ZenIV.linux.org.uk>
References: <20190129192702.3605-14-axboe@kernel.dk>
 <CAG48ez2kLWUEambWesQQaeVn_u=PtjuMeDUc49yamhYspfd7Sg@mail.gmail.com>
 <20190204025612.GR2217@ZenIV.linux.org.uk>
 <785c6db4-095e-65b0-ded5-72b41af5174e@kernel.dk>
 <2b2137ed-8107-f7b6-f0ca-202dcfb87c97@kernel.dk>
 <40b27e78-9ee8-1395-feb3-a73aac87c9a7@kernel.dk>
 <20190206005638.GU2217@ZenIV.linux.org.uk>
 <8f124de2-d6da-d656-25e4-b4d9e58f880e@kernel.dk>
 <20190207040058.GW2217@ZenIV.linux.org.uk>
 <20190207092253.GD19821@veci.piliscsaba.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20190207092253.GD19821@veci.piliscsaba.redhat.com>
Sender: owner-linux-aio@kvack.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Jann Horn <jannh@google.com>, linux-aio@kvack.org, linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Feb 07, 2019 at 10:22:53AM +0100, Miklos Szeredi wrote:
> On Thu, Feb 07, 2019 at 04:00:59AM +0000, Al Viro wrote:
> 
> > So in theory it would be possible to have
> > 	* thread A: sendmsg() has SCM_RIGHTS created and populated,
> > complete with file refcount and ->inflight increments implied,
> > at which point it gets preempted and loses the timeslice.
> > 	* thread B: gets to run and removes all references
> > from descriptor table it shares with thread A.
> > 	* on another CPU we have garbage collector triggered;
> > it determines the set of potentially unreachable unix_sock and
> > everything in our SCM_RIGHTS _is_ in that set, now that no
> > other references remain.
> > 	* on the first CPU, thread A regains the timeslice
> > and inserts its SCM_RIGHTS into queue.  And it does contain
> > references to sockets from the candidate set of running
> > garbage collector, confusing the hell out of it.
> 
> Reminds me: long time ago there was a bug report, and based on that I found a
> bug in MSG_PEEK handling (not confirmed to have fixed the reported bug).  This
> fix, although pretty simple, got lost somehow.  While unix gc code is in your
> head, can you please review and I'll resend through davem?

Umm...  I think the bug is real (something that looks like an eviction
candidate, but actually is referenced from the reachable queue might
get peeked via that queue, then have _its_ queue modified via new
external reference, all between two passes over that queue, confusing the
fuck out of unix_gc()), but I think the fix is an overkill...

Am I right assuming that this queue-modifying operation is accept(), removing
an embryo unix_sock from the queue of listener and thus hiding SCM_RIGHTS in
_its_ queue from scan_children()?

Let me think of it a bit, OK?  While we are at it, some questions from digging
through the current net/unix/garbage.c:
	1) is there any need for ->inflight to be atomic?  All accesses are under
unix_gc_lock, after all...
	2) pumping unix_gc on each sodding reference in SCM_RIGHTS (within
unix_notinflight()/unix_inflight()) looks atrocious... wouldn't it be better to
hold it over that loop?
	3) unix_get_socket() probably ought to be static nowadays...
	4) I wonder if in scan_inflight()/scan_children() we would be better
off with explicit switch (by enum argument) instead of an indirect call.
	5) do we really need UNIX_GC_MAYBE_CYCLE?  Looks like the only
real use is in inc_inflight_move_tail(), and AFAICS it could bloody well
have been
	u->inflight++;
	if (u->inflight == 1)	// just got from zero to non-zero
		list_move_tail(&u->link, &gc_candidates);
The logics there is "we'd found a reference to something that still was
a candidate for eviction in a reachable SCM_RIGHTS, so it's actually
reachable and needs to be scanned (and removed from the set of candidates);
move to the end of list, so that the main loop gets around to it".
If it *was* past the cursor in the list, there's no need to move it; if
we got past it, it must've had zero ->inflight (or we would've removed
it from the set back when we got past it).  Note that it's only called if
UNIX_GC_CANDIDATE is set (i.e. if it's in the initial candidate set),
so for this one ->inflight is guaranteed to mean the number of SCM_RIGHTS
refs from outside of the current candidate set...
	6) unix_get_socket() looks like it might benefit from another
FMODE bit; not sure where it's best set, though - the obvious way would
be SOCK_GC_CARES in sock->flags, set by e.g. unix_create1(), with
sock_alloc_file() propagating it into file->f_mode.  Then unix_get_socket()
would be able to bugger off with NULL for most of the references in
SCM_RIGHTS, without looking into inode...

Comments?  IIRC, you'd done the last serious round of rewriting unix_gc()
and friends...

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
