From: Will Deacon <will.deacon@arm.com>
Subject: Re: [RFC PATCH for 4.15 v12 00/22] Restartable sequences and CPU op
 vector
Date: Wed, 22 Nov 2017 19:37:35 +0000
Message-ID: <20171122193734.GO22648@arm.com>
References: <20171121141900.18471-1-mathieu.desnoyers@efficios.com>
 <20171121172144.GL2482@two.firstfloor.org>
 <740195164.19702.1511301908907.JavaMail.zimbra@efficios.com>
 <20171122193219.GI3165@worktop.lehotels.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171122193219.GI3165@worktop.lehotels.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Andi Kleen <andi@firstfloor.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 22, 2017 at 08:32:19PM +0100, Peter Zijlstra wrote:
> On Tue, Nov 21, 2017 at 10:05:08PM +0000, Mathieu Desnoyers wrote:
> > Other than that, I have not received any concrete alternative proposal to
> > properly handle single-stepping.
> 
> That's not entirely true; amluto did have an alternative in Prague: do
> full machine level instruction emulation till the end of the rseq when
> it gets 'preempted too often'.
> 
> Yes, implementing that will be an absolute royal pain. But it does
> remove the whole duplicate/dual program asm/bytecode thing and avoids
> the syscall entirely.
> 
> And we don't need to do a full x86_64/arch-of-choice emulator for this
> either; just as cpu_opv is fairly limited too. We can do a subset that
> allows dealing with the known sequences and go from there -- it can
> always fall back to not emulating and reverting to the pure rseq with
> debug/fwd progress 'issues'.
> 
> So what exactly is the problem of leaving out the whole cpu_opv thing
> for now? Pure rseq is usable -- albeit a bit cumbersome without
> additional debugger support.

Drive-by "ack" to that. I'd really like a working rseq implementation in
mainline, but I don't much care for another interpreter.

Will
