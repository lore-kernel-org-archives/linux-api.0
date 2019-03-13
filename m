From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v7 01/15] sched/core: uclamp: Add CPU's clamp buckets
 refcounting
Date: Wed, 13 Mar 2019 15:28:31 +0000
Message-ID: <20190313152831.aqkvdrdoffiyu5pp@e110439-lin>
References: <20190208100554.32196-1-patrick.bellasi@arm.com>
 <20190208100554.32196-2-patrick.bellasi@arm.com>
 <20190313140603.GD5922@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190313140603.GD5922@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 13-Mar 15:06, Peter Zijlstra wrote:
> On Fri, Feb 08, 2019 at 10:05:40AM +0000, Patrick Bellasi wrote:
> > +static void __init init_uclamp(void)
> > +{
> > +	unsigned int clamp_id;
> > +	int cpu;
> > +
> > +	for_each_possible_cpu(cpu)
> > +		memset(&cpu_rq(cpu)->uclamp, 0, sizeof(struct uclamp_rq));
> > +
> 
> Is that really needed? Doesn't rq come from .bss ?

Will check better... I've just assumed not since in sched_init() we
already have tons of rq's related zero initializations.

-- 
#include <best/regards.h>

Patrick Bellasi
