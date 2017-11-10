From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH for 4.15 0/9] membarrier updates for 4.15
Date: Fri, 10 Nov 2017 16:37:07 -0500
Message-ID: <20171110213717.12457-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Maged Michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, David Sehr <sehr-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/fQFizaE/u3fw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Those are the membarrier changes I plan to submit for 4.15.

This series includes selftests improvements for sys_membarrier,
improvement of powerpc handling of the memory barrier required
by sys_membarrier in switch_mm(), and adds a new core serializing
membarrier, currently only implemented on x86. Architectures
wishing to provide the core serializing membarrier need to
select ARCH_HAS_MEMBARRIER_SYNC_CORE and document how they
provide the core serialization required by that command in their
architecture code.

I included the x86 core serializing migration fix into that series,
given that this fix and membarrier sync_core both depend on the
new sync_core_before_usermode() architecture function.

Feedback is welcome,

Thanks,

Mathieu

Mathieu Desnoyers (10):
  membarrier: selftest: Test private expedited cmd
  membarrier: powerpc: Skip memory barrier in switch_mm() (v7)
  membarrier: Document scheduler barrier requirements (v5)
  membarrier: Provide core serializing command
  x86: Introduce sync_core_before_usermode
  Fix: x86: Add missing core serializing instruction on migration
  membarrier: x86: Provide core serializing command (v2)
  membarrier: selftest: Test private expedited sync core cmd
  membarrier: provide SHARED_EXPEDITED command
  membarrier: selftest: Test shared expedited cmd

 MAINTAINERS                                        |   1 +
 arch/powerpc/Kconfig                               |   1 +
 arch/powerpc/include/asm/membarrier.h              |  26 +++
 arch/powerpc/mm/mmu_context.c                      |   7 +
 arch/x86/Kconfig                                   |   2 +
 arch/x86/entry/entry_32.S                          |   5 +
 arch/x86/entry/entry_64.S                          |   8 +
 arch/x86/include/asm/processor.h                   |  10 +
 arch/x86/mm/tlb.c                                  |   6 +
 include/linux/processor.h                          |   6 +
 include/linux/sched/mm.h                           |  38 +++-
 include/uapi/linux/membarrier.h                    |  66 +++++-
 init/Kconfig                                       |   6 +
 kernel/sched/core.c                                |  60 ++++--
 kernel/sched/membarrier.c                          | 169 +++++++++++++--
 kernel/sched/sched.h                               |   1 +
 .../testing/selftests/membarrier/membarrier_test.c | 233 +++++++++++++++++++--
 17 files changed, 584 insertions(+), 61 deletions(-)
 create mode 100644 arch/powerpc/include/asm/membarrier.h

-- 
2.11.0
