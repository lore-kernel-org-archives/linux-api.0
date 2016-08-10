From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC PATCH v7 1/7] Restartable sequences system call
Date: Wed, 10 Aug 2016 01:01:42 -0700
Message-ID: <CALCETrWrQWFg-r5+rhiSi3veoLiipxH+TJkTxKXkBpCahadV_g@mail.gmail.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1469135662-31512-2-git-send-email-mathieu.desnoyers@efficios.com>
 <CALCETrVq3hgLbADcx_4g6gGgp7Hf-WnnWA8gg68tPZTv2wfbDg@mail.gmail.com>
 <1806206514.82247.1469502139408.JavaMail.zimbra@efficios.com>
 <20160803122717.GL6862@twins.programming.kicks-ass.net> <CALCETrWw0M9YLWTR7_ruxY8cW9_5XRONdw1QN+_pBp0Y63L8pA@mail.gmail.com>
 <20160804042710.GA13232@tardis.cn.ibm.com> <CALCETrW7t89BWXW5JbWyLVciKS1HJMXe7feopM31wkqL4AtoFA@mail.gmail.com>
 <20160809161328.GA1740@tardis.cn.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160809161328.GA1740@tardis.cn.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boqun Feng <boqun.feng@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Tue, Aug 9, 2016 at 9:13 AM, Boqun Feng <boqun.feng@gmail.com> wrote:
> On Wed, Aug 03, 2016 at 10:03:32PM -0700, Andy Lutomirski wrote:
>> On Wed, Aug 3, 2016 at 9:27 PM, Boqun Feng <boqun.feng@gmail.com> wrote:
>> > On Wed, Aug 03, 2016 at 09:37:57AM -0700, Andy Lutomirski wrote:
>> >> On Wed, Aug 3, 2016 at 5:27 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> >> > On Tue, Jul 26, 2016 at 03:02:19AM +0000, Mathieu Desnoyers wrote:
>> >> >> We really care about preemption here. Every migration implies a
>> >> >> preemption from a user-space perspective. If we would only care
>> >> >> about keeping the CPU id up-to-date, hooking into migration would be
>> >> >> enough. But since we want atomicity guarantees for restartable
>> >> >> sequences, we need to hook into preemption.
>> >> >
>> >> >> It allows user-space to perform update operations on per-cpu data without
>> >> >> requiring heavy-weight atomic operations.
>> >> >
>> >> > Well, a CMPXCHG without LOCK prefix isn't all that expensive on x86.
>> >> >
>> >> > It is however on PPC and possibly other architectures, so in name of
>> >> > simplicity supporting only the one variant makes sense.
>> >> >
>> >>
>> >> I wouldn't want to depend on CMPXCHG.  But imagine we had primitives
>> >> that were narrower than the full abort-on-preemption primitive.
>> >> Specifically, suppose we had abort if (actual cpu != expected_cpu ||
>> >> *aptr != aval).  We could do things like:
>> >>
>> >> expected_cpu = cpu;
>> >> aval = NULL;  // disarm for now
>> >> begin();
>> >> aval = event_count[cpu] + 1;
>> >> event_count[cpu] = aval;
>> >> event_count[cpu]++;
>> >
>> > This line is redundant, right? Because it will guarantee a failure even
>> > in no-contention cases.
>> >
>> >>
>> >> ... compute something ...
>> >>
>> >> // arm the rest of it
>> >> aptr = &event_count[cpu];
>> >> if (*aptr != aval)
>> >>   goto fail;
>> >>
>> >> *thing_im_writing = value_i_computed;
>> >> end();
>> >>
>> >> The idea here is that we don't rely on the scheduler to increment the
>> >> event count at all, which means that we get to determine the scope of
>> >> what kinds of access conflicts we care about ourselves.
>> >>
>> >
>> > If we increase the event count in userspace, how could we prevent two
>> > userspace threads from racing on the event_count[cpu] field? For
>> > example:
>> >
>> >         CPU 0
>> >         ================
>> >         {event_count[0] is initially 0}
>> >
>> >         [Thread 1]
>> >         begin();
>> >         aval = event_count[cpu] + 1; // 1
>> >
>> >         (preempted)
>> >         [Thread 2]
>> >         begin();
>> >         aval = event_count[cpu] + 1; // 1, too
>> >         event_count[cpu] = aval; // event_count[0] is 1
>> >
>>
>> You're right :(  This would work with an xadd instruction, but that's
>> very slow and doesn't exist on most architectures.  It could also work
>> if we did:
>>
>> aval = some_tls_value++;
>>
>> where some_tls_value is set up such that no two threads could ever end
>> up with the same values (using high bits as thread ids, perhaps), but
>> that's messy.  Maybe my idea is no good.
>
> This is a little more complex, plus I failed to find a way to do an
> atomic "if (*aptr == aval) *b = c" in userspace ;-(
>

But the kernel might be able to help using something similar to this patchset.

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

True, although trying to do a syscall in an rseq critical section
seems like a bad idea in general.

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
>         struct task_struct {
>         ...
>         #ifdef CONFIG_RSEQ
>                 struct rseq __user *rseq;
>                 uint32_t rseq_event_counter;
>                 int rseq_cpu;
>         #endif
>         ...
>         };
>
> (task_struct::rseq_cpu should be initialized as -1.)
>
> each time at sched out(in rseq_sched_out()), we do something like:
>
>         if (prev->rseq) {
>                 raw_cpu_write(rseq_owner, prev);
>                 prev->rseq_cpu = smp_processor_id();
>         }
>
> each time sched in(in rseq_handle_notify_resume()), we do something
> like:
>
>         if (current->rseq &&
>             (this_cpu_read(rseq_owner) != current ||
>              current->rseq_cpu != smp_processor_id()))
>                 __rseq_handle_notify_resume(regs);
>
> (Also need to modify rseq_signal_deliver() to call
> __rseq_handle_notify_resume() directly).
>
>
> I think this could save some unnecessary aborts-on-preemption, however,
> TBH, I'm too sleepy to verify every corner case. Will recheck this
> tomorrow.

Interesting.  That could help a bit, although it would help less if
everyone started using rseq.

But do we need to protect MAP_SHARED objects?  If not, maybe we could
only track context switches between different tasks sharing the same
mm.

--Andy
