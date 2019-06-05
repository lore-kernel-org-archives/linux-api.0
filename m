From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 12/16] sched/core: uclamp: Extend CPU's cgroup
 controller
Date: Wed, 5 Jun 2019 07:09:43 -0700
Message-ID: <20190605140943.GM374014@devbig004.ftw2.facebook.com>
References: <20190515094459.10317-1-patrick.bellasi@arm.com>
 <20190515094459.10317-13-patrick.bellasi@arm.com>
 <20190531153545.GE374014@devbig004.ftw2.facebook.com>
 <20190603122929.GC19426@darkstar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190603122929.GC19426@darkstar>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

Hello,

On Mon, Jun 03, 2019 at 01:29:29PM +0100, Patrick Bellasi wrote:
> On 31-May 08:35, Tejun Heo wrote:
> > Hello, Patrick.
> > 
> > On Wed, May 15, 2019 at 10:44:55AM +0100, Patrick Bellasi wrote:
> 
> [...]
> 
> > For proportions (as opposed to weights), we use percentage rational
> > numbers - e.g. 38.44 for 38.44%.  I have parser and doc update commits
> > pending.  I'll put them on cgroup/for-5.3.
> 
> That's a point worth discussing with Peter, we already changed one
> time from percentages to 1024 scale.

cgroup tries to uss uniform units for its interface files as much as
possible even when that deviates from non-cgroup interface.  We can
bikeshed the pros and cons for that design choice for sure but I don't
think it makes sense to deviate from that at this point unless there
are really strong reasons to do so.

> Utilization clamps are expressed as percentages by definition,
> they are just expressed in a convenient 1024 scale which should not be
> alien to people using those knobs.
> 
> If we wanna use a "more specific" name like uclamp.{min,max} then we
> should probably also accept to use a "more specific" metric, don't we?

Heh, this actually made me chuckle.  It's an interesting bargaining
take but I don't think that same word being in two different places
makes them tradable entities.  We can go into the weeds with the
semantics but how about us using an alternative adjective "misleading"
for the cpu.util.min/max names to short-circuit that?

Thanks.

-- 
tejun
