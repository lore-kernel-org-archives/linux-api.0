From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.18 00/23] Restartable sequences and CPU op vector
Date: Thu, 12 Apr 2018 15:27:37 -0400
Message-ID: <20180412192800.15708-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
List-Id: linux-api@vger.kernel.org

Hi,

I'm respinning this series for another RFC round. It is based on the
v4.16 tag. Given that it is now very late in the 4.17 merge window, and
considering that some code changes were needed to address the last round
of feedback, I think it is safer to target the 4.18 merge window.

This series contains:

- Restartable sequences system call (x86 32/64, powerpc 32/64, arm 32),
- CPU operation vector system call (x86 32/64, powerpc 32/64, arm 32).

The main changes introduced in this updated version are:

- Return -1, errno=EFAULT if userspace pointers received as cpu_opv
  operation parameters target noncached memory. A new is_vma_noncached()
  is introduced in linux/mm.h to that effect.
- Introduce vm_map_user_ram, vm_unmap_user_ram, which allows creating
  mappings aliased to a user-space mapping with the same cache coloring
  as the userspace mapping. Allow the kernel to load from and store to
  pages shared with user-space through its own mapping in kernel virtual
  addresses while ensuring cache conherency between kernel and userspace
  mappings for virtually aliased architectures.
- Use vm_{map,unmap}_user_ram in cpu_opv.

Feedback is welcome!

Thanks,

Mathieu

Boqun Feng (2):
  powerpc: Add support for restartable sequences
  powerpc: Wire up restartable sequences system call

Mathieu Desnoyers (21):
  uapi headers: Provide types_32_64.h (v2)
  rseq: Introduce restartable sequences system call (v13)
  arm: Add restartable sequences support
  arm: Wire up restartable sequences system call
  x86: Add support for restartable sequences (v2)
  x86: Wire up restartable sequence system call
  sched: Implement push_task_to_cpu (v2)
  mm: Introduce vm_map_user_ram, vm_unmap_user_ram
  mm: Provide is_vma_noncached
  cpu_opv: Provide cpu_opv system call (v7)
  x86: Wire up cpu_opv system call
  powerpc: Wire up cpu_opv system call
  arm: Wire up cpu_opv system call
  selftests: lib.mk: Introduce OVERRIDE_TARGETS
  cpu_opv: selftests: Implement selftests (v7)
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
 arch/x86/entry/common.c                            |    3 +
 arch/x86/entry/syscalls/syscall_32.tbl             |    2 +
 arch/x86/entry/syscalls/syscall_64.tbl             |    2 +
 arch/x86/kernel/signal.c                           |    6 +
 fs/exec.c                                          |    1 +
 include/linux/mm.h                                 |   24 +
 include/linux/sched.h                              |  134 ++
 include/linux/syscalls.h                           |    6 +
 include/linux/vmalloc.h                            |    4 +
 include/trace/events/rseq.h                        |   56 +
 include/uapi/linux/cpu_opv.h                       |  120 ++
 include/uapi/linux/rseq.h                          |  150 +++
 include/uapi/linux/types_32_64.h                   |   67 +
 init/Kconfig                                       |   40 +
 kernel/Makefile                                    |    2 +
 kernel/cpu_opv.c                                   | 1107 ++++++++++++++++
 kernel/fork.c                                      |    2 +
 kernel/rseq.c                                      |  366 ++++++
 kernel/sched/core.c                                |   44 +
 kernel/sched/sched.h                               |    9 +
 kernel/sys_ni.c                                    |    4 +
 mm/vmalloc.c                                       |   66 +
 tools/testing/selftests/Makefile                   |    2 +
 tools/testing/selftests/cpu-opv/.gitignore         |    1 +
 tools/testing/selftests/cpu-opv/Makefile           |   17 +
 .../testing/selftests/cpu-opv/basic_cpu_opv_test.c | 1368 ++++++++++++++++++++
 tools/testing/selftests/cpu-opv/cpu-op.c           |  352 +++++
 tools/testing/selftests/cpu-opv/cpu-op.h           |   59 +
 tools/testing/selftests/lib.mk                     |    4 +
 tools/testing/selftests/rseq/.gitignore            |    7 +
 tools/testing/selftests/rseq/Makefile              |   37 +
 .../testing/selftests/rseq/basic_percpu_ops_test.c |  296 +++++
 tools/testing/selftests/rseq/basic_test.c          |   55 +
 tools/testing/selftests/rseq/param_test.c          | 1167 +++++++++++++++++
 tools/testing/selftests/rseq/percpu-op.h           |  163 +++
 tools/testing/selftests/rseq/rseq-arm.h            |  732 +++++++++++
 tools/testing/selftests/rseq/rseq-ppc.h            |  688 ++++++++++
 tools/testing/selftests/rseq/rseq-skip.h           |   82 ++
 tools/testing/selftests/rseq/rseq-x86.h            | 1149 ++++++++++++++++
 tools/testing/selftests/rseq/rseq.c                |  116 ++
 tools/testing/selftests/rseq/rseq.h                |  164 +++
 tools/testing/selftests/rseq/run_param_test.sh     |  131 ++
 53 files changed, 8852 insertions(+), 1 deletion(-)
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
