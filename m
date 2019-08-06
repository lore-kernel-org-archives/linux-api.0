From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v13 0/6] Add utilization clamping support (CGroups API)
Date: Tue, 06 Aug 2019 17:40:55 +0100
Message-ID: <87k1bqfdrc.fsf@arm.com>
References: <20190802090853.4810-1-patrick.bellasi@arm.com> <20190806161206.GA20526@blackbody.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20190806161206.GA20526@blackbody.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>, Alessio Balsini <balsini@android.com>
List-Id: linux-api@vger.kernel.org


On Tue, Aug 06, 2019 at 17:12:06 +0100, Michal Koutný wrote...

> On Fri, Aug 02, 2019 at 10:08:47AM +0100, Patrick Bellasi <patrick.bellasi@arm.com> wrote:
>> Patrick Bellasi (6):
>>   sched/core: uclamp: Extend CPU's cgroup controller
>>   sched/core: uclamp: Propagate parent clamps
>>   sched/core: uclamp: Propagate system defaults to root group
>>   sched/core: uclamp: Use TG's clamps to restrict TASK's clamps
>>   sched/core: uclamp: Update CPU's refcount on TG's clamp changes
>>   sched/core: uclamp: always use enum uclamp_id for clamp_id values

Hi Michal!

> Thank you Patrick for your patience.

Thanks to you for your reviews.

> I used the time to revisit the series once again and I think the RCU
> locks can be streamlined a bit.

I'll have a look at those, thanks!

> If you find that correct, feel free to add my Reviewed-by to the
> updated series (for 1/6 and legacy, I'm just asking).

Sure, actually sorry for not having already added that tag in the
current version, it will be there in v14 ;)

> Michal

Cheers,
Patrick

--
#include <best/regards.h>

Patrick Bellasi
