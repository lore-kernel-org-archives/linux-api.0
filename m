From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for 4.16 00/11] membarrier updates for 4.16
Date: Tue, 23 Jan 2018 10:57:22 -0500
Message-ID: <20180123155733.3404-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Maged Michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, David Sehr <sehr-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Mathieu Desnoyers <mathieu.desnoy>
List-Id: linux-api@vger.kernel.org

Hi Ingo, Peter, Thomas,

Here is the updated membarrier patch series following review from
Andy. 

It would be appreciated of those can go through the scheduler tree for
the 4.16 merge window.

Patch "x86: Implement sync_core_before_usermode" got a reviewed-by from
Thomas, but I removed the tag following KPTI-related optimizations based
on the discussion with Andy afterwards.

Highlights:

"powerpc: membarrier: Skip memory barrier in switch_mm()" takes care of
a TODO that was left in the private expedited implementation when merged
in 4.14: an extra memory barrier was added on context switch on powerpc.
Ensure that the barrier is only performed when scheduling between
different processes, only for threads belonging to processes that have
registered their intent to use the private expedited command.

"membarrier: provide GLOBAL_EXPEDITED command" adds new commands to
membarrier for registration and use of membarrier across processes
communicating through shared memory mappings. The non-expedited command
has proven to be really too slow (taking 10ms and more to complete) for
real-world use. The expedited version completes in a matter of
microseconds. This patch renames the pre-existing MEMBARRIER_CMD_SHARED
to MEMBARRIER_CMD_GLOBAL for consistency, keeping the old enum label
as an alias for backward compatibility.

"membarrier: Provide core serializing command" provides core
serialization for JIT reclaim. We received positive feedback from
Android developers that the proposed ABI fits their use-case.
Only x86 32/64 and arm 64 implement this command so far. This is
opt-in per architecture.

The other patches add selftests and documentation.

Thanks,

Mathieu

Mathieu Desnoyers (11):
  membarrier: selftest: Test private expedited cmd (v2)
  powerpc: membarrier: Skip memory barrier in switch_mm() (v7)
  membarrier: Document scheduler barrier requirements (v5)
  membarrier: provide GLOBAL_EXPEDITED command (v3)
  membarrier: selftest: Test global expedited cmd (v2)
  Introduce sync_core_before_usermode (v2)
  x86: Implement sync_core_before_usermode (v3)
  membarrier: Provide core serializing command (v2)
  membarrier: x86: Provide core serializing command (v4)
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
 arch/x86/include/asm/sync_core.h                   |  28 +++
 arch/x86/mm/tlb.c                                  |   6 +
 include/linux/sched/mm.h                           |  40 +++-
 include/linux/sync_core.h                          |  21 ++
 include/uapi/linux/membarrier.h                    |  74 ++++++-
 init/Kconfig                                       |   9 +
 kernel/sched/core.c                                |  53 +++--
 kernel/sched/membarrier.c                          | 177 +++++++++++++--
 .../testing/selftests/membarrier/membarrier_test.c | 237 +++++++++++++++++++--
 18 files changed, 629 insertions(+), 68 deletions(-)
 create mode 100644 arch/powerpc/include/asm/membarrier.h
 create mode 100644 arch/x86/include/asm/sync_core.h
 create mode 100644 include/linux/sync_core.h

-- 
2.11.0
