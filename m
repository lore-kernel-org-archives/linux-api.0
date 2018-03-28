From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH for 4.17 10/21] cpu_opv: Provide cpu_opv system call
 (v6)
Date: Wed, 28 Mar 2018 17:22:03 +0200
Message-ID: <20180328152203.GW4043@hirez.programming.kicks-ass.net>
References: <20180327160542.28457-1-mathieu.desnoyers@efficios.com>
 <20180327160542.28457-11-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180327160542.28457-11-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 27, 2018 at 12:05:31PM -0400, Mathieu Desnoyers wrote:

> 1) Allow algorithms to perform per-cpu data migration without relying on
>    sched_setaffinity()
> 
> The use-cases are migrating memory between per-cpu memory free-lists, or
> stealing tasks from other per-cpu work queues: each require that
> accesses to remote per-cpu data structures are performed.

I think that one completely reduces to the per-cpu (spin)lock case,
right? Because, as per the below, your logging case (8) can 'easily' be
done without the cpu_opv monstrosity.

And if you can construct a per-cpu lock, that can be used to construct
aribtrary logic.

And the difficult case for the per-cpu lock is the remote acquire; all
the other cases are (relatively) trivial.

I've not really managed to get anything sensible to work, I've tried
several variations of split lock, but you invariably end up with
barriers in the fast (local) path, which sucks.

But I feel this should be solvable without cpu_opv. As in, I really hate
that thing ;-)

> 8) Allow libraries with multi-part algorithms to work on same per-cpu
>    data without affecting the allowed cpu mask
> 
> The lttng-ust tracer presents an interesting use-case for per-cpu
> buffers: the algorithm needs to update a "reserve" counter, serialize
> data into the buffer, and then update a "commit" counter _on the same
> per-cpu buffer_. Using rseq for both reserve and commit can bring
> significant performance benefits.
> 
> Clearly, if rseq reserve fails, the algorithm can retry on a different
> per-cpu buffer. However, it's not that easy for the commit. It needs to
> be performed on the same per-cpu buffer as the reserve.
> 
> The cpu_opv system call solves that problem by receiving the cpu number
> on which the operation needs to be performed as argument. It can push
> the task to the right CPU if needed, and perform the operations there
> with preemption disabled.
> 
> Changing the allowed cpu mask for the current thread is not an
> acceptable alternative for a tracing library, because the application
> being traced does not expect that mask to be changed by libraries.

We talked about this use-case, and it can be solved without cpu_opv if
you keep a dual commit counter, one local and one (atomic) remote.

We retain the cpu_id from the first rseq, and the second part will, when
it (unlikely) finds it runs remotely, do an atomic increment on the
remote counter. The consumer of the counter will then have to sum both
the local and remote counter parts.
