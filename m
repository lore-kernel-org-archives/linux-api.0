From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for 4.16 00/10] membarrier updates for 4.16
Date: Mon, 15 Jan 2018 14:10:54 -0500
Message-ID: <20180115191104.12437-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Maged Michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, David Sehr <sehr-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, x86@kernel.
List-Id: linux-api@vger.kernel.org

Hi Ingo, Hi Peter,

Here are the membarrier patch series I would like to submit for the
4.16 merge window. It would be appreciated of those can go through the
scheduler tree.

It's the same series as last week, rebased on top of 4.15-rc8.

Highlights:

"powerpc: membarrier: Skip memory barrier in switch_mm()" takes care of
a TODO that was left in the private expedited implementation when merged
in 4.14: an extra memory barrier was added on context switch on powerpc.
Ensure that the barrier is only performed when scheduling between
different processes, only for threads belonging to processes that have
registered their intent to use the private expedited command.

"membarrier: provide SHARED_EXPEDITED command" adds new commands to
membarrier for registration and use of membarrier across shared
memory mappings. The non-expedited command has proven to be really
too slow (taking 10ms and more to complete) for real-world use. The
expedited version completes in a matter of microseconds.

"membarrier: Provide core serializing command" provides core
serialization for JIT reclaim. We received positive feedback from
Android developers that the proposed ABI fits their use-case.
Only x86 32/64 and arm 64 implement this command so far. This is
opt-in per architecture.

The other patches add selftests and documentation.

Thanks,

Mathieu

Mathieu Desnoyers (10):
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
 kernel/sched/membarrier.c                          | 171 +++++++++++++--
 .../testing/selftests/membarrier/membarrier_test.c | 235 +++++++++++++++++++--
 18 files changed, 585 insertions(+), 63 deletions(-)
 create mode 100644 arch/powerpc/include/asm/membarrier.h

-- 
2.11.0
