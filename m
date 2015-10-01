From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: Re: [PATCH v7 02/11] task_isolation: add initial support
Date: Thu, 1 Oct 2015 15:25:59 -0400
Message-ID: <560D88C7.1090003@ezchip.com>
References: <1443453446-7827-1-git-send-email-cmetcalf@ezchip.com>
 <1443453446-7827-3-git-send-email-cmetcalf@ezchip.com>
 <20151001121414.GB3432@lerouge>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151001121414.GB3432@lerouge>
Sender: linux-kernel-owner@vger.kernel.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 10/01/2015 08:14 AM, Frederic Weisbecker wrote:
> On Mon, Sep 28, 2015 at 11:17:17AM -0400, Chris Metcalf wrote:
>> diff --git a/include/linux/isolation.h b/include/linux/isolation.h
>> new file mode 100644
>> index 000000000000..fd04011b1c1e
>> --- /dev/null
>> +++ b/include/linux/isolation.h
>> @@ -0,0 +1,24 @@
>> +/*
>> + * Task isolation related global functions
>> + */
>> +#ifndef _LINUX_ISOLATION_H
>> +#define _LINUX_ISOLATION_H
>> +
>> +#include <linux/tick.h>
>> +#include <linux/prctl.h>
>> +
>> +#ifdef CONFIG_TASK_ISOLATION
>> +static inline bool task_isolation_enabled(void)
>> +{
>> +	return tick_nohz_full_cpu(smp_processor_id()) &&
>> +		(current->task_isolation_flags & PR_TASK_ISOLATION_ENABLE);
> Ok, I may be a bit burdening with that but, how about using the regular
> existing task flags, and if needed later we can still introduce a new field
> in struct task_struct?

The problem is still that we have two basic bits ("enabled" and
"strict") plus eight bits of signal number to override SIGKILL.
So we end up with *something* extra in task_struct no matter what.
And, right now it's conveniently the same value as the bits
passed to prctl(), so we don't need to marshall and unmarshall
the prctl() get/set results.

If we could convince ourselves not to do the "settable signal"
stuff I'd agree that use task flags makes sense, but I was
convinced for v2 of the patch series to add a settable signal,
and I suspect it still does make sense.

>> +	while (READ_ONCE(dev->next_event.tv64) != KTIME_MAX) {
> You should add a function in tick-sched.c to get the next tick. This
> is supposed to be a private field.

Yes.  Or probably better, a function that just says whether the
timer is quiesced.  Obviously I'll wait to hear what Thomas says
on this subject first, though.

>> +		if (!warned && (jiffies - start) >= (5 * HZ)) {
>> +			pr_warn("%s/%d: cpu %d: task_isolation task blocked for %ld seconds\n",
>> +				task->comm, task->pid, smp_processor_id(),
>> +				(jiffies - start) / HZ);
>> +			warned = true;
>> +		}
>> +		cond_resched();
>> +		if (test_thread_flag(TIF_SIGPENDING))
>> +			break;
> Why not use signal_pending()?

Makes sense, thanks.

> I still think we could try a wait-wake standard scheme. 

I'm curious to hear what you make of my arguments in the
other thread on this subject!

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com
