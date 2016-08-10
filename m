From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v7 1/7] Restartable sequences system call
Date: Wed, 10 Aug 2016 16:47:42 +0000 (UTC)
Message-ID: <2119563927.7329.1470847662641.JavaMail.zimbra@efficios.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com> <1469135662-31512-2-git-send-email-mathieu.desnoyers@efficios.com> <CALCETrVq3hgLbADcx_4g6gGgp7Hf-WnnWA8gg68tPZTv2wfbDg@mail.gmail.com> <1806206514.82247.1469502139408.JavaMail.zimbra@efficios.com> <alpine.DEB.2.20.1608031325040.14875@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1608031325040.14875-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Aug 3, 2016, at 2:29 PM, Chris Lameter cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org wrote:

> On Tue, 26 Jul 2016, Mathieu Desnoyers wrote:
> 
>> > What problem does this solve?
>>
>> It allows user-space to perform update operations on per-cpu data without
>> requiring heavy-weight atomic operations.
> 
> 
> This is great but seems to indicate that such a facility would be better
> for kernel code instread of user space code.

It would be interesting to eventually investigate whether rseq is
additionally useful for kernel code. It seems unrelated to its usefulness
for user-space code though.

Rseq for user-space only needs to hook into preemption and signal delivery,
which doesn't seem to have measurable effects on overall performance.

Doing rseq for kernel code would imply hooking into supplementary sites:

- preemption of kernel code (for atomicity wrt other threads). This would
  replace preempt_disable()/preempt_enable() critical sections touching
  per-cpu data shared with other threads. We would have to do the event_counter
  increment and ip fixup directly in the sched_out hook when preempting
  kernel code.
- possibly interrupt handlers (for atomicity wrt interrupts). This would
  replace local irq save/restore when touching per-cpu data shared with
  interrupt handlers. We would have to increment the event_counter and
  fixup on the pre-irq kernel frame.
- possibly NMI handlers (for atomicity wrt NMIs). This would replace
  preempt/irq off protected local atomic operations on per-cpu data
  shared with NMIs. We would have to increment the event_counter and
  fixup on the pre-NMI kernel frame.

Those supplementary hooks may add significant overall performance overhead,
so careful benchmarking would be required to figure out if it's worth it.

> 
>> First, prohibiting migration from user-space has been frowned upon
>> by scheduler developers for a long time, and I doubt this mindset will
>> change.
> 
> Note that the task isolation patchset from Chris Metcalf does something
> that goes a long way towards this. If you set strict isolation mode then
> the kernel will terminate the process or notify you if the scheduler
> becomes involved. In some way we are getting that as a side effect.

AFAIU, what you propose here is doable at the application design level.
We want to introduce rseq to speed up memory allocation, tracing, and
other uses of per-cpu data without having to modify the design of each
and every user-space applications out there.

> Also prohibiting migration is trivial form user space. Just do a taskset
> to a single cpu.

This is also possible if you can redesign user-space applications, but not
from a library perspective. Invoking system calls to change the affinity of
a thread at each and every critical section would kill performance. Setting
the affinity of a thread from a library on behalf of the application and
leaving it affined requires changes to the application design.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
