From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH for 4.16 00/11] membarrier updates for 4.16
Date: Mon, 29 Jan 2018 16:02:46 +0000 (UTC)
Message-ID: <1278608578.11357.1517241766434.JavaMail.zimbra@efficios.com>
References: <20180123155733.3404-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180123155733.3404-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Boqun Feng <boqun.feng@gmail.com>, Andrew Hunter <ahh@google.com>, maged michael <maged.michael@gmail.com>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Dave Watson <davejwatson@fb.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrea Parri <parri.andrea@gmail.com>, "Russell King, ARM Linux" <linux@armlinux.org.uk>, Greg Hackmann <ghackmann@google.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org

Hi Ingo, Hi Peter,

Please let me know if you find anything that prevents you from integrating
this patchset into the scheduler tree.

Thanks,

Mathieu


----- On Jan 23, 2018, at 10:57 AM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:

> Hi Ingo, Peter, Thomas,
> 
> Here is the updated membarrier patch series following review from
> Andy.
> 
> It would be appreciated of those can go through the scheduler tree for
> the 4.16 merge window.
> 
> Patch "x86: Implement sync_core_before_usermode" got a reviewed-by from
> Thomas, but I removed the tag following KPTI-related optimizations based
> on the discussion with Andy afterwards.
> 
> Highlights:
> 
> "powerpc: membarrier: Skip memory barrier in switch_mm()" takes care of
> a TODO that was left in the private expedited implementation when merged
> in 4.14: an extra memory barrier was added on context switch on powerpc.
> Ensure that the barrier is only performed when scheduling between
> different processes, only for threads belonging to processes that have
> registered their intent to use the private expedited command.
> 
> "membarrier: provide GLOBAL_EXPEDITED command" adds new commands to
> membarrier for registration and use of membarrier across processes
> communicating through shared memory mappings. The non-expedited command
> has proven to be really too slow (taking 10ms and more to complete) for
> real-world use. The expedited version completes in a matter of
> microseconds. This patch renames the pre-existing MEMBARRIER_CMD_SHARED
> to MEMBARRIER_CMD_GLOBAL for consistency, keeping the old enum label
> as an alias for backward compatibility.
> 
> "membarrier: Provide core serializing command" provides core
> serialization for JIT reclaim. We received positive feedback from
> Android developers that the proposed ABI fits their use-case.
> Only x86 32/64 and arm 64 implement this command so far. This is
> opt-in per architecture.
> 
> The other patches add selftests and documentation.
> 
> Thanks,
> 
> Mathieu
> 
> Mathieu Desnoyers (11):
>  membarrier: selftest: Test private expedited cmd (v2)
>  powerpc: membarrier: Skip memory barrier in switch_mm() (v7)
>  membarrier: Document scheduler barrier requirements (v5)
>  membarrier: provide GLOBAL_EXPEDITED command (v3)
>  membarrier: selftest: Test global expedited cmd (v2)
>  Introduce sync_core_before_usermode (v2)
>  x86: Implement sync_core_before_usermode (v3)
>  membarrier: Provide core serializing command (v2)
>  membarrier: x86: Provide core serializing command (v4)
>  membarrier: arm64: Provide core serializing command
>  membarrier: selftest: Test private expedited sync core cmd
> 
> MAINTAINERS                                        |   1 +
> arch/arm64/Kconfig                                 |   1 +
> arch/arm64/kernel/entry.S                          |   4 +
> arch/powerpc/Kconfig                               |   1 +
> arch/powerpc/include/asm/membarrier.h              |  27 +++
> arch/powerpc/mm/mmu_context.c                      |   7 +
> arch/x86/Kconfig                                   |   2 +
> arch/x86/entry/entry_32.S                          |   5 +
> arch/x86/entry/entry_64.S                          |   4 +
> arch/x86/include/asm/sync_core.h                   |  28 +++
> arch/x86/mm/tlb.c                                  |   6 +
> include/linux/sched/mm.h                           |  40 +++-
> include/linux/sync_core.h                          |  21 ++
> include/uapi/linux/membarrier.h                    |  74 ++++++-
> init/Kconfig                                       |   9 +
> kernel/sched/core.c                                |  53 +++--
> kernel/sched/membarrier.c                          | 177 +++++++++++++--
> .../testing/selftests/membarrier/membarrier_test.c | 237 +++++++++++++++++++--
> 18 files changed, 629 insertions(+), 68 deletions(-)
> create mode 100644 arch/powerpc/include/asm/membarrier.h
> create mode 100644 arch/x86/include/asm/sync_core.h
> create mode 100644 include/linux/sync_core.h
> 
> --
> 2.11.0

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
