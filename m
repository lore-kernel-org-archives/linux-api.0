From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [RFC PATCH v3 for 4.15 08/24] Provide cpu_opv system call
Date: Mon, 20 Nov 2017 18:48:29 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1711201831490.1734@nanos>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com> <20171114200414.2188-9-mathieu.desnoyers@efficios.com> <alpine.DEB.2.20.1711162215100.2109@nanos> <1766414702.18278.1511194398489.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323329-2104743139-1511200109=:1734"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1766414702.18278.1511194398489.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <wil>
List-Id: linux-api@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-2104743139-1511200109=:1734
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 20 Nov 2017, Mathieu Desnoyers wrote:
> ----- On Nov 16, 2017, at 6:26 PM, Thomas Gleixner tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org wrote:
> >> +#define NR_PINNED_PAGES_ON_STACK	8
> > 
> > 8 pinned pages on stack? Which stack?
> 
> The common cases need to touch few pages, and we can keep the
> pointers in an array on the kernel stack within the cpu_opv system
> call.
> 
> Updating to:
> 
> /*
>  * Typical invocation of cpu_opv need few pages. Keep struct page
>  * pointers in an array on the stack of the cpu_opv system call up to
>  * this limit, beyond which the array is dynamically allocated.
>  */
> #define NR_PIN_PAGES_ON_STACK        8

That name still sucks. NR_PAGE_PTRS_ON_STACK would be immediately obvious.

> >> + * The operations available are: comparison, memcpy, add, or, and, xor,
> >> + * left shift, and right shift. The system call receives a CPU number
> >> + * from user-space as argument, which is the CPU on which those
> >> + * operations need to be performed. All preparation steps such as
> >> + * loading pointers, and applying offsets to arrays, need to be
> >> + * performed by user-space before invoking the system call. The
> > 
> > loading pointers and applying offsets? That makes no sense.
> 
> Updating to:
> 
>  * All preparation steps such as
>  * loading base pointers, and adding offsets derived from the current
>  * CPU number, need to be performed by user-space before invoking the
>  * system call.

This still does not explain anything, really.

Which base pointer is loaded?  I nowhere see a reference to a base
pointer.

And what are the offsets about?

derived from current cpu number? What is current CPU number? The one on
which the task executes now or the one which it should execute on?

I assume what you want to say is:

  All pointers in the ops must have been set up to point to the per CPU
  memory of the CPU on which the operations should be executed.

At least that's what I oracle in to that.

> >> + * "comparison" operation can be used to check that the data used in the
> >> + * preparation step did not change between preparation of system call
> >> + * inputs and operation execution within the preempt-off critical
> >> + * section.
> >> + *
> >> + * The reason why we require all pointer offsets to be calculated by
> >> + * user-space beforehand is because we need to use get_user_pages_fast()
> >> + * to first pin all pages touched by each operation. This takes care of
> > 
> > That doesnt explain it either.
> 
> What kind of explication are you looking for here ? Perhaps being too close
> to the implementation prevents me from understanding what is unclear from
> your perspective.

What the heck are pointer offsets?

The ops have one or two pointer(s) to a lump of memory. So if a pointer
points to the wrong lump of memory then you're screwed, but that's true for
all pointers handed to the kernel.

> Sorry, that paragraph was unclear. Updated:
> 
>  * An overall maximum of 4216 bytes in enforced on the sum of operation
>  * length within an operation vector, so user-space cannot generate a
>  * too long preempt-off critical section (cache cold critical section
>  * duration measured as 4.7µs on x86-64). Each operation is also limited
>  * a length of PAGE_SIZE bytes,

Again PAGE_SIZE is the wrong unit here. PAGE_SIZE can vary. What you want
is a hard limit of 4K. And because there is no alignment requiremnt the
rest of the sentence is stating the obvious.

>  * meaning that an operation can touch a
>  * maximum of 4 pages (memcpy: 2 pages for source, 2 pages for
>  * destination if addresses are not aligned on page boundaries).

I still have to understand why the 4K copy is necessary in the first place.

> > What's the critical section duration for operations which go to the limits
> > of this on a average x86 64 machine?
> 
> When cache-cold, I measure 4.7 µs per critical section doing a
> 4k memcpy and 15 * 8 bytes memcpy on a E5-2630 v3 @2.4GHz. Is it an
> acceptable preempt-off latency for RT ?

Depends on the use case as always ....

Thanks,

	tglx
--8323329-2104743139-1511200109=:1734--
