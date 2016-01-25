From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 01/22] timer: Allow to check when the timer callback
 has not finished yet
Date: Mon, 25 Jan 2016 13:44:38 -0500
Message-ID: <20160125184438.GA3628@mtj.duckdns.org>
References: <1453736711-6703-1-git-send-email-pmladek@suse.com>
 <1453736711-6703-2-git-send-email-pmladek@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1453736711-6703-2-git-send-email-pmladek@suse.com>
Sender: owner-linux-mm@kvack.org
To: Petr Mladek <pmladek@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hello,

On Mon, Jan 25, 2016 at 04:44:50PM +0100, Petr Mladek wrote:
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

I don't think this is still necessary.  More on this later.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
