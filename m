From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: Re: [PATCH RESEND v4] sched/fair: Add advisory flag for borrowing
 a timeslice
Date: Tue, 23 Dec 2014 13:47:19 -0700
Message-ID: <5499D4D7.90109@oracle.com>
References: <1418928259-6311-1-git-send-email-khalid.aziz@oracle.com> <20141218222846.GH30905@twins.programming.kicks-ass.net> <54935842.5020507@oracle.com> <alpine.DEB.2.11.1412182355020.17382@nanos> <54936562.5070502@oracle.com> <alpine.DEB.2.11.1412190045590.17382@nanos> <54949BF0.8030403@oracle.com> <alpine.DEB.2.11.1412200041220.17382@nanos> <5498498B.90703@oracle.com> <20141223105251.GB22203@gmail.com> <5499867C.1010201@oracle.com> <5499B8A2.4080008@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <5499B8A2.4080008@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, corbet@lwn.net, mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org, rientjes@google.com, ak@linux.intel.com, mgorman@suse.de, raistlin@linux.it, kirill.shutemov@linux.intel.com, atomlin@redhat.com, avagin@openvz.org, gorcunov@openvz.org, serge.hallyn@canonical.com, athorlton@sgi.com, oleg@redhat.com, vdavydov@parallels.com, daeseok.youn@gmail.com, keescook@chromium.org, yangds.fnst@cn.fujitsu.com, sbauer@eng.utah.edu, vishnu.ps@samsung.com, axboe@fb.com, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 12/23/2014 11:46 AM, Rik van Riel wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 12/23/2014 10:13 AM, Khalid Aziz wrote:
>> On 12/23/2014 03:52 AM, Ingo Molnar wrote:
>>>
>>>
>>> to implement what Thomas suggested in the discussion: a proper
>>> futex like spin mechanism? That looks like a totally acceptable
>>> solution to me, without the disadvantages of your proposed
>>> solution.
>>
>> Hi Ingo,
>>
>> Thank you for taking the time to respond. It is indeed possible to
>> implement a futex like spin mechanism. Futex like mechanism will
>> be clean and elegant. That is where I had started when I was given
>> this problem to solve. Trouble I run into is the primary
>> application I am looking at to help with this solution is Database
>> which implements its own locking mechanism without using POSIX
>> semaphore or futex. Since the locking is entirely in userspace,
>> kernel has no clue when the userspace has acquired one of these
>> locks. So I can see only two ways to solve this - find a solution
>> in userspace entirely, or have userspace tell the kernel when it
>> acquires one of these locks. I will spend more time on finding a
>> way to solve it in userspace and see if I can find a way to
>> leverage futex mechanism without causing significant change to
>> database code. There may be a way to use priority inheritance to
>> avoid contention. Database performance people tell me that their
>> testing has shown the cost of making any system calls in this code
>> easily offsets any gains from optimizing for contention avoidance,
>> so that is one big challenge. Database rewriting their locking code
>> is extremely unlikely scenario. Am I missing a third option here?
>
> An uncontended futex is taken without ever going into kernel
> space. Adaptive spinning allows short duration futexes to be
> taken without going into kernel space.

You are right. Uncontended futex is very fast since it never goes into 
kernel. Queuing problem happens when the lock holder has been 
pre-empted. Adaptive spinning does the smart thing os spin-waiting only 
if the lock holder is still running on another core. If lock holder is 
not scheduled on any core, even adaptive spinning has to go into the 
kernel to be put on wait queue. What would avoid queuing problem and 
reduce the cost of contention is a combination of adaptive spinning, and 
a way to keep the lock holder running on one of the cores just a little 
longer so it can release the lock. Without creating special case and a 
new API in kernel, one way I can think of accomplishing the second part 
is to boost the priority of lock holder when contention happens and 
priority ceiling is meant to do exactly that. Priority ceiling 
implementation in glibc boosts the priority by calling into scheduler 
which does incur the cost of a system call. Priority boost is a reliable 
solution that does not change scheduling semantics. The solution 
allowing lock holder to use one extra timeslice is not a definitive 
solution but tpcc workload shows it does work and it works without 
requiring changes to database locking code.

Theoretically a new locking library that uses both these techniques will 
help solve the problem but being a new locking library, there is a big 
unknown of what new problems, performance and otherwise, it will bring 
and database has to recode to this new library. Nevertheless this is the 
path I am exploring now. The challenge being how to do this without 
requiring changes to database code or the kernel. The hooks available to 
me into current database code are schedctl_init(), schedctl_start() and 
schedctl_stop() which are no-op on Linux at this time. Database folks 
can replace these no-ops with real code in their library to solve the 
queuing problem. schedctl_start() and schedctl_stop() are called only 
when one of the highly contended locks is acquired or released. 
schedctl_start() is called after the lock has been acquired which means 
I can not rely upon it to solve contention issue. schedctl_stop() is 
called after the lock has been released.

Thanks,
Khalid

>
> Only long held locks cause a thread to go into kernel space,
> where it goes to sleep, freeing up the cpu, and increasing
> the chance that the lock holder will run.
>
> - --
> All rights reversed
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1
>
> iQEcBAEBAgAGBQJUmbihAAoJEM553pKExN6DDlQH/1vvy9YYuP2dCAZSU3fz855e
> pj4796Qja929I2dStsbLl6Qhcg2ELtwtPkLoAePQ/4j2l7DCYgSNLXlC+RzQ32ay
> rbMIfwiriEVGp2hsvYTOCpnur19IHf7v726ivaDXVOM/nrRaHsB8wwspLQQyfSIE
> b7M7jxvT4S2pEELOGB6JQfEZZhbf5wBv9HBk+fkCBMaO4WZrnYczyD0/omiADm65
> xSm/8pCMK22u8Tzn9EpKpIVdIFrl9AlZ1uiRBV2Br1oqwaBTvJVknW4bvIk0DWZU
> ErwR/073UYKpl+xce3nbnixH8FeRP7/mq73Xd8e+iCgn6Dtzr1tANsu27EigMZ0=
> =WHb3
> -----END PGP SIGNATURE-----
>

