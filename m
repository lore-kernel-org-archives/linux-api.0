From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v7 01/15] sched/core: uclamp: Add CPU's clamp buckets refcounting
Date: Thu, 14 Mar 2019 08:29:48 -0700
Message-ID: <CAJuCfpFDVi7O+yqQ+F0DT3pRZN=BtRD8NyUH5Tys0VVkd9JAGg@mail.gmail.com>
References: <20190208100554.32196-1-patrick.bellasi@arm.com>
 <20190208100554.32196-2-patrick.bellasi@arm.com> <CAJuCfpGAZ6XxJj=e-wVzGx3zmRRLPs=wXm8K0BcjWOm5hM0FcQ@mail.gmail.com>
 <20190314144600.2ulpeipad7jbxyiy@e110439-lin>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190314144600.2ulpeipad7jbxyiy@e110439-lin>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 14, 2019 at 7:46 AM Patrick Bellasi <patrick.bellasi@arm.com> wrote:
>
> On 13-Mar 14:32, Suren Baghdasaryan wrote:
> > On Fri, Feb 8, 2019 at 2:06 AM Patrick Bellasi <patrick.bellasi@arm.com> wrote:
> > >
> > > Utilization clamping allows to clamp the CPU's utilization within a
> > > [util_min, util_max] range, depending on the set of RUNNABLE tasks on
> > > that CPU. Each task references two "clamp buckets" defining its minimum
> > > and maximum (util_{min,max}) utilization "clamp values". A CPU's clamp
> > > bucket is active if there is at least one RUNNABLE tasks enqueued on
> > > that CPU and refcounting that bucket.
> > >
> > > When a task is {en,de}queued {on,from} a rq, the set of active clamp
> > > buckets on that CPU can change. Since each clamp bucket enforces a
> > > different utilization clamp value, when the set of active clamp buckets
> > > changes, a new "aggregated" clamp value is computed for that CPU.
> > >
> > > Clamp values are always MAX aggregated for both util_min and util_max.
> > > This ensures that no tasks can affect the performance of other
> > > co-scheduled tasks which are more boosted (i.e. with higher util_min
> > > clamp) or less capped (i.e. with higher util_max clamp).
> > >
> > > Each task has a:
> > >    task_struct::uclamp[clamp_id]::bucket_id
> > > to track the "bucket index" of the CPU's clamp bucket it refcounts while
> > > enqueued, for each clamp index (clamp_id).
> > >
> > > Each CPU's rq has a:
> > >    rq::uclamp[clamp_id]::bucket[bucket_id].tasks
> > > to track how many tasks, currently RUNNABLE on that CPU, refcount each
> > > clamp bucket (bucket_id) of a clamp index (clamp_id).
> > >
> > > Each CPU's rq has also a:
> > >    rq::uclamp[clamp_id]::bucket[bucket_id].value
> > > to track the clamp value of each clamp bucket (bucket_id) of a clamp
> > > index (clamp_id).
> > >
> > > The rq::uclamp::bucket[clamp_id][] array is scanned every time we need
> > > to find a new MAX aggregated clamp value for a clamp_id. This operation
> > > is required only when we dequeue the last task of a clamp bucket
> > > tracking the current MAX aggregated clamp value. In these cases, the CPU
> > > is either entering IDLE or going to schedule a less boosted or more
> > > clamped task.
> > > The expected number of different clamp values, configured at build time,
> > > is small enough to fit the full unordered array into a single cache
> > > line.
> >
> > I assume you are talking about "struct uclamp_rq uclamp[UCLAMP_CNT]"
> > here.
>
> No, I'm talking about the rq::uclamp::bucket[clamp_id][], which is an
> array of:
>
>    struct uclamp_bucket {
>         unsigned long value : bits_per(SCHED_CAPACITY_SCALE);
>         unsigned long tasks : BITS_PER_LONG - bits_per(SCHED_CAPACITY_SCALE);
>    };
>
> defined as part of:
>
>    struct uclamp_rq {
>         unsigned int value;
>         struct uclamp_bucket bucket[UCLAMP_BUCKETS];
>    };
>
>
> So, it's an array of UCLAMP_BUCKETS (value, tasks) pairs.
>
> > uclamp_rq size depends on UCLAMP_BUCKETS configurable to be up
> > to 20. sizeof(long)*20 is already more than 64 bytes. What am I
> > missing?
>
> Right, the comment above refers to the default configuration, which is
> 5 buckets. With that configuration we have:
>
>
> $> pahole kernel/sched/core.o
>
> ---8<---
>    struct uclamp_bucket {
>            long unsigned int          value:11;             /*     0:53  8 */
>            long unsigned int          tasks:53;             /*     0: 0  8 */
>
>            /* size: 8, cachelines: 1, members: 2 */
>            /* last cacheline: 8 bytes */
>    };
>
>    struct uclamp_rq {
>            unsigned int               value;                /*     0     4 */
>
>            /* XXX 4 bytes hole, try to pack */
>
>            struct uclamp_bucket       bucket[5];            /*     8    40 */
>
>            /* size: 48, cachelines: 1, members: 2 */
>            /* sum members: 44, holes: 1, sum holes: 4 */
>            /* last cacheline: 48 bytes */
>    };
>
>    struct rq {
>            // ...
>            /* --- cacheline 2 boundary (128 bytes) --- */
>            struct uclamp_rq           uclamp[2];            /*   128    96 */
>            /* --- cacheline 3 boundary (192 bytes) was 32 bytes ago --- */
>            // ...
>    };
> ---8<---
>
> Where you see the array fits into a single cache line.
>
> Actually I notice now that, since when we removed the bucket dedicated
> to the default values, we now have some spare space and we can
> probably increase the default (and minimum) value of UCLAMP_BUCKETS to
> be 7.
>
> This will uses two full cache lines in struct rq, one for each clamp
> index...  Although 7 it's a bit of a odd number and gives by default
> buckets of ~14% size instead of the ~20%.
>
> Thoughts ?

Got it. From reading the documentation at the beginning my impression
was that whatever value I choose within allowed 5-20 range it would
still fit in a cache line. To disambiguate it might be worse
mentioning that this is true for the default value or for values up to
7. Thanks!

> [...]
>
> --
> #include <best/regards.h>
>
> Patrick Bellasi
