From: Waiman Long <waiman.long-VXdhtT5mjnY@public.gmane.org>
Subject: Re: [RFC PATCH 2/5] futex: add optimistic spinning to FUTEX_SPIN_LOCK
Date: Tue, 22 Jul 2014 14:46:12 -0400
Message-ID: <53CEB174.5050600@hp.com>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com>  <1405956271-34339-3-git-send-email-Waiman.Long@hp.com> <1405962929.11927.19.camel@buesod1.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405962929.11927.19.camel-5JQ4ckphU/8SZAcGdq5asR6epYMZPwEe5NbjCUgZEJk@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>, Scott J Norton <scott.norton-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 07/21/2014 01:15 PM, Davidlohr Bueso wrote:
> On Mon, 2014-07-21 at 11:24 -0400, Waiman Long wrote:
>> This patch adds code to do optimistic spinning for the FUTEX_SPIN_LOCK
>> primitive on the futex value when the lock owner is running. It is
>> the same optimistic spinning technique that is done in the mutex and
>> rw semaphore code to improve their performance especially on large
>> systems with large number of CPUs. When the lock owner is not running,
>> the spinning tasks will go to sleep.
>>
>> There is 2 major advantages of doing optimistic spinning here:
>>   1) It eliminates the context switching latency and overhead (at
>>      least a few us) associated with sleeping and wakeup.
>>   2) It eliminates most of the need to call futex(2) with
>>      FUTEX_SPIN_UNLOCK as spinning is done without the need to set
>>      the FUTEX_WAITERS bit.
> I think this belongs with Patch 1: optimistic spinning feature should be
> in the same patch when you add the new futex commands.

I broke the spinning code out in patch 2 in order to make patch 1 
smaller and easier to review.

>> Active spinning, however, does consume time in the current quantum of
>> time slice, make it a bit more likely to be preempted while running
>> in the critcal section due to time slice expiration. The heavy spinlock
>> contention of a wait-wake futex has the same effect. So it is not
>> specific
>> to this new primitive.
>>
>> With the addition of optimistic spinning, it can significantly speed
>> up the amount of mutex operations that can be done in a certain unit
>> of time. With a userspace mutex microbenchmark running 10 million
>> mutex operations with 256 threads on a 4-socket 40-core server, the
>> spinning futex can achieve a rate of about 4.9 Mops/s with a critical
>> section load of 10 pause instructions. Whereas the wait-wake futex can
>> only achieve a rate of 3.7 Mops/s. When increasing the load to 100,
>> the corresponding rates become 2.8 Mops/s and 0.8 Mops/s respectively.
>>
>> Signed-off-by: Waiman Long<Waiman.Long-VXdhtT5mjnY@public.gmane.org>
>> ---
>>   kernel/futex.c |  190 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
>>   1 files changed, 172 insertions(+), 18 deletions(-)
>>
>> diff --git a/kernel/futex.c b/kernel/futex.c
>> index ec9b6ee..ddc24d1 100644
>> --- a/kernel/futex.c
>> +++ b/kernel/futex.c
>> @@ -71,6 +71,7 @@
>>   #include<asm/futex.h>
>>
>>   #include "locking/rtmutex_common.h"
>> +#include "locking/mcs_spinlock.h"
>>
>>   /*
>>    * READ this before attempting to hack on futexes!
>> @@ -2995,30 +2996,51 @@ void exit_robust_list(struct task_struct *curr)
>>   #define FUTEX_TID(u)		(pid_t)((u)&  FUTEX_TID_MASK)
>>   #define FUTEX_HAS_WAITERS(u)	((u)&  FUTEX_WAITERS)
>>
>> +/*
>> + * Bit usage of the locker count:
>> + * bit  0-23: number of lockers (spinners + waiters)
>> + * bit 24-30: number of spinners
>> + */
>> +#define FUTEX_SPINCNT_MAX	64	/* Maximum # of spinners */
>> +#define FUTEX_SPINCNT_SHIFT	24
>> +#define FUTEX_SPINCNT_BIAS	(1U<<  FUTEX_SPINCNT_SHIFT)
>> +#define FUTEX_LOCKCNT_MASK	(FUTEX_SPINCNT_BIAS - 1)
>> +#define FUTEX_LOCKCNT(qh)	(atomic_read(&(qh)->lcnt)&  FUTEX_LOCKCNT_MASK)
>> +#define FUTEX_SPINCNT(qh)	(atomic_read(&(qh)->lcnt)>>FUTEX_SPINCNT_SHIFT)
> Both FUTEX_LOCKCNT and FUTEX_SPINCNT should be static inline functions.

I will change them into static inline functions.

>
>>   /**
>>    * struct futex_q_head - head of the optspin futex queue, one per unique key
>>    * @hnode:	list entry from the hash bucket
>>    * @waitq:	a list of waiting tasks
>>    * @key:	the key the futex is hashed on
>> + * @osq:	pointer to optimisitic spinning queue
>> + * @owner:	task_struct pointer of the futex owner
>> + * @otid:	TID of the futex owner
>>    * @wlock:	spinlock for managing wait queue
>> - * @lcnt:	locker count
>> + * @lcnt:	locker count (spinners + waiters)
>>    *
>>    * Locking sequence
>>    * ----------------
>>    * 1) Lock hash bucket spinlock, locate the futex queue head
>>    * 2) Inc lcnt (lock) or read lcnt (unlock), release hash bucket spinlock
>> - * 3) For waiter:
>> + * 3) For spinner:
>> + *    - enqueue into the spinner queue and wait for its turn.
>> + * 4) For waiter:
>>    *    - lock futex queue head spinlock
>>    *    - enqueue into the wait queue
>>    *    - release the lock&  sleep
>> - * 4) For unlocker:
>> + * 5) For unlocker:
>>    *    - locate the queue head just like a locker does
>> - *    - Take the queue head lock and wake up the first waiter there.
>> + *    - clear the owner field if it is the current owner
>> + *    - if the locker count is not 0&  osq is empty, take the queue head lock
>> + *      and wake up the first waiter.
>>    */
>>   struct futex_q_head {
>>   	struct list_head	      hnode;
>>   	struct list_head	      waitq;
>>   	union futex_key		      key;
>> +	struct optimistic_spin_queue *osq;
>> +	struct task_struct	     *owner;
>>   	pid_t			      otid;
>>   	spinlock_t		      wlock;
>>   	atomic_t		      lcnt;
>> @@ -3034,6 +3056,13 @@ struct futex_q_node {
>>   	struct task_struct     *task;
>>   };
>>
>> +/*
>> + * The maximum number of tasks that can be a futex spin queue
>> + *
>> + * It is set to the lesser of half of the total number of CPUs and
>> + * FUTEX_SPINCNT_MAX to avoid locking up all the CPUs in spinning.
>> + */
>> +static int __read_mostly futex_spincnt_max;
>>
>>   /*
>>    * find_qhead - Find a queue head structure with the matching key
>> @@ -3061,7 +3090,7 @@ find_qhead(struct futex_hash_bucket *hb, union futex_key *key)
>>    * contention with no hash bucket collision.
>>    */
>>   static inline struct futex_q_head *
>> -qhead_alloc_init(struct futex_hash_bucket *hb, union futex_key *key)
>> +qhead_alloc_init(struct futex_hash_bucket *hb, union futex_key *key, u32 uval)
>>   {
>>   	struct futex_q_head *qh = NULL;
>>   	static const struct futex_q_head qh0 = { { 0 } };
>> @@ -3073,10 +3102,16 @@ qhead_alloc_init(struct futex_hash_bucket *hb, union futex_key *key)
>>
>>   	/*
>>   	 * Initialize the queue head structure
>> +	 * The lock owner field may be NULL if the task has released the lock
>> +	 * and exit.
>>   	 */
>>   	if (qh) {
>> -		*qh = qh0;
>> -		qh->key = *key;
>> +		*qh	  = qh0;
>> +		qh->key   = *key;
>> +		qh->otid  = FUTEX_TID(uval);
>> +		qh->owner = futex_find_get_task(qh->otid);
>> +		if (unlikely(!qh->owner))
>> +			qh->otid = 0;
>>   		atomic_set(&qh->lcnt, 1);
>>   		INIT_LIST_HEAD(&qh->waitq);
>>   		spin_lock_init(&qh->wlock);
> All this can be a single qh setup function.

This code is already in a separate allocation and initialization 
function. I don't see a big advantage in further breaking them up into 2 
unless there are cases where each can be called independently without 
the other.

>> @@ -3120,9 +3155,11 @@ qhead_free(struct futex_q_head *qh, struct futex_hash_bucket *hb)
>>   	/*
>>   	 * Free the queue head structure
>>   	 */
>> -	BUG_ON(!list_empty(&qh->waitq));
>> +	BUG_ON(!list_empty(&qh->waitq) || qh->osq);
>>   	list_del(&qh->hnode);
>>   	spin_unlock(&hb->lock);
>> +	if (qh->owner)
>> +		put_task_struct(qh->owner);
>>
>>   	if (!hb->qhcache&&  (cmpxchg(&hb->qhcache, NULL, qh) == NULL))
>>   		return;
>> @@ -3134,14 +3171,19 @@ qhead_free(struct futex_q_head *qh, struct futex_hash_bucket *hb)
>>    * Return: 1 if successful or an error happen
>>    *	   0 otherwise
>>    *
>> + * Optimistic spinning is done without holding lock, but with page fault
>> + * explicitly disabled. So different functions need to be used to access
>> + * the userspace futex value.
>> + *
>>    * Side effect: The uval and ret will be updated.
>>    */
>>   static inline int futex_spin_trylock(u32 __user *uaddr, u32 *puval,
>> -				       int *pret, u32 vpid)
>> +				     int *pret, u32 vpid, bool spinning)
>>   {
>> -	u32	  old;
>> +	u32 old;
>>
>> -	*pret = get_futex_value_locked(puval, uaddr);
>> +	*pret = spinning ? __copy_from_user_inatomic(puval, uaddr, sizeof(u32))
>> +			 : get_futex_value_locked(puval, uaddr);
>>   	if (*pret)
>>   		return 1;
>>
>> @@ -3150,18 +3192,102 @@ static inline int futex_spin_trylock(u32 __user *uaddr, u32 *puval,
>>
>>   	old = *puval;
>>
>> -	*pret = cmpxchg_futex_value_locked(puval, uaddr, old, vpid | old);
>> +	*pret = spinning
>> +	      ? futex_atomic_cmpxchg_inatomic(puval, uaddr, old, vpid)
>> +	      : cmpxchg_futex_value_locked(puval, uaddr, old, vpid | old);
>> +
>>   	if (*pret)
>>   		return 1;
>>   	if (*puval == old) {
>>   		/* Adjust uval to reflect current value */
>> -		*puval = vpid | old;
>> +		*puval = spinning ? vpid : (vpid | old);
>>   		return 1;
>>   	}
>>   	return 0;
>>   }
>>
>>   /*
>> + * futex_optspin - optimistic spinning loop
>> + * Return: 1 if lock successfully acquired
>> + *	   0 if need to fall back to waiting
>> + *
>> + * Page fault and preemption are disabled in the optimistic spinning
>> + * loop. Preemption should have been disabled before calling this function.
>> + *
>> + * The number of spinners may temporarily exceed the threshold due to
>> + * racing (the spin count check and add aren't atomic), but that shouldn't
>> + * be a big problem.
>> + */
>> +static inline int futex_optspin(struct futex_q_head *qh,
>> +				struct futex_q_node *qn,
>> +				u32 __user	    *uaddr,
>> +				u32		     vpid)
>> +{
>> +	u32 uval;
>> +	int ret, gotlock = false;
>> +	struct task_struct *owner;
>> +
>> +	/*
>> +	 * Increment the spinner count
>> +	 */
>> +	atomic_add(FUTEX_SPINCNT_BIAS,&qh->lcnt);
>> +	if (!osq_lock(&qh->osq)) {
>> +		atomic_sub(FUTEX_SPINCNT_BIAS,&qh->lcnt);
>> +		return gotlock;
>> +	}
>> +	pagefault_disable();
> How about a comment to why pf is disabled.

When page fault happens, there is a chance that the task can be switched 
to a different CPU so all the OSQ magic fails to work even with 
preempt_disable(). This is a bug that caused me a day or so to figure 
out. I will add a comment to document that.

>> +	for (;; cpu_relax()) {
> while(true) {
>
>> +		if (futex_spin_trylock(uaddr,&uval,&ret, vpid, true)) {
>> +			/*
>> +			 * Fall back to waiting if an error happen
>> +			 */
>> +			if (ret)
>> +				break;
>> +			qh->otid  = vpid;
>> +			owner     = xchg(&qh->owner, qn->task);
>> +			get_task_struct(qn->task);
>> +			if (owner)
>> +				put_task_struct(owner);
>> +			gotlock = true;
>> +			break;
>> +		} else if (unlikely(FUTEX_HAS_WAITERS(uval))) {
> Branch predictions have a time and place, please do not use
> likely/unlikely just for anything.

Sure. I may have overused them.

>
>> +			/*
>> +			 * Try to turn off the waiter bit as it now has a
>> +			 * spinner. It doesn't matter if it fails as it will
>> +			 * try again in the next iteration.
>> +			 */
>> +			(void)futex_atomic_cmpxchg_inatomic
>> +			      (&uval, uaddr, uval, uval&  ~FUTEX_WAITERS);
>> +		}
>> +
>> +		if (unlikely(FUTEX_TID(uval) != qh->otid)) {
>> +			/*
>> +			 * Owner has changed
>> +			 */
>> +			qh->otid = FUTEX_TID(uval);
>> +			owner = xchg(&qh->owner, futex_find_get_task(qh->otid));
>> +			if (owner)
>> +				put_task_struct(owner);
>> +		}
>> +		owner = ACCESS_ONCE(qh->owner);
>> +		if ((owner&&  !ACCESS_ONCE(owner->on_cpu)) || need_resched())
>> +			break;
>> +	}
>> +	pagefault_enable();
>> +	osq_unlock(&qh->osq);
>> +	atomic_sub(FUTEX_SPINCNT_BIAS,&qh->lcnt);
>> +
>> +	/*
>> +	 * If we fell out of the spin path because of need_resched(),
>> +	 * reschedule now.
>> +	 */
>> +	if (!gotlock&&  need_resched())
>> +		schedule_preempt_disabled();
>> +
>> +	return gotlock;
>> +}
>> +
>> +/*
>>    * futex_spin_lock
>>    */
>>   static noinline int futex_spin_lock(u32 __user *uaddr, unsigned int flags)
>> @@ -3170,6 +3296,7 @@ static noinline int futex_spin_lock(u32 __user *uaddr, unsigned int flags)
>>   	struct futex_q_head	 *qh = NULL;
>>   	struct futex_q_node	  qnode;
>>   	union futex_key		  key;
>> +	struct task_struct	 *owner;
>>   	bool			  gotlock;
>>   	int			  ret, cnt;
>>   	u32			  uval, vpid, old;
>> @@ -3193,7 +3320,7 @@ static noinline int futex_spin_lock(u32 __user *uaddr, unsigned int flags)
>>   	 * Check the futex value under the hash bucket lock as it might
>>   	 * be changed.
>>   	 */
>> -	if (futex_spin_trylock(uaddr,&uval,&ret, vpid))
>> +	if (futex_spin_trylock(uaddr,&uval,&ret, vpid, false))
>>   		goto hbunlock_out;
>>
>>   	if (!qh) {
>> @@ -3201,7 +3328,7 @@ static noinline int futex_spin_lock(u32 __user *uaddr, unsigned int flags)
>>   		 * First waiter:
>>   		 * Allocate a queue head structure&  initialize it
>>   		 */
>> -		qh = qhead_alloc_init(hb,&key);
>> +		qh = qhead_alloc_init(hb,&key, uval);
>>   		if (unlikely(!qh)) {
>>   			ret = -ENOMEM;
>>   			goto hbunlock_out;
>> @@ -3212,9 +3339,18 @@ static noinline int futex_spin_lock(u32 __user *uaddr, unsigned int flags)
>>   	spin_unlock(&hb->lock);
>>
>>   	/*
>> -	 * Put the task into the wait queue and sleep
>> +	 * Perform optimisitic spinning if the owner is running.
>>   	 */
>>   	preempt_disable();
>> +	owner = ACCESS_ONCE(qh->owner);
>> +	if ((FUTEX_SPINCNT(qh)<  futex_spincnt_max)&&
>> +	    (!owner || owner->on_cpu))
>> +		if (futex_optspin(qh,&qnode, uaddr, vpid))
>> +			goto penable_out;
>> +
>> +	/*
>> +	 * Put the task into the wait queue and sleep
>> +	 */
>>   	get_task_struct(qnode.task);
>>   	spin_lock(&qh->wlock);
>>   	list_add_tail(&qnode.wnode,&qh->waitq);
>> @@ -3238,6 +3374,11 @@ static noinline int futex_spin_lock(u32 __user *uaddr, unsigned int flags)
>>   					goto dequeue;
>>   				} else if (uval == old) {
>>   					gotlock = true;
>> +					qh->otid = vpid;
>> +					owner = xchg(&qh->owner, qnode.task);
>> +					get_task_struct(qnode.task);
>> +					if (owner)
>> +						put_task_struct(owner);
>>   					goto dequeue;
>>   				}
>>   				continue;
>> @@ -3286,15 +3427,17 @@ dequeue:
>>   		}
>>   	}
>>   	spin_unlock(&qh->wlock);
>> +
>> +penable_out:
>>   	preempt_enable();
>>
>>   	cnt = atomic_dec_return(&qh->lcnt);
>>   	if (cnt == 0)
>>   		qhead_free(qh, hb);
>>   	/*
>> -	 * Need to set the waiters bit there are still waiters
>> +	 * Need to set the waiters bit there no spinner running
>>   	 */
>> -	else if (!ret)
>> +	else if (!ret&&  ((cnt>>  FUTEX_SPINCNT_SHIFT) == 0))
>>   		ret = put_user(vpid | FUTEX_WAITERS, uaddr);
>>   out:
>>   	put_futex_key(&key);
>> @@ -3356,6 +3499,13 @@ static noinline int futex_spin_unlock(u32 __user *uaddr, unsigned int flags)
>>   	}
>>
>>   	/*
>> +	 * Clear the owner field
>> +	 */
>> +	if ((qh->owner == current)&&
>> +	    (cmpxchg(&qh->owner, current, NULL) == current))
>> +		put_task_struct(current);
>> +
>> +	/*
>>   	 * The hash bucket lock is being hold while retrieving the task
>>   	 * structure from the queue head to make sure that the qh structure
>>   	 * won't go away under the hood.
>> @@ -3520,6 +3670,10 @@ static int __init futex_init(void)
>>
>>   	futex_detect_cmpxchg();
>>
>> +	futex_spincnt_max = num_possible_cpus()/2;
>> +	if (futex_spincnt_max>  FUTEX_SPINCNT_MAX)
>> +		futex_spincnt_max = FUTEX_SPINCNT_MAX;
> This threshold needs commenting as well.
>

There is comment up where FUTEX_SPINCNT_MAX is defined. Will add a 
comment here as well.

-Longman
