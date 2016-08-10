From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH v7 1/7] Restartable sequences system call
Date: Wed, 10 Aug 2016 17:33:44 +0000 (UTC)
Message-ID: <1918884375.7403.1470850424697.JavaMail.zimbra@efficios.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com> <CALCETrVq3hgLbADcx_4g6gGgp7Hf-WnnWA8gg68tPZTv2wfbDg@mail.gmail.com> <1806206514.82247.1469502139408.JavaMail.zimbra@efficios.com> <20160803122717.GL6862@twins.programming.kicks-ass.net> <CALCETrWw0M9YLWTR7_ruxY8cW9_5XRONdw1QN+_pBp0Y63L8pA@mail.gmail.com> <20160804042710.GA13232@tardis.cn.ibm.com> <CALCETrW7t89BWXW5JbWyLVciKS1HJMXe7feopM31wkqL4AtoFA@mail.gmail.com> <20160809161328.GA1740@tardis.cn.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160809161328.GA1740@tardis.cn.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boqun Feng <boqun.feng@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

----- On Aug 9, 2016, at 12:13 PM, Boqun Feng boqun.feng@gmail.com wrote:

<snip>

> 
> However, I'm thinking maybe we can use some tricks to avoid unnecessary
> aborts-on-preemption.
> 
> First of all, I notice we haven't make any constraint on what kind of
> memory objects could be "protected" by rseq critical sections yet. And I
> think this is something we should decide before adding this feature into
> kernel.
> 
> We can do some optimization if we have some constraints. For example, if
> the memory objects inside the rseq critical sections could only be
> modified by userspace programs, we therefore don't need to abort
> immediately when userspace task -> kernel task context switch.

The rseq_owner per-cpu variable and rseq_cpu field in task_struct you
propose below would indeed take care of this scenario.

> 
> Further more, if the memory objects inside the rseq critical sections
> could only be modified by userspace programs that have registered their
> rseq structures, we don't need to abort immediately between the context
> switches between two rseq-unregistered tasks or one rseq-registered
> task and one rseq-unregistered task.
> 
> Instead, we do tricks as follow:
> 
> defining a percpu pointer in kernel:
> 
> DEFINE_PER_CPU(struct task_struct *, rseq_owner);
> 
> and a cpu field in struct task_struct:
> 
>	struct task_struct {
>	...
>	#ifdef CONFIG_RSEQ
>		struct rseq __user *rseq;
>		uint32_t rseq_event_counter;
>		int rseq_cpu;
>	#endif
>	...
>	};
> 
> (task_struct::rseq_cpu should be initialized as -1.)
> 
> each time at sched out(in rseq_sched_out()), we do something like:
> 
>	if (prev->rseq) {
>		raw_cpu_write(rseq_owner, prev);
>		prev->rseq_cpu = smp_processor_id();
>	}
> 
> each time sched in(in rseq_handle_notify_resume()), we do something
> like:
> 
>	if (current->rseq &&
>	    (this_cpu_read(rseq_owner) != current ||
>	     current->rseq_cpu != smp_processor_id()))
>		__rseq_handle_notify_resume(regs);
> 
> (Also need to modify rseq_signal_deliver() to call
> __rseq_handle_notify_resume() directly).
> 
> 
> I think this could save some unnecessary aborts-on-preemption, however,
> TBH, I'm too sleepy to verify every corner case. Will recheck this
> tomorrow.

This adds extra fields to the task struct, per-cpu rseq_owner pointers,
and hooks into sched_in which are not needed otherwise, all this to
eliminate unneeded abort-on-preemption.

If we look at the single-stepping use-case, this means that gdb would
only be able to single-step applications as long as neither itself, nor
any of its libraries, use rseq. This seems to be quite fragile. I prefer
requiring rseq users to implement a fallback to locking which progresses
in every situation rather than adding complexity and overhead trying
lessen the odds of triggering the restart.

Simply lessening the odds of triggering the restart without a design that
ensures progress even in restart cases seems to make the lack-of-progress
problem just harder to debug when it will surface in real life.

Thanks,

Mathieu

> 
> Regards,
> Boqun

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
