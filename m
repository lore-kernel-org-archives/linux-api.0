From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH 0/3] restartable sequences: fast user-space percpu
 critical sections
Date: Fri, 26 Jun 2015 01:15:50 +0000 (UTC)
Message-ID: <842897619.3710.1435281350583.JavaMail.zimbra@efficios.com>
References: <20150624222609.6116.86035.stgit@kitami.mtv.corp.google.com> <CALCETrXAtYDZBbpwZceFyhLOnqFmTDqTxhGfbrrVrY+34cxSFg@mail.gmail.com> <CAPM31R+GUtD_9S+m7U0DGpeqSCT1n98bvQ0NUOwMHX7-CoKigQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPM31R+GUtD_9S+m7U0DGpeqSCT1n98bvQ0NUOwMHX7-CoKigQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Jun 24, 2015, at 10:54 PM, Paul Turner pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org wrote:

> On Wed, Jun 24, 2015 at 5:07 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>> On Wed, Jun 24, 2015 at 3:26 PM, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>>> This is a fairly small series demonstrating a feature we've found to be quite
>>> powerful in practice, "restartable sequences".
>>>
>>
>> On an extremely short glance, I'm starting to think that the right
>> approach, at least for x86, is to implement per-cpu gsbase.  Then you
>> could do cmpxchg with a gs prefix to atomically take a percpu lock and
>> atomically release a percpu lock and check whether someone else stole
>> the lock from you.  (Note: cmpxchg, unlike lock cmpxchg, is very
>> fast.)
>>
>> This is totally useless for other architectures, but I think it would
>> be reasonable clean on x86.  Thoughts?
> 
> So this gives semantics that are obviously similar to this_cpu().
> This provides allows reasonable per-cpu counters (which is alone
> almost sufficient for a strong user-space RCU implementation giving
> this some legs).
> 
> However, unless there's a nice implementation trick I'm missing, the
> thing that stands out to me for locks (or other primitives) is that
> this forces a two-phase commit.  There's no way (short of say,
> cmpxchg16b) to perform a write conditional on the lock not having been
> stolen from us (and subsequently release the lock).
> 
> e.g.
> 1) We take the operation in some sort of speculative mode, that
> another thread on the same cpu is stilled allowed to steal from us
> 2) We prepare what we want to commit
> 3) At this point we have to promote the lock taken in (1) to perform
> our actual commit, or see that someone else has stolen (1)
> 4) Release the promoted lock in (3)
> 
> However, this means that if we're preempted at (3) then no other
> thread on that cpu can make progress until we've been rescheduled and
> released the lock; a nice property of the model we have today is that
> threads sharing a cpu can not impede each other beyond what the
> scheduler allows.
> 
> A lesser concern, but worth mentioning, is that there are also
> potential pitfalls in the interaction with signal handlers,
> particularly if a 2-phase commit is used.

Assuming we have a gs segment we can use to address per-cpu locks
in userspace, would the following scheme take care of some of your
concerns ?

per-cpu int32_t: each lock initialized to "cpu_nr" value

per-cpu lock:
  get current cpu number. Remember this value as "CPU lock nr".
  use cmpxchg on gs:lock to grab the lock.
  - Expect old value to be "CPU lock nr".
  - Update with a lock flag in most significant bit, "CPU lock nr"
    in lower bits.
  - Retry if fails. Can be caused by migration or lock being already
    held.

per-cpu unlock:
  clear lock flag within the "CPU lock nr" lock.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
