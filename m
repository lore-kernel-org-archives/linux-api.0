From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: Re: [PATCH v7 02/11] task_isolation: add initial support
Date: Fri, 2 Oct 2015 13:15:49 -0400
Message-ID: <560EBBC5.7000709@ezchip.com>
References: <1443453446-7827-1-git-send-email-cmetcalf@ezchip.com>
 <1443453446-7827-3-git-send-email-cmetcalf@ezchip.com>
 <20151001121414.GB3432@lerouge> <alpine.DEB.2.11.1510011416160.4500@nanos>
 <560D6725.9000609@ezchip.com> <alpine.DEB.2.11.1510012224190.4500@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.11.1510012224190.4500@nanos>
Sender: linux-doc-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 10/01/2015 05:20 PM, Thomas Gleixner wrote:
> On Thu, 1 Oct 2015, Chris Metcalf wrote:
>> But first I want to address the question of the basic semantics
>> of the patch series.  I wrote up a description of why it's useful
>> in my email yesterday:
>>
>> https://lkml.kernel.org/r/560C4CF4.9090601@ezchip.com
>>
>> I haven't directly heard from you as to whether you buy the
>> basic premise of "hard isolation" in terms of protecting tasks
>> from all kernel interrupts while they execute in userspace.
> Just for the record. The first serious initiative to solve that
> problem started here in my own company when I guided Frederic through
> the endavour of figuring out what needs to be done to achieve
> that. That was the assignement of his master thesis, which I gave him.

Thanks for that background.  I didn't know you had gotten
Frederic started down that path originally.

>> So I first want to address what is effectively the API concern that
>> you raised, namely that you're concerned that there is a wait
>> loop in the implementation.
> That wait loop is just a place holder for the underlying more serious
> concern I have with this whole approach. And I raised that concern
> several times in the past and I'm happy to do so again.
>
> The people working on this, especially you, are just dead set to
> achieve a certain functionality by jamming half baken mechanisms into
> the kernel and especially into the low level entry/exit code. And
> that's something which really annoys me, simply because you refuse to
> tackle the problems which have been identified as need to be solved 5+
> years ago when Frederic did his thesis.

I think you raise a good point.  I still claim my arguments are
plausible, but you may be right that this is an instance where
forcing a different approach is better for the kernel community
as a whole.

Given that, what would you think of the following two changes
to my proposed patch series:

1. Rather than spinning in a busy loop if timers are pending,
we reschedule if more than one task is ready to run.  This
directly targets the "architected" problem with the scheduler
tick, rather than sweeping up the scheduler tick and any other
timers into the one catch-all of "any timer ready to fire".
(We can use sched_can_stop_tick() to check the case where
other tasks can preempt us.)  This would then provide part
of the semantics of the task-isolation flag.  The other part is
running whatever code can be run to avoid the various ways
tasks might get interrupted later (lru_add_drain(),
quiet_vmstat(), etc) that are not appropriate to run
unconditionally for tasks that aren't trying to be isolated.

2. Remove the tie between disabling the 1 Hz max deferment
and task isolation per se.  Instead add a boot flag (e.g.
"debug_1hz_tick") that lets us turn off the 1 Hz tick to make it
easy to experiment with both the negative effects of the
missing tick, as well as to try to learn in parallel what actual
timer interrupts are firing "on purpose" rather than just due
to the 1 Hz tick to try to eliminate them as well.

For #1, I'm not sure if it's better to hack up the scheduler's
pick_next_task callback methods to avoid task-isolation tasks
when other tasks are also available to run, or just to observe
that there are additional tasks ready to run during exit to
userspace, and yield the cpu to allow those other tasks to run.
The advantage of doing it at exit to userspace is that we can
easily yield in a loop and pay attention to whether we seem
not to be making forward progress with that task and generate
a suitable warning; it also keeps a lot of task-isolation stuff
out of the core scheduler code, which may be a plus.

With these changes, and booting with the "debug_1hz_tick"
flag, I'm seeing a couple of timer ticks hit my task-isolation
task in the first 20 ms or so, and then it quiesces.  I will
plan to work on figuring out what is triggering those
interrupts and seeing how to fix them.  My hope is that in
parallel with that work, other folks can be working on how to
fix problems that occur more silently with the scheduler
tick max deferment disabled; I'm also happy to work on those
problems to the extent that I understand them (and I'm
always happy to learn more).

As part of the patch series I'd extend the proposed
task_isolation_debug flag to also track timer scheduling
events against task-isolation tasks that are ready to run
in userspace (no other runnable tasks).

What do you think of this approach?

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com

