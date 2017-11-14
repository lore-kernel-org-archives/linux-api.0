From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH 0/2] x86: Fix missing core serialization on
 migration
Date: Tue, 14 Nov 2017 17:10:04 +0000 (UTC)
Message-ID: <1216732828.15017.1510679404571.JavaMail.zimbra@efficios.com>
References: <20171110211249.10742-1-mathieu.desnoyers@efficios.com> <617343212.13932.1510592207202.JavaMail.zimbra@efficios.com> <4d47fbb8-8f99-19d3-a9cf-66841aeffac3@scylladb.com> <4431530.14831.1510672632887.JavaMail.zimbra@efficios.com> <20171114160541.GC3165@worktop.lehotels.local> <20171114160842.GH3857@worktop> <798843926.14994.1510678155257.JavaMail.zimbra@efficios.com> <98b50de6-4cb1-9c43-4353-9ee7135dc63f@scylladb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <98b50de6-4cb1-9c43-4353-9ee7135dc63f-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, maged michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Russell King, ARM Linux" <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Nov 14, 2017, at 12:03 PM, Avi Kivity avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org wrote:

> On 11/14/2017 06:49 PM, Mathieu Desnoyers wrote:
>> ----- On Nov 14, 2017, at 11:08 AM, Peter Zijlstra peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org wrote:
>>
>>> On Tue, Nov 14, 2017 at 05:05:41PM +0100, Peter Zijlstra wrote:
>>>> On Tue, Nov 14, 2017 at 03:17:12PM +0000, Mathieu Desnoyers wrote:
>>>>> I've tried to create a small single-threaded self-modifying loop in
>>>>> user-space to trigger a trace cache or speculative execution quirk,
>>>>> but I have not succeeded yet. I suspect that I would need to know
>>>>> more about the internals of the processor architecture to create the
>>>>> right stalls that would allow speculative execution to move further
>>>>> ahead, and trigger an incoherent execution flow. Ideas on how to
>>>>> trigger this would be welcome.
>>>> I thought the whole problem was per definition multi-threaded.
>>>>
>>>> Single-threaded stuff can't get out of sync with itself; you'll always
>>>> observe your own stores.
>>> And even if you could, you can always execute a local serializing
>>> instruction like CPUID to force things.
>> What I'm trying to reproduce is something that breaks in single-threaded
>> case if I explicitly leave out the CPUID core serializing instruction
>> when doing code modification on upcoming code, in a loop.
>>
>> AFAIU, Intel requires a core serializing instruction to be issued even
>> in single-threaded scenarios between code update and execution, to ensure
>> that speculative execution does not observe incoherent code. Now the
>> question we all have for Intel is: is this requirement too strong, or
>> required by reality ?
>>
> 
> In single-threaded execution, a jump is enough.
> 
> "As processor microarchitectures become more complex and start to
> speculatively execute code ahead of the retire-
> ment point (as in P6 and more recent processor families), the rules
> regarding which code should execute, pre- or
> post-modification, become blurred. To write self-modifying code and
> ensure that it is compliant with current and
> future versions of the IA-32 architectures, use one of the following
> coding options:
> 
> (* OPTION 1 *)
> Store modified code (as data) into code segment;
> Jump to new code or an intermediate location;
> Execute new code;"

Good point, so this is likely why I was having trouble reproducing the
single-threaded self-modifying code incoherent case. I did have a branch
in there.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
