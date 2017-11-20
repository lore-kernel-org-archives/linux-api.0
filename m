From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v3 for 4.15 08/24] Provide cpu_opv system call
Date: Mon, 20 Nov 2017 22:46:03 +0000 (UTC)
Message-ID: <1920107276.18703.1511217963487.JavaMail.zimbra@efficios.com>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com> <20171114200414.2188-9-mathieu.desnoyers@efficios.com> <alpine.DEB.2.20.1711162215100.2109@nanos> <1766414702.18278.1511194398489.JavaMail.zimbra@efficios.com> <alpine.DEB.2.20.1711201831490.1734@nanos> <204285712.18480.1511203151076.JavaMail.zimbra@efficios.com> <20171120184927.GK2482@two.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171120184927.GK2482-1g7Xle2YJi4/4alezvVtWx2eb7JE58TQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will
List-Id: linux-api@vger.kernel.org

----- On Nov 20, 2017, at 1:49 PM, Andi Kleen andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org wrote:

>> Having cpu_opv do a 4k memcpy allow it to handle scenarios where
>> rseq fails to progress.
> 
> If anybody ever gets that right. It will be really hard to just
> test such a path.
> 
> It also seems fairly theoretical to me. Do you even have a
> test case where the normal path stops making forward progress?

We expect the following loop to progress, typically after a single
iteration:

	do {
		cpu = rseq_cpu_start();
		ret = rseq_addv(&v, 1, cpu);
		attempts++;
	} while (ret);

Now runnig this in gdb, break on "main", run, and single-step
execution with "next", the program is stuck in an infinite loop.

What solution do you have in mind to handle this kind of
scenario without breaking pre-existing debuggers ?

Looking at vDSO examples of vgetcpu and vclock_gettime under
gdb 7.7.1 (debian) with glibc 2.19:

sched_getcpu behavior under single-stepping per source line
with "step" seems to only see the ../sysdeps/unix/sysv/linux/x86_64/sched_getcpu.S
source lines, which makes it skip single-stepping of the vDSO.

sched_getcpu under "stepi": it does go through the vDSO instruction
addresses. It does progress, given that there is no loop there.

clock_gettime under "step": it only sees source lines of
../sysdeps/unix/clock_gettime.c.

clock_gettime under "stepi": it's stuck in an infinite loop.

So instruction-level stepping from gdb turns clock_gettime vDSO
into a never-ending loop, which is already bad. But with rseq,
the situation is even worse, because it turns source line level
single-stepping into infinite loops.

My understanding from https://sourceware.org/bugzilla/show_bug.cgi?id=14466
is that GDB currently simply removes the vDSO from its list of library
mappings, which is probably why it skips over vDSO for the source
lines single-stepping case. We cannot do that with rseq, because we
_want_ the rseq critical section to be inlined into the application
or library. A function call costs more than most rseq critical sections.

I plan to have the rseq user-space code provide a "__rseq_table" section
so debuggers can eventually figure out that they need to skip over the
rseq critical sections. However, it won't help the fact that pre-existing
debugger single-stepping will start turning perfectly working programs
into never-ending loops simply by having glibc use rseq for memory
allocation.

Using the cpu_opv system call on rseq failure solves this problem
entirely.

I would even go further and recommend to take a similar approach when
lack of progress is detected in a vDSO, and invoke the equivalent
system call. The current implementation of the clock_gettime()
vDSO turns instruction-level single-stepping into never
ending loops, which is far from being elegant.

Thanks,

Mathieu	

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
