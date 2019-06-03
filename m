From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v9 12/16] sched/core: uclamp: Extend CPU's cgroup
 controller
Date: Mon, 3 Jun 2019 13:24:22 +0100
Message-ID: <20190603122422.GA19426@darkstar>
References: <20190515094459.10317-1-patrick.bellasi@arm.com>
 <20190515094459.10317-13-patrick.bellasi@arm.com>
 <20190531153545.GE374014@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190531153545.GE374014@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 31-May 08:35, Tejun Heo wrote:
> Hello, Patrick.

Hi Tejun!

> On Wed, May 15, 2019 at 10:44:55AM +0100, Patrick Bellasi wrote:
> > Extend the CPU controller with a couple of new attributes util.{min,max}
> > which allows to enforce utilization boosting and capping for all the
> > tasks in a group. Specifically:
> > 
> > - util.min: defines the minimum utilization which should be considered
> > 	    i.e. the RUNNABLE tasks of this group will run at least at a
> > 		 minimum frequency which corresponds to the util.min
> > 		 utilization
> > 
> > - util.max: defines the maximum utilization which should be considered
> > 	    i.e. the RUNNABLE tasks of this group will run up to a
> > 		 maximum frequency which corresponds to the util.max
> > 		 utilization
> 
> Let's please use a prefix which is more specific.  It's clamping the
> utilization estimates of the member tasks which in turn affect
> scheduling / frequency decisions but cpu.util.max reads like it's
> gonna limit the cpu utilization directly.  Maybe just use uclamp?

Being too specific does not risk to expose implementation details?

If that's not a problem and Peter likes:

   cpu.uclamp.{min,max}

that's ok with me.

-- 
#include <best/regards.h>

Patrick Bellasi
