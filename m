From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.17 02/21] rseq: Introduce restartable sequences system call (v12)
Date: Tue, 27 Mar 2018 12:05:23 -0400
Message-ID: <20180327160542.28457-3-mathieu.desnoyers@efficios.com>
References: <20180327160542.28457-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180327160542.28457-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Alexander Viro <viro@zeniv.linux.org.uk>
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
architectures and speeds up the user-space fast path. A second system
call, cpu_opv(), is proposed as fallback to deal with debugger
single-stepping. cpu_opv() executes a sequence of operations on behalf
of user-space with preemption disabled.

Here are benchmarks of various rseq use-cases.

Test hardware:

arm32: ARMv7 Processor rev 4 (v7l) "Cubietruck", 2-core
x86-64: Intel E5-2630 v3@2.40GHz, 16-core, hyperthreading

The following benchmarks were all performed on a single thread.

* Per-CPU statistic counter increment

                getcpu+atomic (ns/op)    rseq (ns/op)    speedup
arm32:                344.0                 31.4          11.0
x86-64:                15.3                  2.0           7.7

* LTTng-UST: write event 32-bit header, 32-bit payload into tracer
             per-cpu buffer

                getcpu+atomic (ns/op)    rseq (ns/op)    speedup
arm32:               2502.0                 2250.0         1.1
x86-64:               117.4                   98.0         1.2

* liburcu percpu: lock-unlock pair, dereference, read/compare word

                getcpu+atomic (ns/op)    rseq (ns/op)    speedup
arm32:                751.0                 128.5          5.8
x86-64:                53.4                  28.6          1.9

* jemalloc memory allocator adapted to use rseq

Using rseq with per-cpu memory pools in jemalloc at Facebook (based on
rseq 2016 implementation):

The production workload response-time has 1-2% gain avg. latency, and
the P99 overall latency drops by 2-3%.

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

- Speed (benchmark taken on v8 of patchset)

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
567 bytes, and the data size increase of vmlinux is 5696 bytes.

On x86-64, between CONFIG_CPU_OPV=n/y, the text size increase of vmlinux is
5576 bytes, and the data size increase of vmlinux is 6164 bytes.

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

Changes since v9:
- Update changelog.
- Fold instrumentation patch.
- check abort-ip signature: Add a signature before the abort-ip landing
  address. This signature is also received as a new parameter to the
  rseq system call. The kernel uses it ensures that rseq cannot be used
  as an exploit vector to redirect execution to arbitrary code.
- Use rseq pointer for both register and unregister. This is more
  symmetric, and eventually allow supporting a linked list of rseq
  struct per thread if needed in the future.
- Unregistration of a rseq structure is now done with
  RSEQ_FLAG_UNREGISTER.
- Remove reference counting. Return "EBUSY" to the caller if rseq is
  already registered for the current thread. This simplifies
  implementation while still allowing user-space to perform lazy
  registration in multi-lib use-cases. (suggested by Ben Maurer)
- Clear rseq_cs upon unregister.
- Set cpu_id back to -1 on unregister, so if rseq user libraries follow
  an unregister, and they expect to lazily register rseq, they can do
  so.
- Document rseq_cs clear requirement: JIT should reset the rseq_cs
  pointer before reclaiming memory of rseq_cs structure.
- Introduce rseq_len syscall parameter, rseq_cs version field:
  Allow keeping track of the registered rseq struct length, for future
  extensions. Add rseq_cs version as first field. Will allow future
  extensions.
- Use offset and unsigned arithmetic to save a branch:  Save a
  conditional branch when comparing instruction pointer against a
  rseq_cs descriptor's address range by having post_commit_ip as an
  offset from start_ip, and using unsigned integer comparison.
  Suggested by Ben Maurer.
- Remove event counter from ABI. Suggested by Andy Lutomirski.
- Add INIT_ONSTACK macro: Introduce the
  RSEQ_FIELD_u32_u64_INIT_ONSTACK() macros to ensure that users
  correctly initialize the upper bits of RSEQ_FIELD_u32_u64() on their
  stack to 0 on 32-bit architectures.
- Select MEMBARRIER: Allows user-space rseq fast-paths to use the value
  of cpu_id field (inherently required by the rseq algorithm) to figure
  out whether membarrier can be expected to be available.
  This effectively allows user-space fast-paths to remove extra
  comparisons and branch testing whether membarrier is enabled, and thus
  whether a full barrier is required (e.g. in userspace RCU
  implementation after rcu_read_lock/before rcu_read_unlock).
- Expose cpu_id_start field: Checking whether the (cpu_id < 0) in the C
  preparation part of the rseq fast-path brings significant overhead at
  least on arm32. We can remove this extra comparison by exposing two
  distinct cpu_id fields in the rseq TLS:

  The field cpu_id_start always contain a *possible* cpu number, although
  it may not be the current one if, for instance, rseq is not initialized
  for the current thread. cpu_id_start is meant to be used in the C code
  for the pointer chasing to figure out which per-cpu data structure
  should be passed to the rseq asm sequence.

  The field cpu_id values -1 means rseq is not initialized, and -2 means
  initialization failed. That field is used in the rseq asm sequence to
  confirm that the cpu_id_start value was indeed the current cpu number.
  It also ends up confirming that rseq is initialized for the current
  thread, because values -1 and -2 will never match the cpu_id_start
  possible cpu number values.

  This allows checking the current CPU number and rseq initialization
  state with a single comparison on the fast-path.

Changes since v10:

- Update rseq.c comment, removing reference to event_counter.

Changes since v11:

- Replace task struct rseq_preempt, rseq_signal, and rseq_migrate
  bool by u32 rseq_event_mask.
- Add missing sys_rseq() asmlinkage declaration to
  include/linux/syscalls.h.
- Copy event mask on process fork, set to 0 on exec and thread-fork.
- Cleanups based on review from Peter Zijlstra.
- Cleanups based on review from Thomas Gleixner.
- Fix: rseq_cs needs to be cleared only when:
  - Nested over non-critical-section userspace code,
  - Nested over rseq_cs _and_ handling abort.
  Basically, we should never clear rseq_cs when the rseq resume to
  userspace handler is called and it is not handling abort: the
  problematic case is if any of the __get_user()/__put_user done
  by the handler trigger a page fault (e.g. page protection
  done by NUMA page migration work), which triggers preemption:
  the next call to the rseq resume to userspace handler needs to
  perform the abort.
- Perform rseq event mask updates atomically wrt preemption,
- Move rseq_migrate to __set_task_cpu(), thus catching migration
  scenario that bypass set_task_cpu(): fork and wake_up_new_task.
- Merge content of rseq_sched_out into rseq_preempt. There is no
  need to have two hook sites. Both setting the rseq event mask
  preempt bit and setting the notify resume thread flag can be
  done from rseq_preempt().
- Issue rseq_preempt() from fork(), thus ensuring that we handle
  abort if needed.

Man page associated:

RSEQ(2)                Linux Programmer's Manual               RSEQ(2)

NAME
       rseq - Restartable sequences and cpu number cache

SYNOPSIS
       #include <linux/rseq.h>

       int rseq(struct rseq * rseq, uint32_t rseq_len, int flags, uint32_t sig);

DESCRIPTION
       The  rseq()  ABI  accelerates  user-space operations on per-cpu
       data by defining a shared data structure ABI between each user-
       space thread and the kernel.

       It  allows  user-space  to perform update operations on per-cpu
       data without requiring heavy-weight atomic operations.

       Restartable sequences are atomic  with  respect  to  preemption
       (making  it atomic with respect to other threads running on the
       same CPU), as well as  signal  delivery  (user-space  execution
       contexts nested over the same thread).

       It is suited for update operations on per-cpu data.

       It can be used on data structures shared between threads within
       a process, and on data structures shared between threads across
       different processes.

       Some examples of operations that can be accelerated or improved
       by this ABI:

       · Memory allocator per-cpu free-lists,

       · Querying the current CPU number,

       · Incrementing per-CPU counters,

       · Modifying data protected by per-CPU spinlocks,

       · Inserting/removing elements in per-CPU linked-lists,

       · Writing/reading per-CPU ring buffers content.

       · Accurately reading performance monitoring unit counters  with
         respect to thread migration.

       The  rseq argument is a pointer to the thread-local rseq struc‐
       ture to be shared between kernel and user-space.  A  NULL  rseq
       value unregisters the current thread rseq structure.

       The layout of struct rseq is as follows:

       Structure alignment
              This structure is aligned on multiples of 32 bytes.

       Structure size
              This  structure  is  extensible.  Its  size is passed as
              parameter to the rseq system call.

       Fields

           cpu_id_start
              Optimistic cache of the CPU number on which the  current
              thread  is running. Its value is guaranteed to always be
              a possible CPU number, even when rseq  is  not  initial‐
              ized.  The  value it contains should always be confirmed
              by reading the cpu_id field.

           cpu_id
              Cache of the CPU number on which the current  thread  is
              running.  -1 if uninitialized.

           rseq_cs
              The  rseq_cs  field is a pointer to a struct rseq_cs. Is
              is NULL when no rseq assembly block critical section  is
              active for the current thread.  Setting it to point to a
              critical section descriptor (struct rseq_cs)  marks  the
              beginning of the critical section.

           flags
              Flags  indicating  the  restart behavior for the current
              thread. This is mainly used for debugging purposes.  Can
              be either:

       ·      RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT

       ·      RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL

       ·      RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE

       The layout of struct rseq_cs version 0 is as follows:

       Structure alignment
              This structure is aligned on multiples of 32 bytes.

       Structure size
              This structure has a fixed size of 32 bytes.

       Fields

           version
              Version of this structure.

           flags
              Flags indicating the restart behavior of this structure.
              Can be either:

       ·      RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT

       ·      RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL

       ·      RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE

           start_ip
              Instruction pointer address of the first instruction  of
              the sequence of consecutive assembly instructions.

           post_commit_offset
              Offset  (from start_ip address) of the address after the
              last instruction of the sequence of consecutive assembly
              instructions.

           abort_ip
              Instruction  pointer address where to move the execution
              flow in case of abort of  the  sequence  of  consecutive
              assembly instructions.

       The  rseq_len argument is the size of the struct rseq to regis‐
       ter.

       The flags argument is 0 for registration, and  RSEQ_FLAG_UNREG‐
       ISTER for unregistration.

       The  sig argument is the 32-bit signature to be expected before
       the abort handler code.

       A single library per process should keep the rseq structure  in
       a  thread-local  storage  variable.  The cpu_id field should be
       initialized to -1, and the cpu_id_start field  should  be  ini‐
       tialized to a possible CPU value (typically 0).

       Each  thread  is  responsible for registering and unregistering
       its rseq structure. No more than one rseq structure address can
       be registered per thread at a given time.

       In  a  typical  usage scenario, the thread registering the rseq
       structure will be performing  loads  and  stores  from/to  that
       structure.  It  is  however also allowed to read that structure
       from other threads.  The rseq field updates  performed  by  the
       kernel  provide  relaxed  atomicity  semantics, which guarantee
       that other threads performing relaxed atomic reads of  the  cpu
       number cache will always observe a consistent value.

RETURN VALUE
       A  return  value  of  0  indicates  success.  On  error,  -1 is
       returned, and errno is set appropriately.

ERRORS
       EINVAL Either flags contains an invalid value, or rseq contains
              an  address  which  is  not  appropriately  aligned,  or
              rseq_len contains a size that does not  match  the  size
              received on registration.

       ENOSYS The  rseq()  system call is not implemented by this ker‐
              nel.

       EFAULT rseq is an invalid address.

       EBUSY  Restartable sequence  is  already  registered  for  this
              thread.

       EPERM  The  sig  argument  on unregistration does not match the
              signature received on registration.

VERSIONS
       The rseq() system call was added in Linux 4.X (TODO).

CONFORMING TO
       rseq() is Linux-specific.

SEE ALSO
       sched_getcpu(3)

Linux                         2017-11-06                       RSEQ(2)
---
 MAINTAINERS                 |  11 ++
 arch/Kconfig                |   7 +
 fs/exec.c                   |   1 +
 include/linux/sched.h       | 118 +++++++++++++++
 include/linux/syscalls.h    |   3 +
 include/trace/events/rseq.h |  56 +++++++
 include/uapi/linux/rseq.h   | 150 +++++++++++++++++++
 init/Kconfig                |  14 ++
 kernel/Makefile             |   1 +
 kernel/fork.c               |   2 +
 kernel/rseq.c               | 358 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/core.c         |   1 +
 kernel/sched/sched.h        |   1 +
 kernel/sys_ni.c             |   3 +
 14 files changed, 726 insertions(+)
 create mode 100644 include/trace/events/rseq.h
 create mode 100644 include/uapi/linux/rseq.h
 create mode 100644 kernel/rseq.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 73c0cdabf755..789463978181 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11812,6 +11812,17 @@ F:	include/dt-bindings/reset/
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
+F:	include/trace/events/rseq.h
+
 RFKILL
 M:	Johannes Berg <johannes@sipsolutions.net>
 L:	linux-wireless@vger.kernel.org
diff --git a/arch/Kconfig b/arch/Kconfig
index 76c0b54443b1..b9b252b1e97a 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -272,6 +272,13 @@ config HAVE_REGS_AND_STACK_ACCESS_API
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
index 7eb8d21bcab9..3eb74db04ee7 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1807,6 +1807,7 @@ static int do_execveat_common(int fd, struct filename *filename,
 	current->fs->in_exec = 0;
 	current->in_execve = 0;
 	membarrier_execve(current);
+	rseq_execve(current);
 	acct_update_integrals(current);
 	task_numa_free(current);
 	free_bprm(bprm);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b161ef8a902e..708d8e9e0821 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -27,6 +27,7 @@
 #include <linux/signal_types.h>
 #include <linux/mm_types_task.h>
 #include <linux/task_io_accounting.h>
+#include <linux/rseq.h>
 
 /* task_struct member predeclarations (sorted alphabetically): */
 struct audit_context;
@@ -979,6 +980,17 @@ struct task_struct {
 	unsigned long			numa_pages_migrated;
 #endif /* CONFIG_NUMA_BALANCING */
 
+#ifdef CONFIG_RSEQ
+	struct rseq __user *rseq;
+	u32 rseq_len;
+	u32 rseq_sig;
+	/*
+	 * RmW on rseq_event_mask must be performed atomically
+	 * with respect to preemption.
+	 */
+	unsigned long rseq_event_mask;
+#endif
+
 	struct tlbflush_unmap_batch	tlb_ubc;
 
 	struct rcu_head			rcu;
@@ -1688,4 +1700,110 @@ extern long sched_getaffinity(pid_t pid, struct cpumask *mask);
 #define TASK_SIZE_OF(tsk)	TASK_SIZE
 #endif
 
+#ifdef CONFIG_RSEQ
+
+/*
+ * Map the event mask on the user-space ABI enum rseq_cs_flags
+ * for direct mask checks.
+ */
+enum rseq_event_mask_bits {
+	RSEQ_EVENT_PREEMPT_BIT	= RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT_BIT,
+	RSEQ_EVENT_SIGNAL_BIT	= RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL_BIT,
+	RSEQ_EVENT_MIGRATE_BIT	= RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE_BIT,
+};
+
+enum rseq_event_mask {
+	RSEQ_EVENT_PREEMPT	= (1U << RSEQ_EVENT_PREEMPT_BIT),
+	RSEQ_EVENT_SIGNAL	= (1U << RSEQ_EVENT_SIGNAL_BIT),
+	RSEQ_EVENT_MIGRATE	= (1U << RSEQ_EVENT_MIGRATE_BIT),
+};
+
+static inline void rseq_set_notify_resume(struct task_struct *t)
+{
+	if (t->rseq)
+		set_tsk_thread_flag(t, TIF_NOTIFY_RESUME);
+}
+
+void __rseq_handle_notify_resume(struct pt_regs *regs);
+
+static inline void rseq_handle_notify_resume(struct pt_regs *regs)
+{
+	if (current->rseq)
+		__rseq_handle_notify_resume(regs);
+}
+
+static inline void rseq_signal_deliver(struct pt_regs *regs)
+{
+	set_bit(RSEQ_EVENT_SIGNAL_BIT, &current->rseq_event_mask);
+	rseq_handle_notify_resume(regs);
+}
+
+static inline void rseq_preempt(struct task_struct *t)
+{
+	set_bit(RSEQ_EVENT_PREEMPT_BIT, &t->rseq_event_mask);
+	rseq_set_notify_resume(t);
+}
+
+static inline void rseq_migrate(struct task_struct *t)
+{
+	set_bit(RSEQ_EVENT_MIGRATE_BIT, &t->rseq_event_mask);
+	rseq_set_notify_resume(t);
+}
+
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
+		t->rseq_len = 0;
+		t->rseq_sig = 0;
+		t->rseq_event_mask = 0;
+	} else {
+		t->rseq = current->rseq;
+		t->rseq_len = current->rseq_len;
+		t->rseq_sig = current->rseq_sig;
+		t->rseq_event_mask = current->rseq_event_mask;
+		rseq_preempt(t);
+	}
+}
+
+static inline void rseq_execve(struct task_struct *t)
+{
+	t->rseq = NULL;
+	t->rseq_len = 0;
+	t->rseq_sig = 0;
+	t->rseq_event_mask = 0;
+}
+
+#else
+
+static inline void rseq_set_notify_resume(struct task_struct *t)
+{
+}
+static inline void rseq_handle_notify_resume(struct pt_regs *regs)
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
+static inline void rseq_fork(struct task_struct *t, unsigned long clone_flags)
+{
+}
+static inline void rseq_execve(struct task_struct *t)
+{
+}
+
+#endif
+
 #endif
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index a78186d826d7..340650b4ec54 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -66,6 +66,7 @@ struct old_linux_dirent;
 struct perf_event_attr;
 struct file_handle;
 struct sigaltstack;
+struct rseq;
 union bpf_attr;
 
 #include <linux/types.h>
@@ -940,5 +941,7 @@ asmlinkage long sys_pkey_alloc(unsigned long flags, unsigned long init_val);
 asmlinkage long sys_pkey_free(int pkey);
 asmlinkage long sys_statx(int dfd, const char __user *path, unsigned flags,
 			  unsigned mask, struct statx __user *buffer);
+asmlinkage long sys_rseq(struct rseq __user *rseq, uint32_t rseq_len,
+			int flags, uint32_t sig);
 
 #endif
diff --git a/include/trace/events/rseq.h b/include/trace/events/rseq.h
new file mode 100644
index 000000000000..c4609a3f5008
--- /dev/null
+++ b/include/trace/events/rseq.h
@@ -0,0 +1,56 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM rseq
+
+#if !defined(_TRACE_RSEQ_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_RSEQ_H
+
+#include <linux/tracepoint.h>
+#include <linux/types.h>
+
+TRACE_EVENT(rseq_update,
+
+	TP_PROTO(struct task_struct *t),
+
+	TP_ARGS(t),
+
+	TP_STRUCT__entry(
+		__field(s32, cpu_id)
+	),
+
+	TP_fast_assign(
+		__entry->cpu_id = raw_smp_processor_id();
+	),
+
+	TP_printk("cpu_id=%d", __entry->cpu_id)
+);
+
+TRACE_EVENT(rseq_ip_fixup,
+
+	TP_PROTO(unsigned long regs_ip, unsigned long start_ip,
+		unsigned long post_commit_offset, unsigned long abort_ip),
+
+	TP_ARGS(regs_ip, start_ip, post_commit_offset, abort_ip),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, regs_ip)
+		__field(unsigned long, start_ip)
+		__field(unsigned long, post_commit_offset)
+		__field(unsigned long, abort_ip)
+	),
+
+	TP_fast_assign(
+		__entry->regs_ip = regs_ip;
+		__entry->start_ip = start_ip;
+		__entry->post_commit_offset = post_commit_offset;
+		__entry->abort_ip = abort_ip;
+	),
+
+	TP_printk("regs_ip=0x%lx start_ip=0x%lx post_commit_offset=%lu abort_ip=0x%lx",
+		__entry->regs_ip, __entry->start_ip,
+		__entry->post_commit_offset, __entry->abort_ip)
+);
+
+#endif /* _TRACE_SOCK_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/include/uapi/linux/rseq.h b/include/uapi/linux/rseq.h
new file mode 100644
index 000000000000..3895ec940059
--- /dev/null
+++ b/include/uapi/linux/rseq.h
@@ -0,0 +1,150 @@
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
+#else
+# include <stdint.h>
+#endif
+
+#include <linux/types_32_64.h>
+
+enum rseq_cpu_id_state {
+	RSEQ_CPU_ID_UNINITIALIZED		= -1,
+	RSEQ_CPU_ID_REGISTRATION_FAILED		= -2,
+};
+
+enum rseq_flags {
+	RSEQ_FLAG_UNREGISTER = (1 << 0),
+};
+
+enum rseq_cs_flags_bit {
+	RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT_BIT	= 0,
+	RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL_BIT	= 1,
+	RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE_BIT	= 2,
+};
+
+enum rseq_cs_flags {
+	RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT	=
+		(1U << RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT_BIT),
+	RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL	=
+		(1U << RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL_BIT),
+	RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE	=
+		(1U << RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE_BIT),
+};
+
+/*
+ * struct rseq_cs is aligned on 4 * 8 bytes to ensure it is always
+ * contained within a single cache-line. It is usually declared as
+ * link-time constant data.
+ */
+struct rseq_cs {
+	/* Version of this structure. */
+	uint32_t version;
+	/* enum rseq_cs_flags */
+	uint32_t flags;
+	LINUX_FIELD_u32_u64(start_ip);
+	/* Offset from start_ip. */
+	LINUX_FIELD_u32_u64(post_commit_offset);
+	LINUX_FIELD_u32_u64(abort_ip);
+} __attribute__((aligned(4 * sizeof(uint64_t))));
+
+/*
+ * struct rseq is aligned on 4 * 8 bytes to ensure it is always
+ * contained within a single cache-line.
+ *
+ * A single struct rseq per thread is allowed.
+ */
+struct rseq {
+	/*
+	 * Restartable sequences cpu_id_start field. Updated by the
+	 * kernel, and read by user-space with single-copy atomicity
+	 * semantics. Aligned on 32-bit. Always contains a value in the
+	 * range of possible CPUs, although the value may not be the
+	 * actual current CPU (e.g. if rseq is not initialized). This
+	 * CPU number value should always be compared against the value
+	 * of the cpu_id field before performing a rseq commit or
+	 * returning a value read from a data structure indexed using
+	 * the cpu_id_start value.
+	 */
+	uint32_t cpu_id_start;
+	/*
+	 * Restartable sequences cpu_id field. Updated by the kernel,
+	 * and read by user-space with single-copy atomicity semantics.
+	 * Aligned on 32-bit. Values RSEQ_CPU_ID_UNINITIALIZED and
+	 * RSEQ_CPU_ID_REGISTRATION_FAILED have a special semantic: the
+	 * former means "rseq uninitialized", and latter means "rseq
+	 * initialization failed". This value is meant to be read within
+	 * rseq critical sections and compared with the cpu_id_start
+	 * value previously read, before performing the commit instruction,
+	 * or read and compared with the cpu_id_start value before returning
+	 * a value loaded from a data structure indexed using the
+	 * cpu_id_start value.
+	 */
+	uint32_t cpu_id;
+	/*
+	 * Restartable sequences rseq_cs field.
+	 *
+	 * Contains NULL when no critical section is active for the current
+	 * thread, or holds a pointer to the currently active struct rseq_cs.
+	 *
+	 * Updated by user-space, which sets the address of the currently
+	 * active rseq_cs at the beginning of assembly instruction sequence
+	 * block, and set to NULL by the kernel when it restarts an assembly
+	 * instruction sequence block, as well as when the kernel detects that
+	 * it is preempting or delivering a signal outside of the range
+	 * targeted by the rseq_cs. Also needs to be set to NULL by user-space
+	 * before reclaiming memory that contains the targeted struct rseq_cs.
+	 *
+	 * Read and set by the kernel with single-copy atomicity semantics.
+	 * Set by user-space with single-copy atomicity semantics. Aligned
+	 * on 64-bit.
+	 */
+	LINUX_FIELD_u32_u64(rseq_cs);
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
index e37f4b2a6445..9610d3def25c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1418,6 +1418,20 @@ config ARCH_HAS_MEMBARRIER_CALLBACKS
 config ARCH_HAS_MEMBARRIER_SYNC_CORE
 	bool
 
+config RSEQ
+	bool "Enable rseq() system call" if EXPERT
+	default y
+	depends on HAVE_RSEQ
+	select MEMBARRIER
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
index f85ae5dfa474..7085c841c413 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -113,6 +113,7 @@ obj-$(CONFIG_CONTEXT_TRACKING) += context_tracking.o
 obj-$(CONFIG_TORTURE_TEST) += torture.o
 
 obj-$(CONFIG_HAS_IOMEM) += memremap.o
+obj-$(CONFIG_RSEQ) += rseq.o
 
 $(obj)/configs.o: $(obj)/config_data.h
 
diff --git a/kernel/fork.c b/kernel/fork.c
index e5d9d405ae4e..3970526f7b45 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1898,6 +1898,8 @@ static __latent_entropy struct task_struct *copy_process(
 	 */
 	copy_seccomp(p);
 
+	rseq_fork(p, clone_flags);
+
 	/*
 	 * Process group and session signals need to be delivered to just the
 	 * parent before the fork or both the parent and the child after the
diff --git a/kernel/rseq.c b/kernel/rseq.c
new file mode 100644
index 000000000000..93f3f169e112
--- /dev/null
+++ b/kernel/rseq.c
@@ -0,0 +1,358 @@
+/*
+ * Restartable sequences system call
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
+#define CREATE_TRACE_POINTS
+#include <trace/events/rseq.h>
+
+/*
+ *
+ * Restartable sequences are a lightweight interface that allows
+ * user-level code to be executed atomically relative to scheduler
+ * preemption and signal delivery. Typically used for implementing
+ * per-cpu operations.
+ *
+ * It allows user-space to perform update operations on per-cpu data
+ * without requiring heavy-weight atomic operations.
+ *
+ * Detailed algorithm of rseq user-space assembly sequences:
+ *
+ *                     init(rseq_cs)
+ *                     cpu = TLS->rseq::cpu_id_start
+ *   [1]               TLS->rseq::rseq_cs = rseq_cs
+ *   [start_ip]        ----------------------------
+ *   [2]               if (cpu != TLS->rseq::cpu_id)
+ *                             goto abort_ip;
+ *   [3]               <last_instruction_in_cs>
+ *   [post_commit_ip]  ----------------------------
+ *
+ *   The address of jump target abort_ip must be outside the critical
+ *   region, i.e.:
+ *
+ *     [abort_ip] < [start_ip]  || [abort_ip] >= [post_commit_ip]
+ *
+ *   Steps [2]-[3] (inclusive) need to be a sequence of instructions in
+ *   userspace that can handle being interrupted between any of those
+ *   instructions, and then resumed to the abort_ip.
+ *
+ *   1.  Userspace stores the address of the struct rseq_cs assembly
+ *       block descriptor into the rseq_cs field of the registered
+ *       struct rseq TLS area. This update is performed through a single
+ *       store within the inline assembly instruction sequence.
+ *       [start_ip]
+ *
+ *   2.  Userspace tests to check whether the current cpu_id field match
+ *       the cpu number loaded before start_ip, branching to abort_ip
+ *       in case of a mismatch.
+ *
+ *       If the sequence is preempted or interrupted by a signal
+ *       at or after start_ip and before post_commit_ip, then the kernel
+ *       clears TLS->__rseq_abi::rseq_cs, and sets the user-space return
+ *       ip to abort_ip before returning to user-space, so the preempted
+ *       execution resumes at abort_ip.
+ *
+ *   3.  Userspace critical section final instruction before
+ *       post_commit_ip is the commit. The critical section is
+ *       self-terminating.
+ *       [post_commit_ip]
+ *
+ *   4.  <success>
+ *
+ *   On failure at [2], or if interrupted by preempt or signal delivery
+ *   between [1] and [3]:
+ *
+ *       [abort_ip]
+ *   F1. <failure>
+ */
+
+static int rseq_update_cpu_id(struct task_struct *t)
+{
+	uint32_t cpu_id = raw_smp_processor_id();
+
+	if (__put_user(cpu_id, &t->rseq->cpu_id_start))
+		return -EFAULT;
+	if (__put_user(cpu_id, &t->rseq->cpu_id))
+		return -EFAULT;
+	trace_rseq_update(t);
+	return 0;
+}
+
+static int rseq_reset_rseq_cpu_id(struct task_struct *t)
+{
+	uint32_t cpu_id_start = 0, cpu_id = RSEQ_CPU_ID_UNINITIALIZED;
+
+	/*
+	 * Reset cpu_id_start to its initial state (0).
+	 */
+	if (__put_user(cpu_id_start, &t->rseq->cpu_id_start))
+		return -EFAULT;
+	/*
+	 * Reset cpu_id to RSEQ_CPU_ID_UNINITIALIZED, so any user coming
+	 * in after unregistration can figure out that rseq needs to be
+	 * registered again.
+	 */
+	if (__put_user(cpu_id, &t->rseq->cpu_id))
+		return -EFAULT;
+	return 0;
+}
+
+static int rseq_get_rseq_cs(struct task_struct *t,
+			    unsigned long *start_ip,
+			    unsigned long *post_commit_offset,
+			    unsigned long *abort_ip,
+			    uint32_t *cs_flags)
+{
+	struct rseq_cs __user *urseq_cs;
+	struct rseq_cs rseq_cs;
+	unsigned long ptr;
+	u32 __user *usig;
+	u32 sig;
+	int ret;
+
+	ret = __get_user(ptr, &t->rseq->rseq_cs);
+	if (ret)
+		return ret;
+	if (!ptr)
+		return 0;
+	urseq_cs = (struct rseq_cs __user *)ptr;
+	if (copy_from_user(&rseq_cs, urseq_cs, sizeof(rseq_cs)))
+		return -EFAULT;
+	if (rseq_cs.version > 0)
+		return -EINVAL;
+
+	/* Ensure that abort_ip is not in the critical section. */
+	if (rseq_cs.abort_ip - rseq_cs.start_ip < rseq_cs.post_commit_offset)
+		return -EINVAL;
+
+	*cs_flags = rseq_cs.flags;
+	*start_ip = rseq_cs.start_ip;
+	*post_commit_offset = rseq_cs.post_commit_offset;
+	*abort_ip = rseq_cs.abort_ip;
+
+	usig = (u32 __user *)(rseq_cs.abort_ip - sizeof(u32));
+	ret = get_user(sig, usig);
+	if (ret)
+		return ret;
+
+	if (current->rseq_sig != sig) {
+		printk_ratelimited(KERN_WARNING
+			"Possible attack attempt. Unexpected rseq signature 0x%x, expecting 0x%x (pid=%d, addr=%p).\n",
+			sig, current->rseq_sig, current->pid, usig);
+		return -EPERM;
+	}
+	return 0;
+}
+
+static int rseq_need_restart(struct task_struct *t, uint32_t cs_flags)
+{
+	uint32_t flags, event_mask;
+	int ret;
+
+	/* Get thread flags. */
+	ret = __get_user(flags, &t->rseq->flags);
+	if (ret)
+		return ret;
+
+	/* Take critical section flags into account. */
+	flags |= cs_flags;
+
+	/*
+	 * Restart on signal can only be inhibited when restart on
+	 * preempt and restart on migrate are inhibited too. Otherwise,
+	 * a preempted signal handler could fail to restart the prior
+	 * execution context on sigreturn.
+	 */
+	if (unlikely(flags & RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL)) {
+		if ((flags & (RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE
+		    | RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT)) !=
+		    (RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE
+		     | RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT))
+			return -EINVAL;
+	}
+
+	/*
+	 * Load and clear event mask atomically with respect to
+	 * scheduler preemption.
+	 */
+	preempt_disable();
+	event_mask = t->rseq_event_mask;
+	t->rseq_event_mask = 0;
+	preempt_enable();
+
+	event_mask &= ~flags;
+	if (event_mask)
+		return 1;
+	return 0;
+}
+
+static int clear_rseq_cs(struct task_struct *t)
+{
+	unsigned long ptr = 0;
+
+	/*
+	 * The rseq_cs field is set to NULL on preemption or signal
+	 * delivery on top of rseq assembly block, as well as on top
+	 * of code outside of the rseq assembly block. This performs
+	 * a lazy clear of the rseq_cs field.
+	 *
+	 * Set rseq_cs to NULL with single-copy atomicity.
+	 */
+	return __put_user(ptr, &t->rseq->rseq_cs);
+}
+
+static int rseq_ip_fixup(struct pt_regs *regs)
+{
+	unsigned long ip = instruction_pointer(regs), start_ip = 0,
+		post_commit_offset = 0, abort_ip = 0;
+	struct task_struct *t = current;
+	uint32_t cs_flags = 0;
+	bool in_rseq_cs = false;
+	int ret;
+
+	ret = rseq_get_rseq_cs(t, &start_ip, &post_commit_offset, &abort_ip,
+			&cs_flags);
+	if (ret)
+		return ret;
+
+	/*
+	 * Handle potentially not being within a critical section.
+	 * Unsigned comparison will be true when
+	 * ip >= start_ip, and when ip < start_ip + post_commit_offset.
+	 */
+	if (ip - start_ip < post_commit_offset)
+		in_rseq_cs = true;
+
+	/*
+	 * If not nested over a rseq critical section, restart is
+	 * useless. Clear the rseq_cs pointer and return.
+	 */
+	if (!in_rseq_cs)
+		return clear_rseq_cs(t);
+	ret = rseq_need_restart(t, cs_flags);
+	if (ret <= 0)
+		return ret;
+	ret = clear_rseq_cs(t);
+	if (ret)
+		return ret;
+	trace_rseq_ip_fixup(ip, start_ip, post_commit_offset, abort_ip);
+	instruction_pointer_set(regs, (unsigned long)abort_ip);
+	return 0;
+}
+
+/*
+ * This resume handler must always be executed between any of:
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
+	if (unlikely(rseq_update_cpu_id(t)))
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
+SYSCALL_DEFINE4(rseq, struct rseq __user *, rseq, uint32_t, rseq_len,
+		int, flags, uint32_t, sig)
+{
+	int ret;
+
+	if (flags & RSEQ_FLAG_UNREGISTER) {
+		/* Unregister rseq for current thread. */
+		if (current->rseq != rseq || !current->rseq)
+			return -EINVAL;
+		if (current->rseq_len != rseq_len)
+			return -EINVAL;
+		if (current->rseq_sig != sig)
+			return -EPERM;
+		ret = rseq_reset_rseq_cpu_id(current);
+		if (ret)
+			return ret;
+		current->rseq = NULL;
+		current->rseq_len = 0;
+		current->rseq_sig = 0;
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
+		if (current->rseq != rseq || current->rseq_len != rseq_len)
+			return -EINVAL;
+		if (current->rseq_sig != sig)
+			return -EPERM;
+		/* Already registered. */
+		return -EBUSY;
+	}
+
+	/*
+	 * If there was no rseq previously registered,
+	 * ensure the provided rseq is properly aligned and valid.
+	 */
+	if (!IS_ALIGNED((unsigned long)rseq, __alignof__(*rseq)) ||
+	    rseq_len != sizeof(*rseq))
+		return -EINVAL;
+	if (!access_ok(VERIFY_WRITE, rseq, rseq_len))
+		return -EFAULT;
+	current->rseq = rseq;
+	current->rseq_len = rseq_len;
+	current->rseq_sig = sig;
+	/*
+	 * If rseq was previously inactive, and has just been
+	 * registered, ensure the cpu_id_start and cpu_id fields
+	 * are updated before returning to user-space.
+	 */
+	rseq_set_notify_resume(current);
+
+	return 0;
+}
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c94895bc5a2c..771caa7e95c6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2648,6 +2648,7 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
 {
 	sched_info_switch(rq, prev, next);
 	perf_event_task_sched_out(prev, next);
+	rseq_preempt(prev);
 	fire_sched_out_preempt_notifiers(prev, next);
 	prepare_task(next);
 	prepare_arch_switch(next);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index fb5fc458547f..66b070444a7e 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1249,6 +1249,7 @@ static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 #endif
 	p->wake_cpu = cpu;
 #endif
+	rseq_migrate(p);
 }
 
 /*
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index b5189762d275..bfa1ee1bf669 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -259,3 +259,6 @@ cond_syscall(sys_membarrier);
 cond_syscall(sys_pkey_mprotect);
 cond_syscall(sys_pkey_alloc);
 cond_syscall(sys_pkey_free);
+
+/* restartable sequence */
+cond_syscall(sys_rseq);
-- 
2.11.0
