From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.18 00/14] Restartable Sequences
Date: Mon, 30 Apr 2018 18:44:19 -0400
Message-ID: <20180430224433.17407-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Joel Fernandes <joelaf@google.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
List-Id: linux-api@vger.kernel.org

Hi,

Here is an updated RFC round of the Restartable Sequences patchset
based on kernel 4.17-rc3. Based on feedback from Linus, I'm introducing
only the rseq system call, keeping the rest for later.

This already enables speeding up the Facebook jemalloc and arm64 PMC
read from user-space use-cases, as well as speedup of use-cases relying
on getting the current cpu number from user-space. We'll have to wait
until a more complete solution is introduced before the LTTng-UST
tracer can replace its ring buffer atomic instructions with rseq
though. But let's proceed one step at a time.

The main change introduced by the removal of cpu_opv from this series
in terms of library use from user-space is that APIs that previously
took a CPU number as argument now only act on the current CPU.

So for instance, this turns:

  int cpu = rseq_per_cpu_lock(lock, target_cpu);
  [...]
  rseq_per_cpu_unlock(lock, cpu);

into

  int cpu = rseq_this_cpu_lock(lock);
  [...]
  rseq_per_cpu_unlock(lock, cpu);

and:

  per_cpu_list_push(list, node, target_cpu);
  [...]
  per_cpu_list_pop(list, node, target_cpu);

into

  this_cpu_list_push(list, node, &cpu);  /* cpu is an output parameter. */
  [...]
  node = this_cpu_list_pop(list, &cpu);  /* cpu is an output parameter. */

Eventually integrating cpu_opv or some alternative will allow passing
the cpu number as parameter rather than requiring the algorithm to work
on the current CPU.

The second effect of not having the cpu_opv fallback is that
line and instruction single-stepping with a debugger transforms rseq
critical sections based on retry loops into never-ending loops.
Debuggers need to use the __rseq_table section to skip those critical
sections in order to correctly behave when single-stepping a thread
which uses rseq in a retry loop. However, applications which use an
alternative fallback method rather than retrying on rseq fast-path abort
won't be affected by this kind of single-stepping issue.

Feedback is welcome!

Thanks,

Mathieu

Boqun Feng (2):
  powerpc: Add support for restartable sequences
  powerpc: Wire up restartable sequences system call

Mathieu Desnoyers (12):
  uapi headers: Provide types_32_64.h (v2)
  rseq: Introduce restartable sequences system call (v13)
  arm: Add restartable sequences support
  arm: Wire up restartable sequences system call
  x86: Add support for restartable sequences (v2)
  x86: Wire up restartable sequence system call
  selftests: lib.mk: Introduce OVERRIDE_TARGETS
  rseq: selftests: Provide rseq library (v5)
  rseq: selftests: Provide basic test
  rseq: selftests: Provide basic percpu ops test (v2)
  rseq: selftests: Provide parametrized tests (v2)
  rseq: selftests: Provide Makefile, scripts, gitignore (v2)

 MAINTAINERS                                        |   12 +
 arch/Kconfig                                       |    7 +
 arch/arm/Kconfig                                   |    1 +
 arch/arm/kernel/signal.c                           |    7 +
 arch/arm/tools/syscall.tbl                         |    1 +
 arch/powerpc/Kconfig                               |    1 +
 arch/powerpc/include/asm/systbl.h                  |    1 +
 arch/powerpc/include/asm/unistd.h                  |    2 +-
 arch/powerpc/include/uapi/asm/unistd.h             |    1 +
 arch/powerpc/kernel/signal.c                       |    3 +
 arch/x86/Kconfig                                   |    1 +
 arch/x86/entry/common.c                            |    3 +
 arch/x86/entry/syscalls/syscall_32.tbl             |    1 +
 arch/x86/entry/syscalls/syscall_64.tbl             |    1 +
 arch/x86/kernel/signal.c                           |    6 +
 fs/exec.c                                          |    1 +
 include/linux/sched.h                              |  134 +++
 include/linux/syscalls.h                           |    4 +-
 include/trace/events/rseq.h                        |   56 +
 include/uapi/linux/rseq.h                          |  150 +++
 include/uapi/linux/types_32_64.h                   |   67 ++
 init/Kconfig                                       |   23 +
 kernel/Makefile                                    |    1 +
 kernel/fork.c                                      |    2 +
 kernel/rseq.c                                      |  366 ++++++
 kernel/sched/core.c                                |    2 +
 kernel/sys_ni.c                                    |    3 +
 tools/testing/selftests/Makefile                   |    1 +
 tools/testing/selftests/lib.mk                     |    4 +
 tools/testing/selftests/rseq/.gitignore            |    6 +
 tools/testing/selftests/rseq/Makefile              |   29 +
 .../testing/selftests/rseq/basic_percpu_ops_test.c |  312 +++++
 tools/testing/selftests/rseq/basic_test.c          |   55 +
 tools/testing/selftests/rseq/param_test.c          | 1259 ++++++++++++++++++++
 tools/testing/selftests/rseq/rseq-arm.h            |  732 ++++++++++++
 tools/testing/selftests/rseq/rseq-ppc.h            |  688 +++++++++++
 tools/testing/selftests/rseq/rseq-skip.h           |   82 ++
 tools/testing/selftests/rseq/rseq-x86.h            | 1149 ++++++++++++++++++
 tools/testing/selftests/rseq/rseq.c                |  116 ++
 tools/testing/selftests/rseq/rseq.h                |  164 +++
 tools/testing/selftests/rseq/run_param_test.sh     |  120 ++
 41 files changed, 5572 insertions(+), 2 deletions(-)
 create mode 100644 include/trace/events/rseq.h
 create mode 100644 include/uapi/linux/rseq.h
 create mode 100644 include/uapi/linux/types_32_64.h
 create mode 100644 kernel/rseq.c
 create mode 100644 tools/testing/selftests/rseq/.gitignore
 create mode 100644 tools/testing/selftests/rseq/Makefile
 create mode 100644 tools/testing/selftests/rseq/basic_percpu_ops_test.c
 create mode 100644 tools/testing/selftests/rseq/basic_test.c
 create mode 100644 tools/testing/selftests/rseq/param_test.c
 create mode 100644 tools/testing/selftests/rseq/rseq-arm.h
 create mode 100644 tools/testing/selftests/rseq/rseq-ppc.h
 create mode 100644 tools/testing/selftests/rseq/rseq-skip.h
 create mode 100644 tools/testing/selftests/rseq/rseq-x86.h
 create mode 100644 tools/testing/selftests/rseq/rseq.c
 create mode 100644 tools/testing/selftests/rseq/rseq.h
 create mode 100755 tools/testing/selftests/rseq/run_param_test.sh

-- 
2.11.0
