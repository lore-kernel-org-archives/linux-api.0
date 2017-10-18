From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v9 for 4.15 01/14] Restartable sequences system call
Date: Wed, 18 Oct 2017 18:11:39 +0000 (UTC)
Message-ID: <515879378.43966.1508350299712.JavaMail.zimbra@efficios.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com> <20171012230326.19984-2-mathieu.desnoyers@efficios.com> <CY4PR15MB1688286D6B1283A1C234BAE6CF4E0@CY4PR15MB1688.namprd15.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CY4PR15MB1688286D6B1283A1C234BAE6CF4E0-ZVJ2su15u+xeX4ZvlgGe+Yd3EbNNOtPMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>
Cc: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Michael
List-Id: linux-api@vger.kernel.org

----- On Oct 18, 2017, at 12:41 PM, Ben Maurer bmaurer-b10kYP2dOMg@public.gmane.org wrote:

>> The layout of struct rseq_cs is as follows:
> 
>> start_ip
>> Instruction pointer address of the first instruction of the
>> sequence of consecutive assembly instructions.
> 
>> post_commit_ip
>> Instruction pointer address after the last  instruction  of
>>  the sequence of consecutive assembly instructions.
> 
>>  abort_ip
>> Instruction  pointer  address  where  to move the execution
>>  flow in case of abort of the sequence of consecutive assem‐
>>  bly instructions.
> 
> Really minor performance performance thought here.
> 
> 1) In the kernel at context switch time you'd need code like:
> 
> if (ip >= start_ip && ip <= post_commit_ip)
> 
> This branch would be hard to predict because most instruction pointers would be
> either before or after. If post_commit_ip were relative to start_ip you could
> do this:
> 
> if (ip - start_ip <= post_commit_offset)
> 
> which is a single branch that would be more predictable.

The actual context switch code only sets the "t->rseq_preempt"
flags and TIF_NOTIFY_RESUME. The user-accesses happen when
returning to user-space with TIF_NOTIFY_RESUME set.

Indeed, we can expect most context switch out of a registered
rseq thread to trigger one __rseq_handle_notify_resume on
return to user-space for that thread.

As you point out, the "common" case is *not* nested over a
critical section. This means t->rseq->rseq_cs is NULL.
This effectively means post_commit_ip and start_ip are NULL in
rseq_ip_fixup when compared to the current ip.

The check is currently implemented like this:

        /* Handle potentially not being within a critical section. */
        if ((void __user *)instruction_pointer(regs) >= post_commit_ip ||
                        (void __user *)instruction_pointer(regs) < start_ip)
                return 1;

So if non-nested over c.s., the first branch is ip >= NULL, which turns
out to be true, and we therefore return 1 from rseq_ip_fixup.

I suspect that we'd need to cast those pointers to (unsigned long) to
be strictly C standard compliant.

If we instead use "post_commit_offset" relative to start_ip, a non-nested
common case would have start_ip = NULL, post_commit_offset = 0. The check
you propose for not being nested over a c.s. would look like:

if (!((long)ip - (long)start_ip <= (long)post_commit_offset))
   return 1;

This introduces an issue here: if "ip" is lower than "start_ip", we
can incorrectly think we are in a critical section, when we are in
fact not.

With the previous approach proposed by Paul Turner, this was not an
issue, because he was setting the equivalent of the rseq_cs pointer
back to NULL at the end of the assembly fast-path. However, I have
a fast-path optimization that only sets the rseq_cs pointer at the
beginning of the fast-path, without clearing it afterward. It's up
to the following critical section to overwrite the rseq_cs pointer,
or to the kernel to set it back to NULL if it finds out that it is
preempting/delivering a signal over an instruction pointer outside
of the current rseq_cs start_ip/post_commit_ip range (lazy clear).

Moreover, this modification would add a subtraction on the common case
(ip - start_ip), and makes the ABI slightly uglier.

> 
> 2) In a shared library a rseq_cs structure would have to be relocated at runtime
> because at compilation time the final address of the library wouldn't be known.
> I'm not sure if this is important enough to address, but it could be solved by
> making the pointers relative to the address of rseq_cs. But this would make for
> an uglier API.

If I understand well, you are proposing to speed up .so load time by
means of removing relocations of pointers within rseq_cs, done by
making those relative to the rseq_cs address.

So the downside here is extra arithmetic operations on resume to
userspace (__rseq_handle_notify_resume): the kernel would have
to calculate the offset of start_ip and post_commit_ip from the
address of rseq_cs. Sure, we're only talking about two additions
there, but I don't think marginally speeding up library load
justifies extra work in that kernel path, nor the uglier ABI.

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
