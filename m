From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH v7 1/7] Restartable sequences system call
Date: Wed, 10 Aug 2016 21:01:22 +0000 (UTC)
Message-ID: <1327322278.7807.1470862882633.JavaMail.zimbra@efficios.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com> <20160803131940.GM6862@twins.programming.kicks-ass.net> <656745027.6624.1470773200334.JavaMail.zimbra@efficios.com> <CALCETrUTpq6qX5SS170y_VtwiPc-SeR03bt-1Q98n+YMZMqopA@mail.gmail.com> <2007752038.7515.1470855891561.JavaMail.zimbra@efficios.com> <CALCETrW-aNG5AOiRi01jnZrLm5h8u3BqT1v+2_LGWf7JohEm2g@mail.gmail.com> <1224101037.7764.1470859581723.JavaMail.zimbra@efficios.com> <CALCETrUrMG0zNxEcYR8cPjG0A9p7TCrLLQmLGqmRzuqVy=pXUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrUrMG0zNxEcYR8cPjG0A9p7TCrLLQmLGqmRzuqVy=pXUQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Boqun Feng <boqun.feng@gmail.com>
List-Id: linux-api@vger.kernel.org

----- On Aug 10, 2016, at 4:09 PM, Andy Lutomirski luto@amacapital.net wrote:

> On Wed, Aug 10, 2016 at 1:06 PM, Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

<snip>

>>> u64 is a perfectly valid, if odd, userspace pointer on all
>>> architecures that I know of, and it's certainly a valid userspace
>>> pointer on x86 32-bit userspace (the high bits will just all be zero).
>>> Can you just use u64?
>>
>> My concern is about a 32-bit user-space putting garbage rather than zeroes
>> (on purpose) to fool the kernel on those upper 32 bits. Doing
>>
>>   compat_ptr((compat_uptr_t)rseq_cs.start_ip)
>>
>> effectively ends up clearing the upper 32 bits.
>>
>> But since we only use those pointer values for comparisons, perhaps we
>> just don't care if a 32-bit userspace app try to shoot itself in
>> the foot by passing garbage upper 32 bits ?
>>
> 
> How is garbage in the high bits any different than garbage in any
> other bits in there?

It's not :)

> 
>>
>>> If this would be a performance problem on ARM, then maybe that's a
>>> reason to use compat helpers.
>>
>> We already use 64-bit values for the pointers, even on 32-bit. Normally
>> userspace just puts zeroes in the top bits. It's mostly a question of
>> clearing the top 32 bits or not when loading them in the kernel. If we
>> don't need to, then I can remove the compat code entirely, and we don't
>> care about user_64bit_mode() anymore, as you initially recommended.
>> Does it make sense ?
> 
> Yes, I think so.  I'd suggest just honoring all the bits.

OK, will do !

> 
>>
>>>
>>>>
>>>>>
>>>>>
>>>>>>>> +SYSCALL_DEFINE2(rseq, struct rseq __user *, rseq, int, flags)
>>>>>>>> +{
>>>>>>>> +    if (unlikely(flags))
>>>>>>>> +            return -EINVAL;
>>>>>>>
>>>>>>> (add whitespace)
>>>>>>
>>>>>> fixed.
>>>>>>
>>>>>>>
>>>>>>>> +    if (!rseq) {
>>>>>>>> +            if (!current->rseq)
>>>>>>>> +                    return -ENOENT;
>>>>>>>> +            return 0;
>>>>>>>> +    }
>>>>>
>>>>> This looks entirely wrong.  Setting rseq to NULL fails if it's already
>>>>> NULL but silently does nothing if rseq is already set?  Surely it
>>>>> should always succeed and it should actually do something if rseq is
>>>>> set.
>>>>
>>>> From the proposed rseq(2) manpage:
>>>>
>>>> "A NULL rseq value can be used to check whether rseq is registered
>>>> for the current thread."
>>>>
>>>> The implementation does just that: it returns -1, errno=ENOENT if no
>>>> rseq is currently registered, or 0 if rseq is currently registered.
>>>
>>> I think that's problematic.  Why can't you unregister an existing
>>> rseq?  If you can't, how is a thread supposed to clean up after
>>> itself?
>>>
>>
>> Unregistering an existing thread rseq would require that we keep reference
>> counting, in case multiple libs and/or the app are using rseq. I am
>> trying to keep things as simple as needed.
>>
>> If I understand your concern, the problematic scenario would be at
>> thread exit (this is my current approximate understanding of glibc
>> handling of library TLS variable reclaim at thread exit):
>>
>> thread exits in userspace:
>> - glibc frees its rseq TLS memory area (in case the TLS is in a library),
>> - thread preempted before really exiting,
>> - kernel reads/writes to freed TLS memory.
>>   - corruption may occur (e.g. memory re-allocated by another thread already)
>>
>> Am I getting it right ?
> 
> Yes.

Hrm, then we should:

- add a rseq_refcount field to the task struct,
- increment this refcount whenever rseq receives a registration, after
  ensuring that we are registering the same address as was previously
  requested by preceding registrations for the thread (except if the
  refcount was 0),
- When rseq receives a NULL address, decrement refcount. Set address to
  NULL when it reaches 0.

Doing the refcounting in kernel-space rather than user-space allows us to
keep both registration/unregistration and refcount atomic, which simplify
things if we plan to use rseq from signal handlers.

With current glibc, a library that would lazily register and use rseq
without knowledge of the application would then have to use pthread_key_create()
to set a destr_function to run at thread exit, which would take care of
unregistration.

We could add a RSEQ_FORCE_UNREGISTER flag to rseq flags to allow future
glibc versions to force unregistering rseq before freeing its TLS memory,
just in case a userspace library omits to unregister itself.

Thoughts ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
