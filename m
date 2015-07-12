From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [RFC PATCH] getcpu_cache system call: caching current CPU number
 (x86)
Date: Sun, 12 Jul 2015 11:47:30 -0700
Message-ID: <20150712184730.GD18191@x>
References: <1436724386-30909-1-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1436724386-30909-1-git-send-email-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, Jul 12, 2015 at 02:06:26PM -0400, Mathieu Desnoyers wrote:
> Expose a new system call allowing threads to register a userspace memory
> area where to store the current CPU number. Scheduler migration sets the
> TIF_NOTIFY_RESUME flag on the current thread. Upon return to user-space,
> a notify-resume handler updates the current CPU value within that
> user-space memory area.
> 
> This getcpu cache is an alternative to the sched_getcpu() vdso which has
> a few benefits:
> - It is faster to do a memory read that to call a vDSO,
> - This cache value can be read from within an inline assembly, which
>   makes it a useful building block for restartable sequences.
> 
> This approach is inspired by Paul Turner and Andrew Hunter's work
> on percpu atomics, which lets the kernel handle restart of critical
> sections:
> Ref.:
> * https://lkml.org/lkml/2015/6/24/665
> * https://lwn.net/Articles/650333/
> * http://www.linuxplumbersconf.org/2013/ocw/system/presentations/1695/original/LPC%20-%20PerCpu%20Atomics.pdf
> 
> Benchmarking sched_getcpu() vs tls cache approach. Getting the
> current CPU number:
> 
> - With Linux vdso:            12.7 ns
> - With TLS-cached cpu number:  0.3 ns

Nice.  One comment below about an interesting assumption that needs
confirmation.

> --- /dev/null
> +++ b/kernel/getcpu-cache.c
[...]
> +void getcpu_cache_handle_notify_resume(struct task_struct *t)
> +{
> +	int32_t __user *gcp = t->getcpu_cache;
> +
> +	if (gcp == NULL)
> +		return;
> +	if (unlikely(t->flags & PF_EXITING))
> +		return;
> +	/*
> +	 * access_ok() of gcp_user has already been checked by
> +	 * sys_getcpu_cache().
> +	 */
> +	if (__put_user(raw_smp_processor_id(), gcp))
> +		force_sig(SIGSEGV, current);
> +}
> +
> +/*
> + * If parent process has a getcpu_cache, the child inherits. Only
> + * applies when forking a process, not a thread.
> + */
> +void getcpu_cache_fork(struct task_struct *t)
> +{
> +	t->getcpu_cache = current->getcpu_cache;
> +}
> +
> +void getcpu_cache_execve(struct task_struct *t)
> +{
> +	t->getcpu_cache = NULL;
> +}
> +
> +/*
> + * sys_getcpu_cache - setup getcpu cache for caller thread
> + */
> +SYSCALL_DEFINE2(getcpu_cache, int32_t __user *, gcp, int, flags)
> +{
> +	if (flags)
> +		return -EINVAL;
> +	if (gcp != NULL && !access_ok(VERIFY_WRITE, gcp, sizeof(int32_t)))
> +		return -EFAULT;
> +	current->getcpu_cache = gcp;

So, you store a userspace address, and intentionally only validate it
when initially set, not when used.  You clear it on exec, though not on
fork.  Could any cases other than exec could make this problematic?  In
particular, what about unusual personality flags, such as
ADDR_LIMIT_32BIT or ADDR_LIMIT_3GB?

> +	/* Will update *gcp on resume */
> +	if (gcp)

Minor nit: you're using the pointer as a boolean here, but comparing it
to NULL elsewhere; you should be consistent.  I'd suggest consistently
using gcp and !gcp, without the comparison to NULL.

- Josh Triplett
