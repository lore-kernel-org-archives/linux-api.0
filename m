From: Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v3] sched/fair: Add advisory flag for borrowing a
 timeslice (was: Pre-emption control for userspace)
Date: Mon, 24 Nov 2014 14:43:02 -0800
Message-ID: <20141124224302.GL10824@tassilo.jf.intel.com>
References: <1416862595-24513-1-git-send-email-khalid.aziz@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1416862595-24513-1-git-send-email-khalid.aziz@oracle.com>
Sender: linux-doc-owner@vger.kernel.org
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: tglx@linutronix.de, corbet@lwn.net, mingo@redhat.com, hpa@zytor.com, peterz@infradead.org, riel@redhat.com, akpm@linux-foundation.org, rientjes@google.com, mgorman@suse.de, liwanp@linux.vnet.ibm.com, raistlin@linux.it, kirill.shutemov@linux.intel.com, atomlin@redhat.com, avagin@openvz.org, gorcunov@openvz.org, serge.hallyn@canonical.com, athorlton@sgi.com, oleg@redhat.com, vdavydov@parallels.com, daeseok.youn@gmail.com, keescook@chromium.org, yangds.fnst@cn.fujitsu.com, sbauer@eng.utah.edu, vishnu.ps@samsung.com, axboe@fb.com, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

> +1. Location of shared flag can be set using prctl() only once. To
> +   write a new memory address, the previous memory address must be
> +   cleared first by writing NULL. Each new memory address requires
> +   validation in the kernel and update of pointers. Changing this
> +   address too many times creates too much overhead.

Can you explain this more? Doesn't make any sense to me.
The validation is just access_ok() which is only a few instructions?

Also I would drop the config symbol. Linux normally doesn't
do CONFIG for things like that.

> diff --git a/kernel/fork.c b/kernel/fork.c
> index 9b7d746..7f0d843 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1671,6 +1671,11 @@ long do_fork(unsigned long clone_flags,
>  			init_completion(&vfork);
>  			get_task_struct(p);
>  		}
> +#ifdef CONFIG_SCHED_PREEMPT_DELAY
> +		p->sched_preempt_delay.delay_req = NULL;
> +		p->sched_preempt_delay.delay_granted = 0;
> +		p->sched_preempt_delay.yield_penalty = 0;
> +#endif

FWIW this would lead to every new thread having to reexecute
this. No good way around it, but it may eventually make
thread spawns more expensive if it was widely used.

>  
> +#ifdef CONFIG_SCHED_PREEMPT_DELAY
> +	/*
> +	 * Clear the penalty flag for current task to reward it for
> +	 * palying by the rules
> +	 */
> +	current->sched_preempt_delay.yield_penalty = 0;
> +#endif

Doesn't that need to be quantified? After all they may yield
only near the end of their time slice.

> +	}
> +
> +	/*
> +	 * Get the value of preemption delay request flag from userspace.
> +	 * Task had already passed us the address where the flag is stored
> +	 * in userspace earlier. This flag is just like the PROCESS_PRIVATE
> +	 * futex, leverage the futex code here to read the flag. If there

I don't think any of the calls below are futex code.

> +	case PR_GET_PREEMPT_DELAY:
> +		error = put_user(
> +			(unsigned long)current->sched_preempt_delay.delay_req,
> +					(unsigned long __user *)arg2);
> +		break;
> +#endif

Unnecessary cast.

> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1104,6 +1104,15 @@ static struct ctl_table kern_table[] = {
>  		.proc_handler	= proc_dointvec,
>  	},
>  #endif
> +#ifdef CONFIG_SCHED_PREEMPT_DELAY
> +	{
> +		.procname	= "preempt_delay_available",
> +		.data		= &sysctl_preempt_delay_available,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0600,

Better 0644, so users can know if they can use it.

Rest looks reasonable to me.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
