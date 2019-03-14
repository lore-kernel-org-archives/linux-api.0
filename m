From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v7 01/15] sched/core: uclamp: Add CPU's clamp buckets
 refcounting
Date: Thu, 14 Mar 2019 14:54:56 +0000
Message-ID: <20190314145456.5qpxchfltfauqaem@e110439-lin>
References: <20190208100554.32196-1-patrick.bellasi@arm.com>
 <20190208100554.32196-2-patrick.bellasi@arm.com>
 <21171fa0-7fd5-ebbf-dd48-d6668ed563af@arm.com>
 <20190313151535.q5ivsuywvwkewrk5@e110439-lin>
 <CAJuCfpGzxnV8UH4h0O7V03RrecEkJA3JQ3zJTu=b8SHhnOo_mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJuCfpGzxnV8UH4h0O7V03RrecEkJA3JQ3zJTu=b8SHhnOo_mg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suren Baghdasaryan <surenb@google.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>, LKML <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>
List-Id: linux-api@vger.kernel.org

On 13-Mar 14:01, Suren Baghdasaryan wrote:
> On Wed, Mar 13, 2019 at 8:15 AM Patrick Bellasi <patrick.bellasi@arm.com> wrote:
> >
> > On 12-Mar 13:52, Dietmar Eggemann wrote:
> > > On 2/8/19 11:05 AM, Patrick Bellasi wrote:

[...]

> > > > +static inline unsigned int uclamp_bucket_value(unsigned int clamp_value)
> > > > +{
> > > > +   return UCLAMP_BUCKET_DELTA * uclamp_bucket_id(clamp_value);
> > > > +}
> > >
> > > Soemthing like uclamp_bucket_nominal_value() should be clearer.
> >
> > Maybe... can update it in v8
> >
> 
> uclamp_bucket_base_value is a little shorter, just to consider :)

Right, I also like it better ;)

-- 
#include <best/regards.h>

Patrick Bellasi
