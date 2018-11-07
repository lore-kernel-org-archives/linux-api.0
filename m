From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v5 02/15] sched/core: make sched_setattr able to tune the
 current policy
Date: Wed, 7 Nov 2018 13:50:39 +0000
Message-ID: <20181107135039.GD14309@e110439-lin>
References: <20181029183311.29175-1-patrick.bellasi@arm.com>
 <20181029183311.29175-3-patrick.bellasi@arm.com>
 <20181107121126.GN9781@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181107121126.GN9781@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 07-Nov 13:11, Peter Zijlstra wrote:
> On Mon, Oct 29, 2018 at 06:32:56PM +0000, Patrick Bellasi wrote:
> 
> > @@ -50,11 +52,13 @@
> >  #define SCHED_FLAG_RESET_ON_FORK	0x01
> >  #define SCHED_FLAG_RECLAIM		0x02
> >  #define SCHED_FLAG_DL_OVERRUN		0x04
> > -#define SCHED_FLAG_UTIL_CLAMP		0x08
> > +#define SCHED_FLAG_TUNE_POLICY		0x08
> > +#define SCHED_FLAG_UTIL_CLAMP		0x10
> 
> That seems to suggest you want to do this patch first, but you didn't..

I've kept it here just to better highlight this change, suggested by
Juri, since we was not entirely sure you are fine with it...

If you think it's ok adding a SCHED_FLAG_TUNE_POLICY behavior to the
sched_setattr syscall, I can certainly squash into the previous patch,
which gives more context on why we need it.

Otherwise, if we want to keep these bits better isolated for possible
future bisects, I can also move it at the beginning of the series.

What do you like best ?

Since we are at that, are we supposed to document some{where,how}
these API changes ?

-- 
#include <best/regards.h>

Patrick Bellasi
