From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH for 4.15 00/14] Restartable sequences and CPU op vector v10
Date: Mon,  6 Nov 2017 15:56:30 -0500
Message-ID: <20171106205644.29386-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Here is an updated rseq patchset taking into account the feedback
received at kernel summit and afterwards.

Use-cases explanation and benchmarks can be found in patch 01
"Restartable sequences system call".

This is still submitted as RFC. I'm keeping a linux-rseq
tree with this patchset at:

https://git.kernel.org/pub/scm/linux/kernel/git/rseq/linux-rseq.git/tag/?h=v4.14-rc8-rseq-20171106.1

If everyone is happy with it, I plan to submit this officially
when the merge window opens.

Thanks,

Mathieu

Boqun Feng (2):
  Restartable sequences: powerpc architecture support
  Restartable sequences: Wire up powerpc system call

Mathieu Desnoyers (12):
  Restartable sequences system call (v10)
  Restartable sequences: ARM 32 architecture support
  Restartable sequences: wire up ARM 32 system call
  Restartable sequences: x86 32/64 architecture support
  Restartable sequences: wire up x86 32/64 system call
  Provide cpu_opv system call (v2)
  cpu_opv: Wire up x86 32/64 system call
  cpu_opv: Wire up powerpc system call
  cpu_opv: Wire up ARM32 system call
  cpu_opv: Implement selftests (v2)
  Restartable sequences: Provide self-tests (v2)
  Restartable sequences selftests: arm: workaround gcc asm size guess

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
 include/linux/sched.h                              |   89 ++
 include/trace/events/rseq.h                        |   60 +
 include/uapi/linux/cpu_opv.h                       |  117 ++
 include/uapi/linux/rseq.h                          |  138 +++
 init/Kconfig                                       |   28 +
 kernel/Makefile                                    |    2 +
 kernel/cpu_opv.c                                   |  952 +++++++++++++++
 kernel/fork.c                                      |    2 +
 kernel/rseq.c                                      |  329 +++++
 kernel/sched/core.c                                |   41 +
 kernel/sched/sched.h                               |    2 +
 kernel/sys_ni.c                                    |    4 +
 tools/testing/selftests/Makefile                   |    2 +
 tools/testing/selftests/cpu-opv/.gitignore         |    1 +
 tools/testing/selftests/cpu-opv/Makefile           |   15 +
 .../testing/selftests/cpu-opv/basic_cpu_opv_test.c | 1157 ++++++++++++++++++
 tools/testing/selftests/cpu-opv/cpu-op.c           |  348 ++++++
 tools/testing/selftests/cpu-opv/cpu-op.h           |   68 ++
 tools/testing/selftests/rseq/.gitignore            |    4 +
 tools/testing/selftests/rseq/Makefile              |   22 +
 .../testing/selftests/rseq/basic_percpu_ops_test.c |  333 +++++
 tools/testing/selftests/rseq/basic_test.c          |   55 +
 tools/testing/selftests/rseq/param_test.c          | 1285 ++++++++++++++++++++
 tools/testing/selftests/rseq/rseq-arm.h            |  568 +++++++++
 tools/testing/selftests/rseq/rseq-ppc.h            |  567 +++++++++
 tools/testing/selftests/rseq/rseq-x86.h            |  898 ++++++++++++++
 tools/testing/selftests/rseq/rseq.c                |  116 ++
 tools/testing/selftests/rseq/rseq.h                |  154 +++
 tools/testing/selftests/rseq/run_param_test.sh     |  124 ++
 45 files changed, 7540 insertions(+), 1 deletion(-)
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
