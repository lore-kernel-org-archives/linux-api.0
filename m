From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH v7 1/7] Restartable sequences system call
Date: Wed, 10 Aug 2016 13:57:05 +0000 (UTC)
Message-ID: <190756064.7087.1470837425199.JavaMail.zimbra@efficios.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com> <1469135662-31512-2-git-send-email-mathieu.desnoyers@efficios.com> <20160803131940.GM6862@twins.programming.kicks-ass.net> <656745027.6624.1470773200334.JavaMail.zimbra@efficios.com> <20160810084320.GM6879@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160810084320.GM6879@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Boqun Feng <boqun.feng@gmail.com>
List-Id: linux-api@vger.kernel.org

----- On Aug 10, 2016, at 4:43 AM, Peter Zijlstra peterz@infradead.org wrote:

> On Tue, Aug 09, 2016 at 08:06:40PM +0000, Mathieu Desnoyers wrote:

<snip>

>> > Also, I think it would be good to have a comment explaining why this is
>> > split in two structures? Don't you rely on the address dependency?
>> 
>> The comment above the rseq_cs fields needs clarification, how about:
>> 
>>         /*
>>          * Restartable sequences rseq_cs field.
>>          * Contains NULL when no critical section is active for the
>>          * current thread, or holds a pointer to the currently active
>>          * struct rseq_cs.
>>          * Updated by user-space at the beginning and end of assembly
>>          * instruction sequence block, and by the kernel when it
>>          * restarts an assembly instruction sequence block. Read by the
>>          * kernel with single-copy atomicity semantics. Aligned on
>>          * 64-bit.
>>          */
>> 
>> This really explains that rseq_cs field of struct rseq holds a pointer
>> to the current struct rseq_cs (or NULL), which makes it obvious why this
>> needs to be two different structures.
> 
> I think I'm still missing things as its not obvious to me at all :/
> 
> We could equally well have chosen a single structure and picked the
> post_commit_ip field to trigger things from, no?
> 
> The only down side seems to be that we must then impose ordering (but UP
> ordering, so that's cheap) between writing the abort_ip and
> post_commit_ip.
> 
> That is; something like so:
> 
> struct rseq {
>	union rseq_event_cpu u;
> 
>	u64 abort_ip;
>	u64 post_commit_ip;
> };
> 
> Where userspace must do:
> 
>	r->abort_ip = $abort_ip;
>	barrier();
>	WRITE_ONCE(r->post_commit_ip, $post_commit_ip);
>	barrier();
> 
> Which is not much different from what Paul did, except he kept the
> abort_ip in a register (which must be loaded before setting the
> commit_ip).
> 
> And the kernel checks post_commit_ip, if 0, nothing happens, otherwise
> we check instruction_pointer and do magic.
> 
> Then after the commit, we clear post_commit_ip again; just like we now
> clear the rseq_cs pointer.
> 
> AFAICT this is an equally valid approach. So why split and put that
> indirection in?

Now I understand from which angle you are looking at it.

The reason for this indirection is to speed up the user-space rseq_finish()
fast path:

With Paul Turner's approach, we needed to clobber a register, issue
instructions to move abort_ip to that register, and store the post_commit_ip
to the TLS.

With your approach here, you need 2 stores, ordered with compiler-barriers:
storing abort_ip to TLS, and then post_commit_ip to TLS.

The approach I propose (indirection) only requires a single store to the TLS:
we store the address of the currently active struct rseq_cs descriptor. The
kernel can then fetch the content of that descriptor (start_ip, post_commit_ip,
abort_ip) when/if it preempts/deliver a signal over that critical section.

On architectures like arm32, it makes a very significant difference
performance-wise to simply remove useless register movement or stores.

So I add an indirection in the kernel slow path (upon return to user-space after
preempting a rseq asm sequence, or upon signal delivery over a rseq asm sequence),
to speed up the user-space fast path.

By using the indirection approach, we also get the "start_ip" pointer for free,
which can be used to let the kernel know the exact range of the restartable
sequence, and means we can implement the abort handler in pure C, even if it
is placed at addresses before the restartable block by the compiler. This saves
us a jump on the fast path (otherwise required to skip over the abort code).
Doing the same with Paul's approach and yours would require to clobber yet
another register or add one more store for the start_ip.

> 
>> Combined with other recent feedback, this becomes:
>> 
>>  *   The abort_ip address needs to be lesser than start_ip, or
> 
> Isn't it "less than" ?

Indeed, I had to look this one up. "lesser" is an adjective, and here
I should use "to be less than", but below the use the "be at addresses
lesser than" would appear to be OK.

> 
>>  *   greater-or-equal the post_commit_ip. Step [4] and the failure
>>  *   code step [F1] need to be at addresses lesser than start_ip, or
>>  *   greater-or-equal the post_commit_ip.
>> 
> 

<snip>

Thanks!

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
