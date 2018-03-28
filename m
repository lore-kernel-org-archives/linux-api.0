From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH for 4.17 02/21] rseq: Introduce restartable sequences
 system call (v12)
Date: Wed, 28 Mar 2018 14:52:16 +0200
Message-ID: <20180328125216.GF4129@hirez.programming.kicks-ass.net>
References: <20180327160542.28457-1-mathieu.desnoyers@efficios.com>
 <20180327160542.28457-3-mathieu.desnoyers@efficios.com>
 <20180328122946.GU4043@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180328122946.GU4043@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 28, 2018 at 02:29:46PM +0200, Peter Zijlstra wrote:
> > +static int rseq_get_rseq_cs(struct task_struct *t,
> > +			    unsigned long *start_ip,
> > +			    unsigned long *post_commit_offset,
> > +			    unsigned long *abort_ip,
> > +			    uint32_t *cs_flags)
> > +{

> 
> > +
> > +	*cs_flags = rseq_cs.flags;
> > +	*start_ip = rseq_cs.start_ip;
> > +	*post_commit_offset = rseq_cs.post_commit_offset;
> > +	*abort_ip = rseq_cs.abort_ip;
> 
> Then this becomes a straight struct assignment.

I initially suggested passing a structure instead of many arguments, but
then recondidered, mostly because it will be inlined (due to having only
the one caller) anyway. Still, maybe a struct will work better, I dunno.
