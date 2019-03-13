From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v7 01/15] sched/core: uclamp: Add CPU's clamp buckets
 refcounting
Date: Wed, 13 Mar 2019 20:48:38 +0100
Message-ID: <20190313194838.GS2482@worktop.programming.kicks-ass.net>
References: <20190208100554.32196-1-patrick.bellasi@arm.com>
 <20190208100554.32196-2-patrick.bellasi@arm.com>
 <20190313134022.GB5922@hirez.programming.kicks-ass.net>
 <20190313161229.pkib2tmjass5chtb@e110439-lin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190313161229.pkib2tmjass5chtb@e110439-lin>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 13, 2019 at 04:12:29PM +0000, Patrick Bellasi wrote:
> On 13-Mar 14:40, Peter Zijlstra wrote:
> > On Fri, Feb 08, 2019 at 10:05:40AM +0000, Patrick Bellasi wrote:
> > > +static inline unsigned int uclamp_bucket_id(unsigned int clamp_value)
> > > +{
> > > +	return clamp_value / UCLAMP_BUCKET_DELTA;
> > > +}
> > > +
> > > +static inline unsigned int uclamp_bucket_value(unsigned int clamp_value)
> > > +{
> > > +	return UCLAMP_BUCKET_DELTA * uclamp_bucket_id(clamp_value);
> > 
> > 	return clamp_value - (clamp_value % UCLAMP_BUCKET_DELTA);
> > 
> > might generate better code; just a single division, instead of a div and
> > mult.
> 
> Wondering if compilers cannot do these optimizations... but yes, looks
> cool and will do it in v8, thanks.

I'd be most impressed if they pull this off. Check the generated code
and see I suppose :-)
