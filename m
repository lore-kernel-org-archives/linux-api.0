From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 5/6] nohz: support PR_DATAPLANE_STRICT mode
Date: Mon, 11 May 2015 15:28:35 -0700
Message-ID: <CALCETrW8aNOZmNKx8P=mCD2iZmjxjDFzZH4Yzmh5im9Werzw9g@mail.gmail.com>
References: <1431107927-13998-1-git-send-email-cmetcalf@ezchip.com>
 <1431107927-13998-6-git-send-email-cmetcalf@ezchip.com> <CALCETrUoptUPVUxL87jUgry1pFac0rDPpnZ790zDKyK4a0FARA@mail.gmail.com>
 <5550FF63.1030107@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <5550FF63.1030107@ezchip.com>
Sender: linux-doc-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@ezchip.com>, Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Christoph Lameter <cl@linux.com>, Gilad Ben Yossef <giladb@ezchip.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

[add peterz due to perf stuff]

On Mon, May 11, 2015 at 12:13 PM, Chris Metcalf <cmetcalf@ezchip.com> wrote:
> On 05/09/2015 03:28 AM, Andy Lutomirski wrote:
>>
>> On May 8, 2015 11:44 PM, "Chris Metcalf" <cmetcalf@ezchip.com> wrote:
>>>
>>> With QUIESCE mode, the task is in principle guaranteed not to be
>>> interrupted by the kernel, but only if it behaves.  In particular,
>>> if it enters the kernel via system call, page fault, or any of
>>> a number of other synchronous traps, it may be unexpectedly
>>> exposed to long latencies.  Add a simple flag that puts the process
>>> into a state where any such kernel entry is fatal.
>>>
>>> To allow the state to be entered and exited, we add an internal
>>> bit to current->dataplane_flags that is set when prctl() sets the
>>> flags.  That way, when we are exiting the kernel after calling
>>> prctl() to forbid future kernel exits, we don't get immediately
>>> killed.
>>
>> Is there any reason this can't already be addressed in userspace using
>> /proc/interrupts or perf_events?  ISTM the real goal here is to detect
>> when we screw up and fail to avoid an interrupt, and killing the task
>> seems like overkill to me.
>
>
> Patch 6/6 proposes a mechanism to track down times when the
> kernel screws up and delivers an IRQ to a userspace-only task.
> Here, we're just trying to identify the times when an application
> screws itself up out of cluelessness, and provide a mechanism
> that allows the developer to easily figure out why and fix it.
>
> In particular, /proc/interrupts won't show syscalls or page faults,
> which are two easy ways applications can screw themselves
> when they think they're in userspace-only mode.  Also, they don't
> provide sufficient precision to make it clear what part of the
> application caused the undesired kernel entry.

Perf does, though, complete with context.

>
> In this case, killing the task is appropriate, since that's exactly
> the semantics that have been asked for - it's like on architectures
> that don't natively support unaligned accesses, but fake it relatively
> slowly in the kernel, and in development you just say "give me a
> SIGBUS when that happens" and in production you might say
> "fix it up and let's try to keep going".

I think more control is needed.  I also think that, if we go this
route, we should distinguish syscalls, synchronous non-syscall
entries, and asynchronous non-syscall entries.  They're quite
different.

>
> You can argue that this is something that can be done by ftrace,
> but certainly you'd want to have a way to programmatically
> turn on ftrace at the moment when you're entering userspace-only
> mode, so we'd want some API around that anyway.  And honestly,
> it's so easy to test a task state bit in a couple of places and
> generate the failurel on the spot, vs. the relative complexity
> of setting up and understanding ftrace, that I think it merits
> inclusion on that basis alone.

perf_event, not ftrace.

>
>> Also, can we please stop further torturing the exit paths?  We have a
>> disaster of assembly code that calls into syscall_trace_leave and
>> do_notify_resume.  Those functions, in turn, *both* call user_enter
>> (WTF?), and on very brief inspection user_enter makes it into the nohz
>> code through multiple levels of indirection, which, with these
>> patches, has yet another conditionally enabled helper, which does this
>> new stuff.  It's getting to be impossible to tell what happens when we
>> exit to user space any more.
>>
>> Also, I think your code is buggy.  There's no particular guarantee
>> that user_enter is only called once between sys_prctl and the final
>> exit to user mode (see the above WTF), so you might spuriously kill
>> the process.
>
>
> This is a good point; I also find the x86 kernel entry and exit
> paths confusing, although I've reviewed them a bunch of times.
> The tile architecture paths are a little easier to understand.
>
> That said, I think the answer here is avoid non-idempotent
> actions in the dataplane code, such as clearing a syscall bit.
>
> A better implementation, I think, is to put the tests for "you
> screwed up and synchronously entered the kernel" in
> the syscall_trace_enter() code, which TIF_NOHZ already
> gets us into;

No, not unless you're planning on using that to distinguish syscalls
from other stuff *and* people think that's justified.

It's far to easy to just make a tiny change to the entry code.  Add a
tiny trivial change here, a few lines of asm (that's you, audit!)
there, some weird written-in-asm scheduling code over here, and you
end up with the truly awful mess that we currently have.

If it really makes sense for this stuff to go with context tracking,
then fine, but we should *fix* the context tracking first rather than
kludging around it.  I already have a prototype patch for the relevant
part of that.

> there, we can test if the dataplane "strict" bit is
> set and the syscall is not prctl(), then we generate the error.
> (We'd exclude exit and exit_group here too, since we don't
> need to shoot down a task that's just trying to kill itself.)
> This needs a bit of platform-specific code for each platform,
> but that doesn't seem like too big a problem.

I'd rather avoid that, too.  This feature isn't really arch-specific,
so let's avoid the arch stuff if at all possible.

>
> Likewise we can test in exception_enter() since that's only
> called for all the synchronous user entries like page faults.

Let's try to generalize a bit.  There's also irq_entry and ist_enter,
and some of the exception_enter cases are for synchronous entries
while (IIRC -- could be wrong) others aren't always like that.

>
>> Also, I think that most users will be quite surprised if "strict
>> dataplane" code causes any machine check on the system to kill your
>> dataplane task.
>
>
> Fair point, and avoided by testing as described above instead.
> (Though presumably in development it's not such a big deal,
> and as I said you'd likely turn it off in production.)

Until you forget to turn it off in production because it worked so
nicely in development.

What if we added a mode to perf where delivery of a sample
synchronously (or semi-synchronously by catching it on the next exit
to userspace) freezes the delivering task?  It would be like debugger
support via perf.

peterz, do you think this would be a sensible thing to add to perf?
It would only make sense for some types of events (tracepoints and
hw_breakpoints mostly, I think).

>> So, I don't know if it is a practical suggestion or not, but would it
>> better/easier to mark a pending signal on kernel entry for this case?
>> The upsides I see is that the user gets her notification (killing the task
>> or just logging the event in a signal handler) and hopefully since return to
>> userspace with a pending signal is already handled we don't need new code in
>> the exit path?
>
>
> We could certainly do this now that I'm planning to do the
> test at kernel entry rather than super-late in kernel exit.
> Rather than just do_group_exit(SIGKILL), we should raise
> a proper SIGKILL signal via send_sig(SIGKILL, current, 1),
> and then we could catch it in the debugger; the pc should
> help identify if it was a syscall, page fault, or other trap.
>
> I'm not sure there's an argument to be made for the user
> process being able to catch the signal itself; presumably in
> production you don't turn this mode on anyway, and in
> development, assuming a debugger is probably fine.
>
> But if you want to argue for another signal (SIGILL?) please
> do; I'm curious to hear if you think it would make more sense.

Make it configurable as part of the prctl.

--Andy
