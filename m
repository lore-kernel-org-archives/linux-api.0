From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH for 4.18] rseq: use __u64 for rseq_cs fields,
 validate user inputs
Date: Tue, 3 Jul 2018 11:24:29 +0200
Message-ID: <20180703092429.GW2494@hirez.programming.kicks-ass.net>
References: <8B2E4CEB-3080-4602-8B62-774E400892EB@amacapital.net>
 <459661281.10865.1530580742205.JavaMail.zimbra@efficios.com>
 <858886246.10882.1530583291379.JavaMail.zimbra@efficios.com>
 <CA+55aFxWMjwx-4TGBHt0H6bh6FXC3NKMsjp=eKGw5cgA4wMBUA@mail.gmail.com>
 <1776351430.10902.1530585009519.JavaMail.zimbra@efficios.com>
 <20180703081449.GT2494@hirez.programming.kicks-ass.net>
 <20180703082955.GH3704@osiris>
 <20180703084312.GU2494@hirez.programming.kicks-ass.net>
 <20180703085546.GJ3704@osiris>
 <20180703091717.GK3704@osiris>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180703091717.GK3704@osiris>
Sender: linux-kernel-owner@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 03, 2018 at 11:17:17AM +0200, Heiko Carstens wrote:

> And to answer also your question: we don't use a regular load, since we
> would have to use 'sacf' construct surrounding the load instruction which
> would be much slower.
> We have something like that implemented for the futex atomic ops, and we
> could also implement something like that for this use case
> (e.g. get_user_atomic()), if really needed.

/me digs out the s390-PoO PDF and understands.. this is because of the
split user/kernel address space stuff.

Fair enough.
