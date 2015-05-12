From: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 5/6] nohz: support PR_DATAPLANE_STRICT mode
Date: Tue, 12 May 2015 06:20:04 -0700
Message-ID: <20150512132004.GL6776@linux.vnet.ibm.com>
References: <1431107927-13998-1-git-send-email-cmetcalf@ezchip.com>
 <1431107927-13998-6-git-send-email-cmetcalf@ezchip.com>
 <20150512093858.GI21418@twins.programming.kicks-ass.net>
Reply-To: paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150512093858.GI21418-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Srivatsa S. Bhat" <srivatsa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, May 12, 2015 at 11:38:58AM +0200, Peter Zijlstra wrote:
> On Fri, May 08, 2015 at 01:58:46PM -0400, Chris Metcalf wrote:
> > +++ b/kernel/time/tick-sched.c
> > @@ -436,6 +436,20 @@ static void dataplane_quiesce(void)
> >  			(jiffies - start));
> >  		dump_stack();
> >  	}
> > +
> > +	/*
> > +	 * Kill the process if it violates STRICT mode.  Note that this
> > +	 * code also results in killing the task if a kernel bug causes an
> > +	 * irq to be delivered to this core.
> > +	 */
> > +	if ((task->dataplane_flags & (PR_DATAPLANE_STRICT|PR_DATAPLANE_PRCTL))
> > +	    == PR_DATAPLANE_STRICT) {
> > +		pr_warn("Dataplane STRICT mode violated; process killed.\n");
> > +		dump_stack();
> > +		task->dataplane_flags &= ~PR_DATAPLANE_QUIESCE;
> > +		local_irq_enable();
> > +		do_group_exit(SIGKILL);
> > +	}
> >  }
> 
> So while I'm all for hard fails like this, can we not provide a wee bit
> more information in the siginfo ? And maybe use a slightly less fatal
> signal, such that userspace can actually catch it and dump state in
> debug modes?

Agreed, a bit more debug state would be helpful.

							Thanx, Paul
