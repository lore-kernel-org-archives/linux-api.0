From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC PATCH v9 for 4.15 01/14] Restartable sequences system call
Date: Fri, 13 Oct 2017 11:17:04 -0700
Message-ID: <CALCETrVWZxC=mT9p7HTrAwcAdMzaxwa=A-O0uQt79qy1Cpky_g@mail.gmail.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com>
 <20171012230326.19984-2-mathieu.desnoyers@efficios.com> <19edaac0-98d7-e7a0-aceb-b861a2befce4@redhat.com>
 <695804241.40580.1507902016119.JavaMail.zimbra@efficios.com>
 <0043559c-c4e0-523a-b634-eded6ced886c@redhat.com> <66195899.40613.1507904878681.JavaMail.zimbra@efficios.com>
 <CALCETrXccCp8apoyUJV8kWLOavnFnenZoU-fbb6cOVZvWp-fnA@mail.gmail.com> <3358e696-43e9-15d3-9634-68e9da79e121@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3358e696-43e9-15d3-9634-68e9da79e121-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin
List-Id: linux-api@vger.kernel.org

On Fri, Oct 13, 2017 at 10:53 AM, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 10/13/2017 07:24 PM, Andy Lutomirski wrote:
>>
>> On Fri, Oct 13, 2017 at 7:27 AM, Mathieu Desnoyers
>> <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>>>
>>> ----- On Oct 13, 2017, at 9:56 AM, Florian Weimer fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
>>> wrote:
>>>
>>>> On 10/13/2017 03:40 PM, Mathieu Desnoyers wrote:
>>>>>
>>>>> The proposed ABI does not require to store any function pointer. For a
>>>>> given
>>>>> rseq_finish() critical section, pointers to specific instructions
>>>>> (within a
>>>>> function) are emitted at link-time into a struct rseq_cs:
>>>>>
>>>>> struct rseq_cs {
>>>>>           RSEQ_FIELD_u32_u64(start_ip);
>>>>>           RSEQ_FIELD_u32_u64(post_commit_ip);
>>>>>           RSEQ_FIELD_u32_u64(abort_ip);
>>>>>           uint32_t flags;
>>>>> } __attribute__((aligned(4 * sizeof(uint64_t))));
>>>>>
>>>>> Then, at runtime, the fast-path stores the address of that struct
>>>>> rseq_cs
>>>>> into the TLS struct rseq "rseq_cs" field.
>>>>>
>>>>> So all we store at runtime is a pointer to data, not a pointer to
>>>>> functions.
>>>>>
>>>>> But you seem to hint that having a pointer to data containing pointers
>>>>> to code
>>>>> may still be making it easier for exploit writers. Can you elaborate on
>>>>> the
>>>>> scenario ?
>>>>
>>>>
>>>> I'm concerned that the exploit writer writes a totally made up struct
>>>> rseq_cs object into writable memory, along with function pointers, and
>>>> puts the address of that in to the rseq_cs field.
>>>>
>>>> This would be comparable to how C++ vtable pointers are targeted
>>>> (including those in the glibc libio implementation of stdio streams).
>>>>
>>>> Does this answer your questions?
>>>
>>>
>>> Yes, it does. How about we add a "canary" field to the TLS struct rseq,
>>> e.g.:
>>>
>>> struct rseq {
>>>          union rseq_cpu_event u;
>>>          RSEQ_FIELD_u32_u64(rseq_cs);  -> pointer to struct rseq_cs
>>>          uint32_t flags;
>>>          uint32_t canary;   -> 32 low bits of rseq_cs ^ canary_mask
>>> };
>>>
>>> We could then add a "uint32_t canary_mask" argument to sys_rseq, e.g.:
>>>
>>> SYSCALL_DEFINE3(rseq, struct rseq __user *, rseq, uint32_t, canary_mask,
>>> int, flags);
>>>
>>> So a thread which does not care about hardening would simply register its
>>> struct rseq TLS with a canary mask of "0". Nothing changes on the
>>> fast-path.
>>>
>>> A thread belonging to a process that cares about hardening could use a
>>> random
>>> value as canary, and pass it as canary_mask argument to the syscall. The
>>> fast-path could then set the struct rseq "canary" value to
>>> (32-low-bits of rseq_cs) ^ canary_mask just surrounding the critical
>>> section,
>>> and set it back to 0 afterward.
>>>
>>> In the kernel, whenever the rseq_cs pointer would be loaded, its 32 low
>>> bits
>>> would be checked to match (canary ^ canary_mask). If it differs, then the
>>> kernel kills the process with SIGSEGV.
>>>
>>> Would that take care of your concern ?
>>>
>>
>> I would propose a slightly different solution: have the kernel verify
>> that it jumps to a code sequence that occurs just after some
>> highly-unlikely magic bytes in the text *and* that those bytes have
>> some signature that matches a signature in the struct rseq that's
>> passed in.
>
>
> And the signature is fixed at the time of the rseq syscall?

The point of the signature is to prevent an rseq landing pad from
being used out of context.  Actually getting the details right might
be tricky.

>
> Yes, that would be far more reliable.
>
> Thanks,
> Florian



-- 
Andy Lutomirski
AMA Capital Management, LLC
