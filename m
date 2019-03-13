From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v7 02/15] sched/core: uclamp: Enforce last task UCLAMP_MAX
Date: Wed, 13 Mar 2019 16:20:51 +0000
Message-ID: <20190313162051.djiu5dwc5ahp5p5p@e110439-lin>
References: <20190208100554.32196-1-patrick.bellasi@arm.com>
 <20190208100554.32196-3-patrick.bellasi@arm.com>
 <20190313141008.GF5922@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190313141008.GF5922@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 13-Mar 15:10, Peter Zijlstra wrote:
> On Fri, Feb 08, 2019 at 10:05:41AM +0000, Patrick Bellasi wrote:
> > +uclamp_idle_value(struct rq *rq, unsigned int clamp_id, unsigned int clamp_value)
> > +{
> > +	/*
> > +	 * Avoid blocked utilization pushing up the frequency when we go
> > +	 * idle (which drops the max-clamp) by retaining the last known
> > +	 * max-clamp.
> > +	 */
> > +	if (clamp_id == UCLAMP_MAX) {
> > +		rq->uclamp_flags |= UCLAMP_FLAG_IDLE;
> > +		return clamp_value;
> > +	}
> > +
> > +	return uclamp_none(UCLAMP_MIN);
> 
> That's a very complicated way or writing: return 0, right?

In my mind it's just a simple way to hardcode values in just one place.

In the current implementation uclamp_none(UCLAMP_MIN) is 0 and the
compiler is not in trubles to inline a 0 there.

Is it really so disgusting ?

-- 
#include <best/regards.h>

Patrick Bellasi
