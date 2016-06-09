From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v8 02/12] kthread: Kthread worker API cleanup
Date: Thu, 9 Jun 2016 19:22:34 +0200
Message-ID: <20160609172234.GW30154@twins.programming.kicks-ass.net>
References: <1465480326-31606-1-git-send-email-pmladek@suse.com>
 <1465480326-31606-3-git-send-email-pmladek@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1465480326-31606-3-git-send-email-pmladek@suse.com>
Sender: owner-linux-mm@kvack.org
To: Petr Mladek <pmladek@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Jun 09, 2016 at 03:51:56PM +0200, Petr Mladek wrote:
> -#define DEFINE_KTHREAD_WORKER(worker)					\
> -	struct kthread_worker worker = KTHREAD_WORKER_INIT(worker)
> +#define KTHREAD_DECLARE_WORKER(worker)					\
> +	struct kthread_worker worker = KTHREAD_INIT_WORKER(worker)
>  
> -#define DEFINE_KTHREAD_WORK(work, fn)					\
> -	struct kthread_work work = KTHREAD_WORK_INIT(work, fn)
> +#define KTHREAD_DECLARE_WORK(work, fn)					\
> +	struct kthread_work work = KTHREAD_INIT_WORK(work, fn)
>  
>  /*
>   * kthread_worker.lock needs its own lockdep class key when defined on
>   * stack with lockdep enabled.  Use the following macros in such cases.
>   */
>  #ifdef CONFIG_LOCKDEP
> -# define KTHREAD_WORKER_INIT_ONSTACK(worker)				\
> -	({ init_kthread_worker(&worker); worker; })
> -# define DEFINE_KTHREAD_WORKER_ONSTACK(worker)				\
> -	struct kthread_worker worker = KTHREAD_WORKER_INIT_ONSTACK(worker)
> +# define KTHREAD_INIT_WORKER_ONSTACK(worker)				\
> +	({ kthread_init_worker(&worker); worker; })
> +# define KTHREAD_DECLARE_WORKER_ONSTACK(worker)				\
> +	struct kthread_worker worker = KTHREAD_INIT_WORKER_ONSTACK(worker)
>  #else
> -# define DEFINE_KTHREAD_WORKER_ONSTACK(worker) DEFINE_KTHREAD_WORKER(worker)
> +# define KTHREAD_DECLARE_WORKER_ONSTACK(worker) KTHREAD_DECLARE_WORKER(worker)
>  #endif

As Steven already said; these are very much definitions _not_
declarations.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
