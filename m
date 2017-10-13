From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC PATCH for 4.15 09/14] Provide cpu_opv system call
Date: Fri, 13 Oct 2017 10:20:52 -0700
Message-ID: <CALCETrUxGiRqrAc_6rBW_q3PxuPxAnoBNyynkr2FZhUoH+tV3w@mail.gmail.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com> <20171012230326.19984-10-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171012230326.19984-10-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 12, 2017 at 4:03 PM, Mathieu Desnoyers
<mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
> This new cpu_opv system call executes a vector of operations on behalf
> of user-space on a specific CPU with preemption disabled. It is inspired
> from readv() and writev() system calls which take a "struct iovec" array
> as argument.
>
> The operations available are: comparison, memcpy, add, or, and, xor,
> left shift, and right shift. The system call receives a CPU number from
> user-space as argument, which is the CPU on which those operations need
> to be performed. All preparation steps such as loading pointers, and
> applying offsets to arrays, need to be performed by user-space before
> invoking the system call. The "comparison" operation can be used to
> check that the data used in the preparation step did not change between
> preparation of system call inputs and operation execution within the
> preempt-off critical section.
>
> The reason why we require all pointer offsets to be calculated by
> user-space beforehand is because we need to use get_user_pages_fast() to
> first pin all pages touched by each operation. This takes care of
> faulting-in the pages. Then, preemption is disabled, and the operations
> are performed atomically with respect to other thread execution on that
> CPU, without generating any page fault.
>
> A maximum limit of 16 operations per cpu_opv syscall invocation is
> enforced, so user-space cannot generate a too long preempt-off critical
> section. Each operation is also limited a length of PAGE_SIZE bytes,
> meaning that an operation can touch a maximum of 4 pages (memcpy: 2
> pages for source, 2 pages for destination if addresses are not aligned
> on page boundaries).
>
> If the thread is not running on the requested CPU, a new
> push_task_to_cpu() is invoked to migrate the task to the requested CPU.
> If the requested CPU is not part of the cpus allowed mask of the thread,
> the system call fails with EINVAL. After the migration has been
> performed, preemption is disabled, and the current CPU number is checked
> again and compared to the requested CPU number. If it still differs, it
> means the scheduler migrated us away from that CPU. Return EAGAIN to
> user-space in that case, and let user-space retry (either requesting the
> same CPU number, or a different one, depending on the user-space
> algorithm constraints).

This series seems to get more complicated every time, and it's been so
long that I've mostly forgetten all the details.  I would have sworn
we had a solution that got single-stepping right without any
complicated work like this in the kernel and had at most a minor
performance hit relative to the absolutely fastest solution.  I'll try
to dig it up.
