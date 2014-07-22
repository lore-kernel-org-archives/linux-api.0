From: Waiman Long <waiman.long@hp.com>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
Date: Tue, 22 Jul 2014 14:28:17 -0400
Message-ID: <53CEAD41.9030307@hp.com>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com> <8761iq3bp3.fsf@tassilo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8761iq3bp3.fsf@tassilo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@linux.intel.com>, Davidlohr Bueso <davidlohr@hp.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>
List-Id: linux-api@vger.kernel.org

On 07/21/2014 12:42 PM, Andi Kleen wrote:
> Waiman Long<Waiman.Long@hp.com>  writes:
>
>> This patch series introduces two new futex command codes to support
>> a new optimistic spinning futex for implementing an exclusive lock
>> primitive that should perform better than the same primitive using
>> the wait-wake futex in cases where the lock owner is actively working
>> instead of waiting for I/O completion.
> How would you distinguish those two cases automatically?

I don't really distinguish between these two. The purpose of this 
paragraph is to show the best use cases for the spinning futexes is when 
the lock owner is not likely to sleep while in the critical section.

>> This patch series improves futex performance on two different fronts:
>>   1) Reducing the amount of the futex spinlock contention by using 2
>>      different spinlocks instead of just one for the wait-wake futex.
>>   2) Eliminating the context switching overhead and latency due to the
>>      sleeping and the waking of the waiting tasks.
> FWIW the main problem is currently that switch-through-idle is so
> slow. I think improving that would give a boost to far more
> situations.

If we can improve the context switching overhead, that can certainly 
help a lot of applications.

>
>> Patch 4 changes sleeping queue from a simple FIFO list to an rbtree
>> sorted by process priority as well as the sequeunce the tasks enter
>> the kernel.
> This seems to mix new functionality with performance improvements?
>
> Generally adding new ordering in an user interface is risky because
> often user programs have been tuned for specific old ordering.

Not really, this patch is to emulate the current behavior of the 
wait-wake futex which is queued in a priority queue. Because of 
spinning, tasks may enter into sleep state in different order than when 
they enter into the kernel. That is why I keep a sequence number to 
track who go into the kernel first.

-Longman
