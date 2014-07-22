From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
Date: Tue, 22 Jul 2014 09:47:19 +0200
Message-ID: <20140722074719.GV3935@laptop>
References: <871tte3bjw.fsf@tassilo.jf.intel.com>
 <CFF29A00.9D44A%dvhart@linux.intel.com>
 <CFF29E4A.9D44E%dvhart@linux.intel.com>
 <alpine.DEB.2.10.1407212025130.20847@nanos>
 <20140721212740.GS3935@laptop>
 <CALCETrXSaWM6-nxr4ggtMh5qcfTQg4wRvkW8FTSbri5+_1ZbVg@mail.gmail.com>
 <alpine.DEB.2.10.1407212344130.20847@nanos>
 <CFF2E3D6.9D525%dvhart@linux.intel.com>
 <alpine.DEB.2.10.1407220047490.20847@nanos>
 <20140721213457.46623e2f@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140721213457.46623e2f-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Waiman Long <Waiman.Long-VXdhtT5mjnY@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>, Scott J Norton <scott.norton-VXdhtT5mjnY@public.gmane.org>, Robert Haas <robertmhaas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 21, 2014 at 09:34:57PM -0400, Steven Rostedt wrote:

> I just want to point out that I was having a very nice conversation
> with Robert Haas (Cc'd) in Napa Valley at Linux Collaboration about
> this very topic. Robert is a PostgeSQL developer who told me that they
> implement their spin locks completely in userspace (no futex, just raw
> spinning on shared memory). This is because the sleep on contention of a
> futex has shown to be very expensive in their benchmarks. His work is
> not a micro benchmark but for a very popular database where locking is
> crucial.

Userspace spinlocks are a clusterfuck. Its impossible to solve the
priority inversion trainwrecks they cause _ever_.

We've had -- as I think Mike already pointed out -- tons of 'fun' with
psql exactly because its doing this :-(

> I was telling Robert that if futexes get optimistic spinning, he should
> reconsider their use of userspace spinlocks in favor of this, because
> I'm pretty sure that they will see a great improvement.
> 
> Now Robert will be the best one to answer if the system call is indeed
> more expensive than doing full spins in userspace. If the spin is done
> in the kernel and they still get better performance by just spinning
> blindly in userspace even if the owner is asleep, I think we will have
> our answer.

No, the best way is to measure the exact syscall cost. If he still gets
better performance we need to analyze why, there might be something else
hiding there.

> Note, I believe they only care about shared threads, and this
> optimistic spinning does not need to be something done between
> processes.

There's no reason not to provide it for shared futexes, in fact I
suspect not doing it for shared futexes is going to make the code
uglier.


Anyway, there is one big fail in the entire futex stack that we 'need'
to sort some day and that is NUMA. Some people (again database people)
explicitly do not use futexes and instead use sysvsem because of this.

The problem with numa futexes is that because they're vaddr based there
is no (persistent) node information. You always end up having to fall
back to looking in all nodes before you can guarantee there is no
matching futex.

One way to achieve it is by extending the futex value to include a node
number, but that's obviously a complete ABI break. Then again, it should
be pretty straight fwd, since the node number doesn't need to be part of
the actual atomic update part, just part of the userspace storage.
