From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18 00/16] Restartable Sequences
Date: Mon, 30 Jul 2018 14:42:00 -0400 (EDT)
Message-ID: <1005916991.7038.1532976120931.JavaMail.zimbra@efficios.com>
References: <20180602124408.8430-1-mathieu.desnoyers@efficios.com> <20180727220115.GA18879@amd> <1210024721.6363.1532785744879.JavaMail.zimbra@efficios.com> <20180728141314.GA25264@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180728141314.GA25264@amd>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: carlos <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linu
List-Id: linux-api@vger.kernel.org

----- On Jul 28, 2018, at 10:13 AM, Pavel Machek pavel@ucw.cz wrote:

> Hi!
> 
>> Documentation-wise, I have posted a rseq man page rfc here:
>> 
>> https://lkml.kernel.org/r/20180616195803.29877-1-mathieu.desnoyers@efficios.com
>> 
>> comments are welcome!
> 
> Thanks for pointer.
> 
> +Restartable sequences are atomic with respect to preemption (making
> it
> +atomic with respect to other threads running on the same CPU), as
> well
> +as signal delivery (user-space execution contexts nested over the
> same
> +thread).
> 
> So the threads are protected against sigkill when running the
> restartable sequence?

In that scenario, SIGKILL _will_ be delivered, hence execution of the
rseq critical section will never reach the commit instruction. This
follows the guarantee provided that the rseq c.s. either executes
completely "atomically" wrt preemption/signal delivery, *or* gets
aborted. In this case, sigkill will reap the entire process, so
the kernel will never actually have to return to userspace and
execute the instruction pointer at the abort_ip, but the rseq c.s.
will never reach the commit instruction.

> 
> +Restartable sequences must not perform system calls. Doing so may
> result
> +in termination of the process by a segmentation fault.
> +
> 
> "may result"? It would be nice to always catch that.

I would also like this, but unfortunately this check adds overhead to every
system call, therefore this is only enforced with CONFIG_DEBUG_RSEQ=y builds.

> 
> +Optimistic cache of the CPU number on which the current thread is
> +running. Its value is guaranteed to always be a possible CPU number,
> +even when rseq is not initialized. The value it contains should
> always
> +be confirmed by reading the cpu_id field.
> 
> I'm not sure what "optimistic cache" is...

Perhaps we can find a better wording.

It's "optimistic" in the sense that it's always guaranteed to hold a
valid CPU number within the range [ 0 .. nr_possible_cpus - 1 ]. It can
therefore be loaded by user-space and then used as an offset, without
having to check whether it is within valid bounds compared to the number
of possible CPUs in the system.

This works even if the kernel on which the application runs on does not
support rseq at all: the __rseq_abi->cpu_id_start field stays initialized at
0, which is indeed a valid CPU number. It's therefore valid to use it as an
offset in per-cpu data structures, and only validate whether it's actually the
current CPU number by comparing it with the __rseq_abi->cpu_id field
within the rseq critical section. If rseq is not available in the kernel,
that cpu_id field stays initialized at -1, so the comparison always fails,
as intended.

It's then up to user-space to use a fall-back mechanism, considering that
rseq is not available.

Advice on improved wording would be welcome.

> 
> +Flags indicating the restart behavior for the current thread. This is
> +mainly used for debugging purposes. Can be either:
> +.IP \[bu]
> +RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT
> +.IP \[bu]
> +RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL
> +.IP \[bu]
> 
> Flags tell me there may be more then one, but "can be either" tells me
> just one flag is allowed.

Combining them is allowed. Will fix by saying: "Can be a combination of:".

> 
> +.B Structure alignment
> +This structure is aligned on multiples of 32 bytes.
> +.TP
> +.B Structure size
> +This structure has a fixed size of 32 bytes.
> +.B Structure alignment
> +This structure is aligned on multiples of 32 bytes.
> +.TP
> +.B Structure size
> +This structure has a fixed size of 32 bytes.
> 
> I believe we normally say "is aligned on 32-bytes boundary".

OK will fix. I think it should then become:

"is aligned on 32-byte boundary." (no plural for byte)

> (Will not
> this need to be bigger on machines with bigger cache sizes?)
> 
> above it says:
> 
> +.B Structure size
> +This structure is extensible. Its size is passed as parameter to the
> +rseq system call.
> 
> I'm reading source, so maybe it refers to different structure.

It can be aligned on a larger multiple. This requirement of 32 bytes
is a minimum. Therefore, if we ever extend struct rseq, or if an
architecture shows benefit from aligning struct rseq on larger boundaries,
it is free to do so. It will still respect the requirement of alignment on
32 bytes boundaries.

Thoughts ?

Thanks,

Mathieu


> 
> Thanks,
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
