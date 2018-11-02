From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Supporting core-specific instruction sets (e.g. big.LITTLE) with
 restartable sequences
Date: Fri, 2 Nov 2018 11:12:24 -0400 (EDT)
Message-ID: <313542172.8.1541171544337.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Henderson <rth@twiddle.net>
Cc: Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, libc-alpha <libc-alpha@sourceware.org>, Carlos O'Donell <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>Ben Maurer <bmaurer@fb.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Richard,

I stumbled on these articles:

- https://medium.com/@jadr2ddude/a-big-little-problem-a-tale-of-big-little-gone-wrong-e7778ce744bb
- https://www.mono-project.com/news/2016/09/12/arm64-icache/

and discussed them with Will Deacon. He told me you were looking into gcc atomics and it might be
worthwhile to discuss the possible use of the new rseq system call that has been added in Linux 4.18
for those use-cases.

Basically, the use-cases targeted are those where some cores on the system support a larger instruction
set than others. So for instance, some cores could use a faster atomic add instruction than others, which
should rely on a slower fallback. This is also the same story for reading the performance monitoring
unit counters from user-space: it depends on the feature-set supported by the CPU on which the instruction
is issued. Same applies to cores having different cache-line sizes.

The main problem is that the kernel can migrate a thread at any point between user-space reading the
current cpu number and issuing the instruction. This is where rseq can help.

The core idea to solve the instruction set issue is to set a mask of cpus supporting the new instruction
in a library constructor, and then load cpu_id, use it with the mask, and branch to either the new or
old instruction, all with a rseq critical section. If the kernel needs to abort due to preemption or
signal delivery, the abort behavior would be to issue the fallback (slow) atomic operation, which
guarantees progress even if single-stepping.

As long as the load, test and branch is faster than the performance delta between the old and new atomic
instruction, it would be worth it.

In the case of PMU read from user-space, using rseq to figure out how to issue the PMU read enables a
use-case which is not otherwise possible to do on big.LITTLE. On rseq abort, it would fallback to a
system call to read the PMU counter. This abort behavior guarantees forward progress.

The second article is about cache line size discrepancy between CPUs. Here again, doing the cacheline
flushing in a rseq critical section could allow tuning it to characteristics of the actual core it is
running on. The fast-path would use a stride fitting the current core characteristics, and if rseq
needs to abort, the slow-path would fall-back to a conservative value which would fit all cores (smaller
cache line size on the overall system). Once again, this abort behavior guarantees forward progress.
This would only work, of course, if cacheline invalidation done on a big core end up being propagated
to other cores in a way that clears all the cache lines corresponding to the one targeted on the big
core.

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
