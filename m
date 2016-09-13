From: Francis Giraldeau <francis.giraldeau@gmail.com>
Subject: Re: Ping: [PATCH v15 00/13] support "task_isolation" mode
Date: Mon, 12 Sep 2016 20:20:16 -0400
Message-ID: <3e93004f-e1c5-f606-33fb-7cb44b99eb0a@gmail.com>
References: <1471382376-5443-1-git-send-email-cmetcalf@mellanox.com>
 <d00bbe64-6e2c-51ce-1dfb-72ef1c4a04fa@mellanox.com>
 <057a958c-4491-b449-ae59-7d331afc872d@gmail.com>
 <909484ad-534d-524a-51db-19b7d013f73e@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <909484ad-534d-524a-51db-19b7d013f73e@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@mellanox.com>, Gilad Ben Yossef <giladb@mellanox.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 2016-09-12 12:01 PM, Chris Metcalf wrote:
> The syscall test fails on x86:
>>
>>      $ sudo ./isolation
>>      [...]
>>      test_syscall: FAIL (0x100)
>>      test_syscall (SIGUSR1): FAIL (0x100) 
>
> Your next email suggested adding TIF_TASK_ISOLATION to the set of
> flags in _TIF_WORK_SYSCALL_ENTRY.  I'm happy to make this change
> regardless (it's consistent with Andy's request to add the task
> isolation flag to _TIF_ALLWORK_MASK), but I'm puzzled: as far as
> I know there is no way for TIF_TASK_ISOLATION to be set unless
> TIF_NOHZ is also set.  The context_tracking_init() code forces TIF_NOHZ
> on for every task during boot up, and nothing ever clears it, so...
>

Hello!

You are right, on entry to syscall_trace_enter() the flags is
(_TIF_NOHZ | _TIF_TASK_ISOLATION):

    [   22.634988] isolation thread flags: 0x82000

But at linux/arch/x86/entry/common.c:83

    work = ACCESS_ONCE(ti->flags) & _TIF_WORK_SYSCALL_ENTRY;

the flag _TIF_TASK_ISOLATION was cleared because it is not included in
_TIF_WORK_SYSCALL_ENTRY. Then, the test below is always false:

    if (work & _TIF_TASK_ISOLATION) {
        if (task_isolation_syscall(regs->orig_ax) == -1)
            return -1L;
        work &= ~_TIF_TASK_ISOLATION;
    }

To fix the issue, _TIF_TASK_ISOLATION must be in _TIF_WORK_SYSCALL_ENTRY.
It works on arm64 because the flags are used directly without a mask applied.

>> BTW, this was causing the test to enter an infinite loop. If the clock
>> source is not reliable, maybe a different error code should be returned,
>> because this situation not transient. 
>
> That's a good idea - do you know what the check should be in that
> case?  We can just return EINVAL, as you suggest. 

The args are valid, but the system has an unstable clock, therefore the
operation is not supported. In the user point of view, maybe ENOTSUPP
would be more appropriate? But then, we need to check the reason and
can_stop_my_full_tick() returns only a boolean.

On a side note, the NOSIG mode may be confusing for the users. At first,
I was expecting that NOSIG behaves the same way as the normal task isolation
mode. In the current situation, if the user wants the normal behavior, but
does not care about the signal, the user must register an empty signal handler.

However, if I understand correctly, other settings beside NOHZ and isolcpus
are required to support quiet CPUs, such as irq_affinity and rcu_nocb. It would
be very convenient from the user point of view if these other settings were configure
correctly.

I can work on that and also write some doc (Documentation/task-isolation.txt ?).

> Thanks a lot for your help! 

Many thanks for your feedback,

Francis
