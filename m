From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH 0/2] x86: Fix missing core serialization on
 migration
Date: Tue, 14 Nov 2017 15:17:12 +0000 (UTC)
Message-ID: <4431530.14831.1510672632887.JavaMail.zimbra@efficios.com>
References: <20171110211249.10742-1-mathieu.desnoyers@efficios.com> <CA+55aFzbroWqi+FTdYhRVSwUZ-M0wDVxjXqDbh40JEnXc2LdgQ@mail.gmail.com> <885227610.13045.1510351034488.JavaMail.zimbra@efficios.com> <617343212.13932.1510592207202.JavaMail.zimbra@efficios.com> <4d47fbb8-8f99-19d3-a9cf-66841aeffac3@scylladb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4d47fbb8-8f99-19d3-a9cf-66841aeffac3-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, maged michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Russell King, ARM Linux" <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Nov 14, 2017, at 9:53 AM, Avi Kivity avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org wrote:

> On 11/13/2017 06:56 PM, Mathieu Desnoyers wrote:
>> ----- On Nov 10, 2017, at 4:57 PM, Mathieu Desnoyers
>> mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org wrote:
>>
>>> ----- On Nov 10, 2017, at 4:36 PM, Linus Torvalds torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
>>> wrote:
>>>
>>>> On Fri, Nov 10, 2017 at 1:12 PM, Mathieu Desnoyers
>>>> <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>>>>> x86 can return to user-space through sysexit and sysretq, which are not
>>>>> core serializing. This breaks expectations from user-space about
>>>>> sequential consistency from a single-threaded self-modifying program
>>>>> point of view in specific migration patterns.
>>>>>
>>>>> Feedback is welcome,
>>>> We should check with Intel. I would actually be surprised if the I$
>>>> can be out of sync with the D$ after a sysretq.  It would actually
>>>> break things like "read code from disk" too in theory.
>>> That core serializing instruction is not that much about I$ vs D$
>>> consistency, but rather about the processor speculatively executing code
>>> ahead of its retirement point. Ref. Intel Architecture Software Developer's
>>> Manual, Volume 3: System Programming.
>>>
>>> 7.1.3. "Handling Self- and Cross-Modifying Code":
>>>
>>> "The act of a processor writing data into a currently executing code segment
>>> with the intent of
>>> executing that data as code is called self-modifying code. Intel Architecture
>>> processors exhibit
>>> model-specific behavior when executing self-modified code, depending upon how
>>> far ahead of
>>> the current execution pointer the code has been modified. As processor
>>> architectures become
>>> more complex and start to speculatively execute code ahead of the retirement
>>> point (as in the P6
>>> family processors), the rules regarding which code should execute, pre- or
>>> post-modification,
>>> become blurred. [...]"
>>>
>>> AFAIU, this core serializing instruction seems to be needed for use-cases of
>>> self-modifying code, but not for the initial load of a program from disk,
>>> as the processor has no way to have speculatively executed any of its
>>> instructions.
>> I figured out what you're pointing to: if exec() is executed by a previously
>> running thread, and there is no core serializing instruction between program
>> load and return to user-space, the kernel ends up acting like a JIT, indeed.
> 
> I think that's safe. The kernel has to execute a MOV CR3 instruction
> before it can execute code loaded by exec, and that is a serializing
> instruction. Loading and unloading shared libraries is made safe by the
> IRET executed by page faults (loading) and TLB shootdown IPIs (unloading).

Very good points! Perhaps those guarantees should be documented somewhere ?

> 
> Directly modifying code in userspace is unsafe if there is some
> non-coherent instruction cache. Instruction fetch and speculative
> execution are non-coherent, but they're probably too short (in current
> processors) to matter. Trace caches are probably large enough, but I
> don't know whether they are coherent or not.

Android guys at Google have reproducers of context synchronization issues
on arm 64 in JIT scenarios. Based on the information I got, flushing the
instruction caches is not enough: they also need to issue a context
synchronizing instruction.

Perhaps the current Intel processors may have short enough speculative
execution and small enough trace caches, but relying on this without
a clear statement from Intel seems fragile.

I've tried to create a small single-threaded self-modifying loop in
user-space to trigger a trace cache or speculative execution quirk,
but I have not succeeded yet. I suspect that I would need to know
more about the internals of the processor architecture to create the
right stalls that would allow speculative execution to move further
ahead, and trigger an incoherent execution flow. Ideas on how to
trigger this would be welcome.

Thanks,

Mathieu


> 
> 
>>
>> Therefore, we'd also need to invoke sync_core_before_usermode() after loading
>> the program.
>>
>> Let's wait to hear back from hpa,
>>
>> Thanks,
>>
>> Mathieu
>>
>>
>>> Hopefully hpa can tell us more about this,
>>>
>>> Thanks,
>>>
>>> Mathieu
>>>
>>>
>>> --
>>> Mathieu Desnoyers
>>> EfficiOS Inc.
> >> http://www.efficios.com

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
