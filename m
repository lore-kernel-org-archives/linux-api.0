From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v5 01/15] sched/core: uclamp: extend sched_setattr to
 support utilization clamping
Date: Wed, 7 Nov 2018 13:09:42 +0100
Message-ID: <20181107120942.GM9781@hirez.programming.kicks-ass.net>
References: <20181029183311.29175-1-patrick.bellasi@arm.com>
 <20181029183311.29175-2-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181029183311.29175-2-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>, Randy Dunlap <rdunlap@infradead.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Oct 29, 2018 at 06:32:55PM +0000, Patrick Bellasi wrote:
> diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
> index 22627f80063e..c27d6e81517b 100644
> --- a/include/uapi/linux/sched.h
> +++ b/include/uapi/linux/sched.h
> @@ -50,9 +50,11 @@
>  #define SCHED_FLAG_RESET_ON_FORK	0x01
>  #define SCHED_FLAG_RECLAIM		0x02
>  #define SCHED_FLAG_DL_OVERRUN		0x04
> +#define SCHED_FLAG_UTIL_CLAMP		0x08
>  
>  #define SCHED_FLAG_ALL	(SCHED_FLAG_RESET_ON_FORK	| \
>  			 SCHED_FLAG_RECLAIM		| \
> -			 SCHED_FLAG_DL_OVERRUN)
> +			 SCHED_FLAG_DL_OVERRUN		| \
> +			 SCHED_FLAG_UTIL_CLAMP)
>  
>  #endif /* _UAPI_LINUX_SCHED_H */
> diff --git a/include/uapi/linux/sched/types.h b/include/uapi/linux/sched/types.h
> index 10fbb8031930..fde7301ed28c 100644
> --- a/include/uapi/linux/sched/types.h
> +++ b/include/uapi/linux/sched/types.h
> @@ -9,6 +9,7 @@ struct sched_param {
>  };
>  
>  #define SCHED_ATTR_SIZE_VER0	48	/* sizeof first published struct */
> +#define SCHED_ATTR_SIZE_VER1	56	/* add: util_{min,max} */
>  
>  /*
>   * Extended scheduling parameters data structure.


--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4533,6 +4533,10 @@ static int sched_copy_attr(struct sched_
 	if (ret)
 		return -EFAULT;
 
+	if ((attr->sched_flags & SCHED_FLAG_UTIL_CLAMP) &&
+	    size < SCHED_ATTR_SIZE_VER1)
+		return -EINVAL;
+
 	/*
 	 * XXX: Do we want to be lenient like existing syscalls; or do we want
 	 * to be strict and return an error on out-of-bounds values?
