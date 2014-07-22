From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
Date: Mon, 21 Jul 2014 21:34:57 -0400
Message-ID: <20140721213457.46623e2f@gandalf.local.home>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com>
 <8761iq3bp3.fsf@tassilo.jf.intel.com>
 <871tte3bjw.fsf@tassilo.jf.intel.com>
 <CFF29A00.9D44A%dvhart@linux.intel.com>
 <CFF29E4A.9D44E%dvhart@linux.intel.com>
 <alpine.DEB.2.10.1407212025130.20847@nanos>
 <20140721212740.GS3935@laptop>
 <CALCETrXSaWM6-nxr4ggtMh5qcfTQg4wRvkW8FTSbri5+_1ZbVg@mail.gmail.com>
 <alpine.DEB.2.10.1407212344130.20847@nanos>
 <CFF2E3D6.9D525%dvhart@linux.intel.com>
 <alpine.DEB.2.10.1407220047490.20847@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.10.1407220047490.20847@nanos>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Darren Hart <dvhart@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>, Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@kernel.org>, Davidlohr Bueso <davidlohr@hp.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>, Robert Haas <robertmhaas@gmail.com>
List-Id: linux-api@vger.kernel.org

On Tue, 22 Jul 2014 03:01:00 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Mon, 21 Jul 2014, Darren Hart wrote:
> > On 7/21/14, 14:47, "Thomas Gleixner" <tglx@linutronix.de> wrote:
> > 
> > >On Mon, 21 Jul 2014, Andy Lutomirski wrote:
> > >> On Mon, Jul 21, 2014 at 2:27 PM, Peter Zijlstra <peterz@infradead.org>
> > >>wrote:
> > >> > All this is predicated on the fact that syscalls are 'expensive'.
> > >> > Weren't syscalls only 100s of cycles? All this bitmap mucking is far
> > >> > more expensive due to cacheline misses, which due to the size of the
> > >> > things is almost guaranteed.
> > >> 
> > >> 120 - 300 cycles for me, unless tracing happens, and I'm working on
> > >> reducing the incidence of tracing.
> > >
> > >So it's a non issue indeed and definitely not worth the trouble of
> > >that extra storage, the scheduler overhead, etc.
> > >
> > >Summary: Once you can't take it atomically in user space, you've lost
> > >	 anyway. And we are better off to do the magic spinning in
> > >	 kernel where we have all the information accessible already.

I just want to point out that I was having a very nice conversation
with Robert Haas (Cc'd) in Napa Valley at Linux Collaboration about
this very topic. Robert is a PostgeSQL developer who told me that they
implement their spin locks completely in userspace (no futex, just raw
spinning on shared memory). This is because the sleep on contention of a
futex has shown to be very expensive in their benchmarks. His work is
not a micro benchmark but for a very popular database where locking is
crucial.

I was telling Robert that if futexes get optimistic spinning, he should
reconsider their use of userspace spinlocks in favor of this, because
I'm pretty sure that they will see a great improvement.

Now Robert will be the best one to answer if the system call is indeed
more expensive than doing full spins in userspace. If the spin is done
in the kernel and they still get better performance by just spinning
blindly in userspace even if the owner is asleep, I think we will have
our answer.

Note, I believe they only care about shared threads, and this
optimistic spinning does not need to be something done between
processes.

> > 
> > And we have such an implementation with the FUTEX_LOCK_ADAPTIVE code we
> > discussed back in Oct 2010 (purely kernel, no VDSO), updated with some of
> > your and other's comments:
> > 
> > http://git.infradead.org/users/dvhart/linux.git/shortlog/refs/heads/futex/f
> > utex-lock/v7
> > 
> > 
> > I can work on forward porting this series to current mainline (post recent
> > security fixes) and cleaning up the commentary and such if people are
> > interested in seeing this implementation (based on Peter Z's spinning
> > mutex work iirc) resurrected...
> 
> No. We really want to avoid more magic hackery in the futex code.
> 
> Lets sit down and think about what we need:
> 
>  1) Support for all existing features
> 
>  2) More fine grained locking
> 
>  3) Optimistic spinning
> 
> @1: No discussion about that. Period.
> 
>     We are not going to introduce some new futex opcode, which is
>     optimized for a microbenchmark and ignoring all of the pain we
>     went through in the last 10 years. No way, especially after the
>     recent security disaster.
> 
> @2 and @3: Yes, we want that.
> 
>     But again, we don't add fine grained locking just for some half
>     baken new opcode. No, we are adding it where it makes the most
>     sense and lets us reuse most of the code.
> 
>     I can predict your question, how that should work :)
> 
>     If we want to have fine grained locking beyond the futex hash
>     buckets and that's something we discussed before, you need a state
>     representation of the user space futex in the kernel. That's what
>     Waiman added as well, just in a way that's beyond repair.
> 
>     The charm of the futex hash buckets is that they do not create
>     kernel state because the futex_q which is enqueued into the bucket
>     is on the task stack of the task which is blocked on the futex.
> 
>     So much for the theory, because that stopped to be true when we
>     added support for PI futexes. They already create kernel internal
>     state which is not magically removed when the thread exits the
>     syscall. It's called pi_state.
> 
>     Now the question is how is this related to the non PI magic
>     spinning optimization? Very much so.
> 
>     Simply because the handling of pi_state already covers ALL the
>     corner cases which come with the extra kernel internal state and
>     they provide the full function set of futexes required by the
>     various (ab)use cases including the requeue functionality which is
>     required for condvars. It even supports caching of the pi_state
>     struct in a way which makes sense, rather than blindly slapping a
>     cached entry onto each hash bucket.
> 
>     So it's not a really mind boggling thought experiment to think
>     about this magic new feature as a subset of the already existing
>     PI futex code. It is a subset, just minus the PI portion plus the
>     more fine grained locking.
> 
> So the right solution is to rework the existing code.
> 
> 1) Make pi_state the entity which gets enqueued into the hash bucket
>    and manage the waiters in a pi_state internal queue.
> 
>    Straight forward problem as it is still protected by the hash
>    bucket lock.
>    
> 2) Add private locking to the pi_state to reduce the lock contention
>    on the hash bucket lock.
> 
>    Straight forward conversion as well
> 
> 3) Make mutex a subset of rt_mutex

+1

> 
>    That makes a lot of sense, simply because a mutex is the same as a
>    rtmutex just without the PI part.
> 
>    Just for the record before anyone cries murder: The original mutex
>    implemention was modeled after the rtmutex one in the first place
>    and the optimistic spinning was first introduced on rtmutexes by
>    Gregory Haskins et. al. in the context of the RT tree. Back then it
>    was too early or we were simply too stupid to see the similarities
>    and opted for a complete separate implementation.

I believe it was more about politics to why it was a separate solution.
Technically, I think they should have been one.

> 
>    Yes, I'm aware that this is a non-trivial problem, but if you look
>    at the details, then the non-trivial part is in the slow path were
>    stuff actually goes to sleep. The fast path of mutex and rt_mutex
>    is simply the same. So there is no reason to keep them separate. An
>    extra conditional in the slow path is not going to hurt at all.
> 
>    Surely, you might say, that I'm an egoistic bastard, who just wants
>    to have the benefit of MCS for rtmutex for free. Right you are, but
>    there is a whole bunch of reasons why this makes tons of sense:
> 
>    - As I said above, it's almost the same, except for the slow path
>      details, where a few extra conditionals do not matter
> 
>    - Sharing the code has the obvious benefits. And it's not only
>      sharing between rtmutex and mutex, it's also sharing the
>      underlying optimizations of MCS for the kernel internal users and
>      the user space exposed ones, i.e. futexes. 
> 
>    - Once unified the desired futex functionality just works with a
>      minimal impact on the futex code itself.
> 
>      The futex code does not care whether the underlying primitive has
>      PI semantics or not, it just cares that all the required features
>      like proxy locking etc. are in place. And that everything like
>      timeouts, requeue etc. is just supported.
> 
>    - The semantics of the new futex functionality has not to be
>      defined again. We can simply reuse the rather well defined and
>      well tested straight forward semantics of the existing PI
>      opcodes.
> 
>    - That minimizes the risk massively, because all state and error
>      handling is common code. 
> 
>    - Any update to the underlying primitives will benefit ALL usage
>      sites and reduces the copy and paste induced hell of MCS code
>      sprinkled all over the kernel.
> 
> 4) Enable user space to make use of it.
> 
>    Whether this will be a separate opcode or just a new flag to the
>    existing PI opcodes is going to be just a bikeshedding question at
>    that point. :)
> 
> The important point is, that we do NOT grow any new unmaintainable
> warts to the futex code. And the 650+ new lines of hackery which come
> with the proposed patch set are in no way acceptable, especially as
> they only cover the minimalistic functionality set of futexes. Not to
> talk about the other issues I've observed on the first glance.
> 
> So before anyone comes up with a "solution" for all of this tomorrow
> afternoon in form of another half baken patch, please sit back mull it
> in your head and lets have a proper discussion about the approach
> first.
> 

If we can have that schedule_out() threads_on_cpu, that could be a
helpful solution to see if the system call is indeed expensive. Sounds
like we can have both an in kernel solution and a userspace one as well.

-- Steve
