From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18 12/23] cpu_opv: Provide cpu_opv system call
 (v7)
Date: Mon, 16 Apr 2018 14:35:08 -0400 (EDT)
Message-ID: <542721578.11358.1523903708510.JavaMail.zimbra@efficios.com>
References: <20180412192800.15708-1-mathieu.desnoyers@efficios.com> <20180412192800.15708-13-mathieu.desnoyers@efficios.com> <CA+55aFxcJ2V_1BoW0Cct=Kkp7REkgiU_BTimGdmoFmWHaWaZ-g@mail.gmail.com> <CALCETrVvaMWUJKx+bxXdEm3oVBzn2r5RuJ4JcXNzOPSgJAC5PA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrVvaMWUJKx+bxXdEm3oVBzn2r5RuJ4JcXNzOPSgJAC5PA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will>
List-Id: linux-api@vger.kernel.org

----- On Apr 14, 2018, at 6:44 PM, Andy Lutomirski luto@amacapital.net wrote:

> On Thu, Apr 12, 2018 at 12:43 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Thu, Apr 12, 2018 at 12:27 PM, Mathieu Desnoyers
>> <mathieu.desnoyers@efficios.com> wrote:
>>> The cpu_opv system call executes a vector of operations on behalf of
>>> user-space on a specific CPU with preemption disabled. It is inspired
>>> by readv() and writev() system calls which take a "struct iovec"
>>> array as argument.
>>
>> Do we really want the page pinning?
>>
>> This whole cpu_opv thing is the most questionable part of the series,
>> and the page pinning is the most questionable part of cpu_opv for me.
>>
>> Can we plan on merging just the plain rseq parts *without* this all
>> first, and then see the cpu_opv thing as a "maybe future expansion"
>> part.
>>
>> I think that would make Andy happier too.
>>
> 
> It only makes me happier if the userspace code involved is actually
> going to work when single-stepped, which might actually be the case
> (fingers crossed).

Specifically for single-stepping, the __rseq_table section introduced
at user-level will allow newer debuggers and tools which do line and
instruction-level single-stepping to skip over rseq critical sections.
However, this breaks existing debuggers and tools.

For a userspace tracer tool such as LTTng-UST, requiring upgrade to newer
debugger versions would limit its adoption in the field. So if using rseq
breaks current debugger tools, lttng-ust won't use rseq until
single-stepping can be done in a non-breaking way, or will have to wait
until most end-user deployments (distributions used in the field) include
debugger versions that skip over the code identified by the __rseq_table
section, which will take many years.

> That being said, I'm not really convinced that
> cpu_opv() makes much difference here, since I'm not entirely convinced
> that user code will actually use it or that user code will actually be
> that well tested.  C'est la vie.

For the use-case of cpu_opv invoked as single-stepping fall-back, this path
will indeed not be executed often enough to be well-tested. I'm considering
the following approach to allow user-space to test cpu_opv more thoroughly:
we can introduce an environment variable, e.g.:

- RSEQ_DISABLE=1: Disable rseq thread registration,
- RSEQ_DISABLE=random: Randomly disable rseq thread registration (some threads
  use rseq, other threads end up using the cpu_opv fallback)

which would disable the rseq fast-path for all or some threads, and thus allow
thorough testing of cpu_opv used as single-stepping fallback.

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
