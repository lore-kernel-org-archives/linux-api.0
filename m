From: Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>
Subject: Re: [PATCH 4/7] locking/rwsem: threshold limited spinning for
 active readers
Date: Mon, 04 Aug 2014 21:54:21 -0700
Message-ID: <1407214461.2566.14.camel@buesod1.americas.hpqcorp.net>
References: <1407119782-41119-1-git-send-email-Waiman.Long@hp.com>
	 <1407119782-41119-5-git-send-email-Waiman.Long@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1407119782-41119-5-git-send-email-Waiman.Long-VXdhtT5mjnY@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Waiman Long <Waiman.Long-VXdhtT5mjnY@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>, Scott J Norton <scott.norton-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, 2014-08-03 at 22:36 -0400, Waiman Long wrote:
> Even thought only the writers can perform optimistic spinning, there
> is still a chance that readers may take the lock before a spinning
> writer can get it. In that case, the owner field will be NULL and the
> spinning writer can spin indefinitely until its time quantum expires
> when some lock owning readers are not running.

Right, now I understand where you were coming from in patch 3/7 ;)

> This patch tries to handle this special case by:
>  1) setting the owner field to a special value RWSEM_READ_OWNED
>     to indicate that the current or last owner is a reader.
>  2) seting a threshold on how many times (currently 100) spinning will
     ^^setting
>     be done with active readers before giving up as there is no easy
>     way to determine if all of them are currently running.
> 
> By doing so, it tries to strike a balance between giving up too early
> and losing potential performance gain and wasting too many precious
> CPU cycles when some lock owning readers are not running.

That's exactly why these kind of magic things aren't a good thing, much
less in locking. And other alternatives are much more involved, creating
more overhead, which can make the whole thing pretty much useless.

Nor does the amount of times trying to spin strike me as the correct
metric to determine such things. Instead something y cycles or time
based.

[...]
>  #ifdef CONFIG_RWSEM_SPIN_ON_OWNER
> +/*
> + * The owner field is set to RWSEM_READ_OWNED if the last owner(s) are
> + * readers. It is not reset until a writer takes over and set it to its
> + * task structure pointer or NULL when it frees the lock. So a value
> + * of RWSEM_READ_OWNED doesn't mean it currently has active readers.
> + */
> +#define RWSEM_READ_OWNED	((struct task_struct *)-1)

Looks rather weird...

>  #define __RWSEM_OPT_INIT(lockname) , .osq = OSQ_LOCK_UNLOCKED, .owner = NULL
>  #else
>  #define __RWSEM_OPT_INIT(lockname)
> diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
> index 9f71a67..576d4cd 100644
> --- a/kernel/locking/rwsem-xadd.c
> +++ b/kernel/locking/rwsem-xadd.c
> @@ -304,6 +304,11 @@ static inline bool rwsem_try_write_lock(long count, struct rw_semaphore *sem)
>  
>  #ifdef CONFIG_RWSEM_SPIN_ON_OWNER
>  /*
> + * Threshold for optimistic spinning on readers
> + */
> +#define RWSEM_READ_SPIN_THRESHOLD	100

I dislike this for the same reasons they weren't welcomed in spinlocks.
We don't know how it can impact workloads that have not been tested.

[...]
>  static bool rwsem_optimistic_spin(struct rw_semaphore *sem)
>  {
>  	struct task_struct *owner;
>  	bool taken = false;
> +	int  read_spincnt = 0;
>  
>  	preempt_disable();
>  
> @@ -397,8 +409,12 @@ static bool rwsem_optimistic_spin(struct rw_semaphore *sem)
>  
>  	while (true) {
>  		owner = ACCESS_ONCE(sem->owner);
> -		if (owner && !rwsem_spin_on_owner(sem, owner))
> +		if (owner == RWSEM_READ_OWNED) {
> +			if (++read_spincnt > RWSEM_READ_SPIN_THRESHOLD)
> +				break;

This is still a pretty fast-path and is going to affect writers, so we
really want to keep it un-clobbered.

Thanks,
Davidlohr
