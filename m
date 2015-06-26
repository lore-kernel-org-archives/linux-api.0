From: Paul Turner <pjt@google.com>
Subject: Re: [RFC PATCH 0/3] restartable sequences: fast user-space percpu
 critical sections
Date: Thu, 25 Jun 2015 19:05:35 -0700
Message-ID: <CAPM31RJwFJXjxLnwFMCBE1=wVXyU06ttrT-_fNr1rb=+ewxVrg@mail.gmail.com>
References: <20150624222609.6116.86035.stgit@kitami.mtv.corp.google.com>
 <CALCETrXAtYDZBbpwZceFyhLOnqFmTDqTxhGfbrrVrY+34cxSFg@mail.gmail.com>
 <CAPM31R+GUtD_9S+m7U0DGpeqSCT1n98bvQ0NUOwMHX7-CoKigQ@mail.gmail.com> <842897619.3710.1435281350583.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <842897619.3710.1435281350583.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Lai Jiangshan <laijs@cn.fujitsu.com>, linux-api <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Chris Lameter <cl@linux.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 25, 2015 at 6:15 PM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
> ----- On Jun 24, 2015, at 10:54 PM, Paul Turner pjt@google.com wrote:
>
>> On Wed, Jun 24, 2015 at 5:07 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> On Wed, Jun 24, 2015 at 3:26 PM, Paul Turner <pjt@google.com> wrote:
>>>> This is a fairly small series demonstrating a feature we've found to be quite
>>>> powerful in practice, "restartable sequences".
>>>>
>>>
>>> On an extremely short glance, I'm starting to think that the right
>>> approach, at least for x86, is to implement per-cpu gsbase.  Then you
>>> could do cmpxchg with a gs prefix to atomically take a percpu lock and
>>> atomically release a percpu lock and check whether someone else stole
>>> the lock from you.  (Note: cmpxchg, unlike lock cmpxchg, is very
>>> fast.)
>>>
>>> This is totally useless for other architectures, but I think it would
>>> be reasonable clean on x86.  Thoughts?
>>
>> So this gives semantics that are obviously similar to this_cpu().
>> This provides allows reasonable per-cpu counters (which is alone
>> almost sufficient for a strong user-space RCU implementation giving
>> this some legs).
>>
>> However, unless there's a nice implementation trick I'm missing, the
>> thing that stands out to me for locks (or other primitives) is that
>> this forces a two-phase commit.  There's no way (short of say,
>> cmpxchg16b) to perform a write conditional on the lock not having been
>> stolen from us (and subsequently release the lock).
>>
>> e.g.
>> 1) We take the operation in some sort of speculative mode, that
>> another thread on the same cpu is stilled allowed to steal from us
>> 2) We prepare what we want to commit
>> 3) At this point we have to promote the lock taken in (1) to perform
>> our actual commit, or see that someone else has stolen (1)
>> 4) Release the promoted lock in (3)
>>
>> However, this means that if we're preempted at (3) then no other
>> thread on that cpu can make progress until we've been rescheduled and
>> released the lock; a nice property of the model we have today is that
>> threads sharing a cpu can not impede each other beyond what the
>> scheduler allows.
>>
>> A lesser concern, but worth mentioning, is that there are also
>> potential pitfalls in the interaction with signal handlers,
>> particularly if a 2-phase commit is used.
>
> Assuming we have a gs segment we can use to address per-cpu locks
> in userspace, would the following scheme take care of some of your
> concerns ?
>
> per-cpu int32_t: each lock initialized to "cpu_nr" value
>
> per-cpu lock:
>   get current cpu number. Remember this value as "CPU lock nr".
>   use cmpxchg on gs:lock to grab the lock.
>   - Expect old value to be "CPU lock nr".
>   - Update with a lock flag in most significant bit, "CPU lock nr"
>     in lower bits.
>   - Retry if fails. Can be caused by migration or lock being already
>     held.

So this is equivalent to just taking the lock in a non-speculative
mode (e.g. non-stealable) from the start.

The challenge remains exactly the same, as soon as an exclusive mode
exists you have some 'critical' critical inner section about the
commit, which impedes the progress of other threads if interrupted.
[The only reason you'd take the lock in any sort of speculative mode
above would be to reduce the length of this.]

I definitely agree that this gets us locks and counters, there's lots
of good things we can do with those and those alone may be sufficient
to implement it this way but I feel there is a lot of power compared
to what can be done with full lockless semantics that this leaves on
the table.  As a concrete example, consider what this does to the
complexity and usefulness of Pop().

>
> per-cpu unlock:
>   clear lock flag within the "CPU lock nr" lock.
>
> Thanks,
>
> Mathieu
>
> --
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com
