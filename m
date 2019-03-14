From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v7 01/15] sched/core: uclamp: Add CPU's clamp buckets
 refcounting
Date: Thu, 14 Mar 2019 14:27:30 +0100
Message-ID: <20190314132730.GI5996@hirez.programming.kicks-ass.net>
References: <20190208100554.32196-1-patrick.bellasi@arm.com>
 <20190208100554.32196-2-patrick.bellasi@arm.com>
 <20190313135238.GC5922@hirez.programming.kicks-ass.net>
 <20190313155954.jse2tyn5iqxm6wle@e110439-lin>
 <20190313193056.GP2482@worktop.programming.kicks-ass.net>
 <20190314110330.rshrdeoxgzt6pk5a@e110439-lin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190314110330.rshrdeoxgzt6pk5a@e110439-lin>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 14, 2019 at 11:03:30AM +0000, Patrick Bellasi wrote:

> void uclamp_rq_dec_id(struct rq *rq, int clamp_id, int bucket_id) {
>     if (__builtin_expect(!!(rq->uclamp[clamp_id].bucket[bucket_id].tasks), 1))
>         return;
>     rq->uclamp[clamp_id].bucket[bucket_id].tasks--;
> }
> ---8<---
> 
> generates something like:
> 
> ---8<---
> uclamp_rq_dec_id:
>         sxtw    x1, w1
>         add     x3, x1, x1, lsl 1
>         lsl     x3, x3, 2
>         sub     x3, x3, x1
>         lsl     x3, x3, 2
>         add     x2, x3, x2, sxtw 3
>         add     x0, x0, x2
>         ldr     w1, [x0, 8]
>         cbz     w1, .L4
>         ret
> .L4:
>         mov     w1, -1
>         str     w1, [x0, 8]
>         ret
> ---8<---
> 
> 
> which looks "sane" and quite expected, isn't it?

Yep, thanks! Sometimes I worry about silly things.
