From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [RFC PATCH v11 for 4.15 01/24] Restartable sequences system
 call
Date: Thu, 16 Nov 2017 22:08:03 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1711162042520.2109@nanos>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com> <20171114200414.2188-2-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114200414.2188-2-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, 14 Nov 2017, Mathieu Desnoyers wrote:
> +#ifdef __KERNEL__
> +# include <linux/types.h>
> +#else	/* #ifdef __KERNEL__ */

Please drop these comments. They are distracting and not helpful at
all. They are valuable for long #ideffed sections but then the normal form
is:

 /* __KERNEL__ */
 
 /* !__KERNEL__ */

> +# include <stdint.h>
> +#endif	/* #else #ifdef __KERNEL__ */
> +
> +#include <asm/byteorder.h>
> +
> +#ifdef __LP64__
> +# define RSEQ_FIELD_u32_u64(field)			uint64_t field
> +# define RSEQ_FIELD_u32_u64_INIT_ONSTACK(field, v)	field = (intptr_t)v
> +#elif defined(__BYTE_ORDER) ? \
> +	__BYTE_ORDER == __BIG_ENDIAN : defined(__BIG_ENDIAN)

Can you please make this decision separate and propagate the result ?

> +# define RSEQ_FIELD_u32_u64(field)	uint32_t field ## _padding, field
> +# define RSEQ_FIELD_u32_u64_INIT_ONSTACK(field, v)	\
> +	field ## _padding = 0, field = (intptr_t)v
> +#else
> +# define RSEQ_FIELD_u32_u64(field)	uint32_t field, field ## _padding
> +# define RSEQ_FIELD_u32_u64_INIT_ONSTACK(field, v)	\
> +	field = (intptr_t)v, field ## _padding = 0
> +#endif
> +
> +enum rseq_flags {
> +	RSEQ_FLAG_UNREGISTER = (1 << 0),
> +};
> +
> +enum rseq_cs_flags {
> +	RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT	= (1U << 0),
> +	RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL	= (1U << 1),
> +	RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE	= (1U << 2),
> +};
> +
> +/*
> + * struct rseq_cs is aligned on 4 * 8 bytes to ensure it is always
> + * contained within a single cache-line. It is usually declared as
> + * link-time constant data.
> + */
> +struct rseq_cs {
> +	uint32_t version;	/* Version of this structure. */
> +	uint32_t flags;		/* enum rseq_cs_flags */
> +	RSEQ_FIELD_u32_u64(start_ip);
> +	RSEQ_FIELD_u32_u64(post_commit_offset);	/* From start_ip */
> +	RSEQ_FIELD_u32_u64(abort_ip);
> +} __attribute__((aligned(4 * sizeof(uint64_t))));
> +
> +/*
> + * struct rseq is aligned on 4 * 8 bytes to ensure it is always
> + * contained within a single cache-line.
> + *
> + * A single struct rseq per thread is allowed.
> + */
> +struct rseq {
> +	/*
> +	 * Restartable sequences cpu_id_start field. Updated by the
> +	 * kernel, and read by user-space with single-copy atomicity
> +	 * semantics. Aligned on 32-bit. Always contain a value in the

contains

> +	 * range of possible CPUs, although the value may not be the
> +	 * actual current CPU (e.g. if rseq is not initialized). This
> +	 * CPU number value should always be confirmed against the value
> +	 * of the cpu_id field.

Who is supposed to confirm that? I think I know what the purpose of the
field is, but from that comment it's not obvious at all.

> +	 */
> +	uint32_t cpu_id_start;
> +	/*
> +	 * Restartable sequences cpu_id field. Updated by the kernel,
> +	 * and read by user-space with single-copy atomicity semantics.

Again. What's the purpose of reading it. 

> +	 * Aligned on 32-bit. Values -1U and -2U have a special
> +	 * semantic: -1U means "rseq uninitialized", and -2U means "rseq
> +	 * initialization failed".
> +	 */
> +	uint32_t cpu_id;
> +	/*
> +	 * Restartable sequences rseq_cs field.
> +	 *
> +	 * Contains NULL when no critical section is active for the current
> +	 * thread, or holds a pointer to the currently active struct rseq_cs.
> +	 *
> +	 * Updated by user-space at the beginning of assembly instruction
> +	 * sequence block, and by the kernel when it restarts an assembly
> +	 * instruction sequence block, and when the kernel detects that it
> +	 * is preempting or delivering a signal outside of the range
> +	 * targeted by the rseq_cs. Also needs to be cleared by user-space
> +	 * before reclaiming memory that contains the targeted struct
> +	 * rseq_cs.

This paragraph is pretty convoluted and it's not really clear what the
actual purpose is and how it is supposed to be used.

   It's NULL when no critical section is active.

   It holds a pointer to a struct rseq_cs when a critical section is active. Fine

Now the update rules:

    - By user space at the start of the critical section, i.e. user space
      sets the pointer to rseq_cs

    - By the kernel when it restarts a sequence block etc ....

      What happens to this field? Is the pointer updated or cleared or
      what? How is the kernel supposed to fiddle with the pointer?

> +	 *
> +	 * Read and set by the kernel with single-copy atomicity semantics.

This looks like it's purely kernel owned, but above you say it's written by
user space. There are no rules for user space?

> +	 * Aligned on 64-bit.
> +	 */
> +	RSEQ_FIELD_u32_u64(rseq_cs);
> +	/*
> +	 * - RSEQ_DISABLE flag:
> +	 *
> +	 * Fallback fast-track flag for single-stepping.
> +	 * Set by user-space if lack of progress is detected.
> +	 * Cleared by user-space after rseq finish.
> +	 * Read by the kernel.
> +	 * - RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT
> +	 *     Inhibit instruction sequence block restart and event
> +	 *     counter increment on preemption for this thread.
> +	 * - RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL
> +	 *     Inhibit instruction sequence block restart and event
> +	 *     counter increment on signal delivery for this thread.
> +	 * - RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE
> +	 *     Inhibit instruction sequence block restart and event
> +	 *     counter increment on migration for this thread.

That looks dangerous. You want to single step through the critical section
and just ignore whether you've been preempted or migrated. How is that
supposed to work?

> +++ b/kernel/rseq.c
> @@ -0,0 +1,328 @@
> + * Detailed algorithm of rseq user-space assembly sequences:
> + *
> + *   Steps [1]-[3] (inclusive) need to be a sequence of instructions in
> + *   userspace that can handle being moved to the abort_ip between any
> + *   of those instructions.

A sequence of instructions cannot be moved. Please describe this in
technical correct wording.

> + *   The abort_ip address needs to be less than start_ip, or
> + *   greater-or-equal the post_commit_ip. Step [5] and the failure

s/the/than/

> + *   code step [F1] need to be at addresses lesser than start_ip, or
> + *   greater-or-equal the post_commit_ip.

Please describe that block visually for clarity

		init(rseq_cs)
		cpu = TLS->rseq::cpu_id
       
start_ip	-----------------
[1]		TLS->rseq::rseq_cs = rseq_cs
		barrier()

[2]		if (cpu != TLS->rseq::cpu_id)
			goto fail_ip;

[3]		last_instruction_in_cs()
post_commit_ip  ----------------

The address of jump target fail_ip must be outside the critical region, i.e.

    fail_ip < start_ip  ||	 fail_ip >= post_commit_ip

Some textual explanation along with that is certainly helpful, but.

> + *       [start_ip]
> + *   1.  Userspace stores the address of the struct rseq_cs assembly
> + *       block descriptor into the rseq_cs field of the registered
> + *       struct rseq TLS area. This update is performed through a single
> + *       store, followed by a compiler barrier which prevents the
> + *       compiler from moving following loads or stores before this
> + *       store.
> + *
> + *   2.  Userspace tests to see whether the current cpu_id field
> + *       match the cpu number loaded before start_ip. Manually jumping
> + *       to [F1] in case of a mismatch.

  Manually jumping?

> + *
> + *       Note that if we are preempted or interrupted by a signal

Up to this point the description was technical, Now you start to
impersonate. That's inconsistent at best.

> + *       after [1] and before post_commit_ip, then the kernel

How does the kernel know about being "after" [1]. Is there something else
than start_ip and post_commit_id? According to this, yes. And that wants a
name and wants to be shown in the visual block. I call it magic_ip for now.

> + *       clears the rseq_cs field of struct rseq, then jumps us to
> + *       abort_ip.

The kernel does not jump us.

    	    If the execution sequence gets preempted at an address >=
    	    magic_ip and < post_commit_ip, the kernel sets
    	    TLS->rseq::rseq_cs to NULL and sets the user space return ip to
    	    fail_ip before returning to user space, so the preempted
    	    execution resumes at fail_ip.

Hmm?

> + *   3.  Userspace critical section final instruction before
> + *       post_commit_ip is the commit. The critical section is
> + *       self-terminating.
> + *       [post_commit_ip]
> + *
> + *   4.  success
> + *
> + *   On failure at [2]:
> + *
> + *       [abort_ip]

Now you introduce abort_ip. Why not use the same terminology consistently?
Because it would make sense and not confuse the reader?

> + *   F1. goto failure label
> + */
> +
> +static bool rseq_update_cpu_id(struct task_struct *t)
> +{
> +	uint32_t cpu_id = raw_smp_processor_id();
> +
> +	if (__put_user(cpu_id, &t->rseq->cpu_id_start))
> +		return false;
> +	if (__put_user(cpu_id, &t->rseq->cpu_id))
> +		return false;
> +	trace_rseq_update(t);
> +	return true;
> +}
> +
> +static bool rseq_reset_rseq_cpu_id(struct task_struct *t)
> +{
> +	uint32_t cpu_id_start = 0, cpu_id = -1U;

Please do not use -1U. Define a proper symbol for it. Hardcoded constant
numbers which have a special measing are annoying.

> +	/*
> +	 * Reset cpu_id_start to its initial state (0).
> +	 */
> +	if (__put_user(cpu_id_start, &t->rseq->cpu_id_start))
> +		return false;

Why bool? If the callsite propagates an error code return it right from
here please.

> +	/*
> +	 * Reset cpu_id to -1U, so any user coming in after unregistration can
> +	 * figure out that rseq needs to be registered again.
> +	 */
> +	if (__put_user(cpu_id, &t->rseq->cpu_id))
> +		return false;
> +	return true;
> +}
> +
> +static bool rseq_get_rseq_cs(struct task_struct *t,
> +		void __user **start_ip,
> +		unsigned long *post_commit_offset,
> +		void __user **abort_ip,
> +		uint32_t *cs_flags)

Please align the arguments with the argument in the first line

> +{
> +	unsigned long ptr;
> +	struct rseq_cs __user *urseq_cs;
> +	struct rseq_cs rseq_cs;
> +	u32 __user *usig;
> +	u32 sig;

Please sort those variables by length in reverse fir tree order.

> +
> +	if (__get_user(ptr, &t->rseq->rseq_cs))
> +		return false;

Call site stores an int and then returns -EFAULT. Works, but pretty is
something else.

> +	if (!ptr)
> +		return true;

What's wrong with 0 / -ERRORCODE returns which are the standard way in the
kernel?

> +	urseq_cs = (struct rseq_cs __user *)ptr;
> +	if (copy_from_user(&rseq_cs, urseq_cs, sizeof(rseq_cs)))
> +		return false;
> +	/*
> +	 * We need to clear rseq_cs upon entry into a signal handler
> +	 * nested on top of a rseq assembly block, so the signal handler
> +	 * will not be fixed up if itself interrupted by a nested signal
> +	 * handler or preempted.

This sentence does not parse.

> +	   We also need to clear rseq_cs if we
> +	 * preempt or deliver a signal on top of code outside of the
> +	 * rseq assembly block, to ensure that a following preemption or
> +	 * signal delivery will not try to perform a fixup needlessly.

Please try to avoid the impersonation. We are not doing anything.

> +	 */
> +	if (clear_user(&t->rseq->rseq_cs, sizeof(t->rseq->rseq_cs)))
> +		return false;
> +	if (rseq_cs.version > 0)
> +		return false;
> +	*cs_flags = rseq_cs.flags;
> +	*start_ip = (void __user *)rseq_cs.start_ip;
> +	*post_commit_offset = (unsigned long)rseq_cs.post_commit_offset;
> +	*abort_ip = (void __user *)rseq_cs.abort_ip;
> +	usig = (u32 __user *)(rseq_cs.abort_ip - sizeof(u32));

Is there no way to avoid this abundant type casting?  It's hard to find the
code in the casts.

> +	if (get_user(sig, usig))
> +		return false;
> +	if (current->rseq_sig != sig) {
> +		printk_ratelimited(KERN_WARNING
> +			"Possible attack attempt. Unexpected rseq signature 0x%x, expecting 0x%x (pid=%d, addr=%p).\n",
> +			sig, current->rseq_sig, current->pid, usig);
> +		return false;
> +	}
> +	return true;
> +}
> +
> +static int rseq_need_restart(struct task_struct *t, uint32_t cs_flags)
> +{
> +	bool need_restart = false;
> +	uint32_t flags;
> +
> +	/* Get thread flags. */
> +	if (__get_user(flags, &t->rseq->flags))
> +		return -EFAULT;
> +
> +	/* Take into account critical section flags. */

Take critical section flags into account. Please

> +	flags |= cs_flags;
> +
> +	/*
> +	 * Restart on signal can only be inhibited when restart on
> +	 * preempt and restart on migrate are inhibited too. Otherwise,
> +	 * a preempted signal handler could fail to restart the prior
> +	 * execution context on sigreturn.
> +	 */
> +	if (flags & RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL) {
> +		if (!(flags & RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE))
> +			return -EINVAL;
> +		if (!(flags & RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT))
> +			return -EINVAL;
> +	}
> +	if (t->rseq_migrate
> +			&& !(flags & RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE))

	if (t->rseq_migrate &&
	    !(flags & RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE))

please.

> +		need_restart = true;
> +	else if (t->rseq_preempt
> +			&& !(flags & RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT))
> +		need_restart = true;
> +	else if (t->rseq_signal
> +			&& !(flags & RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL))
> +		need_restart = true;

If you make all of these rseq_flags explicit bits in a u32 then you can
just do a simple

     	if ((t->rseq_flags ^ flags) & t->rseq_flags)

and you can probably simplify the above checks as well.

> +
> +	t->rseq_preempt = false;
> +	t->rseq_signal = false;
> +	t->rseq_migrate = false;

This becomes a simple t->rseq_flags = 0;

> +	if (need_restart)
> +		return 1;
> +	return 0;

Why are you having a bool in the first place if you have to convert it into
a integer return value at the end. Sure the compiler can optimize that
away, but still...

> +}
> +
> +static int rseq_ip_fixup(struct pt_regs *regs)
> +{
> +	struct task_struct *t = current;
> +	void __user *start_ip = NULL;
> +	unsigned long post_commit_offset = 0;
> +	void __user *abort_ip = NULL;
> +	uint32_t cs_flags = 0;
> +	int ret;
> +
> +	ret = rseq_get_rseq_cs(t, &start_ip, &post_commit_offset, &abort_ip,
> +			&cs_flags);
> +	trace_rseq_ip_fixup((void __user *)instruction_pointer(regs),
> +		start_ip, post_commit_offset, abort_ip, ret);
> +	if (!ret)
> +		return -EFAULT;

This boolean logic is really horrible.

> +	ret = rseq_need_restart(t, cs_flags);
> +	if (ret < 0)
> +		return -EFAULT;

Why can't you propagate ret?

> +	if (!ret)
> +		return 0;
> +	/*
> +	 * Handle potentially not being within a critical section.
> +	 * Unsigned comparison will be true when
> +	 * ip < start_ip (wrap-around to large values), and when
> +	 * ip >= start_ip + post_commit_offset.
> +	 */
> +	if ((unsigned long)instruction_pointer(regs) - (unsigned long)start_ip
> +			>= post_commit_offset)

Neither start_ip nor abort_ip need to be void __user * type. They are not
accessed at all, So why not make them unsigned long and spare all the type
cast mess here and in rseq_get_rseq_cs() ?

> +		return 1;
> +
> +	instruction_pointer_set(regs, (unsigned long)abort_ip);
> +	return 1;
> +}
> +
> +/*
> + * This resume handler should always be executed between any of:

Should? Or must?

> + * - preemption,
> + * - signal delivery,
> + * and return to user-space.
> + *
> +	if (current->rseq) {
> +		/*
> +		 * If rseq is already registered, check whether
> +		 * the provided address differs from the prior
> +		 * one.
> +		 */
> +		if (current->rseq != rseq
> +				|| current->rseq_len != rseq_len)

Align as shown above please. Same for all other malformatted multi line
conditionals.

> +			return -EINVAL;
> +		if (current->rseq_sig != sig)
> +			return -EPERM;
> +		return -EBUSY;	/* Already registered. */

Please do not use tail comments. They disturb the reading flow.

> +	} else {
> +		/*
> +		 * If there was no rseq previously registered,
> +		 * we need to ensure the provided rseq is

s/we need to//  Like in changelogs. Describe it in imperative mood.

> +		 * properly aligned and valid.
> +		 */
> +		if (!IS_ALIGNED((unsigned long)rseq, __alignof__(*rseq))
> +				|| rseq_len != sizeof(*rseq))
> +			return -EINVAL;
> +		if (!access_ok(VERIFY_WRITE, rseq, rseq_len))
> +			return -EFAULT;
> +		current->rseq = rseq;
> +		current->rseq_len = rseq_len;
> +		current->rseq_sig = sig;
> +		/*
> +		 * If rseq was previously inactive, and has just been
> +		 * registered, ensure the cpu_id_start and cpu_id fields
> +		 * are updated before returning to user-space.
> +		 */
> +		rseq_set_notify_resume(current);
> +	}

Thanks,

	tglx
