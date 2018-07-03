From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18] rseq: use __u64 for rseq_cs fields,
 validate user inputs
Date: Tue, 3 Jul 2018 13:58:37 -0400 (EDT)
Message-ID: <1048940999.11846.1530640717837.JavaMail.zimbra@efficios.com>
References: <858886246.10882.1530583291379.JavaMail.zimbra@efficios.com> <20180703085546.GJ3704@osiris> <20180703092113.GV2494@hirez.programming.kicks-ass.net> <20180703164048.i2te5gjemcafqzwf@two.firstfloor.org> <CA+55aFzYEQgEhCnrwtbGuCy36Wh+aiw0_9rgMcjUgbn1JtZAPQ@mail.gmail.com> <20180703173451.GX2494@hirez.programming.kicks-ass.net> <399697782.11820.1530639539750.JavaMail.zimbra@efficios.com> <20180703174833.GZ2494@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180703174833.GZ2494@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <andi@firstfloor.org>, heiko carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@amacapital.net>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will
List-Id: linux-api@vger.kernel.org

----- On Jul 3, 2018, at 1:48 PM, Peter Zijlstra peterz@infradead.org wrote:

> On Tue, Jul 03, 2018 at 01:38:59PM -0400, Mathieu Desnoyers wrote:
>> ----- On Jul 3, 2018, at 1:34 PM, Peter Zijlstra peterz@infradead.org wrote:
>> 
>> > On Tue, Jul 03, 2018 at 10:10:37AM -0700, Linus Torvalds wrote:
>> >> On Tue, Jul 3, 2018 at 9:40 AM Andi Kleen <andi@firstfloor.org> wrote:
>> >> >
>> >> > So it sounds like architectures that don't have an instruction atomic u64
>> >> > *_user need to disable interrupts during the access, and somehow handle that
>> >> > case when a page fault happens?
>> >> 
>> >> No. It's actually the store by *user* space that is the critical one.
>> >> Not the whole 64-bit value, just the low pointer part.
>> >> 
>> >> The kernel could do it as a byte-by-byte load, really. It's
>> >> per-thread, and once the kernel is running, it's not going to change.
>> >> The kernel never changes the value, it just loads it from user space.
>> > 
>> > The kernel doesn't change _this_ value, but the kernel does change other
>> > values, like for instance rseq->cpu_id. But even there, it could use
>> > byte stores and it is again the userspace load of that field that is
>> > critical again and needs to be a single op.
>> 
>> I can simply document that loads/stores from/to all struct rseq fields
>> should be thread-local then ?
> 
> I'm not sure that covers things sufficiently. You really want the
> userspace load/stores to be single instructions.

Yes, of course. More specifically, I would document that those need to
be single-copy atomicity load/store performed by the local thread.

> Also, I think it was rseq_update_cpu_id() where we wanted to use a
> single u64 store if possible but you worried about the stores.

With this added bit of restriction on thread-local loads, indeed we
can then update them without caring about atomicity at kernel level.

I can modify the ABI to put the cpu_id_start and cpu_id fields inside
a union, and update it with a single store.

Thoughts ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
