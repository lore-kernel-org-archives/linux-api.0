From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v8 01/16] sched/core: uclamp: Add CPU's clamp buckets
 refcounting
Date: Mon, 8 Apr 2019 12:49:08 +0100
Message-ID: <20190408114908.evij7pqml6ltqtnl@e110439-lin>
References: <20190402104153.25404-1-patrick.bellasi@arm.com>
 <20190402104153.25404-2-patrick.bellasi@arm.com>
 <CAJuCfpFdDK+xYZDq+TDVjRUcF8BTqeXWvF2Wex8n7nB-O5qH1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJuCfpFdDK+xYZDq+TDVjRUcF8BTqeXWvF2Wex8n7nB-O5qH1g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suren Baghdasaryan <surenb@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>
List-Id: linux-api@vger.kernel.org

On 06-Apr 16:51, Suren Baghdasaryan wrote:
> On Tue, Apr 2, 2019 at 3:42 AM Patrick Bellasi <patrick.bellasi@arm.com> wrote:

[...]

> > + * The first few values calculated by this routine:
> > + * bf(0) = 1
> > + * bf(1) = 1
> > + * bf(2) = 2
> > + * bf(3) = 2
> > + * bf(4) = 3
> > + * ... and so on.
> > + */
> > +#define bits_per(n)                            \
> > +(                                              \
> > +       __builtin_constant_p(n) ? (             \
> > +               ((n) == 0 || (n) == 1) ? 1 : (  \
> > +               ((n) & (n - 1)) == 0 ?          \
> 
> missing braces around 'n'
> -               ((n) & (n - 1)) == 0 ?          \
> +               ((n) & ((n) - 1)) == 0 ?          \
> 
> > +                       ilog2((n) - 1) + 2 :    \
> > +                       ilog2((n) - 1) + 1      \
> 
> Isn't this "((n) & ((n) - 1)) == 0 ?  ilog2((n) - 1) + 2 : ilog2((n) -
> 1) + 1" expression equivalent to a simple "ilog2(n) + 1"?

Right, since we already have n=0 and n=1 as special cases, what you
propose should work for all n>=2.

> 
> > +               )                               \
> > +       ) :                                     \
> > +       __bits_per(n)                           \
> > +)
> >  #endif /* _LINUX_LOG2_H */

[...]

> > +static inline unsigned int uclamp_bucket_base_value(unsigned int clamp_value)
> 
> Where are you using uclamp_bucket_base_value()? I would expect its
> usage somewhere inside uclamp_rq_dec_id() when the last task in the
> bucket is dequeued but I don't see it...

This behavior is not move into a dedicated patch, as per Peter
request:

   Message-ID: <20190314111849.gx6bl6myfjtaan7r@e110439-lin>

This functions was left here to support a the intialization code in
init_uclamp() but... I notice know I'm doing the initialization in a
different way thus, I'll move it into the following patch.

> > +{
> > +       return UCLAMP_BUCKET_DELTA * uclamp_bucket_id(clamp_value);
> > +}
> > +

[...]

> > +static inline void uclamp_rq_dec_id(struct task_struct *p, struct rq *rq,
> > +                                   unsigned int clamp_id)
> > +{
> > +       struct uclamp_rq *uc_rq = &rq->uclamp[clamp_id];
> > +       struct uclamp_se *uc_se = &p->uclamp[clamp_id];
> > +       struct uclamp_bucket *bucket;
> > +       unsigned int rq_clamp;
> > +
> > +       bucket = &uc_rq->bucket[uc_se->bucket_id];
> > +       SCHED_WARN_ON(!bucket->tasks);
> > +       if (likely(bucket->tasks))
> > +               bucket->tasks--;
> > +
> > +       if (likely(bucket->tasks))
> 
> Shouldn't you adjust bucket->value if the remaining tasks in the
> bucket have a lower clamp value than the task that was just removed?

No, this is never done. As long as a bucket is not empty/idle we never
reset it to its nominal value. In this patch specifically, the value
is never changed since we moved the "local max tracking" bits into a
dedicated patch.

> > +               return;
> > +
> > +       rq_clamp = READ_ONCE(uc_rq->value);
> > +       /*
> > +        * Defensive programming: this should never happen. If it happens,
> > +        * e.g. due to future modification, warn and fixup the expected value.
> > +        */
> > +       SCHED_WARN_ON(bucket->value > rq_clamp);
> > +       if (bucket->value >= rq_clamp)
> > +               WRITE_ONCE(uc_rq->value, uclamp_rq_max_value(rq, clamp_id));
> > +}

[...]

> > +static void __init init_uclamp(void)
> > +{
> > +       unsigned int clamp_id;
> > +       int cpu;
> > +
> > +       for_each_possible_cpu(cpu) {
> > +               struct uclamp_bucket *bucket;
> > +               struct uclamp_rq *uc_rq;
> > +               unsigned int bucket_id;
> > +
> > +               memset(&cpu_rq(cpu)->uclamp, 0, sizeof(struct uclamp_rq));
> > +
> > +               for (clamp_id = 0; clamp_id < UCLAMP_CNT; ++clamp_id) {
> > +                       uc_rq = &cpu_rq(cpu)->uclamp[clamp_id];
> > +
> > +                       bucket_id = 1;
> > +                       while (bucket_id < UCLAMP_BUCKETS) {
> > +                               bucket = &uc_rq->bucket[bucket_id];
> > +                               bucket->value = bucket_id * UCLAMP_BUCKET_DELTA;
> > +                               ++bucket_id;
> > +                       }
> > +               }
> > +       }

All the initialization code above is not more required after the next
patch introducing "local max tracking".

> > +
> > +       for (clamp_id = 0; clamp_id < UCLAMP_CNT; ++clamp_id) {
> > +               struct uclamp_se *uc_se = &init_task.uclamp[clamp_id];
> > +
> > +               uc_se->value = uclamp_none(clamp_id);
> > +               uc_se->bucket_id = uclamp_bucket_id(uc_se->value);
> > +       }
> > +}

[...]

-- 
#include <best/regards.h>

Patrick Bellasi
