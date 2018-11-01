From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.21 00/16] rseq updates, new cpu_opv system call (v2)
Date: Thu,  1 Nov 2018 10:58:28 +0100
Message-ID: <20181101095844.24462-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Joel Fernandes <joelaf@google.com>, Mathieu Desnoyers <mathieu.desnoyers@ef>
List-Id: linux-api@vger.kernel.org

Hi,

Here is an updated patchset submitted as RFC for 4.21 (next merge
window).

This series contain:

- rseq selftests:
  - Added reference counter within user-space __rseq_abi structure, for
    integration of rseq application/libraries with future use by glibc,
  - Adapt number of threads to the number of online cpus.

- cpu_opv:
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

The cpu_opv system call has been greatly simplified since the last round
based on feedback from Peter Zijlstra and Will Deacon at OSS Europe.
Major simplifications are:

- Remove unnecessary operations. Only keep compare, memcpy,
  memcpy_release, add, add_release,
- Remove the "mb" instruction in favor of a release semantic,
- Use IPI to execute operations on remote CPUs rather than try to
  migrate the current thread,
- Reduce the maximum operation vector size from 16 to 4 elements,
  thus removing the need to perform memory allocation in the cpu_opv
  system call (there is enough space on the stack). Add a new flag
  allowing user-space to query the maximum vector size supported by
  the kernel for future extensibility.

Feedback is welcome!

Thanks,

Mathieu

Mathieu Desnoyers (16):
  rseq/selftests: Expose reference counter to coexist with glibc (v2)
  rseq/selftests: Adapt number of threads to the number of detected cpus
  mm: Replace BUG_ON() by WARN_ON() in vm_unmap_ram()
  mm: Introduce vm_map_user_ram, vm_unmap_user_ram (v2)
  mm: Provide is_vma_noncached
  cpu_opv: Provide cpu_opv system call (v9)
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
 include/uapi/linux/cpu_opv.h                       |   69 ++
 init/Kconfig                                       |   17 +
 kernel/Makefile                                    |    1 +
 kernel/cpu_opv.c                                   | 1027 ++++++++++++++=
+++
 kernel/sys_ni.c                                    |    1 +
 kernel/sysctl.c                                    |   15 +
 mm/vmalloc.c                                       |   78 +-
 tools/testing/selftests/Makefile                   |    1 +
 tools/testing/selftests/cpu-opv/.gitignore         |    6 +
 tools/testing/selftests/cpu-opv/Makefile           |   39 +
 .../testing/selftests/cpu-opv/basic_cpu_opv_test.c | 1207 ++++++++++++++=
++++++
 .../selftests/cpu-opv/basic_percpu_ops_test.c      |  295 +++++
 tools/testing/selftests/cpu-opv/cpu-op.c           |  362 ++++++
 tools/testing/selftests/cpu-opv/cpu-op.h           |   43 +
 tools/testing/selftests/cpu-opv/param_test.c       | 1187 ++++++++++++++=
+++++
 tools/testing/selftests/cpu-opv/percpu-op.h        |  151 +++
 tools/testing/selftests/cpu-opv/run_param_test.sh  |  134 +++
 tools/testing/selftests/rseq/rseq.c                |   23 +-
 tools/testing/selftests/rseq/rseq.h                |    1 +
 tools/testing/selftests/rseq/run_param_test.sh     |    7 +-
 29 files changed, 4694 insertions(+), 14 deletions(-)
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
