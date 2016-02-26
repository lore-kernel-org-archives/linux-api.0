From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH v4 1/5] getcpu_cache system call: cache CPU number of
 running thread
Date: Fri, 26 Feb 2016 17:20:01 +0000 (UTC)
Message-ID: <967083634.8940.1456507201156.JavaMail.zimbra@efficios.com>
References: <1456270120-7560-1-git-send-email-mathieu.desnoyers@efficios.com> <1456270120-7560-2-git-send-email-mathieu.desnoyers@efficios.com> <20160225095635.GO6356@twins.programming.kicks-ass.net> <390571988.7745.1456419326288.JavaMail.zimbra@efficios.com> <20160225170416.GV6356@twins.programming.kicks-ass.net> <2135602720.7810.1456420671941.JavaMail.zimbra@efficios.com> <20160226113304.GA6356@twins.programming.kicks-ass.net> <alpine.DEB.2.11.1602261719440.3638@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.11.1602261719440.3638@nanos>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

----- On Feb 26, 2016, at 11:29 AM, Thomas Gleixner tglx@linutronix.de wrote:

> On Fri, 26 Feb 2016, Peter Zijlstra wrote:
>> On Thu, Feb 25, 2016 at 05:17:51PM +0000, Mathieu Desnoyers wrote:
>> > ----- On Feb 25, 2016, at 12:04 PM, Peter Zijlstra peterz@infradead.org wrote:
>> > 
>> > > On Thu, Feb 25, 2016 at 04:55:26PM +0000, Mathieu Desnoyers wrote:
>> > >> ----- On Feb 25, 2016, at 4:56 AM, Peter Zijlstra peterz@infradead.org wrote:
>> > >> The restartable sequences are intrinsically designed to work
>> > >> on per-cpu data, so they need to fetch the current CPU number
>> > >> within the rseq critical section. This is where the getcpu_cache
>> > >> system call becomes very useful when combined with rseq:
>> > >> getcpu_cache allows reading the current CPU number in a
>> > >> fraction of cycle.
>> > > 
>> > > Yes yes, I know how restartable sequences work.
>> > > 
>> > > But what I worry about is that they want a cpu number and a sequence
>> > > number, and for performance it would be very good if those live in the
>> > > same cacheline.
>> > > 
>> > > That means either getcpu needs to grow a seq number, or restartable
>> > > sequences need to _also_ provide the cpu number.
>> > 
>> > If we plan things well, we could have both the cpu number and the
>> > seqnum in the same cache line, registered by two different system
>> > calls. It's up to user-space to organize those two variables
>> > to fit within the same cache-line.
>> 
>> I feel this is more fragile than needed. Why not do a single systemcall
>> that does both?
> 
> Right. There is no point in having two calls and two update mechanisms for a
> very similar purpose.
> 
> So let userspace have one struct where cpu/seq and whatever is required for
> rseq is located and flag at register time which parts of the struct need to be
> updated.

If we put both cpu/seq/other in that structure, why not plan ahead and make
it extensible then ?

That looks very much like the "Thread-local ABI" series I posted last year.
See https://lkml.org/lkml/2015/12/22/464

Here is why I ended up introducing the specialized "getcpu_cache" system call
rather than the "generic" system call (quote from the getcpu_cache changelog):

    Rationale for the getcpu_cache system call rather than the thread-local
    ABI system call proposed earlier:
    
    Rather than doing a "generic" thread-local ABI, specialize this system
    call for a cpu number cache only. Anyway, the thread-local ABI approach
    would have required that we introduce "feature" flags, which would have
    ended up reimplementing multiplexing of features on top of a system
    call. It seems better to introduce one system call per feature instead.

If everyone end up preferring that we introduce a system call that implements
many features at once, that's indeed something we can do, but I remember
being told in the past that this is generally a bad idea.

For one thing, it would make the interface more cumbersome to deal with
from user-space in terms of feature detection: if we want to make this
interface extensible, in addition to check -1, errno=ENOSYS, userspace
would have to deal with a field containing the length of the structure
as expected by user-space and kernel, and feature flags to see the common
set of features supported by kernel and user-space.

Having one system call per feature seems simpler to handle in terms of
feature availability detection from a userspace point of view.

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
