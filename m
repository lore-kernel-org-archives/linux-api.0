From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v2 1/3] getcpu_cache system call: cache CPU number
 of running thread
Date: Wed, 27 Jan 2016 17:31:58 +0000 (UTC)
Message-ID: <671969438.6129.1453915918933.JavaMail.zimbra@efficios.com>
References: <1453913683-28915-1-git-send-email-mathieu.desnoyers@efficios.com> <1453913683-28915-2-git-send-email-mathieu.desnoyers@efficios.com> <alpine.DEB.2.11.1601271813290.3886@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1601271813290.3886@nanos>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Jan 27, 2016, at 12:22 PM, Thomas Gleixner tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org wrote:

> On Wed, 27 Jan 2016, Mathieu Desnoyers wrote:
>> +/*
>> + * sys_getcpu_cache - setup getcpu cache for caller thread
>> + */
>> +SYSCALL_DEFINE2(getcpu_cache, int32_t __user **, cpu_cachep, int, flags)
>> +{
>> +	int32_t __user *cpu_cache;
>> +
>> +	if (unlikely(flags))
>> +		return -EINVAL;
>> +	/* Check if cpu_cache is already registered. */
>> +	if (current->cpu_cache) {
>> +		if (put_user(current->cpu_cache, cpu_cachep))
>> +			return -EFAULT;
>> +		return 0;
>> +	}
> 
> This is really odd. How is the caller supposed to differentiate between:
> 
>  1) Get the installed cpucache pointer
> 
>  2) Set the cpucache pointer
> 
> We really want clearly seperated functionality here.
> 
>   getcpu_cache(ptr, GET_CACHEP);
>   
> and
> 
>   getcpu_cache(ptr, SET_CACHEP);
> 
>    Returns -EBUSY if current->cpu_cache is already set, except we allow
>    replacing the pointer.

Sounds fair. What is the recommended typing for "ptr" then ?
uint32_t ** or uint32_t * ?

It would be expected to pass a "uint32_t *" for the set
operation, but the "get" operation requires a "uint32_t **".

Also, I'd be tempted to put the GET/SET operation selector as
a first parameter.

Thanks,

Mathieu

> 
> Thanks,
> 
> 	tglx

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
