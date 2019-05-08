From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v8 04/16] sched/core: uclamp: Add system default clamps
Date: Wed, 8 May 2019 21:07:33 +0200
Message-ID: <20190508190733.GC32547@worktop.programming.kicks-ass.net>
References: <20190402104153.25404-1-patrick.bellasi@arm.com>
 <20190402104153.25404-5-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190402104153.25404-5-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 02, 2019 at 11:41:40AM +0100, Patrick Bellasi wrote:
> +static inline struct uclamp_se
> +uclamp_eff_get(struct task_struct *p, unsigned int clamp_id)
> +{
> +	struct uclamp_se uc_req = p->uclamp_req[clamp_id];
> +	struct uclamp_se uc_max = uclamp_default[clamp_id];
> +
> +	/* System default restrictions always apply */
> +	if (unlikely(uc_req.value > uc_max.value))
> +		return uc_max;
> +
> +	return uc_req;
> +}
> +
> +static inline unsigned int
> +uclamp_eff_bucket_id(struct task_struct *p, unsigned int clamp_id)
> +{
> +	struct uclamp_se uc_eff;
> +
> +	/* Task currently refcounted: use back-annotated (effective) bucket */
> +	if (p->uclamp[clamp_id].active)
> +		return p->uclamp[clamp_id].bucket_id;
> +
> +	uc_eff = uclamp_eff_get(p, clamp_id);
> +
> +	return uc_eff.bucket_id;
> +}
> +
> +unsigned int uclamp_eff_value(struct task_struct *p, unsigned int clamp_id)
> +{
> +	struct uclamp_se uc_eff;
> +
> +	/* Task currently refcounted: use back-annotated (effective) value */
> +	if (p->uclamp[clamp_id].active)
> +		return p->uclamp[clamp_id].value;
> +
> +	uc_eff = uclamp_eff_get(p, clamp_id);
> +
> +	return uc_eff.value;
> +}

This is 'wrong' because:

  uclamp_eff_value(p,id) := uclamp_eff(p,id).value

Which seems to suggest the uclamp_eff_*() functions want another name.

Also, suppose the above would be true; does GCC really generate better
code for the LHS compared to the RHS?
