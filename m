From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 1/5] getcpu_cache system call: cache CPU number of
 running thread
Date: Fri, 26 Feb 2016 22:24:50 -0800
Message-ID: <56D14132.5050100@zytor.com>
References: <1456270120-7560-1-git-send-email-mathieu.desnoyers@efficios.com>
 <2135602720.7810.1456420671941.JavaMail.zimbra@efficios.com>
 <20160226113304.GA6356@twins.programming.kicks-ass.net>
 <alpine.DEB.2.11.1602261719440.3638@nanos>
 <967083634.8940.1456507201156.JavaMail.zimbra@efficios.com>
 <alpine.DEB.2.11.1602261855100.3638@nanos>
 <724964987.9217.1456518255392.JavaMail.zimbra@efficios.com>
 <7096DA23-3908-40DC-A46B-C4CF2252CEE8@zytor.com>
 <1150363257.9781.1456533630895.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1150363257.9781.1456533630895.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 02/26/16 16:40, Mathieu Desnoyers wrote:
>>
>> I think it would be a good idea to make this a general pointer for the kernel to
>> be able to write per thread state to user space, which obviously can't be done
>> with the vDSO.
>>
>> This means the libc per thread startup should query the kernel for the size of
>> this structure and allocate thread local data accordingly.  We can then grow
>> this structure if needed without making the ABI even more complex.
>>
>> This is more than a system call: this is an entirely new way for userspace to
>> interact with the kernel.  Therefore we should make it a general facility.
>
> I'm really glad to see I'm not the only one seeing potential for
> genericity here. :-) This is exactly what I had in mind
> last year when proposing the thread_local_abi() system call:
> a generic way to register an extensible per-thread data structure
> so the kernel can communicate with user-space and vice-versa.
>
> Rather than having the libc query the kernel for size of the structure,
> I would recommend that libc tells the kernel the size of the thread-local
> ABI structure it supports. The idea here is that both the kernel and libc
> need to know about the fields in that structure to allow a two-way
> interaction. Fields known only by either the kernel or userspace
> are useless for a given thread anyway. This way, libc could statically
> define the structure.

Big fat NOPE there.  Why?  Because it means that EVERY interaction with 
this memory, no matter how critical, needs to be conditionalized. 
Furthermore, userspace != libc.  Applications or higher-layer libraries 
might have more information than the running libc about additional 
fields, but with your proposal libc would gate them.

As far as the kernel providing the size in the structure (alone) -- I 
*really* hope you can see what is wrong with that!!  That doesn't mean 
we can't provide it in the structure as well, and that too might avoid 
the skipped libc problem.

> I would be tempted to also add "features" flags, so both user-space
> and the kernel could tell each other what they support: user-space
> would announce the set of features it supports, and it could also
> query the kernel for the set of supported features. One simple approach
> would be to use a uint64_t as type for those feature flags, and
> reserve the last bit for extending to future flags if we ever have
> more than 64.
>
> Thoughts ?

It doesn't seem like it would hurt, although the size of the flags field 
could end up being an issue.

	-hpa
