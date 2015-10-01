From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC v2 00/18] kthread: Use kthread worker API more widely
Date: Thu, 1 Oct 2015 17:59:43 +0200
Message-ID: <20151001155943.GE9603@pathway.suse.cz>
References: <1442840639-6963-1-git-send-email-pmladek@suse.com>
 <20150930050833.GA4412@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150930050833.GA4412-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue 2015-09-29 22:08:33, Paul E. McKenney wrote:
> On Mon, Sep 21, 2015 at 03:03:41PM +0200, Petr Mladek wrote:
> > My intention is to make it easier to manipulate kthreads. This RFC tries
> > to use the kthread worker API. It is based on comments from the
> > first attempt. See https://lkml.org/lkml/2015/7/28/648 and
> > the list of changes below.
> > 
> > 1st..8th patches: improve the existing kthread worker API
> > 
> > 9th, 12th, 17th patches: convert three kthreads into the new API,
> >      namely: khugepaged, ring buffer benchmark, RCU gp kthreads[*]
> > 
> > 10th, 11th patches: fix potential problems in the ring buffer
> >       benchmark; also sent separately
> > 
> > 13th patch: small fix for RCU kthread; also sent separately;
> >      being tested by Paul
> > 
> > 14th..16th patches: preparation steps for the RCU threads
> >      conversion; they are needed _only_ if we split GP start
> >      and QS handling into separate works[*]
> > 
> > 18th patch: does a possible improvement of the kthread worker API;
> >      it adds an extra parameter to the create*() functions, so I
> >      rather put it into this draft
> >      
> > 
> > [*] IMPORTANT: I tried to split RCU GP start and GS state handling
> >     into separate works this time. But there is a problem with
> >     a race in rcu_gp_kthread_worker_poke(). It might queue
> >     the wrong work. It can be detected and fixed by the work
> >     itself but it is a bit ugly. Alternative solution is to
> >     do both operations in one work. But then we sleep too much
> >     in the work which is ugly as well. Any idea is appreciated.
> 
> I think that the kernel is trying really hard to tell you that splitting
> up the RCU grace-period kthreads in this manner is not such a good idea.

Yup, I guess that it would be better to stay with the approach taken
in the previous RFC. I mean to start the grace period and handle
the quiescent state in a single work. See
https://lkml.org/lkml/2015/7/28/650  It basically keeps the
functionality. The only difference is that we regularly leave
the RCU-specific function, so it will be possible to patch it.

The RCU kthreads are very special because they basically ignore
freezer and they never stop. They do not show well the advantage
of any new API. I tried to convert them primary because they were
so sensitive. I thought that it was good for testing limits
of the API.


> So what are we really trying to accomplish here?  I am guessing something
> like the following:
> 
> 1.	Get each grace-period kthread to a known safe state within a
> 	short time of having requested a safe state.  If I recall
> 	correctly, the point of this is to allow no-downtime kernel
> 	patches to the functions executed by the grace-period kthreads.
> 
> 2.	At the same time, if someone suddenly needs a grace period
> 	at some point in this process, the grace period kthreads are
> 	going to have to wake back up and handle the grace period.
> 	Or do you have some tricky way to guarantee that no one is
> 	going to need a grace period beyond the time you freeze
> 	the grace-period kthreads?
> 
> 3.	The boost kthreads should not be a big problem because failing
> 	to boost simply lets the grace period run longer.
> 
> 4.	The callback-offload kthreads are likely to be a big problem,
> 	because in systems configured with them, they need to be running
> 	to invoke the callbacks, and if the callbacks are not invoked,
> 	the grace period might just as well have failed to end.
> 
> 5.	The per-CPU kthreads are in the same boat as the callback-offload
> 	kthreads.  One approach is to offline all the CPUs but one, and
> 	that will park all but the last per-CPU kthread.  But handling
> 	that last per-CPU kthread would likely be "good clean fun"...
> 
> 6.	Other requirements?
> 
> One approach would be to simply say that the top-level rcu_gp_kthread()
> function cannot be patched, and arrange for the grace-period kthreads
> to park at some point within this function.  Or is there some requirement
> that I am missing?

I am a bit confused by the above paragraphs because they mix patching,
stopping, and parking. Note that we do not need to stop any process
when live patching.

I hope that it is more clear after my response in the other mail about
freezing. Or maybe, I am missing something.

Anyway, thanks a lot for looking at the patches and feedback.


Best Regards,
Petr
