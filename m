From: Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v9 06/12] kthread: Add kthread_drain_worker()
Date: Wed, 29 Jun 2016 10:17:48 +0200
Message-ID: <20160629081748.GA3238@pathway.suse.cz>
References: <1466075851-24013-1-git-send-email-pmladek@suse.com>
 <1466075851-24013-7-git-send-email-pmladek@suse.com>
 <20160622205445.GV30909@twins.programming.kicks-ass.net>
 <20160623213258.GO3262@mtj.duckdns.org>
 <20160624070515.GU30154@twins.programming.kicks-ass.net>
 <20160624155447.GY3262@mtj.duckdns.org>
 <20160627143350.GA3313@pathway.suse.cz>
 <20160628170447.GE5185@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20160628170447.GE5185@htj.duckdns.org>
Sender: owner-linux-mm@kvack.org
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue 2016-06-28 13:04:47, Tejun Heo wrote:
> Hello,
> 
> On Mon, Jun 27, 2016 at 04:33:50PM +0200, Petr Mladek wrote:
> > OK, so you suggest to do the following:
> > 
> >   1. Add a flag into struct kthread_worker that will prevent
> >      from further queuing.
> 
> This doesn't add any protection, right?  It's getting freed anyway.
> 
> >   2. kthread_create_worker()/kthread_destroy_worker() will
> >      not longer dynamically allocate struct kthread_worker.
> >      They will just start/stop the kthread.
> 
> Ah, okay, I don't think we need to change this.  I was suggesting to
> simplify it by dropping the draining and just do flush from destroy.

I see. But then it does not address the original concern from Peter
Zijlstra. He did not like that the caller was responsible for blocking
further queueing. It still will be needed. Or did I miss something,
please?

Best Regards,
Petr

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
