From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 10/22] kthread: Allow to modify delayed kthread work
Date: Mon, 25 Jan 2016 14:19:09 -0500
Message-ID: <20160125191909.GF3628@mtj.duckdns.org>
References: <1453736711-6703-1-git-send-email-pmladek@suse.com>
 <1453736711-6703-11-git-send-email-pmladek@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1453736711-6703-11-git-send-email-pmladek@suse.com>
Sender: owner-linux-mm@kvack.org
To: Petr Mladek <pmladek@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Jan 25, 2016 at 04:44:59PM +0100, Petr Mladek wrote:
> +bool mod_delayed_kthread_work(struct kthread_worker *worker,
> +			      struct delayed_kthread_work *dwork,
> +			      unsigned long delay)
> +{
> +	struct kthread_work *work = &dwork->work;
> +	unsigned long flags;
> +	int ret = 0;
> +
> +try_again:
> +	spin_lock_irqsave(&worker->lock, flags);
> +	WARN_ON_ONCE(work->worker && work->worker != worker);
> +
> +	if (work->canceling)
> +		goto out;
> +
> +	ret = try_to_cancel_kthread_work(work, &worker->lock, &flags);
> +	if (ret == -EAGAIN)
> +		goto try_again;
> +
> +	if (work->canceling)

Does this test need to be repeated?  How would ->canceling change
while worker->lock is held?

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
