From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v9 04/13] task_isolation: add initial support
Date: Tue, 5 Jul 2016 16:41:09 +0200
Message-ID: <20160705144107.GC5332@lerouge>
References: <20160130211125.GB7856@lerouge>
 <56BCDFE9.10200@ezchip.com>
 <20160304125603.GA23906@lerouge>
 <56E07BF0.3060509@mellanox.com>
 <20160408135622.GD24956@lerouge>
 <5707DDA8.10600@mellanox.com>
 <20160526010656.GB17245@lerouge>
 <4e96ef87-c254-3357-3c7e-cd97ccb6ce56@mellanox.com>
 <20160629151810.GA28724@lerouge>
 <25c4ace1-6903-abb3-59e9-aedc11ac32fc@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <25c4ace1-6903-abb3-59e9-aedc11ac32fc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Jul 01, 2016 at 04:59:26PM -0400, Chris Metcalf wrote:
> On 6/29/2016 11:18 AM, Frederic Weisbecker wrote:
> >
> >I just feel that quiescing, on the way back to user after an unwanted
> >interruption, is awkward. The quiescing should work once and for all
> >on return back from the prctl. If we still get disturbed afterward,
> >either the quiescing is buggy or incomplete, or something is on the
> >way that can not be quiesced.
> 
> If we are thinking of an initial implementation that doesn't allow any
> subsequent kernel entry to be valid, then this all gets much easier,
> since any subsequent kernel entry except for a prctl() syscall will
> result in a signal, which will turn off task isolation, and we will
> never have to worry about additional quiescing.  I think that's where
> we got from the discussion at the bottom of this email.

Right.

> 
> So for your question here, we're really just thinking about future
> directions as far as how to handle interrupts, and if in the future we
> add support for allowing syscalls and/or exceptions without leaving
> task isolation mode, then we have to think about how that interacts
> with interrupts.  The problem is that it's hard to tell, as you're
> returning to userspace, whether you're returning from an exception or
> an interrupt; you typically don't have that information available.  So
> from a purely ease-of-implementation perspective, we'd likely want to
> handle exceptions and interrupts the same way, and quiesce both.

Sure but what I don't understand is why do we need to quiesce more than
once (ie: at the prctl() call). Quiescing should be a single operation
that prevents from any further disturbance. Like offlining anything
we to other CPUs. And entering again in the kernel shouldn't break
that.

> 
> In general, I think it would also be a better explanation to users of
> task isolation to say "every enter/exit to the kernel is either an
> error that causes a signal, or it quiesces on return".  It's a simpler
> semantic, and I think it also is better for interrupts anyway, since
> it potentially avoids multiple interrupts to the application (whatever
> interrupted to begin with, plus potential timer interrupts later).
> 
> But that said, if we start with "pure strict" mode only, all of this
> becomes hypothetical, and we may in fact choose never to allow "safe"
> modes of entering the kernel.

Right. And starting with pure strict mode would be a good first step,
provided it is a mode you need.


> >>That's true, but I'd argue the behavior in that case should be that you can
> >>raise that kind of exception validly (so you can debug), and then you should
> >>quiesce on return to userspace so the application doesn't see additional
> >>exceptions.
> >
> >I don't see how we can quiesce such things.
> 
> I'm imagining task A is in dataplane mode, and task B wants to debug
> it by writing a breakpoint into its text.  When task A hits the
> breakpoint, it will enter the kernel, and hold there while task B
> pokes at it with ptrace.  When task A finally is allowed to return to
> userspace, it should quiesce before entering userspace in case any
> timer interrupts got scheduled (again, maybe due to softirqs or
> whatever, or random other kernel activity targeting that core while it
> was in the kernel, or whatever).  This is just the same kind of
> quiescing we do on return from the initial prctl().

Well again I think it shouldn't happen. Quiescing should be done once
and for all.


> With a "pure strict" mode it does get a little tricky, since we will
> end up killing task A as it comes back from its breakpoint.  We might
> just choose to say that task A should not enable task isolation if it
> is going to be debugged (some runtime switch).  This isn't really a
> great solution; I do kind of feel that the nicest thing to do is
> quiesce the task again at this point.  This feels like the biggest
> argument in favor of supporting a mode where a task-isolated task can
> safely enter the kernel for exceptions.  What do you think?

Yeah probably we'll need to introduce some sort of debugability. Allow
debug/trap exceptions only for example.


> >> - Soft mode (I don't think we want this) - like "no signal" except you don't even quiesce
> >>   on return to userspace, and asynchronous interrupts don't even cause a signal.
> >>   It's basically "best effort", just nohz_full plus the code that tries to get things
> >>   like LRU or vmstat to run before returning to userspace.  I think there isn't enough
> >>   "value add" to make this a separate mode, though.
> >
> >I can imagine HPC to be willing this mode.
> 
> Yes, perhaps.  I'm not convinced we want to target HPC without a much
> clearer sense of why this is better than nohz_full, though.  I fear
> people might think "task isolation" is better by definition and not
> think too much about it, but I'm really not sure it is better for the
> HPC use case, necessarily.

I don't know. Perhaps HPC could just consist in quiescing once for all
(offline everything that can) and not signal when there is a rare disturbance.

> >Otherwise perhaps just drop a warning.
> 
> Are you saying that we should printk a warning in the prctl() rather
> than returning an error in the case where it's not on a full dynticks
> cpu?  I could be convinced by that just to keep things consistent.

Yeah that's what I meant.


> How about doing it this way?  If you invoke prctl() with the default
> "strict" mode where any kernel entry results in a signal, the prctl()
> will be strict, and require you to be affinitized to a single, full
> dynticks cpu.

But if you do that, you need to do it properly and care about races against
affinity changes. It involves heavy synchronization against scheduler code.

I tend to think we shouldn't bother with that. If we enter in task isolation
mode on a non-nohz-full CPU, the task will be signalled and kicked out of task
isolation mode in the next tick that happens very soon after the prctl().


> But, if you enable the "allow syscalls" mode, then the prctl isn't
> strict either, since you can use syscalls to get into a state where
> you're not on a full dynticks cpu, and you just get a console warning
> if you enter task isolation on the wrong cpu.  (Of course, we may end
> up not doing the "allow syscalls" mode for the first version of this
> patch anyway, as we discuss below.)

Right.

> >Ok. And is it this mode you're interested in? Isn't quiescing an issue in this mode?
> 
> In this mode we don't worry about quiescing for interrupts, since we
> are generating a signal, and when you send a signal, you first have to
> disable task isolation mode to avoid getting into various bad states
> (sending too many signals, or worse, getting deadlocked because you
> are signalling the task BECAUSE it was about to receive a signal).  So
> we only quiesce after syscalls/exceptions.

Ok. And are you interested in such strict mode? :-)

If so it would be nice to start with just that and iterate on top of it.

> >Ok. That interface looks better. At least we can start with just PR_TASK_ISOLATION_ENABLE which
> >does strict pure isolation mode and have future flags for more granularity.
> 
> I think just implementing the basic _ENABLE mode with pure strict task
> isolation makes sense for now.  We can wait to enable syscalls or
> exceptions until we have a better use case.  Meanwhile, even without
> support for allowing syscalls, you can always use prctl() to turn off
> task isolation, and then you can do your syscalls, and prctl() it back
> on again.  prctl() to disable task isolation always has to work :-)

Perfect!

> Or, if we want to make it easy to do debugging, and as a result maybe
> also support the plausible mode where task-isolation tasks make
> occasional syscalls, we could say that the _ALLOW_EXCEPTIONS flag
> above implies syscalls as well, and support that mode.  Perhaps that
> makes the most sense...

I fear that _ALLOW_EXCEPTIONS is too wide for a special case if all we
want it to allow debugging.

The most granular way to express custom isolation would be to use BPF.
Not sure we want to go that far though.


> I'll spin it as a new patch series and you can take a look.

Ok. Ideally it would be nice to respin a simple version (strict mode)
on top of which we can later iterate.

Thanks.
