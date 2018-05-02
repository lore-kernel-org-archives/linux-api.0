From: Daniel Colascione <dancol@google.com>
Subject: Re: [RFC PATCH for 4.18 00/14] Restartable Sequences
Date: Wed, 02 May 2018 16:07:48 +0000
Message-ID: <CAKOZueu_7Ha_WXMyxqMEScXo1aHWr9qYRxqyb-Rpd4k1JP3xHA@mail.gmail.com>
References: <20180430224433.17407-1-mathieu.desnoyers@efficios.com>
 <CAKOZuesa338sc_=w6-wvro25idrSN_zx_zrHFyo-bDiORs7FZw@mail.gmail.com> <660904075.9201.1525276988842.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <660904075.9201.1525276988842.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, boqun.feng@gmail.com, luto@amacapital.net, davejwatson@fb.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux@arm.linux.org.uk, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, Andrew Hunter <ahh@google.com>, andi@firstfloor.org, cl@linux.com, bmaurer@fb.com, rostedt@goodmis.org, josh@joshtriplett.org, torvalds@linux-foundation.org, catalin.marinas@arm.com, will.deacon@arm.com, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Joel Fernandes <joelaf@google.com>
List-Id: linux-api@vger.kernel.org

On Wed, May 2, 2018 at 9:03 AM Mathieu Desnoyers <
mathieu.desnoyers@efficios.com> wrote:

> ----- On May 1, 2018, at 11:53 PM, Daniel Colascione dancol@google.com
wrote:
> [...]
> >
> > I think a small enhancement to rseq would let us build a perfect
userspace
> > mutex, one that spins on lock-acquire only when the lock owner is
running
> > and that sleeps otherwise, freeing userspace from both specifying ad-hoc
> > spin counts and from trying to detect situations in which spinning is
> > generally pointless.
> >
> > It'd work like this: in the per-thread rseq data structure, we'd
include a
> > description of a futex operation for the kernel would perform (in the
> > context of the preempted thread) upon preemption, immediately before
> > schedule(). If the futex operation itself sleeps, that's no problem: we
> > will have still accomplished our goal of running some other thread
instead
> > of the preempted thread.

> Hi Daniel,

> I agree that the problem you are aiming to solve is important. Let's see
> what prevents the proposed rseq implementation from doing what you
envision.

> The main issue here is touching userspace immediately before schedule().
> At that specific point, it's not possible to take a page fault. In the
proposed
> rseq implementation, we get away with it by raising a task struct flag,
and using
> it in a return to userspace notifier (where we can actually take a
fault), where
> we touch the userspace TLS area.

> If we can find a way to solve this limitation, then the rest of your
design
> makes sense to me.

Thanks for taking a look!

Why couldn't we take a page fault just before schedule? The reason we can't
take a page fault in atomic context is that doing so might call schedule.
Here, we're about to call schedule _anyway_, so what harm does it do to
call something that might call schedule? If we schedule via that call, we
can skip the manual schedule we were going to perform.
