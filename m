From: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>
Subject: RE: [RFC PATCH] getcpu_cache system call: caching current CPU
 number (x86)
Date: Mon, 13 Jul 2015 11:17:35 +0000
Message-ID: <5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F39C6@PRN-MBX02-1.TheFacebook.com>
References: <1436724386-30909-1-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436724386-30909-1-git-send-email-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

At Facebook we already use getcpu in folly, our base C++ library, to provide high performance concurrency algorithms. Folly includes an abstraction called AccessSpreader which helps engineers write abstractions which shard themselves across different cores to prevent cache contention (https://github.com/facebook/folly/blob/master/folly/detail/CacheLocality.cpp). We have used this primative to create faster reader writer locks (https://github.com/facebook/folly/blob/master/folly/SharedMutex.h), as well as in an abstraction that powers workqueues (https://github.com/facebook/folly/blob/master/folly/IndexedMemPool.h). This would be a great perf improvement for these types of abstractions and probably encourage us to use the idea more widely.

One quick comment on the approach -- it'd be really great if we had a method that didn't require users to register each thread. This can often lead to requiring an additional branch in critical code to check if the appropriate caches have been initialized. Also, one of the most interesting potential applications of the restartable sequences concept is in malloc. having a brief period at the beginning of the life of a thread where malloc didn't work would be pretty tricky to program around.

-b
________________________________________
From: Mathieu Desnoyers [mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org]
Sent: Sunday, July 12, 2015 11:06 AM
To: Paul Turner
Cc: Mathieu Desnoyers; Andrew Hunter; Peter Zijlstra; Ingo Molnar; Ben Maurer; Steven Rostedt; Paul E. McKenney; Josh Triplett; Lai Jiangshan; Linus Torvalds; Andrew Morton; linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: [RFC PATCH] getcpu_cache system call: caching current CPU number (x86)

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
* https://urldefense.proofpoint.com/v1/url?u=https://lwn.net/Articles/650333/&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=ykFqYBj5kD4j7jlBP4F60A%3D%3D%0A&m=rgSZ590AsXQ7Hp6Q6Oyt6xFrzk0JFmcxItletGiGhNE%3D%0A&s=6446da0c7a6cc256b68c865d26b333a37d4b40548ebeebc39114a782a6ce6ea3
* https://urldefense.proofpoint.com/v1/url?u=http://www.linuxplumbersconf.org/2013/ocw/system/presentations/1695/original/LPC%2520-%2520PerCpu%2520Atomics.pdf&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=ykFqYBj5kD4j7jlBP4F60A%3D%3D%0A&m=rgSZ590AsXQ7Hp6Q6Oyt6xFrzk0JFmcxItletGiGhNE%3D%0A&s=71e097fe57910235e8b23b0bb1b20aa8c8c4b80106663980b62ccaa7e13fba9a

Benchmarking sched_getcpu() vs tls cache approach. Getting the
current CPU number:

- With Linux vdso:            12.7 ns
- With TLS-cached cpu number:  0.3 ns

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
CC: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
CC: Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
CC: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
CC: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>
CC: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
CC: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
CC: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
CC: Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
CC: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 arch/x86/kernel/signal.c          |  2 ++
 arch/x86/syscalls/syscall_64.tbl  |  1 +
 fs/exec.c                         |  1 +
 include/linux/sched.h             | 27 +++++++++++++++
 include/uapi/asm-generic/unistd.h |  4 ++-
 init/Kconfig                      |  9 +++++
 kernel/Makefile                   |  1 +
 kernel/fork.c                     |  2 ++
 kernel/getcpu-cache.c             | 70 +++++++++++++++++++++++++++++++++++++++
 kernel/sched/core.c               |  3 ++
 kernel/sched/sched.h              |  2 ++
 kernel/sys_ni.c                   |  3 ++
 12 files changed, 124 insertions(+), 1 deletion(-)
 create mode 100644 kernel/getcpu-cache.c

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index e504246..157cec0 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -750,6 +750,8 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
        if (thread_info_flags & _TIF_NOTIFY_RESUME) {
                clear_thread_flag(TIF_NOTIFY_RESUME);
                tracehook_notify_resume(regs);
+               if (getcpu_cache_active(current))
+                       getcpu_cache_handle_notify_resume(current);
        }
        if (thread_info_flags & _TIF_USER_RETURN_NOTIFY)
                fire_user_return_notifiers();
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index 8d656fb..cfcf8e7 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -329,6 +329,7 @@
 320    common  kexec_file_load         sys_kexec_file_load
 321    common  bpf                     sys_bpf
 322    64      execveat                stub_execveat
+323    common  getcpu_cache            sys_getcpu_cache

 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/fs/exec.c b/fs/exec.c
index c7f9b73..20ef2e6 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1555,6 +1555,7 @@ static int do_execveat_common(int fd, struct filename *filename,
        /* execve succeeded */
        current->fs->in_exec = 0;
        current->in_execve = 0;
+       getcpu_cache_execve(current);
        acct_update_integrals(current);
        task_numa_free(current);
        free_bprm(bprm);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index a419b65..0654cc2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1710,6 +1710,9 @@ struct task_struct {
 #ifdef CONFIG_DEBUG_ATOMIC_SLEEP
        unsigned long   task_state_change;
 #endif
+#ifdef CONFIG_GETCPU_CACHE
+       int32_t __user *getcpu_cache;
+#endif
 };

 /* Future-safe accessor for struct task_struct's cpus_allowed. */
@@ -3090,4 +3093,28 @@ static inline unsigned long rlimit_max(unsigned int limit)
        return task_rlimit_max(current, limit);
 }

+#ifdef CONFIG_GETCPU_CACHE
+void getcpu_cache_fork(struct task_struct *t);
+void getcpu_cache_execve(struct task_struct *t);
+void getcpu_cache_handle_notify_resume(struct task_struct *t);
+static inline bool getcpu_cache_active(struct task_struct *t)
+{
+       return t->getcpu_cache;
+}
+#else
+static inline void getcpu_cache_fork(struct task_struct *t)
+{
+}
+static inline void getcpu_cache_execve(struct task_struct *t)
+{
+}
+static inline void getcpu_cache_handle_notify_resume(struct task_struct *t)
+{
+}
+static inline bool getcpu_cache_active(struct task_struct *t)
+{
+       return false;
+}
+#endif
+
 #endif
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index e016bd9..f82b70d 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -709,9 +709,11 @@ __SYSCALL(__NR_memfd_create, sys_memfd_create)
 __SYSCALL(__NR_bpf, sys_bpf)
 #define __NR_execveat 281
 __SC_COMP(__NR_execveat, sys_execveat, compat_sys_execveat)
+#define __NR_getcpu_cache 282
+__SYSCALL(__NR_getcpu_cache, sys_getcpu_cache)

 #undef __NR_syscalls
-#define __NR_syscalls 282
+#define __NR_syscalls 283

 /*
  * All syscalls below here should go away really,
diff --git a/init/Kconfig b/init/Kconfig
index f5dbc6d..fac919b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1559,6 +1559,15 @@ config PCI_QUIRKS
          bugs/quirks. Disable this only if your target machine is
          unaffected by PCI quirks.

+config GETCPU_CACHE
+       bool "Enable getcpu_cache() system call" if EXPERT
+       default y
+       help
+         Enable the getcpu_cache() system call which provides a
+         user-space cache for the current CPU number value.
+
+         If unsure, say Y.
+
 config EMBEDDED
        bool "Embedded system"
        option allnoconfig_y
diff --git a/kernel/Makefile b/kernel/Makefile
index 1408b33..3350ba1 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -96,6 +96,7 @@ obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
 obj-$(CONFIG_JUMP_LABEL) += jump_label.o
 obj-$(CONFIG_CONTEXT_TRACKING) += context_tracking.o
 obj-$(CONFIG_TORTURE_TEST) += torture.o
+obj-$(CONFIG_GETCPU_CACHE) += getcpu-cache.o

 $(obj)/configs.o: $(obj)/config_data.h

diff --git a/kernel/fork.c b/kernel/fork.c
index cf65139..334e62d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1549,6 +1549,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
        cgroup_post_fork(p);
        if (clone_flags & CLONE_THREAD)
                threadgroup_change_end(current);
+       if (!(clone_flags & CLONE_THREAD))
+               getcpu_cache_fork(p);
        perf_event_fork(p);

        trace_task_newtask(p, clone_flags);
diff --git a/kernel/getcpu-cache.c b/kernel/getcpu-cache.c
new file mode 100644
index 0000000..b4e5c77
--- /dev/null
+++ b/kernel/getcpu-cache.c
@@ -0,0 +1,70 @@
+/*
+ * Copyright (C) 2015 Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
+ *
+ * getcpu_cache system call
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
+/*
+ * This resume handler should always be executed between a migration
+ * triggered by preemption and return to user-space.
+ */
+void getcpu_cache_handle_notify_resume(struct task_struct *t)
+{
+       int32_t __user *gcp = t->getcpu_cache;
+
+       if (gcp == NULL)
+               return;
+       if (unlikely(t->flags & PF_EXITING))
+               return;
+       /*
+        * access_ok() of gcp_user has already been checked by
+        * sys_getcpu_cache().
+        */
+       if (__put_user(raw_smp_processor_id(), gcp))
+               force_sig(SIGSEGV, current);
+}
+
+/*
+ * If parent process has a getcpu_cache, the child inherits. Only
+ * applies when forking a process, not a thread.
+ */
+void getcpu_cache_fork(struct task_struct *t)
+{
+       t->getcpu_cache = current->getcpu_cache;
+}
+
+void getcpu_cache_execve(struct task_struct *t)
+{
+       t->getcpu_cache = NULL;
+}
+
+/*
+ * sys_getcpu_cache - setup getcpu cache for caller thread
+ */
+SYSCALL_DEFINE2(getcpu_cache, int32_t __user *, gcp, int, flags)
+{
+       if (flags)
+               return -EINVAL;
+       if (gcp != NULL && !access_ok(VERIFY_WRITE, gcp, sizeof(int32_t)))
+               return -EFAULT;
+       current->getcpu_cache = gcp;
+       /* Will update *gcp on resume */
+       if (gcp)
+               set_thread_flag(TIF_NOTIFY_RESUME);
+       return 0;
+}
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 62671f5..a9009d4 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1823,6 +1823,9 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)

        p->numa_group = NULL;
 #endif /* CONFIG_NUMA_BALANCING */
+#ifdef CONFIG_GETCPU_CACHE
+       p->getcpu_cache = NULL;
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
+       if (getcpu_cache_active(p))
+               set_tsk_thread_flag(p, TIF_NOTIFY_RESUME);
        /*
         * After ->cpu is set up to a new value, task_rq_lock(p, ...) can be
         * successfuly executed on another CPU. We must ensure that updates of
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 5adcb0a..3691dc8 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -229,3 +229,6 @@ cond_syscall(sys_bpf);

 /* execveat */
 cond_syscall(sys_execveat);
+
+/* current CPU number cache */
+cond_syscall(sys_getcpu_cache);
--
2.1.4
