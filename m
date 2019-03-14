From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v7 01/15] sched/core: uclamp: Add CPU's clamp buckets refcounting
Date: Thu, 14 Mar 2019 09:39:09 -0700
Message-ID: <CAJuCfpEWCcWj=B2SPai2pQt+wcjsAhEfVV1O+H0A+_fqLCnb8Q@mail.gmail.com>
References: <20190208100554.32196-1-patrick.bellasi@arm.com>
 <20190208100554.32196-2-patrick.bellasi@arm.com> <CAJuCfpGAZ6XxJj=e-wVzGx3zmRRLPs=wXm8K0BcjWOm5hM0FcQ@mail.gmail.com>
 <20190314144600.2ulpeipad7jbxyiy@e110439-lin> <CAJuCfpFDVi7O+yqQ+F0DT3pRZN=BtRD8NyUH5Tys0VVkd9JAGg@mail.gmail.com>
 <20190314154052.345v74snhtc4cqbe@e110439-lin>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190314154052.345v74snhtc4cqbe@e110439-lin>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 14, 2019 at 8:41 AM Patrick Bellasi <patrick.bellasi@arm.com> wrote:
>
> On 14-Mar 08:29, Suren Baghdasaryan wrote:
> > On Thu, Mar 14, 2019 at 7:46 AM Patrick Bellasi <patrick.bellasi@arm.com> wrote:
> > > On 13-Mar 14:32, Suren Baghdasaryan wrote:
> > > > On Fri, Feb 8, 2019 at 2:06 AM Patrick Bellasi <patrick.bellasi@arm.com> wrote:
>
> [...]
>
> > > > > The rq::uclamp::bucket[clamp_id][] array is scanned every time we need
> > > > > to find a new MAX aggregated clamp value for a clamp_id. This operation
> > > > > is required only when we dequeue the last task of a clamp bucket
> > > > > tracking the current MAX aggregated clamp value. In these cases, the CPU
> > > > > is either entering IDLE or going to schedule a less boosted or more
> > > > > clamped task.
>
> The following:
>
> > > > > The expected number of different clamp values, configured at build time,
> > > > > is small enough to fit the full unordered array into a single cache
> > > > > line.
>
> will read:
>
> The expected number of different clamp values, configured at build time,
> is small enough to fit the full unordered array into a single cache
> line for the default UCLAMP_BUCKETS configuration of 7 buckets.

I think keeping default to be 5 is good. As you mentioned it's a nice
round number and keeping it at the minimum also hints that this is not
a free resource and the more buckets you use the more you pay.
Documentation might say "to fit the full unordered array into a single
cache line for configurations of up to 7 buckets".

> [...]
>
> > Got it. From reading the documentation at the beginning my impression
> > was that whatever value I choose within allowed 5-20 range it would
> > still fit in a cache line. To disambiguate it might be worse
> > mentioning that this is true for the default value or for values up to
> > 7. Thanks!
>
> Right, I hope the above proposed change helps to clarify that.
>
> --
> #include <best/regards.h>
>
> Patrick Bellasi
