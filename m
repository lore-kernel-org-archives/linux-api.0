From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: Re: [PATCH 5/6] nohz: support PR_DATAPLANE_STRICT mode
Date: Tue, 12 May 2015 17:06:01 -0400
Message-ID: <55526B39.10208@ezchip.com>
References: <1431107927-13998-1-git-send-email-cmetcalf@ezchip.com> <1431107927-13998-6-git-send-email-cmetcalf@ezchip.com> <CALCETrUoptUPVUxL87jUgry1pFac0rDPpnZ790zDKyK4a0FARA@mail.gmail.com> <5550FF63.1030107@ezchip.com> <CALCETrW8aNOZmNKx8P=mCD2iZmjxjDFzZH4Yzmh5im9Werzw9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrW8aNOZmNKx8P=mCD2iZmjxjDFzZH4Yzmh5im9Werzw9g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>, Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Christoph Lameter <cl@linux.com>, Gilad Ben Yossef <giladb@ezchip.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 05/11/2015 06:28 PM, Andy Lutomirski wrote:
> [add peterz due to perf stuff]
>
> On Mon, May 11, 2015 at 12:13 PM, Chris Metcalf <cmetcalf@ezchip.com> wrote:
>> Patch 6/6 proposes a mechanism to track down times when the
>> kernel screws up and delivers an IRQ to a userspace-only task.
>> Here, we're just trying to identify the times when an application
>> screws itself up out of cluelessness, and provide a mechanism
>> that allows the developer to easily figure out why and fix it.
>>
>> In particular, /proc/interrupts won't show syscalls or page faults,
>> which are two easy ways applications can screw themselves
>> when they think they're in userspace-only mode.  Also, they don't
>> provide sufficient precision to make it clear what part of the
>> application caused the undesired kernel entry.
> Perf does, though, complete with context.

The perf_event suggestions are interesting, but I think it's plausible
for this to be an alternate way to debug the issues that STRICT
addresses.

>> In this case, killing the task is appropriate, since that's exactly
>> the semantics that have been asked for - it's like on architectures
>> that don't natively support unaligned accesses, but fake it relatively
>> slowly in the kernel, and in development you just say "give me a
>> SIGBUS when that happens" and in production you might say
>> "fix it up and let's try to keep going".
> I think more control is needed.  I also think that, if we go this
> route, we should distinguish syscalls, synchronous non-syscall
> entries, and asynchronous non-syscall entries.  They're quite
> different.

I don't think it's necessary to distinguish the types.  As long as we
have a PC pointing to the instruction that triggered the problem,
we can see if it's a system call instruction, a memory write that
caused a page fault, a trap instruction, etc.  We certainly could
add infrastructure to capture syscall numbers, fault/signal numbers,
etc etc, but I think it's overkill if it adds kernel overhead on
entry/exit.

>> A better implementation, I think, is to put the tests for "you
>> screwed up and synchronously entered the kernel" in
>> the syscall_trace_enter() code, which TIF_NOHZ already
>> gets us into;
> No, not unless you're planning on using that to distinguish syscalls
> from other stuff *and* people think that's justified.

So, the question is how we separate synchronous entries
from IRQs?  At a high level, IRQs are kernel bugs (for cpu-isolated
tasks), and synchronous entries are application bugs.  We'd
like to deliver a signal for the latter, and do some kind of
kernel diagnostics for the former.  So we can't just add the
test in the context tracking code, which doesn't actually know
why we're entering or exiting.

That's why I was thinking that the syscall_trace_entry and
exception_enter paths were the best choices.  I'm fairly sure
that exception_enter is only done for synchronous traps,
page faults, etc.

Certainly on the tile architecture we include the trap number
in the pt_regs, so it's possible to just examine the pt_regs and
know why you entered or are exiting the kernel, but I don't
think we can rely on that for all architectures.

> It's far to easy to just make a tiny change to the entry code.  Add a
> tiny trivial change here, a few lines of asm (that's you, audit!)
> there, some weird written-in-asm scheduling code over here, and you
> end up with the truly awful mess that we currently have.
>
> If it really makes sense for this stuff to go with context tracking,
> then fine, but we should *fix* the context tracking first rather than
> kludging around it.  I already have a prototype patch for the relevant
> part of that.
>
>> there, we can test if the dataplane "strict" bit is
>> set and the syscall is not prctl(), then we generate the error.
>> (We'd exclude exit and exit_group here too, since we don't
>> need to shoot down a task that's just trying to kill itself.)
>> This needs a bit of platform-specific code for each platform,
>> but that doesn't seem like too big a problem.
> I'd rather avoid that, too.  This feature isn't really arch-specific,
> so let's avoid the arch stuff if at all possible.

I'll put out a v2 of my patch that does both the things you
advise against :-) just so we can have a strawman to think
about how to do it better - unless you have a suggestion
offhand as to how we can better differentiate sync and async
entries into the kernel in a platform-independent way.

I could imagine modifying user_exit() and exception_enter()
to pass an identifier into the context system saying why they
were changing contexts, so we could have syscalls, trap
numbers, fault numbers, etc., and some way to query as
to whether they were synchronous or asynchronous, and
build this scheme on top of that, but I'm not sure the extra
infrastructure is worthwhile.

>> Likewise we can test in exception_enter() since that's only
>> called for all the synchronous user entries like page faults.
> Let's try to generalize a bit.  There's also irq_entry and ist_enter,
> and some of the exception_enter cases are for synchronous entries
> while (IIRC -- could be wrong) others aren't always like that.

I don't think we need to generalize this piece.  irq_entry()
shouldn't be reported by the STRICT mechanism but by
kernel bug reporting.  For ist_enter(), it looks like if you're
coming from userspace it's just handled with exception_enter().
I'm more familiar with the tile architecture mechanisms than
with x86, though, to be honest.

>>> Also, I think that most users will be quite surprised if "strict
>>> dataplane" code causes any machine check on the system to kill your
>>> dataplane task.
>>
>> Fair point, and avoided by testing as described above instead.
>> (Though presumably in development it's not such a big deal,
>> and as I said you'd likely turn it off in production.)
> Until you forget to turn it off in production because it worked so
> nicely in development.

I guess that's an argument for using a non-fatal signal with a
handler from the get-go, since then even in production you'll
just end up with a slightly heavier-weight kernel overhead
(whatever stupid thing your application did, plus the time
spent in the signal handler), but then after that you can get
back to processing packets or whatever the app is doing.

You had mentioned some alternatives to a catchable signal
(a signal to some other process, or queuing to an fd); I think
it still seems reasonable to just deliver a signal to the process,
configurably by the prctl, and not do anything more complex.
Does this seem reasonable to you at this point?

> What if we added a mode to perf where delivery of a sample
> synchronously (or semi-synchronously by catching it on the next exit
> to userspace) freezes the delivering task?  It would be like debugger
> support via perf.
>
> peterz, do you think this would be a sensible thing to add to perf?
> It would only make sense for some types of events (tracepoints and
> hw_breakpoints mostly, I think).

I suspect it's reasonable to consider this orthogonal, particularly
if there is some skid between the actual violation by the
application, and the freeze happening.

You pushed back somewhat on prctl() in favor of a quiesce()
syscall in your email, but it seemed like at the end of your
email you were adopting the prctl() perspective.  Is that true?
I admit the prctl() still seems cleaner from my perspective.

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com
