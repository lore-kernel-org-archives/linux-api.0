From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 5/6] nohz: support PR_DATAPLANE_STRICT mode
Date: Tue, 12 May 2015 15:23:02 -0700
Message-ID: <CALCETrXVLGi=DSHza2fCXDNbkh_MOAbxQANNg738=AWVMsYPrw@mail.gmail.com>
References: <1431107927-13998-1-git-send-email-cmetcalf@ezchip.com>
 <1431107927-13998-6-git-send-email-cmetcalf@ezchip.com> <CALCETrUoptUPVUxL87jUgry1pFac0rDPpnZ790zDKyK4a0FARA@mail.gmail.com>
 <5550FF63.1030107@ezchip.com> <CALCETrW8aNOZmNKx8P=mCD2iZmjxjDFzZH4Yzmh5im9Werzw9g@mail.gmail.com>
 <55526B39.10208@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <55526B39.10208@ezchip.com>
Sender: linux-doc-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@ezchip.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Frederic Weisbecker <fweisbec@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Christoph Lameter <cl@linux.com>, Gilad Ben Yossef <giladb@ezchip.com>, Ingo Molnar <mingo@kernel.org>
List-Id: linux-api@vger.kernel.org

On May 13, 2015 6:06 AM, "Chris Metcalf" <cmetcalf@ezchip.com> wrote:
>
> On 05/11/2015 06:28 PM, Andy Lutomirski wrote:
>>
>> [add peterz due to perf stuff]
>>
>> On Mon, May 11, 2015 at 12:13 PM, Chris Metcalf <cmetcalf@ezchip.com> wrote:
>>>
>>> Patch 6/6 proposes a mechanism to track down times when the
>>> kernel screws up and delivers an IRQ to a userspace-only task.
>>> Here, we're just trying to identify the times when an application
>>> screws itself up out of cluelessness, and provide a mechanism
>>> that allows the developer to easily figure out why and fix it.
>>>
>>> In particular, /proc/interrupts won't show syscalls or page faults,
>>> which are two easy ways applications can screw themselves
>>> when they think they're in userspace-only mode.  Also, they don't
>>> provide sufficient precision to make it clear what part of the
>>> application caused the undesired kernel entry.
>>
>> Perf does, though, complete with context.
>
>
> The perf_event suggestions are interesting, but I think it's plausible
> for this to be an alternate way to debug the issues that STRICT
> addresses.
>
>
>>> In this case, killing the task is appropriate, since that's exactly
>>> the semantics that have been asked for - it's like on architectures
>>> that don't natively support unaligned accesses, but fake it relatively
>>> slowly in the kernel, and in development you just say "give me a
>>> SIGBUS when that happens" and in production you might say
>>> "fix it up and let's try to keep going".
>>
>> I think more control is needed.  I also think that, if we go this
>> route, we should distinguish syscalls, synchronous non-syscall
>> entries, and asynchronous non-syscall entries.  They're quite
>> different.
>
>
> I don't think it's necessary to distinguish the types.  As long as we
> have a PC pointing to the instruction that triggered the problem,
> we can see if it's a system call instruction, a memory write that
> caused a page fault, a trap instruction, etc.

Not true.  PC right after a syscall insn could be any type of kernel
entry, and you can't even reliably tell whether the syscall insn was
executed or, on x86, whether it was a syscall at all.  (x86 insns
can't be reliably decided backwards.)

PC pointing at a load could be a page fault or an IPI.

> We certainly could
> add infrastructure to capture syscall numbers, fault/signal numbers,
> etc etc, but I think it's overkill if it adds kernel overhead on
> entry/exit.
>

None of these should add overhead.

>
>>> A better implementation, I think, is to put the tests for "you
>>> screwed up and synchronously entered the kernel" in
>>> the syscall_trace_enter() code, which TIF_NOHZ already
>>> gets us into;
>>
>> No, not unless you're planning on using that to distinguish syscalls
>> from other stuff *and* people think that's justified.
>
>
> So, the question is how we separate synchronous entries
> from IRQs?  At a high level, IRQs are kernel bugs (for cpu-isolated
> tasks), and synchronous entries are application bugs.  We'd
> like to deliver a signal for the latter, and do some kind of
> kernel diagnostics for the former.  So we can't just add the
> test in the context tracking code, which doesn't actually know
> why we're entering or exiting.

Synchronous entries could be VM bugs, too.

>
> That's why I was thinking that the syscall_trace_entry and
> exception_enter paths were the best choices.  I'm fairly sure
> that exception_enter is only done for synchronous traps,
> page faults, etc.

Maybe.  Doing it through the actual entry/exit slow paths would be
overhead-free, although I'm not sure that IRQs have real slow paths
for entry.

>
> Certainly on the tile architecture we include the trap number
> in the pt_regs, so it's possible to just examine the pt_regs and
> know why you entered or are exiting the kernel, but I don't
> think we can rely on that for all architectures.

x86 can't do this.

> I'll put out a v2 of my patch that does both the things you
> advise against :-) just so we can have a strawman to think
> about how to do it better - unless you have a suggestion
> offhand as to how we can better differentiate sync and async
> entries into the kernel in a platform-independent way.
>
> I could imagine modifying user_exit() and exception_enter()
> to pass an identifier into the context system saying why they
> were changing contexts, so we could have syscalls, trap
> numbers, fault numbers, etc., and some way to query as
> to whether they were synchronous or asynchronous, and
> build this scheme on top of that, but I'm not sure the extra
> infrastructure is worthwhile.
>

I'll take a look.

Again, though, I think we really do need to distinguish at least MCE
and NMI (on x86) from the others.

>
>> What if we added a mode to perf where delivery of a sample
>> synchronously (or semi-synchronously by catching it on the next exit
>> to userspace) freezes the delivering task?  It would be like debugger
>> support via perf.
>>
>> peterz, do you think this would be a sensible thing to add to perf?
>> It would only make sense for some types of events (tracepoints and
>> hw_breakpoints mostly, I think).
>
>
> I suspect it's reasonable to consider this orthogonal, particularly
> if there is some skid between the actual violation by the
> application, and the freeze happening.
>

I think it could be done without skid, except for async entries, but
for asynx entries we don't care about exact user state anyway.

> You pushed back somewhat on prctl() in favor of a quiesce()
> syscall in your email, but it seemed like at the end of your
> email you were adopting the prctl() perspective.  Is that true?
> I admit the prctl() still seems cleaner from my perspective.
>

Prctl for the strict thing seems much more reasonable to me than prctl
for quiescing.  Also, the scheduler people seem to thing that
quiescing should be automatic.

Anyway, I'll happily look at code and maybe even write more coherent
emails when I'm back in town in a week.  Since you're thinking that
async entries should give kernel diagnostics instead of signals, maybe
the right thing to do is to separate them out completely and try to
address the individual entry types separately and as needed.

--Andy
