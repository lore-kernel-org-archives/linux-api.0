From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: handle_exit_race && PF_EXITING
Date: Wed, 6 Nov 2019 10:53:01 +0100 (CET)
Message-ID: <alpine.DEB.2.21.1911061028020.1869@nanos.tec.linutronix.de>
References: <20191104002909.25783-1-shawn@git.icu> <87woceslfs.fsf@oldenburg2.str.redhat.com> <alpine.DEB.2.21.1911051053470.17054@nanos.tec.linutronix.de> <20191105152728.GA5666@redhat.com> <alpine.DEB.2.21.1911051800070.1869@nanos.tec.linutronix.de>
 <alpine.DEB.2.21.1911051851380.1869@nanos.tec.linutronix.de> <alpine.DEB.2.21.1911051920420.1869@nanos.tec.linutronix.de> <alpine.DEB.2.21.1911051959260.1869@nanos.tec.linutronix.de> <20191106085529.GA12575@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191106085529.GA12575@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Florian Weimer <fweimer@redhat.com>, Shawn Landden <shawn@git.icu>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Deepa Dinamani <deepa.kernel@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Keith Packard <keithp@keithp.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-api@vger.kernel.org

Oleg,

On Wed, 6 Nov 2019, Oleg Nesterov wrote:
> I have found the fix I sent in 2015, attached below. I forgot everything
> I knew about futex.c, so I need some time to adapt it to the current code.
> 
> But I think it is clear what this patch tries to do, do you see any hole?

> @@ -716,11 +716,13 @@ void exit_pi_state_list(struct task_struct *curr)
>  
>  	if (!futex_cmpxchg_enabled)
>  		return;
> +
>  	/*
> -	 * We are a ZOMBIE and nobody can enqueue itself on
> -	 * pi_state_list anymore, but we have to be careful
> -	 * versus waiters unqueueing themselves:
> +	 * attach_to_pi_owner() can no longer add the new entry. But
> +	 * we have to be careful versus waiters unqueueing themselves.
>  	 */
> +	curr->flags |= PF_EXITPIDONE;

This obviously would need a barrier or would have to be moved inside of the
pi_lock region.

>  	raw_spin_lock_irq(&curr->pi_lock);
>  	while (!list_empty(head)) {
>  
> @@ -905,24 +907,12 @@ static int attach_to_pi_owner(u32 uval, union futex_key *key,
>  		return -EPERM;
>  	}
>  
> -	/*
> -	 * We need to look at the task state flags to figure out,
> -	 * whether the task is exiting. To protect against the do_exit
> -	 * change of the task flags, we do this protected by
> -	 * p->pi_lock:
> -	 */
>  	raw_spin_lock_irq(&p->pi_lock);
> -	if (unlikely(p->flags & PF_EXITING)) {
> -		/*
> -		 * The task is on the way out. When PF_EXITPIDONE is
> -		 * set, we know that the task has finished the
> -		 * cleanup:
> -		 */
> -		int ret = (p->flags & PF_EXITPIDONE) ? -ESRCH : -EAGAIN;
> -
> +	if (unlikely(p->flags & PF_EXITPIDONE)) {
> +		/* exit_pi_state_list() was already called */
>  		raw_spin_unlock_irq(&p->pi_lock);
>  		put_task_struct(p);
> -		return ret;
> +		return -ESRCH;

But, this is incorrect because we'd return -ESRCH to user space while the
futex value still has the TID of the exiting task set which will
subsequently cleanout the futex and set the owner died bit.

The result is inconsistent state and will trigger the asserts in the futex
test suite and in the pthread_mutex implementation.

The only reason why -ESRCH can be returned is when the user space value of
the futex contains garbage. But in this case it does not contain garbage
and returning -ESRCH violates the implicit robustness guarantee of PI
futexes and causes unexpected havoc.

See da791a667536 ("futex: Cure exit race") for example.

The futex PI contract between kernel and user space relies on consistent
state. Guess why that code has more corner case handling than actual
functionality. :)

Thanks,

	tglx
