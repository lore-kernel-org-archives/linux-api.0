From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v7 03/11] task_isolation: support PR_TASK_ISOLATION_STRICT mode
Date: Mon, 28 Sep 2015 16:51:49 -0400
Message-ID: <CALCETrU7bheOSeuE8RxATBiyzQ=sPAC4jbXsqvZHgu8-5FY0zg@mail.gmail.com>
References: <1443453446-7827-1-git-send-email-cmetcalf@ezchip.com> <1443453446-7827-4-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443453446-7827-4-git-send-email-cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Cc: Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Sep 28, 2015 at 11:17 AM, Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org> wrote:
> With task_isolation mode, the task is in principle guaranteed not to
> be interrupted by the kernel, but only if it behaves.  In particular,
> if it enters the kernel via system call, page fault, or any of a
> number of other synchronous traps, it may be unexpectedly exposed
> to long latencies.  Add a simple flag that puts the process into
> a state where any such kernel entry is fatal; this is defined as
> happening immediately after the SECCOMP test.

Why after seccomp?  Seccomp is still an entry, and the code would be
considerably simpler if it were before seccomp.

> @@ -35,8 +36,12 @@ static inline enum ctx_state exception_enter(void)
>                 return 0;
>
>         prev_ctx = this_cpu_read(context_tracking.state);
> -       if (prev_ctx != CONTEXT_KERNEL)
> -               context_tracking_exit(prev_ctx);
> +       if (prev_ctx != CONTEXT_KERNEL) {
> +               if (context_tracking_exit(prev_ctx)) {
> +                       if (task_isolation_strict())
> +                               task_isolation_exception();
> +               }
> +       }
>
>         return prev_ctx;
>  }

x86 does not promise to call this function.  In fact, x86 is rather
likely to stop ever calling this function in the reasonably near
future.

> --- a/kernel/context_tracking.c
> +++ b/kernel/context_tracking.c
> @@ -144,15 +144,16 @@ NOKPROBE_SYMBOL(context_tracking_user_enter);
>   * This call supports re-entrancy. This way it can be called from any exception
>   * handler without needing to know if we came from userspace or not.
>   */
> -void context_tracking_exit(enum ctx_state state)
> +bool context_tracking_exit(enum ctx_state state)

This needs clear documentation of what the return value means.

> +static void kill_task_isolation_strict_task(void)
> +{
> +       /* RCU should have been enabled prior to this point. */
> +       RCU_LOCKDEP_WARN(!rcu_is_watching(), "kernel entry without RCU");
> +
> +       dump_stack();
> +       current->task_isolation_flags &= ~PR_TASK_ISOLATION_ENABLE;
> +       send_sig(SIGKILL, current, 1);
> +}

Wasn't this supposed to be configurable?  Or is that something that
happens later on in the series?

> +
> +/*
> + * This routine is called from syscall entry (with the syscall number
> + * passed in) if the _STRICT flag is set.
> + */
> +void task_isolation_syscall(int syscall)
> +{
> +       /* Ignore prctl() syscalls or any task exit. */
> +       switch (syscall) {
> +       case __NR_prctl:
> +       case __NR_exit:
> +       case __NR_exit_group:
> +               return;
> +       }
> +
> +       pr_warn("%s/%d: task_isolation strict mode violated by syscall %d\n",
> +               current->comm, current->pid, syscall);
> +       kill_task_isolation_strict_task();
> +}

Ick.  I guess it works, but this is still quite ugly IMO.

> +void task_isolation_exception(void)
> +{
> +       pr_warn("%s/%d: task_isolation strict mode violated by exception\n",
> +               current->comm, current->pid);
> +       kill_task_isolation_strict_task();
> +}

Should this say what exception?

--Andy
