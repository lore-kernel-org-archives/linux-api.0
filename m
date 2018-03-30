From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [REVIEW][PATCH 11/11] ipc/sem: Fix semctl(..., GETPID, ...)
 between pid namespaces
Date: Fri, 30 Mar 2018 12:09:51 -0700
Message-ID: <20180330190951.nfcdwuzp42bl2lfy@linux-n805>
References: <87vadmobdw.fsf_-_@xmission.com>
 <20180323191614.32489-11-ebiederm@xmission.com>
 <20180329005209.fnzr3hzvyr4oy3wi@linux-n805>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180329005209.fnzr3hzvyr4oy3wi@linux-n805>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, manfred@colorfullife.com
Cc: Linux Containers <containers@lists.linux-foundation.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, khlebnikov@yandex-team.ru, prakash.sangappa@oracle.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, serge.hallyn@ubuntu.com, esyr@redhat.com, jannh@google.com, linux-security-module@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>
List-Id: linux-api@vger.kernel.org

On Wed, 28 Mar 2018, Davidlohr Bueso wrote:

>On Fri, 23 Mar 2018, Eric W. Biederman wrote:
>
>>Today the last process to update a semaphore is remembered and
>>reported in the pid namespace of that process.  If there are processes
>>in any other pid namespace querying that process id with GETPID the
>>result will be unusable nonsense as it does not make any
>>sense in your own pid namespace.
>
>Yeah that sounds pretty wrong.
>
>>
>>Due to ipc_update_pid I don't think you will be able to get System V
>>ipc semaphores into a troublesome cache line ping-pong.  Using struct
>>pids from separate process are not a problem because they do not share
>>a cache line.  Using struct pid from different threads of the same
>>process are unlikely to be a problem as the reference count update
>>can be avoided.
>>
>>Further linux futexes are a much better tool for the job of mutual
>>exclusion between processes than System V semaphores.  So I expect
>>programs that  are performance limited by their interprocess mutual
>>exclusion primitive will be using futexes.
>
>You would be wrong. There are plenty of real workloads out there
>that do not use futexes and are care about performance; in the end
>futexes are only good for the uncontended cases, it can also
>destroy numa boxes if you consider the global hash table. Experience
>as shown me that sysvipc sems are quite still used.
>
>>
>>So while it is possible that enhancing the storage of the last
>>rocess of a System V semaphore from an integer to a struct pid
>>will cause a performance regression because of the effect
>>of frequently updating the pid reference count.  I don't expect
>>that to happen in practice.
>
>How's that? Now thanks to ipc_update_pid() for each semop the user
>passes, perform_atomic_semop() will do two atomic updates for the
>cases where there are multiple processes updating the sem. This is
>not uncommon.
>
>Could you please provide some numbers.

I ran this on a 40-core (no ht) Westmere with two benchmarks. The first
is Manfred's sysvsem lockunlock[1] program which uses _processes_ to,
well, lock and unlock the semaphore. The options are a little
unconventional, to keep the "critical region small" and the lock+unlock
frequency high I added busy_in=busy_out=10. Similarly, to get the
worst case scenario and have everyone update the same semaphore, a single
one is used. Here are the results (pretty low stddev from run to run)
for doing 100,000 lock+unlock.

- 1 proc:
   * vanilla
	total execution time: 0.110638 seconds for 100000 loops
   * dirty
	total execution time: 0.120144 seconds for 100000 loops

- 2 proc:
   * vanilla
	total execution time: 0.379756 seconds for 100000 loops
   * dirty
	total execution time: 0.477778 seconds for 100000 loops

- 4 proc:
   * vanilla
	total execution time: 6.749710 seconds for 100000 loops
   * dirty
	total execution time: 4.651872 seconds for 100000 loops

- 8 proc:
   * vanilla
        total execution time: 5.558404 seconds for 100000 loops
   * dirty
	total execution time: 7.143329 seconds for 100000 loops

- 16 proc:
   * vanilla
	total execution time: 9.016398 seconds for 100000 loops
   * dirty
	total execution time: 9.412055 seconds for 100000 loops

- 32 proc:
   * vanilla
	total execution time: 9.694451 seconds for 100000 loops
   * dirty
	total execution time: 9.990451 seconds for 100000 loops

- 64 proc:
   * vanilla
	total execution time: 9.844984 seconds for 100032 loops
   * dirty
	total execution time: 10.016464 seconds for 100032 loops

Lower task counts show pretty massive performance hits of ~9%, ~25%
and ~30% for single, two and four/eight processes. As more are added
I guess the overhead tends to disappear as for one you have a lot
more locking contention going on.


The second workload I ran this patch on was Chris Mason's sem-scalebench[2]
program which uses _threads_ for the sysvsem option (this benchmark is more
about semaphores as a concept rather than sysvsem specific). Dealing with
a single semaphore and increasing thread counts we get:

sembench-sem
                                            vanill                   dirt
                                           vanilla                  dirty
Hmean     sembench-sem-2      286272.00 (   0.00%)   288232.00 (   0.68%)
Hmean     sembench-sem-8      510966.00 (   0.00%)   494375.00 (  -3.25%)
Hmean     sembench-sem-12     435753.00 (   0.00%)   465328.00 (   6.79%)
Hmean     sembench-sem-21     448144.00 (   0.00%)   462091.00 (   3.11%)
Hmean     sembench-sem-30     479519.00 (   0.00%)   471295.00 (  -1.72%)
Hmean     sembench-sem-48     533270.00 (   0.00%)   542525.00 (   1.74%)
Hmean     sembench-sem-79     510218.00 (   0.00%)   528392.00 (   3.56%)

Unsurprisingly, the thread case shows no overhead -- and yes, even better at
times but still noise). Similarly, when completely abusing the systems and doing
64*NCPUS there is pretty much no difference:

              vanill        dirt
             vanilla       dirty
User         1865.99     1819.75
System      35080.97    35396.34
Elapsed      3602.03     3560.50

So at least for a large box this patch hurts the cases where there is low
to medium cpu usage (no more than ~8 processes on a 40 core box) in a non
trivial way. For more processes it doesn't matter. We can confirm that the
case for threads is irrelevant. While I'm not happy about the 30% regression
I guess we can live with this.

Manfred, any thoughts?

Thanks
Davidlohr

[1] https://github.com/manfred-colorfu/ipcscale/blob/master/sem-lockunlock.c
[2] https://github.com/davidlohr/sembench-ng/blob/master/sembench.c
