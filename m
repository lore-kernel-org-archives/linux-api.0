From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v8 04/16] sched/core: uclamp: Add system default clamps
Date: Thu, 9 May 2019 09:43:11 +0100
Message-ID: <20190509084311.clpvno6am7bxo5wz@e110439-lin>
References: <20190402104153.25404-1-patrick.bellasi@arm.com>
 <20190402104153.25404-5-patrick.bellasi@arm.com>
 <20190508184202.GA32547@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190508184202.GA32547@worktop.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 08-May 20:42, Peter Zijlstra wrote:
> On Tue, Apr 02, 2019 at 11:41:40AM +0100, Patrick Bellasi wrote:
> > Add a privileged interface to define a system default configuration via:
> > 
> >   /proc/sys/kernel/sched_uclamp_util_{min,max}
> 
> Isn't the 'u' in "uclamp" already for util?

Yes, right... I've just wanted to keep the same "uclamp" prefix used
by all related kernel symbols. But, since that's user-space API we can
certainly drop it and go for either:

      /proc/sys/kernel/sched_clamp_util_{min,max}
      /proc/sys/kernel/sched_util_clamp_{min,max}

Preference?

-- 
#include <best/regards.h>

Patrick Bellasi
