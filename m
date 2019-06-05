From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 12/16] sched/core: uclamp: Extend CPU's cgroup
 controller
Date: Wed, 5 Jun 2019 08:27:54 -0700
Message-ID: <20190605152754.GO374014@devbig004.ftw2.facebook.com>
References: <20190515094459.10317-1-patrick.bellasi@arm.com>
 <20190515094459.10317-13-patrick.bellasi@arm.com>
 <20190531153545.GE374014@devbig004.ftw2.facebook.com>
 <20190603122929.GC19426@darkstar>
 <20190605140943.GM374014@devbig004.ftw2.facebook.com>
 <20190605150630.vh5pyfpd6y3mfcaa@e110439-lin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190605150630.vh5pyfpd6y3mfcaa@e110439-lin>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

Hello, Patrick.

On Wed, Jun 05, 2019 at 04:06:30PM +0100, Patrick Bellasi wrote:
> The only additional point I can think about as a (slightly) stronger
> reason is that I guess we would like to have the same API for cgroups
> as well as for the task specific and the system wide settings.
> 
> The task specific values comes in via the sched_setattr() syscall:
> 
>    [PATCH v9 06/16] sched/core: uclamp: Extend sched_setattr() to support utilization clamping
>    https://lore.kernel.org/lkml/20190515094459.10317-7-patrick.bellasi@arm.com/
> 
> where we need to encode each clamp into a __u32 value.
> 
> System wide settings are expose similarly to these:
> 
>    grep '' /proc/sys/kernel/sched_*
> 
> where we have always integer numbers.
> 
> AFAIU your proposal will require to use a "scaled percentage" - e.g.
> 3844 for 38.44% which however it's still not quite the same as writing
> the string "38.44".
> 
> Not sure that's a strong enough argument, is it?

It definitely is an argument but the thing is that the units we use in
kernel API are all over the place anyway.  Even for something as
simple as sizes, we use bytes, 512 byte sectors, kilobytes and pages
all over the place.  Some for good reasons (as you mentioned above)
and others for historical / random ones.

So, I'm generally not too concerned about units differing between
cgroup interface and, say, syscall interface.  That ship has sailed a
long while ago and we have to deal with it everywhere anyway (in many
cases there isn't even a good unit to pick for compatibility because
the existing interfaces are already mixing units heavily).  As long as
the translation is trivial, it isn't a big issue.  Note that some
translations are not trivial.  For example, the sched nice value
mapping to weight has a separate unit matching knob for that reason.

> > We can go into the weeds with the semantics but how about us using
> > an alternative adjective "misleading" for the cpu.util.min/max names
> > to short-circuit that?
> 
> Not quite sure to get what you mean here. Are you pointing out that
> with clamps we don't strictly enforce a bandwidth but we just set a
> bias?

It's just that "util" is already used a lot and cpu.util.max reads
like it should cap cpu utilization (wallclock based) to 80% and it's
likely that it'd read seem way to many other folks too.  A more
distinctive name signals that it isn't something that obvious.

Thanks.

-- 
tejun
