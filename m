From: Christoph Lameter <cl@linux.com>
Subject: Re: [RFC PATCH v7 1/7] Restartable sequences system call
Date: Wed, 3 Aug 2016 13:31:30 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1608031330000.14875@east.gentwo.org>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com> <1469135662-31512-2-git-send-email-mathieu.desnoyers@efficios.com> <CALCETrVq3hgLbADcx_4g6gGgp7Hf-WnnWA8gg68tPZTv2wfbDg@mail.gmail.com> <1806206514.82247.1469502139408.JavaMail.zimbra@efficios.com>
 <20160803122717.GL6862@twins.programming.kicks-ass.net> <CALCETrWw0M9YLWTR7_ruxY8cW9_5XRONdw1QN+_pBp0Y63L8pA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWw0M9YLWTR7_ruxY8cW9_5XRONdw1QN+_pBp0Y63L8pA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Peter Zijlstra <peterz@infradead.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Boqun Feng <boqun.feng@gmail.com>
List-Id: linux-api@vger.kernel.org

On Wed, 3 Aug 2016, Andy Lutomirski wrote:

> > Well, a CMPXCHG without LOCK prefix isn't all that expensive on x86.
> >
> > It is however on PPC and possibly other architectures, so in name of
> > simplicity supporting only the one variant makes sense.
> >
>
> I wouldn't want to depend on CMPXCHG.  But imagine we had primitives
> that were narrower than the full abort-on-preemption primitive.
> Specifically, suppose we had abort if (actual cpu != expected_cpu ||
> *aptr != aval).  We could do things like:
>

The latency issues that are addressed by restartable sequences require
minimim instruction overhead. Lockless CMPXCHG is very important in that
area and I would not simply remove it from consideration.
