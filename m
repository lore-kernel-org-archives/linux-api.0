From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 12/16] sched/core: uclamp: Extend CPU's cgroup
 controller
Date: Wed, 5 Jun 2019 07:44:50 -0700
Message-ID: <20190605144450.GN374014@devbig004.ftw2.facebook.com>
References: <20190515094459.10317-1-patrick.bellasi@arm.com>
 <20190515094459.10317-13-patrick.bellasi@arm.com>
 <20190531153545.GE374014@devbig004.ftw2.facebook.com>
 <20190603122725.GB19426@darkstar>
 <20190605140324.GL374014@devbig004.ftw2.facebook.com>
 <20190605143805.olk2ta5p2jnd4mjt@e110439-lin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190605143805.olk2ta5p2jnd4mjt@e110439-lin>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

Hello,

On Wed, Jun 05, 2019 at 03:39:50PM +0100, Patrick Bellasi wrote:
> Which means we will enforce the effective values as:
> 
>    /tg1/tg11:
> 
>          util_min.effective=0
>             i.e. keep the child protection since smaller than parent
> 
>          util_max.effective=800
>             i.e. keep parent limit since stricter than child
>
> Please shout if I got it wrong, otherwise I'll update v10 to
> implement the above logic.

Everything sounds good to me.  Please note that cgroup interface files
actually use literal "max" for limit/protection max settings so that 0
and "max" mean the same things for all limit/protection knobs.

Thanks.

-- 
tejun
