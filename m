From: Christoph Lameter <cl@linux.com>
Subject: Re: [RFC PATCH v7 1/7] Restartable sequences system call
Date: Wed, 10 Aug 2016 11:59:23 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1608101155230.14336@east.gentwo.org>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com> <1469135662-31512-2-git-send-email-mathieu.desnoyers@efficios.com> <CALCETrVq3hgLbADcx_4g6gGgp7Hf-WnnWA8gg68tPZTv2wfbDg@mail.gmail.com> <1806206514.82247.1469502139408.JavaMail.zimbra@efficios.com>
 <alpine.DEB.2.20.1608031325040.14875@east.gentwo.org> <2119563927.7329.1470847662641.JavaMail.zimbra@efficios.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2119563927.7329.1470847662641.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Boqun Feng <boqun.feng@gmail.com>
List-Id: linux-api@vger.kernel.org

On Wed, 10 Aug 2016, Mathieu Desnoyers wrote:

> - preemption of kernel code (for atomicity wrt other threads). This would
>   replace preempt_disable()/preempt_enable() critical sections touching
>   per-cpu data shared with other threads. We would have to do the event_counter
>   increment and ip fixup directly in the sched_out hook when preempting
>   kernel code.

What we would need is special handling when returning from a context
switch so that we recognize in what type of code section we are in and
continue execution at the proper retry site. This can be done by putting
code into special sections or other methods that do not require additional
coee.

> - possibly interrupt handlers (for atomicity wrt interrupts). This would
>   replace local irq save/restore when touching per-cpu data shared with
>   interrupt handlers. We would have to increment the event_counter and
>   fixup on the pre-irq kernel frame.

Same thing as before. Test if we are in a section by testing the return
address and then maybe continue elsewhere.

> Those supplementary hooks may add significant overall performance overhead,
> so careful benchmarking would be required to figure out if it's worth it.

We need a design that does not need these hooks. If we check the return
IP address for a special range then we would not need those. Any hooks
would bloat the code in such a way that the implementation would not be
acceptable for the kernel code.
