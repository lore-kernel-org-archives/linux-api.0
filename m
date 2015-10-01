From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v7 02/11] task_isolation: add initial support
Date: Thu, 1 Oct 2015 14:14:15 +0200
Message-ID: <20151001121414.GB3432@lerouge>
References: <1443453446-7827-1-git-send-email-cmetcalf@ezchip.com>
 <1443453446-7827-3-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1443453446-7827-3-git-send-email-cmetcalf@ezchip.com>
Sender: linux-doc-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Sep 28, 2015 at 11:17:17AM -0400, Chris Metcalf wrote:
> diff --git a/include/linux/isolation.h b/include/linux/isolation.h
> new file mode 100644
> index 000000000000..fd04011b1c1e
> --- /dev/null
> +++ b/include/linux/isolation.h
> @@ -0,0 +1,24 @@
> +/*
> + * Task isolation related global functions
> + */
> +#ifndef _LINUX_ISOLATION_H
> +#define _LINUX_ISOLATION_H
> +
> +#include <linux/tick.h>
> +#include <linux/prctl.h>
> +
> +#ifdef CONFIG_TASK_ISOLATION
> +static inline bool task_isolation_enabled(void)
> +{
> +	return tick_nohz_full_cpu(smp_processor_id()) &&
> +		(current->task_isolation_flags & PR_TASK_ISOLATION_ENABLE);

Ok, I may be a bit burdening with that but, how about using the regular
existing task flags, and if needed later we can still introduce a new field
in struct task_struct?

> diff --git a/kernel/isolation.c b/kernel/isolation.c
> new file mode 100644
> index 000000000000..6ace866c69f6
> --- /dev/null
> +++ b/kernel/isolation.c
> @@ -0,0 +1,77 @@
> +/*
> + *  linux/kernel/isolation.c
> + *
> + *  Implementation for task isolation.
> + *
> + *  Distributed under GPLv2.
> + */
> +
> +#include <linux/mm.h>
> +#include <linux/swap.h>
> +#include <linux/vmstat.h>
> +#include <linux/isolation.h>
> +#include "time/tick-sched.h"
> +
> +/*
> + * Rather than continuously polling for the next_event in the
> + * tick_cpu_device, architectures can provide a method to save power
> + * by sleeping until an interrupt arrives.
> + *
> + * Note that it must be guaranteed for a particular architecture
> + * that if next_event is not KTIME_MAX, then a timer interrupt will
> + * occur, otherwise the sleep may never awaken.
> + */
> +void __weak task_isolation_wait(void)
> +{
> +	cpu_relax();
> +}
> +
> +/*
> + * We normally return immediately to userspace.
> + *
> + * In task_isolation mode we wait until no more interrupts are
> + * pending.  Otherwise we nap with interrupts enabled and wait for the
> + * next interrupt to fire, then loop back and retry.
> + *
> + * Note that if you schedule two task_isolation processes on the same
> + * core, neither will ever leave the kernel, and one will have to be
> + * killed manually.  Otherwise in situations where another process is
> + * in the runqueue on this cpu, this task will just wait for that
> + * other task to go idle before returning to user space.
> + */
> +void task_isolation_enter(void)
> +{
> +	struct clock_event_device *dev =
> +		__this_cpu_read(tick_cpu_device.evtdev);
> +	struct task_struct *task = current;
> +	unsigned long start = jiffies;
> +	bool warned = false;
> +
> +	if (WARN_ON(irqs_disabled()))
> +		local_irq_enable();
> +
> +	/* Drain the pagevecs to avoid unnecessary IPI flushes later. */
> +	lru_add_drain();
> +
> +	/* Quieten the vmstat worker so it won't interrupt us. */
> +	quiet_vmstat();
> +
> +	while (READ_ONCE(dev->next_event.tv64) != KTIME_MAX) {

You should add a function in tick-sched.c to get the next tick. This
is supposed to be a private field.

> +		if (!warned && (jiffies - start) >= (5 * HZ)) {
> +			pr_warn("%s/%d: cpu %d: task_isolation task blocked for %ld seconds\n",
> +				task->comm, task->pid, smp_processor_id(),
> +				(jiffies - start) / HZ);
> +			warned = true;
> +		}
> +		cond_resched();
> +		if (test_thread_flag(TIF_SIGPENDING))
> +			break;

Why not use signal_pending()?

> +		task_isolation_wait();

I still think we could try a wait-wake standard scheme.

Thanks.
