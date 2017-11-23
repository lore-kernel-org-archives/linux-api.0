From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH for 4.15 v12 00/22] Restartable sequences and CPU op
 vector
Date: Thu, 23 Nov 2017 21:15:21 +0000 (UTC)
Message-ID: <165707648.21250.1511471721845.JavaMail.zimbra@efficios.com>
References: <20171121141900.18471-1-mathieu.desnoyers@efficios.com> <20171121172144.GL2482@two.firstfloor.org> <740195164.19702.1511301908907.JavaMail.zimbra@efficios.com> <20171122193219.GI3165@worktop.lehotels.local> <20171122193734.GO22648@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171122193734.GO22648-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin
List-Id: linux-api@vger.kernel.org

----- On Nov 22, 2017, at 2:37 PM, Will Deacon will.deacon-5wv7dgnIgG8@public.gmane.org wrote:

> On Wed, Nov 22, 2017 at 08:32:19PM +0100, Peter Zijlstra wrote:
>> On Tue, Nov 21, 2017 at 10:05:08PM +0000, Mathieu Desnoyers wrote:
>> > Other than that, I have not received any concrete alternative proposal to
>> > properly handle single-stepping.
>> 
>> That's not entirely true; amluto did have an alternative in Prague: do
>> full machine level instruction emulation till the end of the rseq when
>> it gets 'preempted too often'.
>> 
>> Yes, implementing that will be an absolute royal pain. But it does
>> remove the whole duplicate/dual program asm/bytecode thing and avoids
>> the syscall entirely.
>> 
>> And we don't need to do a full x86_64/arch-of-choice emulator for this
>> either; just as cpu_opv is fairly limited too. We can do a subset that
>> allows dealing with the known sequences and go from there -- it can
>> always fall back to not emulating and reverting to the pure rseq with
>> debug/fwd progress 'issues'.
>> 
>> So what exactly is the problem of leaving out the whole cpu_opv thing
>> for now? Pure rseq is usable -- albeit a bit cumbersome without
>> additional debugger support.
> 
> Drive-by "ack" to that. I'd really like a working rseq implementation in
> mainline, but I don't much care for another interpreter.

Considering the arm 64 use-case of reading PMU counters from user-space
using rseq to prevent migration, I understand that you're lucky enough to
already have a system call at your disposal that can perform the slow-path
in case of single-stepping.

So yes, your particular case is already covered, but unfortunately that's
not the same situation for other use-cases that have been expressed.

Thanks,

Mathieu


> 
> Will

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
