From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH for 4.18] rseq: use __u64 for rseq_cs fields,
 validate user inputs
Date: Tue, 3 Jul 2018 19:02:30 +0200
Message-ID: <20180703170230.GI2458@hirez.programming.kicks-ass.net>
References: <459661281.10865.1530580742205.JavaMail.zimbra@efficios.com>
 <858886246.10882.1530583291379.JavaMail.zimbra@efficios.com>
 <CA+55aFxWMjwx-4TGBHt0H6bh6FXC3NKMsjp=eKGw5cgA4wMBUA@mail.gmail.com>
 <1776351430.10902.1530585009519.JavaMail.zimbra@efficios.com>
 <20180703081449.GT2494@hirez.programming.kicks-ass.net>
 <20180703082955.GH3704@osiris>
 <20180703084312.GU2494@hirez.programming.kicks-ass.net>
 <20180703085546.GJ3704@osiris>
 <20180703092113.GV2494@hirez.programming.kicks-ass.net>
 <20180703164048.i2te5gjemcafqzwf@two.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180703164048.i2te5gjemcafqzwf@two.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.c>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 03, 2018 at 09:40:48AM -0700, Andi Kleen wrote:
> > 
> > So I think you're good... But yes, you raise an interresting point.
> 
> So it sounds like architectures that don't have an instruction atomic u64
> *_user need to disable interrupts during the access, and somehow handle that
> case when a page fault happens?

So for 32bit, as Linus already said, a split store is _fine_, because
the top word is always going to be 0 anyway.

So all we really need is native word sized loads / stores. s390 is just
a little weird here (it wouldn't be s390 if it wasn't I suppose) for not
actually using regular loads / stores because of the split address space
stuff.
