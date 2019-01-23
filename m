From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v6 05/16] sched/core: uclamp: Update CPU's refcount on
 clamp changes
Date: Wed, 23 Jan 2019 19:59:40 +0100
Message-ID: <20190123185940.GF17749@hirez.programming.kicks-ass.net>
References: <20190121153308.GL27931@hirez.programming.kicks-ass.net>
 <20190121154412.fak2t2iquj3aixtu@e110439-lin>
 <20190122093704.GM27931@hirez.programming.kicks-ass.net>
 <20190122104305.6vjx37muqsxm536t@e110439-lin>
 <20190122132817.GG13777@hirez.programming.kicks-ass.net>
 <20190122140115.twtx646vewm757ca@e110439-lin>
 <20190122145742.GQ27931@hirez.programming.kicks-ass.net>
 <20190122153315.dhjl67sgpu74hmqv@e110439-lin>
 <20190123091634.GT27931@hirez.programming.kicks-ass.net>
 <20190123141426.5samtr4hl6okdypu@e110439-lin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190123141426.5samtr4hl6okdypu@e110439-lin>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 23, 2019 at 02:14:26PM +0000, Patrick Bellasi wrote:

> > > Consider also that the uclamp_task_update_active() added by this patch
> > > not only has lower overhead but it will be use also by cgroups where
> > > we want to force update all the tasks on a cgroup's clamp change.
> > 
> > I haven't gotten that far; but I would prefer not to have two different
> > 'change' paths in __sched_setscheduler().
> 
> Yes, I agree that two paths in __sched_setscheduler() could be
> confusing. Still we have to consider that here we are adding
> "not class specific" attributes.

But that change thing is not class specific; the whole:


	rq = task_rq_lock(p, &rf);
	queued = task_on_rq_queued(p);
	running = task_current(rq, p);
	if (queued)
		dequeue_task(rq, p, queue_flags);
	if (running)
		put_prev_task(rq, p);


	/* @p is in it's invariant state; frob it's state */


	if (queued)
		enqueue_task(rq, p, queue_flags);
	if (running)
		set_curr_task(rq, p);
	task_rq_unlock(rq, p, &rf);


pattern is all over the place; it is just because C sucks that that
isn't more explicitly shared (do_set_cpus_allowed(), rt_mutex_setprio(),
set_user_nice(), __sched_setscheduler(), sched_setnuma(),
sched_move_task()).

This is _the_ pattern for changing state and is not class specific at
all.
