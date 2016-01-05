From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH 0/3] Implement getcpu_cache system call
Date: Tue,  5 Jan 2016 02:01:57 -0500
Message-ID: <1451977320-4886-1-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,

Here is a patchset implementing a cache for the CPU number of the
currently running thread in user-space.

Benchmarks comparing this approach to a system call-based getcpu on ARM
show a 44x speedup. They show a 14x speedup on x86-64 compared to
executing lsl from a vDSO through glibc.

I'm added a man page in the changelog of patch 1/3, which shows an
example usage of this new system call.

This patchset is sent as RFC. It applies on Linux 4.3.

Feedback is welcome,

Thanks!

Mathieu

Mathieu Desnoyers (3):
  getcpu_cache system call: cache CPU number of running thread
  getcpu_cache: wire up ARM system call
  getcpu_cache: wire up x86 32/64 system call

 arch/arm/include/uapi/asm/unistd.h     |   1 +
 arch/arm/kernel/calls.S                |   1 +
 arch/arm/kernel/signal.c               |   1 +
 arch/x86/entry/common.c                |   1 +
 arch/x86/entry/syscalls/syscall_32.tbl |   1 +
 arch/x86/entry/syscalls/syscall_64.tbl |   1 +
 fs/exec.c                              |   1 +
 include/linux/init_task.h              |   8 ++
 include/linux/sched.h                  |  43 +++++++++
 include/uapi/linux/Kbuild              |   1 +
 include/uapi/linux/getcpu_cache.h      |  44 +++++++++
 init/Kconfig                           |  10 ++
 kernel/Makefile                        |   1 +
 kernel/fork.c                          |   7 ++
 kernel/getcpu_cache.c                  | 170 +++++++++++++++++++++++++++++++++
 kernel/sched/core.c                    |   3 +
 kernel/sched/sched.h                   |   1 +
 kernel/sys_ni.c                        |   3 +
 18 files changed, 298 insertions(+)
 create mode 100644 include/uapi/linux/getcpu_cache.h
 create mode 100644 kernel/getcpu_cache.c

-- 
2.1.4
