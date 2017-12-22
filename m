From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH for 4.16 00/11] membarrier updates for 4.16
Date: Fri, 22 Dec 2017 15:15:25 -0500
Message-ID: <20171222201536.29809-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Maged Michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Sehr <sehr-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,

I decided to split the membarrier updates from the rseq patchset, and
send it separately so each discussion can happen in different threads.

This series includes a fix for membarrier private expedited, which
should be merged into 4.15-rc and backported to 4.14. The fix has
also been sent separately.

Testing and documentation of membarrier is improved. A new shared
expedited membarrier command is added, allowing use of membarrier
expedited over shared memory mappings.

The series also introduces a "core serializing" private expedited
membarrier for JIT memory reclaim (currently on x86 and arm64).

Feedback is welcome!

Thanks,

Mathieu

Mathieu Desnoyers (11):
  Fix: membarrier: add missing preempt off around smp_call_function_many
  membarrier: selftest: Test private expedited cmd (v2)
  powerpc: membarrier: Skip memory barrier in switch_mm() (v7)
  membarrier: Document scheduler barrier requirements (v5)
  membarrier: provide SHARED_EXPEDITED command (v2)
  membarrier: selftest: Test shared expedited cmd
  membarrier: Provide core serializing command
  x86: Introduce sync_core_before_usermode (v2)
  membarrier: x86: Provide core serializing command (v3)
  membarrier: arm64: Provide core serializing command
  membarrier: selftest: Test private expedited sync core cmd

 MAINTAINERS                                        |   1 +
 arch/arm64/Kconfig                                 |   1 +
 arch/arm64/kernel/entry.S                          |   4 +
 arch/powerpc/Kconfig                               |   1 +
 arch/powerpc/include/asm/membarrier.h              |  27 +++
 arch/powerpc/mm/mmu_context.c                      |   7 +
 arch/x86/Kconfig                                   |   2 +
 arch/x86/entry/entry_32.S                          |   5 +
 arch/x86/entry/entry_64.S                          |   4 +
 arch/x86/include/asm/processor.h                   |  10 +
 arch/x86/mm/tlb.c                                  |   6 +
 include/linux/processor.h                          |   6 +
 include/linux/sched/mm.h                           |  40 +++-
 include/uapi/linux/membarrier.h                    |  66 +++++-
 init/Kconfig                                       |   9 +
 kernel/sched/core.c                                |  53 +++--
 kernel/sched/membarrier.c                          | 173 +++++++++++++--
 .../testing/selftests/membarrier/membarrier_test.c | 235 +++++++++++++++++++--
 18 files changed, 587 insertions(+), 63 deletions(-)
 create mode 100644 arch/powerpc/include/asm/membarrier.h

-- 
2.11.0
