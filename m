From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC v2 04/18] kthread: Add destroy_kthread_worker()
Date: Tue, 22 Sep 2015 14:30:06 -0400
Message-ID: <20150922183006.GC17659@mtj.duckdns.org>
References: <1442840639-6963-1-git-send-email-pmladek@suse.com>
 <1442840639-6963-5-git-send-email-pmladek@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1442840639-6963-5-git-send-email-pmladek@suse.com>
Sender: owner-linux-mm@kvack.org
To: Petr Mladek <pmladek@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, live-patching@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hello,

On Mon, Sep 21, 2015 at 03:03:45PM +0200, Petr Mladek wrote:
...
> Note that flush() does not guarantee that the queue is empty. drain()
> is more safe. It returns when the queue is really empty. Also it warns

Maybe it'd be better to be a bit more specific.  drain() is safer
because it can handle self-requeueing work items.

> when too many work is being queued when draining.
...
> +/**
> + * destroy_kthread_worker - destroy a kthread worker
> + * @worker: worker to be destroyed
> + *
> + * Destroy @worker. It should be idle when this is called.

So, no new work item should be queued from this point on but @worker
is allowed to be not idle.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
