From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH v4 0/5] getcpu_cache system call for 4.6
Date: Tue, 23 Feb 2016 18:28:35 -0500
Message-ID: <1456270120-7560-1-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
List-Id: linux-api@vger.kernel.org

Hi,

Here is a patchset implementing a cache for the CPU number of the
currently running thread in user-space.

Benchmarks comparing this approach to a getcpu based on system call on
ARM show a 44x speedup. They show a 14x speedup on x86-64 compared to
executing lsl from a vDSO through glibc.

I'm added a man page in the changelog of patch 1/3, which shows an
example usage of this new system call.

This series is based on v4.5-rc5, submitted for Linux 4.6.

Feedback is welcome,

Thanks!

Mathieu


Mathieu Desnoyers (5):
  getcpu_cache system call: cache CPU number of running thread
  getcpu_cache: ARM resume notifier
  getcpu_cache: wire up ARM system call
  getcpu_cache: x86 32/64 resume notifier
  getcpu_cache: wire up x86 32/64 system call

 MAINTAINERS                            |   7 ++
 arch/arm/include/uapi/asm/unistd.h     |   1 +
 arch/arm/kernel/calls.S                |   3 +-
 arch/arm/kernel/signal.c               |   1 +
 arch/x86/entry/common.c                |   1 +
 arch/x86/entry/syscalls/syscall_32.tbl |   1 +
 arch/x86/entry/syscalls/syscall_64.tbl |   1 +
 fs/exec.c                              |   1 +
 include/linux/sched.h                  |  36 ++++++++
 include/uapi/linux/Kbuild              |   1 +
 include/uapi/linux/getcpu_cache.h      |  42 +++++++++
 init/Kconfig                           |  10 ++
 kernel/Makefile                        |   1 +
 kernel/fork.c                          |   4 +
 kernel/getcpu_cache.c                  | 163 +++++++++++++++++++++++++++++++++
 kernel/sched/sched.h                   |   1 +
 kernel/sys_ni.c                        |   3 +
 17 files changed, 276 insertions(+), 1 deletion(-)
 create mode 100644 include/uapi/linux/getcpu_cache.h
 create mode 100644 kernel/getcpu_cache.c

-- 
2.1.4
