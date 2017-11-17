From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH v3 for 4.15 08/24] Provide cpu_opv system call
Date: Fri, 17 Nov 2017 21:22:04 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1711172118270.2186@nanos>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com> <20171114200414.2188-9-mathieu.desnoyers@efficios.com> <alpine.DEB.2.20.1711162215100.2109@nanos> <20171117001410.GG2482@two.firstfloor.org> <alpine.DEB.2.20.1711171107450.1709@nanos>
 <1756446476.17265.1510938872121.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1756446476.17265.1510938872121.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will
List-Id: linux-api@vger.kernel.org

On Fri, 17 Nov 2017, Mathieu Desnoyers wrote:
> ----- On Nov 17, 2017, at 5:09 AM, Thomas Gleixner tglx@linutronix.de wrote:
> 7) Allow libraries with multi-part algorithms to work on same per-cpu
>    data without affecting the allowed cpu mask
> 
> I stumbled on an interesting use-case within the lttng-ust tracer
> per-cpu buffers: the algorithm needs to update a "reserve" counter,
> serialize data into the buffer, and then update a "commit" counter
> _on the same per-cpu buffer_. My goal is to use rseq for both reserve
> and commit.
> 
> Clearly, if rseq reserve fails, the algorithm can retry on a different
> per-cpu buffer. However, it's not that easy for the commit. It needs to
> be performed on the same per-cpu buffer as the reserve.
> 
> The cpu_opv system call solves that problem by receiving the cpu number
> on which the operation needs to be performed as argument. It can push
> the task to the right CPU if needed, and perform the operations there
> with preemption disabled.

If your transaction cannot be done in one go, then abusing that byte code
interpreter for concluding it is just hillarious. That whole exercise is a
gazillion times slower than the atomic operations which are neccesary to do
it without all that.

I'm even more convinced now that this is overengineered beyond repair.

Thanks,

	tglx
