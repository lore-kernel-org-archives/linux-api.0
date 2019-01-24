From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v6 09/16] sched/cpufreq: uclamp: Add utilization clamping
 for RT tasks
Date: Thu, 24 Jan 2019 16:33:51 +0100
Message-ID: <20190124153351.GR13777@hirez.programming.kicks-ass.net>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
 <20190115101513.2822-10-patrick.bellasi@arm.com>
 <20190123104944.GX27931@hirez.programming.kicks-ass.net>
 <20190123144011.iid3avb63r5v4r2c@e110439-lin>
 <20190123201146.GH17749@hirez.programming.kicks-ass.net>
 <20190124123009.2yulcf25ld66popd@e110439-lin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190124123009.2yulcf25ld66popd@e110439-lin>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 24, 2019 at 12:30:09PM +0000, Patrick Bellasi wrote:
> On 23-Jan 21:11, Peter Zijlstra wrote:

> > Anyway, once you get range composition defined; that should be something
> > like:
> > 
> > 	R_p \Compose_g R_g
> > 
> > Where R_p is the range of task-p, and R_g is the range of the g'th
> > cgroup of p (where you can make an identity between the root cgroup and
> > the system default).
> > 
> > Now; as per the other email; I think the straight forward composition:
> > 
> > struct range compose(struct range a, struct range b)
> > {
> > 	return (range){.min = clamp(a.min, b.min, b.max),
> > 	               .max = clamp(a.max, b.min, b.max), };
> > }
> 
> This composition is done in uclamp_effective_get() but it's
> slightly different, since we want to support a "nice policy" where
> tasks can always ask less then what they have got assigned.

Not sure I follow..

> Thus, from an abstract standpoint, if a task is in a cgroup:
> 
>      task.min <= R_g.min
>      task.max <= R_g.max
> 
> While, for tasks in the root cgroup system default applies and we
> enforece:
> 
>      task.min >= R_0.min
>      task.max <= R_0.max
> 
> ... where the "nice policy" is currently not more supported, but
> perhaps we can/should use the same for system defaults too.

That seems inconsistent at best.

OK, I'll go have another look. I never recognised that function for
doing that.
