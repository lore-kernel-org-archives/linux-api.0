From: Khalid Aziz <khalid.aziz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] sched/fair: Add advisory flag for borrowing a
 timeslice (was: Pre-emption control for userspace)
Date: Mon, 24 Nov 2014 16:20:44 -0700
Message-ID: <1416871244.17110.11.camel@concerto>
References: <1416862595-24513-1-git-send-email-khalid.aziz@oracle.com>
	 <20141124224302.GL10824@tassilo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141124224302.GL10824-KWJ+5VKanrL29G5dvP0v1laTQe2KTcn/@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, liwanp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, raistlin-k2GhghHVRtY@public.gmane.org, kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, atomlin-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, athorlton-sJ/iWh9BUns@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, daeseok.youn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, sbauer-F61uvSdQLzf2fBVCVOL8/A@public.gmane.org, vishnu.ps-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 2014-11-24 at 14:43 -0800, Andi Kleen wrote:
> > +1. Location of shared flag can be set using prctl() only once. To
> > +   write a new memory address, the previous memory address must be
> > +   cleared first by writing NULL. Each new memory address requires
> > +   validation in the kernel and update of pointers. Changing this
> > +   address too many times creates too much overhead.
> 
> Can you explain this more? Doesn't make any sense to me.
> The validation is just access_ok() which is only a few instructions?

>From userspace app point of view, each call to prctl() incurs the
overhead of a system call.

> 
> Also I would drop the config symbol. Linux normally doesn't
> do CONFIG for things like that.

CONFIG_SCHED_PREEMPT_DELAY allows one to keep this code out of compiled
kernel for custom kernels if this feature is definitely not needed.
Concerns were raised last time about this feature impacting other tasks.
Nevertheless, I am ok with removing the config option if that is the
consensus.

> 
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index 9b7d746..7f0d843 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -1671,6 +1671,11 @@ long do_fork(unsigned long clone_flags,
> >  			init_completion(&vfork);
> >  			get_task_struct(p);
> >  		}
> > +#ifdef CONFIG_SCHED_PREEMPT_DELAY
> > +		p->sched_preempt_delay.delay_req = NULL;
> > +		p->sched_preempt_delay.delay_granted = 0;
> > +		p->sched_preempt_delay.yield_penalty = 0;
> > +#endif
> 
> FWIW this would lead to every new thread having to reexecute
> this. No good way around it, but it may eventually make
> thread spawns more expensive if it was widely used.

Yes, that is true. Newly allocated task_struct is not zero'd out, so
this becomes necessary.

> 
> >  
> > +#ifdef CONFIG_SCHED_PREEMPT_DELAY
> > +	/*
> > +	 * Clear the penalty flag for current task to reward it for
> > +	 * palying by the rules
> > +	 */
> > +	current->sched_preempt_delay.yield_penalty = 0;
> > +#endif
> 
> Doesn't that need to be quantified? After all they may yield
> only near the end of their time slice.

and that should be ok because the task was allowed to borrow a full
timeslice and it can use it up almost completely. Is there a reason to
differentiate between tasks yielding well before their borrowed
timeslice is up and tasks not yielding until almost the end of borrowed
timeslice?

> 
> > +	}
> > +
> > +	/*
> > +	 * Get the value of preemption delay request flag from userspace.
> > +	 * Task had already passed us the address where the flag is stored
> > +	 * in userspace earlier. This flag is just like the PROCESS_PRIVATE
> > +	 * futex, leverage the futex code here to read the flag. If there
> 
> I don't think any of the calls below are futex code.

Following code was borrowed from get_futex_value_locked() but this
comment is not really necessary here and can be removed if it causes
confusion.

> 
> > +	case PR_GET_PREEMPT_DELAY:
> > +		error = put_user(
> > +			(unsigned long)current->sched_preempt_delay.delay_req,
> > +					(unsigned long __user *)arg2);
> > +		break;
> > +#endif
> 
> Unnecessary cast.

I get bunch of warnings and errors if I remove either of the casts.

> 
> > --- a/kernel/sysctl.c
> > +++ b/kernel/sysctl.c
> > @@ -1104,6 +1104,15 @@ static struct ctl_table kern_table[] = {
> >  		.proc_handler	= proc_dointvec,
> >  	},
> >  #endif
> > +#ifdef CONFIG_SCHED_PREEMPT_DELAY
> > +	{
> > +		.procname	= "preempt_delay_available",
> > +		.data		= &sysctl_preempt_delay_available,
> > +		.maxlen		= sizeof(int),
> > +		.mode		= 0600,
> 
> Better 0644, so users can know if they can use it.

OK, I can change that.

> 
> Rest looks reasonable to me.
> 
> -Andi

Thanks, Andi! I appreciate your feedback.

--
Khalid
