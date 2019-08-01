From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v12 1/6] sched/core: uclamp: Extend CPU's cgroup
 controller
Date: Thu, 1 Aug 2019 11:40:14 +0100
Message-ID: <20190801104014.amwvjdvabedsd5t7@e110439-lin>
References: <20190718181748.28446-1-patrick.bellasi@arm.com>
 <20190718181748.28446-2-patrick.bellasi@arm.com>
 <20190725114104.GA32159@blackbody.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190725114104.GA32159@blackbody.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, Alessio Balsini <balsini@android.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Quentin Perret <quentin.perret@arm.com>, Joel Fernandes <joelaf@google.com>, Paul Turner <pjt@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>, Todd Kjos <tkjos@google.com>, Peter Zijlstra <peterz@infradead.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Tejun Heo <tj@kernel.org>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Juri Lelli <juri.lelli@redhat.com>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-api@vger.kernel.org

On 25-Jul 13:41, Michal Koutný wrote:
> On Thu, Jul 18, 2019 at 07:17:43PM +0100, Patrick Bellasi <patrick.bellasi@arm.com> wrote:
> > +static ssize_t cpu_uclamp_min_write(struct kernfs_open_file *of,
> > +				    char *buf, size_t nbytes,
> > +				    loff_t off)
> > +{
> > [...]
> > +static ssize_t cpu_uclamp_max_write(struct kernfs_open_file *of,
> > +				    char *buf, size_t nbytes,
> > +				    loff_t off)
> > +{
> > [...]
> These two functions are almost identical yet not trivial. I think it
> wouldn be better to have the code at one place only and distinguish by
> the passed clamp_id.

Good point, since the removal of the boundary checks on values we now
have two identical methods. I'll factor our the common code in a
single function.

Cheers,
Patrick

-- 
#include <best/regards.h>

Patrick Bellasi
