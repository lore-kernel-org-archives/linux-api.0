From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v8 00/16] Add utilization clamping support
Date: Thu, 9 May 2019 15:02:15 +0200
Message-ID: <20190509130215.GV2623@hirez.programming.kicks-ass.net>
References: <20190402104153.25404-1-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190402104153.25404-1-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 02, 2019 at 11:41:36AM +0100, Patrick Bellasi wrote:
> Series Organization
> ===================
> 
> The series is organized into these main sections:
> 
>  - Patches [01-07]: Per task (primary) API
>  - Patches [08-09]: Schedutil integration for FAIR and RT tasks
>  - Patches [10-11]: Integration with EAS's energy_compute()

Aside from the comments already provided, I think this is starting to
look really good.

Thanks!

>  - Patches [12-16]: Per task group (secondary) API

I still have to stare at these, but maybe a little later...
