From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v8 06/16] sched/core: uclamp: Extend sched_setattr() to
 support utilization clamping
Date: Wed, 8 May 2019 21:41:07 +0200
Message-ID: <20190508194107.GE32547@worktop.programming.kicks-ass.net>
References: <20190402104153.25404-1-patrick.bellasi@arm.com>
 <20190402104153.25404-7-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190402104153.25404-7-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 02, 2019 at 11:41:42AM +0100, Patrick Bellasi wrote:
> @@ -1056,6 +1100,13 @@ static void __init init_uclamp(void)
>  #else /* CONFIG_UCLAMP_TASK */
>  static inline void uclamp_rq_inc(struct rq *rq, struct task_struct *p) { }
>  static inline void uclamp_rq_dec(struct rq *rq, struct task_struct *p) { }
> +static inline int uclamp_validate(struct task_struct *p,
> +				  const struct sched_attr *attr)
> +{
> +	return -ENODEV;

Does that maybe want to be -EOPNOTSUPP ?

> +}
