From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18] rseq: use __u64 for rseq_cs fields,
 validate user inputs
Date: Tue, 3 Jul 2018 13:26:39 -0400 (EDT)
Message-ID: <1047204530.11737.1530638799580.JavaMail.zimbra@efficios.com>
References: <8B2E4CEB-3080-4602-8B62-774E400892EB@amacapital.net> <20180703081449.GT2494@hirez.programming.kicks-ass.net> <20180703082955.GH3704@osiris> <20180703084312.GU2494@hirez.programming.kicks-ass.net> <20180703085546.GJ3704@osiris> <20180703092113.GV2494@hirez.programming.kicks-ass.net> <20180703164048.i2te5gjemcafqzwf@two.firstfloor.org> <CA+55aFzYEQgEhCnrwtbGuCy36Wh+aiw0_9rgMcjUgbn1JtZAPQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFzYEQgEhCnrwtbGuCy36Wh+aiw0_9rgMcjUgbn1JtZAPQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>, heiko carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@amacapital.net>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>Will Deacon <w>
List-Id: linux-api@vger.kernel.org

----- On Jul 3, 2018, at 1:10 PM, Linus Torvalds torvalds@linux-foundation.org wrote:

> On Tue, Jul 3, 2018 at 9:40 AM Andi Kleen <andi@firstfloor.org> wrote:
>>
>> So it sounds like architectures that don't have an instruction atomic u64
>> *_user need to disable interrupts during the access, and somehow handle that
>> case when a page fault happens?
> 
> No. It's actually the store by *user* space that is the critical one.
> Not the whole 64-bit value, just the low pointer part.
> 
> The kernel could do it as a byte-by-byte load, really. It's
> per-thread, and once the kernel is running, it's not going to change.
> The kernel never changes the value, it just loads it from user space.
> 
> So all the atomicity worries for the kernel are a red herring. They'd
> arguably be nice to have - but only for an insane case that makes
> absolutely no sense (a different thread trying to change the value).
> 
> Can we please stop the idiocy already? The kernel could read the rseq
> pointer one bit at a time, and do a little dance with "yield()" in
> between, and take interrupts and page faults, and it wouldn't matter
> AT ALL.
> 
> It's not even that we read the value from an interrupt context, it's
> that as we return to user space (which can be the result of an
> interrupt) we can read the value.
> 
> This whole thread has been filled with crazy "what if" things that don't matter.

Sorry to come back in the thread late, looks like I've missed all the
fun.

I agree with Linus: we can simply document that updates to rseq->rseq_cs
should be thread-local in the rseq uapi and be done with it. This would
allow using get_user(u64) even on 32-bit architectures, because we cannot
care less if an architecture chooses to read the u64 byte-wise while
standing on its feet.

With this added requirement, Andy's idea of using a union between __u64
and upper/lower __u32 would fit very nicely.

If everyone is OK with that approach, I can prepare an updated patch.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
