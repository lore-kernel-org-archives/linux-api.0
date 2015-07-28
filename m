From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 14/14] kthread_worker: Add
 set_kthread_worker_scheduler*()
Date: Tue, 28 Jul 2015 13:41:54 -0400
Message-ID: <20150728174154.GG5322@mtj.duckdns.org>
References: <1438094371-8326-1-git-send-email-pmladek@suse.com>
 <1438094371-8326-15-git-send-email-pmladek@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1438094371-8326-15-git-send-email-pmladek@suse.com>
Sender: owner-linux-mm@kvack.org
To: Petr Mladek <pmladek@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, live-patching@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Jul 28, 2015 at 04:39:31PM +0200, Petr Mladek wrote:
> +/**
> + * set_kthread_worker_scheduler - change the scheduling policy and/or RT
> + *	priority of a kthread worker.
> + * @worker: target kthread_worker
> + * @policy: new policy
> + * @sched_priority: new RT priority
> + *
> + * Return: 0 on success. An error code otherwise.
> + */
> +int set_kthread_worker_scheduler(struct kthread_worker *worker,
> +				 int policy, int sched_priority)
> +{
> +	return __set_kthread_worker_scheduler(worker, policy, sched_priority,
> +					      true);
> +}

Ditto.  I don't get why we would want these thin wrappers.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
