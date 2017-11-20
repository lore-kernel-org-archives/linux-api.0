From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH v3 for 4.15 08/24] Provide cpu_opv system call
Date: Mon, 20 Nov 2017 18:39:11 +0000 (UTC)
Message-ID: <204285712.18480.1511203151076.JavaMail.zimbra@efficios.com>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com> <20171114200414.2188-9-mathieu.desnoyers@efficios.com> <alpine.DEB.2.20.1711162215100.2109@nanos> <1766414702.18278.1511194398489.JavaMail.zimbra@efficios.com> <alpine.DEB.2.20.1711201831490.1734@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1711201831490.1734@nanos>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wil>
List-Id: linux-api@vger.kernel.org

----- On Nov 20, 2017, at 12:48 PM, Thomas Gleixner tglx@linutronix.de wrote:

> On Mon, 20 Nov 2017, Mathieu Desnoyers wrote:
>> ----- On Nov 16, 2017, at 6:26 PM, Thomas Gleixner tglx@linutronix.de wrote:
>> >> +#define NR_PINNED_PAGES_ON_STACK	8
>> > 
>> > 8 pinned pages on stack? Which stack?
>> 
>> The common cases need to touch few pages, and we can keep the
>> pointers in an array on the kernel stack within the cpu_opv system
>> call.
>> 
>> Updating to:
>> 
>> /*
>>  * Typical invocation of cpu_opv need few pages. Keep struct page
>>  * pointers in an array on the stack of the cpu_opv system call up to
>>  * this limit, beyond which the array is dynamically allocated.
>>  */
>> #define NR_PIN_PAGES_ON_STACK        8
> 
> That name still sucks. NR_PAGE_PTRS_ON_STACK would be immediately obvious.

fixed.

> 
>> >> + * The operations available are: comparison, memcpy, add, or, and, xor,
>> >> + * left shift, and right shift. The system call receives a CPU number
>> >> + * from user-space as argument, which is the CPU on which those
>> >> + * operations need to be performed. All preparation steps such as
>> >> + * loading pointers, and applying offsets to arrays, need to be
>> >> + * performed by user-space before invoking the system call. The
>> > 
>> > loading pointers and applying offsets? That makes no sense.
>> 
>> Updating to:
>> 
>>  * All preparation steps such as
>>  * loading base pointers, and adding offsets derived from the current
>>  * CPU number, need to be performed by user-space before invoking the
>>  * system call.
> 
> This still does not explain anything, really.
> 
> Which base pointer is loaded?  I nowhere see a reference to a base
> pointer.
> 
> And what are the offsets about?
> 
> derived from current cpu number? What is current CPU number? The one on
> which the task executes now or the one which it should execute on?
> 
> I assume what you want to say is:
> 
>  All pointers in the ops must have been set up to point to the per CPU
>  memory of the CPU on which the operations should be executed.
> 
> At least that's what I oracle in to that.

Exactly that. Will update to use this description instead.

> 
>> >> + * "comparison" operation can be used to check that the data used in the
>> >> + * preparation step did not change between preparation of system call
>> >> + * inputs and operation execution within the preempt-off critical
>> >> + * section.
>> >> + *
>> >> + * The reason why we require all pointer offsets to be calculated by
>> >> + * user-space beforehand is because we need to use get_user_pages_fast()
>> >> + * to first pin all pages touched by each operation. This takes care of
>> > 
>> > That doesnt explain it either.
>> 
>> What kind of explication are you looking for here ? Perhaps being too close
>> to the implementation prevents me from understanding what is unclear from
>> your perspective.
> 
> What the heck are pointer offsets?
> 
> The ops have one or two pointer(s) to a lump of memory. So if a pointer
> points to the wrong lump of memory then you're screwed, but that's true for
> all pointers handed to the kernel.

I think the sentence you suggested above is clear enough. I'll simply use
it.

> 
>> Sorry, that paragraph was unclear. Updated:
>> 
>>  * An overall maximum of 4216 bytes in enforced on the sum of operation
>>  * length within an operation vector, so user-space cannot generate a
>>  * too long preempt-off critical section (cache cold critical section
>>  * duration measured as 4.7µs on x86-64). Each operation is also limited
>>  * a length of PAGE_SIZE bytes,
> 
> Again PAGE_SIZE is the wrong unit here. PAGE_SIZE can vary. What you want
> is a hard limit of 4K. And because there is no alignment requiremnt the
> rest of the sentence is stating the obvious.

I can make that a 4K limit if you prefer. This presumes that no architecture
has pages smaller than 4K, which is true on Linux.

> 
>>  * meaning that an operation can touch a
>>  * maximum of 4 pages (memcpy: 2 pages for source, 2 pages for
>>  * destination if addresses are not aligned on page boundaries).
> 
> I still have to understand why the 4K copy is necessary in the first place.
> 
>> > What's the critical section duration for operations which go to the limits
>> > of this on a average x86 64 machine?
>> 
>> When cache-cold, I measure 4.7 µs per critical section doing a
>> 4k memcpy and 15 * 8 bytes memcpy on a E5-2630 v3 @2.4GHz. Is it an
>> acceptable preempt-off latency for RT ?
> 
> Depends on the use case as always ....

The use-case for 4k memcpy operation is a per-cpu ring buffer where
the rseq fast-path does the following:

- ring buffer push: in the rseq asm instruction sequence, a memcpy of a
  given structure (limited to 4k in size) into a ring buffer,
  followed by the final commit instruction which increments the current
  position offset by the number of bytes pushed.

- ring buffer pop: in the rseq asm instruction sequence, a memcpy of
  a given structure (up to 4k) from the ring buffer, at "position" offset.
  The final commit instruction decrements the current position offset by
  the number of bytes pop'd.

Having cpu_opv do a 4k memcpy allow it to handle scenarios where
rseq fails to progress.

Thanks,

Mathieu



> 
> Thanks,
> 
> 	tglx

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
