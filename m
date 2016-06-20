From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 12/12] kthread: Better support freezable kthread
 workers
Date: Mon, 20 Jun 2016 16:30:02 -0400
Message-ID: <20160620203002.GD3262@mtj.duckdns.org>
References: <1466075851-24013-1-git-send-email-pmladek@suse.com>
 <1466075851-24013-13-git-send-email-pmladek@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1466075851-24013-13-git-send-email-pmladek@suse.com>
Sender: owner-linux-mm@kvack.org
To: Petr Mladek <pmladek@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Jun 16, 2016 at 01:17:31PM +0200, Petr Mladek wrote:
> This patch allows to make kthread worker freezable via a new @flags
> parameter. It will allow to avoid an init work in some kthreads.
> 
> It currently does not affect the function of kthread_worker_fn()
> but it might help to do some optimization or fixes eventually.
> 
> I currently do not know about any other use for the @flags
> parameter but I believe that we will want more flags
> in the future.
> 
> Finally, I hope that it will not cause confusion with @flags member
> in struct kthread. Well, I guess that we will want to rework the
> basic kthreads implementation once all kthreads are converted into
> kthread workers or workqueues. It is possible that we will merge
> the two structures.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
