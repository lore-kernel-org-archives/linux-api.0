From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v3 01/22] timer: Allow to check when the timer callback
 has not finished yet
Date: Wed, 18 Nov 2015 23:32:28 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1511182331010.3761@nanos>
References: <1447853127-3461-1-git-send-email-pmladek@suse.com> <1447853127-3461-2-git-send-email-pmladek@suse.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1447853127-3461-2-git-send-email-pmladek@suse.com>
Sender: owner-linux-mm@kvack.org
To: Petr Mladek <pmladek@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 18 Nov 2015, Petr Mladek wrote:
> timer_pending() checks whether the list of callbacks is empty.
> Each callback is removed from the list before it is called,
> see call_timer_fn() in __run_timers().
> 
> Sometimes we need to make sure that the callback has finished.
> For example, if we want to free some resources that are accessed
> by the callback.
> 
> For this purpose, this patch adds timer_active(). It checks both
> the list of callbacks and the running_timer. It takes the base_lock
> to see a consistent state.
> 
> I plan to use it to implement delayed works in kthread worker.
> But I guess that it will have wider use. In fact, I wonder if
> timer_pending() is misused in some situations.

Well. That's nice and good. But how will that new function solve
anything? After you drop the lock the state is not longer valid.
 
Thanks,

	tglx

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
