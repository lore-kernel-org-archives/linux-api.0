From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH v2 1/3] getcpu_cache system call: cache CPU number of running thread
Date: Wed, 27 Jan 2016 11:54:41 -0500
Message-ID: <1453913683-28915-2-git-send-email-mathieu.desnoyers@efficios.com>
References: <1453913683-28915-1-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453913683-28915-1-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
List-Id: linux-api@vger.kernel.org

Expose a new system call allowing threads to register one userspace
memory area where to store the CPU number on which the calling thread i=
s
running. Scheduler migration sets the TIF_NOTIFY_RESUME flag on the
current thread. Upon return to user-space, a notify-resume handler
updates the current CPU value within each registered user-space memory
area. User-space can then read the current CPU number directly from
memory.

This getcpu cache is an improvement over current mechanisms available t=
o
read the current CPU number, which has the following benefits:

- 44x speedup on ARM vs system call through glibc,
- 14x speedup on x86 compared to calling glibc, which calls vdso
  executing a "lsl" instruction,
- 11x speedup on x86 compared to inlined "lsl" instruction,
- Unlike vdso approaches, this cached value can be read from an inline
  assembly, which makes it a useful building block for restartable
  sequences.
- The getcpu cache approach is portable (e.g. ARM), which is not the
  case for the lsl-based x86 vdso.

On x86, yet another possible approach would be to use the gs segment
selector to point to user-space per-cpu data. This approach performs
similarly to the getcpu cache, but it has two disadvantages: it is
not portable, and it is incompatible with existing applications already
using the gs segment selector for other purposes.

This approach is inspired by Paul Turner and Andrew Hunter's work
on percpu atomics, which lets the kernel handle restart of critical
sections:
Ref.:
* https://lkml.org/lkml/2015/10/27/1095
* https://lkml.org/lkml/2015/6/24/665
* https://lwn.net/Articles/650333/
* http://www.linuxplumbersconf.org/2013/ocw/system/presentations/1695/o=
riginal/LPC%20-%20PerCpu%20Atomics.pdf

Benchmarking various approaches for reading the current CPU number:

ARMv7 Processor rev 10 (v7l)
Machine model: Wandboard i.MX6 Quad Board
- Baseline (empty loop):               10.1 ns
- Read CPU from getcpu cache:          10.1 ns
- glibc 2.19-0ubuntu6.6 getcpu:       445.6 ns
- getcpu system call:                 322.2 ns

x86-64 Intel(R) Xeon(R) CPU E5-2630 v3 @ 2.40GHz:
- Baseline (empty loop):                1.0 ns
- Read CPU from getcpu cache:           1.0 ns
- Read using gs segment selector:       1.0 ns
- "lsl" inline assembly:               11.2 ns
- glibc 2.19-0ubuntu6.6 getcpu:        14.3 ns
- getcpu system call:                  51.0 ns

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Paul Turner <pjt@google.com>
CC: Andrew Hunter <ahh@google.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Andi Kleen <andi@firstfloor.org>
CC: Dave Watson <davejwatson@fb.com>
CC: Chris Lameter <cl@linux.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: Ben Maurer <bmaurer@fb.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Josh Triplett <josh@joshtriplett.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Russell King <linux@arm.linux.org.uk>
CC: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <will.deacon@arm.com>
CC: Michael Kerrisk <mtk.manpages@gmail.com>
CC: linux-api@vger.kernel.org
---

Changes since v1:

- Return -1, errno=3DEINVAL if cpu_cache pointer is not aligned on
  sizeof(int32_t).
- Update man page to describe the pointer alignement requirements and
  update atomicity guarantees.
- Add MAINTAINERS file GETCPU_CACHE entry.
- Remove dynamic memory allocation: go back to having a single
  getcpu_cache entry per thread. Update documentation accordingly.
- Rebased on Linux 4.4.

Rationale for the getcpu_cache system call rather than the thread-local
ABI system call proposed earlier:

Rather than doing a "generic" thread-local ABI, specialize this system
call for a cpu number cache only. Anyway, the thread-local ABI approach
would have required that we introduce "feature" flags, which would have
ended up reimplementing multiplexing of features on top of a system
call. It seems better to introduce one system call per feature instead.

Man page associated:

GETCPU_CACHE(2)       Linux Programmer's Manual      GETCPU_CACHE(2)

NAME
       getcpu_cache  -  cache CPU number on which the calling thread
       is running

SYNOPSIS
       #include <stdint.h>

       int getcpu_cache(int32_t **cpu_cachep, int flags);

DESCRIPTION
       The getcpu_cache() helps speeding up reading the current  CPU
       number  by  ensuring  that  the memory location registered by
       each user-space thread is always updated with the CPU  number
       on which the thread is running when reading that memory loca=E2=80=
=90
       tion.

       The cpu_cachep argument is a pointer to a int32_t pointer. It
       is  used  as  both  an input argument and output argument. As
       input, it expects the target location to contain a pointer to
       a  possible  cpu  number  cache  to use for this thread (this
       pointer must be naturally aligned on  4-byte  multiples),  or
       contain  NULL. As output, on success, it populates the target
       location with a pointer to the location  of  the  cpu  number
       cache  for  this thread. This cpu number cache address can be
       either the one provided as input, or one  already  registered
       by this thread previously.

       The  flags argument is currently unused and must be specified
       as 0.

       Typically, a library or application will put the  cpu  number
       cache  in  a  thread-local  storage variable, or other memory
       areas belonging to each thread. It is recommended to  perform
       a  volatile  read of the cpu number cache to prevent the com=E2=80=
=90
       piler from doing load tearing. An alternative approach is  to
       read  the  cpu  number cache from inline assembly in a single
       instruction.

       Each thread is responsible for registering its own cpu number
       cache.   Only  one  cpu_cache  address  can be registered per
       thread. Following registration  will  return  the  previously
       registered address in the cpu_cachep target location.

       The  symbol  __getcpu_cache_tls  is  recommended  to  be used
       across libraries  and  applications  wishing  to  register  a
       thread-local  getcpu_cache.  The  attribute  "weak" is recom=E2=80=
=90
       mended when declaring this variable in  libraries.   Applica=E2=80=
=90
       tions  can  choose to define their own version of this symbol
       without the weak attribute as a performance improvement.

       In a typical usage scenario, the thread registering  the  cpu
       number  cache will be performing reads from that cache. It is
       however also allowed to read the cpu number cache from  other
       threads. The cpu number cache updates performed by the kernel
       provide single-copy atomicity semantics, which guarantee that
       other  threads performing single-copy atomic reads of the cpu
       number cache will always observe a consistent value.

       Memory registered as cpu number cache should never be deallo=E2=80=
=90
       cated  before  the thread which registered it exits: specifi=E2=80=
=90
       cally, it should not be freed, and the library containing the
       registered thread-local storage should not be dlclose'd.

       Unregistration  of  associated  cpu_cache are implicitly per=E2=80=
=90
       formed when a thread or process exit.

RETURN VALUE
       A return value of 0 indicates success. On success, the memory
       location  pointed  to by cpu_cachep contains the address used
       as cpu number cache for this thread, which  may  differ  from
       the address provided as input.  On error, -1 is returned, and
       errno is set appropriately.

ERRORS
       EINVAL cpu_cachep points to a location containing an  invalid
              address, cpu_cachep points to a location containing an
              address which is not aligned on 4-byte  multiples,  or
              flags is non-zero.

       ENOSYS The  getcpu_cache()  system call is not implemented by
              this kernel.

       EFAULT cpu_cachep is an invalid address, or cpu_cachep points
              to a location containing an invalid address.

VERSIONS
       The getcpu_cache() system call was added in Linux 4.X (TODO).

CONFORMING TO
       getcpu_cache() is Linux-specific.

EXAMPLE
       The  following  code  uses  the getcpu_cache() system call to
       keep a thread local storage variable up to date with the cur=E2=80=
=90
       rent  CPU  number.  For  example  simplicity,  it  is done in
       main(), but  multithreaded  programs  would  need  to  invoke
       getcpu_cache() from each program thread.

           #define _GNU_SOURCE
           #include <stdlib.h>
           #include <stdio.h>
           #include <unistd.h>
           #include <stdint.h>
           #include <sys/syscall.h>

           static inline int
           getcpu_cache(volatile int32_t **cpu_cachep, int flags)
           {
               return syscall(__NR_getcpu_cache, cpu_cachep, flags);
           }

           /*
            * __getcpu_cache_tls is recommended as symbol name. Weak
            * attribute is recommended when declaring this variable in
            * libraries. Applications can choose to define their own
            * version of this symbol without the weak attribute as a
            * performance improvement.
            */
           __thread __attribute__((weak)) volatile int32_t __getcpu_cac=
he_tls;

           int
           main(int argc, char **argv)
           {
               volatile int32_t *cpu_cache =3D &__getcpu_cache_tls;

               if (getcpu_cache(&cpu_cache, 0) < 0) {
                   perror("getcpu_cache");
                   exit(EXIT_FAILURE);
               }
               if (cpu_cache !=3D &__getcpu_cache_tls) {
                   fprintf(stderr, "Unexpected CPU cache pointer %p\n",
                           cpu_cache);
                   exit(EXIT_FAILURE);
               }

               printf("Current CPU number: %d\n", __getcpu_cache_tls);

               exit(EXIT_SUCCESS);
           }

Linux                        2016-01-27              GETCPU_CACHE(2)
---
 MAINTAINERS           |   6 +++
 fs/exec.c             |   1 +
 include/linux/sched.h |  36 +++++++++++++++++
 init/Kconfig          |  10 +++++
 kernel/Makefile       |   1 +
 kernel/fork.c         |   4 ++
 kernel/getcpu_cache.c | 106 ++++++++++++++++++++++++++++++++++++++++++=
++++++++
 kernel/sched/sched.h  |   1 +
 kernel/sys_ni.c       |   3 ++
 9 files changed, 168 insertions(+)
 create mode 100644 kernel/getcpu_cache.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 233f834..e9106b7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4712,6 +4712,12 @@ M:	Joe Perches <joe@perches.com>
 S:	Maintained
 F:	scripts/get_maintainer.pl
=20
+GETCPU_CACHE SUPPORT
+M:	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+F:	kernel/getcpu_cache.c
+
 GFS2 FILE SYSTEM
 M:	Steven Whitehouse <swhiteho@redhat.com>
 M:	Bob Peterson <rpeterso@redhat.com>
diff --git a/fs/exec.c b/fs/exec.c
index b06623a..1d66af6 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1594,6 +1594,7 @@ static int do_execveat_common(int fd, struct file=
name *filename,
 	/* execve succeeded */
 	current->fs->in_exec =3D 0;
 	current->in_execve =3D 0;
+	getcpu_cache_execve(current);
 	acct_update_integrals(current);
 	task_numa_free(current);
 	free_bprm(bprm);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index fa39434..2fa2db8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1813,6 +1813,9 @@ struct task_struct {
 	unsigned long	task_state_change;
 #endif
 	int pagefault_disabled;
+#ifdef CONFIG_GETCPU_CACHE
+	int32_t __user *cpu_cache;
+#endif
 /* CPU-specific state of this task */
 	struct thread_struct thread;
 /*
@@ -3190,4 +3193,37 @@ static inline unsigned long rlimit_max(unsigned =
int limit)
 	return task_rlimit_max(current, limit);
 }
=20
+#ifdef CONFIG_GETCPU_CACHE
+void getcpu_cache_fork(struct task_struct *t);
+void getcpu_cache_execve(struct task_struct *t);
+void getcpu_cache_exit(struct task_struct *t);
+void __getcpu_cache_handle_notify_resume(struct task_struct *t);
+static inline void getcpu_cache_set_notify_resume(struct task_struct *=
t)
+{
+	if (t->cpu_cache)
+		set_tsk_thread_flag(t, TIF_NOTIFY_RESUME);
+}
+static inline void getcpu_cache_handle_notify_resume(struct task_struc=
t *t)
+{
+	if (t->cpu_cache)
+		__getcpu_cache_handle_notify_resume(t);
+}
+#else
+static inline void getcpu_cache_fork(struct task_struct *t)
+{
+}
+static inline void getcpu_cache_execve(struct task_struct *t)
+{
+}
+static inline void getcpu_cache_exit(struct task_struct *t)
+{
+}
+static inline void getcpu_cache_set_notify_resume(struct task_struct *=
t)
+{
+}
+static inline void getcpu_cache_handle_notify_resume(struct task_struc=
t *t)
+{
+}
+#endif
+
 #endif
diff --git a/init/Kconfig b/init/Kconfig
index 235c7a2..fee2fa1 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1614,6 +1614,16 @@ config MEMBARRIER
=20
 	  If unsure, say Y.
=20
+config GETCPU_CACHE
+	bool "Enable getcpu cache" if EXPERT
+	default y
+	help
+	  Enable the getcpu cache system call. It provides a user-space
+	  cache for the current CPU number value, which speeds up
+	  getting the current CPU number from user-space.
+
+	  If unsure, say Y.
+
 config EMBEDDED
 	bool "Embedded system"
 	option allnoconfig_y
diff --git a/kernel/Makefile b/kernel/Makefile
index 53abf00..b630247 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -103,6 +103,7 @@ obj-$(CONFIG_TORTURE_TEST) +=3D torture.o
 obj-$(CONFIG_MEMBARRIER) +=3D membarrier.o
=20
 obj-$(CONFIG_HAS_IOMEM) +=3D memremap.o
+obj-$(CONFIG_GETCPU_CACHE) +=3D getcpu_cache.o
=20
 $(obj)/configs.o: $(obj)/config_data.h
=20
diff --git a/kernel/fork.c b/kernel/fork.c
index 1155eac..37d0645 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -252,6 +252,7 @@ void __put_task_struct(struct task_struct *tsk)
 	WARN_ON(tsk =3D=3D current);
=20
 	cgroup_free(tsk);
+	getcpu_cache_exit(tsk);
 	task_numa_free(tsk);
 	security_task_free(tsk);
 	exit_creds(tsk);
@@ -1554,6 +1555,9 @@ static struct task_struct *copy_process(unsigned =
long clone_flags,
 	 */
 	copy_seccomp(p);
=20
+	if (!(clone_flags & CLONE_THREAD))
+		getcpu_cache_fork(p);
+
 	/*
 	 * Process group and session signals need to be delivered to just the
 	 * parent before the fork or both the parent and the child after the
diff --git a/kernel/getcpu_cache.c b/kernel/getcpu_cache.c
new file mode 100644
index 0000000..4a1bda5
--- /dev/null
+++ b/kernel/getcpu_cache.c
@@ -0,0 +1,106 @@
+/*
+ * Copyright (C) 2015 Mathieu Desnoyers <mathieu.desnoyers@efficios.co=
m>
+ *
+ * getcpu cache system call
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+#include <linux/syscalls.h>
+
+static int getcpu_cache_update(int32_t __user *cpu_cache)
+{
+	if (put_user(raw_smp_processor_id(), cpu_cache))
+		return -1;
+	return 0;
+}
+
+/*
+ * This resume handler should always be executed between a migration
+ * triggered by preemption and return to user-space.
+ */
+void __getcpu_cache_handle_notify_resume(struct task_struct *t)
+{
+	if (unlikely(t->flags & PF_EXITING))
+		return;
+	if (getcpu_cache_update(t->cpu_cache))
+		force_sig(SIGSEGV, t);
+}
+
+/*
+ * If parent process has a thread-local ABI, the child inherits. Only =
applies
+ * when forking a process, not a thread.
+ */
+void getcpu_cache_fork(struct task_struct *t)
+{
+	t->cpu_cache =3D current->cpu_cache;
+}
+
+void getcpu_cache_execve(struct task_struct *t)
+{
+	t->cpu_cache =3D NULL;
+}
+
+void getcpu_cache_exit(struct task_struct *t)
+{
+	t->cpu_cache =3D NULL;
+}
+
+/*
+ * sys_getcpu_cache - setup getcpu cache for caller thread
+ */
+SYSCALL_DEFINE2(getcpu_cache, int32_t __user **, cpu_cachep, int, flag=
s)
+{
+	int32_t __user *cpu_cache;
+
+	if (unlikely(flags))
+		return -EINVAL;
+	/* Check if cpu_cache is already registered. */
+	if (current->cpu_cache) {
+		if (put_user(current->cpu_cache, cpu_cachep))
+			return -EFAULT;
+		return 0;
+	}
+	if (get_user(cpu_cache, cpu_cachep))
+			return -EFAULT;
+	if (unlikely(!IS_ALIGNED((unsigned long)cpu_cache, sizeof(int32_t))
+			|| !cpu_cache))
+		return -EINVAL;
+	/*
+	 * Do an initial cpu cache update to ensure we won't hit
+	 * SIGSEGV if put_user() fails in the resume notifier.
+	 */
+	if (getcpu_cache_update(cpu_cache)) {
+		return -EFAULT;
+	}
+	current->cpu_cache =3D cpu_cache;
+	/*
+	 * Migration checks the getcpu cache to see whether the
+	 * notify_resume flag should be set.
+	 * Therefore, we need to ensure that the scheduler sees
+	 * the getcpu cache pointer update before we update the getcpu
+	 * cache content with the current CPU number.
+	 *
+	 * Set cpu_cache pointer before updating content.
+	 */
+	barrier();
+	/*
+	 * Set the resume notifier to ensure we update the current CPU
+	 * number before returning to userspace if needed. This handles
+	 * migration happening between the initial
+	 * get_cpu_cache_update() call and setting the current
+	 * cpu_cache pointer.
+	 */
+	getcpu_cache_set_notify_resume(current);
+	return 0;
+}
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index b242775..3edcd13 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -957,6 +957,7 @@ static inline void __set_task_cpu(struct task_struc=
t *p, unsigned int cpu)
 {
 	set_task_rq(p, cpu);
 #ifdef CONFIG_SMP
+	getcpu_cache_set_notify_resume(p);
 	/*
 	 * After ->cpu is set up to a new value, task_rq_lock(p, ...) can be
 	 * successfuly executed on another CPU. We must ensure that updates o=
f
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 0623787..1e1c299 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -249,3 +249,6 @@ cond_syscall(sys_execveat);
=20
 /* membarrier */
 cond_syscall(sys_membarrier);
+
+/* thread-local ABI */
+cond_syscall(sys_getcpu_cache);
--=20
2.1.4
