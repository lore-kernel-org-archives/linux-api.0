From: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH] percpu system call: fast userspace percpu critical sections
Date: Fri, 22 May 2015 22:26:14 +0200
Message-ID: <CAHO5Pa0Kok4_QN0v3JNWyzGT=GbZNZcRyLhu02R2npV9hSdt7g@mail.gmail.com>
References: <1432219487-13364-1-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432219487-13364-1-git-send-email-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[CC += linux-api@]

On Thu, May 21, 2015 at 4:44 PM, Mathieu Desnoyers
<mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
> Expose a new system call allowing userspace threads to register
> a TLS area used as an ABI between the kernel and userspace to
> share information required to create efficient per-cpu critical
> sections in user-space.
>
> This ABI consists of a thread-local structure containing:
>
> - a nesting count surrounding the critical section,
> - a signal number to be sent to the thread when preempting a thread
>   with non-zero nesting count,
> - a flag indicating whether the signal has been sent within the
>   critical section,
> - an integer where to store the current CPU number, updated whenever
>   the thread is preempted. This CPU number cache is not strictly
>   needed, but performs better than getcpu vdso.
>
> This approach is inspired by Paul Turner and Andrew Hunter's work
> on percpu atomics, which lets the kernel handle restart of critical
> sections, ref. http://www.linuxplumbersconf.org/2013/ocw/system/presentations/1695/original/LPC%20-%20PerCpu%20Atomics.pdf
>
> What is done differently here compared to percpu atomics: we track
> a single nesting counter per thread rather than many ranges of
> instruction pointer values. We deliver a signal to user-space and
> let the logic of restart be handled in user-space, thus moving
> the complexity out of the kernel. The nesting counter approach
> allows us to skip the complexity of interacting with signals that
> would be otherwise needed with the percpu atomics approach, which
> needs to know which instruction pointers are preempted, including
> when preemption occurs on a signal handler nested over an instruction
> pointer of interest.
>
> Advantages of this approach over percpu atomics:
> - kernel code is relatively simple: complexity of restart sections
>   is in user-space,
> - easy to port to other architectures: just need to reserve a new
>   system call,
> - for threads which have registered a TLS structure, the fast-path
>   at preemption is only a nesting counter check, along with the
>   optional store of the current CPU number, rather than comparing
>   instruction pointer with possibly many registered ranges,
>
> Caveats of this approach compared to the percpu atomics:
> - We need a signal number for this, so it cannot be done without
>   designing the application accordingly,
> - Handling restart in user-space is currently performed with page
>   protection, for which we install a SIGSEGV signal handler. Again,
>   this requires designing the application accordingly, especially
>   if the application installs its own segmentation fault handler,
> - It cannot be used for tracing of processes by injection of code
>   into their address space, due to interactions with application
>   signal handlers.
>
> The user-space proof of concept code implementing the restart section
> can be found here: https://github.com/compudj/percpu-dev
>
> Benchmarking sched_getcpu() vs tls cache approach. Getting the
> current CPU number:
>
> - With Linux vdso:            12.7 ns
> - With TLS-cached cpu number:  0.3 ns
>
> We will use the TLS-cached cpu number for the following
> benchmarks.
>
> On an Intel(R) Xeon(R) CPU E5-2630 v3 @ 2.40GHz, comparison
> with a baseline running very few load/stores (no locking,
> no getcpu, assuming one thread per CPU with affinity),
> against locking scheme based on "lock; cmpxchg", "cmpxchg"
> (using restart signal), load-store (using restart signal).
> This is performed with 32 threads on a 16-core, hyperthread
> system:
>
>                  ns/loop      overhead (ns)
> Baseline:          3.7           0.0
> lock; cmpxchg:    22.0          18.3
> cmpxchg:          11.1           7.4
> load-store:        9.4           5.7
>
> Therefore, the load-store scheme has a speedup of 3.2x over the
> "lock; cmpxchg" scheme if both are using the tls-cache for the
> CPU number. If we use Linux sched_getcpu() for "lock; cmpxchg"
> we reach of speedup of 5.4x for load-store+tls-cache vs
> "lock; cmpxchg"+vdso-getcpu.
>
> I'm sending this out to trigger discussion, and hopefully to see
> Paul and Andrew's patches being posted publicly at some point, so
> we can compare our approaches.
>
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
> CC: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> CC: Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> CC: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> CC: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> CC: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>
> CC: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
> CC: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> CC: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
> CC: Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
> CC: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> ---
>  arch/x86/syscalls/syscall_64.tbl  |   1 +
>  fs/exec.c                         |   1 +
>  include/linux/sched.h             |  18 ++++++
>  include/uapi/asm-generic/unistd.h |   4 +-
>  init/Kconfig                      |  10 +++
>  kernel/Makefile                   |   1 +
>  kernel/fork.c                     |   2 +
>  kernel/percpu-user.c              | 126 ++++++++++++++++++++++++++++++++++++++
>  kernel/sys_ni.c                   |   3 +
>  9 files changed, 165 insertions(+), 1 deletion(-)
>  create mode 100644 kernel/percpu-user.c
>
> diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
> index 8d656fb..0499703 100644
> --- a/arch/x86/syscalls/syscall_64.tbl
> +++ b/arch/x86/syscalls/syscall_64.tbl
> @@ -329,6 +329,7 @@
>  320    common  kexec_file_load         sys_kexec_file_load
>  321    common  bpf                     sys_bpf
>  322    64      execveat                stub_execveat
> +323    common  percpu                  sys_percpu
>
>  #
>  # x32-specific system call numbers start at 512 to avoid cache impact
> diff --git a/fs/exec.c b/fs/exec.c
> index c7f9b73..0a2f0b2 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1555,6 +1555,7 @@ static int do_execveat_common(int fd, struct filename *filename,
>         /* execve succeeded */
>         current->fs->in_exec = 0;
>         current->in_execve = 0;
> +       percpu_user_execve(current);
>         acct_update_integrals(current);
>         task_numa_free(current);
>         free_bprm(bprm);
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index a419b65..9c88bff 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1275,6 +1275,8 @@ enum perf_event_task_context {
>         perf_nr_task_contexts,
>  };
>
> +struct thread_percpu_user;
> +
>  struct task_struct {
>         volatile long state;    /* -1 unrunnable, 0 runnable, >0 stopped */
>         void *stack;
> @@ -1710,6 +1712,10 @@ struct task_struct {
>  #ifdef CONFIG_DEBUG_ATOMIC_SLEEP
>         unsigned long   task_state_change;
>  #endif
> +#ifdef CONFIG_PERCPU_USER
> +       struct preempt_notifier percpu_user_notifier;
> +       struct thread_percpu_user __user *percpu_user;
> +#endif
>  };
>
>  /* Future-safe accessor for struct task_struct's cpus_allowed. */
> @@ -3090,4 +3096,16 @@ static inline unsigned long rlimit_max(unsigned int limit)
>         return task_rlimit_max(current, limit);
>  }
>
> +#ifdef CONFIG_PERCPU_USER
> +void percpu_user_fork(struct task_struct *t);
> +void percpu_user_execve(struct task_struct *t);
> +#else
> +static inline void percpu_user_fork(struct task_struct *t)
> +{
> +}
> +static inline void percpu_user_execve(struct task_struct *t)
> +{
> +}
> +#endif
> +
>  #endif
> diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
> index e016bd9..f4350d9 100644
> --- a/include/uapi/asm-generic/unistd.h
> +++ b/include/uapi/asm-generic/unistd.h
> @@ -709,9 +709,11 @@ __SYSCALL(__NR_memfd_create, sys_memfd_create)
>  __SYSCALL(__NR_bpf, sys_bpf)
>  #define __NR_execveat 281
>  __SC_COMP(__NR_execveat, sys_execveat, compat_sys_execveat)
> +#define __NR_percpu 282
> +__SYSCALL(__NR_percpu, sys_percpu)
>
>  #undef __NR_syscalls
> -#define __NR_syscalls 282
> +#define __NR_syscalls 283
>
>  /*
>   * All syscalls below here should go away really,
> diff --git a/init/Kconfig b/init/Kconfig
> index f5dbc6d..73c4070 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1559,6 +1559,16 @@ config PCI_QUIRKS
>           bugs/quirks. Disable this only if your target machine is
>           unaffected by PCI quirks.
>
> +config PERCPU_USER
> +       bool "Enable percpu() system call" if EXPERT
> +       default y
> +       select PREEMPT_NOTIFIERS
> +       help
> +         Enable the percpu() system call which provides a building block
> +         for fast per-cpu critical sections in user-space.
> +
> +         If unsure, say Y.
> +
>  config EMBEDDED
>         bool "Embedded system"
>         option allnoconfig_y
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 1408b33..76919a6 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -96,6 +96,7 @@ obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
>  obj-$(CONFIG_JUMP_LABEL) += jump_label.o
>  obj-$(CONFIG_CONTEXT_TRACKING) += context_tracking.o
>  obj-$(CONFIG_TORTURE_TEST) += torture.o
> +obj-$(CONFIG_PERCPU_USER) += percpu-user.o
>
>  $(obj)/configs.o: $(obj)/config_data.h
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index cf65139..63aaf5a 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1549,6 +1549,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>         cgroup_post_fork(p);
>         if (clone_flags & CLONE_THREAD)
>                 threadgroup_change_end(current);
> +       if (!(clone_flags & CLONE_THREAD))
> +               percpu_user_fork(p);
>         perf_event_fork(p);
>
>         trace_task_newtask(p, clone_flags);
> diff --git a/kernel/percpu-user.c b/kernel/percpu-user.c
> new file mode 100644
> index 0000000..be3d439
> --- /dev/null
> +++ b/kernel/percpu-user.c
> @@ -0,0 +1,126 @@
> +/*
> + * Copyright (C) 2015 Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
> + *
> + * percpu system call
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/preempt.h>
> +#include <linux/init.h>
> +#include <linux/sched.h>
> +#include <linux/uaccess.h>
> +#include <linux/syscalls.h>
> +
> +struct thread_percpu_user {
> +       int32_t nesting;
> +       int32_t signal_sent;
> +       int32_t signo;
> +       int32_t current_cpu;
> +};
> +
> +static void percpu_user_sched_in(struct preempt_notifier *notifier, int cpu)
> +{
> +       struct thread_percpu_user __user *tpu_user;
> +       struct thread_percpu_user tpu;
> +       struct task_struct *t = current;
> +
> +       tpu_user = t->percpu_user;
> +       if (tpu_user == NULL)
> +               return;
> +       if (unlikely(t->flags & PF_EXITING))
> +               return;
> +       /*
> +        * access_ok() of tpu_user has already been checked by sys_percpu().
> +        */
> +       if (__put_user(smp_processor_id(), &tpu_user->current_cpu)) {
> +               WARN_ON_ONCE(1);
> +               return;
> +       }
> +       if (__copy_from_user(&tpu, tpu_user, sizeof(tpu))) {
> +               WARN_ON_ONCE(1);
> +               return;
> +       }
> +       if (!tpu.nesting || tpu.signal_sent)
> +               return;
> +       if (do_send_sig_info(tpu.signo, SEND_SIG_PRIV, t, 0)) {
> +               WARN_ON_ONCE(1);
> +               return;
> +       }
> +       tpu.signal_sent = 1;
> +       if (__copy_to_user(tpu_user, &tpu, sizeof(tpu))) {
> +               WARN_ON_ONCE(1);
> +               return;
> +       }
> +}
> +
> +static void percpu_user_sched_out(struct preempt_notifier *notifier,
> +               struct task_struct *next)
> +{
> +}
> +
> +static struct preempt_ops percpu_user_ops = {
> +       .sched_in = percpu_user_sched_in,
> +       .sched_out = percpu_user_sched_out,
> +};
> +
> +/*
> + * If parent had a percpu-user preempt notifier, we need to setup our own.
> + */
> +void percpu_user_fork(struct task_struct *t)
> +{
> +       struct task_struct *parent = current;
> +
> +       if (!parent->percpu_user)
> +               return;
> +       preempt_notifier_init(&t->percpu_user_notifier, &percpu_user_ops);
> +       preempt_notifier_register(&t->percpu_user_notifier);
> +       t->percpu_user = parent->percpu_user;
> +}
> +
> +void percpu_user_execve(struct task_struct *t)
> +{
> +       if (!t->percpu_user)
> +               return;
> +       preempt_notifier_unregister(&t->percpu_user_notifier);
> +       t->percpu_user = NULL;
> +}
> +
> +/*
> + * sys_percpu - setup user-space per-cpu critical section for caller thread
> + */
> +SYSCALL_DEFINE1(percpu, struct thread_percpu_user __user *, tpu)
> +{
> +       struct task_struct *t = current;
> +
> +       if (tpu == NULL) {
> +               if (t->percpu_user)
> +                       preempt_notifier_unregister(&t->percpu_user_notifier);
> +               goto set_tpu;
> +       }
> +       if (!access_ok(VERIFY_WRITE, tpu, sizeof(struct thread_percpu_user)))
> +               return -EFAULT;
> +       preempt_disable();
> +       if (__put_user(smp_processor_id(), &tpu->current_cpu)) {
> +               WARN_ON_ONCE(1);
> +               preempt_enable();
> +               return -EFAULT;
> +       }
> +       preempt_enable();
> +       if (!current->percpu_user) {
> +               preempt_notifier_init(&t->percpu_user_notifier,
> +                               &percpu_user_ops);
> +               preempt_notifier_register(&t->percpu_user_notifier);
> +       }
> +set_tpu:
> +       current->percpu_user = tpu;
> +       return 0;
> +}
> diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
> index 5adcb0a..16e2bc8 100644
> --- a/kernel/sys_ni.c
> +++ b/kernel/sys_ni.c
> @@ -229,3 +229,6 @@ cond_syscall(sys_bpf);
>
>  /* execveat */
>  cond_syscall(sys_execveat);
> +
> +/* percpu userspace critical sections */
> +cond_syscall(sys_percpu);
> --
> 2.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
