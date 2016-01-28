From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v3 1/5] getcpu_cache system call: cache CPU number
 of running thread
Date: Thu, 28 Jan 2016 22:44:04 +0000 (UTC)
Message-ID: <950789004.7282.1454021044123.JavaMail.zimbra@efficios.com>
References: <1454014885-29012-1-git-send-email-mathieu.desnoyers@efficios.com> <1454014885-29012-2-git-send-email-mathieu.desnoyers@efficios.com> <alpine.DEB.2.11.1601282205290.3886@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1601282205290.3886@nanos>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Jan 28, 2016, at 4:52 PM, Thomas Gleixner tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org wrote:

> On Thu, 28 Jan 2016, Mathieu Desnoyers wrote:
> 
>> +static int __get_cpu_cache_ptr(int32_t __user **cpu_cache,
> 
> cpu_cache is __user ????

Note that I mimicked the "get_user()" macro: the first
argument to "get_cpu_cache_ptr()" is a variable within the
kernel address space, from which we take the address
and pass it as first parameter of __get_cpu_cache_ptr().

int32_t __user **cpu_cache is therefore the right typing
here. I had wrongfully assumed that compat_uptr_t contained
an implicit __user tagging, which is my error. This patch
addresses the current sparse warning:

diff --git a/kernel/getcpu_cache.c b/kernel/getcpu_cache.c
index f1251d1..7053611 100644
--- a/kernel/getcpu_cache.c
+++ b/kernel/getcpu_cache.c
@@ -63,7 +63,7 @@ static int __get_cpu_cache_ptr(int32_t __user **cpu_cache,
 {
 #ifdef CONFIG_COMPAT
        if (is_compat_task()) {
-               compat_uptr_t *compat_cachep = (compat_uptr_t *) cpu_cachep;
+               compat_uptr_t __user *compat_cachep = (compat_uptr_t __user *) cpu_cachep;
                compat_uptr_t compat_cache;
 
                if (get_user(compat_cache, compat_cachep))
@@ -84,7 +84,7 @@ static int put_cpu_cache_ptr(int32_t __user *cpu_cache,
 #ifdef CONFIG_COMPAT
        if (is_compat_task()) {
                compat_uptr_t compat_cache = ptr_to_compat(cpu_cache);
-               compat_uptr_t *compat_cachep = (compat_uptr_t *) cpu_cachep;
+               compat_uptr_t __user *compat_cachep = (compat_uptr_t __user *) cpu_cachep;
 
                return put_user(compat_cache, compat_cachep);
        }


> 
>> +		int32_t __user * __user *cpu_cachep)
>> +{
>> +#ifdef CONFIG_COMPAT
>> +	if (is_compat_task()) {
>> +		compat_uptr_t *compat_cachep = (compat_uptr_t *) cpu_cachep;
>> +		compat_uptr_t compat_cache;
>> +
>> +		if (get_user(compat_cache, compat_cachep))
>> +			return -EFAULT;
>> +		*cpu_cache = compat_ptr(compat_cache);
> 
> sparse should have told you that :)
> 
>> +		return 0;
>> +	}
>> +#endif
>> +	return get_user(*cpu_cache, cpu_cachep);
>> +}
>> +
>> +#define get_cpu_cache_ptr(cpu_cache, cpu_cachep)	\
>> +	__get_cpu_cache_ptr(&(cpu_cache), cpu_cachep)
>> +
>> +static int put_cpu_cache_ptr(int32_t __user *cpu_cache,
> 
> Ditto
> 
>> +		int32_t __user * __user *cpu_cachep)
>> +{
>> +#ifdef CONFIG_COMPAT
>> +	if (is_compat_task()) {
>> +		compat_uptr_t compat_cache = ptr_to_compat(cpu_cache);
>> +		compat_uptr_t *compat_cachep = (compat_uptr_t *) cpu_cachep;
>> +
>> +		return put_user(compat_cache, compat_cachep);
>> +	}
>> +#endif
>> +	return put_user(cpu_cache, cpu_cachep);
>> +}
>> +		current->cpu_cache = cpu_cache;
>> +		/*
>> +		 * Migration checks the getcpu cache to see whether the
>> +		 * notify_resume flag should be set.
>> +		 * Therefore, we need to ensure that the scheduler sees
>> +		 * the getcpu cache pointer update before we update the getcpu
>> +		 * cache content with the current CPU number.
>> +		 */
>> +		barrier();
> 
> And how does that barrier ensure this? Not at all. And why would the scheduler
> care? All the scheduler cares about is tsk->cpu_cache.

The case I want to ensure never happens is the following:

Compiler reorders storing the address of current->cpu_cache after
the getcpu_cache_update() store to *cpu_cache. In between, the
scheduler preempts and migrates the task, but does not set the
resume notifier thread flag because it still see a NULL
current->cpu_cache. We therefore return to userspace with a
wrong CPU number in the cache.

The compiler barrier enforces ordering of the current->cpu_cache
address store before updating the *cpu_cache.

> 
>> +		/*
>> +		 * Do an initial cpu cache update to ensure we won't hit
>> +		 * SIGSEGV if put_user() fails in the resume notifier.
>> +		 */
> 
> If you get migrated before that call, then you SIGSEGV nevertheless.

No, because the SIGSEGV is only triggered when returning to userspace.
We are still in the system call here. All we care about in the migration
schedule code is to check the current->cpu_cache to see if we need to
raise the resume notifier flag. No userspace access there.

> 
> You need that call here for the case you are NOT migrated before returning to
> user space because otherwise the variable is not updated.

This call has two goals: indeed, populating the initial current CPU value,
but also checking if the address is valid (and -EFAULT on error).

> 
> If you want to verify that user address without a potential SIGSEGV, then you
> need to do this before setting current->cpu_cache. You still need the update
> after setting current->cpu_cache.

No, because the SIGSEGV can only be triggered by the resume
notifier when returning to userspace from the getcpu_cache
system call. All we need to do is to ensure the resume notifier
sees a NULL current->cpu_cache, and we don't have any segfault.

Does it make sense, or am I missing something ?

Thanks,

Mathieu

> 
>> +		if (getcpu_cache_update(cpu_cache)) {
>> +			current->cpu_cache = NULL;
>> +			return -EFAULT;
>> +		}
>> +		return 0;
> 
> Thanks,
> 
> 	tglx

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
