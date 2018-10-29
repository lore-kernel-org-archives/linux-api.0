From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v5 01/15] sched/core: uclamp: extend sched_setattr to
 support utilization clamping
Date: Mon, 29 Oct 2018 12:33:31 -0700
Message-ID: <5d17113b-d0c8-dafe-f4f9-527722749bb8@infradead.org>
References: <20181029183311.29175-1-patrick.bellasi@arm.com>
 <20181029183311.29175-2-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181029183311.29175-2-patrick.bellasi@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 10/29/18 11:32 AM, Patrick Bellasi wrote:

> diff --git a/include/uapi/linux/sched/types.h b/include/uapi/linux/sched/types.h
> index 10fbb8031930..fde7301ed28c 100644
> --- a/include/uapi/linux/sched/types.h
> +++ b/include/uapi/linux/sched/types.h

> @@ -53,6 +73,30 @@ struct sched_param {
>   * As of now, the SCHED_DEADLINE policy (sched_dl scheduling class) is the
>   * only user of this new interface. More information about the algorithm
>   * available in the scheduling class file or in Documentation/.
> + *
> + * Task Utilization Attributes
> + * ===========================
> + *
> + * A subset of sched_attr attributes allows to specify the utilization which
> + * should be expected by a task. These attributes allow to inform the
> + * scheduler about the utilization boundaries within which it is expected to
> + * schedule the task. These boundaries are valuable hints to support scheduler
> + * decisions on both task placement and frequencies selection.
> + *
> + *  @sched_util_min	represents the minimum utilization
> + *  @sched_util_max	represents the maximum utilization
> + *
> + * Utilization is a value in the range [0..SCHED_CAPACITY_SCALE] which
> + * represents the percentage of CPU time used by a task when running at the
> + * maximum frequency on the highest capacity CPU of the system. Thus, for
> + * example, a 20% utilization task is a task running for 2ms every 10ms.
> + *
> + * A task with a min utilization value bigger then 0 is more likely to be

                                                 than

> + * scheduled on a CPU which has a capacity big enough to fit the specified
> + * minimum utilization value.
> + * A task with a max utilization value smaller then 1024 is more likely to be
> + * scheduled on a CPU which do not necessarily have more capacity then the

                               does                                  than

> + * specified max utilization value.
>   */
>  struct sched_attr {
>  	__u32 size;


cheers.
-- 
~Randy
