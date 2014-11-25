From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: Re: [PATCH v3] sched/fair: Add advisory flag for borrowing a timeslice
Date: Tue, 25 Nov 2014 07:45:43 -0700
Message-ID: <54749617.5030309@oracle.com>
References: <1416862595-24513-1-git-send-email-khalid.aziz@oracle.com> <alpine.DEB.2.11.1411242317380.6439@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.11.1411242317380.6439@nanos>
Sender: linux-doc-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: corbet@lwn.net, mingo@redhat.com, hpa@zytor.com, peterz@infradead.org, riel@redhat.com, akpm@linux-foundation.org, rientjes@google.com, ak@linux.intel.com, mgorman@suse.de, liwanp@linux.vnet.ibm.com, raistlin@linux.it, kirill.shutemov@linux.intel.com, atomlin@redhat.com, avagin@openvz.org, gorcunov@openvz.org, serge.hallyn@canonical.com, athorlton@sgi.com, oleg@redhat.com, vdavydov@parallels.com, daeseok.youn@gmail.com, keescook@chromium.org, yangds.fnst@cn.fujitsu.com, sbauer@eng.utah.edu, vishnu.ps@samsung.com, axboe@fb.com, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Thanks for the review. I appreciate your comments. Please see my 
response inline.

On 11/24/2014 04:35 PM, Thomas Gleixner wrote:
> On Mon, 24 Nov 2014, Khalid Aziz wrote:
>> sched/fair: Add advisory flag for borrowing a timeslice
>>
>> This patch adds a way for a task to request to borrow one timeslice
>> from future if it is about to be preempted, so it could delay
>> preemption and complete any critical task it is in the middle of.
>>
>> This feature helps with performance on databases and has been
>> used for many years on other OSs by the databases. This feature
>> helps in situation where a task acquires a lock before performing a
>> critical operation on the database and happens to get preempted before
>> it completes its task.  This lock being held causes all other tasks
>> that also acquire the same lock to perform their critical operation
>> on the database, to start queueing up and causing large number of
>> context switches.  This queueing problem can be avoided if the task
>> that acquires lock first could request scheduler to let it borrow one
>> timeslice once it enters its critical section and hence allow it to
>> complete its critical section without causing queueing problem. If
>
> While you are niftily avoiding to talk about the nature of the lock, I
> can take it for granted that you are talking about user space
> spinlocks, right?

Sorry, it was certainly not my intention to avoid talking about the 
nature of the locks. I could have done a better job of explaining the 
locks in use. Yes, these are userspace spinlocks implemented in database 
library used by the database.

>
> Simply if you would talk about futexes and pthread_mutexes then it
> would have occured to you while implementing that feature, that the
> kernel already has a mechanism to record a reference to a user space
> data structure (robust_list_head) which is updated when a futex is
> acquired in user space, i.e. when a critical section is entered. It's
> not the same as you need, but it would be relatively simple to convey
> that information there.
>
> So what are the actual lock types and use cases and why can't you
> combine that with the existing robust list mechanism?

When I was asked to solve this queueing problem, I started working on a 
solution built around futexes and then I found out futex based solution 
is a no-go. Two primary users of this feature are database and Java. 
Neither uses POSIX locks or futex I am told by the folks that maintain 
these two. Hence a solution that allows them to ask for amnesty from 
preemption for just one more timeslice by letting them borrow a 
timeslice from future IF they are going to be preempted BEFORE their 
critical section is done. Userspace app is expected to yield the 
processor as soon as it is done with critical section which means the 
app may never use the extra timeslice it had asked for.

This solution has been used by both database and java on other OSs and 
has shown performance improvement. Andrew had asked for performance 
numbers on Linux with this patch last time I sent this out and it took 
me a while to get performance folks to run a full TPC-C workload. They 
did see a 3% improvement in tpcc as I noted in commit log and that is a 
significant improvement.

>
>> critical section completes before the task is due for preemption,
>> the task can simply desassert its request. A task sends the
>
> And that deassertion has which consequences before the next preempt
> check happens?
>
>> +config SCHED_PREEMPT_DELAY
>> +	def_bool n
>> +	prompt "Scheduler preemption delay support"
>> +	depends on PROC_FS
>
> Why so?

I assume you are asking about "depends on PROC_FS"? This patch uses proc 
to publish statistics but it really is publishing through existing proc 
file, so this is a weak dependency at best. I will remove this.

>
>> @@ -1324,6 +1325,13 @@ struct task_struct {
>>   	/* Revert to default priority/policy when forking */
>>   	unsigned sched_reset_on_fork:1;
>>   	unsigned sched_contributes_to_load:1;
>> +#ifdef CONFIG_SCHED_PREEMPT_DELAY
>> +	struct preempt_delay {
>> +		u32 __user *delay_req;		/* delay request flag pointer */
>> +		unsigned char delay_granted;	/* currently in delay */
>> +		unsigned char yield_penalty;	/* failure to yield penalty */
>> +	} sched_preempt_delay;
>
> No. First of all this wants to be a proper struct declaration outside
> of task_struct.
>
> Aside of that your user space side is actually a structure and not a
> opaque u32 pointer, so this should be an explicit data type and not
> something randomly defined in the guts of task_struct.

That is a good point. I will fix it.

>
>> +#if defined(CONFIG_SCHED_PREEMPT_DELAY) && defined(CONFIG_PROC_FS)
>> +extern void sched_preempt_delay_show(struct seq_file *m,
>> +					struct task_struct *task);
>> +extern void sched_preempt_delay_set(struct task_struct *task,
>> +					unsigned char *val);
>> +#endif
>
> Can you please get rid of the leftovers of your previous patches
> yourself and before posting? It's annoying as hell to review patches
> which contain stale code.

Sorry, my screw up. I missed that one when reviewing my own patch.

>
>> diff --git a/kernel/fork.c b/kernel/fork.c
>> index 9b7d746..7f0d843 100644
>> --- a/kernel/fork.c
>> +++ b/kernel/fork.c
>> @@ -1671,6 +1671,11 @@ long do_fork(unsigned long clone_flags,
>>   			init_completion(&vfork);
>>   			get_task_struct(p);
>>   		}
>> +#ifdef CONFIG_SCHED_PREEMPT_DELAY
>> +		p->sched_preempt_delay.delay_req = NULL;
>> +		p->sched_preempt_delay.delay_granted = 0;
>> +		p->sched_preempt_delay.yield_penalty = 0;
>> +#endif
>
> Sigh. We do not sprinkle that kind of #ifdef crap all over the
> place. That's what inline functions in header files are for.

Sure. I will change that.

>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 240157c..38cb515 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -4230,6 +4230,14 @@ SYSCALL_DEFINE0(sched_yield)
>>   {
>>   	struct rq *rq = this_rq_lock();
>>
>> +#ifdef CONFIG_SCHED_PREEMPT_DELAY
>> +	/*
>> +	 * Clear the penalty flag for current task to reward it for
>> +	 * palying by the rules
>
> Looking at that mess makes me palying^Wpale.

:) will clean it up.

>
>> +	 */
>> +	current->sched_preempt_delay.yield_penalty = 0;
>> +#endif
>> +
>>   	schedstat_inc(rq, yld_count);
>>   	current->sched_class->yield_task(rq);
>
>> +#ifdef CONFIG_SCHED_PREEMPT_DELAY
>> +/*
>> + * delay_resched_rq(): Check if the task about to be preempted has
>> + *	requested an additional time slice. If it has, grant it additional
>> + *	timeslice once.
>> + */
>> +static void
>> +delay_resched_rq(struct rq *rq)
>> +{
>> +	struct task_struct *curr = rq->curr;
>> +	struct sched_entity *se;
>> +	int cpu = task_cpu(curr);
>> +	u32 __user *delay_req;
>> +	unsigned int delay_req_flag;
>> +	unsigned char *delay_flag;
>> +
>> +	/*
>> +	 * Check if task is using pre-emption delay feature. If address
>> +	 * for preemption delay request flag is not set, this task is
>> +	 * not using preemption delay feature, we can reschedule without
>> +	 * any delay
>
> So what happens if:
>
>     kernel.preempt_delay_available = 1;
>
>     prctl(PR_SET_PREEMPT_DELAY, ...);
>
>     kernel.preempt_delay_available = 0;
>
> Nothing happens at all because you fail to give the sysop control over
> the feature once you unleashed it.
>
> The proper solution for this is to use a static key to control the
> feature itself. That also reduces the overhead for those who are not
> interested in that.

I was trying to reduce adding one more check to scheduler path and that 
opened up a hole as you pointed out. Good catch! I will add the 
conditional to scheduler path to plug this hole.

>
>> +	 */
>> +	delay_req = curr->sched_preempt_delay.delay_req;
>> +
>> +	if ((delay_req == NULL) || (cpu != smp_processor_id()))
>
> check_preempt_tick() clearly does not care about that, but you inflict
> a smp_processor_id() on every caller. I can see that you really care
> about performance.

:) I do care about performance. I will remove that check.

>
>> +		goto resched_now;
>> +
>> +	/*
>> +	 * Pre-emption delay will  be granted only once. If this task
>> +	 * has already been granted delay, rechedule now
>> +	 */
>> +	if (curr->sched_preempt_delay.delay_granted) {
>> +		curr->sched_preempt_delay.delay_granted = 0;
>> +		goto resched_now;
>> +	}
>> +	/*
>> +	 * Get the value of preemption delay request flag from userspace.
>> +	 * Task had already passed us the address where the flag is stored
>> +	 * in userspace earlier. This flag is just like the PROCESS_PRIVATE
>> +	 * futex, leverage the futex code here to read the flag. If there
>> +	 * is a page fault accessing this flag in userspace, that means
>> +	 * userspace has not touched this flag recently and we can
>> +	 * assume no preemption delay is needed.
>> +	 *
>> +	 * If task is not requesting additional timeslice, resched now
>> +	 */
>> +	if (delay_req) {
>
> Surely we need to recheck delay_req here.
>

Agreed, this is superfluous. I will clean it up.

>> +		int ret;
>> +
>> +		pagefault_disable();
>> +		ret = __copy_from_user_inatomic(&delay_req_flag, delay_req,
>> +				sizeof(u32));
>> +		pagefault_enable();
>> +		delay_flag = &delay_req_flag;
>> +		if (ret || !delay_flag[0])
>
> This is really a well designed kernel/user space interface. NOT.

Please do suggest a better interface. My constraint is it has to be very 
low overhead. A system call is just too much overhead and will negate 
any benefit from this.

>
>> +			goto resched_now;
>> +	} else {
>> +		goto resched_now;
>> +	}
>> +
>> +	/*
>> +	 * Current thread has requested preemption delay and has not
>> +	 * been granted an extension yet. If this thread failed to yield
>> +	 * processor after being granted amnesty last time, penalize it
>> +	 * by not granting this delay request, otherwise give it an extra
>> +	 * timeslice.
>> +	 */
>> +	if (curr->sched_preempt_delay.yield_penalty) {
>> +		curr->sched_preempt_delay.yield_penalty = 0;
>> +		goto resched_now;
>> +	}
>> +
>> +	se = &curr->se;
>> +	curr->sched_preempt_delay.delay_granted = 1;
>> +	/*
>> +	 * Set the penalty flag for failing to yield the processor after
>> +	 * being granted immunity. This flag will be cleared in
>> +	 * sched_yield() if the thread indeed calls sched_yield
>> +	 */
>> +	curr->sched_preempt_delay.yield_penalty = 1;
>
> Why on earth do we need two flags here? Just because we can create
> more code in the guts of the scheduler hot pathes that way?
>
> And surely we want to put them into two adjacent u8 to make life
> easier for all architectures.
>

They keep track of two different things. delay_granted keeps track of 
whether a request for preemption delay was granted and is used to stop 
the task from being granted a second timeslice. yield_penalty keeps 
track of whether the task should be penalized or not. These two flags 
are cleared at two different times. delay_granted is cleared when the 
task is preempted forcibly after being granted a delay whereas 
yield_penalty is cleared when the task gives up the processor voluntarily.

>> +	/*
>> +	 * Let the thread know it got amnesty and it should call
>> +	 * sched_yield() when it is done to avoid penalty next time
>> +	 * it wants amnesty. We need to write to userspace location.
>> +	 * Since we just read from this location, chances are extremley
>> +	 * low we might page fault. If we do page fault, we will ignore
>> +	 * it and accept the cost of failed write in form of unnecessary
>> +	 * penalty for userspace task for not yielding processor.
>
> This is the completely wrong argument. We know that the task was
> asking for an extra time slice because the copy from user above
> succeeded. So we are better of to let the task actually handle its
> pagefault than scheduling it out.
>
>> +	 * This is a highly unlikely scenario.
>> +	 */
>> +	delay_flag[0] = 0;
>> +	delay_flag[1] = 1;
>
> Sigh.
>
>> +#ifdef CONFIG_SCHED_PREEMPT_DELAY
>
> And all of this needs to be in kernel/sys.c just because...

I will look for a better way to do it.

>
>> +int sysctl_preempt_delay_available;
>> +
>> +static int
>> +preempt_delay_write(struct task_struct *task, unsigned long preempt_delay_addr)
>> +{
>> +	/*
>> +	 * Do not allow write if pointer is currently set
>> +	 */
>> +	if (task->sched_preempt_delay.delay_req &&
>> +			((void *)preempt_delay_addr != NULL))
>> +		return -EINVAL;
>> +	/*
>> +	 * Validate the pointer. It should be aligned to 4-byte boundary.
>
> So 4 bytes is a perfect boundary for everyone, right? Pulled that
> number out of thin air or what?

OK. What would you suggest? I can be taught to do this better.

>
>> +	 */
>> +	if (unlikely(!IS_ALIGNED(preempt_delay_addr, 4)))
>> +		return -EFAULT;
>> +	if (unlikely(!access_ok(rw, preempt_delay_addr, sizeof(u32))))
>> +		return -EFAULT;
>> +
>> +	task->sched_preempt_delay.delay_req = (u32 __user *) preempt_delay_addr;
>> +
>> +	/* zero out flags */
>
> Brilliant comment. I can see what the code is doing. What's way more
> interesting and of course undocumented is why you are ignoring the
> return value of put_user() ..
>
>> +	put_user(0, (uint32_t *)preempt_delay_addr);
>
> Aside of the general issues I have with this (see the inline replies
> to your changelog) the overall impression of this patch is that it is
> a half baken and carelessly cobbled together extract of some data base
> specific kernel hackery, which I prefer not to see at all.
>
> Thanks,
>
> 	tglx
>

Even if it helps one of the major workloads for Linux to perform better?

Thanks! You have lot of good feedback for me and I really appreciate it.

--
Khalid

