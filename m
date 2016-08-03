From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC PATCH v7 1/7] Restartable sequences system call
Date: Wed, 3 Aug 2016 15:19:40 +0200
Message-ID: <20160803131940.GM6862@twins.programming.kicks-ass.net>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1469135662-31512-2-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1469135662-31512-2-git-send-email-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 21, 2016 at 05:14:16PM -0400, Mathieu Desnoyers wrote:
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1209323..daef027 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5085,6 +5085,13 @@ M:	Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
>  S:	Maintained
>  F:	scripts/get_maintainer.pl
>  
> +RESTARTABLE SEQUENCES SUPPORT
> +M:	Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>

It would be good to have multiple people here, if we lack volunteers I'd
be willing. Paul, Andrew any of you guys willing?

> +L:	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> +S:	Supported
> +F:	kernel/rseq.c
> +F:	include/uapi/linux/rseq.h
> +
>  GFS2 FILE SYSTEM
>  M:	Steven Whitehouse <swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>  M:	Bob Peterson <rpeterso-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 253538f..5c4b900 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -59,6 +59,7 @@ struct sched_param {
>  #include <linux/gfp.h>
>  #include <linux/magic.h>
>  #include <linux/cgroup-defs.h>
> +#include <linux/rseq.h>
>  
>  #include <asm/processor.h>
>  
> @@ -1918,6 +1919,10 @@ struct task_struct {
>  #ifdef CONFIG_MMU
>  	struct task_struct *oom_reaper_list;
>  #endif
> +#ifdef CONFIG_RSEQ
> +	struct rseq __user *rseq;
> +	uint32_t rseq_event_counter;

This is kernel code, should we not use u32 instead?

Also, do we want a comment somewhere that explains why overflow isn't a
problem?

> +#endif
>  /* CPU-specific state of this task */
>  	struct thread_struct thread;
>  /*
> @@ -3387,4 +3392,67 @@ void cpufreq_add_update_util_hook(int cpu, struct update_util_data *data,
>  void cpufreq_remove_update_util_hook(int cpu);
>  #endif /* CONFIG_CPU_FREQ */
>  
> +#ifdef CONFIG_RSEQ
> +static inline void rseq_set_notify_resume(struct task_struct *t)
> +{
> +	if (t->rseq)
> +		set_tsk_thread_flag(t, TIF_NOTIFY_RESUME);
> +}

Maybe I missed it, but why do we want to hook into NOTIFY_RESUME and not
have our own TIF flag?


> diff --git a/include/uapi/linux/rseq.h b/include/uapi/linux/rseq.h
> new file mode 100644
> index 0000000..3e79fa9
> --- /dev/null
> +++ b/include/uapi/linux/rseq.h
> @@ -0,0 +1,85 @@
> +#ifndef _UAPI_LINUX_RSEQ_H
> +#define _UAPI_LINUX_RSEQ_H
> +
> +/*
> + * linux/rseq.h
> + *
> + * Restartable sequences system call API
> + *
> + * Copyright (c) 2015-2016 Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
> + *
> + * Permission is hereby granted, free of charge, to any person obtaining a copy
> + * of this software and associated documentation files (the "Software"), to deal
> + * in the Software without restriction, including without limitation the rights
> + * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> + * copies of the Software, and to permit persons to whom the Software is
> + * furnished to do so, subject to the following conditions:
> + *
> + * The above copyright notice and this permission notice shall be included in
> + * all copies or substantial portions of the Software.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> + * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> + * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#ifdef __KERNEL__
> +# include <linux/types.h>
> +#else	/* #ifdef __KERNEL__ */
> +# include <stdint.h>
> +#endif	/* #else #ifdef __KERNEL__ */
> +
> +#include <asm/byteorder.h>
> +
> +#ifdef __LP64__
> +# define RSEQ_FIELD_u32_u64(field)	uint64_t field
> +#elif defined(__BYTE_ORDER) ? \
> +	__BYTE_ORDER == __BIG_ENDIAN : defined(__BIG_ENDIAN)
> +# define RSEQ_FIELD_u32_u64(field)	uint32_t _padding ## field, field
> +#else
> +# define RSEQ_FIELD_u32_u64(field)	uint32_t field, _padding ## field
> +#endif
> +
> +struct rseq_cs {
> +	RSEQ_FIELD_u32_u64(start_ip);
> +	RSEQ_FIELD_u32_u64(post_commit_ip);
> +	RSEQ_FIELD_u32_u64(abort_ip);
> +} __attribute__((aligned(sizeof(uint64_t))));

Do we either want to grow that alignment to L1_CACHE_BYTES or place a
comment near that it would be best for performance to ensure the whole
thing fits into 1 line?

Alternatively, growing the alignment to 4*8 would probably be sufficient
to ensure that and waste less bytes.

> +struct rseq {
> +	union {
> +		struct {
> +			/*
> +			 * Restartable sequences cpu_id field.
> +			 * Updated by the kernel, and read by user-space with
> +			 * single-copy atomicity semantics. Aligned on 32-bit.
> +			 * Negative values are reserved for user-space.
> +			 */
> +			int32_t cpu_id;
> +			/*
> +			 * Restartable sequences event_counter field.
> +			 * Updated by the kernel, and read by user-space with
> +			 * single-copy atomicity semantics. Aligned on 32-bit.
> +			 */
> +			uint32_t event_counter;
> +		} e;
> +		/*
> +		 * On architectures with 64-bit aligned reads, both cpu_id and
> +		 * event_counter can be read with single-copy atomicity
> +		 * semantics.
> +		 */
> +		uint64_t v;
> +	} u;
> +	/*
> +	 * Restartable sequences rseq_cs field.
> +	 * Updated by user-space, read by the kernel with
> +	 * single-copy atomicity semantics. Aligned on 64-bit.
> +	 */
> +	RSEQ_FIELD_u32_u64(rseq_cs);
> +} __attribute__((aligned(sizeof(uint64_t))));

2*sizeof(uint64_t) ?

Also, I think it would be good to have a comment explaining why this is
split in two structures? Don't you rely on the address dependency?

> +#endif /* _UAPI_LINUX_RSEQ_H */

> diff --git a/kernel/rseq.c b/kernel/rseq.c
> new file mode 100644
> index 0000000..e1c847b
> --- /dev/null
> +++ b/kernel/rseq.c
> @@ -0,0 +1,231 @@

> +/*
> + * Each restartable sequence assembly block defines a "struct rseq_cs"
> + * structure which describes the post_commit_ip address, and the
> + * abort_ip address where the kernel should move the thread instruction
> + * pointer if a rseq critical section assembly block is preempted or if
> + * a signal is delivered on top of a rseq critical section assembly
> + * block. It also contains a start_ip, which is the address of the start
> + * of the rseq assembly block, which is useful to debuggers.
> + *
> + * The algorithm for a restartable sequence assembly block is as
> + * follows:
> + *
> + * rseq_start()
> + *
> + *   0. Userspace loads the current event counter value from the
> + *      event_counter field of the registered struct rseq TLS area,
> + *
> + * rseq_finish()
> + *
> + *   Steps [1]-[3] (inclusive) need to be a sequence of instructions in
> + *   userspace that can handle being moved to the abort_ip between any
> + *   of those instructions.
> + *
> + *   The abort_ip address needs to be equal or above the post_commit_ip.

Above, as in: abort_ip >= post_commit_ip? Would not 'after' or
greater-or-equal be easier to understand?

> + *   Step [4] and the failure code step [F1] need to be at addresses
> + *   equal or above the post_commit_ip.

idem.

> + *   1.  Userspace stores the address of the struct rseq cs rseq
> + *       assembly block descriptor into the rseq_cs field of the
> + *       registered struct rseq TLS area.

And this should be something like up-store-release, which would
basically be a regular store, but such that the compiler is restrained
from placing the stores to the structure itself later.

> + *
> + *   2.  Userspace tests to see whether the current event counter values
> + *       match those loaded at [0]. Manually jumping to [F1] in case of
> + *       a mismatch.
> + *
> + *       Note that if we are preempted or interrupted by a signal
> + *       after [1] and before post_commit_ip, then the kernel also
> + *       performs the comparison performed in [2], and conditionally
> + *       clears rseq_cs, then jumps us to abort_ip.
> + *
> + *   3.  Userspace critical section final instruction before
> + *       post_commit_ip is the commit. The critical section is
> + *       self-terminating.
> + *       [post_commit_ip]
> + *
> + *   4.  Userspace clears the rseq_cs field of the struct rseq
> + *       TLS area.
> + *
> + *   5.  Return true.
> + *
> + *   On failure at [2]:
> + *
> + *   F1. Userspace clears the rseq_cs field of the struct rseq
> + *       TLS area. Followed by step [F2].
> + *
> + *       [abort_ip]
> + *   F2. Return false.
> + */
> +
> +static int rseq_increment_event_counter(struct task_struct *t)
> +{
> +	if (__put_user(++t->rseq_event_counter,
> +			&t->rseq->u.e.event_counter))
> +		return -1;
> +	return 0;
> +}

this,

> +static int rseq_get_rseq_cs(struct task_struct *t,
> +		void __user **post_commit_ip,
> +		void __user **abort_ip)
> +{
> +	unsigned long ptr;
> +	struct rseq_cs __user *rseq_cs;
> +
> +	if (__get_user(ptr, &t->rseq->rseq_cs))
> +		return -1;
> +	if (!ptr)
> +		return 0;
> +#ifdef CONFIG_COMPAT
> +	if (in_compat_syscall()) {
> +		rseq_cs = compat_ptr((compat_uptr_t)ptr);
> +		if (get_user(ptr, &rseq_cs->post_commit_ip))
> +			return -1;
> +		*post_commit_ip = compat_ptr((compat_uptr_t)ptr);
> +		if (get_user(ptr, &rseq_cs->abort_ip))
> +			return -1;
> +		*abort_ip = compat_ptr((compat_uptr_t)ptr);
> +		return 0;
> +	}
> +#endif
> +	rseq_cs = (struct rseq_cs __user *)ptr;
> +	if (get_user(ptr, &rseq_cs->post_commit_ip))
> +		return -1;
> +	*post_commit_ip = (void __user *)ptr;
> +	if (get_user(ptr, &rseq_cs->abort_ip))
> +		return -1;

Given we want all 3 of those values in a single line and doing 3
get_user() calls ends up doing 3 pairs of STAC/CLAC, should we not use
either copy_from_user_inatomic or unsafe_get_user() paired with
user_access_begin/end() pairs.

> +	*abort_ip = (void __user *)ptr;
> +	return 0;
> +}

this and,

> +static int rseq_ip_fixup(struct pt_regs *regs)
> +{
> +	struct task_struct *t = current;
> +	void __user *post_commit_ip = NULL;
> +	void __user *abort_ip = NULL;
> +
> +	if (rseq_get_rseq_cs(t, &post_commit_ip, &abort_ip))
> +		return -1;
> +
> +	/* Handle potentially being within a critical section. */
> +	if ((void __user *)instruction_pointer(regs) < post_commit_ip) {

Alternatively you can do:

	if (likely(void __user *)instruction_pointer(regs) >= post_commit_ip)
		return 0;

and you can safe an indent level below.

> +		/*
> +		 * We need to clear rseq_cs upon entry into a signal
> +		 * handler nested on top of a rseq assembly block, so
> +		 * the signal handler will not be fixed up if itself
> +		 * interrupted by a nested signal handler or preempted.
> +		 */
> +		if (clear_user(&t->rseq->rseq_cs,
> +				sizeof(t->rseq->rseq_cs)))
> +			return -1;
> +
> +		/*
> +		 * We set this after potentially failing in
> +		 * clear_user so that the signal arrives at the
> +		 * faulting rip.
> +		 */
> +		instruction_pointer_set(regs, (unsigned long)abort_ip);
> +	}
> +	return 0;
> +}

this function look like it should return bool.

> +/*
> + * This resume handler should always be executed between any of:
> + * - preemption,
> + * - signal delivery,
> + * and return to user-space.
> + */
> +void __rseq_handle_notify_resume(struct pt_regs *regs)
> +{
> +	struct task_struct *t = current;
> +
> +	if (unlikely(t->flags & PF_EXITING))
> +		return;
> +	if (!access_ok(VERIFY_WRITE, t->rseq, sizeof(*t->rseq)))
> +		goto error;
> +	if (__put_user(raw_smp_processor_id(), &t->rseq->u.e.cpu_id))
> +		goto error;
> +	if (rseq_increment_event_counter(t))

It seems a shame to not use a single __put_user() here. You did the
layout to explicitly allow for this, but then you don't.

> +		goto error;
> +	if (rseq_ip_fixup(regs))
> +		goto error;
> +	return;
> +
> +error:
> +	force_sig(SIGSEGV, t);
> +}
> +
> +/*
> + * sys_rseq - setup restartable sequences for caller thread.
> + */
> +SYSCALL_DEFINE2(rseq, struct rseq __user *, rseq, int, flags)
> +{
> +	if (unlikely(flags))
> +		return -EINVAL;

(add whitespace)

> +	if (!rseq) {
> +		if (!current->rseq)
> +			return -ENOENT;
> +		return 0;
> +	}
> +
> +	if (current->rseq) {
> +		/*
> +		 * If rseq is already registered, check whether
> +		 * the provided address differs from the prior
> +		 * one.
> +		 */
> +		if (current->rseq != rseq)
> +			return -EBUSY;

Why explicitly allow resetting the same value?

> +	} else {
> +		/*
> +		 * If there was no rseq previously registered,
> +		 * we need to ensure the provided rseq is
> +		 * properly aligned and valid.
> +		 */
> +		if (!IS_ALIGNED((unsigned long)rseq, sizeof(uint64_t)))
> +			return -EINVAL;
> +		if (!access_ok(VERIFY_WRITE, rseq, sizeof(*rseq)))
> +			return -EFAULT;

GCC has __alignof__(struct rseq) for this. And as per the above, I would
recommend you change this to 2*sizeof(u64) to ensure the whole thing
fits in a single line.

> +		current->rseq = rseq;
> +		/*
> +		 * If rseq was previously inactive, and has just
> +		 * been registered, ensure the cpu_id and
> +		 * event_counter fields are updated before
> +		 * returning to user-space.
> +		 */
> +		rseq_set_notify_resume(current);
> +	}
> +
> +	return 0;
> +}
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 51d7105..fbef0c3 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2664,6 +2664,7 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
>  {
>  	sched_info_switch(rq, prev, next);
>  	perf_event_task_sched_out(prev, next);
> +	rseq_sched_out(prev);

One thing I considered is doing something like:

static inline void rseq_sched_out(struct task_struct *t)
{
	unsigned long ptr;
	int err;

	if (!t->rseq)
		return;

	err = __get_user(ptr, &t->rseq->rseq_cs);
	if (err || ptr)
		set_tsk_thread_flag(t, TIF_NOTIFY_RESUME);
}

That will optimistically try to read the rseq_cs pointer and, on success
and empty (the most likely case) avoid setting the TIF flag.

This will require an explicit migration hook to unconditionally set the
TIF flag such that we keep the cpu_id field correct of course.

And obviously we can do this later, as an optimization. Its just
something I figured might be worth it.

>  	fire_sched_out_preempt_notifiers(prev, next);
>  	prepare_lock_switch(rq, next);
>  	prepare_arch_switch(next);
