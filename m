From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH for 4.15 00/24] Restartable sequences and CPU op vector v11
Date: Tue, 14 Nov 2017 15:03:50 -0500
Message-ID: <20171114200414.2188-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Here is the last RFC round of the updated rseq patchset containing:

- Restartable sequences system call (x86 32/64, powerpc 32/64, arm 32),
- CPU operation vector system call (x86 32/64, powerpc 32/64, arm 32),
- membarrier shared expedited, and private expedited core serializing
  commands.

This is *not* yet a PR. I'm submitting the patchset as RFC one last
time given that I did a few small fixes, and reordered the patchset,
since the last time I sent it as RFC.

You can alternatively find this patchset as a git branch at this
location:

https://git.kernel.org/pub/scm/linux/kernel/git/rseq/linux-rseq.git
branch: v4.14-rseq-20171114

Orion Hodson is currently testing the private expedited core
serializing membarrier command on Android, where they have a
context synchronization issue reproducer on arm 64. We should know
more about this shortly.

Thanks,

Mathieu

Boqun Feng (2):
  Restartable sequences: powerpc architecture support
  Restartable sequences: Wire up powerpc system call

Mathieu Desnoyers (22):
  Restartable sequences system call (v11)
  Restartable sequences: ARM 32 architecture support
  Restartable sequences: wire up ARM 32 system call
  Restartable sequences: x86 32/64 architecture support
  Restartable sequences: wire up x86 32/64 system call
  Provide cpu_opv system call (v3)
  cpu_opv: Wire up x86 32/64 system call
  cpu_opv: Wire up powerpc system call
  cpu_opv: Wire up ARM32 system call
  cpu_opv: Implement selftests (v2)
  Restartable sequences: Provide self-tests (v2)
  Restartable sequences selftests: arm: workaround gcc asm size guess
  membarrier: selftest: Test private expedited cmd (v2)
  membarrier: powerpc: Skip memory barrier in switch_mm() (v7)
  membarrier: Document scheduler barrier requirements (v5)
  membarrier: provide SHARED_EXPEDITED command
  membarrier: selftest: Test shared expedited cmd
  membarrier: Provide core serializing command
  x86: Introduce sync_core_before_usermode (v2)
  membarrier: x86: Provide core serializing command (v2)
  membarrier: selftest: Test private expedited sync core cmd
  membarrier: arm64: Provide core serializing command

 MAINTAINERS                                        |   21 +
 arch/Kconfig                                       |    7 +
 arch/arm/Kconfig                                   |    1 +
 arch/arm/kernel/signal.c                           |    7 +
 arch/arm/tools/syscall.tbl                         |    2 +
 arch/arm64/Kconfig                                 |    1 +
 arch/arm64/kernel/entry.S                          |    4 +
 arch/powerpc/Kconfig                               |    2 +
 arch/powerpc/include/asm/membarrier.h              |   26 +
 arch/powerpc/include/asm/systbl.h                  |    2 +
 arch/powerpc/include/asm/unistd.h                  |    2 +-
 arch/powerpc/include/uapi/asm/unistd.h             |    2 +
 arch/powerpc/kernel/signal.c                       |    3 +
 arch/powerpc/mm/mmu_context.c                      |    7 +
 arch/x86/Kconfig                                   |    3 +
 arch/x86/entry/common.c                            |    1 +
 arch/x86/entry/entry_32.S                          |    5 +
 arch/x86/entry/entry_64.S                          |    8 +
 arch/x86/entry/syscalls/syscall_32.tbl             |    2 +
 arch/x86/entry/syscalls/syscall_64.tbl             |    2 +
 arch/x86/include/asm/processor.h                   |   10 +
 arch/x86/kernel/signal.c                           |    6 +
 arch/x86/mm/tlb.c                                  |    6 +
 fs/exec.c                                          |    1 +
 include/linux/processor.h                          |    6 +
 include/linux/sched.h                              |   89 ++
 include/linux/sched/mm.h                           |   39 +-
 include/trace/events/rseq.h                        |   60 +
 include/uapi/linux/cpu_opv.h                       |  117 ++
 include/uapi/linux/membarrier.h                    |   66 +-
 include/uapi/linux/rseq.h                          |  138 +++
 init/Kconfig                                       |   37 +
 kernel/Makefile                                    |    2 +
 kernel/cpu_opv.c                                   |  968 +++++++++++++++
 kernel/fork.c                                      |    2 +
 kernel/rseq.c                                      |  328 +++++
 kernel/sched/core.c                                |   95 +-
 kernel/sched/membarrier.c                          |  169 ++-
 kernel/sched/sched.h                               |    2 +
 kernel/sys_ni.c                                    |    4 +
 tools/testing/selftests/Makefile                   |    2 +
 tools/testing/selftests/cpu-opv/.gitignore         |    1 +
 tools/testing/selftests/cpu-opv/Makefile           |   17 +
 .../testing/selftests/cpu-opv/basic_cpu_opv_test.c | 1157 ++++++++++++++++++
 tools/testing/selftests/cpu-opv/cpu-op.c           |  348 ++++++
 tools/testing/selftests/cpu-opv/cpu-op.h           |   68 ++
 tools/testing/selftests/lib.mk                     |    4 +
 .../testing/selftests/membarrier/membarrier_test.c |  235 +++-
 tools/testing/selftests/rseq/.gitignore            |    4 +
 tools/testing/selftests/rseq/Makefile              |   23 +
 .../testing/selftests/rseq/basic_percpu_ops_test.c |  333 +++++
 tools/testing/selftests/rseq/basic_test.c          |   55 +
 tools/testing/selftests/rseq/param_test.c          | 1285 ++++++++++++++++++++
 tools/testing/selftests/rseq/rseq-arm.h            |  568 +++++++++
 tools/testing/selftests/rseq/rseq-ppc.h            |  567 +++++++++
 tools/testing/selftests/rseq/rseq-x86.h            |  898 ++++++++++++++
 tools/testing/selftests/rseq/rseq.c                |  116 ++
 tools/testing/selftests/rseq/rseq.h                |  154 +++
 tools/testing/selftests/rseq/run_param_test.sh     |  124 ++
 59 files changed, 8149 insertions(+), 63 deletions(-)
 create mode 100644 arch/powerpc/include/asm/membarrier.h
 create mode 100644 include/trace/events/rseq.h
 create mode 100644 include/uapi/linux/cpu_opv.h
 create mode 100644 include/uapi/linux/rseq.h
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
 create mode 100644 tools/testing/selftests/rseq/rseq-arm.h
 create mode 100644 tools/testing/selftests/rseq/rseq-ppc.h
 create mode 100644 tools/testing/selftests/rseq/rseq-x86.h
 create mode 100644 tools/testing/selftests/rseq/rseq.c
 create mode 100644 tools/testing/selftests/rseq/rseq.h
 create mode 100755 tools/testing/selftests/rseq/run_param_test.sh

-- 
2.11.0
