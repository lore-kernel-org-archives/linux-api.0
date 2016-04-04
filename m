From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH v6 0/5] Thread-local ABI system call (CPU number cache)
Date: Mon,  4 Apr 2016 13:01:48 -0400
Message-ID: <1459789313-4917-1-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
List-Id: linux-api@vger.kernel.org

Hi,

This patchset implements a general ABI to exchange per-thread data
between kernel and user-space. The initial feature implemented is a
cache for the CPU number of the currently running thread in user-space.
This ABI is extensible to add more features in the future.

Benchmarks comparing this approach to a getcpu based on system call on
ARM show a 44x speedup. They show a 16.5x speedup on x86-64 compared to
executing lsl from a vDSO through glibc.

There is a man page in the changelog of patch 1/5, which shows an
example usage of this new system call.

This patchset is sent as RFC. It applies on Linux 4.5. The prior
versions of this patchset were known as a "getcpu_cache system call".

Feedback is welcome,

Thanks!

Mathieu


Mathieu Desnoyers (5):
  Thread-local ABI system call: cache CPU number of running thread
  Thread-local ABI cpu_id: ARM resume notifier
  Thread-local ABI: wire up ARM system call
  Thread-local ABI cpu_id: x86 32/64 resume notifier
  Thread-local ABI: wire up x86 32/64 system call

 MAINTAINERS                            |   7 +++
 arch/arm/include/asm/unistd.h          |   2 +-
 arch/arm/include/uapi/asm/unistd.h     |   1 +
 arch/arm/kernel/calls.S                |   3 +-
 arch/arm/kernel/signal.c               |   1 +
 arch/x86/entry/common.c                |   1 +
 arch/x86/entry/syscalls/syscall_32.tbl |   1 +
 arch/x86/entry/syscalls/syscall_64.tbl |   1 +
 fs/exec.c                              |   1 +
 include/linux/sched.h                  |  66 +++++++++++++++++++++
 include/uapi/linux/Kbuild              |   1 +
 include/uapi/linux/thread_local_abi.h  |  83 ++++++++++++++++++++++++++
 init/Kconfig                           |  14 +++++
 kernel/Makefile                        |   1 +
 kernel/fork.c                          |   4 ++
 kernel/sched/sched.h                   |   1 +
 kernel/sys_ni.c                        |   3 +
 kernel/thread_local_abi.c              | 103 +++++++++++++++++++++++++++++++++
 18 files changed, 292 insertions(+), 2 deletions(-)
 create mode 100644 include/uapi/linux/thread_local_abi.h
 create mode 100644 kernel/thread_local_abi.c

-- 
2.1.4
