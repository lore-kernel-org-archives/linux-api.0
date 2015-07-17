From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH] thread_local_abi system call: caching current CPU
 number (x86)
Date: Fri, 17 Jul 2015 16:23:13 +0000 (UTC)
Message-ID: <1277152121.1054.1437150193382.JavaMail.zimbra@efficios.com>
References: <1437076851-14848-1-git-send-email-mathieu.desnoyers@efficios.com> <55A8F9B2.2070008@siteground.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55A8F9B2.2070008@siteground.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nikolay Borisov <n.borisov@siteground.com>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Jul 17, 2015, at 8:48 AM, Nikolay Borisov n.borisov@siteground.com wrote:

> On 07/16/2015 11:00 PM, Mathieu Desnoyers wrote:
>> Expose a new system call allowing threads to register a userspace memory
>> area where to store the current CPU number. Scheduler migration sets the
>> TIF_NOTIFY_RESUME flag on the current thread. Upon return to user-space,
>> a notify-resume handler updates the current CPU value within that
>> user-space memory area.
>> 
>> This getcpu cache is an alternative to the sched_getcpu() vdso which has
>> a few benefits:
>> - It is faster to do a memory read that to call a vDSO,
>> - This cache value can be read from within an inline assembly, which
>>   makes it a useful building block for restartable sequences.
>> 
>> This approach is inspired by Paul Turner and Andrew Hunter's work
>> on percpu atomics, which lets the kernel handle restart of critical
>> sections:
>> Ref.:
>> * https://lkml.org/lkml/2015/6/24/665
>> * https://lwn.net/Articles/650333/
>> *
>> http://www.linuxplumbersconf.org/2013/ocw/system/presentations/1695/original/LPC%20-%20PerCpu%20Atomics.pdf
>> 
>> Benchmarking sched_getcpu() vs tls cache approach. Getting the
>> current CPU number:
>> 
>> - With Linux vdso:            12.7 ns
>> - With TLS-cached cpu number:  0.3 ns
>> 
>> The system call can be extended by registering a larger structure in
>> the future.
>> 
[...]
>> +/*
>> + * sys_thread_local_abi - setup thread-local ABI for caller thread
>> + */
>> +SYSCALL_DEFINE3(thread_local_abi, struct thread_local_abi __user *, tlap,
>> +		size_t, len, int, flags)
>> +{
>> +	size_t minlen;
>> +
>> +	if (flags)
>> +		return -EINVAL;
>> +	if (current->thread_local_abi && tlap)
>> +		return -EBUSY;
>> +	/* Agree on the intersection of userspace and kernel features */
>> +	minlen = min_t(size_t, len, sizeof(struct thread_local_abi));
>> +	current->thread_local_abi_len = minlen;
>> +	current->thread_local_abi = tlap;
>> +	if (!tlap)
>> +		return 0;
>> +	/*
>> +	 * Migration checks ->thread_local_abi to see if notify_resume
>> +	 * flag should be set. Therefore, we need to ensure that
>> +	 * the scheduler sees ->thread_local_abi before we update its content.
>> +	 */
>> +	barrier();	/* Store thread_local_abi before update content */
>> +	if (getcpu_cache_active(current)) {
> 
> Just checking whether my understanding of the code is correct, but this
> 'if' is necessary in case we have been moved to a different CPU after
> the store of the thread_local_abi?

No, this is not correct. Currently, only the getcpu_cache feature is
implemented, but if struct thread_local_abi eventually grows with more
fields, userspace could call the kernel with a "len" argument that does not
cover some of the features. Therefore, the generic way to check whether
getcpu_cache is implemented by the current thread is to call
"getcpu_cache_active()". If it is enabled, then we need to update the
getcpu_cache content for the current thread.

The barrier() above is required because we want to store thread_local_abi
(and thread_local_abi_len) before we get the current CPU number and store
it into the getcpu_cache, because we could be migrated by the scheduler
with CONFIG_PREEMPT=y at any point between the moment we read the current
CPU number within getcpu_cache_update() and resume userspace. Having
thread_local_abi and thread_local_abi_len set before fetching the current
CPU number ensures that the scheduler will succeed its own getcpu_cache_active()
check, and will therefore raise the resume notifier flag upon migration,
which will then fix the CPU number before resuming to userspace.

Thanks,

Mathieu

> 
>> +		if (getcpu_cache_update(current))
>> +			return -EFAULT;
>> +	}
>> +	return minlen;
>> +}

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
