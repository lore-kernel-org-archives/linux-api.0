From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC PATCH 1/2] thread_local_abi system call: caching current
 CPU number (x86)
Date: Sun, 13 Dec 2015 19:15:27 +0100
Message-ID: <20151213181527.GV15533@two.firstfloor.org>
References: <1449761990-23525-1-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1449761990-23525-1-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

> This getcpu cache is an alternative to the sched_getcpu() vdso which has
> a few benefits:


Note the first version of getcpu() I proposed had a cache. But it was
rejected.

> - It is faster to do a memory read that to call a vDSO,
> - This cached value can be read from within an inline assembly, which
>   makes it a useful building block for restartable sequences.

On x86 we already have the de-facto ABI of using LSL with the magic
segment directly. While that is a few cycles slower than a memory load
I question the difference is big enough to justify a new system call,
and risk slow page fault in context switches.

BTW the vdso could be also optimized I think. For example glibc today
does some stupid (slow) things with it, like doing double iindirect
jumps.

-Andi
