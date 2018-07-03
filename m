From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH for 4.18] rseq: use __u64 for rseq_cs fields, validate
 user inputs
Date: Tue, 3 Jul 2018 10:10:37 -0700
Message-ID: <CA+55aFzYEQgEhCnrwtbGuCy36Wh+aiw0_9rgMcjUgbn1JtZAPQ@mail.gmail.com>
References: <8B2E4CEB-3080-4602-8B62-774E400892EB@amacapital.net>
 <459661281.10865.1530580742205.JavaMail.zimbra@efficios.com>
 <858886246.10882.1530583291379.JavaMail.zimbra@efficios.com>
 <CA+55aFxWMjwx-4TGBHt0H6bh6FXC3NKMsjp=eKGw5cgA4wMBUA@mail.gmail.com>
 <1776351430.10902.1530585009519.JavaMail.zimbra@efficios.com>
 <20180703081449.GT2494@hirez.programming.kicks-ass.net> <20180703082955.GH3704@osiris>
 <20180703084312.GU2494@hirez.programming.kicks-ass.net> <20180703085546.GJ3704@osiris>
 <20180703092113.GV2494@hirez.programming.kicks-ass.net> <20180703164048.i2te5gjemcafqzwf@two.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180703164048.i2te5gjemcafqzwf@two.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Andy Lutomirski <luto@amacapital.net>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King - ARM Linux <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, Peter Anvin <hpa@zytor.com>, Christoph Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <cata>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 3, 2018 at 9:40 AM Andi Kleen <andi@firstfloor.org> wrote:
>
> So it sounds like architectures that don't have an instruction atomic u64
> *_user need to disable interrupts during the access, and somehow handle that
> case when a page fault happens?

No. It's actually the store by *user* space that is the critical one.
Not the whole 64-bit value, just the low pointer part.

The kernel could do it as a byte-by-byte load, really. It's
per-thread, and once the kernel is running, it's not going to change.
The kernel never changes the value, it just loads it from user space.

So all the atomicity worries for the kernel are a red herring. They'd
arguably be nice to have - but only for an insane case that makes
absolutely no sense (a different thread trying to change the value).

Can we please stop the idiocy already? The kernel could read the rseq
pointer one bit at a time, and do a little dance with "yield()" in
between, and take interrupts and page faults, and it wouldn't matter
AT ALL.

It's not even that we read the value from an interrupt context, it's
that as we return to user space (which can be the result of an
interrupt) we can read the value.

This whole thread has been filled with crazy "what if" things that don't matter.

                    Linus
