From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 5/6] nohz: support PR_DATAPLANE_STRICT mode
Date: Tue, 12 May 2015 11:38:58 +0200
Message-ID: <20150512093858.GI21418@twins.programming.kicks-ass.net>
References: <1431107927-13998-1-git-send-email-cmetcalf@ezchip.com>
 <1431107927-13998-6-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1431107927-13998-6-git-send-email-cmetcalf@ezchip.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Frederic Weisbecker <fweisbec@gmail.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, May 08, 2015 at 01:58:46PM -0400, Chris Metcalf wrote:
> +++ b/kernel/time/tick-sched.c
> @@ -436,6 +436,20 @@ static void dataplane_quiesce(void)
>  			(jiffies - start));
>  		dump_stack();
>  	}
> +
> +	/*
> +	 * Kill the process if it violates STRICT mode.  Note that this
> +	 * code also results in killing the task if a kernel bug causes an
> +	 * irq to be delivered to this core.
> +	 */
> +	if ((task->dataplane_flags & (PR_DATAPLANE_STRICT|PR_DATAPLANE_PRCTL))
> +	    == PR_DATAPLANE_STRICT) {
> +		pr_warn("Dataplane STRICT mode violated; process killed.\n");
> +		dump_stack();
> +		task->dataplane_flags &= ~PR_DATAPLANE_QUIESCE;
> +		local_irq_enable();
> +		do_group_exit(SIGKILL);
> +	}
>  }

So while I'm all for hard fails like this, can we not provide a wee bit
more information in the siginfo ? And maybe use a slightly less fatal
signal, such that userspace can actually catch it and dump state in
debug modes?
