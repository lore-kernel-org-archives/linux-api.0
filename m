From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC PATCH] percpu system call: fast userspace percpu critical sections
Date: Fri, 22 May 2015 13:53:43 -0700
Message-ID: <CALCETrUSBqHG3tbOq1yFz33v1_ckEgLNorgAxwLFi7MkjNcwLA@mail.gmail.com>
References: <1432219487-13364-1-git-send-email-mathieu.desnoyers@efficios.com> <CAHO5Pa0Kok4_QN0v3JNWyzGT=GbZNZcRyLhu02R2npV9hSdt7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHO5Pa0Kok4_QN0v3JNWyzGT=GbZNZcRyLhu02R2npV9hSdt7g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, May 22, 2015 at 1:26 PM, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> [CC += linux-api@]
>
> On Thu, May 21, 2015 at 4:44 PM, Mathieu Desnoyers
> <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>> Expose a new system call allowing userspace threads to register
>> a TLS area used as an ABI between the kernel and userspace to
>> share information required to create efficient per-cpu critical
>> sections in user-space.
>>
>> This ABI consists of a thread-local structure containing:
>>
>> - a nesting count surrounding the critical section,
>> - a signal number to be sent to the thread when preempting a thread
>>   with non-zero nesting count,
>> - a flag indicating whether the signal has been sent within the
>>   critical section,
>> - an integer where to store the current CPU number, updated whenever
>>   the thread is preempted. This CPU number cache is not strictly
>>   needed, but performs better than getcpu vdso.
>>
>> This approach is inspired by Paul Turner and Andrew Hunter's work
>> on percpu atomics, which lets the kernel handle restart of critical
>> sections, ref. http://www.linuxplumbersconf.org/2013/ocw/system/presentations/1695/original/LPC%20-%20PerCpu%20Atomics.pdf
>>
>> What is done differently here compared to percpu atomics: we track
>> a single nesting counter per thread rather than many ranges of
>> instruction pointer values. We deliver a signal to user-space and
>> let the logic of restart be handled in user-space, thus moving
>> the complexity out of the kernel. The nesting counter approach
>> allows us to skip the complexity of interacting with signals that
>> would be otherwise needed with the percpu atomics approach, which
>> needs to know which instruction pointers are preempted, including
>> when preemption occurs on a signal handler nested over an instruction
>> pointer of interest.
>>

I talked about this kind of thing with PeterZ at LSF/MM, and I was
unable to convince myself that the kernel needs to help at all.  To do
this without kernel help, I want to relax the requirements slightly.
With true per-cpu atomic sections, you have a guarantee that you are
either really running on the same CPU for the entire duration of the
atomic section or you abort.  I propose a weaker primitive: you
acquire one of an array of locks (probably one per cpu), and you are
guaranteed that, if you don't abort, no one else acquires the same
lock while you hold it.  Here's how:

Create an array of user-managed locks, one per cpu.  Call them lock[i]
for 0 <= i < ncpus.

To acquire, look up your CPU number.  Then, atomically, check that
lock[cpu] isn't held and, if so, mark it held and record both your tid
and your lock acquisition count.  If you learn that the lock *was*
held after all, signal the holder (with kill or your favorite other
mechanism), telling it which lock acquisition count is being aborted.
Then atomically steal the lock, but only if the lock acquisition count
hasn't changed.

This has a few benefits over the in-kernel approach:

1. No kernel patch.

2. No unnecessary abort if you are preempted in favor of a thread that
doesn't content for your lock.

3. Greatly improved debuggability.

4. With long critical sections and heavy load, you can improve
performance by having several locks per cpu and choosing one at
random.

Is there a reason that a scheme like this doesn't work?

>> Benchmarking sched_getcpu() vs tls cache approach. Getting the
>> current CPU number:
>>
>> - With Linux vdso:            12.7 ns
>> - With TLS-cached cpu number:  0.3 ns

Slightly off-topic: try this again on a newer kernel.  The vdso should
have gotten a bit faster in 3.19 or 4.0 IIRC.

--Andy
