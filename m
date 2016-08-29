From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v15 04/13] task_isolation: add initial support
Date: Mon, 29 Aug 2016 18:33:52 +0200
Message-ID: <20160829163352.GV10153@twins.programming.kicks-ass.net>
References: <1471382376-5443-1-git-send-email-cmetcalf@mellanox.com>
 <1471382376-5443-5-git-send-email-cmetcalf@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1471382376-5443-5-git-send-email-cmetcalf@mellanox.com>
Sender: owner-linux-mm@kvack.org
To: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Gilad Ben Yossef <giladb@mellanox.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Aug 16, 2016 at 05:19:27PM -0400, Chris Metcalf wrote:
> +	/*
> +	 * Request rescheduling unless we are in full dynticks mode.
> +	 * We would eventually get pre-empted without this, and if
> +	 * there's another task waiting, it would run; but by
> +	 * explicitly requesting the reschedule, we may reduce the
> +	 * latency.  We could directly call schedule() here as well,
> +	 * but since our caller is the standard place where schedule()
> +	 * is called, we defer to the caller.
> +	 *
> +	 * A more substantive approach here would be to use a struct
> +	 * completion here explicitly, and complete it when we shut
> +	 * down dynticks, but since we presumably have nothing better
> +	 * to do on this core anyway, just spinning seems plausible.
> +	 */
> +	if (!tick_nohz_tick_stopped())
> +		set_tsk_need_resched(current);

This is broken.. and it would be really good if you don't actually need
to do this.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
