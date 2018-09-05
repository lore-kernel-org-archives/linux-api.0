From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH v4 01/16] sched/core: uclamp: extend sched_setattr to
 support utilization clamping
Date: Wed, 5 Sep 2018 13:01:08 +0200
Message-ID: <20180905110108.GC20267@localhost.localdomain>
References: <20180828135324.21976-1-patrick.bellasi@arm.com>
 <20180828135324.21976-2-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180828135324.21976-2-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Viresh Kumar <viresh.kumar@linaro.org>, Vincent Guittot <vincent.guittot@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>, Randy Dunlap <rdunlap@infradead.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi,

On 28/08/18 14:53, Patrick Bellasi wrote:

[...]

> Let's introduce a new API to set utilization clamping values for a
> specified task by extending sched_setattr, a syscall which already
> allows to define task specific properties for different scheduling
> classes.
> Specifically, a new pair of attributes allows to specify a minimum and
> maximum utilization which the scheduler should consider for a task.

AFAIK sched_setattr currently mandates that a policy is always specified
[1]. I was wondering if relaxing such requirement might be handy. Being
util clamp a cross-class feature it might be cumbersome to always have
to get current policy/params and use those with new umin/umax just to
change the latter.

sched_setparam already uses the in-kernel SETPARAM_POLICY thing, maybe
we could extend that to sched_setattr? Not sure exposing this to
userspace is a good idea though. :-/

Best,

- Juri

1 - https://elixir.bootlin.com/linux/v4.19-rc2/source/kernel/sched/core.c#L4564
