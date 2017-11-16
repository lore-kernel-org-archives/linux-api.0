From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v11 for 4.15 01/24] Restartable sequences system
 call
Date: Thu, 16 Nov 2017 20:37:58 +0000 (UTC)
Message-ID: <1083699948.16848.1510864678185.JavaMail.zimbra@efficios.com>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com> <20171114200414.2188-2-mathieu.desnoyers@efficios.com> <20171116191448.rmds347hwsyibipm@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171116191448.rmds347hwsyibipm-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will>
List-Id: linux-api@vger.kernel.org

----- On Nov 16, 2017, at 2:14 PM, Peter Zijlstra peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org wrote:

> On Tue, Nov 14, 2017 at 03:03:51PM -0500, Mathieu Desnoyers wrote:
>> +static bool rseq_update_cpu_id(struct task_struct *t)
>> +{
>> +	uint32_t cpu_id = raw_smp_processor_id();
>> +
>> +	if (__put_user(cpu_id, &t->rseq->cpu_id_start))
>> +		return false;
>> +	if (__put_user(cpu_id, &t->rseq->cpu_id))
>> +		return false;
> 
> For LP64 this _could_ be a single 64bit store, right? It would save some
> stac/clac noise on x86_64.

Yes it could, but last time I checked a __put_user of a u64
did not guarantee single-copy atomicity of each of the two
32-bit words on 32-bit architectures, so I figured that it
would be better to postpone that optimization to a point
where architectures would provide a u64 __put_user that
guarantee single-copy atomicity of each 32-bit word on 32-bit
architectures.

> 
>> +	trace_rseq_update(t);
>> +	return true;
>> +}
> 
>> +static bool rseq_get_rseq_cs(struct task_struct *t,
> 
> bool return value, but is used as a C int error value later (it works,
> but is inconsistent).

I can do the following on the caller side instead:

        if (!rseq_get_rseq_cs(t, &start_ip, &post_commit_offset, &abort_ip,
                        &cs_flags))
                return -EFAULT;


> 
>> +		void __user **start_ip,
>> +		unsigned long *post_commit_offset,
>> +		void __user **abort_ip,
>> +		uint32_t *cs_flags)
> 
> That's a fair amount of arguments, and I suppose that isn't a problem
> because there's only the one callsite and it all gets inlined anyway.

Yep.

> 
>> +{
>> +	unsigned long ptr;
>> +	struct rseq_cs __user *urseq_cs;
>> +	struct rseq_cs rseq_cs;
>> +	u32 __user *usig;
>> +	u32 sig;
>> +
>> +	if (__get_user(ptr, &t->rseq->rseq_cs))
>> +		return false;
>> +	if (!ptr)
>> +		return true;
>> +	urseq_cs = (struct rseq_cs __user *)ptr;
>> +	if (copy_from_user(&rseq_cs, urseq_cs, sizeof(rseq_cs)))
>> +		return false;
>> +	/*
>> +	 * We need to clear rseq_cs upon entry into a signal handler
>> +	 * nested on top of a rseq assembly block, so the signal handler
>> +	 * will not be fixed up if itself interrupted by a nested signal
>> +	 * handler or preempted.  We also need to clear rseq_cs if we
>> +	 * preempt or deliver a signal on top of code outside of the
>> +	 * rseq assembly block, to ensure that a following preemption or
>> +	 * signal delivery will not try to perform a fixup needlessly.
>> +	 */
>> +	if (clear_user(&t->rseq->rseq_cs, sizeof(t->rseq->rseq_cs)))
>> +		return false;
>> +	if (rseq_cs.version > 0)
>> +		return false;
> 
>> +	*cs_flags = rseq_cs.flags;
>> +	*start_ip = (void __user *)rseq_cs.start_ip;
>> +	*post_commit_offset = (unsigned long)rseq_cs.post_commit_offset;
>> +	*abort_ip = (void __user *)rseq_cs.abort_ip;
> 
>> +	usig = (u32 __user *)(rseq_cs.abort_ip - sizeof(u32));
>> +	if (get_user(sig, usig))
>> +		return false;
> 

ok for adding newlines.

>> +	if (current->rseq_sig != sig) {
>> +		printk_ratelimited(KERN_WARNING
>> +			"Possible attack attempt. Unexpected rseq signature 0x%x, expecting 0x%x
>> (pid=%d, addr=%p).\n",
>> +			sig, current->rseq_sig, current->pid, usig);
>> +		return false;
>> +	}
>> +	return true;
>> +}
>> +
>> +static int rseq_need_restart(struct task_struct *t, uint32_t cs_flags)
>> +{
>> +	bool need_restart = false;
>> +	uint32_t flags;
>> +
>> +	/* Get thread flags. */
>> +	if (__get_user(flags, &t->rseq->flags))
>> +		return -EFAULT;
>> +
>> +	/* Take into account critical section flags. */
>> +	flags |= cs_flags;
>> +
>> +	/*
>> +	 * Restart on signal can only be inhibited when restart on
>> +	 * preempt and restart on migrate are inhibited too. Otherwise,
>> +	 * a preempted signal handler could fail to restart the prior
>> +	 * execution context on sigreturn.
>> +	 */
>> +	if (flags & RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL) {
>> +		if (!(flags & RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE))
>> +			return -EINVAL;
>> +		if (!(flags & RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT))
>> +			return -EINVAL;
>> +	}
>> +	if (t->rseq_migrate
>> +			&& !(flags & RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE))
> 
> That's a horrible code form, please put the && at the end of the
> previous line and begin the next line aligned with the (, like:
> 
>	if (t->rseq_migrate &&
>	    !(flags & RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE))
> 
> Luckily you've already killed this code, but try and remember for a next
> time ;-)

I usually never space-align with open parenthesis "(". Is it a coding
style requirement of the kernel for multi-line if () conditions ?

Would the following replatement code be ok ?

        if (unlikely(flags & RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL)) {
                if ((flags & (RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE
                                | RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT)) !=
                                (RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE
                                | RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT))
                        return -EINVAL;
        }
        event_mask = t->rseq_event_mask;
        t->rseq_event_mask = 0;
        event_mask &= ~flags;
        if (event_mask)
                return 1;
        return 0;

I'm uneasy with the wall of text caused by the flags. And based on
your comment, I should align on the if ( parenthesis. Style improvement
ideas are welcome. An alternative would be:

        if (unlikely(flags & RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL)) {
                if ((flags & (RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE
                    | RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT)) !=
                    (RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE
                     | RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT))
                        return -EINVAL;
        }
[...]

> 
>> +		need_restart = true;
>> +	else if (t->rseq_preempt
>> +			&& !(flags & RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT))
>> +		need_restart = true;
>> +	else if (t->rseq_signal
>> +			&& !(flags & RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL))
>> +		need_restart = true;
>> +
>> +	t->rseq_preempt = false;
>> +	t->rseq_signal = false;
>> +	t->rseq_migrate = false;
>> +	if (need_restart)
>> +		return 1;
>> +	return 0;
>> +}
>> +
>> +static int rseq_ip_fixup(struct pt_regs *regs)
>> +{
>> +	struct task_struct *t = current;
>> +	void __user *start_ip = NULL;
>> +	unsigned long post_commit_offset = 0;
>> +	void __user *abort_ip = NULL;
>> +	uint32_t cs_flags = 0;
>> +	int ret;
> 
>	unsigned long ip = instruction_pointer(regs);

ok

> 
>> +
>> +	ret = rseq_get_rseq_cs(t, &start_ip, &post_commit_offset, &abort_ip,
>> +			&cs_flags);
>	trace_rseq_ip_fixup((void __user *)ip,
>> +		start_ip, post_commit_offset, abort_ip, ret);
> 
> Why trace here and not right before/after instruction_pointer_set()?

Good point. Tracing right before instruction_pointer_set() would make sense.
I can remove the "ret" parameter too.

> 
>> +	if (!ret)
>> +		return -EFAULT;
>> +
>> +	ret = rseq_need_restart(t, cs_flags);
>> +	if (ret < 0)
>> +		return -EFAULT;
>> +	if (!ret)
>> +		return 0;
>> +	/*
>> +	 * Handle potentially not being within a critical section.
>> +	 * Unsigned comparison will be true when
>> +	 * ip < start_ip (wrap-around to large values), and when
>> +	 * ip >= start_ip + post_commit_offset.
>> +	 */
>> +	if ((unsigned long)instruction_pointer(regs) - (unsigned long)start_ip
>> +			>= post_commit_offset)
> 
>	if ((unsigned long)(ip - start_ip) >= post_commit_offset)

Now that both ip and start_ip are unsigned long, I simply can do:


if (ip - start_ip >= post_commit_offset)
  ...

> 
>> +		return 1;
>> +
>> +	instruction_pointer_set(regs, (unsigned long)abort_ip);
> 
> Since you only ever use abort_ip as unsigned long, why propagate this
> "void __user *" all the way from rseq_get_rseq_cs() ? Save yourself some
> typing and casts :-)

Will do, I'll use unsigned long instead,

Thanks!

Mathieu


> 
>> +	return 1;
> > +}

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
