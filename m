From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v5 02/15] sched/core: make sched_setattr able to tune the
 current policy
Date: Wed, 7 Nov 2018 13:11:26 +0100
Message-ID: <20181107121126.GN9781@hirez.programming.kicks-ass.net>
References: <20181029183311.29175-1-patrick.bellasi@arm.com>
 <20181029183311.29175-3-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181029183311.29175-3-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Oct 29, 2018 at 06:32:56PM +0000, Patrick Bellasi wrote:

> @@ -50,11 +52,13 @@
>  #define SCHED_FLAG_RESET_ON_FORK	0x01
>  #define SCHED_FLAG_RECLAIM		0x02
>  #define SCHED_FLAG_DL_OVERRUN		0x04
> -#define SCHED_FLAG_UTIL_CLAMP		0x08
> +#define SCHED_FLAG_TUNE_POLICY		0x08
> +#define SCHED_FLAG_UTIL_CLAMP		0x10

That seems to suggest you want to do this patch first, but you didn't..
