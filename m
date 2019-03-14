From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v7 01/15] sched/core: uclamp: Add CPU's clamp buckets
 refcounting
Date: Thu, 14 Mar 2019 15:07:53 +0000
Message-ID: <20190314150753.lzu6uftirxnhdv4y@e110439-lin>
References: <20190208100554.32196-1-patrick.bellasi@arm.com>
 <20190208100554.32196-2-patrick.bellasi@arm.com>
 <20190313134022.GB5922@hirez.programming.kicks-ass.net>
 <20190313161229.pkib2tmjass5chtb@e110439-lin>
 <20190313194838.GS2482@worktop.programming.kicks-ass.net>
 <20190314121315.juqpsqu5cwouuqpp@e110439-lin>
 <20190314133211.GJ5996@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190314133211.GJ5996@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 14-Mar 14:32, Peter Zijlstra wrote:
> On Thu, Mar 14, 2019 at 12:13:15PM +0000, Patrick Bellasi wrote:
> > > I'd be most impressed if they pull this off. Check the generated code
> > > and see I suppose :-)
> > 
> > On x86 the code generated looks exactly the same:
> > 
> >    https://godbolt.org/z/PjmA7k
> 
> Argh, they do mult by inverse to avoid the division, and can do this
> because its a constant.
> 
> And then yes, your arm version looks worse.

your "arm version" is worst then x86, or "your version" is worse?

IOW, should I keep the code as the original? Do you prefer your
version? Or... we don't really care...

> It does what I expected with -Os, but as Rutland said the other day,
> that stands for Optimize for Sadness.

Yes, I guess we cannot optimize for all flags... however, just let me
know what you prefer and I'll put that version in ;)

-- 
#include <best/regards.h>

Patrick Bellasi
