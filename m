From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.21 00/16] rseq updates, new cpu_opv system call
Date: Wed, 10 Oct 2018 15:19:20 -0400
Message-ID: <20181010191936.7495-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Joel Fernandes <joelaf@google.com>, Mathieu Desnoyers <mathieu.desnoyers@ef>
List-Id: linux-api@vger.kernel.org

Hi,

Considering it's already late in the 4.19 rc cycle, I'm submitting this
patchset as RFC for 4.21 to give everyone plenty of time to provide
feedback.

This series contain:

- rseq selftests (this could be 4.20 material):
  - Added reference counter within user-space __rseq_abi structure, for
    integration of rseq application/libraries with future use by glibc,
  - Adapt number of threads to the number of online cpus.

- cpu_opv (4.21 material):
  - Implement push_task_to_cpu() (scheduler),
  - Introduce vm_map_user_ram()/vm_unmap_user_ram() (mm),
  - Provide is_vma_noncached() (mm),
  - Introduce cpu_opv system call, with vmap space limiting,
    - Wire up cpu_opv on x86, powerpc, arm,
  - Provide cpu_opv selftests.

The cpu_opv system call covers the use-cases that rseq does not handle,
namely single-stepping with debuggers, moving data between per-cpu data
structures without interfering with cpu affinity masks, and using rseq
from signal handlers nested between thread creation and rseq
registration by glibc, or between rseq unregistration by glibc and
thread teardown.

Thanks,

Mathieu

Mathieu Desnoyers (16):
  rseq/selftests: Add reference counter to coexist with glibc
  rseq/selftests: Adapt number of threads to the number of detected cpus
  sched: Implement push_task_to_cpu (v2)
  mm: Introduce vm_map_user_ram, vm_unmap_user_ram
  mm: Provide is_vma_noncached
  cpu_opv: Provide cpu_opv system call (v8)
  cpu_opv: limit amount of virtual address space used by cpu_opv
  x86: Wire up cpu_opv system call
  powerpc: Wire up cpu_opv system call
  arm: Wire up cpu_opv system call
  cpu-opv/selftests: Provide cpu-op library
  cpu-opv/selftests: Provide basic test
  cpu-opv/selftests: Provide percpu_op API
  cpu-opv/selftests: Provide basic percpu ops test
  cpu-opv/selftests: Provide parametrized tests
  cpu-opv/selftests: Provide Makefile, scripts, gitignore

 MAINTAINERS                                        |    8 +
 arch/arm/tools/syscall.tbl                         |    1 +
 arch/powerpc/include/asm/systbl.h                  |    1 +
 arch/powerpc/include/uapi/asm/unistd.h             |    1 +
 arch/x86/entry/syscalls/syscall_32.tbl             |    1 +
 arch/x86/entry/syscalls/syscall_64.tbl             |    1 +
 include/linux/mm.h                                 |   24 +
 include/linux/syscalls.h                           |    3 +
 include/linux/vmalloc.h                            |    4 +
 include/uapi/linux/cpu_opv.h                       |  114 ++
 init/Kconfig                                       |   17 +
 kernel/Makefile                                    |    1 +
 kernel/cpu_opv.c                                   | 1190 ++++++++++++++=
+++
 kernel/sched/core.c                                |   42 +
 kernel/sched/sched.h                               |    9 +
 kernel/sys_ni.c                                    |    1 +
 kernel/sysctl.c                                    |   15 +
 mm/vmalloc.c                                       |   64 +
 tools/testing/selftests/Makefile                   |    1 +
 tools/testing/selftests/cpu-opv/.gitignore         |    6 +
 tools/testing/selftests/cpu-opv/Makefile           |   39 +
 .../testing/selftests/cpu-opv/basic_cpu_opv_test.c | 1362 ++++++++++++++=
++++++
 .../selftests/cpu-opv/basic_percpu_ops_test.c      |  295 +++++
 tools/testing/selftests/cpu-opv/cpu-op.c           |  353 +++++
 tools/testing/selftests/cpu-opv/cpu-op.h           |   42 +
 tools/testing/selftests/cpu-opv/param_test.c       | 1187 ++++++++++++++=
+++
 tools/testing/selftests/cpu-opv/percpu-op.h        |  151 +++
 tools/testing/selftests/cpu-opv/run_param_test.sh  |  134 ++
 tools/testing/selftests/rseq/rseq.c                |   32 +-
 tools/testing/selftests/rseq/run_param_test.sh     |    7 +-
 30 files changed, 5096 insertions(+), 10 deletions(-)
 create mode 100644 include/uapi/linux/cpu_opv.h
 create mode 100644 kernel/cpu_opv.c
 create mode 100644 tools/testing/selftests/cpu-opv/.gitignore
 create mode 100644 tools/testing/selftests/cpu-opv/Makefile
 create mode 100644 tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c
 create mode 100644 tools/testing/selftests/cpu-opv/basic_percpu_ops_test=
.c
 create mode 100644 tools/testing/selftests/cpu-opv/cpu-op.c
 create mode 100644 tools/testing/selftests/cpu-opv/cpu-op.h
 create mode 100644 tools/testing/selftests/cpu-opv/param_test.c
 create mode 100644 tools/testing/selftests/cpu-opv/percpu-op.h
 create mode 100755 tools/testing/selftests/cpu-opv/run_param_test.sh

--=20
2.11.0
