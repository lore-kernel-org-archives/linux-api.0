From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 08/11] membarrier: Provide core serializing command (v2)
Date: Mon, 29 Jan 2018 19:20:52 +0000 (UTC)
Message-ID: <579395772.11661.1517253652787.JavaMail.zimbra@efficios.com>
References: <20180123155733.3404-1-mathieu.desnoyers@efficios.com> <20180123155733.3404-9-mathieu.desnoyers@efficios.com> <20180129180414.GO2249@hirez.programming.kicks-ass.net> <20180129181529.GG2295@hirez.programming.kicks-ass.net> <485936677.11601.1517250965043.JavaMail.zimbra@efficios.com> <20180129190923.GP2249@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180129190923.GP2249-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, maged michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Russell King, ARM Linux" <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, David
List-Id: linux-api@vger.kernel.org

----- On Jan 29, 2018, at 2:09 PM, Peter Zijlstra peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org wrote:

> On Mon, Jan 29, 2018 at 06:36:05PM +0000, Mathieu Desnoyers wrote:
>> ----- On Jan 29, 2018, at 1:15 PM, Peter Zijlstra peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org wrote:
> 
>> > Aaah, its the case where we do not pass through switch_mm(), the partial
>> > comment got to me. I only realized after reading the next patch.
>> 
>> Indeed, if we read the entire comment, it's made clear that this case is for
>> when switch_mm is not invoked, where the current mm is changed without going
>> through switch_mm(), when scheduling between uthread->kthread->uthread for
>> instance.
>> 
>>         /*
>>          * When transitioning from a kernel thread to a userspace
>>          * thread, mmdrop()'s implicit full barrier is required by the
>>          * membarrier system call, because the current active_mm can
>>          * become the current mm without going through switch_mm().
>>          * membarrier also requires a core serializing instruction
>>          * before going back to user-space after storing to rq->curr.
>>          */
>> 
>> Is there something I should improve in the wording of this added
>> sentence to make it clearer ?
> 
> Can be improved I think, its got two unqualified "membarrier"s in and
> its a bit mixed up. I'm having a major case of the mondays (brain just
> won't start today), but maybe something like:
> 
>	When we switched through a kernel thread, the loop in
>	membarrier_{private,global}_expedited() can have observed that
>	kernel thread and not issued an IPI. We will also not pass
>	through switch_mm(). Membarrier requires a barrier after writing
>	rq->curr and returning to userspace, so provide them here:
> 
>	  - a full memory barrier for {PRIVATE,GLOBAL}_EXPEDITED
>	  - a sync_core for SYNC_CORE

Editing to remove use of "we" and clarify, which ends up as:

        /*
         * When switching through a kernel thread, the loop in
         * membarrier_{private,global}_expedited() may have observed that
         * kernel thread and not issued an IPI. It is therefore possible to
         * schedule between user->kernel->user threads without passing though
         * switch_mm(). Membarrier requires a barrier after storing to
         * rq->curr, before returning to userspace, so provide them here:
         *
         * - a full memory barrier for {PRIVATE,GLOBAL}_EXPEDITED, implicitly
         *   provided by mmdrop(),
         * - a sync_core for SYNC_CORE.
         */

> 
> Also I think changing the changlog to state where we need core-sync
> would be good. Currently the x86 patch does that, but not this one,
> while this introduces the feature.

Planning to add this:

Architectures selecting this feature need to either document that
they issue core serializing instructions when returning to user-space,
or implement their architecture-specific sync_core_before_usermode().

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
