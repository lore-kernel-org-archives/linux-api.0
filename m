From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v7 11/15] sched/core: uclamp: Extend CPU's cgroup
 controller
Date: Tue, 19 Mar 2019 10:00:35 +0000
Message-ID: <20190319100035.mzuuynaobp7hrbtf@e110439-lin>
References: <20190208100554.32196-1-patrick.bellasi@arm.com>
 <20190208100554.32196-12-patrick.bellasi@arm.com>
 <20190214154817.GN50184@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190214154817.GN50184@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 14-Feb 07:48, Tejun Heo wrote:
> Hello,

Hi Tejun,

> On Fri, Feb 08, 2019 at 10:05:50AM +0000, Patrick Bellasi wrote:
> > a) are available only for non-root nodes, both on default and legacy
> >    hierarchies, while system wide clamps are defined by a generic
> >    interface which does not depends on cgroups
> > 
> > b) do not enforce any constraints and/or dependencies between the parent
> >    and its child nodes, thus relying:
> >    - on permission settings defined by the system management software,
> >      to define if subgroups can configure their clamp values
> >    - on the delegation model, to ensure that effective clamps are
> >      updated to consider both subgroup requests and parent group
> >      constraints
> 
> I'm not sure about this hierarchical behavior.

Yes, the above paragraph is misleading and it fails in properly
document what the code really does.

I'll update it on v8 to be more clear.

> 
> > c) have higher priority than task-specific clamps, defined via
> >    sched_setattr(), thus allowing to control and restrict task requests
> 
> and I have some other concerns about the interface, but let's discuss
> them once the !cgroup portion is settled.

Sure, looking forward to get some more feedbacks from you on that
part.

For the time being I'll keep adding the cgroups bits on top of
the core ones just to follow the principle of "share early, share
often" and to give interested people a more complete picture of our
final goal.

I'm sure Peter will let you know when it's worth for you to be
more actively involved with the review ;)

> Thanks.

Cheers,
Patrick

-- 
#include <best/regards.h>

Patrick Bellasi
