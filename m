From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 07/22] kthread: Detect when a kthread work is used by
 more workers
Date: Mon, 23 Nov 2015 17:27:03 -0500
Message-ID: <20151123222703.GH19072@mtj.duckdns.org>
References: <1447853127-3461-1-git-send-email-pmladek@suse.com>
 <1447853127-3461-8-git-send-email-pmladek@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1447853127-3461-8-git-send-email-pmladek@suse.com>
Sender: owner-linux-mm@kvack.org
To: Petr Mladek <pmladek@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hello,

On Wed, Nov 18, 2015 at 02:25:12PM +0100, Petr Mladek wrote:
> @@ -610,6 +625,12 @@ repeat:
>  	if (work) {
>  		__set_current_state(TASK_RUNNING);
>  		work->func(work);
> +
> +		spin_lock_irq(&worker->lock);
> +		/* Allow to queue the work into another worker */
> +		if (!kthread_work_pending(work))
> +			work->worker = NULL;
> +		spin_unlock_irq(&worker->lock);

Doesn't this mean that the work item can't be freed from its callback?
That pattern tends to happen regularly.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
