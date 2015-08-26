From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: Re: [PATCH v6 3/6] task_isolation: support PR_TASK_ISOLATION_STRICT
 mode
Date: Wed, 26 Aug 2015 11:10:34 -0400
Message-ID: <55DDD6EA.3070307@ezchip.com>
References: <1440532555-15492-1-git-send-email-cmetcalf@ezchip.com>
 <1440532555-15492-4-git-send-email-cmetcalf@ezchip.com>
 <20150826103651.GA30466@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150826103651.GA30466@arm.com>
Sender: linux-doc-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <Catalin.Marinas@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 08/26/2015 06:36 AM, Will Deacon wrote:
> Hi Chris,
>
> On Tue, Aug 25, 2015 at 08:55:52PM +0100, Chris Metcalf wrote:
>> diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
>> index d882b833dbdb..e3d83a12f3cf 100644
>> --- a/arch/arm64/kernel/ptrace.c
>> +++ b/arch/arm64/kernel/ptrace.c
>> @@ -37,6 +37,7 @@
>>   #include <linux/regset.h>
>>   #include <linux/tracehook.h>
>>   #include <linux/elf.h>
>> +#include <linux/isolation.h>
>>   
>>   #include <asm/compat.h>
>>   #include <asm/debug-monitors.h>
>> @@ -1150,6 +1151,10 @@ static void tracehook_report_syscall(struct pt_regs *regs,
>>   
>>   asmlinkage int syscall_trace_enter(struct pt_regs *regs)
>>   {
>> +	/* Ensure we report task_isolation violations in all circumstances. */
>> +	if (test_thread_flag(TIF_NOHZ) && task_isolation_strict())
> This is going to force us to check TIF_NOHZ on the syscall slowpath even
> when CONFIG_TASK_ISOLATION=n.

Yes, good catch.  I was thinking the "&& false" would suppress the TIF
test but I forgot that test_bit() takes a volatile argument, so it gets
evaluated even though the result isn't actually used.

But I don't want to just reorder the two tests, because when isolation
is enabled, testing TIF_NOHZ first is better.  I think probably the right
solution is just to put an #ifdef CONFIG_TASK_ISOLATION around that
test, even though that is a little crufty.  The alternative is to provide
a task_isolation_configured() macro that just returns true or false, and
make it a three-part "&&" test with that new macro first, but
that seems a little crufty as well.  Do you have a preference?

>> +		task_isolation_syscall(regs->syscallno);
>> +
>>   	/* Do the secure computing check first; failures should be fast. */
> Here we have the usual priority problems with all the subsystems that
> hook into the syscall path. If a prctl is later rewritten to a different
> syscall, do you care about catching it? Either way, the comment about
> doing secure computing "first" needs fixing.

I admit I am unclear on the utility of rewriting prctl.  My instinct is that
we are trying to catch userspace invocations of prctl and allow them,
and fail most everything else, so doing it pre-rewrite seems OK.

I'm not sure if it makes sense to catch it before or after the
secure computing check, though.  On reflection maybe doing it
afterwards makes more sense - what do you think?

Thanks!

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com

