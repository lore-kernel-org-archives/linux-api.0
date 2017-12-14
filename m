From: Christopher Lameter <cl@linux.com>
Subject: Re: [RFC PATCH for 4.16 02/21] rseq: Introduce restartable sequences
 system call (v12)
Date: Thu, 14 Dec 2017 10:44:34 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1712141033100.6249@nuc-kabylake>
References: <20171214161403.30643-1-mathieu.desnoyers@efficios.com> <20171214161403.30643-3-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171214161403.30643-3-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org

On Thu, 14 Dec 2017, Mathieu Desnoyers wrote:

> On x86, yet another possible approach would be to use the gs segment
> selector to point to user-space per-cpu data. This approach performs
> similarly to the cpu id cache, but it has two disadvantages: it is
> not portable, and it is incompatible with existing applications already
> using the gs segment selector for other purposes.

I think the proper way to think about gs and fs on x86 is as base
registers. They are essentially values in registers added to the address
generated in an instruction. As such the approach is transferable to other
processor architecture. Many support base register and base register
relative processing. If a processor can do RMV instructions base register
relative then you have something similar.

In a restartable sequence you could increase efficieny by avoiding full
atomic instructions. This would be similar to the lockless RMV available
on x86 then. And in that form it is portable.

A context switch to another processors would mean that the value of the
base register has changed and that we therefore are accessing another per
cpu segment. Restarting the sequence will yield a correct result without
any reloading of registers.
