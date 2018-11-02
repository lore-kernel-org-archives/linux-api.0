From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: Supporting core-specific instruction sets (e.g. big.LITTLE) with
 restartable sequences
Date: Fri, 2 Nov 2018 16:08:45 +0000
Message-ID: <20181102160844.ihge4najccn63cxi@lakrids.cambridge.arm.com>
References: <313542172.8.1541171544337.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <313542172.8.1541171544337.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Richard Henderson <rth@twiddle.net>, Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, libc-alpha <libc-alpha@sourceware.org>, Carlos O'Donell <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Mathieu, Richard,

On Fri, Nov 02, 2018 at 11:12:24AM -0400, Mathieu Desnoyers wrote:
> Hi Richard,
> 
> I stumbled on these articles:
> 
> - https://medium.com/@jadr2ddude/a-big-little-problem-a-tale-of-big-little-gone-wrong-e7778ce744bb
> - https://www.mono-project.com/news/2016/09/12/arm64-icache/
> 
> and discussed them with Will Deacon. He told me you were looking into
> gcc atomics and it might be worthwhile to discuss the possible use of
> the new rseq system call that has been added in Linux 4.18 for those
> use-cases.
> 
> Basically, the use-cases targeted are those where some cores on the
> system support a larger instruction set than others. So for instance,
> some cores could use a faster atomic add instruction than others,
> which should rely on a slower fallback. This is also the same story
> for reading the performance monitoring unit counters from user-space:
> it depends on the feature-set supported by the CPU on which the
> instruction is issued. Same applies to cores having different
> cache-line sizes.

Please note that upstream arm64 Linux does not expose mismatched ISA
feature to userspace. We go to great pains to expose a uniform set of
supported features.

The two issues referenced above are both handled by the kernel, and no
userspace changes are required to handle them.

We do not intend or expect to expose mismatched features to userspace.
Correctly-written userspace should not use optional instructions unless
the kernel has advertised their presence via a hwcap (or via ID register
emulation).

> The main problem is that the kernel can migrate a thread at any point
> between user-space reading the current cpu number and issuing the
> instruction. This is where rseq can help.
> 
> The core idea to solve the instruction set issue is to set a mask of
> cpus supporting the new instruction in a library constructor, and then
> load cpu_id, use it with the mask, and branch to either the new or old
> instruction, all with a rseq critical section. If the kernel needs to
> abort due to preemption or signal delivery, the abort behavior would
> be to issue the fallback (slow) atomic operation, which guarantees
> progress even if single-stepping.
> 
> As long as the load, test and branch is faster than the performance
> delta between the old and new atomic instruction, it would be worth
> it.

Specifically w.r.t. the atomics, the kernel will only expose the
presence of the ARMv8.1 atomic instructions when supported by all CPUs
in the system.

> In the case of PMU read from user-space, using rseq to figure out how
> to issue the PMU read enables a use-case which is not otherwise
> possible to do on big.LITTLE. On rseq abort, it would fallback to a
> system call to read the PMU counter. This abort behavior guarantees
> forward progress.

We do not currently expose any PMU registers to userspace. If we were to
expose them for big.LITTLE, rseq may be of use, but no-one has done the
groundwork to investigate this.

> The second article is about cache line size discrepancy between CPUs.
> Here again, doing the cacheline flushing in a rseq critical section
> could allow tuning it to characteristics of the actual core it is
> running on. The fast-path would use a stride fitting the current core
> characteristics, and if rseq needs to abort, the slow-path would
> fall-back to a conservative value which would fit all cores (smaller
> cache line size on the overall system).

This is already handled by the kernel, and the proposed rseq approach is
not correct -- cache maintenance must *always* use the system-wide
minimum cacheline size, or stale entries will be left on some CPUs,
which will result in later failures.

Thanks,
Mark.
