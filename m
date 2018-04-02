From: Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [REVIEW][PATCH 11/11] ipc/sem: Fix semctl(..., GETPID, ...)
 between pid namespaces
Date: Mon, 2 Apr 2018 13:11:54 +0200
Message-ID: <334d0390-88e9-b950-b07e-ad69c0516e5b@colorfullife.com>
References: <87vadmobdw.fsf_-_@xmission.com>
 <20180323191614.32489-11-ebiederm@xmission.com>
 <20180329005209.fnzr3hzvyr4oy3wi@linux-n805>
 <20180330190951.nfcdwuzp42bl2lfy@linux-n805>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180330190951.nfcdwuzp42bl2lfy@linux-n805>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, khlebnikov@yandex-team.ru, prakash.sangappa@oracle.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, serge.hallyn@ubuntu.com, esyr@redhat.com, jannh@google.com, linux-security-module@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>
List-Id: linux-api@vger.kernel.org

Hi,

On 03/30/2018 09:09 PM, Davidlohr Bueso wrote:
> On Wed, 28 Mar 2018, Davidlohr Bueso wrote:
>
>> On Fri, 23 Mar 2018, Eric W. Biederman wrote:
>>
>>> Today the last process to update a semaphore is remembered and
>>> reported in the pid namespace of that process.  If there are processes
>>> in any other pid namespace querying that process id with GETPID the
>>> result will be unusable nonsense as it does not make any
>>> sense in your own pid namespace.
>>
>> Yeah that sounds pretty wrong.
>>
>>>
>>> Due to ipc_update_pid I don't think you will be able to get System V
>>> ipc semaphores into a troublesome cache line ping-pong.  Using struct
>>> pids from separate process are not a problem because they do not share
>>> a cache line.  Using struct pid from different threads of the same
>>> process are unlikely to be a problem as the reference count update
>>> can be avoided.
>>>
>>> Further linux futexes are a much better tool for the job of mutual
>>> exclusion between processes than System V semaphores.  So I expect
>>> programs that  are performance limited by their interprocess mutual
>>> exclusion primitive will be using futexes.
>>
The performance of sysv sem and futexes for the contended case is more 
or less identical, it depends on the CONFIG_ options what is faster.

And this is obvious, both primitives must do the same tasks:
sleep:
- lookup a kernel pointer from a user space reference
- acquire a lock, do some housekeeping, unlock and sleep
wakeup:
- lookup a kernel pointer from a user space reference
- acquire a lock, do some housekeeping, especially unlink the to be 
woken up task, unlock and wakeup

The woken up task has nothing to do, it returns immediately to user space.

IIRC for the uncontended case, sysvsem was at ~300 cpu cycles, but that 
number is a few years old, and I don't know what is the impact of spectre.
The futex code is obviously faster.
But I don't know which real-world applications do their own 
optimizations for the uncontended case before using sysvsem.

Thus the only "real" challenge is to minimize cache line trashing.

>> You would be wrong. There are plenty of real workloads out there
>> that do not use futexes and are care about performance; in the end
>> futexes are only good for the uncontended cases, it can also
>> destroy numa boxes if you consider the global hash table. Experience
>> as shown me that sysvipc sems are quite still used.
>>
>>>
>>> So while it is possible that enhancing the storage of the last
>>> rocess of a System V semaphore from an integer to a struct pid
>>> will cause a performance regression because of the effect
>>> of frequently updating the pid reference count.  I don't expect
>>> that to happen in practice.
>>
>> How's that? Now thanks to ipc_update_pid() for each semop the user
>> passes, perform_atomic_semop() will do two atomic updates for the
>> cases where there are multiple processes updating the sem. This is
>> not uncommon.
>>
>> Could you please provide some numbers.
>
[...]
> So at least for a large box this patch hurts the cases where there is low
> to medium cpu usage (no more than ~8 processes on a 40 core box) in a non
> trivial way. For more processes it doesn't matter. We can confirm that 
> the
> case for threads is irrelevant. While I'm not happy about the 30% 
> regression
> I guess we can live with this.
>
> Manfred, any thoughts?
>
Bugfixing has always first priority, and a 30% regression in one 
microbenchmark doesn't seem to be that bad.

Thus I would propose that we fix SEMPID first, and _if_ someone notices 
a noticeable regression, then we must improve the code.

--
     Manfred
