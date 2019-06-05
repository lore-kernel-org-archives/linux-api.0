From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 12/16] sched/core: uclamp: Extend CPU's cgroup
 controller
Date: Wed, 5 Jun 2019 08:39:55 -0700
Message-ID: <20190605153955.GP374014@devbig004.ftw2.facebook.com>
References: <20190515094459.10317-1-patrick.bellasi@arm.com>
 <20190515094459.10317-13-patrick.bellasi@arm.com>
 <20190531153545.GE374014@devbig004.ftw2.facebook.com>
 <20190603122725.GB19426@darkstar>
 <20190605140324.GL374014@devbig004.ftw2.facebook.com>
 <20190605143805.olk2ta5p2jnd4mjt@e110439-lin>
 <20190605144450.GN374014@devbig004.ftw2.facebook.com>
 <20190605153742.lusoiodrzxmpsrvd@e110439-lin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190605153742.lusoiodrzxmpsrvd@e110439-lin>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

Hello, Patrick.

On Wed, Jun 05, 2019 at 04:37:43PM +0100, Patrick Bellasi wrote:
> > Everything sounds good to me.  Please note that cgroup interface files
> > actually use literal "max" for limit/protection max settings so that 0
> > and "max" mean the same things for all limit/protection knobs.
> 
> Lemme see if I've got it right, do you mean that we can:
> 
>  1) write the _string_ "max" into a cgroup attribute to:
> 
>     - set    0 for util_max, since it's a protection
>     - set 1024 for util_min, since it's a limit
>
>  2) write the _string_ "0" into a cgroup attribute to:
> 
>     - set 1024 for util_max, since it's a protection
>     - set    0 for util_min, since it's a limit
> 
> Is that correct or it's just me totally confused?

Heh, sorry about not being clearer.  "max" just means numerically
highest possible config for the config knob, so in your case, "max"
would always map to 1024.

Thanks.

-- 
tejun
