From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v13 2/6] sched/core: uclamp: Propagate parent clamps
Date: Thu, 08 Aug 2019 16:08:10 +0100
Message-ID: <87h86r4rvp.fsf@arm.com>
References: <20190802090853.4810-1-patrick.bellasi@arm.com> <20190802090853.4810-3-patrick.bellasi@arm.com> <20190806161153.GA19991@blackbody.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20190806161153.GA19991@blackbody.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>, Alessio Balsini <balsini@android.com>
List-Id: linux-api@vger.kernel.org


On Tue, Aug 06, 2019 at 17:11:53 +0100, Michal Koutný wrote...

> On Fri, Aug 02, 2019 at 10:08:49AM +0100, Patrick Bellasi <patrick.bellasi@arm.com> wrote:
>> @@ -7095,6 +7149,7 @@ static ssize_t cpu_uclamp_write(struct kernfs_open_file *of, char *buf,
>>  	if (req.ret)
>>  		return req.ret;
>>  
>> +	mutex_lock(&uclamp_mutex);
>>  	rcu_read_lock();
>>  
>>  	tg = css_tg(of_css(of));
>> @@ -7107,7 +7162,11 @@ static ssize_t cpu_uclamp_write(struct kernfs_open_file *of, char *buf,
>>  	 */
>>  	tg->uclamp_pct[clamp_id] = req.percent;
>>  
>> +	/* Update effective clamps to track the most restrictive value */
>> +	cpu_util_update_eff(of_css(of));
>> +
>>  	rcu_read_unlock();
>> +	mutex_unlock(&uclamp_mutex);
> Following my remarks to "[PATCH v13 1/6] sched/core: uclamp: Extend
> CPU's cgroup", I wonder if the rcu_read_lock() couldn't be moved right
> before cpu_util_update_eff(). And by extension rcu_read_(un)lock could
> be hidden into cpu_util_update_eff() closer to its actual need.

Well, if I've got correctly your comment in the previous message, I
would say that at this stage we don't need RCU looks at all.

Reason being that cpu_util_update_eff() gets called only from
cpu_uclamp_write() which is from an ongoing write operation on a cgroup
attribute and thus granted to be available.

We will eventually need to move the RCU look only down the stack when
uclamp_update_active_tasks() gets called to update the RUNNABLE tasks on
a RQ... or perhaps we don't need them since we already get the
task_rq_lock() for each task we visit.

Is that correct?

Cheers,
Patrick

-- 
#include <best/regards.h>

Patrick Bellasi
