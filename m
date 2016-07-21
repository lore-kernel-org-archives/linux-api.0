From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH v7 1/7] Restartable sequences system call
Date: Thu, 21 Jul 2016 17:14:16 -0400
Message-ID: <1469135662-31512-2-git-send-email-mathieu.desnoyers@efficios.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469135662-31512-1-git-send-email-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Expose a new system call allowing each thread to register one userspace
memory area to be used as an ABI between kernel and user-space for two
purposes: user-space restartable sequences and quick access to read the
current CPU number value from user-space.

* Restartable sequences (per-cpu atomics)

The restartable critical sections (percpu atomics) work has been starte=
d
by Paul Turner and Andrew Hunter. It lets the kernel handle restart of
critical sections. [1] [2] The re-implementation proposed here brings a
few simplifications to the ABI which facilitates porting to other
architectures and speeds up the user-space fast path. A locking-based
fall-back, purely implemented in user-space, is proposed here to deal
with debugger single-stepping. This fallback interacts with rseq_start(=
)
and rseq_finish(), which force retries in response to concurrent
lock-based activity.

Here are benchmarks of counter increment in various scenarios compared
to restartable sequences:

ARMv7 Processor rev 4 (v7l)
Machine model: Cubietruck

                      Counter increment speed (ns/increment)
                             1 thread    2 threads
global increment (baseline)      6           N/A
percpu rseq increment           50            52
percpu rseq spinlock            94            94
global atomic increment         48            74 (__sync_add_and_fetch_=
4)
global atomic CAS               50           172 (__sync_val_compare_an=
d_swap_4)
global pthread mutex           148           862

ARMv7 Processor rev 10 (v7l)
Machine model: Wandboard

                      Counter increment speed (ns/increment)
                             1 thread    4 threads
global increment (baseline)      7           N/A
percpu rseq increment           50            50
percpu rseq spinlock            82            84
global atomic increment         44           262 (__sync_add_and_fetch_=
4)
global atomic CAS               46           316 (__sync_val_compare_an=
d_swap_4)
global pthread mutex           146          1400

x86-64 Intel(R) Xeon(R) CPU E5-2630 v3 @ 2.40GHz:

                      Counter increment speed (ns/increment)
                              1 thread           8 threads
global increment (baseline)      3.0                N/A
percpu rseq increment            3.6                3.8
percpu rseq spinlock             5.6                6.2
global LOCK; inc                 8.0              166.4
global LOCK; cmpxchg            13.4              435.2
global pthread mutex            25.2             1363.6

* Reading the current CPU number

Speeding up reading the current CPU number on which the caller thread i=
s
running is done by keeping the current CPU number up do date within the
cpu_id field of the memory area registered by the thread. This is done
by making scheduler migration set the TIF_NOTIFY_RESUME flag on the
current thread. Upon return to user-space, a notify-resume handler
updates the current CPU value within the registered user-space memory
area. User-space can then read the current CPU number directly from
memory.

Keeping the current cpu id in a memory area shared between kernel and
user-space is an improvement over current mechanisms available to read
the current CPU number, which has the following benefits over
alternative approaches:

- 35x speedup on ARM vs system call through glibc
- 20x speedup on x86 compared to calling glibc, which calls vdso
  executing a "lsl" instruction,
- 14x speedup on x86 compared to inlined "lsl" instruction,
- Unlike vdso approaches, this cpu_id value can be read from an inline
  assembly, which makes it a useful building block for restartable
  sequences.
- The approach of reading the cpu id through memory mapping shared
  between kernel and user-space is portable (e.g. ARM), which is not th=
e
  case for the lsl-based x86 vdso.

On x86, yet another possible approach would be to use the gs segment
selector to point to user-space per-cpu data. This approach performs
similarly to the cpu id cache, but it has two disadvantages: it is
not portable, and it is incompatible with existing applications already
using the gs segment selector for other purposes.

Benchmarking various approaches for reading the current CPU number:

ARMv7 Processor rev 4 (v7l)
Machine model: Cubietruck
- Baseline (empty loop):                                    8.4 ns
- Read CPU from rseq cpu_id:                               16.7 ns
- Read CPU from rseq cpu_id (lazy register):               19.8 ns
- glibc 2.19-0ubuntu6.6 getcpu:                           301.8 ns
- getcpu system call:                                     234.9 ns

x86-64 Intel(R) Xeon(R) CPU E5-2630 v3 @ 2.40GHz:
- Baseline (empty loop):                                    0.8 ns
- Read CPU from rseq cpu_id:                                0.8 ns
- Read CPU from rseq cpu_id (lazy register):                0.8 ns
- Read using gs segment selector:                           0.8 ns
- "lsl" inline assembly:                                   13.0 ns
- glibc 2.19-0ubuntu6 getcpu:                              16.6 ns
- getcpu system call:                                      53.9 ns

- Speed

Running 10 runs of hackbench -l 100000 seems to indicate, contrary to
expectations, that enabling CONFIG_RSEQ slightly accelerates the
scheduler:

Configuration: 2 sockets * 8-core Intel(R) Xeon(R) CPU E5-2630 v3 @
2.40GHz (directly on hardware, hyperthreading disabled in BIOS, energy
saving disabled in BIOS, turboboost disabled in BIOS, cpuidle.off=3D1
kernel parameter), with a Linux v4.6 defconfig+localyesconfig,
restartable sequences series applied.

* CONFIG_RSEQ=3Dn

avg.:      41.37 s
std.dev.:   0.36 s

* CONFIG_RSEQ=3Dy

avg.:      40.46 s
std.dev.:   0.33 s

- Size

On x86-64, between CONFIG_RSEQ=3Dn/y, the text size increase of vmlinux=
 is
2855 bytes, and the data size increase of vmlinux is 1024 bytes.

* CONFIG_RSEQ=3Dn

   text	   data	    bss	    dec	    hex	filename
9964559	4256280	 962560	15183399	 e7ae27	vmlinux.norseq

* CONFIG_RSEQ=3Dy

   text	   data	    bss	    dec	    hex	filename
9967414	4257304	 962560	15187278	 e7bd4e	vmlinux.rseq

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
CC: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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

Changes since v6:
- Integrate "restartable sequences" v2 patchset from Paul Turner.
- Add handling of single-stepping purely in user-space, with a
  fallback to locking after 2 rseq failures to ensure progress, and
  by exposing a __rseq_table section to debuggers so they know where
  to put breakpoints when dealing with rseq assembly blocks which
  can be aborted at any point.
- make the code and ABI generic: porting the kernel implementation
  simply requires to wire up the signal handler and return to user-spac=
e
  hooks, and allocate the syscall number.
- extend testing with a fully configurable test program. See
  param_spinlock_test -h for details.
- handling of rseq ENOSYS in user-space, also with a fallback
  to locking.
- modify Paul Turner's rseq ABI to only require a single TLS store on
  the user-space fast-path, removing the need to populate two additiona=
l
  registers. This is made possible by introducing struct rseq_cs into
  the ABI to describe a critical section start_ip, post_commit_ip, and
  abort_ip.
- Rebased on kernel v4.7-rc7.

Man page associated:

RSEQ(2)                Linux Programmer's Manual               RSEQ(2)

NAME
       rseq - Restartable sequences and cpu number cache

SYNOPSIS
       #include <linux/rseq.h>

       int rseq(struct rseq * rseq, int flags);

DESCRIPTION
       The  rseq()  ABI  accelerates  user-space operations on per-cpu
       data by defining a shared data structure ABI between each user-
       space thread and the kernel.

       The  rseq argument is a pointer to the thread-local rseq struc=E2=
=80=90
       ture to be shared between kernel and user-space.  A  NULL  rseq
       value  can  be used to check whether rseq is registered for the
       current thread.

       The layout of struct rseq is as follows:

       Structure alignment
              This structure needs to be aligned on  multiples  of  64
              bytes.

       Structure size
              This structure has a fixed size of 128 bytes.

       Fields

           cpu_id
              Cache  of  the CPU number on which the calling thread is
              running.

           event_counter
              Restartable sequences event_counter field.

           rseq_cs
              Restartable sequences rseq_cs field. Points to a  struct
              rseq_cs.

       The layout of struct rseq_cs is as follows:

       Structure alignment
              This  structure  needs  to be aligned on multiples of 64
              bytes.

       Structure size
              This structure has a fixed size of 192 bytes.

       Fields

           start_ip
              Instruction pointer address of the first instruction  of
              the sequence of consecutive assembly instructions.

           post_commit_ip
              Instruction  pointer  address after the last instruction
              of the sequence of consecutive assembly instructions.

           abort_ip
              Instruction pointer address where to move the  execution
              flow  in  case  of  abort of the sequence of consecutive
              assembly instructions.

       The flags argument is currently unused and must be specified as
       0.

       Typically,  a  library or application will keep the rseq struc=E2=
=80=90
       ture in a thread-local storage variable, or other memory  areas
       belonging to each thread. It is recommended to perform volatile
       reads of the thread-local cache to prevent  the  compiler  from
       doing  load  tearing.  An  alternative approach is to read each
       field from inline assembly.

       Each thread is responsible for registering its rseq  structure.
       Only  one  rseq structure address can be registered per thread.
       Once set, the rseq address is idempotent for a given thread.

       In a typical usage scenario, the thread  registering  the  rseq
       structure  will  be  performing  loads  and stores from/to that
       structure. It is however also allowed to  read  that  structure
       from  other  threads.   The rseq field updates performed by the
       kernel provide single-copy atomicity semantics, which guarantee
       that  other  threads performing single-copy atomic reads of the
       cpu number cache will always observe a consistent value.

       Memory registered as rseq structure should never be deallocated
       before  the  thread which registered it exits: specifically, it
       should not be freed, and the library containing the  registered
       thread-local  storage  should  not be dlclose'd. Violating this
       constraint may cause a SIGSEGV signal to be  delivered  to  the
       thread.

       Unregistration  of associated rseq structure is implicitly per=E2=
=80=90
       formed when a thread or process exit.

RETURN VALUE
       A return  value  of  0  indicates  success.  On  error,  -1  is
       returned, and errno is set appropriately.

ERRORS
       EINVAL Either  flags  is  non-zero, or rseq contains an address
              which is not appropriately aligned.

       ENOSYS The rseq() system call is not implemented by  this  ker=E2=
=80=90
              nel.

       EFAULT rseq is an invalid address.

       EBUSY  The rseq argument contains a non-NULL address which dif=E2=
=80=90
              fers from the memory  location  already  registered  for
              this thread.

       ENOENT The  rseq  argument  is  NULL, but no memory location is
              currently registered for this thread.

VERSIONS
       The rseq() system call was added in Linux 4.X (TODO).

CONFORMING TO
       rseq() is Linux-specific.

EXAMPLE
       The following code uses  the  rseq()  system  call  to  keep  a
       thread-local  storage  variable up to date with the current CPU
       number, with a fallback on sched_getcpu(3) if the cache is  not
       available.  For  example  simplicity, it is done in main(), but
       multithreaded programs would need to invoke  rseq()  from  each
       program thread.

           #define _GNU_SOURCE
           #include <stdlib.h>
           #include <stdio.h>
           #include <unistd.h>
           #include <stdint.h>
           #include <sched.h>
           #include <stddef.h>
           #include <errno.h>
           #include <string.h>
           #include <sys/syscall.h>
           #include <linux/rseq.h>

           static __thread volatile struct rseq rseq_state =3D {
               .u.e.cpu_id =3D -1,
           };

           static int
           sys_rseq(volatile struct rseq *rseq_abi, int flags)
           {
               return syscall(__NR_rseq, rseq_abi, flags);
           }

           static int32_t
           rseq_current_cpu_raw(void)
           {
               return rseq_state.u.e.cpu_id;
           }

           static int32_t
           rseq_current_cpu(void)
           {
               int32_t cpu;

               cpu =3D rseq_current_cpu_raw();
               if (cpu < 0)
                   cpu =3D sched_getcpu();
               return cpu;
           }

           static int
           rseq_init_current_thread(void)
           {
               int rc;

               rc =3D sys_rseq(&rseq_state, 0);
               if (rc) {
                   fprintf(stderr, "Error: sys_rseq(...) failed(%d): %s=
\n",
                       errno, strerror(errno));
                   return -1;
               }
               return 0;
           }

           int
           main(int argc, char **argv)
           {
               if (rseq_init_current_thread()) {
                   fprintf(stderr,
                       "Unable to initialize restartable sequences.\n")=
;
                   fprintf(stderr, "Using sched_getcpu() as fallback.\n=
");
               }
               printf("Current CPU number: %d\n", rseq_current_cpu());

               exit(EXIT_SUCCESS);
           }

SEE ALSO
       sched_getcpu(3)

Linux                         2016-07-19                       RSEQ(2)
---
 MAINTAINERS               |   7 ++
 arch/Kconfig              |   7 ++
 fs/exec.c                 |   1 +
 include/linux/sched.h     |  68 ++++++++++++++
 include/uapi/linux/Kbuild |   1 +
 include/uapi/linux/rseq.h |  85 +++++++++++++++++
 init/Kconfig              |  13 +++
 kernel/Makefile           |   1 +
 kernel/fork.c             |   2 +
 kernel/rseq.c             | 231 ++++++++++++++++++++++++++++++++++++++=
++++++++
 kernel/sched/core.c       |   1 +
 kernel/sys_ni.c           |   3 +
 12 files changed, 420 insertions(+)
 create mode 100644 include/uapi/linux/rseq.h
 create mode 100644 kernel/rseq.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 1209323..daef027 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5085,6 +5085,13 @@ M:	Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
 S:	Maintained
 F:	scripts/get_maintainer.pl
=20
+RESTARTABLE SEQUENCES SUPPORT
+M:	Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
+L:	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+S:	Supported
+F:	kernel/rseq.c
+F:	include/uapi/linux/rseq.h
+
 GFS2 FILE SYSTEM
 M:	Steven Whitehouse <swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 M:	Bob Peterson <rpeterso-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
diff --git a/arch/Kconfig b/arch/Kconfig
index 1599629..2c23e26 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -242,6 +242,13 @@ config HAVE_REGS_AND_STACK_ACCESS_API
 	  declared in asm/ptrace.h
 	  For example the kprobes-based event tracer needs this API.
=20
+config HAVE_RSEQ
+	bool
+	depends on HAVE_REGS_AND_STACK_ACCESS_API
+	help
+	  This symbol should be selected by an architecture if it
+	  supports an implementation of restartable sequences.
+
 config HAVE_CLK
 	bool
 	help
diff --git a/fs/exec.c b/fs/exec.c
index 887c1c9..e912d87 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1707,6 +1707,7 @@ static int do_execveat_common(int fd, struct file=
name *filename,
 	/* execve succeeded */
 	current->fs->in_exec =3D 0;
 	current->in_execve =3D 0;
+	rseq_execve(current);
 	acct_update_integrals(current);
 	task_numa_free(current);
 	free_bprm(bprm);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 253538f..5c4b900 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -59,6 +59,7 @@ struct sched_param {
 #include <linux/gfp.h>
 #include <linux/magic.h>
 #include <linux/cgroup-defs.h>
+#include <linux/rseq.h>
=20
 #include <asm/processor.h>
=20
@@ -1918,6 +1919,10 @@ struct task_struct {
 #ifdef CONFIG_MMU
 	struct task_struct *oom_reaper_list;
 #endif
+#ifdef CONFIG_RSEQ
+	struct rseq __user *rseq;
+	uint32_t rseq_event_counter;
+#endif
 /* CPU-specific state of this task */
 	struct thread_struct thread;
 /*
@@ -3387,4 +3392,67 @@ void cpufreq_add_update_util_hook(int cpu, struc=
t update_util_data *data,
 void cpufreq_remove_update_util_hook(int cpu);
 #endif /* CONFIG_CPU_FREQ */
=20
+#ifdef CONFIG_RSEQ
+static inline void rseq_set_notify_resume(struct task_struct *t)
+{
+	if (t->rseq)
+		set_tsk_thread_flag(t, TIF_NOTIFY_RESUME);
+}
+void __rseq_handle_notify_resume(struct pt_regs *regs);
+static inline void rseq_handle_notify_resume(struct pt_regs *regs)
+{
+	if (current->rseq)
+		__rseq_handle_notify_resume(regs);
+}
+/*
+ * If parent process has a registered restartable sequences area, the
+ * child inherits. Only applies when forking a process, not a thread. =
In
+ * case a parent fork() in the middle of a restartable sequence, set t=
he
+ * resume notifier to force the child to retry.
+ */
+static inline void rseq_fork(struct task_struct *t, unsigned long clon=
e_flags)
+{
+	if (clone_flags & CLONE_THREAD) {
+		t->rseq =3D NULL;
+		t->rseq_event_counter =3D 0;
+	} else {
+		t->rseq =3D current->rseq;
+		t->rseq_event_counter =3D current->rseq_event_counter;
+		rseq_set_notify_resume(t);
+	}
+}
+static inline void rseq_execve(struct task_struct *t)
+{
+	t->rseq =3D NULL;
+	t->rseq_event_counter =3D 0;
+}
+static inline void rseq_sched_out(struct task_struct *t)
+{
+	rseq_set_notify_resume(t);
+}
+static inline void rseq_signal_deliver(struct pt_regs *regs)
+{
+	rseq_handle_notify_resume(regs);
+}
+#else
+static inline void rseq_set_notify_resume(struct task_struct *t)
+{
+}
+static inline void rseq_handle_notify_resume(struct pt_regs *regs)
+{
+}
+static inline void rseq_fork(struct task_struct *t, unsigned long clon=
e_flags)
+{
+}
+static inline void rseq_execve(struct task_struct *t)
+{
+}
+static inline void rseq_sched_out(struct task_struct *t)
+{
+}
+static inline void rseq_signal_deliver(struct pt_regs *regs)
+{
+}
+#endif
+
 #endif
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 8bdae34..2e64fb8 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -403,6 +403,7 @@ header-y +=3D tcp_metrics.h
 header-y +=3D telephony.h
 header-y +=3D termios.h
 header-y +=3D thermal.h
+header-y +=3D rseq.h
 header-y +=3D time.h
 header-y +=3D times.h
 header-y +=3D timex.h
diff --git a/include/uapi/linux/rseq.h b/include/uapi/linux/rseq.h
new file mode 100644
index 0000000..3e79fa9
--- /dev/null
+++ b/include/uapi/linux/rseq.h
@@ -0,0 +1,85 @@
+#ifndef _UAPI_LINUX_RSEQ_H
+#define _UAPI_LINUX_RSEQ_H
+
+/*
+ * linux/rseq.h
+ *
+ * Restartable sequences system call API
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
+#include <asm/byteorder.h>
+
+#ifdef __LP64__
+# define RSEQ_FIELD_u32_u64(field)	uint64_t field
+#elif defined(__BYTE_ORDER) ? \
+	__BYTE_ORDER =3D=3D __BIG_ENDIAN : defined(__BIG_ENDIAN)
+# define RSEQ_FIELD_u32_u64(field)	uint32_t _padding ## field, field
+#else
+# define RSEQ_FIELD_u32_u64(field)	uint32_t field, _padding ## field
+#endif
+
+struct rseq_cs {
+	RSEQ_FIELD_u32_u64(start_ip);
+	RSEQ_FIELD_u32_u64(post_commit_ip);
+	RSEQ_FIELD_u32_u64(abort_ip);
+} __attribute__((aligned(sizeof(uint64_t))));
+
+struct rseq {
+	union {
+		struct {
+			/*
+			 * Restartable sequences cpu_id field.
+			 * Updated by the kernel, and read by user-space with
+			 * single-copy atomicity semantics. Aligned on 32-bit.
+			 * Negative values are reserved for user-space.
+			 */
+			int32_t cpu_id;
+			/*
+			 * Restartable sequences event_counter field.
+			 * Updated by the kernel, and read by user-space with
+			 * single-copy atomicity semantics. Aligned on 32-bit.
+			 */
+			uint32_t event_counter;
+		} e;
+		/*
+		 * On architectures with 64-bit aligned reads, both cpu_id and
+		 * event_counter can be read with single-copy atomicity
+		 * semantics.
+		 */
+		uint64_t v;
+	} u;
+	/*
+	 * Restartable sequences rseq_cs field.
+	 * Updated by user-space, read by the kernel with
+	 * single-copy atomicity semantics. Aligned on 64-bit.
+	 */
+	RSEQ_FIELD_u32_u64(rseq_cs);
+} __attribute__((aligned(sizeof(uint64_t))));
+
+#endif /* _UAPI_LINUX_RSEQ_H */
diff --git a/init/Kconfig b/init/Kconfig
index c02d897..545b7ed 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1653,6 +1653,19 @@ config MEMBARRIER
=20
 	  If unsure, say Y.
=20
+config RSEQ
+	bool "Enable rseq() system call" if EXPERT
+	default y
+	depends on HAVE_RSEQ
+	help
+	  Enable the restartable sequences system call. It provides a
+	  user-space cache for the current CPU number value, which
+	  speeds up getting the current CPU number from user-space,
+	  as well as an ABI to speed up user-space operations on
+	  per-CPU data.
+
+	  If unsure, say Y.
+
 config EMBEDDED
 	bool "Embedded system"
 	option allnoconfig_y
diff --git a/kernel/Makefile b/kernel/Makefile
index e2ec54e..4c6d8b5 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -112,6 +112,7 @@ obj-$(CONFIG_TORTURE_TEST) +=3D torture.o
 obj-$(CONFIG_MEMBARRIER) +=3D membarrier.o
=20
 obj-$(CONFIG_HAS_IOMEM) +=3D memremap.o
+obj-$(CONFIG_RSEQ) +=3D rseq.o
=20
 $(obj)/configs.o: $(obj)/config_data.h
=20
diff --git a/kernel/fork.c b/kernel/fork.c
index 4a7ec0c..cc7756b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1591,6 +1591,8 @@ static struct task_struct *copy_process(unsigned =
long clone_flags,
 	 */
 	copy_seccomp(p);
=20
+	rseq_fork(p, clone_flags);
+
 	/*
 	 * Process group and session signals need to be delivered to just the
 	 * parent before the fork or both the parent and the child after the
diff --git a/kernel/rseq.c b/kernel/rseq.c
new file mode 100644
index 0000000..e1c847b
--- /dev/null
+++ b/kernel/rseq.c
@@ -0,0 +1,231 @@
+/*
+ * Restartable sequences system call
+ *
+ * Restartable sequences are a lightweight interface that allows
+ * user-level code to be executed atomically relative to scheduler
+ * preemption and signal delivery. Typically used for implementing
+ * per-cpu operations.
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
+ *
+ * Copyright (C) 2015, Google, Inc.,
+ * Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> and Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
+ * Copyright (C) 2015-2016, EfficiOS Inc.,
+ * Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
+ */
+
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+#include <linux/syscalls.h>
+#include <linux/compat.h>
+#include <linux/rseq.h>
+#include <asm/ptrace.h>
+
+/*
+ * Each restartable sequence assembly block defines a "struct rseq_cs"
+ * structure which describes the post_commit_ip address, and the
+ * abort_ip address where the kernel should move the thread instructio=
n
+ * pointer if a rseq critical section assembly block is preempted or i=
f
+ * a signal is delivered on top of a rseq critical section assembly
+ * block. It also contains a start_ip, which is the address of the sta=
rt
+ * of the rseq assembly block, which is useful to debuggers.
+ *
+ * The algorithm for a restartable sequence assembly block is as
+ * follows:
+ *
+ * rseq_start()
+ *
+ *   0. Userspace loads the current event counter value from the
+ *      event_counter field of the registered struct rseq TLS area,
+ *
+ * rseq_finish()
+ *
+ *   Steps [1]-[3] (inclusive) need to be a sequence of instructions i=
n
+ *   userspace that can handle being moved to the abort_ip between any
+ *   of those instructions.
+ *
+ *   The abort_ip address needs to be equal or above the post_commit_i=
p.
+ *   Step [4] and the failure code step [F1] need to be at addresses
+ *   equal or above the post_commit_ip.
+ *
+ *   1.  Userspace stores the address of the struct rseq cs rseq
+ *       assembly block descriptor into the rseq_cs field of the
+ *       registered struct rseq TLS area.
+ *
+ *   2.  Userspace tests to see whether the current event counter valu=
es
+ *       match those loaded at [0]. Manually jumping to [F1] in case o=
f
+ *       a mismatch.
+ *
+ *       Note that if we are preempted or interrupted by a signal
+ *       after [1] and before post_commit_ip, then the kernel also
+ *       performs the comparison performed in [2], and conditionally
+ *       clears rseq_cs, then jumps us to abort_ip.
+ *
+ *   3.  Userspace critical section final instruction before
+ *       post_commit_ip is the commit. The critical section is
+ *       self-terminating.
+ *       [post_commit_ip]
+ *
+ *   4.  Userspace clears the rseq_cs field of the struct rseq
+ *       TLS area.
+ *
+ *   5.  Return true.
+ *
+ *   On failure at [2]:
+ *
+ *   F1. Userspace clears the rseq_cs field of the struct rseq
+ *       TLS area. Followed by step [F2].
+ *
+ *       [abort_ip]
+ *   F2. Return false.
+ */
+
+static int rseq_increment_event_counter(struct task_struct *t)
+{
+	if (__put_user(++t->rseq_event_counter,
+			&t->rseq->u.e.event_counter))
+		return -1;
+	return 0;
+}
+
+static int rseq_get_rseq_cs(struct task_struct *t,
+		void __user **post_commit_ip,
+		void __user **abort_ip)
+{
+	unsigned long ptr;
+	struct rseq_cs __user *rseq_cs;
+
+	if (__get_user(ptr, &t->rseq->rseq_cs))
+		return -1;
+	if (!ptr)
+		return 0;
+#ifdef CONFIG_COMPAT
+	if (in_compat_syscall()) {
+		rseq_cs =3D compat_ptr((compat_uptr_t)ptr);
+		if (get_user(ptr, &rseq_cs->post_commit_ip))
+			return -1;
+		*post_commit_ip =3D compat_ptr((compat_uptr_t)ptr);
+		if (get_user(ptr, &rseq_cs->abort_ip))
+			return -1;
+		*abort_ip =3D compat_ptr((compat_uptr_t)ptr);
+		return 0;
+	}
+#endif
+	rseq_cs =3D (struct rseq_cs __user *)ptr;
+	if (get_user(ptr, &rseq_cs->post_commit_ip))
+		return -1;
+	*post_commit_ip =3D (void __user *)ptr;
+	if (get_user(ptr, &rseq_cs->abort_ip))
+		return -1;
+	*abort_ip =3D (void __user *)ptr;
+	return 0;
+}
+
+static int rseq_ip_fixup(struct pt_regs *regs)
+{
+	struct task_struct *t =3D current;
+	void __user *post_commit_ip =3D NULL;
+	void __user *abort_ip =3D NULL;
+
+	if (rseq_get_rseq_cs(t, &post_commit_ip, &abort_ip))
+		return -1;
+
+	/* Handle potentially being within a critical section. */
+	if ((void __user *)instruction_pointer(regs) < post_commit_ip) {
+		/*
+		 * We need to clear rseq_cs upon entry into a signal
+		 * handler nested on top of a rseq assembly block, so
+		 * the signal handler will not be fixed up if itself
+		 * interrupted by a nested signal handler or preempted.
+		 */
+		if (clear_user(&t->rseq->rseq_cs,
+				sizeof(t->rseq->rseq_cs)))
+			return -1;
+
+		/*
+		 * We set this after potentially failing in
+		 * clear_user so that the signal arrives at the
+		 * faulting rip.
+		 */
+		instruction_pointer_set(regs, (unsigned long)abort_ip);
+	}
+	return 0;
+}
+
+/*
+ * This resume handler should always be executed between any of:
+ * - preemption,
+ * - signal delivery,
+ * and return to user-space.
+ */
+void __rseq_handle_notify_resume(struct pt_regs *regs)
+{
+	struct task_struct *t =3D current;
+
+	if (unlikely(t->flags & PF_EXITING))
+		return;
+	if (!access_ok(VERIFY_WRITE, t->rseq, sizeof(*t->rseq)))
+		goto error;
+	if (__put_user(raw_smp_processor_id(), &t->rseq->u.e.cpu_id))
+		goto error;
+	if (rseq_increment_event_counter(t))
+		goto error;
+	if (rseq_ip_fixup(regs))
+		goto error;
+	return;
+
+error:
+	force_sig(SIGSEGV, t);
+}
+
+/*
+ * sys_rseq - setup restartable sequences for caller thread.
+ */
+SYSCALL_DEFINE2(rseq, struct rseq __user *, rseq, int, flags)
+{
+	if (unlikely(flags))
+		return -EINVAL;
+	if (!rseq) {
+		if (!current->rseq)
+			return -ENOENT;
+		return 0;
+	}
+
+	if (current->rseq) {
+		/*
+		 * If rseq is already registered, check whether
+		 * the provided address differs from the prior
+		 * one.
+		 */
+		if (current->rseq !=3D rseq)
+			return -EBUSY;
+	} else {
+		/*
+		 * If there was no rseq previously registered,
+		 * we need to ensure the provided rseq is
+		 * properly aligned and valid.
+		 */
+		if (!IS_ALIGNED((unsigned long)rseq, sizeof(uint64_t)))
+			return -EINVAL;
+		if (!access_ok(VERIFY_WRITE, rseq, sizeof(*rseq)))
+			return -EFAULT;
+		current->rseq =3D rseq;
+		/*
+		 * If rseq was previously inactive, and has just
+		 * been registered, ensure the cpu_id and
+		 * event_counter fields are updated before
+		 * returning to user-space.
+		 */
+		rseq_set_notify_resume(current);
+	}
+
+	return 0;
+}
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 51d7105..fbef0c3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2664,6 +2664,7 @@ prepare_task_switch(struct rq *rq, struct task_st=
ruct *prev,
 {
 	sched_info_switch(rq, prev, next);
 	perf_event_task_sched_out(prev, next);
+	rseq_sched_out(prev);
 	fire_sched_out_preempt_notifiers(prev, next);
 	prepare_lock_switch(rq, next);
 	prepare_arch_switch(next);
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 2c5e3a8..c653f78 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -250,3 +250,6 @@ cond_syscall(sys_execveat);
=20
 /* membarrier */
 cond_syscall(sys_membarrier);
+
+/* restartable sequence */
+cond_syscall(sys_rseq);
--=20
2.1.4
