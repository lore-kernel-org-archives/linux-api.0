From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18 00/16] Restartable Sequences
Date: Mon, 30 Jul 2018 15:34:18 -0400 (EDT)
Message-ID: <1259134501.7268.1532979258894.JavaMail.zimbra@efficios.com>
References: <20180602124408.8430-1-mathieu.desnoyers@efficios.com> <20180727220115.GA18879@amd> <1210024721.6363.1532785744879.JavaMail.zimbra@efficios.com> <20180728141314.GA25264@amd> <1005916991.7038.1532976120931.JavaMail.zimbra@efficios.com> <20180730190715.GA29926@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180730190715.GA29926@amd>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: carlos <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linu
List-Id: linux-api@vger.kernel.org

----- On Jul 30, 2018, at 3:07 PM, Pavel Machek pavel@ucw.cz wrote:

> Hi!
> 
>> > Thanks for pointer.
>> > 
>> > +Restartable sequences are atomic with respect to preemption (making
>> > it
>> > +atomic with respect to other threads running on the same CPU), as
>> > well
>> > +as signal delivery (user-space execution contexts nested over the
>> > same
>> > +thread).
>> > 
>> > So the threads are protected against sigkill when running the
>> > restartable sequence?
>> 
>> In that scenario, SIGKILL _will_ be delivered, hence execution of the
>> rseq critical section will never reach the commit instruction. This
>> follows the guarantee provided that the rseq c.s. either executes
>> completely "atomically" wrt preemption/signal delivery, *or* gets
>> aborted. In this case, sigkill will reap the entire process, so
> 
> The text above does not mention abort -- so I was just making
> sure. Maybe mentioning it would be good idea?

How about this ?

Restartable sequences are atomic with respect to preemption (making it
atomic with respect to other threads running on the same CPU), as well
as signal delivery (user-space execution contexts nested over the same
thread). They either complete atomically with respect to preemption on
the current CPU and signal delivery, or they are aborted.

[...]

> 
>> > +Optimistic cache of the CPU number on which the current thread is
>> > +running. Its value is guaranteed to always be a possible CPU number,
>> > +even when rseq is not initialized. The value it contains should
>> > always
>> > +be confirmed by reading the cpu_id field.
>> > 
>> > I'm not sure what "optimistic cache" is...
>> 
>> Perhaps we can find a better wording.
>> 
>> It's "optimistic" in the sense that it's always guaranteed to hold a
>> valid CPU number within the range [ 0 .. nr_possible_cpus - 1 ]. It can
>> therefore be loaded by user-space and then used as an offset, without
>> having to check whether it is within valid bounds compared to the number
>> of possible CPUs in the system.
>> 
>> This works even if the kernel on which the application runs on does not
>> support rseq at all: the __rseq_abi->cpu_id_start field stays initialized at
>> 0, which is indeed a valid CPU number. It's therefore valid to use it as an
>> offset in per-cpu data structures, and only validate whether it's actually the
>> current CPU number by comparing it with the __rseq_abi->cpu_id field
>> within the rseq critical section. If rseq is not available in the kernel,
>> that cpu_id field stays initialized at -1, so the comparison always fails,
>> as intended.
>> 
>> It's then up to user-space to use a fall-back mechanism, considering that
>> rseq is not available.
>> 
>> Advice on improved wording would be welcome.
> 
> Ok, that makes sense, but I'd not understand it from the man
> page. Perhaps your text should be put there?

How about this ?

.TP
.in +4n
.I cpu_id_start
Optimistic cache of the CPU number on which the current thread is
running. Its value is guaranteed to always be a possible CPU number,
even when rseq is not initialized. The value it contains should always
be confirmed by reading the cpu_id field.

This field is an optimistic cache in the sense that it is always
guaranteed to hold a valid CPU number in the range [ 0 ..
nr_possible_cpus - 1 ]. It can therefore be loaded by user-space and
used as an offset in per-cpu data structures without having to
check whether its value is within the valid bounds compared to the
number of possible CPUs in the system.

For user-space applications executed on a kernel without rseq support,
the cpu_id_start field stays initialized at 0, which is indeed a valid
CPU number. It is therefore valid to use it as an offset in per-cpu data
structures, and only validate whether it's actually the current CPU
number by comparing it with the cpu_id field within the rseq critical
section. If the kernel does not provide rseq support, that cpu_id field
stays initialized at -1, so the comparison always fails, as intended.

It is then up to user-space to use a fall-back mechanism, considering
that rseq is not available.

[...]

> 
>> > (Will not
>> > this need to be bigger on machines with bigger cache sizes?)
>> > 
>> > above it says:
>> > 
>> > +.B Structure size
>> > +This structure is extensible. Its size is passed as parameter to the
>> > +rseq system call.
>> > 
>> > I'm reading source, so maybe it refers to different structure.
>> 
>> It can be aligned on a larger multiple. This requirement of 32 bytes
>> is a minimum. Therefore, if we ever extend struct rseq, or if an
>> architecture shows benefit from aligning struct rseq on larger boundaries,
>> it is free to do so. It will still respect the requirement of alignment on
>> 32 bytes boundaries.
> 
> Well, elsewhere it said "This structure has a fixed size of 32 bytes."
> Now it says structure size is passed with every syscalls. Now I'm
> confused (but maybe that's caused by reading source, not formatted
> document).

This is the layout for struct rseq_cs version 0.

The variable-sized structure is struct rseq.

struct rseq is typically in a TLS, and contains a "rseq_cs" field
which is a pointer to the struct rseq_cs descriptor describing the
currently active rseq critical section.

Hoping this clears up the confusion.

Thanks for the review!

Mathieu


> 
> Best regards,
>									Pavel
> 
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures)
> http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
