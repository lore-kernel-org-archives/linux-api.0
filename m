From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH] Fix: membarrier: racy access to p->mm in
 membarrier_global_expedited()
Date: Mon, 28 Jan 2019 16:07:26 -0500 (EST)
Message-ID: <231707440.2765.1548709646123.JavaMail.zimbra@efficios.com>
References: <20190128182636.18420-1-mathieu.desnoyers@efficios.com> <CAHk-=wjmpfXak0pQVu8dZrk2Oma3OxtEoBHfwCAruu0xpSMN4A@mail.gmail.com> <20190128204611.GB4240@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190128204611.GB4240@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: paulmck <paulmck@linux.ibm.com>, Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andrea Parri <parri.andrea@gmail.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@kernel.org>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, David Sehr <sehr@google.com>, Greg Hackmann <ghackmann@google.com>, "H. Peter Anvin" <hpa@zytor.com>, maged michael <maged.michael@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, Paul Mackerras <paulus@samba.org>, "Russell King, ARM Linux" <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org

----- On Jan 28, 2019, at 3:46 PM, paulmck paulmck@linux.ibm.com wrote:

> On Mon, Jan 28, 2019 at 12:27:03PM -0800, Linus Torvalds wrote:
>> On Mon, Jan 28, 2019 at 10:27 AM Mathieu Desnoyers
>> <mathieu.desnoyers@efficios.com> wrote:
>> >
>> > Jann Horn identified a racy access to p->mm in the global expedited
>> > command of the membarrier system call.
>> >
>> > The suggested fix is to hold the task_lock() around the accesses to
>> > p->mm and to the mm_struct membarrier_state field to guarantee the
>> > existence of the mm_struct.
>> 
>> Hmm. I think this is right. You shouldn't access another threads mm
>> pointer without proper locking.
>> 
>> That said, we *could* make the mm_cachep be SLAB_TYPESAFE_BY_RCU,
>> which would allow speculatively reading data off the mm pointer under
>> RCU. It might not be the *right* mm if somebody just did an exit, but
>> for things like this it shouldn't matter.
> 
> That sounds much simpler and more effective than the contention-reduction
> approach that I suggested.  ;-)

I'd be tempted to stick to the locking approach for a fix, and implement
Linus' type-safe mm_cachep idea if anyone complains about the overhead
of membarrier GLOBAL_EXPEDITED (and submit for a future merge window).

I tested the KASAN splat reproducer from Jann locally, and confirmed that
my patch fixes the issue it reproduces.

Please let me know if the task_lock() approach is OK as a fix for now.

I'm also awaiting a Tested-by from Jann before submitting this for real.

Thanks,

Mathieu

> 
>							Thanx, Paul
> 
>> But if this is the only case that might care, it sounds like just
>> doing the proper locking is the right approach.
>> 
>>            Linus

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
