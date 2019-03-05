From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH for 5.1 0/3] Restartable Sequences updates for 5.1
Date: Tue, 5 Mar 2019 15:18:35 -0500 (EST)
Message-ID: <1689743723.311.1551817115045.JavaMail.zimbra@efficios.com>
References: <20190305194755.2602-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190305194755.2602-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael
List-Id: linux-api@vger.kernel.org

----- On Mar 5, 2019, at 2:47 PM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:

> Those changes aiming at 5.1 include one comment cleanup, the removal of
> the rseq_len field from the task struct which serves no purpose
> considering that the struct size is fixed by the ABI, and a selftest
> improvement adapting the number of threads to the number of detected
> CPUs, which is nicer for smaller systems.

For those interested, here is a status update on how things are evolving
in terms of rseq Linux ecosystem integration:

I've been working with glibc maintainers for the past months to get rseq
registration integrated into glibc. The patchset is awaiting feedback
from glibc maintainers at this point. An important part of that integration
is the user-level ABI defining interaction between the executable and
libraries wishing to register rseq within the same process. This is needed
because the rseq system call only supports a single rseq registration per
thread (this was done on purpose). If all goes well we should see rseq
integration in glibc as part of the glibc 2.30 release in August 2019.

For those interested in upcoming rseq kernel patches I have ready, those are
available at [1].

The main reason why we're not seeing more users of rseq out there right now
is because the user-level ABI to interact between libc, applications, and
early adopter libraries needs to be specified before projects start using
rseq. An early adopter of rseq should not be incompatible with a glibc
which introduces rseq registration support.

Once glibc integration is done, here are a few things I have ready:

* NUMA node ID in TLS

Having the NUMA node ID available in a TLS variable would allow glibc to
perform interesting NUMA performance improvements within its locking
implementation, so I have a patch adding NUMA node ID support to rseq
as a new rseq system call flag.

* Adaptative mutex improvements

I have done a prototype using rseq to implement an adaptative mutex which
can detect preemption using a rseq critical section. This ensures the
thread doesn't continue to busy-loop after it returns from preemption, and
calls sys_futex() instead. This is part of a user-space prototype branch [2],
and does not require any kernel change.

* cpu_opv system call

Use-cases requiring access to remote per-cpu data such as memory migration
in a memory allocator and access to specific per-cpu buffers from a
ring-buffer consumer will end up requiring this additional system call.
I'm awaiting a broader adoption of rseq (which depends on glibc integration)
for simpler use-cases before pushing the cpu_opv system call again.

Thanks,

Mathieu

[1] https://git.kernel.org/pub/scm/linux/kernel/git/rseq/linux-rseq.git/
[2] https://github.com/compudj/rseq-test/blob/adapt-lock/test-rseq-adaptative-lock.c

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
