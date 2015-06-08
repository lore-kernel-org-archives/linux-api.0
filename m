From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH 09/18] kthread: Make it easier to correctly sleep in
 iterant kthreads
Date: Mon, 08 Jun 2015 13:39:55 +0200
Message-ID: <1433763595.1495.35.camel@twins>
References: <1433516477-5153-1-git-send-email-pmladek@suse.cz>
	 <1433516477-5153-10-git-send-email-pmladek@suse.cz>
	 <20150605161021.GJ19282@twins.programming.kicks-ass.net>
	 <20150608100107.GA3135@pathway.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150608100107.GA3135@pathway.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Petr Mladek <pmladek@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>, Richard Weinberger <richard@nod.at>, Steven Rostedt <rostedt@goodmis.org>, David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, linux-nfs@vger.kernel.org, Chris Mason <clm@fb.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, live-patching@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 2015-06-08 at 12:01 +0200, Petr Mladek wrote:

> Just to be sure. Do you suggest to use TASK_IDLE everywhere in
> kthreads or only when the uninterruptible sleep is really needed?

Always, only use INTERRUPTIBLE when you're actually interruptible, that
is you want signals or such muck to terminate your wait.

> IMHO, we should not use TASK_IDLE in freezable kthreads because
> it would break freezing.

How so? The task is IDLE, its not doing anything.

>  Well, we could freezable_schedule() but only
> on locations where it is safe to get freezed. Anyway, we need to
> be careful here.

s/freezed/frozen/

Bah, you made me look at the freezer code, karma reduction for you.

And this is the arch typical freeze point if ever there was one, you're
checking kthread_stop, if we can terminate the kthread, we can certainly
get frozen.

> BTW: What is the preferred way of freezing, please? Is it better
> to end up in the fridge or is it fine to call freezer_do_not_count();
> or set PF_NOFREEZE when it is safe?

freezable_schedule() is fine in this case.
