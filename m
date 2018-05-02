From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18 00/14] Restartable Sequences
Date: Wed, 2 May 2018 12:03:08 -0400 (EDT)
Message-ID: <660904075.9201.1525276988842.JavaMail.zimbra@efficios.com>
References: <20180430224433.17407-1-mathieu.desnoyers@efficios.com> <CAKOZuesa338sc_=w6-wvro25idrSN_zx_zrHFyo-bDiORs7FZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZuesa338sc_=w6-wvro25idrSN_zx_zrHFyo-bDiORs7FZw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <cata>
List-Id: linux-api@vger.kernel.org

----- On May 1, 2018, at 11:53 PM, Daniel Colascione dancol@google.com wrote:
[...]
> 
> I think a small enhancement to rseq would let us build a perfect userspace
> mutex, one that spins on lock-acquire only when the lock owner is running
> and that sleeps otherwise, freeing userspace from both specifying ad-hoc
> spin counts and from trying to detect situations in which spinning is
> generally pointless.
> 
> It'd work like this: in the per-thread rseq data structure, we'd include a
> description of a futex operation for the kernel would perform (in the
> context of the preempted thread) upon preemption, immediately before
> schedule(). If the futex operation itself sleeps, that's no problem: we
> will have still accomplished our goal of running some other thread instead
> of the preempted thread.

Hi Daniel,

I agree that the problem you are aiming to solve is important. Let's see
what prevents the proposed rseq implementation from doing what you envision.

The main issue here is touching userspace immediately before schedule().
At that specific point, it's not possible to take a page fault. In the proposed
rseq implementation, we get away with it by raising a task struct flag, and using
it in a return to userspace notifier (where we can actually take a fault), where
we touch the userspace TLS area.

If we can find a way to solve this limitation, then the rest of your design
makes sense to me.

Thanks!

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
