From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC PATCH] getcpu_cache system call: caching current CPU number (x86)
Date: Sun, 12 Jul 2015 20:38:33 -0700
Message-ID: <CALCETrV1suAbvMgD1jOEFyn3JcDE_hhi6X7+sGs9e3Oqw_6jUw@mail.gmail.com>
References: <1436724386-30909-1-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436724386-30909-1-git-send-email-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Jul 12, 2015 12:06 PM, "Mathieu Desnoyers"
<mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>
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

Let's wait and see what the final percpu atomic solution is.  If it
involves percpu segments, then this is unnecessary.

Also, this will need to be rebased onto -tip, and that should wait
until the big exit rewrite is farther along.

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

This is a bit unfair, because the glibc wrapper sucks and the
__vdso_getcpu interface is overcomplicated.  We can fix it with a
better API.  It won't make it *that* much faster, though.

>
> diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
> index e504246..157cec0 100644
> --- a/arch/x86/kernel/signal.c
> +++ b/arch/x86/kernel/signal.c
> @@ -750,6 +750,8 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
>         if (thread_info_flags & _TIF_NOTIFY_RESUME) {
>                 clear_thread_flag(TIF_NOTIFY_RESUME);
>                 tracehook_notify_resume(regs);
> +               if (getcpu_cache_active(current))
> +                       getcpu_cache_handle_notify_resume(current);

We need to disentangle this stuff.  This is buried way too deeply here.

Fortunately, do_notify_resume is going away.  It's already unused on
64-bit kernels in -next.

> +/*
> + * This resume handler should always be executed between a migration
> + * triggered by preemption and return to user-space.
> + */
> +void getcpu_cache_handle_notify_resume(struct task_struct *t)
> +{
> +       int32_t __user *gcp = t->getcpu_cache;
> +
> +       if (gcp == NULL)
> +               return;
> +       if (unlikely(t->flags & PF_EXITING))
> +               return;
> +       /*
> +        * access_ok() of gcp_user has already been checked by
> +        * sys_getcpu_cache().
> +        */
> +       if (__put_user(raw_smp_processor_id(), gcp))
> +               force_sig(SIGSEGV, current);

We're preemptible here, although I think it's okay.  But I'd at least
clear the getcpu_cache state if __put_user fails, because otherwise
it's not entirely obvious to me that we can't infinite loop.

> +/*
> + * sys_getcpu_cache - setup getcpu cache for caller thread
> + */
> +SYSCALL_DEFINE2(getcpu_cache, int32_t __user *, gcp, int, flags)
> +{
> +       if (flags)
> +               return -EINVAL;
> +       if (gcp != NULL && !access_ok(VERIFY_WRITE, gcp, sizeof(int32_t)))
> +               return -EFAULT;
> +       current->getcpu_cache = gcp;
> +       /* Will update *gcp on resume */
> +       if (gcp)
> +               set_thread_flag(TIF_NOTIFY_RESUME);
> +       return 0;
> +}

IMO this is impolite.  If the pointer is bad, we should return -EFAULT
rather than sending SIGSEGV.

--Andy
