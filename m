From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC PATCH 2/3] restartable sequences: x86 ABI
Date: Fri, 26 Jun 2015 12:31:21 -0700
Message-ID: <CALCETrWKzP8UPH2OEmwbC4egcAa6NA+VkQD6OuA-LhFv-Aqg6Q@mail.gmail.com>
References: <20150624222609.6116.86035.stgit@kitami.mtv.corp.google.com>
 <20150624222609.6116.30992.stgit@kitami.mtv.corp.google.com> <1050218158.4054.1435342186284.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1050218158.4054.1435342186284.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 26, 2015 at 11:09 AM, Mathieu Desnoyers
<mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
> ----- On Jun 24, 2015, at 6:26 PM, Paul Turner pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org wrote:
>
>> Implements the x86 (i386 & x86-64) ABIs for interrupting and restarting
>> execution within restartable sequence sections.
>>
>> With respect to the x86-specific ABI:
>>  On 32-bit:           Upon restart, the interrupted rip is placed in %ecx
>>  On 64-bit (or x32):  Upon restart, the interrupted rip is placed in %r10
>>
>> While potentially surprising at first glance, this choice is strongly motivated
>> by the fact that the available scratch registers under the i386 function call
>> ABI overlap with those used as argument registers under x86_64.
>>
>> Given that sequences are already personality specific and that we always want
>> the arguments to be available for sequence restart, it's much more natural to
>> ultimately differentiate the ABI in these two cases.
>>
>> Signed-off-by: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> ---
>> arch/x86/include/asm/restartable_sequences.h |   50 +++++++++++++++++++
>> arch/x86/kernel/Makefile                     |    2 +
>> arch/x86/kernel/restartable_sequences.c      |   69 ++++++++++++++++++++++++++
>> arch/x86/kernel/signal.c                     |   12 +++++
>> kernel/restartable_sequences.c               |   11 +++-
>> 5 files changed, 141 insertions(+), 3 deletions(-)
>> create mode 100644 arch/x86/include/asm/restartable_sequences.h
>> create mode 100644 arch/x86/kernel/restartable_sequences.c
>>
>> diff --git a/arch/x86/include/asm/restartable_sequences.h
>> b/arch/x86/include/asm/restartable_sequences.h
>> new file mode 100644
>> index 0000000..0ceb024
>> --- /dev/null
>> +++ b/arch/x86/include/asm/restartable_sequences.h
>> @@ -0,0 +1,50 @@
>> +#ifndef _ASM_X86_RESTARTABLE_SEQUENCES_H
>> +#define _ASM_X86_RESTARTABLE_SEQUENCES_H
>> +
>> +#include <asm/processor.h>
>> +#include <asm/ptrace.h>
>> +#include <linux/sched.h>
>> +
>> +#ifdef CONFIG_RESTARTABLE_SEQUENCES
>> +
>> +static inline bool arch_rseq_in_crit_section(struct task_struct *p,
>> +                                          struct pt_regs *regs)
>> +{
>> +     struct task_struct *leader = p->group_leader;
>> +     struct restartable_sequence_state *rseq_state = &leader->rseq_state;
>> +
>> +     unsigned long ip = (unsigned long)regs->ip;
>> +     if (unlikely(ip < (unsigned long)rseq_state->crit_end &&
>> +                  ip >= (unsigned long)rseq_state->crit_start))
>> +             return true;
>> +
>> +     return false;
>> +}
>> +
>> +static inline bool arch_rseq_needs_notify_resume(struct task_struct *p)
>> +{
>> +#ifdef CONFIG_PREEMPT
>> +     /*
>> +      * Under CONFIG_PREEMPT it's possible for regs to be incoherent in the
>> +      * case that we took an interrupt during syscall entry.  Avoid this by
>> +      * always deferring to our notify-resume handler.
>> +      */
>> +     return true;
>
> I'm a bit puzzled about this. If I look at perf_get_regs_user() in the perf
> code, task_pt_regs() seems to return the user-space pt_regs for a task with
> a current->mm set (iow, not a kernel thread), even if an interrupt nests on
> top of a system call. The only corner-case is NMIs, where an NMI may interrupt
> in the middle of setting up the task pt_regs, but scheduling should never happen
> there, right ?

Careful, here!  task_pt_regs returns a pointer to the place where regs
would be if they were fully initialized.  We can certainly take an
interrupt in the middle of pt_regs setup (entry_SYSCALL_64 enables
interrupts very early, for example).  To me, the question is whether
we can ever be preemptable at such a time.

It's a bit worse, though: we can certainly be preemptible when other
code is accessing pt_regs.  clone, execve, sigreturn, and signal
delivery come to mind.

Why don't we give up on poking at user state from the scheduler and do
it on exit to user mode instead?  Starting in 4.3 (hopefully landing
in -tip in a week or two), we should have a nice function
prepare_exit_to_usermode that runs with well-defined state,
non-reentrantly, that can do whatever you want here, *including user
memory access*.

The remaining question would be what the ABI should be.

Could we get away with a vDSO function along the lines of "set *A=B
and *X=Y if we're on cpu N and *X=Z"?  Straight-up cmpxchg would be
even simpler.

--Andy
