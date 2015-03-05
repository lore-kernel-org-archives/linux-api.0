From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v3 0/3] epoll: introduce round robin wakeup mode
Date: Thu, 5 Mar 2015 01:02:25 +0100
Message-ID: <20150305000225.GA27592@gmail.com>
References: <cover.1424805740.git.jbaron@akamai.com>
 <20150225073814.GA14558@gmail.com>
 <54EDF7D8.60201@akamai.com>
 <20150227131034.2f2787dcabf285191a1f6ffa@linux-foundation.org>
 <54F0E93C.3010306@akamai.com>
 <20150227143158.afa4ec39d49d5815cbbd6a6c@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150227143158.afa4ec39d49d5815cbbd6a6c@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Baron <jbaron@akamai.com>, peterz@infradead.org, mingo@redhat.com, viro@zeniv.linux.org.uk, normalperson@yhbt.net, davidel@xmailserver.org, mtk.manpages@gmail.com, luto@amacapital.net, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Alexander Viro <viro@ftp.linux.org.uk>
List-Id: linux-api@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 27 Feb 2015 17:01:32 -0500 Jason Baron <jbaron@akamai.com> wrote:
> 
> > 
> > >
> > > I don't really understand the need for rotation/round-robin.  We can
> > > solve the thundering herd via exclusive wakeups, but what is the point
> > > in choosing to wake the task which has been sleeping for the longest
> > > time?  Why is that better than waking the task which has been sleeping
> > > for the *least* time?  That's probably faster as that task's data is
> > > more likely to still be in cache.
> > >
> > > The changelogs talks about "starvation" but they don't really say what
> > > this term means in this context, nor why it is a bad thing.
> > >
> 
> I'm still not getting it.
> 
> > So the idea with the 'rotation' is to try and distribute the
> > workload more evenly across the worker threads.
> 
> Why?
> 
> > We currently
> > tend to wake up the 'head' of the queue over and over and
> > thus the workload for us is not evenly distributed.
> 
> What's wrong with that?
> 
> > In fact, we
> > have a workload where we have to remove all the epoll sets
> > and then re-add them in a different order to improve the situation.
> 
> Why?

So my guess would be (but Jason would know this more precisely) that 
spreading the workload to more tasks in a FIFO manner, the individual 
tasks can move between CPUs better, and fill in available CPU 
bandwidth better, increasing concurrency.

With the current LIFO distribution of wakeups, the 'busiest' threads 
will get many wakeups (potentially from different CPUs), making them 
cache-hot, which may interfere with them easily migrating across CPUs.

So while technically both approaches have similar concurrency, the 
more 'spread out' task hierarchy schedules in a more consistent 
manner.

But ... this is just a wild guess and even if my description is 
accurate then it should still be backed by robust measurements and 
observations, before we extend the ABI.

This hypothesis could be tested by the patch below: with the patch 
applied if the performance difference between FIFO and LIFO epoll 
wakeups disappears, then the root cause is the cache-hotness code in 
the scheduler.

Thanks,

	Ingo

---

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ee595ef30470..89af04e946d2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5354,7 +5354,7 @@ static int task_hot(struct task_struct *p, struct lb_env *env)
 
 	lockdep_assert_held(&env->src_rq->lock);
 
-	if (p->sched_class != &fair_sched_class)
+	if (1 || p->sched_class != &fair_sched_class)
 		return 0;
 
 	if (unlikely(p->policy == SCHED_IDLE))
