From: Waiman Long <waiman.long@hp.com>
Subject: Re: [PATCH 4/7] locking/rwsem: threshold limited spinning for active
 readers
Date: Tue, 05 Aug 2014 14:14:59 -0400
Message-ID: <53E11F23.7060405@hp.com>
References: <1407119782-41119-1-git-send-email-Waiman.Long@hp.com>  <1407119782-41119-5-git-send-email-Waiman.Long@hp.com> <1407214461.2566.14.camel@buesod1.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1407214461.2566.14.camel@buesod1.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>
List-Id: linux-api@vger.kernel.org

On 08/05/2014 12:54 AM, Davidlohr Bueso wrote:
> On Sun, 2014-08-03 at 22:36 -0400, Waiman Long wrote:
>> Even thought only the writers can perform optimistic spinning, there
>> is still a chance that readers may take the lock before a spinning
>> writer can get it. In that case, the owner field will be NULL and the
>> spinning writer can spin indefinitely until its time quantum expires
>> when some lock owning readers are not running.
> Right, now I understand where you were coming from in patch 3/7 ;)
>
>> This patch tries to handle this special case by:
>>   1) setting the owner field to a special value RWSEM_READ_OWNED
>>      to indicate that the current or last owner is a reader.
>>   2) seting a threshold on how many times (currently 100) spinning will
>       ^^setting
>>      be done with active readers before giving up as there is no easy
>>      way to determine if all of them are currently running.
>>
>> By doing so, it tries to strike a balance between giving up too early
>> and losing potential performance gain and wasting too many precious
>> CPU cycles when some lock owning readers are not running.
> That's exactly why these kind of magic things aren't a good thing, much
> less in locking. And other alternatives are much more involved, creating
> more overhead, which can make the whole thing pretty much useless.
>
> Nor does the amount of times trying to spin strike me as the correct
> metric to determine such things. Instead something y cycles or time
> based.

I can make it to be time-based. Still we need some kind of magic number 
of ns of spinning before we give up. Also, it will make the code more 
complicated. Now I am thinking about reduce the threshold to a small 
number, say 16, in addition to whether the sem count is changing to 
decide when to give up. Hopefully, that will reduce the number of 
useless spinning when the readers are running.

> [...]
>>   #ifdef CONFIG_RWSEM_SPIN_ON_OWNER
>> +/*
>> + * The owner field is set to RWSEM_READ_OWNED if the last owner(s) are
>> + * readers. It is not reset until a writer takes over and set it to its
>> + * task structure pointer or NULL when it frees the lock. So a value
>> + * of RWSEM_READ_OWNED doesn't mean it currently has active readers.
>> + */
>> +#define RWSEM_READ_OWNED	((struct task_struct *)-1)
> Looks rather weird...

Overloading pointers with some kind of special value is a technique that 
is also used elsewhere in the kernel.

>
>>   #define __RWSEM_OPT_INIT(lockname) , .osq = OSQ_LOCK_UNLOCKED, .owner = NULL
>>   #else
>>   #define __RWSEM_OPT_INIT(lockname)
>> diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
>> index 9f71a67..576d4cd 100644
>> --- a/kernel/locking/rwsem-xadd.c
>> +++ b/kernel/locking/rwsem-xadd.c
>> @@ -304,6 +304,11 @@ static inline bool rwsem_try_write_lock(long count, struct rw_semaphore *sem)
>>
>>   #ifdef CONFIG_RWSEM_SPIN_ON_OWNER
>>   /*
>> + * Threshold for optimistic spinning on readers
>> + */
>> +#define RWSEM_READ_SPIN_THRESHOLD	100
> I dislike this for the same reasons they weren't welcomed in spinlocks.
> We don't know how it can impact workloads that have not been tested.

Well, this kind of fixed threshold spinning is actually used in the 
para-virtualized spinlock. Please see the SPIN_THRESHOLD macro in 
arch/x86/include/asm/spinlock.h for more details.

> [...]
>>   static bool rwsem_optimistic_spin(struct rw_semaphore *sem)
>>   {
>>   	struct task_struct *owner;
>>   	bool taken = false;
>> +	int  read_spincnt = 0;
>>
>>   	preempt_disable();
>>
>> @@ -397,8 +409,12 @@ static bool rwsem_optimistic_spin(struct rw_semaphore *sem)
>>
>>   	while (true) {
>>   		owner = ACCESS_ONCE(sem->owner);
>> -		if (owner&&  !rwsem_spin_on_owner(sem, owner))
>> +		if (owner == RWSEM_READ_OWNED) {
>> +			if (++read_spincnt>  RWSEM_READ_SPIN_THRESHOLD)
>> +				break;
> This is still a pretty fast-path and is going to affect writers, so we
> really want to keep it un-clobbered.
>
> Thanks,
> Davidlohr
>

When the lock is writer-owned, the only overhead is an additional check 
for (owner == RWSEM_READ_OWNED) which should be negligible compared to 
reading the contended semaphore cacheline. I don't think that it will 
have any performance impact in this case.

-Longman
