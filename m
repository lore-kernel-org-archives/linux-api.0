From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 12/16] sched/core: uclamp: Extend CPU's cgroup
 controller
Date: Fri, 31 May 2019 08:35:45 -0700
Message-ID: <20190531153545.GE374014@devbig004.ftw2.facebook.com>
References: <20190515094459.10317-1-patrick.bellasi@arm.com>
 <20190515094459.10317-13-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190515094459.10317-13-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

Hello, Patrick.

On Wed, May 15, 2019 at 10:44:55AM +0100, Patrick Bellasi wrote:
> Extend the CPU controller with a couple of new attributes util.{min,max}
> which allows to enforce utilization boosting and capping for all the
> tasks in a group. Specifically:
> 
> - util.min: defines the minimum utilization which should be considered
> 	    i.e. the RUNNABLE tasks of this group will run at least at a
> 		 minimum frequency which corresponds to the util.min
> 		 utilization
> 
> - util.max: defines the maximum utilization which should be considered
> 	    i.e. the RUNNABLE tasks of this group will run up to a
> 		 maximum frequency which corresponds to the util.max
> 		 utilization

Let's please use a prefix which is more specific.  It's clamping the
utilization estimates of the member tasks which in turn affect
scheduling / frequency decisions but cpu.util.max reads like it's
gonna limit the cpu utilization directly.  Maybe just use uclamp?

> These attributes:
> 
> a) are available only for non-root nodes, both on default and legacy
>    hierarchies, while system wide clamps are defined by a generic
>    interface which does not depends on cgroups. This system wide
>    interface enforces constraints on tasks in the root node.

I'd much prefer if they weren't entangled this way.  The system wide
limits should work the same regardless of cgroup's existence.  cgroup
can put further restriction on top but mere creation of cgroups with
cpu controller enabled shouldn't take them out of the system-wide
limits.

> b) enforce effective constraints at each level of the hierarchy which
>    are a restriction of the group requests considering its parent's
>    effective constraints. Root group effective constraints are defined
>    by the system wide interface.
>    This mechanism allows each (non-root) level of the hierarchy to:
>    - request whatever clamp values it would like to get
>    - effectively get only up to the maximum amount allowed by its parent

I'll come back to this later.

> c) have higher priority than task-specific clamps, defined via
>    sched_setattr(), thus allowing to control and restrict task requests

This sounds good.

> Add two new attributes to the cpu controller to collect "requested"
> clamp values. Allow that at each non-root level of the hierarchy.
> Validate local consistency by enforcing util.min < util.max.
> Keep it simple by do not caring now about "effective" values computation
> and propagation along the hierarchy.

So, the followings are what we're doing for hierarchical protection
and limit propgations.

* Limits (high / max) default to max.  Protections (low / min) 0.  A
  new cgroup by default doesn't constrain itself further and doesn't
  have any protection.

* A limit defines the upper ceiling for the subtree.  If an ancestor
  has a limit of X, none of its descendants can have more than X.

* A protection defines the upper ceiling of protections for the
  subtree.  If an andester has a protection of X, none of its
  descendants can have more protection than X.

Note that there's no way for an ancestor to enforce protection its
descendants.  It can only allow them to claim some.  This is
intentional as the other end of the spectrum is either descendants
losing the ability to further distribute protections as they see fit.

For proportions (as opposed to weights), we use percentage rational
numbers - e.g. 38.44 for 38.44%.  I have parser and doc update commits
pending.  I'll put them on cgroup/for-5.3.

Thanks.

-- 
tejun
