From: Davidlohr Bueso <davidlohr@hp.com>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
Date: Mon, 21 Jul 2014 20:06:19 -0700
Message-ID: <1405998379.25048.16.camel@buesod1.americas.hpqcorp.net>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com>
	 <8761iq3bp3.fsf@tassilo.jf.intel.com> <871tte3bjw.fsf@tassilo.jf.intel.com>
	 <CFF29A00.9D44A%dvhart@linux.intel.com>
	 <CFF29E4A.9D44E%dvhart@linux.intel.com>
	 <alpine.DEB.2.10.1407212025130.20847@nanos> <20140721212740.GS3935@laptop>
	 <CALCETrXSaWM6-nxr4ggtMh5qcfTQg4wRvkW8FTSbri5+_1ZbVg@mail.gmail.com>
	 <alpine.DEB.2.10.1407212344130.20847@nanos>
	 <CFF2E3D6.9D525%dvhart@linux.intel.com>
	 <alpine.DEB.2.10.1407220047490.20847@nanos>
	 <20140721213457.46623e2f@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140721213457.46623e2f@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhart@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>, Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@kernel.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>, Robert Haas <robertmhaas@gmail.com>
List-Id: linux-api@vger.kernel.org

On Mon, 2014-07-21 at 21:34 -0400, Steven Rostedt wrote:
> On Tue, 22 Jul 2014 03:01:00 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Mon, 21 Jul 2014, Darren Hart wrote:
> > > On 7/21/14, 14:47, "Thomas Gleixner" <tglx@linutronix.de> wrote:
> > > 
> > > >On Mon, 21 Jul 2014, Andy Lutomirski wrote:
> > > >> On Mon, Jul 21, 2014 at 2:27 PM, Peter Zijlstra <peterz@infradead.org>
> > > >>wrote:
> > > >> > All this is predicated on the fact that syscalls are 'expensive'.
> > > >> > Weren't syscalls only 100s of cycles? All this bitmap mucking is far
> > > >> > more expensive due to cacheline misses, which due to the size of the
> > > >> > things is almost guaranteed.
> > > >> 
> > > >> 120 - 300 cycles for me, unless tracing happens, and I'm working on
> > > >> reducing the incidence of tracing.
> > > >
> > > >So it's a non issue indeed and definitely not worth the trouble of
> > > >that extra storage, the scheduler overhead, etc.
> > > >
> > > >Summary: Once you can't take it atomically in user space, you've lost
> > > >	 anyway. And we are better off to do the magic spinning in
> > > >	 kernel where we have all the information accessible already.
> 
> I just want to point out that I was having a very nice conversation
> with Robert Haas (Cc'd) in Napa Valley at Linux Collaboration about
> this very topic. Robert is a PostgeSQL developer who told me that they
> implement their spin locks completely in userspace (no futex, just raw
> spinning on shared memory). This is because the sleep on contention of a
> futex has shown to be very expensive in their benchmarks. 

Well sure, hashing, plist handling, wakeups etc. (not to mention
dirtying cachelines). The "fast" in futex is only due to the fact that
there is no jump to kernel space when the lock is uncontended after say,
a successful cmpxchg in user space. Once futex(2) is actually called,
performance is quite a different story.

> His work is
> not a micro benchmark but for a very popular database where locking is
> crucial.
> 
> I was telling Robert that if futexes get optimistic spinning, he should
> reconsider their use of userspace spinlocks in favor of this, because
> I'm pretty sure that they will see a great improvement.

Agreed, with the critical regions being correctly sized for spinning
locks.

> Now Robert will be the best one to answer if the system call is indeed
> more expensive than doing full spins in userspace. If the spin is done
> in the kernel and they still get better performance by just spinning
> blindly in userspace even if the owner is asleep, I think we will have
> our answer.
> 
> Note, I believe they only care about shared threads, and this
> optimistic spinning does not need to be something done between
> processes.

With the pi_state there would be no such distinction.

Thanks,
Davidlohr
