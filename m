From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH v7 02/11] task_isolation: add initial support
Date: Fri, 2 Oct 2015 21:02:29 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1510022057430.4500@nanos>
References: <1443453446-7827-1-git-send-email-cmetcalf@ezchip.com> <1443453446-7827-3-git-send-email-cmetcalf@ezchip.com> <20151001121414.GB3432@lerouge> <alpine.DEB.2.11.1510011416160.4500@nanos> <560D6725.9000609@ezchip.com> <alpine.DEB.2.11.1510012224190.4500@nanos>
 <560EBBC5.7000709@ezchip.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <560EBBC5.7000709-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Cc: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Chris,

On Fri, 2 Oct 2015, Chris Metcalf wrote:
> 1. Rather than spinning in a busy loop if timers are pending,
> we reschedule if more than one task is ready to run.  This
> directly targets the "architected" problem with the scheduler
> tick, rather than sweeping up the scheduler tick and any other
> timers into the one catch-all of "any timer ready to fire".
> (We can use sched_can_stop_tick() to check the case where
> other tasks can preempt us.)  This would then provide part
> of the semantics of the task-isolation flag.  The other part is
> running whatever code can be run to avoid the various ways
> tasks might get interrupted later (lru_add_drain(),
> quiet_vmstat(), etc) that are not appropriate to run
> unconditionally for tasks that aren't trying to be isolated.

Sounds like a plan
 
> 2. Remove the tie between disabling the 1 Hz max deferment
> and task isolation per se.  Instead add a boot flag (e.g.
> "debug_1hz_tick") that lets us turn off the 1 Hz tick to make it
> easy to experiment with both the negative effects of the
> missing tick, as well as to try to learn in parallel what actual
> timer interrupts are firing "on purpose" rather than just due
> to the 1 Hz tick to try to eliminate them as well.

I have no problem with a debug flag, which allows you to experiment,
though I'm not entirely sure whether we need to carry it in mainline
or just in an extra isolation git tree.

> For #1, I'm not sure if it's better to hack up the scheduler's
> pick_next_task callback methods to avoid task-isolation tasks
> when other tasks are also available to run, or just to observe
> that there are additional tasks ready to run during exit to
> userspace, and yield the cpu to allow those other tasks to run.
> The advantage of doing it at exit to userspace is that we can
> easily yield in a loop and pay attention to whether we seem
> not to be making forward progress with that task and generate
> a suitable warning; it also keeps a lot of task-isolation stuff
> out of the core scheduler code, which may be a plus.

You should discuss that with Peter Zijlstra. I see the plus not to
have it in the scheduler, but OTOH having it in the core code has its
advantages as well. Let's see how ugly it gets.
 
> With these changes, and booting with the "debug_1hz_tick"
> flag, I'm seeing a couple of timer ticks hit my task-isolation
> task in the first 20 ms or so, and then it quiesces.  I will
> plan to work on figuring out what is triggering those
> interrupts and seeing how to fix them.  My hope is that in
> parallel with that work, other folks can be working on how to
> fix problems that occur more silently with the scheduler
> tick max deferment disabled; I'm also happy to work on those
> problems to the extent that I understand them (and I'm
> always happy to learn more).

I like that approach :)
 
> As part of the patch series I'd extend the proposed
> task_isolation_debug flag to also track timer scheduling
> events against task-isolation tasks that are ready to run
> in userspace (no other runnable tasks).
>
> What do you think of this approach?

Makes sense.

Thanks,

	tglx
