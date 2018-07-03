From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18] rseq: use __u64 for rseq_cs fields,
 validate user inputs
Date: Tue, 3 Jul 2018 14:09:53 -0400 (EDT)
Message-ID: <775833760.11858.1530641393364.JavaMail.zimbra@efficios.com>
References: <858886246.10882.1530583291379.JavaMail.zimbra@efficios.com> <20180703092113.GV2494@hirez.programming.kicks-ass.net> <20180703164048.i2te5gjemcafqzwf@two.firstfloor.org> <CA+55aFzYEQgEhCnrwtbGuCy36Wh+aiw0_9rgMcjUgbn1JtZAPQ@mail.gmail.com> <20180703173451.GX2494@hirez.programming.kicks-ass.net> <399697782.11820.1530639539750.JavaMail.zimbra@efficios.com> <20180703174833.GZ2494@hirez.programming.kicks-ass.net> <CA+55aFxcVbG2DMmmrW-HLTXZE+rcBWc5F48UYoL2heEsEpyO=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFxcVbG2DMmmrW-HLTXZE+rcBWc5F48UYoL2heEsEpyO=g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>, heiko carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@amacapital.net>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>Will Deacon <w>
List-Id: linux-api@vger.kernel.org

----- On Jul 3, 2018, at 1:59 PM, Linus Torvalds torvalds@linux-foundation.org wrote:

> On Tue, Jul 3, 2018 at 10:49 AM Peter Zijlstra <peterz@infradead.org> wrote:
>>
>> > I can simply document that loads/stores from/to all struct rseq fields
>> > should be thread-local then ?
>>
>> I'm not sure that covers things sufficiently. You really want the
>> userspace load/stores to be single instructions.
> 
> Actually, I think we should try very hard to limit even that to _just_
> the rseq pointer itself.
> 
> Everything else can be filled in ahead of time with non-atomic stores,
> and then the last thing that happens - and the only thing that wants
> that final "one last atomic write" is the rseq pointer write.
> 
> No?

Well a small nit here: the rseq->rseq_cs pointer store is performed
at the _very beginning_ of the rseq critical section. We indeed want
that store to be performed as a single instruction by user-space.

What I think you have in mind as "one last atomic write" is the commit
instruction at the end of the critical section, which does not touch
any field in struct rseq.

> 
> So I'd suggest that the only part we aim to have any "atomic" behavior
> at all is for the individual fields in "struct rseq" itself. So the
> cpu id and the base pointer and the flags. And even they are
> thread-local, so the atomicity is not about the kernel, but about user
> space needing to read and update them in word-sized chunks.
> 
> End result: absolutely nothing is atomic for the kernel.

Yes, +1. If everyone is OK with that I'll go and implement the changes
within the coming day.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
