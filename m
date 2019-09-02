From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v14 5/6] sched/core: uclamp: Update CPU's refcount on TG's clamp changes
Date: Mon, 02 Sep 2019 07:44:40 +0100
Message-ID: <87woernqnb.fsf@arm.com>
References: <20190822132811.31294-1-patrick.bellasi@arm.com> <20190822132811.31294-6-patrick.bellasi@arm.com> <20190830094834.GB2369@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20190830094834.GB2369@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Michal Koutny <mkoutny@suse.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>, Alessio Balsini <balsini@android.com>
List-Id: linux-api@vger.kernel.org


On Fri, Aug 30, 2019 at 09:48:34 +0000, Peter Zijlstra wrote...

> On Thu, Aug 22, 2019 at 02:28:10PM +0100, Patrick Bellasi wrote:
>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 04fc161e4dbe..fc2dc86a2abe 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -1043,6 +1043,57 @@ static inline void uclamp_rq_dec(struct rq *rq, struct task_struct *p)
>>  		uclamp_rq_dec_id(rq, p, clamp_id);
>>  }
>>  
>> +static inline void
>> +uclamp_update_active(struct task_struct *p, unsigned int clamp_id)
>> +{
>> +	struct rq_flags rf;
>> +	struct rq *rq;
>> +
>> +	/*
>> +	 * Lock the task and the rq where the task is (or was) queued.
>> +	 *
>> +	 * We might lock the (previous) rq of a !RUNNABLE task, but that's the
>> +	 * price to pay to safely serialize util_{min,max} updates with
>> +	 * enqueues, dequeues and migration operations.
>> +	 * This is the same locking schema used by __set_cpus_allowed_ptr().
>> +	 */
>> +	rq = task_rq_lock(p, &rf);
>
> Since modifying cgroup parameters is priv only, this should be OK I
> suppose. Priv can already DoS the system anyway.

Are you referring to the possibility to DoS the scheduler by keep
writing cgroup attributes?

Because, in that case I think cgroup attributes could be written also by
non priv users. It all depends on how they are mounted and permissions
are set. Isn't it?

Anyway, I'm not sure we can fix that here... and in principle we could
have that DoS by setting CPUs affinities, which is user exposed.
Isn't it?

>> +	/*
>> +	 * Setting the clamp bucket is serialized by task_rq_lock().
>> +	 * If the task is not yet RUNNABLE and its task_struct is not
>> +	 * affecting a valid clamp bucket, the next time it's enqueued,
>> +	 * it will already see the updated clamp bucket value.
>> +	 */
>> +	if (!p->uclamp[clamp_id].active)
>> +		goto done;
>> +
>> +	uclamp_rq_dec_id(rq, p, clamp_id);
>> +	uclamp_rq_inc_id(rq, p, clamp_id);
>> +
>> +done:
>
> I'm thinking that:
>
> 	if (p->uclamp[clamp_id].active) {
> 		uclamp_rq_dec_id(rq, p, clamp_id);
> 		uclamp_rq_inc_id(rq, p, clamp_id);
> 	}
>
> was too obvious? ;-)

Yep, right... I think there was some more code in prev versions but I
forgot to get rid of that "goto" pattern after some change.

>> +
>> +	task_rq_unlock(rq, p, &rf);
>> +}

Cheers,
Patrick
