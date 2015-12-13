From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 1/2] thread_local_abi system call: caching current CPU
 number (x86)
Date: Sun, 13 Dec 2015 09:04:45 +0100
Message-ID: <CAKgNAki=CB8cY257QDmtj6L3pGjSGwmaA_qRozzWi+kQpKXWBQ@mail.gmail.com>
References: <1449761990-23525-1-git-send-email-mathieu.desnoyers@efficios.com>
 <566B1C6A.4030603@gmail.com> <1734518724.233994.1449924035932.JavaMail.zimbra@efficios.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1734518724.233994.1449924035932.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Mathieu

On 12 December 2015 at 13:40, Mathieu Desnoyers
<mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
> ----- On Dec 11, 2015, at 1:56 PM, Michael Kerrisk mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> Hi Mathieu,
>>
>> On 12/10/2015 04:39 PM, Mathieu Desnoyers wrote:
>>> Expose a new system call allowing threads to register a userspace memory
>>> area where to store the current CPU number. Scheduler migration sets the
>>> TIF_NOTIFY_RESUME flag on the current thread. Upon return to user-space,
>>> a notify-resume handler updates the current CPU value within that
>>> user-space memory area.
>>>
>>> This getcpu cache is an alternative to the sched_getcpu() vdso which has
>>> a few benefits:
>>> - It is faster to do a memory read that to call a vDSO,
>>> - This cached value can be read from within an inline assembly, which
>>>   makes it a useful building block for restartable sequences.
>>>
>>> This approach is inspired by Paul Turner and Andrew Hunter's work
>>> on percpu atomics, which lets the kernel handle restart of critical
>>> sections:
>>> Ref.:
>>> * https://lkml.org/lkml/2015/6/24/665
>>> * https://lwn.net/Articles/650333/
>>> *
>>> http://www.linuxplumbersconf.org/2013/ocw/system/presentations/1695/original/LPC%20-%20PerCpu%20Atomics.pdf
>>>
>>> Benchmarking sched_getcpu() vs tls cache approach. Getting the
>>> current CPU number:
>>
>> Is there a man page for this system call?
>
> Hi Michael,
>
> Not yet. I first want check whether the overall technical
> approach is deemed acceptable before adding documentation.
>
> Adding a manpage is going to be one of the first steps after
> we agree on the syscall interface. Or perhaps you are suggesting
> that adding a manpage at this RFC stage could help the
> interface discussion ?

Yup, that's exactly what I'm suggesting.

Thanks,

Michael
