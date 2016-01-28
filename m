From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [RFC PATCH v3 1/5] getcpu_cache system call: cache CPU number
 of running thread
Date: Thu, 28 Jan 2016 22:52:13 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1601282205290.3886@nanos>
References: <1454014885-29012-1-git-send-email-mathieu.desnoyers@efficios.com> <1454014885-29012-2-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454014885-29012-2-git-send-email-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 28 Jan 2016, Mathieu Desnoyers wrote:

> +static int __get_cpu_cache_ptr(int32_t __user **cpu_cache,

cpu_cache is __user ????

> +		int32_t __user * __user *cpu_cachep)
> +{
> +#ifdef CONFIG_COMPAT
> +	if (is_compat_task()) {
> +		compat_uptr_t *compat_cachep = (compat_uptr_t *) cpu_cachep;
> +		compat_uptr_t compat_cache;
> +
> +		if (get_user(compat_cache, compat_cachep))
> +			return -EFAULT;
> +		*cpu_cache = compat_ptr(compat_cache);

sparse should have told you that :)

> +		return 0;
> +	}
> +#endif
> +	return get_user(*cpu_cache, cpu_cachep);
> +}
> +
> +#define get_cpu_cache_ptr(cpu_cache, cpu_cachep)	\
> +	__get_cpu_cache_ptr(&(cpu_cache), cpu_cachep)
> +
> +static int put_cpu_cache_ptr(int32_t __user *cpu_cache,

Ditto

> +		int32_t __user * __user *cpu_cachep)
> +{
> +#ifdef CONFIG_COMPAT
> +	if (is_compat_task()) {
> +		compat_uptr_t compat_cache = ptr_to_compat(cpu_cache);
> +		compat_uptr_t *compat_cachep = (compat_uptr_t *) cpu_cachep;
> +
> +		return put_user(compat_cache, compat_cachep);
> +	}
> +#endif
> +	return put_user(cpu_cache, cpu_cachep);
> +}
> +		current->cpu_cache = cpu_cache;
> +		/*
> +		 * Migration checks the getcpu cache to see whether the
> +		 * notify_resume flag should be set.
> +		 * Therefore, we need to ensure that the scheduler sees
> +		 * the getcpu cache pointer update before we update the getcpu
> +		 * cache content with the current CPU number.
> +		 */
> +		barrier();

And how does that barrier ensure this? Not at all. And why would the scheduler
care? All the scheduler cares about is tsk->cpu_cache.

> +		/*
> +		 * Do an initial cpu cache update to ensure we won't hit
> +		 * SIGSEGV if put_user() fails in the resume notifier.
> +		 */

If you get migrated before that call, then you SIGSEGV nevertheless.

You need that call here for the case you are NOT migrated before returning to
user space because otherwise the variable is not updated.

If you want to verify that user address without a potential SIGSEGV, then you
need to do this before setting current->cpu_cache. You still need the update
after setting current->cpu_cache.

> +		if (getcpu_cache_update(cpu_cache)) {
> +			current->cpu_cache = NULL;
> +			return -EFAULT;
> +		}
> +		return 0;

Thanks,

	tglx
