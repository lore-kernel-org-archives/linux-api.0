From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC PATCH v7 1/7] Restartable sequences system call
Date: Wed, 3 Aug 2016 09:37:57 -0700
Message-ID: <CALCETrWw0M9YLWTR7_ruxY8cW9_5XRONdw1QN+_pBp0Y63L8pA@mail.gmail.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1469135662-31512-2-git-send-email-mathieu.desnoyers@efficios.com>
 <CALCETrVq3hgLbADcx_4g6gGgp7Hf-WnnWA8gg68tPZTv2wfbDg@mail.gmail.com>
 <1806206514.82247.1469502139408.JavaMail.zimbra@efficios.com> <20160803122717.GL6862@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160803122717.GL6862@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Boqun Feng <boqun.feng@gmail.com>
List-Id: linux-api@vger.kernel.org

On Wed, Aug 3, 2016 at 5:27 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Jul 26, 2016 at 03:02:19AM +0000, Mathieu Desnoyers wrote:
>> We really care about preemption here. Every migration implies a
>> preemption from a user-space perspective. If we would only care
>> about keeping the CPU id up-to-date, hooking into migration would be
>> enough. But since we want atomicity guarantees for restartable
>> sequences, we need to hook into preemption.
>
>> It allows user-space to perform update operations on per-cpu data without
>> requiring heavy-weight atomic operations.
>
> Well, a CMPXCHG without LOCK prefix isn't all that expensive on x86.
>
> It is however on PPC and possibly other architectures, so in name of
> simplicity supporting only the one variant makes sense.
>

I wouldn't want to depend on CMPXCHG.  But imagine we had primitives
that were narrower than the full abort-on-preemption primitive.
Specifically, suppose we had abort if (actual cpu != expected_cpu ||
*aptr != aval).  We could do things like:

expected_cpu = cpu;
aval = NULL;  // disarm for now
begin();
aval = event_count[cpu] + 1;
event_count[cpu] = aval;
event_count[cpu]++;

... compute something ...

// arm the rest of it
aptr = &event_count[cpu];
if (*aptr != aval)
  goto fail;

*thing_im_writing = value_i_computed;
end();

The idea here is that we don't rely on the scheduler to increment the
event count at all, which means that we get to determine the scope of
what kinds of access conflicts we care about ourselves.

This has an obvious downside: it's more complicated.

It has several benefits, I think.  It's debuggable without hassle
(unless someone, accidentally or otherwise, sets aval incorrectly).
It also allows much longer critical sections to work well, as merely
being preempted in the middle won't cause an abort any more.

So I'm hoping to understand whether we could make something like this
work.  This whole thing is roughly equivalent to abort-if-migrated
plus an atomic "if (*aptr == aval) *b = c;" operation.

(I think that, if this worked, we could improve it a bit by making the
abort operation jump back to the "if (*aptr != aval) goto fail;" code,
which should reduce the scope for error a bit and also reduces the
need for extra code paths that only execute on an abort.)
