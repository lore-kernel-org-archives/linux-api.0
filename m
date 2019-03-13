From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v7 01/15] sched/core: uclamp: Add CPU's clamp buckets refcounting
Date: Wed, 13 Mar 2019 14:32:23 -0700
Message-ID: <CAJuCfpGAZ6XxJj=e-wVzGx3zmRRLPs=wXm8K0BcjWOm5hM0FcQ@mail.gmail.com>
References: <20190208100554.32196-1-patrick.bellasi@arm.com> <20190208100554.32196-2-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190208100554.32196-2-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 8, 2019 at 2:06 AM Patrick Bellasi <patrick.bellasi@arm.com> wrote:
>
> Utilization clamping allows to clamp the CPU's utilization within a
> [util_min, util_max] range, depending on the set of RUNNABLE tasks on
> that CPU. Each task references two "clamp buckets" defining its minimum
> and maximum (util_{min,max}) utilization "clamp values". A CPU's clamp
> bucket is active if there is at least one RUNNABLE tasks enqueued on
> that CPU and refcounting that bucket.
>
> When a task is {en,de}queued {on,from} a rq, the set of active clamp
> buckets on that CPU can change. Since each clamp bucket enforces a
> different utilization clamp value, when the set of active clamp buckets
> changes, a new "aggregated" clamp value is computed for that CPU.
>
> Clamp values are always MAX aggregated for both util_min and util_max.
> This ensures that no tasks can affect the performance of other
> co-scheduled tasks which are more boosted (i.e. with higher util_min
> clamp) or less capped (i.e. with higher util_max clamp).
>
> Each task has a:
>    task_struct::uclamp[clamp_id]::bucket_id
> to track the "bucket index" of the CPU's clamp bucket it refcounts while
> enqueued, for each clamp index (clamp_id).
>
> Each CPU's rq has a:
>    rq::uclamp[clamp_id]::bucket[bucket_id].tasks
> to track how many tasks, currently RUNNABLE on that CPU, refcount each
> clamp bucket (bucket_id) of a clamp index (clamp_id).
>
> Each CPU's rq has also a:
>    rq::uclamp[clamp_id]::bucket[bucket_id].value
> to track the clamp value of each clamp bucket (bucket_id) of a clamp
> index (clamp_id).
>
> The rq::uclamp::bucket[clamp_id][] array is scanned every time we need
> to find a new MAX aggregated clamp value for a clamp_id. This operation
> is required only when we dequeue the last task of a clamp bucket
> tracking the current MAX aggregated clamp value. In these cases, the CPU
> is either entering IDLE or going to schedule a less boosted or more
> clamped task.
> The expected number of different clamp values, configured at build time,
> is small enough to fit the full unordered array into a single cache
> line.

I assume you are talking about "struct uclamp_rq uclamp[UCLAMP_CNT]"
here. uclamp_rq size depends on UCLAMP_BUCKETS configurable to be up
to 20. sizeof(long)*20 is already more than 64 bytes. What am I
missing?

> Add the basic data structures required to refcount, in each CPU's rq,
> the number of RUNNABLE tasks for each clamp bucket. Add also the max
> aggregation required to update the rq's clamp value at each
> enqueue/dequeue event.
>
> Use a simple linear mapping of clamp values into clamp buckets.
> Pre-compute and cache bucket_id to avoid integer divisions at
> enqueue/dequeue time.
>
> Signed-off-by: Patrick Bellasi <patrick.bellasi@arm.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
>
> ---
> Changes in v7:
>  Message-ID: <20190123191007.GG17749@hirez.programming.kicks-ass.net>
>  - removed buckets mapping code
>  - use a simpler linear mapping of clamp values into buckets
>  Message-ID: <20190124161443.lv2pw5fsspyelckq@e110439-lin>
>  - move this patch at the beginning of the series,
>    in the attempt to make the overall series easier to digest by moving
>    at the very beginning the core bits and main data structures
>  Others:
>  - update the mapping logic to use exactly and only
>    UCLAMP_BUCKETS_COUNT buckets, i.e. no more "special" bucket
>  - update uclamp_rq_update() to do top-bottom max search
> ---
>  include/linux/log2.h           |  37 ++++++++
>  include/linux/sched.h          |  39 ++++++++
>  include/linux/sched/topology.h |   6 --
>  init/Kconfig                   |  53 +++++++++++
>  kernel/sched/core.c            | 165 +++++++++++++++++++++++++++++++++
>  kernel/sched/sched.h           |  59 +++++++++++-
>  6 files changed, 350 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/log2.h b/include/linux/log2.h
> index 2af7f77866d0..e2db25734532 100644
> --- a/include/linux/log2.h
> +++ b/include/linux/log2.h
> @@ -224,4 +224,41 @@ int __order_base_2(unsigned long n)
>                 ilog2((n) - 1) + 1) :           \
>         __order_base_2(n)                       \
>  )
> +
> +static inline __attribute__((const))
> +int __bits_per(unsigned long n)
> +{
> +       if (n < 2)
> +               return 1;
> +       if (is_power_of_2(n))
> +               return order_base_2(n) + 1;
> +       return order_base_2(n);
> +}
> +
> +/**
> + * bits_per - calculate the number of bits required for the argument
> + * @n: parameter
> + *
> + * This is constant-capable and can be used for compile time
> + * initiaizations, e.g bitfields.
> + *
> + * The first few values calculated by this routine:
> + * bf(0) = 1
> + * bf(1) = 1
> + * bf(2) = 2
> + * bf(3) = 2
> + * bf(4) = 3
> + * ... and so on.
> + */
> +#define bits_per(n)                            \
> +(                                              \
> +       __builtin_constant_p(n) ? (             \
> +               ((n) == 0 || (n) == 1) ? 1 : (  \
> +               ((n) & (n - 1)) == 0 ?          \
> +                       ilog2((n) - 1) + 2 :    \
> +                       ilog2((n) - 1) + 1      \
> +               )                               \
> +       ) :                                     \
> +       __bits_per(n)                           \
> +)
>  #endif /* _LINUX_LOG2_H */
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 4112639c2a85..45460e7a3eee 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -281,6 +281,18 @@ struct vtime {
>         u64                     gtime;
>  };
>
> +/*
> + * Utilization clamp constraints.
> + * @UCLAMP_MIN:        Minimum utilization
> + * @UCLAMP_MAX:        Maximum utilization
> + * @UCLAMP_CNT:        Utilization clamp constraints count
> + */
> +enum uclamp_id {
> +       UCLAMP_MIN = 0,
> +       UCLAMP_MAX,
> +       UCLAMP_CNT
> +};
> +
>  struct sched_info {
>  #ifdef CONFIG_SCHED_INFO
>         /* Cumulative counters: */
> @@ -312,6 +324,10 @@ struct sched_info {
>  # define SCHED_FIXEDPOINT_SHIFT                10
>  # define SCHED_FIXEDPOINT_SCALE                (1L << SCHED_FIXEDPOINT_SHIFT)
>
> +/* Increase resolution of cpu_capacity calculations */
> +# define SCHED_CAPACITY_SHIFT          SCHED_FIXEDPOINT_SHIFT
> +# define SCHED_CAPACITY_SCALE          (1L << SCHED_CAPACITY_SHIFT)
> +
>  struct load_weight {
>         unsigned long                   weight;
>         u32                             inv_weight;
> @@ -560,6 +576,25 @@ struct sched_dl_entity {
>         struct hrtimer inactive_timer;
>  };
>
> +#ifdef CONFIG_UCLAMP_TASK
> +/* Number of utilization clamp buckets (shorter alias) */
> +#define UCLAMP_BUCKETS CONFIG_UCLAMP_BUCKETS_COUNT
> +
> +/*
> + * Utilization clamp for a scheduling entity
> + * @value:             clamp value "requested" by a se
> + * @bucket_id:         clamp bucket corresponding to the "requested" value
> + *
> + * The bucket_id is the index of the clamp bucket matching the clamp value
> + * which is pre-computed and stored to avoid expensive integer divisions from
> + * the fast path.
> + */
> +struct uclamp_se {
> +       unsigned int value              : bits_per(SCHED_CAPACITY_SCALE);
> +       unsigned int bucket_id          : bits_per(UCLAMP_BUCKETS);
> +};
> +#endif /* CONFIG_UCLAMP_TASK */
> +
>  union rcu_special {
>         struct {
>                 u8                      blocked;
> @@ -640,6 +675,10 @@ struct task_struct {
>  #endif
>         struct sched_dl_entity          dl;
>
> +#ifdef CONFIG_UCLAMP_TASK
> +       struct uclamp_se                uclamp[UCLAMP_CNT];
> +#endif
> +
>  #ifdef CONFIG_PREEMPT_NOTIFIERS
>         /* List of struct preempt_notifier: */
>         struct hlist_head               preempt_notifiers;
> diff --git a/include/linux/sched/topology.h b/include/linux/sched/topology.h
> index c31d3a47a47c..04beadac6985 100644
> --- a/include/linux/sched/topology.h
> +++ b/include/linux/sched/topology.h
> @@ -6,12 +6,6 @@
>
>  #include <linux/sched/idle.h>
>
> -/*
> - * Increase resolution of cpu_capacity calculations
> - */
> -#define SCHED_CAPACITY_SHIFT   SCHED_FIXEDPOINT_SHIFT
> -#define SCHED_CAPACITY_SCALE   (1L << SCHED_CAPACITY_SHIFT)
> -
>  /*
>   * sched-domains (multiprocessor balancing) declarations:
>   */
> diff --git a/init/Kconfig b/init/Kconfig
> index 513fa544a134..34e23d5d95d1 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -640,6 +640,59 @@ config HAVE_UNSTABLE_SCHED_CLOCK
>  config GENERIC_SCHED_CLOCK
>         bool
>
> +menu "Scheduler features"
> +
> +config UCLAMP_TASK
> +       bool "Enable utilization clamping for RT/FAIR tasks"
> +       depends on CPU_FREQ_GOV_SCHEDUTIL
> +       help
> +         This feature enables the scheduler to track the clamped utilization
> +         of each CPU based on RUNNABLE tasks scheduled on that CPU.
> +
> +         With this option, the user can specify the min and max CPU
> +         utilization allowed for RUNNABLE tasks. The max utilization defines
> +         the maximum frequency a task should use while the min utilization
> +         defines the minimum frequency it should use.
> +
> +         Both min and max utilization clamp values are hints to the scheduler,
> +         aiming at improving its frequency selection policy, but they do not
> +         enforce or grant any specific bandwidth for tasks.
> +
> +         If in doubt, say N.
> +
> +config UCLAMP_BUCKETS_COUNT
> +       int "Number of supported utilization clamp buckets"
> +       range 5 20
> +       default 5
> +       depends on UCLAMP_TASK
> +       help
> +         Defines the number of clamp buckets to use. The range of each bucket
> +         will be SCHED_CAPACITY_SCALE/UCLAMP_BUCKETS_COUNT. The higher the
> +         number of clamp buckets the finer their granularity and the higher
> +         the precision of clamping aggregation and tracking at run-time.
> +
> +         For example, with the default configuration we will have 5 clamp
> +         buckets tracking 20% utilization each. A 25% boosted tasks will be
> +         refcounted in the [20..39]% bucket and will set the bucket clamp
> +         effective value to 25%.
> +         If a second 30% boosted task should be co-scheduled on the same CPU,
> +         that task will be refcounted in the same bucket of the first task and
> +         it will boost the bucket clamp effective value to 30%.
> +         The clamp effective value of a bucket is reset to its nominal value
> +         (20% in the example above) when there are anymore tasks refcounted in
> +         that bucket.
> +
> +         An additional boost/capping margin can be added to some tasks. In the
> +         example above the 25% task will be boosted to 30% until it exits the
> +         CPU. If that should be considered not acceptable on certain systems,
> +         it's always possible to reduce the margin by increasing the number of
> +         clamp buckets to trade off used memory for run-time tracking
> +         precision.
> +
> +         If in doubt, use the default value.
> +
> +endmenu
> +
>  #
>  # For architectures that want to enable the support for NUMA-affine scheduler
>  # balancing logic:
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index ec1b67a195cc..8ecf5470058c 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -719,6 +719,167 @@ static void set_load_weight(struct task_struct *p, bool update_load)
>         }
>  }
>
> +#ifdef CONFIG_UCLAMP_TASK
> +
> +/* Integer ceil-rounded range for each bucket */
> +#define UCLAMP_BUCKET_DELTA ((SCHED_CAPACITY_SCALE / UCLAMP_BUCKETS) + 1)
> +
> +static inline unsigned int uclamp_bucket_id(unsigned int clamp_value)
> +{
> +       return clamp_value / UCLAMP_BUCKET_DELTA;
> +}
> +
> +static inline unsigned int uclamp_bucket_value(unsigned int clamp_value)
> +{
> +       return UCLAMP_BUCKET_DELTA * uclamp_bucket_id(clamp_value);
> +}
> +
> +static inline unsigned int uclamp_none(int clamp_id)
> +{
> +       if (clamp_id == UCLAMP_MIN)
> +               return 0;
> +       return SCHED_CAPACITY_SCALE;
> +}
> +
> +static inline void uclamp_rq_update(struct rq *rq, unsigned int clamp_id)
> +{
> +       struct uclamp_bucket *bucket = rq->uclamp[clamp_id].bucket;
> +       unsigned int max_value = uclamp_none(clamp_id);
> +       unsigned int bucket_id;
> +
> +       /*
> +        * Both min and max clamps are MAX aggregated, thus the topmost
> +        * bucket with some tasks defines the rq's clamp value.
> +        */
> +       bucket_id = UCLAMP_BUCKETS;
> +       do {
> +               --bucket_id;
> +               if (!rq->uclamp[clamp_id].bucket[bucket_id].tasks)
> +                       continue;
> +               max_value = bucket[bucket_id].value;
> +               break;
> +       } while (bucket_id);
> +
> +       WRITE_ONCE(rq->uclamp[clamp_id].value, max_value);
> +}
> +
> +/*
> + * When a task is enqueued on a rq, the clamp bucket currently defined by the
> + * task's uclamp::bucket_id is reference counted on that rq. This also
> + * immediately updates the rq's clamp value if required.
> + *
> + * Since tasks know their specific value requested from user-space, we track
> + * within each bucket the maximum value for tasks refcounted in that bucket.
> + * This provide a further aggregation (local clamping) which allows to track
> + * within each bucket the exact "requested" clamp value whenever all tasks
> + * RUNNABLE in that bucket require the same clamp.
> + */
> +static inline void uclamp_rq_inc_id(struct task_struct *p, struct rq *rq,
> +                                   unsigned int clamp_id)
> +{
> +       unsigned int bucket_id = p->uclamp[clamp_id].bucket_id;
> +       unsigned int rq_clamp, bkt_clamp, tsk_clamp;
> +
> +       rq->uclamp[clamp_id].bucket[bucket_id].tasks++;
> +
> +       /*
> +        * Local clamping: rq's buckets always track the max "requested"
> +        * clamp value from all RUNNABLE tasks in that bucket.
> +        */
> +       tsk_clamp = p->uclamp[clamp_id].value;
> +       bkt_clamp = rq->uclamp[clamp_id].bucket[bucket_id].value;
> +       rq->uclamp[clamp_id].bucket[bucket_id].value = max(bkt_clamp, tsk_clamp);
> +
> +       rq_clamp = READ_ONCE(rq->uclamp[clamp_id].value);
> +       WRITE_ONCE(rq->uclamp[clamp_id].value, max(rq_clamp, tsk_clamp));
> +}
> +
> +/*
> + * When a task is dequeued from a rq, the clamp bucket reference counted by
> + * the task is released. If this is the last task reference counting the rq's
> + * max active clamp value, then the rq's clamp value is updated.
> + * Both the tasks reference counter and the rq's cached clamp values are
> + * expected to be always valid, if we detect they are not we skip the updates,
> + * enforce a consistent state and warn.
> + */
> +static inline void uclamp_rq_dec_id(struct task_struct *p, struct rq *rq,
> +                                   unsigned int clamp_id)
> +{
> +       unsigned int bucket_id = p->uclamp[clamp_id].bucket_id;
> +       unsigned int rq_clamp, bkt_clamp;
> +
> +       SCHED_WARN_ON(!rq->uclamp[clamp_id].bucket[bucket_id].tasks);
> +       if (likely(rq->uclamp[clamp_id].bucket[bucket_id].tasks))
> +               rq->uclamp[clamp_id].bucket[bucket_id].tasks--;
> +
> +       /*
> +        * Keep "local clamping" simple and accept to (possibly) overboost
> +        * still RUNNABLE tasks in the same bucket.
> +        */
> +       if (likely(rq->uclamp[clamp_id].bucket[bucket_id].tasks))
> +               return;
> +       bkt_clamp = rq->uclamp[clamp_id].bucket[bucket_id].value;
> +
> +       /* The rq's clamp value is expected to always track the max */
> +       rq_clamp = READ_ONCE(rq->uclamp[clamp_id].value);
> +       SCHED_WARN_ON(bkt_clamp > rq_clamp);
> +       if (bkt_clamp >= rq_clamp) {
> +               /*
> +                * Reset rq's clamp bucket value to its nominal value whenever
> +                * there are anymore RUNNABLE tasks refcounting it.
> +                */
> +               rq->uclamp[clamp_id].bucket[bucket_id].value =
> +                       uclamp_bucket_value(rq_clamp);
> +               uclamp_rq_update(rq, clamp_id);
> +       }
> +}
> +
> +static inline void uclamp_rq_inc(struct rq *rq, struct task_struct *p)
> +{
> +       unsigned int clamp_id;
> +
> +       if (unlikely(!p->sched_class->uclamp_enabled))
> +               return;
> +
> +       for (clamp_id = 0; clamp_id < UCLAMP_CNT; ++clamp_id)
> +               uclamp_rq_inc_id(p, rq, clamp_id);
> +}
> +
> +static inline void uclamp_rq_dec(struct rq *rq, struct task_struct *p)
> +{
> +       unsigned int clamp_id;
> +
> +       if (unlikely(!p->sched_class->uclamp_enabled))
> +               return;
> +
> +       for (clamp_id = 0; clamp_id < UCLAMP_CNT; ++clamp_id)
> +               uclamp_rq_dec_id(p, rq, clamp_id);
> +}
> +
> +static void __init init_uclamp(void)
> +{
> +       unsigned int clamp_id;
> +       int cpu;
> +
> +       for_each_possible_cpu(cpu)
> +               memset(&cpu_rq(cpu)->uclamp, 0, sizeof(struct uclamp_rq));
> +
> +       for (clamp_id = 0; clamp_id < UCLAMP_CNT; ++clamp_id) {
> +               unsigned int clamp_value = uclamp_none(clamp_id);
> +               unsigned int bucket_id = uclamp_bucket_id(clamp_value);
> +               struct uclamp_se *uc_se = &init_task.uclamp[clamp_id];
> +
> +               uc_se->bucket_id = bucket_id;
> +               uc_se->value = clamp_value;
> +       }
> +}
> +
> +#else /* CONFIG_UCLAMP_TASK */
> +static inline void uclamp_rq_inc(struct rq *rq, struct task_struct *p) { }
> +static inline void uclamp_rq_dec(struct rq *rq, struct task_struct *p) { }
> +static inline void init_uclamp(void) { }
> +#endif /* CONFIG_UCLAMP_TASK */
> +
>  static inline void enqueue_task(struct rq *rq, struct task_struct *p, int flags)
>  {
>         if (!(flags & ENQUEUE_NOCLOCK))
> @@ -729,6 +890,7 @@ static inline void enqueue_task(struct rq *rq, struct task_struct *p, int flags)
>                 psi_enqueue(p, flags & ENQUEUE_WAKEUP);
>         }
>
> +       uclamp_rq_inc(rq, p);
>         p->sched_class->enqueue_task(rq, p, flags);
>  }
>
> @@ -742,6 +904,7 @@ static inline void dequeue_task(struct rq *rq, struct task_struct *p, int flags)
>                 psi_dequeue(p, flags & DEQUEUE_SLEEP);
>         }
>
> +       uclamp_rq_dec(rq, p);
>         p->sched_class->dequeue_task(rq, p, flags);
>  }
>
> @@ -6075,6 +6238,8 @@ void __init sched_init(void)
>
>         psi_init();
>
> +       init_uclamp();
> +
>         scheduler_running = 1;
>  }
>
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index c688ef5012e5..ea9e28723946 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -797,6 +797,48 @@ extern void rto_push_irq_work_func(struct irq_work *work);
>  #endif
>  #endif /* CONFIG_SMP */
>
> +#ifdef CONFIG_UCLAMP_TASK
> +/*
> + * struct uclamp_bucket - Utilization clamp bucket
> + * @value: utilization clamp value for tasks on this clamp bucket
> + * @tasks: number of RUNNABLE tasks on this clamp bucket
> + *
> + * Keep track of how many tasks are RUNNABLE for a given utilization
> + * clamp value.
> + */
> +struct uclamp_bucket {
> +       unsigned long value : bits_per(SCHED_CAPACITY_SCALE);
> +       unsigned long tasks : BITS_PER_LONG - bits_per(SCHED_CAPACITY_SCALE);
> +};
> +
> +/*
> + * struct uclamp_rq - rq's utilization clamp
> + * @value: currently active clamp values for a rq
> + * @bucket: utilization clamp buckets affecting a rq
> + *
> + * Keep track of RUNNABLE tasks on a rq to aggregate their clamp values.
> + * A clamp value is affecting a rq when there is at least one task RUNNABLE
> + * (or actually running) with that value.
> + *
> + * We have up to UCLAMP_CNT possible different clamp values, which are
> + * currently only two: minmum utilization and maximum utilization.
> + *
> + * All utilization clamping values are MAX aggregated, since:
> + * - for util_min: we want to run the CPU at least at the max of the minimum
> + *   utilization required by its currently RUNNABLE tasks.
> + * - for util_max: we want to allow the CPU to run up to the max of the
> + *   maximum utilization allowed by its currently RUNNABLE tasks.
> + *
> + * Since on each system we expect only a limited number of different
> + * utilization clamp values (UCLAMP_BUCKETS), we use a simple array to track
> + * the metrics required to compute all the per-rq utilization clamp values.
> + */
> +struct uclamp_rq {
> +       unsigned int value;
> +       struct uclamp_bucket bucket[UCLAMP_BUCKETS];
> +};
> +#endif /* CONFIG_UCLAMP_TASK */
> +
>  /*
>   * This is the main, per-CPU runqueue data structure.
>   *
> @@ -835,6 +877,11 @@ struct rq {
>         unsigned long           nr_load_updates;
>         u64                     nr_switches;
>
> +#ifdef CONFIG_UCLAMP_TASK
> +       /* Utilization clamp values based on CPU's RUNNABLE tasks */
> +       struct uclamp_rq        uclamp[UCLAMP_CNT] ____cacheline_aligned;
> +#endif
> +
>         struct cfs_rq           cfs;
>         struct rt_rq            rt;
>         struct dl_rq            dl;
> @@ -1649,10 +1696,12 @@ extern const u32                sched_prio_to_wmult[40];
>  struct sched_class {
>         const struct sched_class *next;
>
> +#ifdef CONFIG_UCLAMP_TASK
> +       int uclamp_enabled;
> +#endif
> +
>         void (*enqueue_task) (struct rq *rq, struct task_struct *p, int flags);
>         void (*dequeue_task) (struct rq *rq, struct task_struct *p, int flags);
> -       void (*yield_task)   (struct rq *rq);
> -       bool (*yield_to_task)(struct rq *rq, struct task_struct *p, bool preempt);
>
>         void (*check_preempt_curr)(struct rq *rq, struct task_struct *p, int flags);
>
> @@ -1685,7 +1734,6 @@ struct sched_class {
>         void (*set_curr_task)(struct rq *rq);
>         void (*task_tick)(struct rq *rq, struct task_struct *p, int queued);
>         void (*task_fork)(struct task_struct *p);
> -       void (*task_dead)(struct task_struct *p);
>
>         /*
>          * The switched_from() call is allowed to drop rq->lock, therefore we
> @@ -1702,12 +1750,17 @@ struct sched_class {
>
>         void (*update_curr)(struct rq *rq);
>
> +       void (*yield_task)   (struct rq *rq);
> +       bool (*yield_to_task)(struct rq *rq, struct task_struct *p, bool preempt);
> +
>  #define TASK_SET_GROUP         0
>  #define TASK_MOVE_GROUP                1
>
>  #ifdef CONFIG_FAIR_GROUP_SCHED
>         void (*task_change_group)(struct task_struct *p, int type);
>  #endif
> +
> +       void (*task_dead)(struct task_struct *p);
>  };
>
>  static inline void put_prev_task(struct rq *rq, struct task_struct *prev)
> --
> 2.20.1
>
