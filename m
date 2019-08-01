From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v12 3/6] sched/core: uclamp: Propagate system defaults to
 root group
Date: Thu, 1 Aug 2019 12:10:54 +0100
Message-ID: <20190801111054.6izrad6eysfnw5ju@e110439-lin>
References: <20190718181748.28446-1-patrick.bellasi@arm.com>
 <20190718181748.28446-4-patrick.bellasi@arm.com>
 <20190725114126.GA4130@blackbody.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190725114126.GA4130@blackbody.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, Alessio Balsini <balsini@android.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Quentin Perret <quentin.perret@arm.com>, Joel Fernandes <joelaf@google.com>, Paul Turner <pjt@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>, Todd Kjos <tkjos@google.com>, Peter Zijlstra <peterz@infradead.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Tejun Heo <tj@kernel.org>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Juri Lelli <juri.lelli@redhat.com>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-api@vger.kernel.org

On 25-Jul 13:41, Michal Koutný wrote:
> On Thu, Jul 18, 2019 at 07:17:45PM +0100, Patrick Bellasi <patrick.bellasi@arm.com> wrote:
> > The clamp values are not tunable at the level of the root task group.
> > That's for two main reasons:
> > 
> >  - the root group represents "system resources" which are always
> >    entirely available from the cgroup standpoint.
> > 
> >  - when tuning/restricting "system resources" makes sense, tuning must
> >    be done using a system wide API which should also be available when
> >    control groups are not.
> > 
> > When a system wide restriction is available, cgroups should be aware of
> > its value in order to know exactly how much "system resources" are
> > available for the subgroups.
> IIUC, the global default would apply in uclamp_eff_get(), so this
> propagation isn't strictly necessary in order to apply to tasks (that's
> how it works under !CONFIG_UCLAMP_TASK_GROUP).

That's right.

> The reason is that effective value (which isn't exposed currently) in a
> group takes into account this global restriction, right?

Yep, well admittedly in this area things changed in a slightly confusing way.

Up to v10:
 - effective values was exposed to userspace
 - system defaults was enforced only at enqueue time

Now instead:
 - effective values are not exposed anymore (because of Tejun request)
 - system defaults are applied to the root group and propagated down
   the hierarchy to all effective values

Both solutions are functionally correct but, in the first case, the
cgroup's effective values was not really reflecting what a task will
get while, in the current solution, we force update all effective
values while not exposing them anymore.

However, I think this solution is better in keeping information more
consistent and should create less confusion if in the future we decide
to expose effective values to user-space.

Thought?

> > @@ -1043,12 +1063,17 @@ int sysctl_sched_uclamp_handler(struct ctl_table *table, int write,
> > [...]
> > +	if (update_root_tg)
> > +		uclamp_update_root_tg();
> > +
> >  	/*
> >  	 * Updating all the RUNNABLE task is expensive, keep it simple and do
> >  	 * just a lazy update at each next enqueue time.
> Since uclamp_update_root_tg() traverses down to
> uclamp_update_active_tasks() is this comment half true now?

Right, this comment is now wrong. We update all RUNNABLE tasks on
system default changes. However, despite the above command it's
difficult to say how much expensive that operation can be.

It really depends on how many RUNNABLE tasks we have, the number of
CPUs and also how many tasks are not already clamped by a more
restrictive "effective" value. Thus, for the time being, we can
consider speculation the above statement and add in a simple change if
in the future that should be reported as a real issue to justify a
lazy update.

The upside is that with the current implementation we have a more
strict control on task. Even long running tasks can be clamped on
sysadmin demand without waiting for them to sleep.

Does that makes sense?

If it does, I'll drop the above comment in v13.

Cheers Patrick

-- 
#include <best/regards.h>

Patrick Bellasi
