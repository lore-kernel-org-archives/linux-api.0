From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v7 03/15] sched/core: uclamp: Add system default clamps
Date: Mon, 18 Mar 2019 12:18:04 +0000
Message-ID: <20190318121804.tr3myhtgczvovmkq@e110439-lin>
References: <20190208100554.32196-1-patrick.bellasi@arm.com>
 <20190208100554.32196-4-patrick.bellasi@arm.com>
 <20190313201821.GW2482@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190313201821.GW2482@worktop.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 13-Mar 21:18, Peter Zijlstra wrote:
> On Fri, Feb 08, 2019 at 10:05:42AM +0000, Patrick Bellasi wrote:
> > +static void uclamp_fork(struct task_struct *p)
> > +{
> > +	unsigned int clamp_id;
> > +
> > +	if (unlikely(!p->sched_class->uclamp_enabled))
> > +		return;
> > +
> > +	for (clamp_id = 0; clamp_id < UCLAMP_CNT; ++clamp_id)
> > +		p->uclamp[clamp_id].active = false;
> > +}
> 
> Because in that case .active == false, and copy_process() will have done
> thr right thing?

Don't really get what you mean here? :/


-- 
#include <best/regards.h>

Patrick Bellasi
