From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v7 03/15] sched/core: uclamp: Add system default clamps
Date: Wed, 13 Mar 2019 20:58:50 +0100
Message-ID: <20190313195850.GT2482@worktop.programming.kicks-ass.net>
References: <20190208100554.32196-1-patrick.bellasi@arm.com>
 <20190208100554.32196-4-patrick.bellasi@arm.com>
 <20190313143240.GH5922@hirez.programming.kicks-ass.net>
 <20190313170940.ngiafkmiijryhl2k@e110439-lin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190313170940.ngiafkmiijryhl2k@e110439-lin>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 13, 2019 at 05:09:40PM +0000, Patrick Bellasi wrote:
> On 13-Mar 15:32, Peter Zijlstra wrote:

> > I still think that this effective thing is backwards.

> With respect to the previous v6, I've now moved this concept to the
> patch where we actually use it for the first time.

> The "effective" values allows to efficiently enforce the most
> restrictive clamp value for a task at enqueue time by:
>  - not loosing track of the original request
>  - don't caring about updating non runnable tasks

My point is that you already had an effective value; namely p->uclamp[],
since patch 1.

This patch then changes that into something else, instead of adding
p->uclamp_orig[], and concequently has to update all sites that
previously used p->uclamp[], which is a lot of pointless churn.
