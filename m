From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 02/12] kthread: Kthread worker API cleanup
Date: Mon, 20 Jun 2016 15:27:08 -0400
Message-ID: <20160620192708.GT3262@mtj.duckdns.org>
References: <1466075851-24013-1-git-send-email-pmladek@suse.com>
 <1466075851-24013-3-git-send-email-pmladek@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1466075851-24013-3-git-send-email-pmladek@suse.com>
Sender: owner-linux-mm@kvack.org
To: Petr Mladek <pmladek@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hello,

On Thu, Jun 16, 2016 at 01:17:21PM +0200, Petr Mladek wrote:
> __init_kthread_worker()		-> __kthread_init_worker()
> init_kthread_worker()		-> kthread_init_worker()
> init_kthread_work()		-> kthread_init_work()
> insert_kthread_work()		-> kthread_insert_work()
> queue_kthread_work()		-> kthread_queue_work()
> flush_kthread_work()		-> kthread_flush_work()
> flush_kthread_worker()		-> kthread_flush_worker()

I wonder whether the subsystem name here is more the whole
kthread_worker rather than just kthread but I can't think of a good
single syllable abbrev for it.  It's a bikeshedding anyway.

> Note that the names of DEFINE_KTHREAD_WORK*() macros stay
> as they are. It is common that the "DEFINE_" prefix has
> precedence over the subsystem names.
> 
> INIT_() macros are similar to DEFINE_. Therefore this patch
> renames:
> 
> KTHREAD_WORKER_INIT()		-> INIT_KTHREAD_WORKER()
> KTHREAD_WORK_INIT()		-> INIT_KTHREAD_WORK()

So, they're different.  In the above cases, INIT doesn't stand for the
verb INITIALIZE but its noun form INITIALIZER.  These aren't
operations and thus different from DEFINE_XXX().

	kthread_init_worker	= kthread: initialize worker
	KTHREAD_WORKER_INIT	= kthread: worker initializer

I think it makes a lot more sense to keep _INIT at the end for these.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
