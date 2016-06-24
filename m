From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 06/12] kthread: Add kthread_drain_worker()
Date: Fri, 24 Jun 2016 11:54:47 -0400
Message-ID: <20160624155447.GY3262@mtj.duckdns.org>
References: <1466075851-24013-1-git-send-email-pmladek@suse.com>
 <1466075851-24013-7-git-send-email-pmladek@suse.com>
 <20160622205445.GV30909@twins.programming.kicks-ass.net>
 <20160623213258.GO3262@mtj.duckdns.org>
 <20160624070515.GU30154@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20160624070515.GU30154@twins.programming.kicks-ass.net>
Sender: owner-linux-mm@kvack.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hello,

On Fri, Jun 24, 2016 at 09:05:15AM +0200, Peter Zijlstra wrote:
> > Given how rare that is 
> 
> Could you then not remove/rework these few cases for workqueue as well
> and make that 'better' too?

Usage of draining is rare for workqueue but that still means several
legitimate users.  With draining there, it's logical to use it during
shutdown.  I don't think it makes sense to change it on workqueue
side.

> > and the extra
> > complexity of identifying self-requeueing cases, let's forget about
> > draining and on destruction clear the worker pointer to block further
> > queueing and then flush whatever is in flight.
> 
> You're talking about regular workqueues here?

No, kthread worker.  It's unlikely that kthread worker is gonna need
chained draining especially given that most of its usages are gonna be
conversions from raw kthread usages.  We won't lose much if anything
by just ignoring draining and making the code simpler.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
