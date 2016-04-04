From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH v6 1/5] Thread-local ABI system call: cache CPU number of running thread
Date: Mon,  4 Apr 2016 13:01:49 -0400
Message-ID: <1459789313-4917-2-git-send-email-mathieu.desnoyers@efficios.com>
References: <1459789313-4917-1-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459789313-4917-1-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
List-Id: linux-api@vger.kernel.org

Expose a new system call allowing threads to register one userspace
memory area where to store the CPU number on which the calling thread i=
s
running. Scheduler migration sets the TIF_NOTIFY_RESUME flag on the
current thread. Upon return to user-space, a notify-resume handler
updates the current CPU value within each registered user-space memory
area. User-space can then read the current CPU number directly from
memory.

This thread-local ABI can be extended to add features in the future.
One future feature extension is the restartable critical sections
(percpu atomics) work undergone by Paul Turner and Andrew Hunter,
which lets the kernel handle restart of critical sections. [1] [2]

This cpu id cache is an improvement over current mechanisms available t=
o
read the current CPU number, which has the following benefits:

- 44x speedup on ARM vs system call through glibc,
- 20x speedup on x86 compared to calling glibc, which calls vdso
  executing a "lsl" instruction,
- 16x speedup on x86 compared to inlined "lsl" instruction,
- Unlike vdso approaches, this cached value can be read from an inline
  assembly, which makes it a useful building block for restartable
  sequences.
- The cpu id cache approach is portable (e.g. ARM), which is not the
  case for the lsl-based x86 vdso.

On x86, yet another possible approach would be to use the gs segment
selector to point to user-space per-cpu data. This approach performs
similarly to the cpu id cache, but it has two disadvantages: it is
not portable, and it is incompatible with existing applications already
using the gs segment selector for other purposes.

Benchmarking various approaches for reading the current CPU number:

ARMv7 Processor rev 10 (v7l)
Machine model: Wandboard i.MX6 Quad Board
- Baseline (empty loop):                                   10.1 ns
- Read CPU from __thread_local_abi.cpu_id:                 10.1 ns
- Read CPU from __thread_local_abi.cpu_id (lazy register): 12.4 ns
- glibc 2.19-0ubuntu6.6 getcpu:                           445.6 ns
- getcpu system call:                                     322.2 ns

x86-64 Intel(R) Xeon(R) CPU E5-2630 v3 @ 2.40GHz:
- Baseline (empty loop):                                    0.8 ns
- Read CPU from __thread_local_abi.cpu_id:                  0.8 ns
- Read CPU from __thread_local_abi.cpu_id (lazy register):  1.6 ns
- Read using gs segment selector:                           0.8 ns
- "lsl" inline assembly:                                   13.0 ns
- glibc 2.19-0ubuntu6 getcpu:                              16.5 ns
- getcpu system call:                                      52.5 ns

- Speed

Running 10 runs of hackbench -l 100000 seems to indicate that the sched
switch impact of this new configuration option is within the noise:

Configuration: 2 sockets * 8-core Intel(R) Xeon(R) CPU E5-2630 v3 @
2.40GHz (directly on hardware, hyperthreading disabled in BIOS, energy
saving disabled in BIOS, turboboost disabled in BIOS, cpuidle.off=3D1
kernel parameter), with a Linux v4.5 defconfig+localyesconfig,
thread-local ABI series applied.

* CONFIG_GETCPU_CACHE=3Dn

avg.:      40.42 s
std.dev.:   0.29 s

* CONFIG_GETCPU_CACHE=3Dy

avg.:      40.60 s
std.dev.:   0.17 s

- Size

On x86-64, between CONFIG_THREAD_LOCAL_ABI_CPU_ID=3Dn/y, the text size
increase of vmlinux is 640 bytes, and the data size increase of vmlinux
is 512 bytes.

* CONFIG_THREAD_LOCAL_ABI_CPU_ID=3Dn
   text        data         bss         dec        hex    filename
17018635    2762368     1564672    21345675    145b58b    vmlinux

* CONFIG_THREAD_LOCAL_ABI_CPU_ID=3Dy
   text        data         bss         dec        hex    filename
17019275    2762880     1564672    21346827    145ba0b    vmlinux

[1] https://lwn.net/Articles/650333/
[2] http://www.linuxplumbersconf.org/2013/ocw/system/presentations/1695=
/original/LPC%20-%20PerCpu%20Atomics.pdf

Link: http://lkml.kernel.org/r/20151027235635.16059.11630.stgit@pjt-gla=
ptop.roam.corp.google.com
Link: http://lkml.kernel.org/r/20150624222609.6116.86035.stgit@kitami.m=
tv.corp.google.com
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
CC: "H. Peter Anvin" <hpa@zytor.com>
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
CC: Boqun Feng <boqun.feng@gmail.com>
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

Changes since v4:
- Inline getcpu_cache_fork, getcpu_cache_execve, and getcpu_cache_exit.
- Add new line between if() and switch() to improve readability.
- Added sched switch benchmarks (hackbench) and size overhead compariso=
n
  to change log.

Changes since v5:
- Rename "getcpu_cache" to "thread_local_abi", allowing to extend
  this system call to cover future features such as restartable critica=
l
  sections. Generalizing this system call ensures that we can add
  features similar to the cpu_id field within the same cache-line
  without having to track one pointer per feature within the task
  struct.
- Add a tlabi_nr parameter to the system call, thus allowing to extend
  the ABI beyond the initial 64-byte structure by registering structure=
s
  with tlabi_nr greater than 0. The initial ABI structure is associated
  with tlabi_nr 0.
- Rebased on kernel v4.5.

Man page associated:

THREAD_LOCAL_ABI(2)     Linux Programmer's Manual     THREAD_LOCAL_ABI(=
2)

NAME
       thread_local_abi  -  Shared  memory  interface  between user-spa=
ce
       threads and the kernel

SYNOPSIS
       #include <linux/thread_local_abi.h>

       int thread_local_abi(uint32_t tlabi_nr, void * tlabi, uint32_t f=
eature_mask, int flags);

DESCRIPTION
       The thread_local_abi() accelerates some frequent user-space oper=
a=E2=80=90
       tions  by  defining a shared data structure ABI between each use=
r-
       space thread and the kernel.

       The tlabi_nr argument is the thread-local  ABI  structure  numbe=
r.
       Currently, only tlabi_nr 0 is supported.  tlabi_nr 0 expects tla=
bi
       to hold a pointer to struct thread_local_abi features and  layou=
t,
       or NULL.

       The layout of struct thread_local_abi is as follows:

       Structure alignment
              This  structure  needs  to  be  aligned on multiples of 6=
4
              bytes.

       Structure size
              This structure has a fixed size of 64 bytes.

       Fields

           features
              Bitmask of the features enabled for this thread's  tlabi_=
nr
              0.

           cpu_id
              Cache of the CPU number on which the calling thread is ru=
n=E2=80=90
              ning.

       The tlabi argument is a pointer to the thread-local ABI  structu=
re
       to  be shared between kernel and user-space. If tlabi is NULL, t=
he
       currently registered address will be used.

       The feature_mask is a bitmask  of  the  features  to  enable.  F=
or
       tlabi_nr 0, it is a OR'd mask of the following features:

       TLABI_FEATURE_CPU_ID
              Cache the CPU number on which the calling thread is runni=
ng
              into the cpu_id field of the struct thread_local_abi stru=
c=E2=80=90
              ture.

       The flags argument is currently unused and must be specified as =
0.

       Typically, a library or application will keep the thread-local A=
BI
       in a thread-local storage variable, or other memory areas  belon=
g=E2=80=90
       ing to each thread. It is recommended to perform volatile reads =
of
       the thread-local cache to prevent the  compiler  from  doing  lo=
ad
       tearing.  An  alternative approach is to read the cpu number cac=
he
       from inline assembly in a single instruction.

       Each thread is responsible for registering  its  thread-local  A=
BI
       structure. Only one thread-local ABI structure address can be re=
g=E2=80=90
       istered per thread for each tlabi_nr number. Once set, the threa=
d-
       local  ABI  address  associated to a tlabi_nr number is idempote=
nt
       for a given thread.

       The symbol __thread_local_abi is recommended  to  be  used  acro=
ss
       libraries  and applications wishing to register a the thread-loc=
al
       ABI structure for tlabi_nr 0. The attribute "weak" is  recommend=
ed
       when  declaring  this  variable  in  libraries.   Applications c=
an
       choose to define their own version of this symbol without the we=
ak
       attribute as a performance improvement.

       In  a  typical  usage scenario, the thread registering the threa=
d-
       local ABI structure will be performing reads from that  structur=
e.
       It  is  however also allowed to read the that structure from oth=
er
       threads. The thread-local ABI field updates performed by the  ke=
r=E2=80=90
       nel  provide single-copy atomicity semantics, which guarantee th=
at
       other threads performing single-copy atomic reads of the cpu  nu=
m=E2=80=90
       ber cache will always observe a consistent value.

       Memory  registered  as  thread-local ABI structure should never =
be
       deallocated before the thread which registered it exits:  specif=
i=E2=80=90
       cally, it should not be freed, and the library containing the re=
g=E2=80=90
       istered thread-local storage should not  be  dlclose'd.  Violati=
ng
       this  constraint may cause a SIGSEGV signal to be delivered to t=
he
       thread.

       Unregistration of associated thread-local ABI structure is impli=
c=E2=80=90
       itly performed when a thread or process exit.

RETURN VALUE
       A  return  value of 0 indicates success. On error, -1 is returne=
d,
       and errno is set appropriately.

ERRORS
       EINVAL Either  flags is non-zero, an unexpected tlabi_nr has bee=
n
              specified, tlabi contains an address which is  not  appro=
=E2=80=90
              priately  aligned,  or  a  feature  specified  in the fea=
=E2=80=90
              ture_mask is not available.

       ENOSYS The thread_local_abi() system call is not  implemented  b=
y
              this kernel.

       EFAULT tlabi is an invalid address.

       EBUSY  The  tlabi argument contains a non-NULL address which dif=
=E2=80=90
              fers from the memory location already registered for  thi=
s
              thread for the given tlabi_nr number.

       ENOENT The tlabi argument is NULL, but no memory location is cur=
=E2=80=90
              rently registered for this thread for the  given  tlabi_n=
r
              number.

VERSIONS
       The thread_local_abi() system call was added in Linux 4.X (TODO)=
=2E

CONFORMING TO
       thread_local_abi() is Linux-specific.

EXAMPLE
       The following code uses the thread_local_abi() system call to ke=
ep
       a thread-local storage variable up to date with  the  current  C=
PU
       number,  with  a  fallback  on sched_getcpu(3) if the cache is n=
ot
       available. For example simplicity, it is done in main(), but  mu=
l=E2=80=90
       tithreaded  programs  would need to invoke thread_local_abi() fr=
om
       each program thread.

           #define _GNU_SOURCE
           #include <stdlib.h>
           #include <stdio.h>
           #include <unistd.h>
           #include <stdint.h>
           #include <sched.h>
           #include <stddef.h>
           #include <sys/syscall.h>
           #include <linux/thread_local_abi.h>

           static inline int
           thread_local_abi(uint32_t tlabi_nr,
                   volatile struct thread_local_abi *tlabi,
                   uint32_t feature_mask, int flags)
           {
               return syscall(__NR_thread_local_abi, tlabi_nr, tlabi,
                       feature_mask, flags);
           }

           /*
            * __thread_local_abi is recommended as symbol name for the
            * thread-local ABI. Weak attribute is recommended when decl=
aring
            * this variable in libraries.
            */
           __thread __attribute__((weak))
           volatile struct thread_local_abi __thread_local_abi;

           static int
           tlabi_cpu_id_register(void)
           {
               if (thread_local_abi(0, &__thread_local_abi,
                       TLABI_FEATURE_CPU_ID, 0))
                   return -1;
               return 0;
           }

           static int32_t
           read_cpu_id(void)
           {
               if (!(__thread_local_abi.features & TLABI_FEATURE_CPU_ID=
))
                   return sched_getcpu();
               return __thread_local_abi.cpu_id;
           }

           int
           main(int argc, char **argv)
           {
               if (tlabi_cpu_id_register()) {
                   fprintf(stderr,
                       "Unable to initialize thread-local ABI cpu_id fe=
ature.\n");
                   fprintf(stderr, "Using sched_getcpu() as fallback.\n=
");
               }
               printf("Current CPU number: %d\n", read_cpu_id());
               printf("TLABI features: 0x%x\n", __thread_local_abi.feat=
ures);

               exit(EXIT_SUCCESS);
           }

SEE ALSO
       sched_getcpu(3)

Linux                           2016-01-27            THREAD_LOCAL_ABI(=
2)
---
 MAINTAINERS                           |   7 +++
 fs/exec.c                             |   1 +
 include/linux/sched.h                 |  66 ++++++++++++++++++++++
 include/uapi/linux/Kbuild             |   1 +
 include/uapi/linux/thread_local_abi.h |  83 ++++++++++++++++++++++++++=
+
 init/Kconfig                          |  14 +++++
 kernel/Makefile                       |   1 +
 kernel/fork.c                         |   4 ++
 kernel/sched/sched.h                  |   1 +
 kernel/sys_ni.c                       |   3 +
 kernel/thread_local_abi.c             | 103 ++++++++++++++++++++++++++=
++++++++
 11 files changed, 284 insertions(+)
 create mode 100644 include/uapi/linux/thread_local_abi.h
 create mode 100644 kernel/thread_local_abi.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 6ee06ea..9b5b613 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4787,6 +4787,13 @@ M:	Joe Perches <joe@perches.com>
 S:	Maintained
 F:	scripts/get_maintainer.pl
=20
+THREAD LOCAL ABI SUPPORT
+M:	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+F:	kernel/thread_local_abi.c
+F:	include/uapi/linux/thread_local_abi.h
+
 GFS2 FILE SYSTEM
 M:	Steven Whitehouse <swhiteho@redhat.com>
 M:	Bob Peterson <rpeterso@redhat.com>
diff --git a/fs/exec.c b/fs/exec.c
index dcd4ac7..b41903c 100644
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
diff --git a/include/linux/sched.h b/include/linux/sched.h
index a10494a..7dcc910 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -59,6 +59,7 @@ struct sched_param {
 #include <linux/gfp.h>
 #include <linux/magic.h>
 #include <linux/cgroup-defs.h>
+#include <linux/thread_local_abi.h>
=20
 #include <asm/processor.h>
=20
@@ -1830,6 +1831,10 @@ struct task_struct {
 	unsigned long	task_state_change;
 #endif
 	int pagefault_disabled;
+#ifdef CONFIG_THREAD_LOCAL_ABI
+	uint32_t tlabi_features;
+	struct thread_local_abi __user *tlabi;
+#endif
 /* CPU-specific state of this task */
 	struct thread_struct thread;
 /*
@@ -3207,4 +3212,65 @@ static inline unsigned long rlimit_max(unsigned =
int limit)
 	return task_rlimit_max(current, limit);
 }
=20
+#ifdef CONFIG_THREAD_LOCAL_ABI
+/*
+ * If parent process has a thread-local ABI, the child inherits. Only
+ * applies when forking a process, not a thread.
+ */
+static inline void thread_local_abi_fork(struct task_struct *t)
+{
+	t->tlabi_features =3D current->tlabi_features;
+	t->tlabi =3D current->tlabi;
+}
+static inline void thread_local_abi_execve(struct task_struct *t)
+{
+	t->tlabi_features =3D 0;
+	t->tlabi =3D NULL;
+}
+static inline void thread_local_abi_exit(struct task_struct *t)
+{
+	t->tlabi_features =3D 0;
+	t->tlabi =3D NULL;
+}
+#else
+static inline void thread_local_abi_fork(struct task_struct *t)
+{
+}
+static inline void thread_local_abi_execve(struct task_struct *t)
+{
+}
+static inline void thread_local_abi_exit(struct task_struct *t)
+{
+}
+#endif
+
+#ifdef CONFIG_THREAD_LOCAL_ABI_CPU_ID
+void __tlabi_cpu_id_handle_notify_resume(struct task_struct *t);
+static inline void tlabi_cpu_id_set_notify_resume(struct task_struct *=
t)
+{
+	if (t->tlabi_features & TLABI_FEATURE_CPU_ID)
+		set_tsk_thread_flag(t, TIF_NOTIFY_RESUME);
+}
+static inline void tlabi_cpu_id_handle_notify_resume(struct task_struc=
t *t)
+{
+	if (t->tlabi_features & TLABI_FEATURE_CPU_ID)
+		__tlabi_cpu_id_handle_notify_resume(t);
+}
+static inline bool tlabi_cpu_id_feature_available(void)
+{
+	return true;
+}
+#else
+static inline void tlabi_cpu_id_set_notify_resume(struct task_struct *=
t)
+{
+}
+static inline void tlabi_cpu_id_handle_notify_resume(struct task_struc=
t *t)
+{
+}
+static inline bool tlabi_cpu_id_feature_available(void)
+{
+	return false;
+}
+#endif
+
 #endif
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index ebd10e6..96f6f32 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -398,6 +398,7 @@ header-y +=3D tcp_metrics.h
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
index 0000000..48e685a
--- /dev/null
+++ b/include/uapi/linux/thread_local_abi.h
@@ -0,0 +1,83 @@
+#ifndef _UAPI_LINUX_THREAD_LOCAL_ABI_H
+#define _UAPI_LINUX_THREAD_LOCAL_ABI_H
+
+/*
+ * linux/thread_local_abi.h
+ *
+ * Thread-local ABI system call API
+ *
+ * Copyright (c) 2015-2016 Mathieu Desnoyers <mathieu.desnoyers@effici=
os.com>
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
+#ifdef __KERNEL__
+# include <linux/types.h>
+#else	/* #ifdef __KERNEL__ */
+# include <stdint.h>
+#endif	/* #else #ifdef __KERNEL__ */
+
+/*
+ * The initial thread-local ABI shared structure is associated with
+ * the tlabi_nr parameter value 0 passed to the thread_local_abi syste=
m
+ * call. It will be henceforth referred to as "tlabi 0".
+ *
+ * This tlabi 0 structure is strictly required to be aligned on 64
+ * bytes. The tlabi 0 structure has a fixed length of 64 bytes. Each o=
f
+ * its fields should be naturally aligned so no padding is necessary.
+ * The size of tlabi 0 structure is fixed to 64 bytes to ensure that
+ * neither the kernel nor user-space have to perform size checks. The
+ * choice of 64 bytes matches the L1 cache size on common architecture=
s.
+ *
+ * If more fields are needed than the available 64 bytes, a new tlabi
+ * number should be reserved, associated to its own shared structure
+ * layout.
+ */
+#define TLABI_LEN		64
+
+enum thread_local_abi_feature {
+	TLABI_FEATURE_NONE =3D 0,
+	TLABI_FEATURE_CPU_ID =3D (1 << 0),
+};
+
+struct thread_local_abi {
+	/*
+	 * Thread-local ABI features field.
+	 * Updated by the kernel, and read by user-space with
+	 * single-copy atomicity semantics. Aligned on 32-bit.
+	 * This field contains a mask of enabled features.
+	 */
+	uint32_t features;
+
+	/*
+	 * Thread-local ABI cpu_id field.
+	 * Updated by the kernel, and read by user-space with
+	 * single-copy atomicity semantics. Aligned on 32-bit.
+	 */
+	uint32_t cpu_id;
+
+	/*
+	 * Add new fields here, before padding. Increment TLABI_BYTES_USED
+	 * accordingly.
+	 */
+#define TLABI_BYTES_USED	8
+	char padding[TLABI_LEN - TLABI_BYTES_USED];
+} __attribute__ ((aligned(TLABI_LEN)));
+
+#endif /* _UAPI_LINUX_THREAD_LOCAL_ABI_H */
diff --git a/init/Kconfig b/init/Kconfig
index 2232080..3f64a2f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1589,6 +1589,20 @@ config MEMBARRIER
=20
 	  If unsure, say Y.
=20
+config THREAD_LOCAL_ABI
+	bool
+
+config THREAD_LOCAL_ABI_CPU_ID
+	bool "Enable thread-local CPU number cache" if EXPERT
+	default y
+	select THREAD_LOCAL_ABI
+	help
+	  Enable the thread-local CPU number cache. It provides a
+	  user-space cache for the current CPU number value, which
+	  speeds up getting the current CPU number from user-space.
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
index 2e391c7..055f37d 100644
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
@@ -1552,6 +1553,9 @@ static struct task_struct *copy_process(unsigned =
long clone_flags,
 	 */
 	copy_seccomp(p);
=20
+	if (!(clone_flags & CLONE_THREAD))
+		thread_local_abi_fork(p);
+
 	/*
 	 * Process group and session signals need to be delivered to just the
 	 * parent before the fork or both the parent and the child after the
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 10f1637..a67d732 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -971,6 +971,7 @@ static inline void __set_task_cpu(struct task_struc=
t *p, unsigned int cpu)
 {
 	set_task_rq(p, cpu);
 #ifdef CONFIG_SMP
+	tlabi_cpu_id_set_notify_resume(p);
 	/*
 	 * After ->cpu is set up to a new value, task_rq_lock(p, ...) can be
 	 * successfuly executed on another CPU. We must ensure that updates o=
f
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 2c5e3a8..ce1f466 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -250,3 +250,6 @@ cond_syscall(sys_execveat);
=20
 /* membarrier */
 cond_syscall(sys_membarrier);
+
+/* thread-local ABI */
+cond_syscall(sys_thread_local_abi);
diff --git a/kernel/thread_local_abi.c b/kernel/thread_local_abi.c
new file mode 100644
index 0000000..91adbb8
--- /dev/null
+++ b/kernel/thread_local_abi.c
@@ -0,0 +1,103 @@
+/*
+ * Copyright (C) 2015-2016 Mathieu Desnoyers <mathieu.desnoyers@effici=
os.com>
+ *
+ * Thread-local ABI system call
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
+#include <linux/thread_local_abi.h>
+
+#define TLABI_FEATURES_UNKNOWN		(~TLABI_FEATURE_CPU_ID)
+
+/*
+ * This resume handler should always be executed between a migration
+ * triggered by preemption and return to user-space.
+ */
+void __tlabi_cpu_id_handle_notify_resume(struct task_struct *t)
+{
+	if (unlikely(t->flags & PF_EXITING))
+		return;
+	if (put_user(raw_smp_processor_id(), &t->tlabi->cpu_id))
+		force_sig(SIGSEGV, t);
+}
+
+/*
+ * sys_thread_local_abi - setup thread-local ABI for caller thread
+ */
+SYSCALL_DEFINE4(thread_local_abi, uint32_t, tlabi_nr, void *, _tlabi,
+		uint32_t, feature_mask, int, flags)
+{
+	struct thread_local_abi __user *tlabi =3D
+			(struct thread_local_abi __user *)_tlabi;
+	uint32_t orig_feature_mask;
+
+	/* Sanity check on size of ABI structure. */
+	BUILD_BUG_ON(sizeof(struct thread_local_abi) !=3D TLABI_LEN);
+
+	if (unlikely(flags || tlabi_nr))
+		return -EINVAL;
+	/* Ensure requested features are available. */
+	if (feature_mask & TLABI_FEATURES_UNKNOWN)
+		return -EINVAL;
+	if ((feature_mask & TLABI_FEATURE_CPU_ID)
+			&& !tlabi_cpu_id_feature_available())
+		return -EINVAL;
+
+	if (tlabi) {
+		if (current->tlabi) {
+			/*
+			 * If tlabi is already registered, check
+			 * whether the provided address differs from the
+			 * prior one.
+			 */
+			if (current->tlabi !=3D tlabi)
+				return -EBUSY;
+		} else {
+			/*
+			 * If there was no tlabi previously registered,
+			 * we need to ensure the provided tlabi is
+			 * properly aligned and valid.
+			 */
+			if (!IS_ALIGNED((unsigned long)tlabi, TLABI_LEN))
+				return -EINVAL;
+			if (!access_ok(VERIFY_WRITE, tlabi,
+					sizeof(struct thread_local_abi)))
+				return -EFAULT;
+			current->tlabi =3D tlabi;
+		}
+	} else {
+		if (!current->tlabi)
+			return -ENOENT;
+	}
+
+	/* Update feature mask for current thread. */
+	orig_feature_mask =3D current->tlabi_features;
+	current->tlabi_features |=3D feature_mask;
+	if (put_user(current->tlabi_features, &current->tlabi->features)) {
+		current->tlabi =3D NULL;
+		current->tlabi_features =3D 0;
+		return -EFAULT;
+	}
+
+	/*
+	 * If the CPU_ID feature was previously inactive, and has just
+	 * been requested, ensure the cpu_id field is updated before
+	 * returning to user-space.
+	 */
+	if (!(orig_feature_mask & TLABI_FEATURE_CPU_ID))
+		tlabi_cpu_id_set_notify_resume(current);
+	return 0;
+}
--=20
2.1.4
