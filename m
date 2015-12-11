From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [RFC PATCH 1/2] thread_local_abi system call: caching current
 CPU number (x86)
Date: Fri, 11 Dec 2015 19:56:42 +0100
Message-ID: <566B1C6A.4030603@gmail.com>
References: <1449761990-23525-1-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449761990-23525-1-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: mtk.manpages@gmail.com, linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Mathieu,

On 12/10/2015 04:39 PM, Mathieu Desnoyers wrote:
> Expose a new system call allowing threads to register a userspace memory
> area where to store the current CPU number. Scheduler migration sets the
> TIF_NOTIFY_RESUME flag on the current thread. Upon return to user-space,
> a notify-resume handler updates the current CPU value within that
> user-space memory area.
> 
> This getcpu cache is an alternative to the sched_getcpu() vdso which has
> a few benefits:
> - It is faster to do a memory read that to call a vDSO,
> - This cached value can be read from within an inline assembly, which
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

Is there a man page for this system call?

Thanks,

Michael

> - With Linux vdso:            12.7 ns
> - With TLS-cached cpu number:  0.3 ns
> 
> The system call can be extended by registering a larger structure in
> the future.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Paul Turner <pjt@google.com>
> CC: Andrew Hunter <ahh@google.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Andy Lutomirski <luto@amacapital.net>
> CC: Andi Kleen <andi@firstfloor.org>
> CC: Dave Watson <davejwatson@fb.com>
> CC: Chris Lameter <cl@linux.com>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: Ben Maurer <bmaurer@fb.com>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> CC: Josh Triplett <josh@joshtriplett.org>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: linux-api@vger.kernel.org
> ---
>  arch/x86/entry/common.c                |  2 +
>  arch/x86/entry/syscalls/syscall_64.tbl |  1 +
>  fs/exec.c                              |  1 +
>  include/linux/sched.h                  | 32 ++++++++++++
>  include/uapi/asm-generic/unistd.h      |  4 +-
>  include/uapi/linux/Kbuild              |  1 +
>  include/uapi/linux/thread_local_abi.h  | 37 ++++++++++++++
>  init/Kconfig                           |  7 +++
>  kernel/Makefile                        |  1 +
>  kernel/fork.c                          |  2 +
>  kernel/sched/core.c                    |  4 ++
>  kernel/sched/sched.h                   |  2 +
>  kernel/sys_ni.c                        |  3 ++
>  kernel/thread_local_abi.c              | 92 ++++++++++++++++++++++++++++++++++
>  14 files changed, 188 insertions(+), 1 deletion(-)
>  create mode 100644 include/uapi/linux/thread_local_abi.h
>  create mode 100644 kernel/thread_local_abi.c
> 
> diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
> index a89fdbc..fdfdb14 100644
> --- a/arch/x86/entry/common.c
> +++ b/arch/x86/entry/common.c
> @@ -249,6 +249,8 @@ static void exit_to_usermode_loop(struct pt_regs *regs, u32 cached_flags)
>  		if (cached_flags & _TIF_NOTIFY_RESUME) {
>  			clear_thread_flag(TIF_NOTIFY_RESUME);
>  			tracehook_notify_resume(regs);
> +			if (getcpu_cache_active(current))
> +				getcpu_cache_handle_notify_resume(current);
>  		}
>  
>  		if (cached_flags & _TIF_USER_RETURN_NOTIFY)
> diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
> index 314a90b..748aee3 100644
> --- a/arch/x86/entry/syscalls/syscall_64.tbl
> +++ b/arch/x86/entry/syscalls/syscall_64.tbl
> @@ -332,6 +332,7 @@
>  323	common	userfaultfd		sys_userfaultfd
>  324	common	membarrier		sys_membarrier
>  325	common	mlock2			sys_mlock2
> +326	common	thread_local_abi	sys_thread_local_abi
>  
>  #
>  # x32-specific system call numbers start at 512 to avoid cache impact
> diff --git a/fs/exec.c b/fs/exec.c
> index b06623a..88490cc 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1594,6 +1594,7 @@ static int do_execveat_common(int fd, struct filename *filename,
>  	/* execve succeeded */
>  	current->fs->in_exec = 0;
>  	current->in_execve = 0;
> +	thread_local_abi_execve(current);
>  	acct_update_integrals(current);
>  	task_numa_free(current);
>  	free_bprm(bprm);
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index edad7a4..b39d9a3 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2,6 +2,7 @@
>  #define _LINUX_SCHED_H
>  
>  #include <uapi/linux/sched.h>
> +#include <uapi/linux/thread_local_abi.h>
>  
>  #include <linux/sched/prio.h>
>  
> @@ -1812,6 +1813,10 @@ struct task_struct {
>  	unsigned long	task_state_change;
>  #endif
>  	int pagefault_disabled;
> +#ifdef CONFIG_THREAD_LOCAL_ABI
> +	size_t thread_local_abi_len;
> +	struct thread_local_abi __user *thread_local_abi;
> +#endif
>  /* CPU-specific state of this task */
>  	struct thread_struct thread;
>  /*
> @@ -3188,4 +3193,31 @@ static inline unsigned long rlimit_max(unsigned int limit)
>  	return task_rlimit_max(current, limit);
>  }
>  
> +#ifdef CONFIG_THREAD_LOCAL_ABI
> +void thread_local_abi_fork(struct task_struct *t);
> +void thread_local_abi_execve(struct task_struct *t);
> +void getcpu_cache_handle_notify_resume(struct task_struct *t);
> +static inline bool getcpu_cache_active(struct task_struct *t)
> +{
> +	if (t->thread_local_abi_len < offsetof(struct thread_local_abi, cpu)
> +			+ sizeof(t->thread_local_abi->cpu))
> +		return false;
> +	return true;
> +}
> +#else
> +static inline void thread_local_abi_fork(struct task_struct *t)
> +{
> +}
> +static inline void thread_local_abi_execve(struct task_struct *t)
> +{
> +}
> +static inline void getcpu_cache_handle_notify_resume(struct task_struct *t)
> +{
> +}
> +static inline bool getcpu_cache_active(struct task_struct *t)
> +{
> +	return false;
> +}
> +#endif
> +
>  #endif
> diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
> index 1324b02..89a107a 100644
> --- a/include/uapi/asm-generic/unistd.h
> +++ b/include/uapi/asm-generic/unistd.h
> @@ -715,9 +715,11 @@ __SYSCALL(__NR_userfaultfd, sys_userfaultfd)
>  __SYSCALL(__NR_membarrier, sys_membarrier)
>  #define __NR_mlock2 284
>  __SYSCALL(__NR_mlock2, sys_mlock2)
> +#define __NR_thread_local_abi 285
> +__SYSCALL(__NR_thread_local_abi, sys_thread_local_abi)
>  
>  #undef __NR_syscalls
> -#define __NR_syscalls 285
> +#define __NR_syscalls 286
>  
>  /*
>   * All syscalls below here should go away really,
> diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
> index 628e6e6..5df5460 100644
> --- a/include/uapi/linux/Kbuild
> +++ b/include/uapi/linux/Kbuild
> @@ -397,6 +397,7 @@ header-y += tcp_metrics.h
>  header-y += telephony.h
>  header-y += termios.h
>  header-y += thermal.h
> +header-y += thread_local_abi.h
>  header-y += time.h
>  header-y += times.h
>  header-y += timex.h
> diff --git a/include/uapi/linux/thread_local_abi.h b/include/uapi/linux/thread_local_abi.h
> new file mode 100644
> index 0000000..6487c92
> --- /dev/null
> +++ b/include/uapi/linux/thread_local_abi.h
> @@ -0,0 +1,37 @@
> +#ifndef _UAPI_LINUX_THREAD_LOCAL_ABI_H
> +#define _UAPI_LINUX_THREAD_LOCAL_ABI_H
> +
> +/*
> + * linux/thread_local_abi.h
> + *
> + * thread_local_abi system call API
> + *
> + * Copyright (c) 2015 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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
> +#include <linux/types.h>
> +
> +/* This structure is an ABI that can only be extended. */
> +struct thread_local_abi {
> +	int32_t cpu;
> +};
> +
> +#endif /* _UAPI_LINUX_THREAD_LOCAL_ABI_H */
> diff --git a/init/Kconfig b/init/Kconfig
> index c24b6f7..df29803 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1612,6 +1612,13 @@ config MEMBARRIER
>  	  pairs of memory barriers into pairs consisting of membarrier() and a
>  	  compiler barrier.
>  
> +config THREAD_LOCAL_ABI
> +	bool "Enable thread-local ABI" if EXPERT
> +	default y
> +	help
> +	  Enable the thread-local ABI system call. It provides a user-space
> +	  cache for the current CPU number value.
> +
>  	  If unsure, say Y.
>  
>  config EMBEDDED
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 53abf00..327fbd9 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -103,6 +103,7 @@ obj-$(CONFIG_TORTURE_TEST) += torture.o
>  obj-$(CONFIG_MEMBARRIER) += membarrier.o
>  
>  obj-$(CONFIG_HAS_IOMEM) += memremap.o
> +obj-$(CONFIG_THREAD_LOCAL_ABI) += thread_local_abi.o
>  
>  $(obj)/configs.o: $(obj)/config_data.h
>  
> diff --git a/kernel/fork.c b/kernel/fork.c
> index f97f2c4..42dd565 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1612,6 +1612,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  	cgroup_post_fork(p, cgrp_ss_priv);
>  	if (clone_flags & CLONE_THREAD)
>  		threadgroup_change_end(current);
> +	if (!(clone_flags & CLONE_THREAD))
> +		thread_local_abi_fork(p);
>  	perf_event_fork(p);
>  
>  	trace_task_newtask(p, clone_flags);
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 4d568ac..b78f92f 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2120,6 +2120,10 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
>  
>  	p->numa_group = NULL;
>  #endif /* CONFIG_NUMA_BALANCING */
> +#ifdef CONFIG_THREAD_LOCAL_ABI
> +	p->thread_local_abi_len = 0;
> +	p->thread_local_abi = NULL;
> +#endif
>  }
>  
>  DEFINE_STATIC_KEY_FALSE(sched_numa_balancing);
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index efd3bfc..d828b97 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -957,6 +957,8 @@ static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
>  {
>  	set_task_rq(p, cpu);
>  #ifdef CONFIG_SMP
> +	if (getcpu_cache_active(p))
> +		set_tsk_thread_flag(p, TIF_NOTIFY_RESUME);
>  	/*
>  	 * After ->cpu is set up to a new value, task_rq_lock(p, ...) can be
>  	 * successfuly executed on another CPU. We must ensure that updates of
> diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
> index 0623787..e803824 100644
> --- a/kernel/sys_ni.c
> +++ b/kernel/sys_ni.c
> @@ -249,3 +249,6 @@ cond_syscall(sys_execveat);
>  
>  /* membarrier */
>  cond_syscall(sys_membarrier);
> +
> +/* thread-local ABI */
> +cond_syscall(sys_thread_local_abi);
> diff --git a/kernel/thread_local_abi.c b/kernel/thread_local_abi.c
> new file mode 100644
> index 0000000..f05505a
> --- /dev/null
> +++ b/kernel/thread_local_abi.c
> @@ -0,0 +1,92 @@
> +/*
> + * Copyright (C) 2015 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> + *
> + * thread_local_abi system call
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
> +#include <linux/init.h>
> +#include <linux/sched.h>
> +#include <linux/uaccess.h>
> +#include <linux/syscalls.h>
> +
> +static int getcpu_cache_update(struct task_struct *t)
> +{
> +	if (put_user(raw_smp_processor_id(), &t->thread_local_abi->cpu)) {
> +		t->thread_local_abi_len = 0;
> +		t->thread_local_abi = NULL;
> +		return -1;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * This resume handler should always be executed between a migration
> + * triggered by preemption and return to user-space.
> + */
> +void getcpu_cache_handle_notify_resume(struct task_struct *t)
> +{
> +	BUG_ON(!getcpu_cache_active(t));
> +	if (unlikely(t->flags & PF_EXITING))
> +		return;
> +	if (getcpu_cache_update(t))
> +		force_sig(SIGSEGV, t);
> +}
> +
> +/*
> + * If parent process has a thread-local ABI, the child inherits. Only applies
> + * when forking a process, not a thread.
> + */
> +void thread_local_abi_fork(struct task_struct *t)
> +{
> +	t->thread_local_abi_len = current->thread_local_abi_len;
> +	t->thread_local_abi = current->thread_local_abi;
> +}
> +
> +void thread_local_abi_execve(struct task_struct *t)
> +{
> +	t->thread_local_abi_len = 0;
> +	t->thread_local_abi = NULL;
> +}
> +
> +/*
> + * sys_thread_local_abi - setup thread-local ABI for caller thread
> + */
> +SYSCALL_DEFINE3(thread_local_abi, struct thread_local_abi __user *, tlap,
> +		size_t, len, int, flags)
> +{
> +	size_t minlen;
> +
> +	if (flags)
> +		return -EINVAL;
> +	if (current->thread_local_abi && tlap)
> +		return -EBUSY;
> +	/* Agree on the intersection of userspace and kernel features */
> +	if (!tlap)
> +		minlen = 0;
> +	else
> +		minlen = min_t(size_t, len, sizeof(struct thread_local_abi));
> +	current->thread_local_abi_len = minlen;
> +	current->thread_local_abi = tlap;
> +	/*
> +	 * Migration checks ->thread_local_abi_len to see if notify_resume
> +	 * flag should be set. Therefore, we need to ensure that
> +	 * the scheduler sees ->thread_local_abi_len before we update
> +	 * the getcpu cache content with the current CPU number.
> +	 */
> +	barrier();	/* Store thread_local_abi_len before update content */
> +	if (getcpu_cache_active(current)) {
> +		if (getcpu_cache_update(current))
> +			return -EFAULT;
> +	}
> +	return minlen;
> +}
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
