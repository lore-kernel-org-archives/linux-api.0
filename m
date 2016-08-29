From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH v8 1/9] Restartable sequences system call
Date: Mon, 29 Aug 2016 15:16:52 +0000 (UTC)
Message-ID: <91715400.22162.1472483812389.JavaMail.zimbra@efficios.com>
References: <1471637274-13583-1-git-send-email-mathieu.desnoyers@efficios.com> <1471637274-13583-2-git-send-email-mathieu.desnoyers@efficios.com> <CA+55aFz+Q33m1+ju3ANaznBwYCcWo9D9WDr2=p0YLEF4gJF12g@mail.gmail.com> <545371402.19191.1472144912215.JavaMail.zimbra@efficios.com> <1BD94294-23AD-40CC-8227-43AE1AD8092F@fb.com> <20160827042226.akfaq4wku2gdpxsi@x>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160827042226.akfaq4wku2gdpxsi@x>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Triplett <josh@joshtriplett.org>
Cc: Ben Maurer <bmaurer@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Watson <davejwatson@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, rostedt <rostedt@goodmis.org>, Catalin Marinas <catalin.marinas@arm.com>, Will
List-Id: linux-api@vger.kernel.org

----- On Aug 27, 2016, at 12:22 AM, Josh Triplett josh@joshtriplett.org wrote:

> On Thu, Aug 25, 2016 at 05:56:25PM +0000, Ben Maurer wrote:
>> rseq opens up a whole world of algorithms to userspace – algorithms
>> that are O(num CPUs) and where one can have an extremely fast fastpath
>> at the cost of a slower slow path. Many of these algorithms are in use
>> in the kernel today – per-cpu allocators, RCU, light-weight reader
>> writer locks, etc. Even in cases where these APIs can be implemented
>> today, a rseq implementation is often superior in terms of
>> predictability and usability (eg per-thread counters consume more
>> memory and are more expensive to read than per-cpu counters).
>>
>> Isn’t the large number of uses of rseq-like algorithms in the kernel a
>> pretty substantial sign that there would be demand for similar
>> algorithms by user-space systems programmers?
> 
> Yes and no.  It provides a substantial sign that such algorithms could
> and should exist; however "someone should do this" doesn't demonstrate
> that someone *will*.  I do think we need a concrete example of a
> userspace user with benchmark numbers that demonstrate the value of this
> approach.
> 
> Mathieu, do you have a version of URCU that can use rseq to work per-CPU
> rather than per-thread?  URCU's data structures would work as a
> benchmark.

I currently don't have a per-cpu flavor of liburcu. All the flavors are
per-thread, because currently the alternative requires atomic operations
on the fast-path. We could indeed re-implement something similar to SRCU
(although under LGPLv2.1 license). I've looked at what would be required
over the weekend, and it seems feasible, but in the short term my customers
expect me to focus my work on speeding up the LTTng-UST tracer per-cpu
ring buffer by adapting it to rseq. Completing the liburcu per-cpu flavor
will be in my spare time for now.

I expect liburcu per-cpu flavor to improve the slow path in many-threads
use-cases (smaller grace period overhead), but not the fast path much,
except perhaps by allowing faster memory reclaim in update-heavy workloads,
which could then lead to better use of the cache even for reads.

> 
> Ben, Mathieu, Dave, do you have jemalloc benchmark numbers with and
> without rseq?  (As well as memory usage numbers for the reduced memory
> usage of per-CPU pools rather than per-thread pools?)

Before I started reimplementing rseq, the numbers presented by Facebook
at https://lkml.org/lkml/2015/10/22/588 were in my opinion a good proof
that rseq is useful. I'm not sure if their memoryidler API was used back
then.

I could take Dave's jemalloc branch adapted to Paul Turner's rseq and
adapt it to mine. Then we could use this allocator to compare the
memory use and speed of heavily multi-threaded applications.

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
