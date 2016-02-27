From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 1/5] getcpu_cache system call: cache CPU number of running thread
Date: Sat, 27 Feb 2016 07:04:18 -0800
Message-ID: <ED301F1F-EB5C-4477-8A04-BBCC984CF7D6@zytor.com>
References: <1456270120-7560-1-git-send-email-mathieu.desnoyers@efficios.com> <alpine.DEB.2.11.1602261719440.3638@nanos> <967083634.8940.1456507201156.JavaMail.zimbra@efficios.com> <alpine.DEB.2.11.1602261855100.3638@nanos> <724964987.9217.1456518255392.JavaMail.zimbra@efficios.com> <7096DA23-3908-40DC-A46B-C4CF2252CEE8@zytor.com> <1150363257.9781.1456533630895.JavaMail.zimbra@efficios.com> <56D14132.5050100@zytor.com> <2053850250.10158.1456582501604.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2053850250.10158.1456582501604.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On February 27, 2016 6:15:01 AM PST, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>----- On Feb 27, 2016, at 1:24 AM, H. Peter Anvin hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org wrote:
>
>> On 02/26/16 16:40, Mathieu Desnoyers wrote:
>>>>
>>>> I think it would be a good idea to make this a general pointer for
>the kernel to
>>>> be able to write per thread state to user space, which obviously
>can't be done
>>>> with the vDSO.
>>>>
>>>> This means the libc per thread startup should query the kernel for
>the size of
>>>> this structure and allocate thread local data accordingly.  We can
>then grow
>>>> this structure if needed without making the ABI even more complex.
>>>>
>>>> This is more than a system call: this is an entirely new way for
>userspace to
>>>> interact with the kernel.  Therefore we should make it a general
>facility.
>>>
>>> I'm really glad to see I'm not the only one seeing potential for
>>> genericity here. :-) This is exactly what I had in mind
>>> last year when proposing the thread_local_abi() system call:
>>> a generic way to register an extensible per-thread data structure
>>> so the kernel can communicate with user-space and vice-versa.
>>>
>>> Rather than having the libc query the kernel for size of the
>structure,
>>> I would recommend that libc tells the kernel the size of the
>thread-local
>>> ABI structure it supports. The idea here is that both the kernel and
>libc
>>> need to know about the fields in that structure to allow a two-way
>>> interaction. Fields known only by either the kernel or userspace
>>> are useless for a given thread anyway. This way, libc could
>statically
>>> define the structure.
>> 
>> Big fat NOPE there.  Why?  Because it means that EVERY interaction
>with
>> this memory, no matter how critical, needs to be conditionalized.
>> Furthermore, userspace != libc.  Applications or higher-layer
>libraries
>> might have more information than the running libc about additional
>> fields, but with your proposal libc would gate them.
>
>Good point!
>
>> 
>> As far as the kernel providing the size in the structure (alone) -- I
>> *really* hope you can see what is wrong with that!!  That doesn't
>mean
>> we can't provide it in the structure as well, and that too might
>avoid
>> the skipped libc problem.
>
>Indeed, libc would need to query the size before it can allocate
>the structure.
>
>> 
>>> I would be tempted to also add "features" flags, so both user-space
>>> and the kernel could tell each other what they support: user-space
>>> would announce the set of features it supports, and it could also
>>> query the kernel for the set of supported features. One simple
>approach
>>> would be to use a uint64_t as type for those feature flags, and
>>> reserve the last bit for extending to future flags if we ever have
>>> more than 64.
>>>
>>> Thoughts ?
>> 
>> It doesn't seem like it would hurt, although the size of the flags
>field
>> could end up being an issue.
>
>I'm concerned that this thread-local ABI structure may become messy.
>Let's just imagine how we would first introduce a "cpu_id" field
>(int32_t),
>and eventually add a "seqnum" field for rseq in the future (unsigned
>long).
>
>Both fields need to be read with single-copy semantics as volatile
>reads, and both need to be naturally aligned. However, I'm tempted
>to use the "packed" attribute on the structure since it's an ABI
>between kernel and user-space. A pretty bad example of what this
>could become, due to alignment constraints, looks like:
>
>/* This structure needs to be aligned on pointer size. */
>struct thread_local_abi {
>        int32_t cpu_id;
>        int32_t __unused1;
>        unsigned long seqnum;
>        /* Add new fields at the end. */
>} __attribute__((packed));
>
>And this is just a start. It may become messier as we append
>new fields in the future.
>
>The main argument I currently see in favor of having this
>meta system call for all per-thread features is to only
>maintain a single pointer in the kernel task_struct rather
>than one per thread-local feature.
>
>If the goal is really to keep the burden on the task struct
>small, we could use kmalloc()/kfree() to allocate and free an
>array of pointers to the various per-thread features, rather
>than putting them directly in task_struct. We could keep a
>mask of the enabled features in the task struct too (which
>we will likely have to do even if we go the the thread-local
>ABI meta system call).
>
>Having this per-task allocated pointer array at kernel-level
>would allow us to have one system call per feature, with clear
>semantics, without evolving a messy thread-local ABI structure
>due to all sorts of alignment constraints.
>
>Thoughts ?
>
>Thanks,
>
>Mathieu

I think you are worried about problems which we have already solved many, many times - structures are very common in the user space ABI and we know how to deal with this.

And when you say:

> However, I'm tempted
> to use the "packed" attribute on the structure
> since it's an ABI
> between kernel and user-space.

and mention "unsigned long" in a user space ABI all I can think of that you really have not followed the issues of user space ABI design as they have evolved over the last 20 years.

Simply put: non-problem.  
-- 
Sent from my Android device with K-9 Mail. Please excuse brevity and formatting.
