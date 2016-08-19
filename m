From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH v8 0/9] Restartable sequences system call
Date: Fri, 19 Aug 2016 16:07:45 -0400
Message-ID: <1471637274-13583-1-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,

Here is v8 of the restartable sequences system call patchset, after
taking care of feedback received from Peter Zijlstra, Andy Lutomirski,
Boqun Feng, and Dave Watson. Added PowerPC architecture support provided
by Boqun Feng. It is based on Linux kernel v4.8-rc2.

The small library provided in kernel selftests now allows to perform
either a single final commit (do_rseq()), a speculative store before the
final commit (do_rseq2()), or a speculative memcpy before the final
commit (do_rseq_memcpy()).

Feedback is welcome!

Thanks,

Mathieu

Boqun Feng (2):
  Restartable sequences: powerpc architecture support
  Restartable sequences: Wire up powerpc system call

Mathieu Desnoyers (7):
  Restartable sequences system call
  tracing: instrument restartable sequences
  Restartable sequences: ARM 32 architecture support
  Restartable sequences: wire up ARM 32 system call
  Restartable sequences: x86 32/64 architecture support
  Restartable sequences: wire up x86 32/64 system call
  Restartable sequences: self-tests

 MAINTAINERS                                        |   11 +
 arch/Kconfig                                       |    7 +
 arch/arm/Kconfig                                   |    1 +
 arch/arm/include/uapi/asm/unistd.h                 |    1 +
 arch/arm/kernel/calls.S                            |    1 +
 arch/arm/kernel/signal.c                           |    7 +
 arch/powerpc/Kconfig                               |    1 +
 arch/powerpc/include/asm/systbl.h                  |    1 +
 arch/powerpc/include/asm/unistd.h                  |    2 +-
 arch/powerpc/include/uapi/asm/unistd.h             |    1 +
 arch/powerpc/kernel/signal.c                       |    3 +
 arch/x86/Kconfig                                   |    1 +
 arch/x86/entry/common.c                            |    1 +
 arch/x86/entry/syscalls/syscall_32.tbl             |    1 +
 arch/x86/entry/syscalls/syscall_64.tbl             |    1 +
 arch/x86/kernel/signal.c                           |    6 +
 fs/exec.c                                          |    1 +
 include/linux/sched.h                              |   72 ++
 include/trace/events/rseq.h                        |   64 ++
 include/uapi/linux/Kbuild                          |    1 +
 include/uapi/linux/rseq.h                          |  106 ++
 init/Kconfig                                       |   13 +
 kernel/Makefile                                    |    1 +
 kernel/fork.c                                      |    2 +
 kernel/rseq.c                                      |  296 ++++++
 kernel/sched/core.c                                |    1 +
 kernel/sys_ni.c                                    |    3 +
 tools/testing/selftests/rseq/.gitignore            |    3 +
 tools/testing/selftests/rseq/Makefile              |   13 +
 .../testing/selftests/rseq/basic_percpu_ops_test.c |  286 +++++
 tools/testing/selftests/rseq/basic_test.c          |  107 ++
 tools/testing/selftests/rseq/param_test.c          | 1116 ++++++++++++++++++++
 tools/testing/selftests/rseq/rseq-arm.h            |  168 +++
 tools/testing/selftests/rseq/rseq-ppc.h            |  273 +++++
 tools/testing/selftests/rseq/rseq-x86.h            |  306 ++++++
 tools/testing/selftests/rseq/rseq.c                |  231 ++++
 tools/testing/selftests/rseq/rseq.h                |  454 ++++++++
 37 files changed, 3562 insertions(+), 1 deletion(-)
 create mode 100644 include/trace/events/rseq.h
 create mode 100644 include/uapi/linux/rseq.h
 create mode 100644 kernel/rseq.c
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

-- 
2.1.4
