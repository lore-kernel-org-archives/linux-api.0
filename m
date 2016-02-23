From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v4 1/5] getcpu_cache system call: cache CPU number of running thread
Date: Tue, 23 Feb 2016 18:28:36 -0500
Message-ID: <1456270120-7560-2-git-send-email-mathieu.desnoyers@efficios.com>
References: <1456270120-7560-1-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456270120-7560-1-git-send-email-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
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
sections. [1] [2]

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

[1] https://lwn.net/Articles/650333/
[2] http://www.linuxplumbersconf.org/2013/ocw/system/presentations/1695=
/original/LPC%20-%20PerCpu%20Atomics.pdf

Link: http://lkml.kernel.org/r/20151027235635.16059.11630.stgit@pjt-gla=
ptop.roam.corp.google.com
Link: http://lkml.kernel.org/r/20150624222609.6116.86035.stgit@kitami.m=
tv.corp.google.com
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
CC: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
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
- Return -1, errno=3DEINVAL if cpu_cache pointer is not aligned on
  sizeof(int32_t).
- Update man page to describe the pointer alignement requirements and
  update atomicity guarantees.
- Add MAINTAINERS file GETCPU_CACHE entry.
- Remove dynamic memory allocation: go back to having a single
  getcpu_cache entry per thread. Update documentation accordingly.
- Rebased on Linux 4.4.

Changes since v2:
- Introduce a "cmd" argument, along with an enum with GETCPU_CACHE_GET
  and GETCPU_CACHE_SET. Introduce a uapi header linux/getcpu_cache.h
  defining this enumeration.
- Split resume notifier architecture implementation from the system cal=
l
  wire up in the following arch-specific patches.
- Man pages updates.
- Handle 32-bit compat pointers.
- Simplify handling of getcpu_cache GETCPU_CACHE_SET compiler barrier:
  set the current cpu cache pointer before doing the cache update, and
  set it back to NULL if the update fails. Setting it back to NULL on
  error ensures that no resume notifier will trigger a SIGSEGV if a
  migration happened concurrently.

Changes since v3:
- Fix __user annotations in compat code,
- Update memory ordering comments.
- Rebased on kernel v4.5-rc5.

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
       #include <linux/getcpu_cache.h>
       #include <stdint.h>

       int getcpu_cache(int cmd, int32_t **cpu_cachep, int flags);

DESCRIPTION
       The getcpu_cache() helps speeding up reading the current  CPU
       number  by  ensuring  that  the memory location registered by
       each user-space thread is always updated with the CPU  number
       on which the thread is running when reading that memory loca=E2=80=
=90
       tion.

       The cmd argument is one of the following:

       GETCPU_CACHE_GET
              Get the pointer to the current cpu number  cache  into
              the   memory   location  targeted  by  the  cpu_cachep
              pointer.

       GETCPU_CACHE_SET
              Attempt to set the current cpu number cache  by  using
              the pointer located in the memory location targeted by
              the cpu_cachep pointer. This pointer must  be  aligned
              on 4-byte multiples (natural alignment).

       The cpu_cachep argument is a pointer to a int32_t pointer. It
       is used as an output argument for GETCPU_CACHE_GET, and as an
       input argument for GETCPU_CACHE_SET.

       The  flags argument is currently unused and must be specified
       as 0.

       Typically, a library or application will keep the cpu  number
       cache  in  a  thread-local  storage variable, or other memory
       areas belonging to each thread. It is recommended to  perform
       a  volatile  read of the cpu number cache to prevent the com=E2=80=
=90
       piler from doing load tearing. An alternative approach is  to
       read  the  cpu  number cache from inline assembly in a single
       instruction.

       Each thread is responsible for registering its own cpu number
       cache.   Only  one  cpu  cache  address can be registered per
       thread.

       The symbol  __getcpu_cache_tls  is  recommended  to  be  used
       across  libraries  and  applications  wishing  to  register a
       thread-local getcpu_cache. The  attribute  "weak"  is  recom=E2=80=
=90
       mended  when  declaring this variable in libraries.  Applica=E2=80=
=90
       tions can choose to define their own version of  this  symbol
       without the weak attribute as a performance improvement.

       In  a  typical usage scenario, the thread registering the cpu
       number cache will be performing reads from that cache. It  is
       however  also allowed to read the cpu number cache from other
       threads. The cpu number cache updates performed by the kernel
       provide single-copy atomicity semantics, which guarantee that
       other threads performing single-copy atomic reads of the  cpu
       number cache will always observe a consistent value.

       Memory registered as cpu number cache should never be deallo=E2=80=
=90
       cated before the thread which registered it  exits:  specifi=E2=80=
=90
       cally, it should not be freed, and the library containing the
       registered thread-local storage should not be dlclose'd.

       Unregistration of associated cpu  cache  is  implicitly  per=E2=80=
=90
       formed when a thread or process exit.

RETURN VALUE
       A  return  value  of  0  indicates  success.  On error, -1 is
       returned, and errno is set appropriately.

ERRORS
       EINVAL Either flags is non-zero,  an  invalid  cmd  has  been
              specified,  or  the  GETCPU_CACHE_GET command has been
              specified and cpu_cachep points to a location contain=E2=80=
=90
              ing  an  invalid  address,  or  cpu_cachep points to a
              location containing an address which is not aligned on
              4-byte multiples.

       ENOSYS The  getcpu_cache()  system call is not implemented by
              this kernel.

       EFAULT cpu_cachep is an invalid address, or cpu_cachep points
              to a location containing an invalid address.

       EBUSY  The GETCPU_CACHE_SET command has been specified, and a
              cpu cache address which differs from  the  content  of
              the  memory  location  pointed  to  by  cpu_cachep  is
              already registered for this thread.

       ENOENT The GETCPU_CACHE_GET command has been  specified,  but
              no cpu cache has been registered for this thread.

VERSIONS
       The getcpu_cache() system call was added in Linux 4.X (TODO).

CONFORMING TO
       getcpu_cache() is Linux-specific.

EXAMPLE
       The  following  code  uses  the getcpu_cache() system call to
       keep a thread local storage variable up to date with the cur=E2=80=
=90
       rent  CPU  number,  with a fallback on sched_getcpu(3) if the
       cache is not available. For example simplicity, it is done in
       main(),  but  multithreaded  programs  would  need  to invoke
       getcpu_cache() from each program thread.

           #define _GNU_SOURCE
           #include <stdlib.h>
           #include <stdio.h>
           #include <unistd.h>
           #include <stdint.h>
           #include <sched.h>
           #include <linux/getcpu_cache.h>
           #include <sys/syscall.h>

           static inline int
           getcpu_cache(int cmd, volatile int32_t **cpu_cachep, int fla=
gs)
           {
               return syscall(__NR_getcpu_cache, cmd, cpu_cachep, flags=
);
           }

           /*
            * __getcpu_cache_tls is recommended as symbol name for the
            * cpu number cache. Weak attribute is recommended when
            * declaring this variable in libraries. Applications can
            * choose to define their own version of this symbol without
            * the weak attribute and access it directly as a
            * performance improvement when it matches the address
            * returned by GETCPU_CACHE_GET. The initial value "-1"
            * will be read in case the getcpu cache is not available.
            */
           __thread __attribute__((weak)) volatile int32_t
                     __getcpu_cache_tls =3D -1;

           int
           main(int argc, char **argv)
           {
               volatile int32_t *cpu_cache =3D &__getcpu_cache_tls;
               int32_t cpu;

               /* Try to register the CPU cache. */
               if (getcpu_cache(GETCPU_CACHE_SET, &cpu_cache, 0) < 0) {
                   perror("getcpu_cache set");
                   fprintf(stderr, "Using sched_getcpu() as fallback.\n=
");
               }

               cpu =3D __getcpu_cache_tls;    /* Read current CPU numbe=
r. */
               if (cpu < 0) {
                   /* Fallback on sched_getcpu(). */
                   cpu =3D sched_getcpu();
               }
               printf("Current CPU number: %d\n", cpu);

               exit(EXIT_SUCCESS);
           }

SEE ALSO
       sched_getcpu(3)

Linux                        2016-01-27              GETCPU_CACHE(2)
---
 MAINTAINERS                       |   7 ++
 fs/exec.c                         |   1 +
 include/linux/sched.h             |  36 +++++++++
 include/uapi/linux/Kbuild         |   1 +
 include/uapi/linux/getcpu_cache.h |  42 ++++++++++
 init/Kconfig                      |  10 +++
 kernel/Makefile                   |   1 +
 kernel/fork.c                     |   4 +
 kernel/getcpu_cache.c             | 163 ++++++++++++++++++++++++++++++=
++++++++
 kernel/sched/sched.h              |   1 +
 kernel/sys_ni.c                   |   3 +
 11 files changed, 269 insertions(+)
 create mode 100644 include/uapi/linux/getcpu_cache.h
 create mode 100644 kernel/getcpu_cache.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 4978dc1..dfef1bc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4766,6 +4766,13 @@ M:	Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
 S:	Maintained
 F:	scripts/get_maintainer.pl
=20
+GETCPU_CACHE SUPPORT
+M:	Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
+L:	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+S:	Supported
+F:	kernel/getcpu_cache.c
+F:	include/uapi/linux/getcpu_cache.h
+
 GFS2 FILE SYSTEM
 M:	Steven Whitehouse <swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 M:	Bob Peterson <rpeterso-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
diff --git a/fs/exec.c b/fs/exec.c
index dcd4ac7..f4ec02f 100644
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
index a10494a..18f2f79 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1830,6 +1830,9 @@ struct task_struct {
 	unsigned long	task_state_change;
 #endif
 	int pagefault_disabled;
+#ifdef CONFIG_GETCPU_CACHE
+	int32_t __user *cpu_cache;
+#endif
 /* CPU-specific state of this task */
 	struct thread_struct thread;
 /*
@@ -3207,4 +3210,37 @@ static inline unsigned long rlimit_max(unsigned =
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
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index ebd10e6..1d7eb4d 100644
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
index 0000000..25343b9
--- /dev/null
+++ b/include/uapi/linux/getcpu_cache.h
@@ -0,0 +1,42 @@
+#ifndef _UAPI_LINUX_GETCPU_CACHE_H
+#define _UAPI_LINUX_GETCPU_CACHE_H
+
+/*
+ * linux/getcpu_cache.h
+ *
+ * getcpu_cache system call API
+ *
+ * Copyright (c) 2015, 2016 Mathieu Desnoyers <mathieu.desnoyers@effic=
ios.com>
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
+ * @GETCPU_CACHE_GET: Get the address of the current thread CPU number
+ *                    cache.
+ * @GETCPU_CACHE_SET: Set the address of the current thread CPU number
+ *                    cache.
+ */
+enum getcpu_cache_cmd {
+	GETCPU_CACHE_GET =3D 0,
+	GETCPU_CACHE_SET =3D 1,
+};
+
+#endif /* _UAPI_LINUX_GETCPU_CACHE_H */
diff --git a/init/Kconfig b/init/Kconfig
index 2232080..e8db8db 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1589,6 +1589,16 @@ config MEMBARRIER
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
index 2e391c7..fad76d5 100644
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
@@ -1552,6 +1553,9 @@ static struct task_struct *copy_process(unsigned =
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
index 0000000..b7eaed0
--- /dev/null
+++ b/kernel/getcpu_cache.c
@@ -0,0 +1,163 @@
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
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+#include <linux/syscalls.h>
+#include <linux/compat.h>
+#include <linux/getcpu_cache.h>
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
+static int __get_cpu_cache_ptr(int32_t __user **cpu_cache,
+		int32_t __user * __user *cpu_cachep)
+{
+#ifdef CONFIG_COMPAT
+	if (is_compat_task()) {
+		compat_uptr_t __user *compat_cachep =3D
+			(compat_uptr_t __user *) cpu_cachep;
+		compat_uptr_t compat_cache;
+
+		if (get_user(compat_cache, compat_cachep))
+			return -EFAULT;
+		*cpu_cache =3D compat_ptr(compat_cache);
+		return 0;
+	}
+#endif
+	return get_user(*cpu_cache, cpu_cachep);
+}
+
+#define get_cpu_cache_ptr(cpu_cache, cpu_cachep)	\
+	__get_cpu_cache_ptr(&(cpu_cache), cpu_cachep)
+
+static int put_cpu_cache_ptr(int32_t __user *cpu_cache,
+		int32_t __user * __user *cpu_cachep)
+{
+#ifdef CONFIG_COMPAT
+	if (is_compat_task()) {
+		compat_uptr_t compat_cache =3D ptr_to_compat(cpu_cache);
+		compat_uptr_t __user *compat_cachep =3D
+			(compat_uptr_t __user *) cpu_cachep;
+
+		return put_user(compat_cache, compat_cachep);
+	}
+#endif
+	return put_user(cpu_cache, cpu_cachep);
+}
+
+/*
+ * sys_getcpu_cache - setup getcpu cache for caller thread
+ */
+SYSCALL_DEFINE3(getcpu_cache, int, cmd, int32_t __user * __user *, cpu=
_cachep,
+		int, flags)
+{
+	if (unlikely(flags))
+		return -EINVAL;
+	switch (cmd) {
+	case GETCPU_CACHE_GET:
+		if (!current->cpu_cache)
+			return -ENOENT;
+		if (put_cpu_cache_ptr(current->cpu_cache, cpu_cachep))
+			return -EFAULT;
+		return 0;
+	case GETCPU_CACHE_SET:
+	{
+		int32_t __user *cpu_cache;
+
+		if (get_cpu_cache_ptr(cpu_cache, cpu_cachep))
+			return -EFAULT;
+		if (unlikely(!IS_ALIGNED((unsigned long)cpu_cache,
+				sizeof(int32_t)) || !cpu_cache))
+			return -EINVAL;
+		/*
+		 * Check if cpu_cache is already registered, and whether
+		 * the address differs from *cpu_cachep.
+		 */
+		if (current->cpu_cache) {
+			if (current->cpu_cache !=3D cpu_cache)
+				return -EBUSY;
+			return 0;
+		}
+		current->cpu_cache =3D cpu_cache;
+		/*
+		 * Migration reads the current->cpu_cache pointer to
+		 * decide whether the notify_resume flag should be set.
+		 * Therefore, we need to ensure that the scheduler sees
+		 * the getcpu cache pointer update before we update the
+		 * getcpu cache content with the current CPU number.
+		 * This ensures we don't return from the getcpu_cache
+		 * system call to userspace with a wrong CPU number in
+		 * the cache if preempted and migrated after the initial
+		 * successful cpu cache update (below).
+		 *
+		 * This compiler barrier enforces ordering of the
+		 * current->cpu_cache address store before update of the
+		 * *cpu_cache.
+		 */
+		barrier();
+		/*
+		 * Do an initial cpu cache update to populate the
+		 * current CPU value, and to check whether the address
+		 * is valid, thus ensuring we return -EFAULT in case or
+		 * invalid address rather than triggering a SIGSEGV if
+		 * put_user() fails in the resume notifier.
+		 */
+		if (getcpu_cache_update(cpu_cache)) {
+			current->cpu_cache =3D NULL;
+			return -EFAULT;
+		}
+		return 0;
+	}
+	default:
+		return -EINVAL;
+	}
+}
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 10f1637..11ae33f 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -971,6 +971,7 @@ static inline void __set_task_cpu(struct task_struc=
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
index 2c5e3a8..7e336c0 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -250,3 +250,6 @@ cond_syscall(sys_execveat);
=20
 /* membarrier */
 cond_syscall(sys_membarrier);
+
+/* thread-local ABI */
+cond_syscall(sys_getcpu_cache);
--=20
2.1.4
