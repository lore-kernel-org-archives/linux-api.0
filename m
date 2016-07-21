From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH v7 0/7] Restartable sequences system call
Date: Thu, 21 Jul 2016 17:14:15 -0400
Message-ID: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,

This is mostly a re-write of Paul Turner and Andrew Hunter's restartable
critical sections (percpu atomics), which brings the following main
benefits over Paul Turner's prior version (v2):

- The ABI is now architecture-agnostic, and it requires fewer
  instruction on the user-space fast path,
- Ported to ARM 32, in addition to cover x86 32/64. Adding support
  for new architectures is now trivial,
- Progress is ensured by a fall-back to locking (purely userspace)
  when single-stepped by a debugger.

This is v7, as it derives from my prior getcpu cache and thread local
ABI patchsets. You will find benchmark results in the changelog of
patch 1/7.

Feedback is welcome!

Thanks,

Mathieu


Mathieu Desnoyers (7):
  Restartable sequences system call
  tracing: instrument restartable sequences
  Restartable sequences: ARM 32 architecture support
  Restartable sequences: wire up ARM 32 system call
  Restartable sequences: x86 32/64 architecture support
  Restartable sequences: wire up x86 32/64 system call
  Restartable sequences: self-tests

 MAINTAINERS                                        |   7 +
 arch/Kconfig                                       |   7 +
 arch/arm/Kconfig                                   |   1 +
 arch/arm/include/uapi/asm/unistd.h                 |   1 +
 arch/arm/kernel/calls.S                            |   1 +
 arch/arm/kernel/signal.c                           |   7 +
 arch/x86/Kconfig                                   |   1 +
 arch/x86/entry/common.c                            |   1 +
 arch/x86/entry/syscalls/syscall_32.tbl             |   1 +
 arch/x86/entry/syscalls/syscall_64.tbl             |   1 +
 arch/x86/kernel/signal.c                           |   6 +
 fs/exec.c                                          |   1 +
 include/linux/sched.h                              |  68 ++
 include/trace/events/rseq.h                        |  60 ++
 include/uapi/linux/Kbuild                          |   1 +
 include/uapi/linux/rseq.h                          |  85 +++
 init/Kconfig                                       |  13 +
 kernel/Makefile                                    |   1 +
 kernel/fork.c                                      |   2 +
 kernel/rseq.c                                      | 243 +++++++
 kernel/sched/core.c                                |   1 +
 kernel/sys_ni.c                                    |   3 +
 tools/testing/selftests/rseq/.gitignore            |   3 +
 tools/testing/selftests/rseq/Makefile              |  13 +
 .../testing/selftests/rseq/basic_percpu_ops_test.c | 279 ++++++++
 tools/testing/selftests/rseq/basic_test.c          | 106 +++
 tools/testing/selftests/rseq/param_test.c          | 707 +++++++++++++++++++++
 tools/testing/selftests/rseq/rseq.c                | 200 ++++++
 tools/testing/selftests/rseq/rseq.h                | 449 +++++++++++++
 29 files changed, 2269 insertions(+)
 create mode 100644 include/trace/events/rseq.h
 create mode 100644 include/uapi/linux/rseq.h
 create mode 100644 kernel/rseq.c
 create mode 100644 tools/testing/selftests/rseq/.gitignore
 create mode 100644 tools/testing/selftests/rseq/Makefile
 create mode 100644 tools/testing/selftests/rseq/basic_percpu_ops_test.c
 create mode 100644 tools/testing/selftests/rseq/basic_test.c
 create mode 100644 tools/testing/selftests/rseq/param_test.c
 create mode 100644 tools/testing/selftests/rseq/rseq.c
 create mode 100644 tools/testing/selftests/rseq/rseq.h

-- 
2.1.4
