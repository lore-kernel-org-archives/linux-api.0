From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] getcpu_cache system call: cache CPU number of
 running thread
Date: Tue, 5 Jan 2016 22:34:04 +0000 (UTC)
Message-ID: <1777488643.338535.1452033244991.JavaMail.zimbra@efficios.com>
References: <1451977320-4886-1-git-send-email-mathieu.desnoyers@efficios.com> <1451977320-4886-2-git-send-email-mathieu.desnoyers@efficios.com> <20160105120400.GD10705@arm.com> <1079064730.338115.1452015105259.JavaMail.zimbra@efficios.com> <20160105174017.GY19062@n2100.arm.linux.org.uk> <20160105214717.GE3818@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160105214717.GE3818-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Jan 5, 2016, at 4:47 PM, Paul E. McKenney paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org wrote:

> On Tue, Jan 05, 2016 at 05:40:18PM +0000, Russell King - ARM Linux wrote:
>> On Tue, Jan 05, 2016 at 05:31:45PM +0000, Mathieu Desnoyers wrote:
>> > For instance, an application could create a linked list or hash map
>> > of thread control structures, which could contain the current CPU
>> > number of each thread. A dispatch thread could then traverse or
>> > lookup this structure to see on which CPU each thread is running and
>> > do work queue dispatch or scheduling decisions accordingly.
>> 
>> So, what happens if the linked list is walked from thread X, and we
>> discover that thread Y is allegedly running on CPU1.  We decide that
>> we want to dispatch some work on that thread due to it being on CPU1,
>> so we send an event to thread Y.
>> 
>> Thread Y becomes runnable, and the scheduler decides to schedule the
>> thread on CPU3 instead of CPU1.
>> 
>> My point is that the above idea is inherently racy.  The only case
>> where it isn't racy is when thread Y is bound to CPU1, and so can't
>> move - but then you'd know that thread Y is on CPU1 and there
>> wouldn't be a need for the inherent complexity suggested above.
>> 
>> The behaviour I've seen on ARM from the scheduler (on a quad CPU
>> platform, observing the system activity with top reporting the last
>> CPU number used by each thread) is that threads often migrate
>> between CPUs - especially in the case of (eg) one or two threads
>> running in a quad-CPU system.
>> 
>> Given that, I'm really not sure what the use of reading and making
>> decisions on the current CPU number would be within a program -
>> unless the thread is bound to a particular CPU or group of CPUs,
>> it seems that you can't rely on being on the reported CPU by the
>> time the system call returns.
> 
> As I understand it, the idea is -not- to eliminate synchronization
> like we do with per-CPU variables in the kernel, but rather to
> reduce the average cost of synchronization.  For example, there
> might be a separate data structure per CPU, each structure guarded
> by its own lock.  A thread could sample the current running CPU,
> acquire that CPU's corresponding lock, and operate on that CPU's
> structure.  This would work correctly even if there was an arbitrarily
> high number of preemptions/migrations, but would have improved
> performance (compared to a single global lock) in the common case
> where there were no preemptions/migrations.
> 
> This approach can also be used in conjunction with Paul Turner's
> per-CPU atomics.
> 
> Make sense, or am I missing your point?

Russell's point is more about accessing a given thread's cpu_cache
variable from other threads/cores, which is beyond what is needed
for restartable critical sections.

Independently of the usefulness of reading other thread's cpu_cache
to see their current CPU, I would advocate for checking the cpu_cache
natural alignment, and return EINVAL if it is not aligned. Even for
thread-local reads, we care about ensuring there is no load tearing
when reading this variable. The behavior of the kernel updating this
variable read by a user-space thread is very similar to having a
variable updated by a signal handler nested on top of a thread. This
makes it simpler and reduces the testing state space.

Thoughts ?

Thanks,

Mathieu

> 
> 							Thanx, Paul

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
