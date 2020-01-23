From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v1] pin_on_cpu: Introduce thread CPU pinning system
 call
Date: Wed, 22 Jan 2020 23:53:54 -0800
Message-ID: <ead7a565-9a23-a7d7-904d-c4860f63952a@zytor.com>
References: <20200121160312.26545-1-mathieu.desnoyers@efficios.com>
 <CAG48ez2bQdoT9y7HkyU06DTazysUDdPdJe+gyV-NxgQA7JWQVQ@mail.gmail.com>
 <430172781.596271.1579636021412.JavaMail.zimbra@efficios.com>
 <CAG48ez2Z5CesMfandNK+S32Rrgp_QGQHqQ1Fpd5-YTsCWGfHeg@mail.gmail.com>
 <2049164886.596497.1579641536619.JavaMail.zimbra@efficios.com>
 <alpine.DEB.2.21.2001212141590.1231@www.lameter.com>
 <1648013936.596672.1579655468604.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1648013936.596672.1579655468604.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joel Fernandes <joelaf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, linux-kselftest <linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Paul <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 2020-01-21 17:11, Mathieu Desnoyers wrote:
> ----- On Jan 21, 2020, at 4:44 PM, Chris Lameter cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org wrote:
> 
>> These scenarios are all pretty complex and will be difficult to understand
>> for the user of these APIs.
>>
>> I think the easiest solution (and most comprehensible) is for the user
>> space process that does per cpu operations to get some sort of signal. If
>> its not able to handle that then terminate it. The code makes a basic
>> assumption after all that the process is running on a specific cpu. If
>> this is no longer the case then its better to abort if the process cannot
>> handle moving to a different processor.
> 
> The point of pin_on_cpu() is to allow threads to access per-cpu data
> structures belonging to a given CPU even if they cannot run on that
> CPU (because it is offline).
> 
> I am not sure what scenario your signal delivery proposal aims to cover.
> 
> Just to try to put this into the context of a specific scenario to see
> if I understand your point, is the following what you have in mind ?
> 
> 1. Thread A issues pin_on_cpu(5),
> 2. Thread B issues sched_setaffinity removing cpu 5 from thread A's
>    affinity mask,
> 3. Noticing that it would generate an invalid combination, rather than
>    failing sched_setaffinity, it would send a SIGSEGV (or other) signal
>    to thread A.
> 
> Or so you have something entirely different in mind ?
> 

I would agree that this seems like the only sane option, or you will be in a
world of hurt because of conflicting semantics. It is not just offlining, but
what happens if a policy manager calls sched_setaffinity() on another thread
-- and now the universe breaks because a library is updated to use this new
system call which collides with the expectations of the policy manager.

There doesn't seem to be any way to get this to be a local event which doesn't
break assumptions elsewhere in the system without making this an abort event
of some type. However, signals are painful in their own right, mostly because
of the lack of any infrastructure for allocating signals to libraries in user
space. I was actually thinking about exactly that issue just this weekend.

	-hpa
