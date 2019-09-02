From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v14 1/6] sched/core: uclamp: Extend CPU's cgroup controller
Date: Mon, 02 Sep 2019 07:38:53 +0100
Message-ID: <87zhjnnqz2.fsf@arm.com>
References: <20190822132811.31294-1-patrick.bellasi@arm.com> <20190822132811.31294-2-patrick.bellasi@arm.com> <20190830094505.GA2369@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20190830094505.GA2369@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Michal Koutny <mkoutny@suse.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>, Alessio Balsini <balsini@android.com>
List-Id: linux-api@vger.kernel.org


On Fri, Aug 30, 2019 at 09:45:05 +0000, Peter Zijlstra wrote...

> On Thu, Aug 22, 2019 at 02:28:06PM +0100, Patrick Bellasi wrote:
>> +#define _POW10(exp) ((unsigned int)1e##exp)
>> +#define POW10(exp) _POW10(exp)
>
> What is this magic? You're forcing a float literal into an integer.
> Surely that deserves a comment!

Yes, I'm introducing the two constants:
  UCLAMP_PERCENT_SHIFT,
  UCLAMP_PERCENT_SCALE
similar to what we have for CAPACITY. Moreover, I need both 100*100 (for
the scale) and 100 further down in the code for the: 

	percent = div_u64_rem(percent, POW10(UCLAMP_PERCENT_SHIFT), &rem);

used in cpu_uclamp_print().

That's why adding a compile time support to compute a 10^N is useful.

C provides the "1eN" literal, I just convert it to integer and to do
that at compile time I need a two level macros.

What if I add this comment just above the macro definitions:

/*
 * Integer 10^N with a given N exponent by casting to integer the literal "1eN"
 * C expression. Since there is no way to convert a macro argument (N) into a
 * character constant, use two levels of macros.
 */

is this clear enough?

>
>> +struct uclamp_request {
>> +#define UCLAMP_PERCENT_SHIFT	2
>> +#define UCLAMP_PERCENT_SCALE	(100 * POW10(UCLAMP_PERCENT_SHIFT))
>> +	s64 percent;
>> +	u64 util;
>> +	int ret;
>> +};
>> +
>> +static inline struct uclamp_request
>> +capacity_from_percent(char *buf)
>> +{
>> +	struct uclamp_request req = {
>> +		.percent = UCLAMP_PERCENT_SCALE,
>> +		.util = SCHED_CAPACITY_SCALE,
>> +		.ret = 0,
>> +	};
>> +
>> +	buf = strim(buf);
>> +	if (strncmp("max", buf, 4)) {
>
> That is either a bug, and you meant to write: strncmp(buf, "max", 3),
> or it is not, and then you could've written: strcmp(buf, "max")

I don't think it's a bug.

The usage of 4 is intentional, to force a '\0' check while using
strncmp(). Otherwise, strncmp(buf, "max", 3) would accept also strings
starting by "max", which we don't want.

> But as written it doesn't make sense.

The code is safe but I agree that strcmp() does just the same and it
does not generate confusion. That's actually a pretty good example
on how it's not always better to use strncmp() instead of strcmp().

Cheers,
Patrick
