From: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: futex(2) man page update help request
Date: Fri, 16 Jan 2015 17:33:05 -0800
Message-ID: <D0DEF1AE.B7EDE%dvhart@linux.intel.com>
References: <537346E5.4050407@gmail.com>
 <CF98E3EF.90564%dvhart@linux.intel.com>
 <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com>
 <5373D0CA.2050204@redhat.com>
 <alpine.DEB.2.02.1405150121230.6261@ionos.tec.linutronix.de>
 <CAKgNAkjQ5Dd_U9OojXdgeforpRevvPHNFAw99kBFPCwHgf7Ggg@mail.gmail.com>
 <alpine.DEB.2.02.1405151144390.6261@ionos.tec.linutronix.de>
 <CF9A731D.913E6%dvhart@linux.intel.com>
 <54B7D8D4.2070203@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54B7D8D4.2070203-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Corrected Davidlohr's email address.

On 1/15/15, 7:12 AM, "Michael Kerrisk (man-pages)"
<mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

>Hello Darren,
>
>I give you the same apology as to Thomas for the
>long-delayed response to your mail.
>
>And I repeat my note to Thomas:
>In the next day or two, I hope to send out the new version
>of the futex(2) page for review. The new draft is a bit
>bigger (okay -- 4 x bigger) than the current page. And there
>are a quite number of FIXMEs that I've placed in the page
>for various points--some minor, but a few major--that need
>to be checked or fixed. Would you have some time to review
>that page?

I'll make the time for that. I've wanted to see this for a while, so thank
you for working on it!

> 
>
>In the meantime, I have a couple of questions, which, if
>you could answer them, I would work some changes into the
>page before sending.
>
>1. In various places, distinction is made between non-PI
>   futexs and PI futexes. But what determines that distinction?
>   From the kernel's perspective, hat make a futex one type
>   or another? I presume it is to do with the types of blocking
>   waiters on the futex, but it would be good to have a formal
>   definition.

You're right in that a uaddr is a uaddr is a uaddr. Also "there is no such
thing as a futex", it doesn't exist as any kind of identifiable object, so
these discussions can get rather confusing :-)

A "futex" becomes a PI futex when it is "created" via a PI futex op code.
At that point, the syscall will ensure a pi_state is populated for the
futex_q entry. See futex_lock_pi() for example. Before the locks are
taken, there is a call to refill_pi_state_cache() which preps a pi_state
for assignment later in futex_lock_pi_atomic(). This pi_state provides the
necessary linkage to perform the priority boosting in the event of a
priority inversion. This is handled externally from the futexes via the
rt_mutex construct.

Clear as mud?


>
>2. Can you say something about the pairing requirements of
>   FUTEX_WAIT_REQUEUE_PI and FUTEX_CMP_REQUEUE_PI.
>   What is the requirement and why do we need it?

Briefly, these op codes exist to support a fairly specific use case:
support for PI aware pthread condvars (glibc patch acceptance STILL
PENDING FOR LOVE OF EVERYTHING HOLY WHY?!?!?! But is shipped with various
PREEMPT_RT enabled Linux systems. Because these calls are paired, and more
of the logic can happen on the kernel side (to preserve ownership of an
rt_mutex with waiters), so in order to ensure userspace and kernelspace
remain in sync, we pre-specify the target of the requeue in
futex_wait_requeue_pi. This also limits the attack surface by only
supporting exactly what it was meant to do. The corner cases get insane
otherwise.

We could walk through the various ways in which it would break if these
pairing restrictions were not in place, but I'll have to take some serious
time to page all those into working memory. Let me know if we need more
detail here and I will.

>
>Most of the rest of this mail is just a checklist noting
>what I did with your comments. No response is needed
>in most cases, but there is one that I have marked with
>"???". If you could reply to that. I'd be grateful.

...

>> For all the PI opcodes, we should probably mention something about the
>> futex value scheme (TID), whereas the other opcodes do not require any
>> specific value scheme.
>> 
>> No Owner:	0
>> Owner:		TID
>> Waiters:	TID | FUTEX_WAITERS
>> 
>> This is the relevant section from the referenced paper:
>> 				
>> The PI futex operations diverge from the oth-
>> ers in that they impose a policy describing how
>> the futex value is to be used. If the lock is un-
>> owned, the futex value shall be 0. If owned, it
>> shall be the thread id (tid) of the owning thread.
>> If there are threads contending for the lock, then
>> the FUTEX_WAITERS flag is set. With this policy in
>> place, userspace can atomically acquire an unowned
>> lock or release an uncontended lock using an atomic
>> instruction and their own tid. A non-zero futex
>> value will force waiters into the kernel to lock. The
>> FUTEX_WAITERS flag forces the owner into the kernel
>> to unlock. If the callers are forced into the kernel,
>> they then deal directly with an underlying rt_mutex
>> which implements the priority inheritance semantics.
>> After the rt_mutex is acquired, the futex value is up-
>> dated accordingly, before the calling thread returns
>> to userspace.
>>
>> It is important to note that the kernel will update the futex value
>>prior
>> to returning to userspace. Unlike other futex op codes,
>> FUTEX_CMP_REUQUE_PI (and FUTEX_WAIT_REQUEUE_PI, FUTEX_LOCK_PI are
>>designed
>> for the implementation of very specific IPC mechanisms).
>
>??? Great text. May I presume that I can take this text
>and freely adapt it for the man page? (Actually, this is a
>request for forgiveness, rather than permission :-).)

Thanks, and no objection from me.

--
Darren Hart
Intel Open Source Technology Center
