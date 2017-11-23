From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.15 v12 00/22] Restartable sequences and CPU op
 vector
Date: Thu, 23 Nov 2017 23:01:11 +0000 (UTC)
Message-ID: <739755311.21380.1511478071883.JavaMail.zimbra@efficios.com>
References: <20171121141900.18471-1-mathieu.desnoyers@efficios.com> <20171121172144.GL2482@two.firstfloor.org> <740195164.19702.1511301908907.JavaMail.zimbra@efficios.com> <20171122193219.GI3165@worktop.lehotels.local> <20171122193734.GO22648@arm.com> <165707648.21250.1511471721845.JavaMail.zimbra@efficios.com> <alpine.DEB.2.20.1711232346030.2364@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1711232346030.2364@nanos>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>, Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin
List-Id: linux-api@vger.kernel.org

----- On Nov 23, 2017, at 5:51 PM, Thomas Gleixner tglx@linutronix.de wrote:

> On Thu, 23 Nov 2017, Mathieu Desnoyers wrote:
>> ----- On Nov 22, 2017, at 2:37 PM, Will Deacon will.deacon@arm.com wrote:
>> > On Wed, Nov 22, 2017 at 08:32:19PM +0100, Peter Zijlstra wrote:
>> >>
>> >> So what exactly is the problem of leaving out the whole cpu_opv thing
>> >> for now? Pure rseq is usable -- albeit a bit cumbersome without
>> >> additional debugger support.
>> > 
>> > Drive-by "ack" to that. I'd really like a working rseq implementation in
>> > mainline, but I don't much care for another interpreter.
>> 
>> Considering the arm 64 use-case of reading PMU counters from user-space
>> using rseq to prevent migration, I understand that you're lucky enough to
>> already have a system call at your disposal that can perform the slow-path
>> in case of single-stepping.
>> 
>> So yes, your particular case is already covered, but unfortunately that's
>> not the same situation for other use-cases that have been expressed.
> 
> If we have users of rseq which can do without the other muck, then what's
> the reason not to support it?
> 
> The sysops thing can be sorted out on top and the use cases which need both
> will have to test for both syscalls being available anyway.

I'm currently making sure CONFIG_RSEQ selects both CONFIG_CPU_OPV and
CONFIG_MEMBARRIER, so the user-space fast-paths don't end up with
various ways of doing the fallback/single-stepping/memory barrier handling
depending on whether the kernel support each of those individually.
So first of all, it reduces complexity from a user-space perspective.

Moreover, with a single already needed cpu_id vs cpu_id_start field comparison
in the rseq fast-path, user-space knows that it can rely on having rseq,
cpu_opv, and membarrier. Without this guarantee, user-space would have to
detect individually whether each of those system calls is available, and
test flags on the fast-path, for additional overhead.

Those are my main concerns about pushing an incomplete solution at this
stage.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
