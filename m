From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH for 5.1 0/3] Restartable Sequences updates for 5.1
Date: Tue, 5 Mar 2019 22:58:48 +0100
Message-ID: <20190305215848.GQ32477@hirez.programming.kicks-ass.net>
References: <20190305194755.2602-1-mathieu.desnoyers@efficios.com>
 <1689743723.311.1551817115045.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1689743723.311.1551817115045.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael
List-Id: linux-api@vger.kernel.org

On Tue, Mar 05, 2019 at 03:18:35PM -0500, Mathieu Desnoyers wrote:
> * NUMA node ID in TLS
> 
> Having the NUMA node ID available in a TLS variable would allow glibc to
> perform interesting NUMA performance improvements within its locking
> implementation, so I have a patch adding NUMA node ID support to rseq
> as a new rseq system call flag.

Details? There's just not much room in the futex word, and futexes
themselves are not numa aware.

Before all this spectre nonsense; tglx and me were looking at a futex2
syscall that would, among other things, cure this.

> * Adaptative mutex improvements
> 
> I have done a prototype using rseq to implement an adaptative mutex which
> can detect preemption using a rseq critical section. This ensures the
> thread doesn't continue to busy-loop after it returns from preemption, and
> calls sys_futex() instead. This is part of a user-space prototype branch [2],
> and does not require any kernel change.

I'm still not convinced that is actually the right way to go about
things. The kernel heuristic is spin while the _owner_ runs, and we
don't get preempted, obviously.

And the only userspace spinning that makes sense is to cover the cost of
the syscall. Now Obviously PTI wrecked everything, but before that
syscalls were actually plenty fast and you didn't need many cmpxchg
cycles to amortize the syscall itself -- which could then do kernel side
adaptive spinning (when required).
