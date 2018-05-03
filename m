From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18 00/14] Restartable Sequences
Date: Thu, 3 May 2018 12:12:21 -0400 (EDT)
Message-ID: <1718748931.10084.1525363941807.JavaMail.zimbra@efficios.com>
References: <20180430224433.17407-1-mathieu.desnoyers@efficios.com> <CAKOZuesa338sc_=w6-wvro25idrSN_zx_zrHFyo-bDiORs7FZw@mail.gmail.com> <660904075.9201.1525276988842.JavaMail.zimbra@efficios.com> <CAKOZueu_7Ha_WXMyxqMEScXo1aHWr9qYRxqyb-Rpd4k1JP3xHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZueu_7Ha_WXMyxqMEScXo1aHWr9qYRxqyb-Rpd4k1JP3xHA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <cata>
List-Id: linux-api@vger.kernel.org

----- On May 2, 2018, at 12:07 PM, Daniel Colascione dancol@google.com wrote:

> On Wed, May 2, 2018 at 9:03 AM Mathieu Desnoyers <
> mathieu.desnoyers@efficios.com> wrote:
> 
>> ----- On May 1, 2018, at 11:53 PM, Daniel Colascione dancol@google.com
> wrote:
>> [...]
>> >
>> > I think a small enhancement to rseq would let us build a perfect
> userspace
>> > mutex, one that spins on lock-acquire only when the lock owner is
> running
>> > and that sleeps otherwise, freeing userspace from both specifying ad-hoc
>> > spin counts and from trying to detect situations in which spinning is
>> > generally pointless.
>> >
>> > It'd work like this: in the per-thread rseq data structure, we'd
> include a
>> > description of a futex operation for the kernel would perform (in the
>> > context of the preempted thread) upon preemption, immediately before
>> > schedule(). If the futex operation itself sleeps, that's no problem: we
>> > will have still accomplished our goal of running some other thread
> instead
>> > of the preempted thread.
> 
>> Hi Daniel,
> 
>> I agree that the problem you are aiming to solve is important. Let's see
>> what prevents the proposed rseq implementation from doing what you
> envision.
> 
>> The main issue here is touching userspace immediately before schedule().
>> At that specific point, it's not possible to take a page fault. In the
> proposed
>> rseq implementation, we get away with it by raising a task struct flag,
> and using
>> it in a return to userspace notifier (where we can actually take a
> fault), where
>> we touch the userspace TLS area.
> 
>> If we can find a way to solve this limitation, then the rest of your
> design
>> makes sense to me.
> 
> Thanks for taking a look!
> 
> Why couldn't we take a page fault just before schedule? The reason we can't
> take a page fault in atomic context is that doing so might call schedule.
> Here, we're about to call schedule _anyway_, so what harm does it do to
> call something that might call schedule? If we schedule via that call, we
> can skip the manual schedule we were going to perform.

By the way, if we eventually find a way to enhance user-space mutexes in the
fashion you describe here, it would belong to another TLS area, and would
be registered by another system call than rseq. I proposed a more generic
"TLS area registration" system call a few years ago, but Linus told me he
wanted a system call that was specific to rseq. If we need to implement
other use-cases in a TLS area shared between kernel and user-space in a
similar fashion, the plan is to do it in a distinct system call.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
