From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH for 4.18] rseq: use __u64 for rseq_cs fields,
 validate user inputs
Date: Tue, 3 Jul 2018 10:14:49 +0200
Message-ID: <20180703081449.GT2494@hirez.programming.kicks-ass.net>
References: <20180702223143.4663-1-mathieu.desnoyers@efficios.com>
 <CA+55aFzZYOatOtjrm7fD7878_SzCAmEoEu74n0+pgd7faH-sTQ@mail.gmail.com>
 <825871008.10839.1530573419561.JavaMail.zimbra@efficios.com>
 <1959930320.10843.1530573742647.JavaMail.zimbra@efficios.com>
 <8B2E4CEB-3080-4602-8B62-774E400892EB@amacapital.net>
 <459661281.10865.1530580742205.JavaMail.zimbra@efficios.com>
 <858886246.10882.1530583291379.JavaMail.zimbra@efficios.com>
 <CA+55aFxWMjwx-4TGBHt0H6bh6FXC3NKMsjp=eKGw5cgA4wMBUA@mail.gmail.com>
 <1776351430.10902.1530585009519.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1776351430.10902.1530585009519.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael
List-Id: linux-api@vger.kernel.org

On Mon, Jul 02, 2018 at 10:30:09PM -0400, Mathieu Desnoyers wrote:
> > Use "get_user()". It works for 64-bit objects too, and it will be
> > atomic in the 32-bit sub-parts on a 32-bit architecture.
> 
> Is it really ? Last time we had this discussion, not all architectures
> guaranteed that reading a 64-bit integer would happen in two atomic
> 32-bit sub-parts. This was the main motivation for the LINUX_FIELD_u32_u64()
> macro as it stands today (rather than using a union).

Just state, as a requirement for supporting rseq, that the arch
{get,put}_user(u64) on 32bit targets must be exactly 2 u32 loads/stores.

We're piece-wise enabling rseq across architectures anyway, and when the
relevant maintains do this, they can have a look at their
{get,put}_user() implementations and fix them.

If you rely on get_user(u64) working, that means microblaze is already
broken, but I suppose it already was, since their rseq enablement patch
is extremely dodgy. Michal?
