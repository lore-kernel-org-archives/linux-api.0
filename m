From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH for 4.16 00/21] Restartable sequences and CPU op vector
Date: Thu, 14 Dec 2017 11:13:42 -0500
Message-ID: <20171214161403.30643-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,

Following changes based on the last round of review, I'm respinning this
series for another RFC round. It is based on the v4.15-rc3 tag. I am
now targeting the 4.16 merge window.

This series contains:

- Restartable sequences system call (x86 32/64, powerpc 32/64, arm 32),
- CPU operation vector system call (x86 32/64, powerpc 32/64, arm 32).

I have moved the membarrier patches to a different series.

The main changes introduced in this updated version are:

- Introducing a user-space "percpu-op.h" API, which wraps fast and slow
  paths into a single inline function,
- Changes to the cpu_opv page pinning, making it robust with respect to
  concurrent PTE changes,
- Fixed a rseq bug where the rseq_cs pointer was cleared too soon,
  causing hard-to-reproduce races triggered by NUMA page protection.
- Extended rseq selftests to add a "compare twice" approach validating
  invaritants, which catches races more quickly and closer to the
  race.

This updated series documents a major upside of the cpu_opv system call:
it allows performing operations on remote per-cpu data (e.g. migration
of memory between per-cpu memory pools, task migration across per-cpu
work queues, or summing up and clearning per-cpu statistics counters)
by simply passing the CPU number on which the operation must be
performed as argument to the system call.

Doing this without cpu_opv would require use of sched_setaffinity
alongside with restartable sequences, which is not safe against CPU
hot-unplug.

Feedback is welcome!

Thanks,

Mathieu

Boqun Feng (2):
  powerpc: Add support for restartable sequences
  powerpc: Wire up restartable sequences system call

Mathieu Desnoyers (19):
  uapi headers: Provide types_32_64.h
  rseq: Introduce restartable sequences system call (v12)
  arm: Add restartable sequences support
  arm: Wire up restartable sequences system call
  x86: Add support for restartable sequences
  x86: Wire up restartable sequence system call
  sched: Implement push_task_to_cpu
  cpu_opv: Provide cpu_opv system call (v5)
  x86: Wire up cpu_opv system call
  powerpc: Wire up cpu_opv system call
  arm: Wire up cpu_opv system call
  selftests: lib.mk: Introduce OVERRIDE_TARGETS
  cpu_opv: selftests: Implement selftests (v6)
  rseq: selftests: Provide rseq library (v5)
  rseq: selftests: Provide percpu_op API
  rseq: selftests: Provide basic test
  rseq: selftests: Provide basic percpu ops test
  rseq: selftests: Provide parametrized tests
  rseq: selftests: Provide Makefile, scripts, gitignore

 MAINTAINERS                                        |   20 +
 arch/Kconfig                                       |    7 +
 arch/arm/Kconfig                                   |    1 +
 arch/arm/kernel/signal.c                           |    7 +
 arch/arm/tools/syscall.tbl                         |    2 +
 arch/powerpc/Kconfig                               |    1 +
 arch/powerpc/include/asm/systbl.h                  |    2 +
 arch/powerpc/include/asm/unistd.h                  |    2 +-
 arch/powerpc/include/uapi/asm/unistd.h             |    2 +
 arch/powerpc/kernel/signal.c                       |    3 +
 arch/x86/Kconfig                                   |    1 +
 arch/x86/entry/common.c                            |    1 +
 arch/x86/entry/syscalls/syscall_32.tbl             |    2 +
 arch/x86/entry/syscalls/syscall_64.tbl             |    2 +
 arch/x86/kernel/signal.c                           |    6 +
 fs/exec.c                                          |    1 +
 include/linux/sched.h                              |  109 ++
 include/linux/syscalls.h                           |    6 +
 include/trace/events/rseq.h                        |   56 +
 include/uapi/linux/cpu_opv.h                       |  114 ++
 include/uapi/linux/rseq.h                          |  150 +++
 include/uapi/linux/types_32_64.h                   |   67 ++
 init/Kconfig                                       |   30 +
 kernel/Makefile                                    |    2 +
 kernel/cpu_opv.c                                   | 1078 +++++++++++++++++
 kernel/fork.c                                      |    2 +
 kernel/rseq.c                                      |  358 ++++++
 kernel/sched/core.c                                |   38 +
 kernel/sched/sched.h                               |   10 +
 kernel/sys_ni.c                                    |    4 +
 tools/testing/selftests/Makefile                   |    2 +
 tools/testing/selftests/cpu-opv/.gitignore         |    1 +
 tools/testing/selftests/cpu-opv/Makefile           |   17 +
 .../testing/selftests/cpu-opv/basic_cpu_opv_test.c | 1258 ++++++++++++++++++++
 tools/testing/selftests/cpu-opv/cpu-op.c           |  352 ++++++
 tools/testing/selftests/cpu-opv/cpu-op.h           |   59 +
 tools/testing/selftests/lib.mk                     |    4 +
 tools/testing/selftests/rseq/.gitignore            |    7 +
 tools/testing/selftests/rseq/Makefile              |   37 +
 .../testing/selftests/rseq/basic_percpu_ops_test.c |  296 +++++
 tools/testing/selftests/rseq/basic_test.c          |   55 +
 tools/testing/selftests/rseq/param_test.c          | 1163 ++++++++++++++++++
 tools/testing/selftests/rseq/percpu-op.h           |  163 +++
 tools/testing/selftests/rseq/rseq-arm.h            |  732 ++++++++++++
 tools/testing/selftests/rseq/rseq-ppc.h            |  688 +++++++++++
 tools/testing/selftests/rseq/rseq-skip.h           |   82 ++
 tools/testing/selftests/rseq/rseq-x86.h            | 1149 ++++++++++++++++++
 tools/testing/selftests/rseq/rseq.c                |  116 ++
 tools/testing/selftests/rseq/rseq.h                |  164 +++
 tools/testing/selftests/rseq/run_param_test.sh     |  130 ++
 50 files changed, 8558 insertions(+), 1 deletion(-)
 create mode 100644 include/trace/events/rseq.h
 create mode 100644 include/uapi/linux/cpu_opv.h
 create mode 100644 include/uapi/linux/rseq.h
 create mode 100644 include/uapi/linux/types_32_64.h
 create mode 100644 kernel/cpu_opv.c
 create mode 100644 kernel/rseq.c
 create mode 100644 tools/testing/selftests/cpu-opv/.gitignore
 create mode 100644 tools/testing/selftests/cpu-opv/Makefile
 create mode 100644 tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c
 create mode 100644 tools/testing/selftests/cpu-opv/cpu-op.c
 create mode 100644 tools/testing/selftests/cpu-opv/cpu-op.h
 create mode 100644 tools/testing/selftests/rseq/.gitignore
 create mode 100644 tools/testing/selftests/rseq/Makefile
 create mode 100644 tools/testing/selftests/rseq/basic_percpu_ops_test.c
 create mode 100644 tools/testing/selftests/rseq/basic_test.c
 create mode 100644 tools/testing/selftests/rseq/param_test.c
 create mode 100644 tools/testing/selftests/rseq/percpu-op.h
 create mode 100644 tools/testing/selftests/rseq/rseq-arm.h
 create mode 100644 tools/testing/selftests/rseq/rseq-ppc.h
 create mode 100644 tools/testing/selftests/rseq/rseq-skip.h
 create mode 100644 tools/testing/selftests/rseq/rseq-x86.h
 create mode 100644 tools/testing/selftests/rseq/rseq.c
 create mode 100644 tools/testing/selftests/rseq/rseq.h
 create mode 100755 tools/testing/selftests/rseq/run_param_test.sh

-- 
2.11.0
