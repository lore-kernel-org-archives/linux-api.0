From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC v2 03/18] kthread: Add drain_kthread_worker()
Date: Tue, 22 Sep 2015 14:26:59 -0400
Message-ID: <20150922182659.GB17659@mtj.duckdns.org>
References: <1442840639-6963-1-git-send-email-pmladek@suse.com>
 <1442840639-6963-4-git-send-email-pmladek@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1442840639-6963-4-git-send-email-pmladek@suse.com>
Sender: owner-linux-mm@kvack.org
To: Petr Mladek <pmladek@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, live-patching@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Sep 21, 2015 at 03:03:44PM +0200, Petr Mladek wrote:
> flush_kthread_worker() returns when the currently queued works are proceed.
								     ^
								   processed?

> But some other works might have been queued in the meantime.
...
> +/**
> + * drain_kthread_worker - drain a kthread worker
> + * @worker: worker to be drained
> + *
> + * Wait until there is none work queued for the given kthread worker.
                          ^
                          no

> + * Only currently running work on @worker can queue further work items
                                             ^^^^^^^^^
				 should be queueing is prolly more accurate

> + * on it.  @worker is flushed repeatedly until it becomes empty.
> + * The number of flushing is determined by the depth of chaining
> + * and should be relatively short.  Whine if it takes too long.
> + *
> + * The caller is responsible for blocking all existing works
> + * from an infinite re-queuing!
           
The caller is responsible for preventing the existing work items from
requeueing themselves indefinitely.

> + *
> + * Also the caller is responsible for blocking all the kthread
> + * worker users from queuing any new work. It is especially
> + * important if the queue has to stay empty once this function
> + * finishes.

The last sentence reads a bit weird to me.  New work items just aren't
allowed while draining.  It isn't "especially important" for certain
cases.  It's just buggy otherwise.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
