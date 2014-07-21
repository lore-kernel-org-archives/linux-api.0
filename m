From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 1/5] futex: add new exclusive lock & unlock command
 codes
Date: Mon, 21 Jul 2014 18:42:16 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1407211811360.20847@nanos>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com> <1405956271-34339-2-git-send-email-Waiman.Long@hp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1405956271-34339-2-git-send-email-Waiman.Long@hp.com>
Sender: linux-doc-owner@vger.kernel.org
To: Waiman Long <Waiman.Long@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@linux.intel.com>, Davidlohr Bueso <davidlohr@hp.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>
List-Id: linux-api@vger.kernel.org

On Mon, 21 Jul 2014, Waiman Long wrote:

> +#define FUTEX_TID(u)		(pid_t)((u) & FUTEX_TID_MASK)
> +#define FUTEX_HAS_WAITERS(u)	((u) & FUTEX_WAITERS)

You love ugly macros, right?

> +/*
> + * futex_spin_trylock - attempt to take the lock
> + * Return: 1 if successful or an error happen
> + *	   0 otherwise
> + *
> + * Side effect: The uval and ret will be updated.
> + */
> +static inline int futex_spin_trylock(u32 __user *uaddr, u32 *puval,
> +				       int *pret, u32 vpid)
> +{
> +	u32	  old;
> +
> +	*pret = get_futex_value_locked(puval, uaddr);
> +	if (*pret)
> +		return 1;
> +
> +	if (FUTEX_TID(*puval))
> +		return 0;	/* The mutex is not free */
> +
> +	old = *puval;
> +
> +	*pret = cmpxchg_futex_value_locked(puval, uaddr, old, vpid | old);
> +	if (*pret)
> +		return 1;
> +	if (*puval == old) {
> +		/* Adjust uval to reflect current value */
> +		*puval = vpid | old;
> +		return 1;
> +	}
> +	return 0;

What's the point if all of this?

A simple cmpxchg_futex_value_locked() does all of this, just less ugly
and without all these extra indirections and totally uncomprehensible
conditionals.

> +}
> +
> +/*
> + * futex_spin_lock
> + */
> +static noinline int futex_spin_lock(u32 __user *uaddr, unsigned int flags)
> +{

So this lacks a timeout. If we provide this, then we need to have the
timeout supported as well.

> +	struct futex_hash_bucket *hb;
> +	struct futex_q_head	 *qh = NULL;
> +	struct futex_q_node	  qnode;
> +	union futex_key		  key;
> +	bool			  gotlock;
> +	int			  ret, cnt;
> +	u32			  uval, vpid, old;
> +
> +	qnode.task  = current;
> +	vpid = task_pid_vnr(qnode.task);
> +
> +	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &key, VERIFY_WRITE);
> +	if (unlikely(ret))

Stop sprinkling the code with unlikelys

> +		return ret;
> +
> +	hb = hash_futex(&key);
> +	spin_lock(&hb->lock);
> +
> +	/*
> +	 * Locate the queue head for the given key
> +	 */

Brilliant comment. If you'd comment the stuff which really matters and
leave out the obvious, then your code might be readable some day.

> +	qh = find_qhead(hb, &key);
> +
> +	/*
> +	 * Check the futex value under the hash bucket lock as it might
> +	 * be changed.
> +	 */

What might have changed? You enter the function with uaddr, but no
uval. So what changed? 

> +	if (futex_spin_trylock(uaddr, &uval, &ret, vpid))
> +		goto hbunlock_out;
> +
> +	if (!qh) {
> +		/*
> +		 * First waiter:
> +		 * Allocate a queue head structure & initialize it
> +		 */
> +		qh = qhead_alloc_init(hb, &key);
> +		if (unlikely(!qh)) {
> +			ret = -ENOMEM;
> +			goto hbunlock_out;
> +		}
> +	} else {
> +		atomic_inc(&qh->lcnt);
> +	}
> +	spin_unlock(&hb->lock);
> +
> +	/*
> +	 * Put the task into the wait queue and sleep
> +	 */
> +	preempt_disable();

Why?

> +	get_task_struct(qnode.task);

So you get a task reference on current? What the heck is this for?

> +	spin_lock(&qh->wlock);
> +	list_add_tail(&qnode.wnode, &qh->waitq);
> +	__set_current_state(TASK_INTERRUPTIBLE);
> +	spin_unlock(&qh->wlock);
> +	gotlock = false;
> +	for (;;) {
> +		ret = get_user(uval, uaddr);
> +		if (ret)
> +			break;

So you let user space handle EFAULT? 

> +dequeue:
> +	__set_current_state(TASK_RUNNING);
> +	/*
> +	 * Remove itself from the wait queue and go back to optimistic
> +	 * spinning if it hasn't got the lock yet.
> +	 */
> +	put_task_struct(qnode.task);
> +	spin_lock(&qh->wlock);
> +	list_del(&qnode.wnode);
> +
> +	/*
> +	 * Try to clear the waiter bit if the wait queue is empty
> +	 */
> +	if (list_empty(&qh->waitq)) {
> +		int retval = get_futex_value_locked(&uval, uaddr);
> +
> +		if (!retval && FUTEX_HAS_WAITERS(uval)) {
> +			old   = uval;
> +			uval &= ~FUTEX_WAITERS;
> +			(void)cmpxchg_futex_value_locked(&uval, uaddr, old,
> +							  uval);
> +		}
> +	}
> +	spin_unlock(&qh->wlock);
> +	preempt_enable();
> +
> +	cnt = atomic_dec_return(&qh->lcnt);
> +	if (cnt == 0)
> +		qhead_free(qh, hb);
> +	/*
> +	 * Need to set the waiters bit there are still waiters
> +	 */
> +	else if (!ret)
> +		ret = put_user(vpid | FUTEX_WAITERS, uaddr);

WTF? You fiddle with the uaddr completely unprotected. 

> +out:
> +	put_futex_key(&key);
> +	return ret;
> +
> +hbunlock_out:
> +	spin_unlock(&hb->lock);
> +	goto out;
> +}
> +
> +/*
> + * futex_spin_unlock
> + */
> +static noinline int futex_spin_unlock(u32 __user *uaddr, unsigned int flags)
> +{
> +	struct futex_hash_bucket *hb;
> +	struct futex_q_head	 *qh;
> +	union futex_key		  key;
> +	struct task_struct	 *wtask;	/* Task to be woken */
> +	int			  ret, lcnt;
> +	u32			  uval, old, vpid = task_pid_vnr(current);
> +
> +	ret = get_user(uval, uaddr);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * The unlocker may have cleared the TID value and another task may
> +	 * steal it. However, if its TID is still set, we need to clear
> +	 * it as well as the FUTEX_WAITERS bit.

No, that's complete and utter crap. The unlocker is current and it may
not have cleared anything.

Your design or the lack thereof is a complete disaster.

Sit down first and define the exact semantics of the new opcode. That
includes user and kernel space and the interaction with robust list,
which you happily ignored.

What are the semantics of uval? When can it be changed in kernel and
in user space? How do we deal with corruption of the user space value?

How does that new opcode provide robustness?

How are faults handled?

....

Before you can't provide a coherent description of that, nothing of
this is going to happen. And after that, it's definitely not going to
look like the hackery you delivered now.

Thanks,

	tglx



