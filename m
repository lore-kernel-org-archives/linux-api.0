From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [RFC PATCH for 4.18] rseq: use __u64 for rseq_cs fields,
 validate user inputs
Date: Tue, 3 Jul 2018 11:17:17 +0200
Message-ID: <20180703091717.GK3704@osiris>
References: <1959930320.10843.1530573742647.JavaMail.zimbra@efficios.com>
 <8B2E4CEB-3080-4602-8B62-774E400892EB@amacapital.net>
 <459661281.10865.1530580742205.JavaMail.zimbra@efficios.com>
 <858886246.10882.1530583291379.JavaMail.zimbra@efficios.com>
 <CA+55aFxWMjwx-4TGBHt0H6bh6FXC3NKMsjp=eKGw5cgA4wMBUA@mail.gmail.com>
 <1776351430.10902.1530585009519.JavaMail.zimbra@efficios.com>
 <20180703081449.GT2494@hirez.programming.kicks-ass.net>
 <20180703082955.GH3704@osiris>
 <20180703084312.GU2494@hirez.programming.kicks-ass.net>
 <20180703085546.GJ3704@osiris>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180703085546.GJ3704@osiris>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>C
List-Id: linux-api@vger.kernel.org

On Tue, Jul 03, 2018 at 10:55:46AM +0200, Heiko Carstens wrote:
> > > > We're piece-wise enabling rseq across architectures anyway, and when the
> > > > relevant maintains do this, they can have a look at their
> > > > {get,put}_user() implementations and fix them.
> > > > 
> > > > If you rely on get_user(u64) working, that means microblaze is already
> > > > broken, but I suppose it already was, since their rseq enablement patch
> > > > is extremely dodgy. Michal?
> > > 
> > > s390 uses the mvcos instruction to implement get_user(). That instruction
> > > is not defined to be atomic, but may copy bytes piecemeal.. I had the
> > > impression that the rseq fields are supposed to be updated within the
> > > context of a single thread (user + kernel space).
> > > 
> > > However if another user space thread is allowed to do this as well, then
> > > the get_user() approach won't fly on s390.
> > > 
> > > That leaves the question: does it even make sense for a thread to update
> > > the rseq structure of a different thread?
> > 
> > The problem is interrupts; we need interrupts on the CPU doing the store
> > to observe either the old or the new value, not a mix.
> > 
> > If mvcos does not guarantee that, we're having problems. Is there a
> > reason get_user() cannot use a 'regular' load?
> 
> Well, that's single instruction semantics. This is something we actually
> can guarantee, since the mvcos instruction itself won't be interrupted and
> copies all 1/2/4/8 bytes in a row.
> 
> So we are talking about that single instructions are required and not
> atomic accesses?

And to answer also your question: we don't use a regular load, since we
would have to use 'sacf' construct surrounding the load instruction which
would be much slower.
We have something like that implemented for the futex atomic ops, and we
could also implement something like that for this use case
(e.g. get_user_atomic()), if really needed.
