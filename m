From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18 12/23] cpu_opv: Provide cpu_opv system call
 (v7)
Date: Thu, 12 Apr 2018 15:59:27 -0400 (EDT)
Message-ID: <1580648199.9463.1523563167045.JavaMail.zimbra@efficios.com>
References: <20180412192800.15708-1-mathieu.desnoyers@efficios.com> <20180412192800.15708-13-mathieu.desnoyers@efficios.com> <CA+55aFxcJ2V_1BoW0Cct=Kkp7REkgiU_BTimGdmoFmWHaWaZ-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFxcJ2V_1BoW0Cct=Kkp7REkgiU_BTimGdmoFmWHaWaZ-g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@a>
List-Id: linux-api@vger.kernel.org

----- On Apr 12, 2018, at 3:43 PM, Linus Torvalds torvalds@linux-foundation.org wrote:

> On Thu, Apr 12, 2018 at 12:27 PM, Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
>> The cpu_opv system call executes a vector of operations on behalf of
>> user-space on a specific CPU with preemption disabled. It is inspired
>> by readv() and writev() system calls which take a "struct iovec"
>> array as argument.
> 
> Do we really want the page pinning?
> 
> This whole cpu_opv thing is the most questionable part of the series,
> and the page pinning is the most questionable part of cpu_opv for me.

What are your concerns about page pinning ?

Do you have an alternative approach in mind ?

> Can we plan on merging just the plain rseq parts *without* this all
> first, and then see the cpu_opv thing as a "maybe future expansion"
> part.

The main problem with the incremental approach is that it won't deal
with remote CPU data accesses, and won't deal with cpu hotplug in
non-racy ways. For *some* of the use-cases, the other issues solved by
cpu_opv can be worked-around in user-space, at the cost of making
the userspace code a mess, and in many cases slower than if we can rely
on cpu_opv for the fallback.

All the rseq test-cases depend on cpu_opv as they stand now. Without
cpu_opv to handle the corner-cases, things become much more messy on the
user-space side.

Thanks,

Mathieu

> 
> I think that would make Andy happier too.
> 
>              Linus

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
