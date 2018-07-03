From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH for 4.18] rseq: use __u64 for rseq_cs fields,
 validate user inputs
Date: Tue, 3 Jul 2018 19:34:51 +0200
Message-ID: <20180703173451.GX2494@hirez.programming.kicks-ass.net>
References: <858886246.10882.1530583291379.JavaMail.zimbra@efficios.com>
 <CA+55aFxWMjwx-4TGBHt0H6bh6FXC3NKMsjp=eKGw5cgA4wMBUA@mail.gmail.com>
 <1776351430.10902.1530585009519.JavaMail.zimbra@efficios.com>
 <20180703081449.GT2494@hirez.programming.kicks-ass.net>
 <20180703082955.GH3704@osiris>
 <20180703084312.GU2494@hirez.programming.kicks-ass.net>
 <20180703085546.GJ3704@osiris>
 <20180703092113.GV2494@hirez.programming.kicks-ass.net>
 <20180703164048.i2te5gjemcafqzwf@two.firstfloor.org>
 <CA+55aFzYEQgEhCnrwtbGuCy36Wh+aiw0_9rgMcjUgbn1JtZAPQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFzYEQgEhCnrwtbGuCy36Wh+aiw0_9rgMcjUgbn1JtZAPQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Andy Lutomirski <luto@amacapital.net>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King - ARM Linux <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, Peter Anvin <hpa@zytor.com>, Christoph Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.m>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 03, 2018 at 10:10:37AM -0700, Linus Torvalds wrote:
> On Tue, Jul 3, 2018 at 9:40 AM Andi Kleen <andi@firstfloor.org> wrote:
> >
> > So it sounds like architectures that don't have an instruction atomic u64
> > *_user need to disable interrupts during the access, and somehow handle that
> > case when a page fault happens?
> 
> No. It's actually the store by *user* space that is the critical one.
> Not the whole 64-bit value, just the low pointer part.
> 
> The kernel could do it as a byte-by-byte load, really. It's
> per-thread, and once the kernel is running, it's not going to change.
> The kernel never changes the value, it just loads it from user space.

The kernel doesn't change _this_ value, but the kernel does change other
values, like for instance rseq->cpu_id. But even there, it could use
byte stores and it is again the userspace load of that field that is
critical again and needs to be a single op.
