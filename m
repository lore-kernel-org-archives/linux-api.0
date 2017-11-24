From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH for 4.15 v12 00/22] Restartable sequences and CPU op
 vector
Date: Fri, 24 Nov 2017 00:04:34 +0000 (UTC)
Message-ID: <1589826840.21401.1511481874141.JavaMail.zimbra@efficios.com>
References: <20171121141900.18471-1-mathieu.desnoyers@efficios.com> <740195164.19702.1511301908907.JavaMail.zimbra@efficios.com> <20171122193219.GI3165@worktop.lehotels.local> <20171122193734.GO22648@arm.com> <165707648.21250.1511471721845.JavaMail.zimbra@efficios.com> <alpine.DEB.2.20.1711232346030.2364@nanos> <739755311.21380.1511478071883.JavaMail.zimbra@efficios.com> <alpine.DEB.2.20.1711240026480.2364@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1711240026480.2364@nanos>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin
List-Id: linux-api@vger.kernel.org

----- On Nov 23, 2017, at 6:38 PM, Thomas Gleixner tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org wrote:

> On Thu, 23 Nov 2017, Mathieu Desnoyers wrote:
>> ----- On Nov 23, 2017, at 5:51 PM, Thomas Gleixner tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org wrote:
>> > On Thu, 23 Nov 2017, Mathieu Desnoyers wrote:
>> >> ----- On Nov 22, 2017, at 2:37 PM, Will Deacon will.deacon-5wv7dgnIgG8@public.gmane.org wrote:
>> >> > On Wed, Nov 22, 2017 at 08:32:19PM +0100, Peter Zijlstra wrote:
>> >> >>
>> >> >> So what exactly is the problem of leaving out the whole cpu_opv thing
>> >> >> for now? Pure rseq is usable -- albeit a bit cumbersome without
>> >> >> additional debugger support.
>> >> > 
>> >> > Drive-by "ack" to that. I'd really like a working rseq implementation in
>> >> > mainline, but I don't much care for another interpreter.
>> >> 
>> >> Considering the arm 64 use-case of reading PMU counters from user-space
>> >> using rseq to prevent migration, I understand that you're lucky enough to
>> >> already have a system call at your disposal that can perform the slow-path
>> >> in case of single-stepping.
>> >> 
>> >> So yes, your particular case is already covered, but unfortunately that's
>> >> not the same situation for other use-cases that have been expressed.
>> > 
>> > If we have users of rseq which can do without the other muck, then what's
>> > the reason not to support it?
>> > 
>> > The sysops thing can be sorted out on top and the use cases which need both
>> > will have to test for both syscalls being available anyway.
>> 
>> I'm currently making sure CONFIG_RSEQ selects both CONFIG_CPU_OPV and
>> CONFIG_MEMBARRIER, so the user-space fast-paths don't end up with
>> various ways of doing the fallback/single-stepping/memory barrier handling
>> depending on whether the kernel support each of those individually.
>> So first of all, it reduces complexity from a user-space perspective.
>>
>> Moreover, with a single already needed cpu_id vs cpu_id_start field comparison
>> in the rseq fast-path, user-space knows that it can rely on having rseq,
>> cpu_opv, and membarrier. Without this guarantee, user-space would have to
>> detect individually whether each of those system calls is available, and
>> test flags on the fast-path, for additional overhead.
> 
> You have to test for sys_rseq somewhere in the init code. So you can test
> for the other two being fully functional as well.
> 
> If one of them is missing then you can avoid that rseq fastpath either
> completely or because you never registered that rseq muck your rseq will
> just contain stale init data which kicks you into some slowpath fallback
> code.

That would work if we could have more than one rseq TLS entry per thread.
If it would be the case, then e.g. lttng-ust could own its own rseq
TLS and do just as you explain above.

It's not the case with the current proposal. This means multiple user
libraries will have to share the same cpu_id and cpu_id_start fields,
which breaks your proposed new-app/old-kernel backward compatibility
check proposal.

For instance, if glibc librseq.so happily registers rseq (and does not
care about testing for cpu_opv or membarrier availability), then
lttng-ust cannot leave stale rseq init data which kicks in its slowpath
fallback.

> 
> You need something like this anyway unless you plan to ship code which
> cannot run on systems w/o rseq support at all.

My plan is to ensure that testing for

  (TLS::rseq->cpu_id_start == TLS::rseq->cpu_id)

should be enough for fast-paths to guarantee that:

- rseq is available and registered for the current thread,
- cpu_opv is available as fallback,
- membarrier private_expedited and shared_expedited are available.

> 
> Either you designed your thing wrong or you try to create an artifical
> dependency for political reasons.

Having the rseq TLS shared across multiple library/app users within a
single process does limit our options there. :-/

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
