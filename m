From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH for 4.15 0/6] membarrier updates for 4.15
Date: Wed,  8 Nov 2017 13:35:08 -0500
Message-ID: <20171108183514.3306-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Maged Michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, gromer-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Here are the membarrier changes I plan on sending for the
4.15 merge window.

This series includes selftests improvements for sys_membarrier,
improvement of powerpc handling of the memory barrier required
by sys_membarrier in switch_mm(), and adds a new core serializing
membarrier, currently only implemented on x86. Architectures
wishing to provide the core serializing membarrier need to
select ARCH_HAS_MEMBARRIER_SYNC_CORE and document how they
provide the core serialization required by that command in their
architecture code.

Andy, I know you told me you had changes coming up in x86 entry.S
for 4.15, but I figure that managing the merge conflict between your
changes in 4.15 and those added comments should be straightforward.
Anyway, I kind of suspect that at any given point in time you will
always have changes of some sort to propose to entry.S, so now seems
to be a time as appropriate as ever to push the core serializing
membarrier comments.

Feedback is welcome!

Thanks,

Mathieu

Mathieu Desnoyers (6):
  membarrier: selftest: Test private expedited cmd
  membarrier: powerpc: Skip memory barrier in switch_mm() (v6)
  membarrier: Document scheduler barrier requirements (v5)
  membarrier: Provide core serializing command
  membarrier: x86: Provide core serializing command
  membarrier: selftest: Test private expedited sync core cmd

 MAINTAINERS                                        |   2 +
 arch/powerpc/Kconfig                               |   1 +
 arch/powerpc/include/asm/membarrier.h              |  32 ++++
 arch/powerpc/kernel/Makefile                       |   2 +
 arch/powerpc/kernel/membarrier.c                   |  37 ++++
 arch/powerpc/mm/mmu_context.c                      |   7 +
 arch/x86/Kconfig                                   |   2 +
 arch/x86/entry/entry_32.S                          |   5 +
 arch/x86/entry/entry_64.S                          |   8 +
 arch/x86/include/asm/membarrier.h                  |  36 ++++
 arch/x86/kernel/Makefile                           |   1 +
 arch/x86/kernel/membarrier.c                       |  39 +++++
 arch/x86/mm/tlb.c                                  |   6 +
 include/linux/sched/mm.h                           |  36 +++-
 include/uapi/linux/membarrier.h                    |  14 +-
 init/Kconfig                                       |   6 +
 kernel/sched/core.c                                |  53 +++---
 kernel/sched/membarrier.c                          |  55 ++++--
 .../testing/selftests/membarrier/membarrier_test.c | 186 +++++++++++++++++++--
 19 files changed, 470 insertions(+), 58 deletions(-)
 create mode 100644 arch/powerpc/include/asm/membarrier.h
 create mode 100644 arch/powerpc/kernel/membarrier.c
 create mode 100644 arch/x86/include/asm/membarrier.h
 create mode 100644 arch/x86/kernel/membarrier.c

-- 
2.11.0
