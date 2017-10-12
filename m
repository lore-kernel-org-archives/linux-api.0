From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH v9 for 4.15 01/14] Restartable sequences system call
Date: Thu, 12 Oct 2017 19:03:13 -0400
Message-ID: <20171012230326.19984-2-mathieu.desnoyers@efficios.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171012230326.19984-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Josh Triplett <josh@joshtriplett.org>, Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Expose a new system call allowing each thread to register one userspace
memory area to be used as an ABI between kernel and user-space for two
purposes: user-space restartable sequences and quick access to read the
current CPU number value from user-space.

* Restartable sequences (per-cpu atomics)

Restartables sequences allow user-space to perform update operations on
per-cpu data without requiring heavy-weight atomic operations.

The restartable critical sections (percpu atomics) work has been started
by Paul Turner and Andrew Hunter. It lets the kernel handle restart of
critical sections. [1] [2] The re-implementation proposed here brings a
few simplifications to the ABI which facilitates porting to other
architectures and speeds up the user-space fast path. A locking-based
fall-back, purely implemented in user-space, is proposed here to deal
with debugger single-stepping. This fallback interacts with rseq_start()
and rseq_finish(), which force retries in response to concurrent
lock-based activity.

Here are benchmarks of counter increment in various scenarios compared
to restartable sequences. Those benchmarks were taken on v8 of the
patchset.

ARMv7 Processor rev 4 (v7l)
Machine model: Cubietruck

                      Counter increment speed (ns/increment)
                             1 thread    2 threads
global increment (baseline)      6           N/A
percpu rseq increment           50            52
percpu rseq spinlock            94            94
global atomic increment         48            74 (__sync_add_and_fetch_4)
global atomic CAS               50           172 (__sync_val_compare_and_swap_4)
global pthread mutex           148           862

ARMv7 Processor rev 10 (v7l)
Machine model: Wandboard

                      Counter increment speed (ns/increment)
                             1 thread    4 threads
global increment (baseline)      7           N/A
percpu rseq increment           50            50
percpu rseq spinlock            82            84
global atomic increment         44           262 (__sync_add_and_fetch_4)
global atomic CAS               46           316 (__sync_val_compare_and_swap_4)
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

Speeding up reading the current CPU number on which the caller thread is
running is done by keeping the current CPU number up do date within the
cpu_id field of the memory area registered by the thread. This is done
by making scheduler preemption set the TIF_NOTIFY_RESUME flag on the
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
  between kernel and user-space is portable (e.g. ARM), which is not the
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
saving disabled in BIOS, turboboost disabled in BIOS, cpuidle.off=1
kernel parameter), with a Linux v4.6 defconfig+localyesconfig,
restartable sequences series applied.

* CONFIG_RSEQ=n

avg.:      41.37 s
std.dev.:   0.36 s

* CONFIG_RSEQ=y

avg.:      40.46 s
std.dev.:   0.33 s

- Size

On x86-64, between CONFIG_RSEQ=n/y, the text size increase of vmlinux is
2855 bytes, and the data size increase of vmlinux is 1024 bytes.

* CONFIG_RSEQ=n

   text	   data	    bss	    dec	    hex	filename
9964559	4256280	 962560	15183399	 e7ae27	vmlinux.norseq

* CONFIG_RSEQ=y

   text	   data	    bss	    dec	    hex	filename
9967414	4257304	 962560	15187278	 e7bd4e	vmlinux.rseq

[1] https://lwn.net/Articles/650333/
[2] http://www.linuxplumbersconf.org/2013/ocw/system/presentations/1695/original/LPC%20-%20PerCpu%20Atomics.pdf

Link: http://lkml.kernel.org/r/20151027235635.16059.11630.stgit@pjt-glaptop.roam.corp.google.com
Link: http://lkml.kernel.org/r/20150624222609.6116.86035.stgit@kitami.mtv.corp.google.com
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
CC: Alexander Viro <viro@zeniv.linux.org.uk>
CC: linux-api@vger.kernel.org
---

Changes since v1:
- Return -1, errno=EINVAL if cpu_cache pointer is not aligned on
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
- Split resume notifier architecture implementation from the system call
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
- Added sched switch benchmarks (hackbench) and size overhead comparison
  to change log.

Changes since v5:
- Rename "getcpu_cache" to "thread_local_abi", allowing to extend
  this system call to cover future features such as restartable critical
  sections. Generalizing this system call ensures that we can add
  features similar to the cpu_id field within the same cache-line
  without having to track one pointer per feature within the task
  struct.
- Add a tlabi_nr parameter to the system call, thus allowing to extend
  the ABI beyond the initial 64-byte structure by registering structures
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
  simply requires to wire up the signal handler and return to user-space
  hooks, and allocate the syscall number.
- extend testing with a fully configurable test program. See
  param_spinlock_test -h for details.
- handling of rseq ENOSYS in user-space, also with a fallback
  to locking.
- modify Paul Turner's rseq ABI to only require a single TLS store on
  the user-space fast-path, removing the need to populate two additional
  registers. This is made possible by introducing struct rseq_cs into
  the ABI to describe a critical section start_ip, post_commit_ip, and
  abort_ip.
- Rebased on kernel v4.7-rc7.

Changes since v7:
- Documentation updates.
- Integrated powerpc architecture support.
- Compare rseq critical section start_ip, allows shriking the user-space
  fast-path code size.
- Added Peter Zijlstra, Paul E. McKenney and Boqun Feng as
  co-maintainers.
- Added do_rseq2 and do_rseq_memcpy to test program helper library.
- Code cleanup based on review from Peter Zijlstra, Andy Lutomirski and
  Boqun Feng.
- Rebase on kernel v4.8-rc2.

Changes since v8:
- clear rseq_cs even if non-nested. Speeds up user-space fast path by
  removing the final "rseq_cs=NULL" assignment.
- add enum rseq_flags: critical sections and threads can set migration,
  preemption and signal "disable" flags to inhibit rseq behavior.
- rseq_event_counter needs to be updated with a pre-increment: Otherwise
  misses an increment after exec (when TLS and in-kernel states are
  initially 0).

Man page associated:

RSEQ(2)                 Linux Programmer's Manual                 RSEQ(2)

NAME
       rseq - Restartable sequences and cpu number cache

SYNOPSIS
       #include <linux/rseq.h>

       int rseq(struct rseq * rseq, int flags);

DESCRIPTION
       The  rseq()  ABI accelerates user-space operations on per-cpu data
       by defining a shared data structure ABI  between  each  user-space
       thread and the kernel.

       It  allows user-space to perform update operations on per-cpu data
       without requiring heavy-weight atomic operations.

       Restartable sequences are atomic with respect to preemption  (mak‐
       ing  it  atomic  with respect to other threads running on the same
       CPU), as well as signal delivery  (user-space  execution  contexts
       nested over the same thread).

       It is suited for update operations on per-cpu data.

       It  can be used on data structures shared between threads within a
       process, and on data structures shared between threads across dif‐
       ferent processes.

       Some examples of operations that can be accelerated by this ABI:

       · Querying the current CPU number,

       · Incrementing per-CPU counters,

       · Modifying data protected by per-CPU spinlocks,

       · Inserting/removing elements in per-CPU linked-lists,

       · Writing/reading per-CPU ring buffers content.

       The  rseq argument is a pointer to the thread-local rseq structure
       to be shared between kernel and  user-space.  A  NULL  rseq  value
       unregisters the current thread rseq structure.

       The layout of struct rseq is as follows:

       Structure alignment
              This structure is aligned on multiples of 128 bytes.

       Structure size
              This structure has a fixed size of 128 bytes.

       Fields

           cpu_id
              Cache of the CPU number on which the current thread is run‐
              ning.

           event_counter
              Counter guaranteed  to  be  incremented  when  the  current
              thread  is  preempted  or when a signal is delivered to the
              current thread.

           rseq_cs
              The rseq_cs field is a pointer to a struct rseq_cs.  Is  is
              NULL when no rseq assembly block critical section is active
              for the current thread.  Setting it to point to a  critical
              section  descriptor (struct rseq_cs) marks the beginning of
              the critical section. It is cleared after the  end  of  the
              critical section.

       The layout of struct rseq_cs is as follows:

       Structure alignment
              This structure is aligned on multiples of 256 bytes.

       Structure size
              This structure has a fixed size of 256 bytes.

       Fields

           start_ip
              Instruction pointer address of the first instruction of the
              sequence of consecutive assembly instructions.

           post_commit_ip
              Instruction pointer address after the last  instruction  of
              the sequence of consecutive assembly instructions.

           abort_ip
              Instruction  pointer  address  where  to move the execution
              flow in case of abort of the sequence of consecutive assem‐
              bly instructions.

       Upon registration, the flags argument is currently unused and must
       be specified as 0. Upon unregistration, the flags argument can  be
       either  specified  as  0,  or as RSEQ_FORCE_UNREGISTER, which will
       force unregistration of  the  current  rseq  address  rather  than
       requiring each registration to be matched by an unregistration.

       Libraries  and  applications  should  keep the rseq structure in a
       thread-local storage variable.  Since only one rseq address can be
       registered  per  thread,  applications and libraries should define
       their struct rseq as a volatile thread-local storage variable with
       the weak symbol __rseq_abi.  This allows using rseq from an appli‐
       cation executable and from multiple shared libraries linked to the
       same executable. The cpu_id field should be initialized to -1.

       Each  thread  is responsible for registering and unregistering its
       rseq structure. No more than one rseq  structure  address  can  be
       registered  per  thread  at  a given time. The same address can be
       registered more than once for  a  thread,  and  each  registration
       needs  to  have  a  matching  unregistration before the address is
       effectively unregistered. After the rseq  address  is  effectively
       unregistered for a thread, a new address can be registered. Unreg‐
       istration of associated rseq  structure  is  implicitly  performed
       when a thread or process exits.

       In  a  typical  usage  scenario,  the  thread registering the rseq
       structure will be performing loads and stores from/to that  struc‐
       ture. It is however also allowed to read that structure from other
       threads.  The rseq field updates performed by the  kernel  provide
       relaxed  atomicity  semantics,  which guarantee that other threads
       performing relaxed atomic reads  of  the  cpu  number  cache  will
       always observe a consistent value.

RETURN VALUE
       A  return  value of 0 indicates success. On error, -1 is returned,
       and errno is set appropriately.

ERRORS
       EINVAL Either flags contains an invalid value, or rseq contains an
              address which is not appropriately aligned.

       ENOSYS The rseq() system call is not implemented by this kernel.

       EFAULT rseq is an invalid address.

       EBUSY  The rseq argument contains a non-NULL address which differs
              from  the  memory  location  already  registered  for  this
              thread.

       EOVERFLOW
              Registering  the  rseq  address  is  not allowed because it
              would cause a reference counter overflow.

       ENOENT The rseq argument is NULL, but no memory location  is  cur‐
              rently registered for this thread.

VERSIONS
       The rseq() system call was added in Linux 4.X (TODO).

CONFORMING TO
       rseq() is Linux-specific.

ALGORITHM
       The restartable sequences mechanism is the overlap of two distinct
       restart mechanisms: a sequence  counter  tracking  preemption  and
       signal  delivery for high-level code, and an ip-fixup-based mecha‐
       nism for the final assembly instruction sequence.

       A high-level summary of the algorithm to use rseq from  user-space
       is as follows:

       The  high-level  code between rseq_start() and rseq_finish() loads
       the current value of the sequence  counter  in  rseq_start(),  and
       then  it  gets  compared  with  the  new  current value within the
       rseq_finish()   restartable    instruction    sequence.    Between
       rseq_start()  and  rseq_finish(),  the high-level code can perform
       operations that do not have side-effects, such as getting the cur‐
       rent CPU number, and loading from variables.

       Stores  are  performed at the very end of the restartable sequence
       assembly block. Each  assembly  block  defines  a  struct  rseq_cs
       structure   which   describes   the  start_ip  and  post_commit_ip
       addresses, as well as the abort_ip address where the kernel should
       move  the  thread  instruction  pointer if a rseq critical section
       assembly block is preempted or if a signal is delivered on top  of
       a rseq critical section assembly block.

       Detailed algorithm of rseq use:

       rseq_start()

           0. Userspace  loads  the  current event counter value from the
              event_counter field of the registered struct rseq TLS area,

       rseq_finish()

              Steps [1]-[3] (inclusive) need to be a sequence of instruc‐
              tions  in  userspace  that  can  handle  being moved to the
              abort_ip between any of those instructions.

              The abort_ip address needs to be  less  than  start_ip,  or
              greater-or-equal  the  post_commit_ip.   Step  [4]  and the
              failure code step [F1] need to be at addresses lesser  than
              start_ip, or greater-or-equal the post_commit_ip.

           [ start_ip ]

           1. Userspace stores the address of the struct rseq_cs assembly
              block descriptor into the rseq_cs field of  the  registered
              struct rseq TLS area.

           2. Userspace  tests  to  see whether the current event_counter
              value match the value loaded at [0].  Manually  jumping  to
              [F1] in case of a mismatch.

              Note  that  if  we are preempted or interrupted by a signal
              after [1] and before post_commit_ip, then the  kernel  also
              performs the comparison performed in [2], and conditionally
              clears the rseq_cs field of struct rseq, then jumps  us  to
              abort_ip.

           3. Userspace   critical   section   final  instruction  before
              post_commit_ip is the commit. The critical section is self-
              terminating.

           [ post_commit_ip ]

           4. Userspace  clears  the rseq_cs field of the struct rseq TLS
              area.

           5. Return true.

           On failure at [2]:

           F1.
              Userspace clears the rseq_cs field of the struct  rseq  TLS
              area. Followed by step [F2].

           [ abort_ip ]

           F2.
              Return false.

EXAMPLE
       The following code uses the rseq() system call to keep a thread-local
       storage variable up to date with the current CPU number, with a fall‐
       back on sched_getcpu(3) if the cache is not  available.  For  example
       simplicity,  it  is  done in main(), but multithreaded programs would
       need to invoke rseq() from each program thread.

           #define _GNU_SOURCE
           #include <stdlib.h>
           #include <stdio.h>
           #include <unistd.h>
           #include <stdint.h>
           #include <sched.h>
           #include <stddef.h>
           #include <errno.h>
           #include <string.h>
           #include <stdbool.h>
           #include <sys/syscall.h>
           #include <linux/rseq.h>

           __attribute__((weak)) __thread volatile struct rseq __rseq_abi = {
               .u.e.cpu_id = -1,
           };

           static int
           sys_rseq(volatile struct rseq *rseq_abi, int flags)
           {
               return syscall(__NR_rseq, rseq_abi, flags);
           }

           static int32_t
           rseq_current_cpu_raw(void)
           {
               return __rseq_abi.u.e.cpu_id;
           }

           static int32_t
           rseq_current_cpu(void)
           {
               int32_t cpu;

               cpu = rseq_current_cpu_raw();
               if (cpu < 0)
                   cpu = sched_getcpu();
               return cpu;
           }

           static int
           rseq_register_current_thread(void)
           {
               int rc;

               rc = sys_rseq(&__rseq_abi, 0);
               if (rc) {
                   fprintf(stderr,
                       "Error: sys_rseq(...) register failed(%d): %s\n",
                       errno, strerror(errno));
                   return -1;
               }
               return 0;
           }

           static int
           rseq_unregister_current_thread(void)
           {
               int rc;

               rc = sys_rseq(NULL, 0);
               if (rc) {
                   fprintf(stderr,
                       "Error: sys_rseq(...) unregister failed(%d): %s\n",
                       errno, strerror(errno));
                   return -1;
               }
               return 0;
           }

           int
           main(int argc, char **argv)
           {
               bool rseq_registered = false;

               if (!rseq_register_current_thread()) {
                   rseq_registered = true;
               } else {
                   fprintf(stderr,
                       "Unable to register restartable sequences.\n");
                   fprintf(stderr, "Using sched_getcpu() as fallback.\n");
               }

               printf("Current CPU number: %d\n", rseq_current_cpu());

               if (rseq_registered && rseq_unregister_current_thread()) {
                   exit(EXIT_FAILURE);
               }
               exit(EXIT_SUCCESS);
           }

SEE ALSO
       sched_getcpu(3)

Linux                           2016-08-19                        RSEQ(2)
---
 MAINTAINERS               |  10 ++
 arch/Kconfig              |   7 +
 fs/exec.c                 |   1 +
 include/linux/sched.h     |  89 ++++++++++++
 include/uapi/linux/rseq.h | 131 +++++++++++++++++
 init/Kconfig              |  13 ++
 kernel/Makefile           |   1 +
 kernel/fork.c             |   2 +
 kernel/rseq.c             | 347 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/core.c       |   4 +
 kernel/sys_ni.c           |   3 +
 11 files changed, 608 insertions(+)
 create mode 100644 include/uapi/linux/rseq.h
 create mode 100644 kernel/rseq.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 1c3feffb1c1c..f05c526fe1e8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11224,6 +11224,16 @@ F:	include/dt-bindings/reset/
 F:	include/linux/reset.h
 F:	include/linux/reset-controller.h
 
+RESTARTABLE SEQUENCES SUPPORT
+M:	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+M:	Peter Zijlstra <peterz@infradead.org>
+M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
+M:	Boqun Feng <boqun.feng@gmail.com>
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+F:	kernel/rseq.c
+F:	include/uapi/linux/rseq.h
+
 RFKILL
 M:	Johannes Berg <johannes@sipsolutions.net>
 L:	linux-wireless@vger.kernel.org
diff --git a/arch/Kconfig b/arch/Kconfig
index 21d0089117fe..6f1203612403 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -257,6 +257,13 @@ config HAVE_REGS_AND_STACK_ACCESS_API
 	  declared in asm/ptrace.h
 	  For example the kprobes-based event tracer needs this API.
 
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
index 62175cbcc801..75fcbaeb0206 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1794,6 +1794,7 @@ static int do_execveat_common(int fd, struct filename *filename,
 	/* execve succeeded */
 	current->fs->in_exec = 0;
 	current->in_execve = 0;
+	rseq_execve(current);
 	acct_update_integrals(current);
 	task_numa_free(current);
 	free_bprm(bprm);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index c05ac5f5aa03..203abf387a14 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -26,6 +26,7 @@
 #include <linux/signal_types.h>
 #include <linux/mm_types_task.h>
 #include <linux/task_io_accounting.h>
+#include <linux/rseq.h>
 
 /* task_struct member predeclarations (sorted alphabetically): */
 struct audit_context;
@@ -966,6 +967,13 @@ struct task_struct {
 	unsigned long			numa_pages_migrated;
 #endif /* CONFIG_NUMA_BALANCING */
 
+#ifdef CONFIG_RSEQ
+	struct rseq __user *rseq;
+	u32 rseq_event_counter;
+	unsigned int rseq_refcount;
+	bool rseq_preempt, rseq_signal, rseq_migrate;
+#endif
+
 	struct tlbflush_unmap_batch	tlb_ubc;
 
 	struct rcu_head			rcu;
@@ -1626,4 +1634,85 @@ extern long sched_getaffinity(pid_t pid, struct cpumask *mask);
 #define TASK_SIZE_OF(tsk)	TASK_SIZE
 #endif
 
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
+ * child inherits. Only applies when forking a process, not a thread. In
+ * case a parent fork() in the middle of a restartable sequence, set the
+ * resume notifier to force the child to retry.
+ */
+static inline void rseq_fork(struct task_struct *t, unsigned long clone_flags)
+{
+	if (clone_flags & CLONE_THREAD) {
+		t->rseq = NULL;
+		t->rseq_event_counter = 0;
+		t->rseq_refcount = 0;
+	} else {
+		t->rseq = current->rseq;
+		t->rseq_event_counter = current->rseq_event_counter;
+		t->rseq_refcount = current->rseq_refcount;
+		rseq_set_notify_resume(t);
+	}
+}
+static inline void rseq_execve(struct task_struct *t)
+{
+	t->rseq = NULL;
+	t->rseq_event_counter = 0;
+	t->rseq_refcount = 0;
+}
+static inline void rseq_sched_out(struct task_struct *t)
+{
+	rseq_set_notify_resume(t);
+}
+static inline void rseq_signal_deliver(struct pt_regs *regs)
+{
+	current->rseq_signal = true;
+	rseq_handle_notify_resume(regs);
+}
+static inline void rseq_preempt(struct task_struct *t)
+{
+	t->rseq_preempt = true;
+}
+static inline void rseq_migrate(struct task_struct *t)
+{
+	t->rseq_migrate = true;
+}
+#else
+static inline void rseq_set_notify_resume(struct task_struct *t)
+{
+}
+static inline void rseq_handle_notify_resume(struct pt_regs *regs)
+{
+}
+static inline void rseq_fork(struct task_struct *t, unsigned long clone_flags)
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
+static inline void rseq_preempt(struct task_struct *t)
+{
+}
+static inline void rseq_migrate(struct task_struct *t)
+{
+}
+#endif
+
 #endif
diff --git a/include/uapi/linux/rseq.h b/include/uapi/linux/rseq.h
new file mode 100644
index 000000000000..8abd8b638ce0
--- /dev/null
+++ b/include/uapi/linux/rseq.h
@@ -0,0 +1,131 @@
+#ifndef _UAPI_LINUX_RSEQ_H
+#define _UAPI_LINUX_RSEQ_H
+
+/*
+ * linux/rseq.h
+ *
+ * Restartable sequences system call API
+ *
+ * Copyright (c) 2015-2016 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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
+	__BYTE_ORDER == __BIG_ENDIAN : defined(__BIG_ENDIAN)
+# define RSEQ_FIELD_u32_u64(field)	uint32_t _padding ## field, field
+#else
+# define RSEQ_FIELD_u32_u64(field)	uint32_t field, _padding ## field
+#endif
+
+enum rseq_flags {
+	RSEQ_FORCE_UNREGISTER = (1 << 0),
+};
+
+enum rseq_cs_flags {
+	RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT	= (1U << 0),
+	RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL	= (1U << 1),
+	RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE	= (1U << 2),
+};
+
+/*
+ * struct rseq_cs is aligned on 4 * 8 bytes to ensure it is always
+ * contained within a single cache-line. It is usually declared as
+ * link-time constant data.
+ */
+struct rseq_cs {
+	RSEQ_FIELD_u32_u64(start_ip);
+	RSEQ_FIELD_u32_u64(post_commit_ip);
+	RSEQ_FIELD_u32_u64(abort_ip);
+	uint32_t flags;
+} __attribute__((aligned(4 * sizeof(uint64_t))));
+
+union rseq_cpu_event {
+	struct {
+		/*
+		 * Restartable sequences cpu_id field.
+		 * Updated by the kernel, and read by user-space with
+		 * single-copy atomicity semantics. Aligned on 32-bit.
+		 * Negative values are reserved for user-space.
+		 */
+		int32_t cpu_id;
+		/*
+		 * Restartable sequences event_counter field.
+		 * Updated by the kernel, and read by user-space with
+		 * single-copy atomicity semantics. Aligned on 32-bit.
+		 */
+		uint32_t event_counter;
+	} e;
+	/*
+	 * On architectures with 64-bit aligned reads, both cpu_id and
+	 * event_counter can be read with single-copy atomicity
+	 * semantics.
+	 */
+	uint64_t v;
+};
+
+/*
+ * struct rseq is aligned on 4 * 8 bytes to ensure it is always
+ * contained within a single cache-line.
+ */
+struct rseq {
+	union rseq_cpu_event u;
+	/*
+	 * Restartable sequences rseq_cs field.
+	 * Contains NULL when no critical section is active for the
+	 * current thread, or holds a pointer to the currently active
+	 * struct rseq_cs.
+	 * Updated by user-space at the beginning and end of assembly
+	 * instruction sequence block, and by the kernel when it
+	 * restarts an assembly instruction sequence block. Read by the
+	 * kernel with single-copy atomicity semantics. Aligned on
+	 * 64-bit.
+	 */
+	RSEQ_FIELD_u32_u64(rseq_cs);
+	/*
+	 * - RSEQ_DISABLE flag:
+	 *
+	 * Fallback fast-track flag for single-stepping.
+	 * Set by user-space if lack of progress is detected.
+	 * Cleared by user-space after rseq finish.
+	 * Read by the kernel.
+	 * - RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT
+	 *     Inhibit instruction sequence block restart and event
+	 *     counter increment on preemption for this thread.
+	 * - RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL
+	 *     Inhibit instruction sequence block restart and event
+	 *     counter increment on signal delivery for this thread.
+	 * - RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE
+	 *     Inhibit instruction sequence block restart and event
+	 *     counter increment on migration for this thread.
+	 */
+	uint32_t flags;
+} __attribute__((aligned(4 * sizeof(uint64_t))));
+
+#endif /* _UAPI_LINUX_RSEQ_H */
diff --git a/init/Kconfig b/init/Kconfig
index 8514b25db21c..b8aa41bd4f4f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1395,6 +1395,19 @@ config MEMBARRIER
 
 	  If unsure, say Y.
 
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
index 4cb8e8b23c6e..5c09592b3b9f 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -111,6 +111,7 @@ obj-$(CONFIG_TORTURE_TEST) += torture.o
 obj-$(CONFIG_MEMBARRIER) += membarrier.o
 
 obj-$(CONFIG_HAS_IOMEM) += memremap.o
+obj-$(CONFIG_RSEQ) += rseq.o
 
 $(obj)/configs.o: $(obj)/config_data.h
 
diff --git a/kernel/fork.c b/kernel/fork.c
index b7e9e57b71ea..f311a99fb1d1 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1849,6 +1849,8 @@ static __latent_entropy struct task_struct *copy_process(
 	 */
 	copy_seccomp(p);
 
+	rseq_fork(p, clone_flags);
+
 	/*
 	 * Process group and session signals need to be delivered to just the
 	 * parent before the fork or both the parent and the child after the
diff --git a/kernel/rseq.c b/kernel/rseq.c
new file mode 100644
index 000000000000..706a83bd885c
--- /dev/null
+++ b/kernel/rseq.c
@@ -0,0 +1,347 @@
+/*
+ * Restartable sequences system call
+ *
+ * Restartable sequences are a lightweight interface that allows
+ * user-level code to be executed atomically relative to scheduler
+ * preemption and signal delivery. Typically used for implementing
+ * per-cpu operations.
+ *
+ * It allows user-space to perform update operations on per-cpu data
+ * without requiring heavy-weight atomic operations.
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
+ *
+ * Copyright (C) 2015, Google, Inc.,
+ * Paul Turner <pjt@google.com> and Andrew Hunter <ahh@google.com>
+ * Copyright (C) 2015-2016, EfficiOS Inc.,
+ * Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ */
+
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+#include <linux/syscalls.h>
+#include <linux/rseq.h>
+#include <linux/types.h>
+#include <asm/ptrace.h>
+
+/*
+ * The restartable sequences mechanism is the overlap of two distinct
+ * restart mechanisms: a sequence counter tracking preemption and signal
+ * delivery for high-level code, and an ip-fixup-based mechanism for the
+ * final assembly instruction sequence.
+ *
+ * A high-level summary of the algorithm to use rseq from user-space is
+ * as follows:
+ *
+ * The high-level code between rseq_start() and rseq_finish() loads the
+ * current value of the sequence counter in rseq_start(), and then it
+ * gets compared with the new current value within the rseq_finish()
+ * restartable instruction sequence. Between rseq_start() and
+ * rseq_finish(), the high-level code can perform operations that do not
+ * have side-effects, such as getting the current CPU number, and
+ * loading from variables.
+ *
+ * Stores are performed at the very end of the restartable sequence
+ * assembly block. Each assembly block within rseq_finish() defines a
+ * "struct rseq_cs" structure which describes the start_ip and
+ * post_commit_ip addresses, as well as the abort_ip address where the
+ * kernel should move the thread instruction pointer if a rseq critical
+ * section assembly block is preempted or if a signal is delivered on
+ * top of a rseq critical section assembly block.
+ *
+ * Detailed algorithm of rseq use:
+ *
+ * rseq_start()
+ *
+ *   0. Userspace loads the current event counter value from the
+ *      event_counter field of the registered struct rseq TLS area,
+ *
+ * rseq_finish()
+ *
+ *   Steps [1]-[3] (inclusive) need to be a sequence of instructions in
+ *   userspace that can handle being moved to the abort_ip between any
+ *   of those instructions.
+ *
+ *   The abort_ip address needs to be less than start_ip, or
+ *   greater-or-equal the post_commit_ip. Step [4] and the failure
+ *   code step [F1] need to be at addresses lesser than start_ip, or
+ *   greater-or-equal the post_commit_ip.
+ *
+ *       [start_ip]
+ *   1.  Userspace stores the address of the struct rseq_cs assembly
+ *       block descriptor into the rseq_cs field of the registered
+ *       struct rseq TLS area. This update is performed through a single
+ *       store, followed by a compiler barrier which prevents the
+ *       compiler from moving following loads or stores before this
+ *       store.
+ *
+ *   2.  Userspace tests to see whether the current event counter value
+ *       match the value loaded at [0]. Manually jumping to [F1] in case
+ *       of a mismatch.
+ *
+ *       Note that if we are preempted or interrupted by a signal
+ *       after [1] and before post_commit_ip, then the kernel also
+ *       performs the comparison performed in [2], and conditionally
+ *       clears the rseq_cs field of struct rseq, then jumps us to
+ *       abort_ip.
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
+/*
+ * The rseq_event_counter allow user-space to detect preemption and
+ * signal delivery. It increments at least once before returning to
+ * user-space if a thread is preempted or has a signal delivered. It is
+ * not meant to be an exact counter of such events.
+ *
+ * Overflow of the event counter is not a problem in practice. It
+ * increments at most once between each user-space thread instruction
+ * executed, so we would need a thread to execute 2^32 instructions or
+ * more between rseq_start() and rseq_finish(), while single-stepping,
+ * for this to be an issue.
+ *
+ * On 64-bit architectures, both cpu_id and event_counter can be updated
+ * with a single 64-bit store. On 32-bit architectures, __put_user() is
+ * expected to perform two 32-bit single-copy stores to guarantee
+ * single-copy atomicity semantics for other threads.
+ */
+static bool rseq_update_cpu_id_event_counter(struct task_struct *t,
+		bool inc_event_counter)
+{
+	union rseq_cpu_event u;
+
+	u.e.cpu_id = raw_smp_processor_id();
+	u.e.event_counter = inc_event_counter ? ++t->rseq_event_counter :
+			t->rseq_event_counter;
+	if (__put_user(u.v, &t->rseq->u.v))
+		return false;
+	return true;
+}
+
+static bool rseq_get_rseq_cs(struct task_struct *t,
+		void __user **start_ip,
+		void __user **post_commit_ip,
+		void __user **abort_ip,
+		uint32_t *cs_flags)
+{
+	unsigned long ptr;
+	struct rseq_cs __user *urseq_cs;
+	struct rseq_cs rseq_cs;
+
+	if (__get_user(ptr, &t->rseq->rseq_cs))
+		return false;
+	if (!ptr)
+		return true;
+	urseq_cs = (struct rseq_cs __user *)ptr;
+	if (copy_from_user(&rseq_cs, urseq_cs, sizeof(rseq_cs)))
+		return false;
+	/*
+	 * We need to clear rseq_cs upon entry into a signal handler
+	 * nested on top of a rseq assembly block, so the signal handler
+	 * will not be fixed up if itself interrupted by a nested signal
+	 * handler or preempted.  We also need to clear rseq_cs if we
+	 * preempt or deliver a signal on top of code outside of the
+	 * rseq assembly block, to ensure that a following preemption or
+	 * signal delivery will not try to perform a fixup needlessly.
+	 */
+	if (clear_user(&t->rseq->rseq_cs, sizeof(t->rseq->rseq_cs)))
+		return false;
+	*start_ip = (void __user *)rseq_cs.start_ip;
+	*post_commit_ip = (void __user *)rseq_cs.post_commit_ip;
+	*abort_ip = (void __user *)rseq_cs.abort_ip;
+	*cs_flags = rseq_cs.flags;
+	return true;
+}
+
+static int rseq_need_restart(struct task_struct *t, uint32_t cs_flags)
+{
+	bool need_restart = false;
+	uint32_t flags;
+
+	/* Get thread flags. */
+	if (__get_user(flags, &t->rseq->flags))
+		return -EFAULT;
+
+	/* Take into account critical section flags. */
+	flags |= cs_flags;
+
+	/*
+	 * Restart on signal can only be inhibited when restart on
+	 * preempt and restart on migrate are inhibited too. Otherwise,
+	 * a preempted signal handler could fail to restart the prior
+	 * execution context on sigreturn.
+	 */
+	if (flags & RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL) {
+		if (!(flags & RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE))
+			return -EINVAL;
+		if (!(flags & RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT))
+			return -EINVAL;
+	}
+	if (t->rseq_migrate
+			&& !(flags & RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE))
+		need_restart = true;
+	else if (t->rseq_preempt
+			&& !(flags & RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT))
+		need_restart = true;
+	else if (t->rseq_signal
+			&& !(flags & RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL))
+		need_restart = true;
+
+	t->rseq_preempt = false;
+	t->rseq_signal = false;
+	t->rseq_migrate = false;
+	if (need_restart)
+		return 1;
+	return 0;
+}
+
+static int rseq_ip_fixup(struct pt_regs *regs)
+{
+	struct task_struct *t = current;
+	void __user *start_ip = NULL;
+	void __user *post_commit_ip = NULL;
+	void __user *abort_ip = NULL;
+	uint32_t cs_flags = 0;
+	int ret;
+
+	ret = rseq_get_rseq_cs(t, &start_ip, &post_commit_ip, &abort_ip,
+			&cs_flags);
+	if (!ret)
+		return -EFAULT;
+
+	ret = rseq_need_restart(t, cs_flags);
+	if (ret < 0)
+		return -EFAULT;
+	if (!ret)
+		return 0;
+
+	/* Handle potentially not being within a critical section. */
+	if ((void __user *)instruction_pointer(regs) >= post_commit_ip ||
+			(void __user *)instruction_pointer(regs) < start_ip)
+		return 1;
+
+	/*
+	 * We set this after potentially failing in
+	 * clear_user so that the signal arrives at the
+	 * faulting rip.
+	 */
+	instruction_pointer_set(regs, (unsigned long)abort_ip);
+	return 1;
+}
+
+/*
+ * This resume handler should always be executed between any of:
+ * - preemption,
+ * - signal delivery,
+ * and return to user-space.
+ *
+ * This is how we can ensure that the entire rseq critical section,
+ * consisting of both the C part and the assembly instruction sequence,
+ * will issue the commit instruction only if executed atomically with
+ * respect to other threads scheduled on the same CPU, and with respect
+ * to signal handlers.
+ */
+void __rseq_handle_notify_resume(struct pt_regs *regs)
+{
+	struct task_struct *t = current;
+	int ret;
+
+	if (unlikely(t->flags & PF_EXITING))
+		return;
+	if (unlikely(!access_ok(VERIFY_WRITE, t->rseq, sizeof(*t->rseq))))
+		goto error;
+	ret = rseq_ip_fixup(regs);
+	if (unlikely(ret < 0))
+		goto error;
+	if (unlikely(!rseq_update_cpu_id_event_counter(t, ret)))
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
+	if (!rseq) {
+		/* Unregister rseq for current thread. */
+		if (unlikely(flags & ~RSEQ_FORCE_UNREGISTER))
+			return -EINVAL;
+		if (flags & RSEQ_FORCE_UNREGISTER) {
+			current->rseq = NULL;
+			current->rseq_refcount = 0;
+			return 0;
+		}
+		if (!current->rseq_refcount)
+			return -ENOENT;
+		if (!--current->rseq_refcount)
+			current->rseq = NULL;
+		return 0;
+	}
+
+	if (unlikely(flags))
+		return -EINVAL;
+
+	if (current->rseq) {
+		/*
+		 * If rseq is already registered, check whether
+		 * the provided address differs from the prior
+		 * one.
+		 */
+		BUG_ON(!current->rseq_refcount);
+		if (current->rseq != rseq)
+			return -EBUSY;
+		if (current->rseq_refcount == UINT_MAX)
+			return -EOVERFLOW;
+		current->rseq_refcount++;
+	} else {
+		/*
+		 * If there was no rseq previously registered,
+		 * we need to ensure the provided rseq is
+		 * properly aligned and valid.
+		 */
+		BUG_ON(current->rseq_refcount);
+		if (!IS_ALIGNED((unsigned long)rseq, __alignof__(*rseq)))
+			return -EINVAL;
+		if (!access_ok(VERIFY_WRITE, rseq, sizeof(*rseq)))
+			return -EFAULT;
+		current->rseq = rseq;
+		current->rseq_refcount = 1;
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
index 0869b20fba81..12da0f771d73 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1170,6 +1170,8 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 #endif
 #endif
 
+	rseq_migrate(p);
+
 	trace_sched_migrate_task(p, new_cpu);
 
 	if (task_cpu(p) != new_cpu) {
@@ -2572,6 +2574,7 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
 {
 	sched_info_switch(rq, prev, next);
 	perf_event_task_sched_out(prev, next);
+	rseq_sched_out(prev);
 	fire_sched_out_preempt_notifiers(prev, next);
 	prepare_lock_switch(rq, next);
 	prepare_arch_switch(next);
@@ -3322,6 +3325,7 @@ static void __sched notrace __schedule(bool preempt)
 	clear_preempt_need_resched();
 
 	if (likely(prev != next)) {
+		rseq_preempt(prev);
 		rq->nr_switches++;
 		rq->curr = next;
 		++*switch_count;
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 8acef8576ce9..c7b366ccf39c 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -258,3 +258,6 @@ cond_syscall(sys_membarrier);
 cond_syscall(sys_pkey_mprotect);
 cond_syscall(sys_pkey_alloc);
 cond_syscall(sys_pkey_free);
+
+/* restartable sequence */
+cond_syscall(sys_rseq);
-- 
2.11.0
