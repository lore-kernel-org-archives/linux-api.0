From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.15 v12 00/22] Restartable sequences and CPU op
 vector
Date: Thu, 23 Nov 2017 21:13:22 +0000 (UTC)
Message-ID: <2130360737.21248.1511471602798.JavaMail.zimbra@efficios.com>
References: <20171121141900.18471-1-mathieu.desnoyers@efficios.com> <20171121172144.GL2482@two.firstfloor.org> <740195164.19702.1511301908907.JavaMail.zimbra@efficios.com> <20171122193219.GI3165@worktop.lehotels.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171122193219.GI3165@worktop.lehotels.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will
List-Id: linux-api@vger.kernel.org

----- On Nov 22, 2017, at 2:32 PM, Peter Zijlstra peterz@infradead.org wrote:

> On Tue, Nov 21, 2017 at 10:05:08PM +0000, Mathieu Desnoyers wrote:
>> Other than that, I have not received any concrete alternative proposal to
>> properly handle single-stepping.
> 
> That's not entirely true; amluto did have an alternative in Prague: do
> full machine level instruction emulation till the end of the rseq when
> it gets 'preempted too often'.

Yes, that's right. Andy did propose that alternative at KS. Which is also
interpreter-based.

> 
> Yes, implementing that will be an absolute royal pain. But it does
> remove the whole duplicate/dual program asm/bytecode thing and avoids
> the syscall entirely.

Agreed on this being a royal pain that we'd have to do for each
architecture.

By the way, I figured an interesting library API that would remove the
need for code duplication for end-users:

e.g.

static inline __attribute__((always_inline))
int percpu_addv(intptr_t *v, intptr_t count, int cpu)
{
        rseq_addv(v, count, cpu);
        if (rseq_unlikely(rseq_addv(v, count, cpu)))
                return cpu_op_addv(v, count, cpu);
        return 0;
}

And the caller becomes:

                cpu = rseq_cpu_start();
                ret = percpu_addv(&data->c[cpu].count, 1, cpu);
                if (unlikely(ret)) {
                        perror("cpu_opv");
                        abort();
                }

So the caller does not even have to bother retrying in case of
rseq error, it's all handled by the "percpu_*()" static inlines.

> 
> And we don't need to do a full x86_64/arch-of-choice emulator for this
> either; just as cpu_opv is fairly limited too. We can do a subset that
> allows dealing with the known sequences and go from there -- it can
> always fall back to not emulating and reverting to the pure rseq with
> debug/fwd progress 'issues'.

I think trying to make the kernel ABI "developer-friendly" is the wrong
approach. This kind of ease-of-use sugar should be provided by a library,
not by the kernel ABI. The futex system call is a good example of low-level
syscall meant to be used by libraries rather than directly by end-users.

> So what exactly is the problem of leaving out the whole cpu_opv thing
> for now? Pure rseq is usable -- albeit a bit cumbersome without
> additional debugger support.

Then rseq will cover _some_ use-cases, but will miss many others.

One example is the reserve+commit lttng-ust ring buffer operations, where
the commit _needs_ to run on the same CPU as the reserve. Just rseq does
not allow a tracer library to do that, rseq+cpu_opv allow that just
fine.

So if I introduce just rseq for now, then all those other use-cases will
need to check whether the kernel supports cpu_opv or not as well, cache the
result into a variable, and it will add a forest of branches into those
fast paths. No thanks.

Also, turning both line-level and instruction-level single-stepping into
infinite loops looks pretty much like a new kernel facility that breaks
user-space. It's a no-go from my point of view.

Thanks,

Mathieu




-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
