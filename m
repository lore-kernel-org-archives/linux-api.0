From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH for 4.15 5/6] membarrier: x86: Provide core
 serializing command
Date: Thu, 9 Nov 2017 19:35:25 +0000 (UTC)
Message-ID: <452803516.12441.1510256125252.JavaMail.zimbra@efficios.com>
References: <20171108183514.3306-1-mathieu.desnoyers@efficios.com> <20171108183514.3306-6-mathieu.desnoyers@efficios.com> <CALCETrX4vZHxkWhLKBebZ+R_UE8pDsmVbpJzpyPt=ZgZB8w8iQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrX4vZHxkWhLKBebZ+R_UE8pDsmVbpJzpyPt=ZgZB8w8iQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, maged michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, gromer <gromer-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, x86 <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Nov 9, 2017, at 2:07 PM, Andy Lutomirski luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:

> On Wed, Nov 8, 2017 at 10:35 AM, Mathieu Desnoyers
> <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
> 
>> +/*
>> + * x86-64 implements return to user-space through sysret, which is not a
>> + * core-serializing instruction. Therefore, we need an explicit core
>> + * serializing instruction after going from kernel thread back to
>> + * user-space thread (active_mm moved back to current mm).
>> + */
>> +static inline void membarrier_arch_mm_sync_core(struct mm_struct *mm)
>> +{
>> +       if (likely(!(atomic_read(&mm->membarrier_state) &
>> +                       MEMBARRIER_STATE_SYNC_CORE)))
>> +               return;
>> +       sync_core();
>> +}
> 
> IMO there should be an extremely clear specification somewhere for
> what this function is supposed to do.
> 
> If I remember correctly, it's supposed to promise that the icache is
> synced before the next time we return to usermode for the current mm
> on this CPU.  If that's correct, then let's document it very
> explicitly and let's also drop the "membarrier" from the name -- it's
> a primitive we'll need anyway given the existing migration bug.

I understand that on x86 (specifically), synchronizing the icache and
doing a core serializing instruction may mean the same thing.

However, on architectures like ARM, icache sync differs from core
serialization. Those architectures typically have either a user-space
accessible instruction or a system call to perform the icache flush.
The missing part for JIT is core serialization (also called context
synchronization). icache flush is already handled by pre-existing
means.

So the promise here given by membarrier_arch_mm_sync_core() is that
a core serializing instruction is issued before the next time we return
to usermode on the current thread. However, we only need that guarantee
if the current thread's mm is a registered MEMBARRIER_{...}_SYNC_CORE user.

Regarding the existing migration bug, what I think you want is a kind
of weaker "sync_core()", which ensures that a core serializing
instruction is issued before the next time the current thread returns
to usermode.

It could be e.g.: set_tsk_need_core_sync() which would set a
TIF_NEED_CORE_SYNC thread flag on the current thread.

Clearly, when this kind of thread flag is introduced as an
optimization over sync_core(), I would like to use that. However,
I don't think it replaces the membarrier_arch_mm_sync_core() entirely,
given that it would not check for the mm membarrier "SYNC_CORE"
registration state. It appears to me to be merely an optimization over
directly invoking sync_core.

What I suggest is that I update the comment above
membarrier_arch_mm_sync_core to spell out more clearly that all we
need is to have a core serializing instruction issued before the next
time the current thread returns to user-space. I can still use
sync_core for now, and we can then improve the implementation
whenever a new thread flag is introduced. The new comment would look
like:

/*
 * x86-64 implements return to user-space through sysret, which is not a
 * core-serializing instruction. Therefore, we need an explicit core
 * serializing instruction after going from kernel thread back to
 * user-space thread (active_mm moved back to current mm).
 *
 * This function ensures that a core serializing instruction is issued
 * before the current thread returns to user-space.
 */

Thoughts ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
