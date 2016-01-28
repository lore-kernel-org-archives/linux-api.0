From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v2 1/3] getcpu_cache system call: cache CPU number
 of running thread
Date: Thu, 28 Jan 2016 17:41:10 +0000 (UTC)
Message-ID: <95352831.6907.1454002870641.JavaMail.zimbra@efficios.com>
References: <1453913683-28915-1-git-send-email-mathieu.desnoyers@efficios.com> <1453913683-28915-2-git-send-email-mathieu.desnoyers@efficios.com> <20160128031213.GA55682@ast-mbp.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160128031213.GA55682-+o4/htvd0TDFYCXBM6kdu7fOX0fSgVTm@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Jan 27, 2016, at 10:12 PM, Alexei Starovoitov alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> On Wed, Jan 27, 2016 at 11:54:41AM -0500, Mathieu Desnoyers wrote:
>> Expose a new system call allowing threads to register one userspace
>> memory area where to store the CPU number on which the calling thread is
>> running. Scheduler migration sets the TIF_NOTIFY_RESUME flag on the
>> current thread. Upon return to user-space, a notify-resume handler
>> updates the current CPU value within each registered user-space memory
>> area. User-space can then read the current CPU number directly from
>> memory.
>> 
>> This getcpu cache is an improvement over current mechanisms available to
>> read the current CPU number, which has the following benefits:
>> 
>> - 44x speedup on ARM vs system call through glibc,
>> - 14x speedup on x86 compared to calling glibc, which calls vdso
>>   executing a "lsl" instruction,
>> - 11x speedup on x86 compared to inlined "lsl" instruction,
>> - Unlike vdso approaches, this cached value can be read from an inline
>>   assembly, which makes it a useful building block for restartable
>>   sequences.
>> - The getcpu cache approach is portable (e.g. ARM), which is not the
>>   case for the lsl-based x86 vdso.
>> 
>> On x86, yet another possible approach would be to use the gs segment
>> selector to point to user-space per-cpu data. This approach performs
>> similarly to the getcpu cache, but it has two disadvantages: it is
>> not portable, and it is incompatible with existing applications already
>> using the gs segment selector for other purposes.
> 
> Great work!

Thanks!

> The only concern is that every arch has to implement
> a call to getcpu_cache_handle_notify_resume() to be able to do put_user()
> from the safe place which is not pretty.

Indeed, I've considered the alternatives before going down that
route. The idea you propose below was among those I eventually
rejected. Here is why:

> Can we do better?
> Here is one crazy idea:
> The kernel can allocate the memory that user space will mmap()
> (ideally reusing perf ring-buffer alloc/mmap mechanism).
> then the kernel can just write cpuid into it from any place.

This requires the memory to be "mlock'd" or equivalent, because the
kernel cannot page fault when writing to it. That memory then becomes
impossible to swap out.

Also, how large should this mmap() area be ? Since there can be a
very large amount of threads created within a process, it would
probably need to be extended at some point. Then how do you manage
memory fragmentation, e.g. if there is no room left to extend the
mapping when a thread appears ?

> Then user space will register the 'offset' into this space for a given
> user space thread (or kernel will return it or ptr within this area)

This seems to require a "thread ID allocation" mechanism which allocates
IDs for threads starting from 0, with re-use of IDs when thread go away.
So we're adding a free-list of IDs per process or something similar.

In order to eliminate false-sharing, each "entry" in this array
would need to be at least cacheline-sized, which leads to wasted
memory space and cache compared to the TLS approach.

> and in finish_task_switch() the kernel will do
> *task->offset_converted_to_ptr = smp_processor_id();
> At init time the user space will do:
> __thread int *cpuid;
> cpuid = (void*)addr_from_mmap + registered_offset;
> and at runtime the '*cpuid' will give userspace what it wants.
> It's two loads to get cpuid vs getcpu_cache approach, but
> probably still fast enough?

Those per-cpu fast paths are extremely fast (they run in a couple
of nanoseconds). Adding a pointer dereference on the fast path
will likely be measurable.

> And this way we can have a mechanism to return much bigger
> structures to userspace. Kernel can update such area from any
> place and user space only needs one extra load to get the base of
> such per-cpu area and another load to fetch cpuid.
> Thoughts?

>From my understanding, your mmap-array proposal adds more complexity
than the one call in each architecture's resume notifier it's trying
to remove. It requires unswappable memory, a thread ID allocator, and
leads to a slower fast-path due to the extra pointer dereference. I
don't see this approach as a net gain over the call in the arch
resume notifier.

Thanks for the feedback!

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
