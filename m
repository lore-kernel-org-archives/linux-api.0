From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 09/12] kthread: Initial support for delayed kthread
 work
Date: Mon, 20 Jun 2016 16:20:53 -0400
Message-ID: <20160620202053.GA3262@mtj.duckdns.org>
References: <1466075851-24013-1-git-send-email-pmladek@suse.com>
 <1466075851-24013-10-git-send-email-pmladek@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1466075851-24013-10-git-send-email-pmladek@suse.com>
Sender: owner-linux-mm@kvack.org
To: Petr Mladek <pmladek@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hello,

On Thu, Jun 16, 2016 at 01:17:28PM +0200, Petr Mladek wrote:
> +/**
> + * kthread_delayed_work_timer_fn - callback that queues the associated kthread
> + *	delayed work when the timer expires.
> + * @__data: pointer to the data associated with the timer
> + *
> + * The format of the function is defined by struct timer_list.
> + * It should have been called from irqsafe timer with irq already off.
> + */
> +void kthread_delayed_work_timer_fn(unsigned long __data)
> +{
> +	struct kthread_delayed_work *dwork =
> +		(struct kthread_delayed_work *)__data;
> +	struct kthread_work *work = &dwork->work;
> +	struct kthread_worker *worker = work->worker;
> +
> +	/*
> +	 * This might happen when a pending work is reinitialized.
> +	 * It means that it is used a wrong way.
> +	 */
> +	if (WARN_ON_ONCE(!worker))
> +		return;
> +
> +	spin_lock(&worker->lock);
> +	/* Work must not be used with more workers, see kthread_queue_work(). */
                                         ^
					 ditto, this reads weird

Other than that,

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
