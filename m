From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v6 07/16] sched/core: uclamp: Add system default clamps
Date: Wed, 23 Jan 2019 10:22:10 +0100
Message-ID: <20190123092210.GU27931@hirez.programming.kicks-ass.net>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
 <20190115101513.2822-8-patrick.bellasi@arm.com>
 <20190122135644.GP27931@hirez.programming.kicks-ass.net>
 <20190122144329.ziimv6fejwvky7yb@e110439-lin>
 <20190122151317.GH13777@hirez.programming.kicks-ass.net>
 <20190122154129.mxnpgaoxnccbjbch@e110439-lin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190122154129.mxnpgaoxnccbjbch@e110439-lin>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 22, 2019 at 03:41:29PM +0000, Patrick Bellasi wrote:
> On 22-Jan 16:13, Peter Zijlstra wrote:
> > On Tue, Jan 22, 2019 at 02:43:29PM +0000, Patrick Bellasi wrote:

> > > Do you think that could be acceptable?
> > 
> > Think so, it's a sysctl poke, 'nobody' ever does that.
> 
> Cool, so... I'll keep lazy update for system default.

Ah, I think I misunderstood. I meant to say that since nobody ever pokes
at sysctl's it doesn't matter if its a little more expensive and iterate
everything.

Also; if you always keep everything up-to-date, you can avoid doing that
duplicate accounting.
