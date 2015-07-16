From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH] thread_local_abi system call: caching current CPU number (x86)
Date: Thu, 16 Jul 2015 16:00:51 -0400
Message-ID: <1437076851-14848-1-git-send-email-mathieu.desnoyers@efficios.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Expose a new system call allowing threads to register a userspace memory
area where to store the current CPU number. Scheduler migration sets the
TIF_NOTIFY_RESUME flag on the current thread. Upon return to user-space,
a notify-resume handler updates the current CPU value within that
user-space memory area.

This getcpu cache is an alternative to the sched_getcpu() vdso which has
a few benefits:
- It is faster to do a memory read that to call a vDSO,
- This cache value can be read from within an inline assembly, which
  makes it a useful building block for restartable sequences.

This approach is inspired by Paul Turner and Andrew Hunter's work
on percpu atomics, which lets the kernel handle restart of critical
sections:
Ref.:
* https://lkml.org/lkml/2015/6/24/665
* https://lwn.net/Articles/650333/
* http://www.linuxplumbersconf.org/2013/ocw/system/presentations/1695/original/LPC%20-%20PerCpu%20Atomics.pdf

Benchmarking sched_getcpu() vs tls cache approach. Getting the
current CPU number:

- With Linux vdso:            12.7 ns
- With TLS-cached cpu number:  0.3 ns

The system call can be extended by registering a larger structure in
the future.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
CC: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
CC: Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
CC: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
CC: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>
CC: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
CC: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
CC: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
CC: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 arch/x86/kernel/signal.c              |  2 +
 arch/x86/syscalls/syscall_64.tbl      |  1 +
 fs/exec.c                             |  1 +
 include/linux/sched.h                 | 35 ++++++++++++++
 include/uapi/asm-generic/unistd.h     |  4 +-
 include/uapi/linux/Kbuild             |  1 +
 include/uapi/linux/thread_local_abi.h | 37 ++++++++++++++
 init/Kconfig                          |  9 ++++
 kernel/Makefile                       |  1 +
 kernel/fork.c                         |  2 +
 kernel/sched/core.c                   |  4 ++
 kernel/sched/sched.h                  |  2 +
 kernel/sys_ni.c                       |  3 ++
 kernel/thread_local_abi.c             | 90 +++++++++++++++++++++++++++++++++++
 14 files changed, 191 insertions(+), 1 deletion(-)
 create mode 100644 include/uapi/linux/thread_local_abi.h
 create mode 100644 kernel/thread_local_abi.c

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index e504246..157cec0 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -750,6 +750,8 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
+		if (getcpu_cache_active(current))
+			getcpu_cache_handle_notify_resume(current);
 	}
 	if (thread_info_flags & _TIF_USER_RETURN_NOTIFY)
 		fire_user_return_notifiers();
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index 8d656fb..0eb2fc2 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -329,6 +329,7 @@
 320	common	kexec_file_load		sys_kexec_file_load
 321	common	bpf			sys_bpf
 322	64	execveat		stub_execveat
+323	common	thread_local_abi	sys_thread_local_abi
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/fs/exec.c b/fs/exec.c
index c7f9b73..e5acf80 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1555,6 +1555,7 @@ static int do_execveat_common(int fd, struct filename *filename,
 	/* execve succeeded */
 	current->fs->in_exec = 0;
 	current->in_execve = 0;
+	thread_local_abi_execve(current);
 	acct_update_integrals(current);
 	task_numa_free(current);
 	free_bprm(bprm);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index a419b65..4a3fc52 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2,6 +2,7 @@
 #define _LINUX_SCHED_H
 
 #include <uapi/linux/sched.h>
+#include <uapi/linux/thread_local_abi.h>
 
 #include <linux/sched/prio.h>
 
@@ -1710,6 +1711,10 @@ struct task_struct {
 #ifdef CONFIG_DEBUG_ATOMIC_SLEEP
 	unsigned long	task_state_change;
 #endif
+#ifdef CONFIG_THREAD_LOCAL_ABI
+	size_t thread_local_abi_len;
+	struct thread_local_abi __user *thread_local_abi;
+#endif
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
@@ -3090,4 +3095,34 @@ static inline unsigned long rlimit_max(unsigned int limit)
 	return task_rlimit_max(current, limit);
 }
 
+#ifdef CONFIG_THREAD_LOCAL_ABI
+void thread_local_abi_fork(struct task_struct *t);
+void thread_local_abi_execve(struct task_struct *t);
+void getcpu_cache_handle_notify_resume(struct task_struct *t);
+static inline bool getcpu_cache_active(struct task_struct *t)
+{
+	struct thread_local_abi __user *tlap = t->thread_local_abi;
+
+	if (!tlap || t->thread_local_abi_len <
+			offsetof(struct thread_local_abi, cpu)
+			+ sizeof(tlap->cpu))
+		return false;
+	return true;
+}
+#else
+static inline void thread_local_abi_fork(struct task_struct *t)
+{
+}
+static inline void thread_local_abi_execve(struct task_struct *t)
+{
+}
+static inline void getcpu_cache_handle_notify_resume(struct task_struct *t)
+{
+}
+static inline bool getcpu_cache_active(struct task_struct *t)
+{
+	return false;
+}
+#endif
+
 #endif
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index e016bd9..50aa984 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -709,9 +709,11 @@ __SYSCALL(__NR_memfd_create, sys_memfd_create)
 __SYSCALL(__NR_bpf, sys_bpf)
 #define __NR_execveat 281
 __SC_COMP(__NR_execveat, sys_execveat, compat_sys_execveat)
+#define __NR_thread_local_abi 282
+__SYSCALL(__NR_thread_local_abi, sys_thread_local_abi)
 
 #undef __NR_syscalls
-#define __NR_syscalls 282
+#define __NR_syscalls 283
 
 /*
  * All syscalls below here should go away really,
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 68ceb97..dfd6a30 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -389,6 +389,7 @@ header-y += tcp_metrics.h
 header-y += telephony.h
 header-y += termios.h
 header-y += thermal.h
+header-y += thread_local_abi.h
 header-y += time.h
 header-y += times.h
 header-y += timex.h
diff --git a/include/uapi/linux/thread_local_abi.h b/include/uapi/linux/thread_local_abi.h
new file mode 100644
index 0000000..6487c92
--- /dev/null
+++ b/include/uapi/linux/thread_local_abi.h
@@ -0,0 +1,37 @@
+#ifndef _UAPI_LINUX_THREAD_LOCAL_ABI_H
+#define _UAPI_LINUX_THREAD_LOCAL_ABI_H
+
+/*
+ * linux/thread_local_abi.h
+ *
+ * thread_local_abi system call API
+ *
+ * Copyright (c) 2015 Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to deal
+ * in the Software without restriction, including without limitation the rights
+ * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
+ * copies of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
+ * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/types.h>
+
+/* This structure is an ABI that can only be extended. */
+struct thread_local_abi {
+	int32_t cpu;
+};
+
+#endif /* _UAPI_LINUX_THREAD_LOCAL_ABI_H */
diff --git a/init/Kconfig b/init/Kconfig
index f5dbc6d..c8ff5fa 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1559,6 +1559,15 @@ config PCI_QUIRKS
 	  bugs/quirks. Disable this only if your target machine is
 	  unaffected by PCI quirks.
 
+config THREAD_LOCAL_ABI
+	bool "Enable thread-local ABI" if EXPERT
+	default y
+	help
+	  Enable the thread-local ABI system call. It provides a user-space
+	  cache for the current CPU number value.
+
+	  If unsure, say Y.
+
 config EMBEDDED
 	bool "Embedded system"
 	option allnoconfig_y
diff --git a/kernel/Makefile b/kernel/Makefile
index 1408b33..cc1f3d4 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -96,6 +96,7 @@ obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
 obj-$(CONFIG_JUMP_LABEL) += jump_label.o
 obj-$(CONFIG_CONTEXT_TRACKING) += context_tracking.o
 obj-$(CONFIG_TORTURE_TEST) += torture.o
+obj-$(CONFIG_THREAD_LOCAL_ABI) += thread_local_abi.o
 
 $(obj)/configs.o: $(obj)/config_data.h
 
diff --git a/kernel/fork.c b/kernel/fork.c
index cf65139..e17bcb3 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1549,6 +1549,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	cgroup_post_fork(p);
 	if (clone_flags & CLONE_THREAD)
 		threadgroup_change_end(current);
+	if (!(clone_flags & CLONE_THREAD))
+		thread_local_abi_fork(p);
 	perf_event_fork(p);
 
 	trace_task_newtask(p, clone_flags);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 62671f5..668a502 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1823,6 +1823,10 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
 
 	p->numa_group = NULL;
 #endif /* CONFIG_NUMA_BALANCING */
+#ifdef CONFIG_THREAD_LOCAL_ABI
+	p->thread_local_abi_len = 0;
+	p->thread_local_abi = NULL;
+#endif
 }
 
 #ifdef CONFIG_NUMA_BALANCING
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index dc0f435..bf3e346 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -921,6 +921,8 @@ static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 {
 	set_task_rq(p, cpu);
 #ifdef CONFIG_SMP
+	if (getcpu_cache_active(p))
+		set_tsk_thread_flag(p, TIF_NOTIFY_RESUME);
 	/*
 	 * After ->cpu is set up to a new value, task_rq_lock(p, ...) can be
 	 * successfuly executed on another CPU. We must ensure that updates of
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 5adcb0a..cadb903 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -229,3 +229,6 @@ cond_syscall(sys_bpf);
 
 /* execveat */
 cond_syscall(sys_execveat);
+
+/* thread-local ABI */
+cond_syscall(sys_thread_local_abi);
diff --git a/kernel/thread_local_abi.c b/kernel/thread_local_abi.c
new file mode 100644
index 0000000..681f06e
--- /dev/null
+++ b/kernel/thread_local_abi.c
@@ -0,0 +1,90 @@
+/*
+ * Copyright (C) 2015 Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
+ *
+ * thread_local_abi system call
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+#include <linux/syscalls.h>
+
+static int getcpu_cache_update(struct task_struct *t)
+{
+	if (put_user(raw_smp_processor_id(), &t->thread_local_abi->cpu)) {
+		t->thread_local_abi_len = 0;
+		t->thread_local_abi = NULL;
+		return -1;
+	}
+	return 0;
+}
+
+/*
+ * This resume handler should always be executed between a migration
+ * triggered by preemption and return to user-space.
+ */
+void getcpu_cache_handle_notify_resume(struct task_struct *t)
+{
+	BUG_ON(!getcpu_cache_active(t));
+	if (unlikely(t->flags & PF_EXITING))
+		return;
+	if (getcpu_cache_update(t))
+		force_sig(SIGSEGV, t);
+}
+
+/*
+ * If parent process has a thread-local ABI, the child inherits. Only applies
+ * when forking a process, not a thread.
+ */
+void thread_local_abi_fork(struct task_struct *t)
+{
+	t->thread_local_abi_len = current->thread_local_abi_len;
+	t->thread_local_abi = current->thread_local_abi;
+}
+
+void thread_local_abi_execve(struct task_struct *t)
+{
+	t->thread_local_abi_len = 0;
+	t->thread_local_abi = NULL;
+}
+
+/*
+ * sys_thread_local_abi - setup thread-local ABI for caller thread
+ */
+SYSCALL_DEFINE3(thread_local_abi, struct thread_local_abi __user *, tlap,
+		size_t, len, int, flags)
+{
+	size_t minlen;
+
+	if (flags)
+		return -EINVAL;
+	if (current->thread_local_abi && tlap)
+		return -EBUSY;
+	/* Agree on the intersection of userspace and kernel features */
+	minlen = min_t(size_t, len, sizeof(struct thread_local_abi));
+	current->thread_local_abi_len = minlen;
+	current->thread_local_abi = tlap;
+	if (!tlap)
+		return 0;
+	/*
+	 * Migration checks ->thread_local_abi to see if notify_resume
+	 * flag should be set. Therefore, we need to ensure that
+	 * the scheduler sees ->thread_local_abi before we update its content.
+	 */
+	barrier();	/* Store thread_local_abi before update content */
+	if (getcpu_cache_active(current)) {
+		if (getcpu_cache_update(current))
+			return -EFAULT;
+	}
+	return minlen;
+}
-- 
2.1.4
