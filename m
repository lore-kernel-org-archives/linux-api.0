From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] getcpu_cache system call: cache CPU number of
 running thread
Date: Tue, 5 Jan 2016 17:34:49 +0000 (UTC)
Message-ID: <2105119117.338119.1452015289206.JavaMail.zimbra@efficios.com>
References: <1451977320-4886-1-git-send-email-mathieu.desnoyers@efficios.com> <1451977320-4886-2-git-send-email-mathieu.desnoyers@efficios.com> <20160105120400.GD10705@arm.com> <1079064730.338115.1452015105259.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1079064730.338115.1452015105259.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Jan 5, 2016, at 12:31 PM, Mathieu Desnoyers mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org wrote:

> ----- On Jan 5, 2016, at 7:04 AM, Will Deacon will.deacon-5wv7dgnIgG8@public.gmane.org wrote:
> 
>> Hi Mathieu,
>> 
>> On Tue, Jan 05, 2016 at 02:01:58AM -0500, Mathieu Desnoyers wrote:
>>> Expose a new system call allowing threads to register userspace memory
>>> areas where to store the CPU number on which the calling thread is
>>> running. Scheduler migration sets the TIF_NOTIFY_RESUME flag on the
>>> current thread. Upon return to user-space, a notify-resume handler
>>> updates the current CPU value within each registered user-space memory
>>> area. User-space can then read the current CPU number directly from
>>> memory.
>> 
>> What guarantees do you provide if a thread other than the one which
>> registered the cache tries to access the value? Obviously, there's a
>> potential data race here with the kernel issuing a parallel update, but
>> are you intending to have single-copy atomicity semantics (like relaxed
>> atomics in C11) or is this simply going to give you junk?
>> 
>> I ask because, in the absence of alignment checks on the cache pointer,
>> we can't guarantee single-copy atomicity on ARM when the kernel writes
>> the current CPU value.
> 
> Hi Will,
> 
> This is an excellent question. My initial thinking was that only the
> thread registering the cache would read it, but now that you ask,
> there might be use-cases where other threads would be interested in
> reading each other's current CPU number.
> 
> For instance, an application could create a linked list or hash map
> of thread control structures, which could contain the current CPU
> number of each thread. A dispatch thread could then traverse or
> lookup this structure to see on which CPU each thread is running and
> do work queue dispatch or scheduling decisions accordingly.
> 
> This use-case would imply ensuring that reading the current CPU value
> from another CPU will never result in reading a garbage value.
> 
> If we indeed intend to enable this use-case, we should:
> 
> 1) Add an alignment check on the cpu_cache pointer. Should we
>   return -EINVAL if unaligned ?
> 2) Document this alignment requirement in the man page, and the
>   atomicity guarantees it provides,

Related question: if we check that cpu_cache pointer is aligned
on 4 bytes, does put_user() then guarantee single-copy atomicity
on all architectures ?

Thanks,

Mathieu

> 
> The tiny downside of having this alignment requirement is that
> it would not be possible to put the cpu_cache into a packed
> structure. I don't think anyone would care though.
> 
> Thanks!
> 
> Mathieu
> 
> 
>> 
>> Cheers,
>> 
>> Will
> 
> --
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
