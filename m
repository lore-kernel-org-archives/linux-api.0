From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v7 1/7] Restartable sequences system call
Date: Wed, 10 Aug 2016 19:04:51 +0000 (UTC)
Message-ID: <2007752038.7515.1470855891561.JavaMail.zimbra@efficios.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com> <1469135662-31512-2-git-send-email-mathieu.desnoyers@efficios.com> <20160803131940.GM6862@twins.programming.kicks-ass.net> <656745027.6624.1470773200334.JavaMail.zimbra@efficios.com> <CALCETrUTpq6qX5SS170y_VtwiPc-SeR03bt-1Q98n+YMZMqopA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrUTpq6qX5SS170y_VtwiPc-SeR03bt-1Q98n+YMZMqopA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Aug 10, 2016, at 4:10 AM, Andy Lutomirski luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org wrote:

> On Tue, Aug 9, 2016 at 1:06 PM, Mathieu Desnoyers
> <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:

<snip>

>> Actually, we want copy_from_user() there. This executes upon
>> resume to user-space, so we can take a page fault is needed, so
>> no "inatomic" needed. I therefore suggest:
> 
> Running the code below via exit_to_usermode_loop...
> 
>>
>> static bool rseq_get_rseq_cs(struct task_struct *t,
>>                 void __user **start_ip,
>>                 void __user **post_commit_ip,
>>                 void __user **abort_ip)
>> {
>>         unsigned long ptr;
>>         struct rseq_cs __user *urseq_cs;
>>         struct rseq_cs rseq_cs;
>>
>>         if (__get_user(ptr, &t->rseq->rseq_cs))
>>                 return false;
>>         if (!ptr)
>>                 return true;
>> #ifdef CONFIG_COMPAT
>>         if (in_compat_syscall()) {
>>                 urseq_cs = compat_ptr((compat_uptr_t)ptr);
>>                 if (copy_from_user(&rseq_cs, urseq_cs, sizeof(*rseq_cs)))
>>                         return false;
>>                 *start_ip = compat_ptr((compat_uptr_t)rseq_cs.start_ip);
>>                 *post_commit_ip = compat_ptr((compat_uptr_t)rseq_cs.post_commit_ip);
>>                 *abort_ip = compat_ptr((compat_uptr_t)rseq_cs.abort_ip);
>>                 return true;
>>         }
>> #endif
> 
> ...means that in_compat_syscall() is nonsense.  (It *works* there, but
> I can't imagine that it does anything that is actually sensible for
> this use.)

Agreed that we are not per-se in a system call here. It works for
in_ia32_syscall(), but it may not work for in_x32_syscall().

Then should we test for this ?

if (!is_64bit_mm(current->mm))

This is currently x86-specific. Is this how we are expected to test
the user-space pointer size in the current mm in arch-agnostic code ?
If so, we should implement is_64bit_mm() on all other architectures.

> 
> Can't you just define the ABI so that no compat junk is needed?
> (Also, CRIU will thank you for doing that.)

We are dealing with user-space pointers here, so AFAIU we need to
be aware of their size, which involves compat code. Am I missing
something ?

> 
> 
>>>> +SYSCALL_DEFINE2(rseq, struct rseq __user *, rseq, int, flags)
>>>> +{
>>>> +    if (unlikely(flags))
>>>> +            return -EINVAL;
>>>
>>> (add whitespace)
>>
>> fixed.
>>
>>>
>>>> +    if (!rseq) {
>>>> +            if (!current->rseq)
>>>> +                    return -ENOENT;
>>>> +            return 0;
>>>> +    }
> 
> This looks entirely wrong.  Setting rseq to NULL fails if it's already
> NULL but silently does nothing if rseq is already set?  Surely it
> should always succeed and it should actually do something if rseq is
> set.

>From the proposed rseq(2) manpage:

"A NULL rseq value can be used to check whether rseq is registered
for the current thread."

The implementation does just that: it returns -1, errno=ENOENT if no
rseq is currently registered, or 0 if rseq is currently registered.

Thanks,

Mathieu


> 
> 
> --
> Andy Lutomirski
> AMA Capital Management, LLC

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
