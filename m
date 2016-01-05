From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH 1/3] getcpu_cache system call: cache CPU number of running thread
Date: Tue,  5 Jan 2016 02:01:58 -0500
Message-ID: <1451977320-4886-2-git-send-email-mathieu.desnoyers@efficios.com>
References: <1451977320-4886-1-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1451977320-4886-1-git-send-email-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Expose a new system call allowing threads to register userspace memory
areas where to store the CPU number on which the calling thread is
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

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
CC: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
CC: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
CC: Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
CC: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
CC: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
CC: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
CC: Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
CC: Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
CC: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>
CC: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
CC: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
CC: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
CC: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
CC: Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
CC: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
CC: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
CC: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
Man page associated:

GETCPU_CACHE(2)       Linux Programmer's Manual      GETCPU_CACHE(2)

NAME
       getcpu_cache  -  cache CPU number on which the calling thread
       is running

SYNOPSIS
       #include <linux/getcpu_cache.h>

       int getcpu_cache(int cmd, int32_t * cpu_cache, int flags);

DESCRIPTION
       The getcpu_cache() helps speeding up reading the current  CPU
       number  by ensuring that memory locations registered by user-
       space threads are always updated with the CPU number on which
       the thread is running when reading those memory locations.

       The cpu_cache argument is a pointer to a int32_t.

       The cmd argument is one of the following:

       GETCPU_CACHE_CMD_REGISTER
              Register the cpu_cache given as parameter for the cur=E2=80=
=90
              rent thread.

       GETCPU_CACHE_CMD_UNREGISTER
              Unregister the cpu_cache given as parameter  from  the
              current thread.

       The  flags argument is currently unused and must be specified
       as 0.

       Typically, a library or application will put the cpu_cache in
       a  thread-local  storage  variable,  or  other  memory  areas
       belonging to each thread. It  is  recommended  to  perform  a
       volatile  read  of the cpu_cache to prevent the compiler from
       doing load tearing. An alternative approach is  to  read  the
       cpu_cache from inline assembly in a single instruction.

       Each thread is responsible for registering its own cpu_cache.
       It is possible to register many cpu_cache for a given thread,
       for instance from different libraries.

       Unregistration  of  associated  cpu_cache are implicitly per=E2=80=
=90
       formed when a thread or process exit.

RETURN VALUE
       A return value of 0  indicates  success.   On  error,  -1  is
       returned, and errno is set appropriately.

ERRORS
       EINVAL cmd  is unsupported, cpu_cache is invalid, or flags is
              non-zero.

       ENOSYS The getcpu_cache() system call is not  implemented  by
              this kernel.

       EBUSY  cmd  is  GETCPU_CACHE_CMD_REGISTER  and  cpu_cache  is
              already registered for this thread.

       EFAULT cmd is GETCPU_CACHE_CMD_REGISTER and the memory  loca=E2=80=
=90
              tion specified by cpu_cache is a bad address.

       ENOENT cmd  is GETCPU_CACHE_CMD_UNREGISTER and cpu_cache can=E2=80=
=90
              not be found for this thread.

       ENOMEM cmd is GETCPU_CACHE_CMD_UNREGISTER and the kernel  has
              run out of memory.

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
           #include <linux/getcpu_cache.h>

           static inline int
           getcpu_cache(int cmd, volatile int32_t *cpu_cache, int flags=
)
           {
               return syscall(__NR_getcpu_cache, cmd, cpu_cache, flags)=
;
           }

           static __thread volatile int32_t getcpu_cache_tls;

           int
           main(int argc, char **argv)
           {
               if (getcpu_cache(GETCPU_CACHE_CMD_REGISTER,
                     &getcpu_cache_tls, 0) < 0) {
                   perror("getcpu_cache register");
                   exit(EXIT_FAILURE);
               }

               printf("Current CPU number: %d\n", getcpu_cache_tls);

               if (getcpu_cache(GETCPU_CACHE_CMD_UNREGISTER,
                     &getcpu_cache_tls, 0) < 0) {
                   perror("getcpu_cache unregister");
                   exit(EXIT_FAILURE);
               }
               exit(EXIT_SUCCESS);
           }

Linux                        2016-01-01              GETCPU_CACHE(2)

Rationale for the getcpu_cache system call rather than the thread-local
ABI system call proposed earlier:

Rather than doing a "generic" thread-local ABI, specialize this system
call for a cpu number cache only. Anyway, the thread-local ABI approach
would have required that we introduce "feature" flags, which would have
ended up reimplementing multiplexing of features on top of a system
call. It seems better to introduce one system call per feature instead.
---
 fs/exec.c                         |   1 +
 include/linux/init_task.h         |   8 ++
 include/linux/sched.h             |  43 ++++++++++
 include/uapi/linux/Kbuild         |   1 +
 include/uapi/linux/getcpu_cache.h |  44 ++++++++++
 init/Kconfig                      |  10 +++
 kernel/Makefile                   |   1 +
 kernel/fork.c                     |   7 ++
 kernel/getcpu_cache.c             | 170 ++++++++++++++++++++++++++++++=
++++++++
 kernel/sched/core.c               |   3 +
 kernel/sched/sched.h              |   1 +
 kernel/sys_ni.c                   |   3 +
 12 files changed, 292 insertions(+)
 create mode 100644 include/uapi/linux/getcpu_cache.h
 create mode 100644 kernel/getcpu_cache.c

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
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 1c1ff7e..5097798 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -183,6 +183,13 @@ extern struct task_group root_task_group;
 # define INIT_KASAN(tsk)
 #endif
=20
+#ifdef CONFIG_GETCPU_CACHE
+# define INIT_GETCPU_CACHE(tsk)						\
+	.getcpu_cache_head =3D LIST_HEAD_INIT(tsk.getcpu_cache_head),
+#else
+# define INIT_GETCPU_CACHE(tsk)
+#endif
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=3D0, limit=3D0x1fffff (=3D2MB)
@@ -260,6 +267,7 @@ extern struct task_group root_task_group;
 	INIT_VTIME(tsk)							\
 	INIT_NUMA_BALANCING(tsk)					\
 	INIT_KASAN(tsk)							\
+	INIT_GETCPU_CACHE(tsk)						\
 }
=20
=20
diff --git a/include/linux/sched.h b/include/linux/sched.h
index edad7a4..044fa79 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1375,6 +1375,11 @@ struct tlbflush_unmap_batch {
 	bool writable;
 };
=20
+struct getcpu_cache_entry {
+	int32_t __user *cpu_cache;
+	struct list_head entry;
+};
+
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	void *stack;
@@ -1812,6 +1817,10 @@ struct task_struct {
 	unsigned long	task_state_change;
 #endif
 	int pagefault_disabled;
+#ifdef CONFIG_GETCPU_CACHE
+	/* list of struct getcpu_cache_entry */
+	struct list_head getcpu_cache_head;
+#endif
 /* CPU-specific state of this task */
 	struct thread_struct thread;
 /*
@@ -3188,4 +3197,38 @@ static inline unsigned long rlimit_max(unsigned =
int limit)
 	return task_rlimit_max(current, limit);
 }
=20
+#ifdef CONFIG_GETCPU_CACHE
+int getcpu_cache_fork(struct task_struct *t);
+void getcpu_cache_execve(struct task_struct *t);
+void getcpu_cache_exit(struct task_struct *t);
+void __getcpu_cache_handle_notify_resume(struct task_struct *t);
+static inline void getcpu_cache_set_notify_resume(struct task_struct *=
t)
+{
+	if (!list_empty(&t->getcpu_cache_head))
+		set_tsk_thread_flag(t, TIF_NOTIFY_RESUME);
+}
+static inline void getcpu_cache_handle_notify_resume(struct task_struc=
t *t)
+{
+	if (!list_empty(&t->getcpu_cache_head))
+		__getcpu_cache_handle_notify_resume(t);
+}
+#else
+static inline int getcpu_cache_fork(struct task_struct *t)
+{
+	return 0;
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
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 628e6e6..6be3724 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -136,6 +136,7 @@ header-y +=3D futex.h
 header-y +=3D gameport.h
 header-y +=3D genetlink.h
 header-y +=3D gen_stats.h
+header-y +=3D getcpu_cache.h
 header-y +=3D gfs2_ondisk.h
 header-y +=3D gigaset_dev.h
 header-y +=3D gsmmux.h
diff --git a/include/uapi/linux/getcpu_cache.h b/include/uapi/linux/get=
cpu_cache.h
new file mode 100644
index 0000000..4cd1bd4
--- /dev/null
+++ b/include/uapi/linux/getcpu_cache.h
@@ -0,0 +1,44 @@
+#ifndef _UAPI_LINUX_GETCPU_CACHE_H
+#define _UAPI_LINUX_GETCPU_CACHE_H
+
+/*
+ * linux/getcpu_cache.h
+ *
+ * getcpu_cache system call API
+ *
+ * Copyright (c) 2015 Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/fQFizaE/u3fw@public.gmane.org=
m>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaini=
ng a copy
+ * of this software and associated documentation files (the "Software"=
), to deal
+ * in the Software without restriction, including without limitation t=
he rights
+ * to use, copy, modify, merge, publish, distribute, sublicense, and/o=
r sell
+ * copies of the Software, and to permit persons to whom the Software =
is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be incl=
uded in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXP=
RESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABI=
LITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT S=
HALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OT=
HER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARI=
SING FROM,
+ * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALI=
NGS IN THE
+ * SOFTWARE.
+ */
+
+/**
+ * enum getcpu_cache_cmd - getcpu_cache system call command
+ * @GETCPU_CACHE_CMD_REGISTER:   Register the cpu_cache for the curren=
t
+ *				 thread.
+ * @GETCPU_CACHE_CMD_UNREGISTER: Unregister the cpu_cache from the cur=
rent
+ *				 thread.
+ *
+ * Command to be passed to the getcpu_cache system call.
+ */
+enum getcpu_cache_cmd {
+	GETCPU_CACHE_CMD_REGISTER =3D (1 << 0),
+	GETCPU_CACHE_CMD_UNREGISTER =3D (1 << 1),
+};
+
+#endif /* _UAPI_LINUX_GETCPU_CACHE_H */
diff --git a/init/Kconfig b/init/Kconfig
index c24b6f7..61287ff 100644
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
index f97f2c4..2d8aba6 100644
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
@@ -1554,6 +1555,12 @@ static struct task_struct *copy_process(unsigned=
 long clone_flags,
 	 */
 	copy_seccomp(p);
=20
+	if (!(clone_flags & CLONE_THREAD)) {
+		retval =3D -ENOMEM;
+		if (getcpu_cache_fork(p))
+			goto bad_fork_cancel_cgroup;
+	}
+
 	/*
 	 * Process group and session signals need to be delivered to just the
 	 * parent before the fork or both the parent and the child after the
diff --git a/kernel/getcpu_cache.c b/kernel/getcpu_cache.c
new file mode 100644
index 0000000..d15d5a8
--- /dev/null
+++ b/kernel/getcpu_cache.c
@@ -0,0 +1,170 @@
+/*
+ * Copyright (C) 2015 Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/fQFizaE/u3fw@public.gmane.org=
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
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+#include <linux/syscalls.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/getcpu_cache.h>
+
+static struct getcpu_cache_entry *
+	add_thread_entry(struct task_struct *t,
+		int32_t __user *cpu_cache)
+{
+	struct getcpu_cache_entry *te;
+
+	te =3D kmalloc(sizeof(*te), GFP_KERNEL);
+	if (!te)
+		return NULL;
+	te->cpu_cache =3D cpu_cache;
+	list_add(&te->entry, &t->getcpu_cache_head);
+	return te;
+}
+
+static void remove_thread_entry(struct getcpu_cache_entry *te)
+{
+	list_del(&te->entry);
+	kfree(te);
+}
+
+static void remove_all_thread_entry(struct task_struct *t)
+{
+	struct getcpu_cache_entry *te, *te_tmp;
+
+	list_for_each_entry_safe(te, te_tmp, &t->getcpu_cache_head, entry)
+		remove_thread_entry(te);
+}
+
+static struct getcpu_cache_entry *
+	find_thread_entry(struct task_struct *t,
+		int32_t __user *cpu_cache)
+{
+	struct getcpu_cache_entry *te;
+
+	list_for_each_entry(te, &t->getcpu_cache_head, entry) {
+		if (te->cpu_cache =3D=3D cpu_cache)
+			return te;
+	}
+	return NULL;
+}
+
+static int getcpu_cache_update_entry(struct getcpu_cache_entry *te)
+{
+	if (put_user(raw_smp_processor_id(), te->cpu_cache)) {
+		/*
+		 * Force unregistration of each entry causing
+		 * put_user() errors.
+		 */
+		remove_thread_entry(te);
+		return -1;
+	}
+	return 0;
+
+}
+
+static int getcpu_cache_update(struct task_struct *t)
+{
+	struct getcpu_cache_entry *te, *te_tmp;
+	int err =3D 0;
+
+	list_for_each_entry_safe(te, te_tmp, &t->getcpu_cache_head, entry) {
+		if (getcpu_cache_update_entry(te))
+			err =3D -1;
+	}
+	return err;
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
+	if (getcpu_cache_update(t))
+		force_sig(SIGSEGV, t);
+}
+
+/*
+ * If parent process has a thread-local ABI, the child inherits. Only =
applies
+ * when forking a process, not a thread.
+ */
+int getcpu_cache_fork(struct task_struct *t)
+{
+	struct getcpu_cache_entry *te;
+
+	list_for_each_entry(te, &current->getcpu_cache_head, entry) {
+		if (!add_thread_entry(t, te->cpu_cache))
+			return -1;
+	}
+	return 0;
+}
+
+void getcpu_cache_execve(struct task_struct *t)
+{
+	remove_all_thread_entry(t);
+}
+
+void getcpu_cache_exit(struct task_struct *t)
+{
+	remove_all_thread_entry(t);
+}
+
+/*
+ * sys_getcpu_cache - setup getcpu cache for caller thread
+ */
+SYSCALL_DEFINE3(getcpu_cache, int, cmd, int32_t __user *, cpu_cache,
+		int, flags)
+{
+	struct getcpu_cache_entry *te;
+
+	if (unlikely(!cpu_cache || flags))
+		return -EINVAL;
+	te =3D find_thread_entry(current, cpu_cache);
+	switch (cmd) {
+	case GETCPU_CACHE_CMD_REGISTER:
+		/* Attempt to register cpu_cache. Check if already there. */
+		if (te)
+			return -EBUSY;
+		te =3D add_thread_entry(current, cpu_cache);
+		if (!te)
+			return -ENOMEM;
+		/*
+		 * Migration walks the getcpu cache entry list to see
+		 * whether the notify_resume flag should be set.
+		 * Therefore, we need to ensure that the scheduler sees
+		 * the list update before we update the getcpu cache
+		 * content with the current CPU number.
+		 *
+		 * Add thread entry to list before updating content.
+		 */
+		barrier();
+		if (getcpu_cache_update_entry(te))
+			return -EFAULT;
+		return 0;
+	case GETCPU_CACHE_CMD_UNREGISTER:
+		/* Unregistration is requested. */
+		if (!te)
+			return -ENOENT;
+		remove_thread_entry(te);
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4d568ac..2e93411 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2120,6 +2120,9 @@ static void __sched_fork(unsigned long clone_flag=
s, struct task_struct *p)
=20
 	p->numa_group =3D NULL;
 #endif /* CONFIG_NUMA_BALANCING */
+#ifdef CONFIG_GETCPU_CACHE
+	INIT_LIST_HEAD(&p->getcpu_cache_head);
+#endif
 }
=20
 DEFINE_STATIC_KEY_FALSE(sched_numa_balancing);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index efd3bfc..8f6d5d3 100644
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
