From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v6 08/16] sched/cpufreq: uclamp: Add utilization clamping
 for FAIR tasks
Date: Wed, 23 Jan 2019 14:24:55 +0000
Message-ID: <20190123142455.454u4w253xaxzar3@e110439-lin>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
 <20190115101513.2822-9-patrick.bellasi@arm.com>
 <20190122171314.GS27931@hirez.programming.kicks-ass.net>
 <20190122181831.a4w65qcivx4hua6d@e110439-lin>
 <20190123095219.GV27931@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190123095219.GV27931@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 23-Jan 10:52, Peter Zijlstra wrote:
> On Tue, Jan 22, 2019 at 06:18:31PM +0000, Patrick Bellasi wrote:
> > On 22-Jan 18:13, Peter Zijlstra wrote:
> > > On Tue, Jan 15, 2019 at 10:15:05AM +0000, Patrick Bellasi wrote:

[...]

> > If a task is not clamped we execute it at its required utilization or
> > even max frequency in case of wakeup from IO.
> > 
> > When a task is util_max clamped instead, we are saying that we don't
> > care to run it above the specified clamp value and, if possible, we
> > should run it below that capacity level.
> > 
> > If that's the case, why this clamping hints should not be enforced on
> > IO wakeups too?
> > 
> > At the end it's still a user-space decision, we basically allow
> > userspace to defined what's the max IO boost they like to get.
> 
> Because it is the wrong knob for it.
> 
> Ideally we'd extend the IO-wait state to include the device-busy state
> at the time of sleep. At the very least double state io_schedule() state
> space from 1 to 2 bits, where we not only indicate: yes this is an
> IO-sleep, but also can indicate device saturation. When the device is
> saturated, we don't need to boost further.
> 
> (this binary state will ofcourse cause oscilations where we drop the
> freq, drop device saturation, then ramp the freq, regain device
> saturation etc..)
> 
> However, doing this is going to require fairly massive surgery on our
> whole IO stack.
> 
> Also; how big of a problem is 'supriouos' boosting really? Joel tried to
> introduce a boost_max tunable, but the grandual boosting thing was good
> enough at the time.

Ok then, I'll drop the clamp on IOBoost... you right and moreover we
can always investigate for a better solution in the future with a
real use-case on hand.

Cheers.

-- 
#include <best/regards.h>

Patrick Bellasi
