From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v6 09/16] sched/cpufreq: uclamp: Add utilization clamping
 for RT tasks
Date: Thu, 24 Jan 2019 16:05:18 +0000
Message-ID: <20190124160518.isdg3lg3vn6gyb5f@e110439-lin>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
 <20190115101513.2822-10-patrick.bellasi@arm.com>
 <20190124151559.GP13777@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190124151559.GP13777@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 24-Jan 16:15, Peter Zijlstra wrote:
> On Tue, Jan 15, 2019 at 10:15:06AM +0000, Patrick Bellasi wrote:
> > Add uclamp_default_perf, a special set of clamp values to be used
> > for tasks requiring maximum performance, i.e. by default all the non
> > clamped RT tasks.
> 
> Urgh... why though?

Because tasks without a task-specific clamp value assigned are subject
to system default... but those, by default, don't clamp at all:

   uclamp_default = [0..1024]

For RT tasks however, we want to execute then always at max OPP, if
not otherwise requested (e.g. task-specific value). Thus we need a
different set of default clamps:

   uclamp_perf_default = [1024..1024]

-- 
#include <best/regards.h>

Patrick Bellasi
