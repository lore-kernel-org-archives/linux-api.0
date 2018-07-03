From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH for 4.18] rseq: use __u64 for rseq_cs fields,
 validate user inputs
Date: Tue, 3 Jul 2018 11:21:13 +0200
Message-ID: <20180703092113.GV2494@hirez.programming.kicks-ass.net>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180703085546.GJ3704@osiris>
Sender: linux-kernel-owner@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 03, 2018 at 10:55:46AM +0200, Heiko Carstens wrote:
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

rseq is strictly task local. So from that pov single-copy atomic and
single instruction semantics end up being very similar.

The most complicated scenario would be where we interrupt the task,
schedule it out, migrate it and resume execution on another CPU. In that
case the second CPU also needs to observe a 'whole' value.

But note that in that example there's a fair bit of ordering provided by
the scheduler to ensure all the state from the old CPU is observed by
the new CPU (on s390 just the rq->lock fiddling would imply a bunch of
general memory barriers).

So I think you're good... But yes, you raise an interresting point.
