From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 12/16] sched/core: uclamp: Extend CPU's cgroup
 controller
Date: Wed, 5 Jun 2019 07:03:24 -0700
Message-ID: <20190605140324.GL374014@devbig004.ftw2.facebook.com>
References: <20190515094459.10317-1-patrick.bellasi@arm.com>
 <20190515094459.10317-13-patrick.bellasi@arm.com>
 <20190531153545.GE374014@devbig004.ftw2.facebook.com>
 <20190603122725.GB19426@darkstar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190603122725.GB19426@darkstar>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

Hello,

On Mon, Jun 03, 2019 at 01:27:25PM +0100, Patrick Bellasi wrote:
> All the above, to me it means that:
>  - cgroups are always capped by system clamps
>  - cgroups can further restrict system clamps
> 
> Does that match with your view?

Yeah, as long as what's defined at system level clamps everything in
the system whether they're in cgroups or not, it's all good.

> > * Limits (high / max) default to max.  Protections (low / min) 0.  A
> >   new cgroup by default doesn't constrain itself further and doesn't
> >   have any protection.
> 
> Example 2
> ---------
> 
> Let say we have:
> 
>   /tg1:
>         util_min=200 (as a protection)
>         util_max=800 (as a limit)
> 
> the moment we create a subgroup /tg1/tg11, in v9 it is initialized
> with the same limits _and protections_ of its father:
> 
>   /tg1/tg11:
>         util_min=200 (protection inherited from /tg1)
>         util_max=800 (limit inherited from /tg1)
> 
> Do you mean that we should have instead:
> 
>   /tg1/tg11:
>         util_min=0   (no protection by default at creation time)
>         util_max=800 (limit inherited from /tg1)
> 
> 
> i.e. we need to reset the protection of a newly created subgroup?

The default value for limits should be max, protections 0.  Don't
inherit config values from the parent.  That gets confusing super fast
because when the parent config is set and each child is created plays
into the overall configuration.  Hierarchical confinements should
always be enforced and a new cgroup should always start afresh in
terms of its own configuration.

> > * A limit defines the upper ceiling for the subtree.  If an ancestor
> >   has a limit of X, none of its descendants can have more than X.
> 
> That's correct, however we distinguish between "requested" and
> "effective" values.

Sure, all property propagating controllers should.

> > Note that there's no way for an ancestor to enforce protection its
> > descendants.  It can only allow them to claim some.  This is
> > intentional as the other end of the spectrum is either descendants
> > losing the ability to further distribute protections as they see fit.
> 
> Ok, that means I need to update in v10 the initialization of subgroups
> min clamps to be none by default as discussed in the above Example 2,
> right?

Yeah and max to max.

Thanks.

-- 
tejun
