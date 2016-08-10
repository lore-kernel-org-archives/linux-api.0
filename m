From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH v7 1/7] Restartable sequences system call
Date: Wed, 10 Aug 2016 14:44:29 +0000 (UTC)
Message-ID: <1181173240.7126.1470840269327.JavaMail.zimbra@efficios.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com> <1469135662-31512-2-git-send-email-mathieu.desnoyers@efficios.com> <20160803131940.GM6862@twins.programming.kicks-ass.net> <656745027.6624.1470773200334.JavaMail.zimbra@efficios.com> <20160810084320.GM6879@twins.programming.kicks-ass.net> <190756064.7087.1470837425199.JavaMail.zimbra@efficios.com> <20160810142858.GQ30192@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160810142858.GQ30192@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Boqun Feng <boqun.feng@gmail.com>
List-Id: linux-api@vger.kernel.org

----- On Aug 10, 2016, at 10:28 AM, Peter Zijlstra peterz@infradead.org wrote:

> On Wed, Aug 10, 2016 at 01:57:05PM +0000, Mathieu Desnoyers wrote:
> 
>> > We could equally well have chosen a single structure and picked the
>> > post_commit_ip field to trigger things from, no?
>> > 
>> > The only down side seems to be that we must then impose ordering (but UP
>> > ordering, so that's cheap) between writing the abort_ip and
>> > post_commit_ip.
>> > 
>> > That is; something like so:
>> > 
>> > struct rseq {
>> >	union rseq_event_cpu u;
>> > 
>> >	u64 abort_ip;
>> >	u64 post_commit_ip;
>> > };
>> > 
>> > Where userspace must do:
>> > 
>> >	r->abort_ip = $abort_ip;
>> >	barrier();
>> >	WRITE_ONCE(r->post_commit_ip, $post_commit_ip);
>> >	barrier();
>> > 
>> > Which is not much different from what Paul did, except he kept the
>> > abort_ip in a register (which must be loaded before setting the
>> > commit_ip).
>> > 
>> > And the kernel checks post_commit_ip, if 0, nothing happens, otherwise
>> > we check instruction_pointer and do magic.
>> > 
>> > Then after the commit, we clear post_commit_ip again; just like we now
>> > clear the rseq_cs pointer.
>> > 
>> > AFAICT this is an equally valid approach. So why split and put that
>> > indirection in?
>> 
>> Now I understand from which angle you are looking at it.
>> 
>> The reason for this indirection is to speed up the user-space rseq_finish()
>> fast path:
>> 
>> With Paul Turner's approach, we needed to clobber a register, issue
>> instructions to move abort_ip to that register, and store the post_commit_ip
>> to the TLS.
>> 
>> With your approach here, you need 2 stores, ordered with compiler-barriers:
>> storing abort_ip to TLS, and then post_commit_ip to TLS.
>> 
>> The approach I propose (indirection) only requires a single store to the TLS:
>> we store the address of the currently active struct rseq_cs descriptor. The
>> kernel can then fetch the content of that descriptor (start_ip, post_commit_ip,
>> abort_ip) when/if it preempts/deliver a signal over that critical section.
>> 
>> On architectures like arm32, it makes a very significant difference
>> performance-wise to simply remove useless register movement or stores.
>> 
>> So I add an indirection in the kernel slow path (upon return to user-space after
>> preempting a rseq asm sequence, or upon signal delivery over a rseq asm
>> sequence),
>> to speed up the user-space fast path.
>> 
>> By using the indirection approach, we also get the "start_ip" pointer for free,
>> which can be used to let the kernel know the exact range of the restartable
>> sequence, and means we can implement the abort handler in pure C, even if it
>> is placed at addresses before the restartable block by the compiler. This saves
>> us a jump on the fast path (otherwise required to skip over the abort code).
>> Doing the same with Paul's approach and yours would require to clobber yet
>> another register or add one more store for the start_ip.
> 
> Ah, because the {start,abort,commit} tuple is link time constants? Which
> means we can have this in .data and not on the stack, avoiding the
> stores entirely.

Yes, this is exactly what we do in the selftests rseq.h for x86 and ppc. For
ARM32, we put this in the code (we jump over it), so we can calculate the
address pointing to the descriptor using the ip-relative "adr" instruction,
which is faster than loading an arbitrary address constant.

> 
> Because the moment we put the thing on the stack, we need to do those
> stores anyway.

Since those are link-time constants, we don't need to store them, ever.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
