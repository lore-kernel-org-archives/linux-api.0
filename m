From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [RFC PATCH for 4.15 5/6] membarrier: x86: Provide core
 serializing command
Date: Thu, 9 Nov 2017 17:19:34 -0800
Message-ID: <CALCETrUqGBe7S0RvAtk19vAry4bEHS09JwkhqgNTpAmw=rK2Yw@mail.gmail.com>
References: <20171108183514.3306-1-mathieu.desnoyers@efficios.com>
 <20171108183514.3306-6-mathieu.desnoyers@efficios.com> <CALCETrX4vZHxkWhLKBebZ+R_UE8pDsmVbpJzpyPt=ZgZB8w8iQ@mail.gmail.com>
 <452803516.12441.1510256125252.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <452803516.12441.1510256125252.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andy Lutomirski <luto@kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, Andrew Hunter <ahh@google.com>, maged michael <maged.michael@gmail.com>, gromer <gromer@google.com>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Dave Watson <davejwatson@fb.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrea Parri <parri.andrea@gmail.com>, x86 <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 9, 2017 at 11:35 AM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
> ----- On Nov 9, 2017, at 2:07 PM, Andy Lutomirski luto@kernel.org wrote:
>
>> On Wed, Nov 8, 2017 at 10:35 AM, Mathieu Desnoyers
>> <mathieu.desnoyers@efficios.com> wrote:
>>
>>> +/*
>>> + * x86-64 implements return to user-space through sysret, which is not a
>>> + * core-serializing instruction. Therefore, we need an explicit core
>>> + * serializing instruction after going from kernel thread back to
>>> + * user-space thread (active_mm moved back to current mm).
>>> + */
>>> +static inline void membarrier_arch_mm_sync_core(struct mm_struct *mm)
>>> +{
>>> +       if (likely(!(atomic_read(&mm->membarrier_state) &
>>> +                       MEMBARRIER_STATE_SYNC_CORE)))
>>> +               return;
>>> +       sync_core();
>>> +}
>>
>> IMO there should be an extremely clear specification somewhere for
>> what this function is supposed to do.
>>
>> If I remember correctly, it's supposed to promise that the icache is
>> synced before the next time we return to usermode for the current mm
>> on this CPU.  If that's correct, then let's document it very
>> explicitly and let's also drop the "membarrier" from the name -- it's
>> a primitive we'll need anyway given the existing migration bug.
>
> I understand that on x86 (specifically), synchronizing the icache and
> doing a core serializing instruction may mean the same thing.
>
> However, on architectures like ARM, icache sync differs from core
> serialization. Those architectures typically have either a user-space
> accessible instruction or a system call to perform the icache flush.
> The missing part for JIT is core serialization (also called context
> synchronization). icache flush is already handled by pre-existing
> means.

Can you explain what "core serialization" means for the non-ARM-using
dummies in the audience? :)  That is, what does it actually guarantee.

>
> So the promise here given by membarrier_arch_mm_sync_core() is that
> a core serializing instruction is issued before the next time we return
> to usermode on the current thread. However, we only need that guarantee
> if the current thread's mm is a registered MEMBARRIER_{...}_SYNC_CORE user.

Why not make is so that it guarantees core serialization before the
next time we return to usermode on the current thread regardless of
membarrier details and to push the membarrier details into the caller?
 Also, do you really mean "current thread" or do you mean "current
mm", perhaps, or even "current CPU"?  The latter makes the most sense
to me.

>
> Regarding the existing migration bug, what I think you want is a kind
> of weaker "sync_core()", which ensures that a core serializing
> instruction is issued before the next time the current thread returns
> to usermode.

ISTM that would also satisfy membarrier's needs.

>
> It could be e.g.: set_tsk_need_core_sync() which would set a
> TIF_NEED_CORE_SYNC thread flag on the current thread.

Nah, only x86 and maybe power are weird enough to need thread info
flags.  Let's keep implementation details like that out of the
interface.

> What I suggest is that I update the comment above
> membarrier_arch_mm_sync_core to spell out more clearly that all we
> need is to have a core serializing instruction issued before the next
> time the current thread returns to user-space.

I would want more justification before x86 adds the "current thread"
mechanism.  x86 has an existing bug that needs fixing.  Once that bug
is fixed, I think you don't need anything that follows the thread
around if it migrates before the core sync happens.  With that bug
unfixed, I think this whole exercise is pointless on x86 -- we're
already buggy, and your series doesn't actually fix the bug.

> I can still use
> sync_core for now, and we can then improve the implementation
> whenever a new thread flag is introduced. The new comment would look
> like:
>
> /*
>  * x86-64 implements return to user-space through sysret, which is not a
>  * core-serializing instruction. Therefore, we need an explicit core
>  * serializing instruction after going from kernel thread back to
>  * user-space thread (active_mm moved back to current mm).
>  *
>  * This function ensures that a core serializing instruction is issued
>  * before the current thread returns to user-space.
>  */
>

What I'm suggesting is that you put something like the second
paragraph into the generic header.  But I still think that acting on
the current *thread* is a mistake.  On any architecture where you sync
a thread properly but then get unsynced on migration, you have a
problem just like x86 has now.  Once we've logically synced a thread,
I think it needs to remain synced regardless of migration.  Also, what
happens to all the other non-running threads that belong to the same
mm?  I.e. what's at all special about current?

--Andy
