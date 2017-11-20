From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH v3 for 4.15 08/24] Provide cpu_opv system call
Date: Mon, 20 Nov 2017 17:13:01 +0000 (UTC)
Message-ID: <2146933374.18426.1511197981823.JavaMail.zimbra@efficios.com>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com> <20171114200414.2188-9-mathieu.desnoyers@efficios.com> <alpine.DEB.2.20.1711162215100.2109@nanos> <20171117001410.GG2482@two.firstfloor.org> <alpine.DEB.2.20.1711171107450.1709@nanos> <1756446476.17265.1510938872121.JavaMail.zimbra@efficios.com> <alpine.DEB.2.20.1711172118270.2186@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1711172118270.2186@nanos>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will
List-Id: linux-api@vger.kernel.org

----- On Nov 17, 2017, at 3:22 PM, Thomas Gleixner tglx@linutronix.de wrote:

> On Fri, 17 Nov 2017, Mathieu Desnoyers wrote:
>> ----- On Nov 17, 2017, at 5:09 AM, Thomas Gleixner tglx@linutronix.de wrote:
>> 7) Allow libraries with multi-part algorithms to work on same per-cpu
>>    data without affecting the allowed cpu mask
>> 
>> I stumbled on an interesting use-case within the lttng-ust tracer
>> per-cpu buffers: the algorithm needs to update a "reserve" counter,
>> serialize data into the buffer, and then update a "commit" counter
>> _on the same per-cpu buffer_. My goal is to use rseq for both reserve
>> and commit.
>> 
>> Clearly, if rseq reserve fails, the algorithm can retry on a different
>> per-cpu buffer. However, it's not that easy for the commit. It needs to
>> be performed on the same per-cpu buffer as the reserve.
>> 
>> The cpu_opv system call solves that problem by receiving the cpu number
>> on which the operation needs to be performed as argument. It can push
>> the task to the right CPU if needed, and perform the operations there
>> with preemption disabled.
> 
> If your transaction cannot be done in one go, then abusing that byte code
> interpreter for concluding it is just hillarious. That whole exercise is a
> gazillion times slower than the atomic operations which are neccesary to do
> it without all that.
> 
> I'm even more convinced now that this is overengineered beyond repair.

The fast-path (typical case) will execute on the right CPU, and rseq will
do both the reserve and the commit, and that is faster than atomic ops.

However, we need to handle migration between reserve and commit.
Unfortunately, concurrent rseq and atomic ops don't mix well on the
same per-cpu data, so we cannot fall-back on atomic ops, except in
very specific cases where we can use a split-counter strategy.

So cpu_opv handles migration for this use-case by ensuring
the slow-path is performed with preemption-off after migrating
the current task to the right CPU.

Thanks,

Mathieu


> 
> Thanks,
> 
> 	tglx

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
