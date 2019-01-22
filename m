From: Quentin Perret <quentin.perret@arm.com>
Subject: Re: [PATCH v6 11/16] sched/fair: Add uclamp support to
 energy_compute()
Date: Tue, 22 Jan 2019 15:14:06 +0000
Message-ID: <20190122151404.5rtosic6puixado3@queper01-lin>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
 <20190115101513.2822-12-patrick.bellasi@arm.com>
 <20190122121321.r6mv23ao57uut3t7@queper01-lin>
 <20190122124546.njrpmykzbjpztd6u@e110439-lin>
 <20190122132944.sfxlnpc3xeft4rqd@queper01-lin>
 <20190122142606.gc5hnc5pzefblegw@e110439-lin>
 <20190122143909.pmlqyhcjshyomrbw@queper01-lin>
 <20190122150137.fp4g4kdng2qpy6qx@e110439-lin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190122150137.fp4g4kdng2qpy6qx@e110439-lin>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On Tuesday 22 Jan 2019 at 15:01:37 (+0000), Patrick Bellasi wrote:
> > I'm not saying it's useful, I'm saying userspace can decide to do that
> > if it thinks it is a good idea. The default should be min_cap = 1024 for
> > RT, no questions. But you _can_ change it at runtime if you want to.
> > That's my point. And doing that basically provides the same behaviour as
> > what we have right now in terms of EAS calculation (but it changes the
> > freq selection obviously) which is why I'm not fundamentally opposed to
> > your patch.
> 
> Well, I think it's tricky to say whether the current or new approach
> is better... it probably depends on the use-case.

Agreed.

> > So in short, I'm fine with the behavioural change, but please at least
> > mention it somewhere :-)
> 
> Anyway... agree, it's just that to add some documentation I need to
> get what you are pointing out ;)
> 
> Will come up with some additional text to be added to the changelog

Sounds good.

> Maybe we can add a more detailed explanation of the different
> behaviors you can get in the EAS documentation which is coming to
> mainline ?

Yeah, if you feel like it, I guess that won't hurt :-)

Thanks,
Quentin
