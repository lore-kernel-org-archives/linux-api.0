From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18 12/23] cpu_opv: Provide cpu_opv system call
 (v7)
Date: Fri, 13 Apr 2018 08:16:49 -0400 (EDT)
Message-ID: <625160026.9658.1523621809662.JavaMail.zimbra@efficios.com>
References: <20180412192800.15708-1-mathieu.desnoyers@efficios.com> <20180412192800.15708-13-mathieu.desnoyers@efficios.com> <CA+55aFxcJ2V_1BoW0Cct=Kkp7REkgiU_BTimGdmoFmWHaWaZ-g@mail.gmail.com> <1580648199.9463.1523563167045.JavaMail.zimbra@efficios.com> <CA+55aFwFUeNA6_0a1MOU-7VGzCw5T99cfVCPiyTpZQJdd6z=bw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFwFUeNA6_0a1MOU-7VGzCw5T99cfVCPiyTpZQJdd6z=bw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@a>
List-Id: linux-api@vger.kernel.org

----- On Apr 12, 2018, at 4:07 PM, Linus Torvalds torvalds@linux-foundation.org wrote:

> On Thu, Apr 12, 2018 at 12:59 PM, Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
>>
>> What are your concerns about page pinning ?
> 
> Pretty much everything.
> 
> It's the most complex part by far, and the vmalloc space is a limited
> resource on 32-bit architectures.

The vmalloc space needed by cpu_opv is bound by the number of pages
a cpu_opv call can touch. On architectures with virtually aliased
dcache, we also need to add a few extra pages worth of address space
to account for SHMLBA alignment.

So on ARM32, with SHMLBA=4 pages, this means at most 1 MB of virtual
address space temporarily needed for a cpu_opv system call in the very
worst case scenario: 16 ops * 2 uaddr * 8 pages per uaddr
(if we're unlucky and find ourselves aligned across two SHMLBA) * 4096 bytes per page.

If this amount of vmalloc space happens to be our limiting factor, we can
change the max cpu_opv ops array size supported, e.g. bringing it from 16 down
to 4. The largest number of operations I currently need in the cpu-opv library
is 4. With 4 ops, the worse case vmalloc space used by a cpu_opv system call
becomes 256 kB.

> 
>> Do you have an alternative approach in mind ?
> 
> Do everything in user space.

I wish we could disable preemption and cpu hotplug in user-space.
Unfortunately, that does not seem to be a viable solution for many
technical reasons, starting with page fault handling.

> 
> And even if you absolutely want cpu_opv at all, why not do it in the
> user space *mapping* without the aliasing into kernel space?

That's because cpu_opv need to execute the entire array of operations
with preemption disabled, and we cannot take a page fault with preemption
off.

Page pinning and aliasing user-space pages in the kernel linear mapping
ensure that we don't end up in trouble in page fault scenarios, such as
having the pages we need to touch swapped out under our feet.

> 
> The cpu_opv approach isn't even fast. It's *really* slow if it has to
> do VM crap.
> 
> The whole rseq thing was billed as "faster than atomics". I
> *guarantee* that the cpu_opv's aren't faster than atomics.

Yes, and here is the good news: cpu_opv speed does not even matter. rseq assember instruction sequences are very fast, but cannot deal with infrequent corner-cases.
cpu_opv is slow, but is guaranteed to deal with the occasional corner-case
situations.

This is similar to pthread mutex/futex fast/slow paths. The common case is fast
(rseq), and the speed of the infrequent case (cpu_opv) does not matter as long
as it's used infrequently enough, which is the case here.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
