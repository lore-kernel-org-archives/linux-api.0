From: Chris Metcalf <cmetcalf@mellanox.com>
Subject: Re: Ping: [PATCH v15 00/13] support "task_isolation" mode
Date: Mon, 12 Sep 2016 12:01:58 -0400
Message-ID: <909484ad-534d-524a-51db-19b7d013f73e@mellanox.com>
References: <1471382376-5443-1-git-send-email-cmetcalf@mellanox.com>
 <d00bbe64-6e2c-51ce-1dfb-72ef1c4a04fa@mellanox.com>
 <057a958c-4491-b449-ae59-7d331afc872d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <057a958c-4491-b449-ae59-7d331afc872d@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Francis Giraldeau <francis.giraldeau@gmail.com>, Gilad Ben Yossef <giladb@mellanox.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 9/7/2016 5:11 PM, Francis Giraldeau wrote:
> On 2016-08-29 12:27 PM, Chris Metcalf wrote:
>> On 8/16/2016 5:19 PM, Chris Metcalf wrote:
>>> Here is a respin of the task-isolation patch set.
>> No concerns have been raised yet with the v15 version of the patch series
>> in the two weeks since I posted it, and I think I have addressed all
>> previously-raised concerns (or perhaps people have just given up arguing
>> with me).
> There is a cycle with header include in the v15 patch set on x86_64 that cause a compilation error. You will find the patch (and other fixes) in the following branch:
>
>      https://github.com/giraldeau/linux/commits/dataplane-x86-fix-inc

Thanks, I fixed the header inclusion loop by converting
task_isolation_set_flags() to a macro, removing the unnecessary
include of <linux/smp.h>, and replacing the include of <linux/sched.h>
with a "struct task_struct;" declaration.  That avoids having to dump
too much isolation-related stuff into the apic.h header (note that
you'd also need to include the empty #define for when isolation is
configured off).

> In the test file, it is indicated to change timer-tick.c to disable the 1Hz tick, is there a reason why the change is not in the patch set? I added this trivial change in the branch dataplane-x86-fix-inc above.

Yes, Frederic prefers that we not allow any way of automatically
disabling the tick for now.  Hopefully we will clean up the last
few things that are requiring it to keep ticking shortly.  But for
now it's on a parallel track to the task isolation stuff.

> The syscall test fails on x86:
>
>      $ sudo ./isolation
>      [...]
>      test_syscall: FAIL (0x100)
>      test_syscall (SIGUSR1): FAIL (0x100)

Your next email suggested adding TIF_TASK_ISOLATION to the set of
flags in _TIF_WORK_SYSCALL_ENTRY.  I'm happy to make this change
regardless (it's consistent with Andy's request to add the task
isolation flag to _TIF_ALLWORK_MASK), but I'm puzzled: as far as
I know there is no way for TIF_TASK_ISOLATION to be set unless
TIF_NOHZ is also set.  The context_tracking_init() code forces TIF_NOHZ
on for every task during boot up, and nothing ever clears it, so...

> I wanted to debug this problem with gdb and a KVM virtual machine. However, the TSC clock source is detected as non reliable, even with the boot parameter tsc=reliable, and therefore prctl(PR_SET_TASK_ISOLATION, PR_TASK_ISOLATION_ENABLE) always returns EAGAIN. Is there a trick to run task isolation in a VM (at least for debugging purposes)?
>
> BTW, this was causing the test to enter an infinite loop. If the clock source is not reliable, maybe a different error code should be returned, because this situation not transient.

That's a good idea - do you know what the check should be in that
case?  We can just return EINVAL, as you suggest.

> In the mean time, I added a check for 100 max retries in the test (prctl_safe()).

Thanks, that's a good idea.  I'll add your changes to the selftest code for the
next release.

> When running only the test_jitter(), the isolation mode is lost:
>
>      [ 6741.566048] isolation/9515: task_isolation mode lost due to irq_work
>
> With ftrace (events/workqueue/workqueue_execute_start), I get a bit more info:
>
>       kworker/1:1-676   [001] ....  6610.097128: workqueue_execute_start: work struct ffff8801a784ca20: function dbs_work_handler
>
> The governor was ondemand, so I tried to set the frequency scaling governor to performance, but that does not solve the issue. Is there a way to suppress this irq_work? Should we run the isolated task with high real-time priority, such that it never get preempted?

On the tile platform we don't have the frequency scaling stuff to contend with, so
I don't know much about it.  I'd be very curious to know what you can figure out
on this front.

Thanks a lot for your help!

-- 
Chris Metcalf, Mellanox Technologies
http://www.mellanox.com
