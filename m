From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: futex(2) man page update help request
Date: Sat, 17 Jan 2015 10:16:34 +0100
Message-ID: <54BA2872.5040003@gmail.com>
References: <537346E5.4050407@gmail.com> <CF98E3EF.90564%dvhart@linux.intel.com> <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com> <5373D0CA.2050204@redhat.com> <alpine.DEB.2.02.1405150121230.6261@ionos.tec.linutronix.de> <CAKgNAkjQ5Dd_U9OojXdgeforpRevvPHNFAw99kBFPCwHgf7Ggg@mail.gmail.com> <alpine.DEB.2.02.1405151144390.6261@ionos.tec.linutronix.de> <CF9A731D.913E6%dvhart@linux.intel.com> <54B7D8D4.2070203@gmail.com> <D0DEF1AE.B7EDE%dvhart@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <D0DEF1AE.B7EDE%dvhart@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Darren Hart <dvhart@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: mtk.manpages@gmail.com, Carlos O'Donell <carlos@redhat.com>, Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>, "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, Linux API <linux-api@vger.kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, Jan Kiszka <jan.kiszka@siemens.com>
List-Id: linux-api@vger.kernel.org

Hello Darren,

On 01/17/2015 02:33 AM, Darren Hart wrote:
> Corrected Davidlohr's email address.

Thanks!

> On 1/15/15, 7:12 AM, "Michael Kerrisk (man-pages)"
> <mtk.manpages@gmail.com> wrote:
> 
>> Hello Darren,
>>
>> I give you the same apology as to Thomas for the
>> long-delayed response to your mail.
>>
>> And I repeat my note to Thomas:
>> In the next day or two, I hope to send out the new version
>> of the futex(2) page for review. The new draft is a bit
>> bigger (okay -- 4 x bigger) than the current page. And there
>> are a quite number of FIXMEs that I've placed in the page
>> for various points--some minor, but a few major--that need
>> to be checked or fixed. Would you have some time to review
>> that page?
> 
> I'll make the time for that. I've wanted to see this for a while, so thank
> you for working on it!

Great!

>> In the meantime, I have a couple of questions, which, if
>> you could answer them, I would work some changes into the
>> page before sending.
>>
>> 1. In various places, distinction is made between non-PI
>>   futexs and PI futexes. But what determines that distinction?
>>   From the kernel's perspective, hat make a futex one type
>>   or another? I presume it is to do with the types of blocking
>>   waiters on the futex, but it would be good to have a formal
>>   definition.
> 
> You're right in that a uaddr is a uaddr is a uaddr. Also "there is no such
> thing as a futex", it doesn't exist as any kind of identifiable object, so
> these discussions can get rather confusing :-)

So, I want to make sure that I am clear on what you mean you say this.
You say "there is no such thing as a futex" because from the kernel's
perspective there is no visible entity in the uncontended case
(where everything can be dealt with in user space). And from user-space,
in the uncontended case all we're doing is memory operations. Right?

On the other hand, from a kernel perspective, we could say that a 
futex "exists" in the contended phases, since the kernel has allocated
state associated with the uaddr. Right?

> A "futex" becomes a PI futex when it is "created" via a PI futex op code.

Precisely which PI op codes? Is it: FUTEX_LOCK_PI, FUTEX_TRYLOCK_PI, and
FUTEX_CMP_REQUEUE_PI, and not FUTEX_WAIT_REQUEUE_PI or FUTEX_UNLOCK_PI?

> At that point, the syscall will ensure a pi_state is populated for the
> futex_q entry. See futex_lock_pi() for example. Before the locks are
> taken, there is a call to refill_pi_state_cache() which preps a pi_state
> for assignment later in futex_lock_pi_atomic(). This pi_state provides the
> necessary linkage to perform the priority boosting in the event of a
> priority inversion. This is handled externally from the futexes via the
> rt_mutex construct.
> 
> Clear as mud?

Not quite that bad, but... The thing is, still, the man page has text
such as the following (based on your wording):

       FUTEX_CMP_REQUEUE_PI (since Linux 2.6.31)
              This operation is a PI-aware variant of FUTEX_CMP_REQUEUE.
              It    requeues    waiters    that    are    blocked    via
              FUTEX_WAIT_REQUEUE_PI  on uaddr from a non-PI source futex
              (uaddr) to a PI target futex (uaddr2).

And elsewhere you said

    EINVAL is returned if the non-pi to pi or 
    op pairing semantics are violated.

When someone in user-land (e.g., me) reads pieces like that, they then 
want to find somewhere in the man page a description of what makes a 
futex a *PI futex* and probably some statements of the distinction 
between PI and non-PI futexes. And those statements should be from a 
perspective that is somewhat comprehensible to user-space. I'm not
yet confident that I can do that. Do you care to take a shot at it?

>> 2. Can you say something about the pairing requirements of
>>   FUTEX_WAIT_REQUEUE_PI and FUTEX_CMP_REQUEUE_PI.
>>   What is the requirement and why do we need it?
> 
> Briefly, these op codes exist to support a fairly specific use case:
> support for PI aware pthread condvars (glibc patch acceptance STILL
> PENDING FOR LOVE OF EVERYTHING HOLY WHY?!?!?! 

Yes, Jan Kiszka recently alerted me to the existence of 
https://sourceware.org/bugzilla/show_bug.cgi?id=11588
and I still have some text that you proposed (mail titled
("Pthread Condition Variables and Priority Inversion")
quite a long time ago for the pthread_cond_timedwait() page.
One day, when that page exists, I'll try to remember to add it.

> But is shipped with various
> PREEMPT_RT enabled Linux systems. Because these calls are paired, and more
> of the logic can happen on the kernel side (to preserve ownership of an
> rt_mutex with waiters), so in order to ensure userspace and kernelspace
> remain in sync, we pre-specify the target of the requeue in
> futex_wait_requeue_pi. This also limits the attack surface by only
> supporting exactly what it was meant to do. The corner cases get insane
> otherwise.

Thanks. I've added some text on pairing, based on your text above.

> We could walk through the various ways in which it would break if these
> pairing restrictions were not in place, but I'll have to take some serious
> time to page all those into working memory. Let me know if we need more
> detail here and I will.

I don't think we need that much level of detail.

>> Most of the rest of this mail is just a checklist noting
>> what I did with your comments. No response is needed
>> in most cases, but there is one that I have marked with
>> "???". If you could reply to that. I'd be grateful.
> 
> ...
> 
>>> For all the PI opcodes, we should probably mention something about the
>>> futex value scheme (TID), whereas the other opcodes do not require any
>>> specific value scheme.
>>>
>>> No Owner:	0
>>> Owner:		TID
>>> Waiters:	TID | FUTEX_WAITERS
>>>
>>> This is the relevant section from the referenced paper:
>>> 				
>>> The PI futex operations diverge from the oth-
>>> ers in that they impose a policy describing how
>>> the futex value is to be used. If the lock is un-
>>> owned, the futex value shall be 0. If owned, it
>>> shall be the thread id (tid) of the owning thread.
>>> If there are threads contending for the lock, then
>>> the FUTEX_WAITERS flag is set. With this policy in
>>> place, userspace can atomically acquire an unowned
>>> lock or release an uncontended lock using an atomic
>>> instruction and their own tid. A non-zero futex
>>> value will force waiters into the kernel to lock. The
>>> FUTEX_WAITERS flag forces the owner into the kernel
>>> to unlock. If the callers are forced into the kernel,
>>> they then deal directly with an underlying rt_mutex
>>> which implements the priority inheritance semantics.
>>> After the rt_mutex is acquired, the futex value is up-
>>> dated accordingly, before the calling thread returns
>>> to userspace.
>>>
>>> It is important to note that the kernel will update the futex value
>>> prior
>>> to returning to userspace. Unlike other futex op codes,
>>> FUTEX_CMP_REUQUE_PI (and FUTEX_WAIT_REQUEUE_PI, FUTEX_LOCK_PI are
>>> designed
>>> for the implementation of very specific IPC mechanisms).
>>
>> ??? Great text. May I presume that I can take this text
>> and freely adapt it for the man page? (Actually, this is a
>> request for forgiveness, rather than permission :-).)
> 
> Thanks, and no objection from me.

Thanks.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
