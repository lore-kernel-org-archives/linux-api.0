From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v7 02/15] sched/core: uclamp: Enforce last task UCLAMP_MAX
Date: Wed, 13 Mar 2019 16:16:46 +0000
Message-ID: <20190313161646.fp2gswuqgzi7z7ow@e110439-lin>
References: <20190208100554.32196-1-patrick.bellasi@arm.com>
 <20190208100554.32196-3-patrick.bellasi@arm.com>
 <20190313141253.GG5922@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190313141253.GG5922@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 13-Mar 15:12, Peter Zijlstra wrote:
> On Fri, Feb 08, 2019 at 10:05:41AM +0000, Patrick Bellasi wrote:
> > +static inline void uclamp_idle_reset(struct rq *rq, unsigned int clamp_id,
> > +				     unsigned int clamp_value)
> > +{
> > +	/* Reset max-clamp retention only on idle exit */
> > +	if (!(rq->uclamp_flags & UCLAMP_FLAG_IDLE))
> > +		return;
> > +
> > +	WRITE_ONCE(rq->uclamp[clamp_id].value, clamp_value);
> > +
> > +	/*
> > +	 * This function is called for both UCLAMP_MIN (before) and UCLAMP_MAX
> > +	 * (after). The idle flag is reset only the second time, when we know
> > +	 * that UCLAMP_MIN has been already updated.
> 
> Why do we care? That is, what is this comment trying to tell us.

Right, the code is clear enough, I'll remove this comment.

> 
> > +	 */
> > +	if (clamp_id == UCLAMP_MAX)
> > +		rq->uclamp_flags &= ~UCLAMP_FLAG_IDLE;
> > +}

-- 
#include <best/regards.h>

Patrick Bellasi
