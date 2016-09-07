From: Francis Giraldeau <francis.giraldeau@gmail.com>
Subject: Re: Ping: [PATCH v15 00/13] support "task_isolation" mode
Date: Wed, 7 Sep 2016 17:11:06 -0400
Message-ID: <057a958c-4491-b449-ae59-7d331afc872d@gmail.com>
References: <1471382376-5443-1-git-send-email-cmetcalf@mellanox.com>
 <d00bbe64-6e2c-51ce-1dfb-72ef1c4a04fa@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <d00bbe64-6e2c-51ce-1dfb-72ef1c4a04fa@mellanox.com>
Sender: linux-doc-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@mellanox.com>, Gilad Ben Yossef <giladb@mellanox.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 2016-08-29 12:27 PM, Chris Metcalf wrote:
> On 8/16/2016 5:19 PM, Chris Metcalf wrote:
>> Here is a respin of the task-isolation patch set.
>
> No concerns have been raised yet with the v15 version of the patch series
> in the two weeks since I posted it, and I think I have addressed all
> previously-raised concerns (or perhaps people have just given up arguing
> with me).

There is a cycle with header include in the v15 patch set on x86_64 that cause a compilation error. You will find the patch (and other fixes) in the following branch:

    https://github.com/giraldeau/linux/commits/dataplane-x86-fix-inc

In the test file, it is indicated to change timer-tick.c to disable the 1Hz tick, is there a reason why the change is not in the patch set? I added this trivial change in the branch dataplane-x86-fix-inc above.

The syscall test fails on x86:

    $ sudo ./isolation
    [...]
    test_syscall: FAIL (0x100)
    test_syscall (SIGUSR1): FAIL (0x100)

I wanted to debug this problem with gdb and a KVM virtual machine. However, the TSC clock source is detected as non reliable, even with the boot parameter tsc=reliable, and therefore prctl(PR_SET_TASK_ISOLATION, PR_TASK_ISOLATION_ENABLE) always returns EAGAIN. Is there a trick to run task isolation in a VM (at least for debugging purposes)?

BTW, this was causing the test to enter an infinite loop. If the clock source is not reliable, maybe a different error code should be returned, because this situation not transient. In the mean time, I added a check for 100 max retries in the test (prctl_safe()).

When running only the test_jitter(), the isolation mode is lost:

    [ 6741.566048] isolation/9515: task_isolation mode lost due to irq_work

With ftrace (events/workqueue/workqueue_execute_start), I get a bit more info:

     kworker/1:1-676   [001] ....  6610.097128: workqueue_execute_start: work struct ffff8801a784ca20: function dbs_work_handler

The governor was ondemand, so I tried to set the frequency scaling governor to performance, but that does not solve the issue. Is there a way to suppress this irq_work? Should we run the isolated task with high real-time priority, such that it never get preempted?

Thanks!

Francis
