From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 11/22] kthread: Better support freezable kthread
 workers
Date: Mon, 25 Jan 2016 14:21:11 -0500
Message-ID: <20160125192111.GG3628@mtj.duckdns.org>
References: <1453736711-6703-1-git-send-email-pmladek@suse.com>
 <1453736711-6703-12-git-send-email-pmladek@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1453736711-6703-12-git-send-email-pmladek@suse.com>
Sender: owner-linux-mm@kvack.org
To: Petr Mladek <pmladek@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Jan 25, 2016 at 04:45:00PM +0100, Petr Mladek wrote:
> @@ -556,6 +556,7 @@ void __init_kthread_worker(struct kthread_worker *worker,
>  				const char *name,
>  				struct lock_class_key *key)
>  {
> +	worker->flags = 0;
>  	spin_lock_init(&worker->lock);
>  	lockdep_set_class_and_name(&worker->lock, key, name);
>  	INIT_LIST_HEAD(&worker->work_list);

Maybe memset the thing and drop 0, NULL inits?

> @@ -638,7 +643,8 @@ repeat:
>  EXPORT_SYMBOL_GPL(kthread_worker_fn);
>  
>  static struct kthread_worker *
> -__create_kthread_worker(int cpu, const char namefmt[], va_list args)
> +__create_kthread_worker(unsigned int flags, int cpu,
> +			const char namefmt[], va_list args)

Wouldn't @cpu, @flags be less confusing?  You would end up with, (A,
B, C) and (B, C) instead of (A, B, C) and (A, C).

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
