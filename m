From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC PATCH v7 1/7] Restartable sequences system call
Date: Wed, 10 Aug 2016 12:16:03 -0700
Message-ID: <CALCETrW-aNG5AOiRi01jnZrLm5h8u3BqT1v+2_LGWf7JohEm2g@mail.gmail.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1469135662-31512-2-git-send-email-mathieu.desnoyers@efficios.com>
 <20160803131940.GM6862@twins.programming.kicks-ass.net> <656745027.6624.1470773200334.JavaMail.zimbra@efficios.com>
 <CALCETrUTpq6qX5SS170y_VtwiPc-SeR03bt-1Q98n+YMZMqopA@mail.gmail.com> <2007752038.7515.1470855891561.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2007752038.7515.1470855891561.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Boqun Feng <boqun.feng@gmail.com>
List-Id: linux-api@vger.kernel.org

On Wed, Aug 10, 2016 at 12:04 PM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
> ----- On Aug 10, 2016, at 4:10 AM, Andy Lutomirski luto@amacapital.net wrote:
>
>> On Tue, Aug 9, 2016 at 1:06 PM, Mathieu Desnoyers
>> <mathieu.desnoyers@efficios.com> wrote:
>
> <snip>
>
>>> Actually, we want copy_from_user() there. This executes upon
>>> resume to user-space, so we can take a page fault is needed, so
>>> no "inatomic" needed. I therefore suggest:
>>
>> Running the code below via exit_to_usermode_loop...
>>
>>>
>>> static bool rseq_get_rseq_cs(struct task_struct *t,
>>>                 void __user **start_ip,
>>>                 void __user **post_commit_ip,
>>>                 void __user **abort_ip)
>>> {
>>>         unsigned long ptr;
>>>         struct rseq_cs __user *urseq_cs;
>>>         struct rseq_cs rseq_cs;
>>>
>>>         if (__get_user(ptr, &t->rseq->rseq_cs))
>>>                 return false;
>>>         if (!ptr)
>>>                 return true;
>>> #ifdef CONFIG_COMPAT
>>>         if (in_compat_syscall()) {
>>>                 urseq_cs = compat_ptr((compat_uptr_t)ptr);
>>>                 if (copy_from_user(&rseq_cs, urseq_cs, sizeof(*rseq_cs)))
>>>                         return false;
>>>                 *start_ip = compat_ptr((compat_uptr_t)rseq_cs.start_ip);
>>>                 *post_commit_ip = compat_ptr((compat_uptr_t)rseq_cs.post_commit_ip);
>>>                 *abort_ip = compat_ptr((compat_uptr_t)rseq_cs.abort_ip);
>>>                 return true;
>>>         }
>>> #endif
>>
>> ...means that in_compat_syscall() is nonsense.  (It *works* there, but
>> I can't imagine that it does anything that is actually sensible for
>> this use.)
>
> Agreed that we are not per-se in a system call here. It works for
> in_ia32_syscall(), but it may not work for in_x32_syscall().
>
> Then should we test for this ?
>
> if (!is_64bit_mm(current->mm))
>
> This is currently x86-specific. Is this how we are expected to test
> the user-space pointer size in the current mm in arch-agnostic code ?
> If so, we should implement is_64bit_mm() on all other architectures.

There is no universal concept of the user-space pointer size on x86
because x86 code can change it via long jumps.

What are you actually trying to do?  I would guess that
user_64bit_mode(regs) is the right thing here, because the rseq data
structure is describing the currently executing code.

>
>>
>> Can't you just define the ABI so that no compat junk is needed?
>> (Also, CRIU will thank you for doing that.)
>
> We are dealing with user-space pointers here, so AFAIU we need to
> be aware of their size, which involves compat code. Am I missing
> something ?

u64 is a perfectly valid, if odd, userspace pointer on all
architecures that I know of, and it's certainly a valid userspace
pointer on x86 32-bit userspace (the high bits will just all be zero).
Can you just use u64?

If this would be a performance problem on ARM, then maybe that's a
reason to use compat helpers.

>
>>
>>
>>>>> +SYSCALL_DEFINE2(rseq, struct rseq __user *, rseq, int, flags)
>>>>> +{
>>>>> +    if (unlikely(flags))
>>>>> +            return -EINVAL;
>>>>
>>>> (add whitespace)
>>>
>>> fixed.
>>>
>>>>
>>>>> +    if (!rseq) {
>>>>> +            if (!current->rseq)
>>>>> +                    return -ENOENT;
>>>>> +            return 0;
>>>>> +    }
>>
>> This looks entirely wrong.  Setting rseq to NULL fails if it's already
>> NULL but silently does nothing if rseq is already set?  Surely it
>> should always succeed and it should actually do something if rseq is
>> set.
>
> From the proposed rseq(2) manpage:
>
> "A NULL rseq value can be used to check whether rseq is registered
> for the current thread."
>
> The implementation does just that: it returns -1, errno=ENOENT if no
> rseq is currently registered, or 0 if rseq is currently registered.

I think that's problematic.  Why can't you unregister an existing
rseq?  If you can't, how is a thread supposed to clean up after
itself?

--Andy
