From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH v2 1/3] thread_local_abi system call: caching current CPU number
Date: Tue, 22 Dec 2015 13:02:11 -0500
Message-ID: <1450807333-22104-1-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Expose a new system call allowing threads to register userspace memory
areas where to store the current CPU number. Scheduler migration sets t=
he
TIF_NOTIFY_RESUME flag on the current thread. Upon return to user-space=
,
a notify-resume handler updates the current CPU value within that
user-space memory area.

This getcpu cache is an alternative to the sched_getcpu() vdso which ha=
s
a few benefits:

- A memory read is faster that an "lsl" instruction (x86),
- A memory read is faster that performing a function call (x86),
- A memory read is of course faster than a system call,
- This cached value can be read from within an inline assembly, which
  makes it a useful building block for restartable sequences.
- The getcpu cache approach is portable (e.g. ARM 32), which is not the
  case for the segment-based x86 vdso.

This approach is inspired by Paul Turner and Andrew Hunter's work
on percpu atomics, which lets the kernel handle restart of critical
sections:
Ref.:
* https://lkml.org/lkml/2015/10/27/1095
* https://lkml.org/lkml/2015/6/24/665
* https://lwn.net/Articles/650333/
* http://www.linuxplumbersconf.org/2013/ocw/system/presentations/1695/o=
riginal/LPC%20-%20PerCpu%20Atomics.pdf

Benchmarking various approaches for reading the current CPU number
on a x86-64 Intel(R) Xeon(R) CPU E5-2630 v3 @ 2.40GHz:

- Baseline (empty loop):                1.0 ns
- Read CPU from thread-local ABI:       1.0 ns
- "lsl" inline assembly:               11.2 ns
- glibc 2.19-0ubuntu6.6 getcpu:        14.3 ns
- getcpu system call:                  51.0 ns

The system call can be extended by registering a larger structure in
the future.

Man page associated:

THREAD_LOCAL_ABI(2)        Linux Programmer's Manual       THREAD_LOCAL=
_ABI(2)

NAME
       thread_local_abi - Interface between user-space threads and the =
kernel

SYNOPSIS
       #include <linux/thread_local_abi.h>

       ssize_t  thread_local_abi(struct  thread_local_abi  * tlap, size=
_t len,
       int flags);

DESCRIPTION
       The thread_local_abi() helps speeding up some frequent operation=
s  such
       as reading the current CPU number by ensuring that the memory lo=
cations
       registered by user-space threads are always updated  with  the  =
current
       information.

       The tlap argument is a pointer to a struct thread_local_abi.

       The  len argument is the size of the struct thread_local_abi. If=
 len is
       greater than 0, it means the tlap should be registered for the  =
current
       thread.  A len of 0 means that the tlap should be unregistered f=
rom the
       current thread.

       The flags argument is currently unused and must be specified as =
0.

       Typically, a library or application will put struct thread_local=
_abi in
       a  thread-local  storage  variable,  or other memory areas belon=
ging to
       each thread.

       Each thread is responsible for registering its own thread-local =
ABI. It
       is  possible  to register many thread-local ABI for a given thre=
ad, for
       instance from different libraries.

RETURN VALUE
       When thread_local_abi is invoked with len  greater  than  0  (re=
gistra=E2=80=90
       tion),  a  return  value  greater  or equal to 0 indicates succe=
ss. The
       value returned is the minimum between the len argument and  the =
 struct
       thread_local_abi  length  supported by the kernel.  This should =
be used
       to check whether the kernel supports the fields required by user=
-space.
       On error, -1 is returned, and errno is set appropriately.

       When  thread_local_abi  is  invoked  with a 0 len argument (unre=
gistra=E2=80=90
       tion), a return  value  of  0  indicates  success.   On  error, =
 -1  is
       returned, and errno is set appropriately.

ERRORS
       EINVAL tlap is invalid or flags is non-zero.

       ENOSYS The  thread_local_abi()  system  call is not implemented =
by this
              kernel.

       ENOENT len is 0 (unregistration) and tlap  cannot  be  found  fo=
r  this
              thread.

       EBUSY  len  is greater than 0 (registration) and tlap is already=
 regis=E2=80=90
              tered for this thread.

       ENOMEM len is greater than 0 (registration) and we have run out =
of mem=E2=80=90
              ory.

       EFAULT len  is  greater  than  0 (registration) and the memory l=
ocation
              specified by tlap is a bad address.

VERSIONS
       The thread_local_abi() system call was added in Linux 4.N (TODO)=
=2E

CONFORMING TO
       thread_local_abi() is Linux-specific.

Linux                             2015-12-22               THREAD_LOCAL=
_ABI(2)

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
Changes since v1:
* Allow multiple libraries to register their per-thread memory area.
* Split system call wire up into separate patches.
* Added man page to changelog.
* This patchset applies on top of Linux 4.3.
---
 fs/exec.c                             |   1 +
 include/linux/init_task.h             |   8 ++
 include/linux/sched.h                 |  40 ++++++++
 include/uapi/linux/Kbuild             |   1 +
 include/uapi/linux/thread_local_abi.h |  37 ++++++++
 init/Kconfig                          |   9 ++
 kernel/Makefile                       |   1 +
 kernel/fork.c                         |   7 ++
 kernel/sched/core.c                   |   3 +
 kernel/sched/sched.h                  |   2 +
 kernel/sys_ni.c                       |   3 +
 kernel/thread_local_abi.c             | 174 ++++++++++++++++++++++++++=
++++++++
 12 files changed, 286 insertions(+)
 create mode 100644 include/uapi/linux/thread_local_abi.h
 create mode 100644 kernel/thread_local_abi.c

diff --git a/fs/exec.c b/fs/exec.c
index b06623a..88490cc 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1594,6 +1594,7 @@ static int do_execveat_common(int fd, struct file=
name *filename,
 	/* execve succeeded */
 	current->fs->in_exec =3D 0;
 	current->in_execve =3D 0;
+	thread_local_abi_execve(current);
 	acct_update_integrals(current);
 	task_numa_free(current);
 	free_bprm(bprm);
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 1c1ff7e..69dd780 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -183,6 +183,13 @@ extern struct task_group root_task_group;
 # define INIT_KASAN(tsk)
 #endif
=20
+#ifdef CONFIG_THREAD_LOCAL_ABI
+# define INIT_THREAD_LOCAL_ABI(tsk)					\
+	.thread_local_abi_head	=3D LIST_HEAD_INIT(tsk.thread_local_abi_head),
+#else
+# define INIT_THREAD_LOCAL_ABI(tsk)
+#endif
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=3D0, limit=3D0x1fffff (=3D2MB)
@@ -260,6 +267,7 @@ extern struct task_group root_task_group;
 	INIT_VTIME(tsk)							\
 	INIT_NUMA_BALANCING(tsk)					\
 	INIT_KASAN(tsk)							\
+	INIT_THREAD_LOCAL_ABI(tsk)					\
 }
=20
=20
diff --git a/include/linux/sched.h b/include/linux/sched.h
index edad7a4..9cf8917 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2,6 +2,7 @@
 #define _LINUX_SCHED_H
=20
 #include <uapi/linux/sched.h>
+#include <uapi/linux/thread_local_abi.h>
=20
 #include <linux/sched/prio.h>
=20
@@ -1375,6 +1376,12 @@ struct tlbflush_unmap_batch {
 	bool writable;
 };
=20
+struct thread_local_abi_entry {
+	size_t thread_local_abi_len;
+	struct thread_local_abi __user *thread_local_abi;
+	struct list_head entry;
+};
+
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	void *stack;
@@ -1812,6 +1819,10 @@ struct task_struct {
 	unsigned long	task_state_change;
 #endif
 	int pagefault_disabled;
+#ifdef CONFIG_THREAD_LOCAL_ABI
+	/* list of struct thread_local_abi_entry */
+	struct list_head thread_local_abi_head;
+#endif
 /* CPU-specific state of this task */
 	struct thread_struct thread;
 /*
@@ -3188,4 +3199,33 @@ static inline unsigned long rlimit_max(unsigned =
int limit)
 	return task_rlimit_max(current, limit);
 }
=20
+#ifdef CONFIG_THREAD_LOCAL_ABI
+int thread_local_abi_fork(struct task_struct *t);
+void thread_local_abi_execve(struct task_struct *t);
+void thread_local_abi_exit(struct task_struct *t);
+void thread_local_abi_handle_notify_resume(struct task_struct *t);
+static inline bool thread_local_abi_active(struct task_struct *t)
+{
+	return !list_empty(&t->thread_local_abi_head);
+}
+#else
+static inline int thread_local_abi_fork(struct task_struct *t)
+{
+	return 0;
+}
+static inline void thread_local_abi_execve(struct task_struct *t)
+{
+}
+static inline void thread_local_abi_exit(struct task_struct *t)
+{
+}
+static inline void thread_local_abi_handle_notify_resume(struct task_s=
truct *t)
+{
+}
+static inline bool thread_local_abi_active(struct task_struct *t)
+{
+	return false;
+}
+#endif
+
 #endif
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 628e6e6..5df5460 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -397,6 +397,7 @@ header-y +=3D tcp_metrics.h
 header-y +=3D telephony.h
 header-y +=3D termios.h
 header-y +=3D thermal.h
+header-y +=3D thread_local_abi.h
 header-y +=3D time.h
 header-y +=3D times.h
 header-y +=3D timex.h
diff --git a/include/uapi/linux/thread_local_abi.h b/include/uapi/linux=
/thread_local_abi.h
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
+#include <linux/types.h>
+
+/* This structure is an ABI that can only be extended. */
+struct thread_local_abi {
+	int32_t cpu;
+};
+
+#endif /* _UAPI_LINUX_THREAD_LOCAL_ABI_H */
diff --git a/init/Kconfig b/init/Kconfig
index c24b6f7..e1a6bf8 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1614,6 +1614,15 @@ config MEMBARRIER
=20
 	  If unsure, say Y.
=20
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
index 53abf00..327fbd9 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -103,6 +103,7 @@ obj-$(CONFIG_TORTURE_TEST) +=3D torture.o
 obj-$(CONFIG_MEMBARRIER) +=3D membarrier.o
=20
 obj-$(CONFIG_HAS_IOMEM) +=3D memremap.o
+obj-$(CONFIG_THREAD_LOCAL_ABI) +=3D thread_local_abi.o
=20
 $(obj)/configs.o: $(obj)/config_data.h
=20
diff --git a/kernel/fork.c b/kernel/fork.c
index f97f2c4..02526e8 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -252,6 +252,7 @@ void __put_task_struct(struct task_struct *tsk)
 	WARN_ON(tsk =3D=3D current);
=20
 	cgroup_free(tsk);
+	thread_local_abi_exit(tsk);
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
+		if (thread_local_abi_fork(p))
+			goto bad_fork_cancel_cgroup;
+	}
+
 	/*
 	 * Process group and session signals need to be delivered to just the
 	 * parent before the fork or both the parent and the child after the
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4d568ac..f26babf 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2120,6 +2120,9 @@ static void __sched_fork(unsigned long clone_flag=
s, struct task_struct *p)
=20
 	p->numa_group =3D NULL;
 #endif /* CONFIG_NUMA_BALANCING */
+#ifdef CONFIG_THREAD_LOCAL_ABI
+	INIT_LIST_HEAD(&p->thread_local_abi_head);
+#endif
 }
=20
 DEFINE_STATIC_KEY_FALSE(sched_numa_balancing);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index efd3bfc..371aa8f 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -957,6 +957,8 @@ static inline void __set_task_cpu(struct task_struc=
t *p, unsigned int cpu)
 {
 	set_task_rq(p, cpu);
 #ifdef CONFIG_SMP
+	if (thread_local_abi_active(p))
+		set_tsk_thread_flag(p, TIF_NOTIFY_RESUME);
 	/*
 	 * After ->cpu is set up to a new value, task_rq_lock(p, ...) can be
 	 * successfuly executed on another CPU. We must ensure that updates o=
f
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 0623787..e803824 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -249,3 +249,6 @@ cond_syscall(sys_execveat);
=20
 /* membarrier */
 cond_syscall(sys_membarrier);
+
+/* thread-local ABI */
+cond_syscall(sys_thread_local_abi);
diff --git a/kernel/thread_local_abi.c b/kernel/thread_local_abi.c
new file mode 100644
index 0000000..8e60259
--- /dev/null
+++ b/kernel/thread_local_abi.c
@@ -0,0 +1,174 @@
+/*
+ * Copyright (C) 2015 Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/fQFizaE/u3fw@public.gmane.org=
m>
+ *
+ * thread_local_abi system call
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
+
+static struct thread_local_abi_entry *
+	add_thread_entry(struct task_struct *t,
+		size_t abi_len,
+		struct thread_local_abi __user *ptr)
+{
+	struct thread_local_abi_entry *te;
+
+	te =3D kmalloc(sizeof(*te), GFP_KERNEL);
+	if (!te)
+		return NULL;
+	te->thread_local_abi_len =3D abi_len;
+	te->thread_local_abi =3D ptr;
+	list_add(&te->entry, &t->thread_local_abi_head);
+	return te;
+}
+
+static void remove_thread_entry(struct thread_local_abi_entry *te)
+{
+	list_del(&te->entry);
+	kfree(te);
+}
+
+static void remove_all_thread_entry(struct task_struct *t)
+{
+	struct thread_local_abi_entry *te, *te_tmp;
+
+	list_for_each_entry_safe(te, te_tmp, &t->thread_local_abi_head, entry=
)
+		remove_thread_entry(te);
+}
+
+static struct thread_local_abi_entry *
+	find_thread_entry(struct task_struct *t,
+		struct thread_local_abi __user *ptr)
+{
+	struct thread_local_abi_entry *te;
+
+	list_for_each_entry(te, &t->thread_local_abi_head, entry) {
+		if (te->thread_local_abi =3D=3D ptr)
+			return te;
+	}
+	return NULL;
+}
+
+static int thread_local_abi_update_entry(struct thread_local_abi_entry=
 *te)
+{
+	if (te->thread_local_abi_len <
+			offsetof(struct thread_local_abi, cpu)
+				+ sizeof(te->thread_local_abi->cpu))
+		return 0;
+	if (put_user(raw_smp_processor_id(), &te->thread_local_abi->cpu)) {
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
+static int thread_local_abi_update(struct task_struct *t)
+{
+	struct thread_local_abi_entry *te, *te_tmp;
+	int err =3D 0;
+
+	list_for_each_entry_safe(te, te_tmp, &t->thread_local_abi_head, entry=
) {
+		if (thread_local_abi_update_entry(te))
+			err =3D -1;
+	}
+	return err;
+}
+
+/*
+ * This resume handler should always be executed between a migration
+ * triggered by preemption and return to user-space.
+ */
+void thread_local_abi_handle_notify_resume(struct task_struct *t)
+{
+	BUG_ON(!thread_local_abi_active(t));
+	if (unlikely(t->flags & PF_EXITING))
+		return;
+	if (thread_local_abi_update(t))
+		force_sig(SIGSEGV, t);
+}
+
+/*
+ * If parent process has a thread-local ABI, the child inherits. Only =
applies
+ * when forking a process, not a thread.
+ */
+int thread_local_abi_fork(struct task_struct *t)
+{
+	struct thread_local_abi_entry *te;
+
+	list_for_each_entry(te, &current->thread_local_abi_head, entry) {
+		if (!add_thread_entry(t, te->thread_local_abi_len,
+				te->thread_local_abi))
+			return -1;
+	}
+	return 0;
+}
+
+void thread_local_abi_execve(struct task_struct *t)
+{
+	remove_all_thread_entry(t);
+}
+
+void thread_local_abi_exit(struct task_struct *t)
+{
+	remove_all_thread_entry(t);
+}
+
+/*
+ * sys_thread_local_abi - setup thread-local ABI for caller thread
+ */
+SYSCALL_DEFINE3(thread_local_abi, struct thread_local_abi __user *, tl=
ap,
+		size_t, len, int, flags)
+{
+	size_t minlen;
+	struct thread_local_abi_entry *te;
+
+	if (flags || !tlap)
+		return -EINVAL;
+	te =3D find_thread_entry(current, tlap);
+	if (!len) {
+		/* Unregistration is requested by a 0 len argument. */
+		if (!te)
+			return -ENOENT;
+		remove_thread_entry(te);
+		return 0;
+	}
+	/* Attempt to register tlap. Check if already there. */
+	if (te)
+		return -EBUSY;
+	/* Agree on the intersection of userspace and kernel features. */
+	minlen =3D min_t(size_t, len, sizeof(struct thread_local_abi));
+	te =3D add_thread_entry(current, minlen, tlap);
+	if (!te)
+		return -ENOMEM;
+	/*
+	 * Migration walks the thread local abi entry list to see
+	 * whether the notify_resume flag should be set. Therefore, we
+	 * need to ensure that the scheduler sees the list update before
+	 * we update the thread local abi content with the current CPU
+	 * number.
+	 */
+	barrier();	/* Add thread entry to list before updating content. */
+	if (thread_local_abi_update_entry(te))
+		return -EFAULT;
+	return minlen;
+}
--=20
2.1.4
