From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC v2 07/18] kthread: Allow to cancel kthread work
Date: Wed, 7 Oct 2015 07:24:46 -0700
Message-ID: <20151007142446.GA2012@mtj.duckdns.org>
References: <1442840639-6963-1-git-send-email-pmladek@suse.com>
 <1442840639-6963-8-git-send-email-pmladek@suse.com>
 <20150922193513.GE17659@mtj.duckdns.org>
 <20150925112617.GA3122@pathway.suse.cz>
 <20150928170314.GF2589@mtj.duckdns.org>
 <20151002154336.GC3122@pathway.suse.cz>
 <20151002192453.GA7564@mtj.duckdns.org>
 <20151005100758.GK9603@pathway.suse.cz>
 <20151005110924.GL9603@pathway.suse.cz>
 <20151007092130.GD3122@pathway.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151007092130.GD3122@pathway.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Petr Mladek <pmladek@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, live-patching@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hello, Petr.

On Wed, Oct 07, 2015 at 11:21:30AM +0200, Petr Mladek wrote:
> Now, let's have one work: W, two workers: A, B, and try to queue
> the same work to the two workers at the same time:

It's a debug WARN condition to catch silly mistakes.  It can have
minor race conditions.

...
> Second, we still need the busy waiting for the pending timer callback.

Isn't that del_timer_sync()?

> Yes, we could set some flag so that the call back does not queue
> the work. But cancel_kthread_work_sync() still has to wait.
> It could not return if there is still some pending operation
> with the struct kthread_work. Otherwise, it never could
> be freed a safe way.
> 
> Also note that we still need the WORK_PENDING flag. Otherwise, we
> would not be able to detect the race when timer is removed but
> the callback has not run yet.

Yeah, just use a state field as I wrote before.

> Let me to repeat that using per-work and per-worker lock is not an
> option either. We would need some crazy hacks to avoid ABBA deadlocks.
> 
> 
> All in all, I would prefer to keep the original approach that is
> heavily inspired by the workqueues. I think that it is actually
> an advantage to reuse some working concept that reinventing wheels.

At each turn, you come up with non-issues and declare that it needs to
be full workqueue-like implementation but the issues you're raising
seem all rather irrelevant.  Can you please try to take a step back
and put some distance from the implementation details of workqueue?

Thanks.

-- 
tejun
