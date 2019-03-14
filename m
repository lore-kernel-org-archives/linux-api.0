From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v7 01/15] sched/core: uclamp: Add CPU's clamp buckets
 refcounting
Date: Thu, 14 Mar 2019 11:03:30 +0000
Message-ID: <20190314110330.rshrdeoxgzt6pk5a@e110439-lin>
References: <20190208100554.32196-1-patrick.bellasi@arm.com>
 <20190208100554.32196-2-patrick.bellasi@arm.com>
 <20190313135238.GC5922@hirez.programming.kicks-ass.net>
 <20190313155954.jse2tyn5iqxm6wle@e110439-lin>
 <20190313193056.GP2482@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190313193056.GP2482@worktop.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 13-Mar 20:30, Peter Zijlstra wrote:
> On Wed, Mar 13, 2019 at 03:59:54PM +0000, Patrick Bellasi wrote:
> > On 13-Mar 14:52, Peter Zijlstra wrote:
> > > > +static inline void uclamp_rq_dec_id(struct task_struct *p, struct rq *rq,
> > > > +				    unsigned int clamp_id)
> > > > +{
> > > > +	unsigned int bucket_id = p->uclamp[clamp_id].bucket_id;
> > > > +	unsigned int rq_clamp, bkt_clamp;
> > > > +
> > > > +	SCHED_WARN_ON(!rq->uclamp[clamp_id].bucket[bucket_id].tasks);
> > > > +	if (likely(rq->uclamp[clamp_id].bucket[bucket_id].tasks))
> > > > +		rq->uclamp[clamp_id].bucket[bucket_id].tasks--;
> > > > +
> > > > +	/*
> > > > +	 * Keep "local clamping" simple and accept to (possibly) overboost
> > > > +	 * still RUNNABLE tasks in the same bucket.
> > > > +	 */
> > > > +	if (likely(rq->uclamp[clamp_id].bucket[bucket_id].tasks))
> > > > +		return;
> > > 
> > > (Oh man, I hope that generates semi sane code; long live CSE passes I
> > > suppose)
> > 
> > What do you mean ?
> 
> that does: 'rq->uclamp[clamp_id].bucket[bucket_id].tasks' three times in
> a row. And yes the compiler _should_ dtrt, but....

Sorry, don't follow you here... but it's an interesting point. :)

The code above becomes:

   if (__builtin_expect(!!(rq->uclamp[clamp_id].bucket[bucket_id].tasks), 1))
           return;

Are you referring to the resolution of the memory references, i.e
   1) rq->uclamp
   2) rq->uclamp[clamp_id]
   3) rq->uclamp[clamp_id].bucket[bucket_id]
?

By playing with:

   https://godbolt.org/z/OPLpyR

I can see that this simplified version:

---8<---
#define BUCKETS 5
#define CLAMPS 2

struct uclamp {
    unsigned int value;
    struct bucket {
        unsigned int value;
        unsigned int tasks;
    } bucket[BUCKETS];
};

struct rq {
    struct uclamp uclamp[CLAMPS];
};

void uclamp_rq_dec_id(struct rq *rq, int clamp_id, int bucket_id) {
    if (__builtin_expect(!!(rq->uclamp[clamp_id].bucket[bucket_id].tasks), 1))
        return;
    rq->uclamp[clamp_id].bucket[bucket_id].tasks--;
}
---8<---

generates something like:

---8<---
uclamp_rq_dec_id:
        sxtw    x1, w1
        add     x3, x1, x1, lsl 1
        lsl     x3, x3, 2
        sub     x3, x3, x1
        lsl     x3, x3, 2
        add     x2, x3, x2, sxtw 3
        add     x0, x0, x2
        ldr     w1, [x0, 8]
        cbz     w1, .L4
        ret
.L4:
        mov     w1, -1
        str     w1, [x0, 8]
        ret
---8<---


which looks "sane" and quite expected, isn't it?

-- 
#include <best/regards.h>

Patrick Bellasi
