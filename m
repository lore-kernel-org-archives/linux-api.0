From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v8 04/14] task_isolation: add initial support
Date: Tue, 20 Oct 2015 13:56:38 -0700
Message-ID: <CALCETrWzhrYreizoKG0w6Jtz3RLFjNx9Qk_JLykcLLUQcCXBEA@mail.gmail.com>
References: <1445373372-6567-1-git-send-email-cmetcalf@ezchip.com> <1445373372-6567-5-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1445373372-6567-5-git-send-email-cmetcalf@ezchip.com>
Sender: linux-doc-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 20, 2015 at 1:36 PM, Chris Metcalf <cmetcalf@ezchip.com> wrote:
> +/*
> + * In task isolation mode we try to return to userspace only after
> + * attempting to make sure we won't be interrupted again.  To handle
> + * the periodic scheduler tick, we test to make sure that the tick is
> + * stopped, and if it isn't yet, we request a reschedule so that if
> + * another task needs to run to completion first, it can do so.
> + * Similarly, if any other subsystems require quiescing, we will need
> + * to do that before we return to userspace.
> + */
> +bool _task_isolation_ready(void)
> +{
> +       WARN_ON_ONCE(!irqs_disabled());
> +
> +       /* If we need to drain the LRU cache, we're not ready. */
> +       if (lru_add_drain_needed(smp_processor_id()))
> +               return false;
> +
> +       /* If vmstats need updating, we're not ready. */
> +       if (!vmstat_idle())
> +               return false;
> +
> +       /* If the tick is running, request rescheduling; we're not ready. */
> +       if (!tick_nohz_tick_stopped()) {
> +               set_tsk_need_resched(current);
> +               return false;
> +       }
> +
> +       return true;
> +}

I still don't get why this is a loop.

I would argue that this should simply drain the LRU, quiet vmstat, and
return.  If the tick isn't stopped, then there's a reason why it's not
stopped (which may involve having SCHED_OTHER tasks around, in which
case user code shouldn't do that or there should simply be a
requirement that isolation requires a real-time scheduler class).

BTW, should isolation just be a scheduler class (SCHED_ISOLATED)?

--Andy
