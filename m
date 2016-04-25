From: Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v9 04/13] task_isolation: add initial support
Date: Mon, 25 Apr 2016 16:36:25 -0400
Message-ID: <571E7FC9.60405@mellanox.com>
References: <20160119154214.GA2722@lerouge> <569EA050.5030106@ezchip.com>
 <20160128002801.GA14313@lerouge> <56ABACDD.5090500@ezchip.com>
 <20160130211125.GB7856@lerouge> <56BCDFE9.10200@ezchip.com>
 <20160304125603.GA23906@lerouge> <56E07BF0.3060509@mellanox.com>
 <20160408135622.GD24956@lerouge> <5707DDA8.10600@mellanox.com>
 <20160422131642.GA27722@lerouge>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160422131642.GA27722@lerouge>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 4/22/2016 9:16 AM, Frederic Weisbecker wrote:
> On Fri, Apr 08, 2016 at 12:34:48PM -0400, Chris Metcalf wrote:
>> On 4/8/2016 9:56 AM, Frederic Weisbecker wrote:
>>> On Wed, Mar 09, 2016 at 02:39:28PM -0500, Chris Metcalf wrote:
>>>>    TL;DR: Let's make an explicit decision about whether task isolation
>>>>    should be "persistent" or "one-shot".  Both have some advantages.
>>>>    =====
>>>>
>>>> An important high-level issue is how "sticky" task isolation mode is.
>>>> We need to choose one of these two options:
>>>>
>>>> "Persistent mode": A task switches state to "task isolation" mode
>>>> (kind of a level-triggered analogy) and stays there indefinitely.  It
>>>> can make a syscall, take a page fault, etc., if it wants to, but the
>>>> kernel protects it from incurring any further asynchronous interrupts.
>>>> This is the model I've been advocating for.
>>> But then in this mode, what happens when an interrupt triggers.
>> So here I'm taking "interrupt" to mean an external, asynchronous
>> interrupt, from another core or device, or asynchronously triggered
>> on the local core, like a timer interrupt.  By contrast I use "exception"
>> or "fault" to refer to synchronous, locally-triggered interruptions.
> Ok.
>
>> So for interrupts, the short answer is, it's a bug! :-)
>>
>> An interrupt could be a kernel bug, in which case we consider it a
>> "true" bug.  This could be a timer interrupt occurring even after the
>> task isolation code thought there were none pending, or a hardware
>> device that incorrectly distributes interrupts to a task-isolation
>> cpu, or a global IPI that should be sent to fewer cores, or a kernel
>> TLB flush that could be deferred until the task-isolation task
>> re-enters the kernel later, etc.  Regardless, I'd consider it a kernel
>> bug.  I'm sure there are more such bugs that we can continue to fix
>> going forward; it depends on how arbitrary you want to allow code
>> running on other cores to be.  For example, can another core unload a
>> kernel module without interrupting a task-isolation task?  Not right now.
>>
>> Or, it could be an application bug: the standard example is if you
>> have an application with task-isolated cores that also does occasional
>> unmaps on another thread in the same process, on another core.  This
>> causes TLB flush interrupts under application control.  The
>> application shouldn't do this, and we tell our customers not to build
>> their applications this way.  The typical way we encourage our
>> customers to arrange this kind of "multi-threading" is by having a
>> pure memory API between the task isolation threads and what are
>> typically "control" threads running on non-task-isolated cores.  The
>> two types of threads just both mmap some common, shared memory but run
>> as different processes.
>>
>> So what happens if an interrupt does occur?
>>
>> In the "base" task isolation mode, you just take the interrupt, then
>> wait to quiesce any further kernel timer ticks, etc., and return to
>> the process.  This at least limits the damage to being a single
>> interruption rather than potentially additional ones, if the interrupt
>> also caused timers to get queued, etc.
> So if we take an interrupt that we didn't expect, we want to wait some more
> in the end of that interrupt to wait for things to quiesce some more?

I think it's actually pretty plausible.

Consider the "application bug" case, where you're running some code that does
packet dispatch to different cores.  If a core seems to back up you stop
dispatching packets to it.

Now, we get a TLB flush.  If handling the flush causes us to restart the tick
(maybe just as a side effect of entering the kernel in the first place) we
really are better off staying in the kernel until the tick is handled and
things are quiesced again.  That way, although we may end up dropping a
bunch of packets that were queued up to that core, we only do so ONCE - we
don't do it again when the tick fires a little bit later on, when the core
has already caught up and is claiming to be able to handle packets again.

Also, pragmatically, we would require a whole bunch of machinery in the
kernel to figure out whether we were returning from a syscall, an exception,
or an interrupt, and only skip the task-isolation work for interrupts.  We
don't actually have that information available to us at the moment we are
returning to userspace right now, so we'd need to add that tracking state
in each platform's code somehow.


> That doesn't look right. Things should be quiesced once and for all on
> return from the initial prctl() call. We can't even expect to quiesce more
> in case of interruptions, the tick can't be forced off anyway.

Yes, things are quiesced once and for all after prctl().  We also need to
be prepared to handle unexpected interrupts, though.  It's true that we can't
force the tick off, but as I suggested above, just waiting for the tick may
well be a better strategy than subjecting the application to another interrupt
after some fraction of a second.

>> Or, you can enable "strict" mode, and then you get hard isolation
>> without the ability to get in and out of the kernel at all: the kernel
>> just kills you if you try to leave hard isolation other than by an
>> explicit prctl().
> That would be extreme strict mode yeah. We can still add such mode later
> if any user request it.

So, humorously, I have become totally convinced that "extreme strict mode"
is really the right default for isolation.  It gives semantics that are easily
understandable: you stay in userspace until you do a prctl() to turn off
the flag, or exit(), or else the kernel kills you.  And, it's probably what
people want by default anyway for userspace driver code.  For code that
legitimately wants to make syscalls in this mode, you can just prctl() the
mode off, do whatever you need to do, then prctl() the mode back on again.
It's nominally a bit of overhead, but as a task-isolated application you
should be expecting tons of overhead from going into the kernel anyway.

The "less extreme strict mode" is arguably reasonable if you want to allow
people to make occasional syscalls, but it has confusing performance
characteristics (sometimes the syscalls happen quickly, but sometimes they
take multiple ticks while we wait for interrupts to quiesce), and it has
confusing semantics (what happens if a third party re-affinitizes you to
a non-isolated core).  So I like the idea of just having a separate flag
(PR_TASK_ISOLATION_NOSIG) that tells the kernel to let the user play in
the kernel without getting killed.

> (I'll reply the rest of the email soonish)

Thanks for the feedback.  It makes me feel like we may get there eventually :-)

-- 
Chris Metcalf, Mellanox Technologies
http://www.mellanox.com
