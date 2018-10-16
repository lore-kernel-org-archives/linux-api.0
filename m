From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH for 4.21 04/16] mm: Introduce vm_map_user_ram,
 vm_unmap_user_ram
Date: Tue, 16 Oct 2018 15:40:21 -0400
Message-ID: <20181016154021.429b3c08@gandalf.local.home>
References: <20181010191936.7495-1-mathieu.desnoyers@efficios.com>
        <20181010191936.7495-5-mathieu.desnoyers@efficios.com>
        <20181016143016.10da89bd@gandalf.local.home>
        <1635827931.274.1539717691833.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1635827931.274.1539717691833.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michae
List-Id: linux-api@vger.kernel.org

On Tue, 16 Oct 2018 15:21:31 -0400 (EDT)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> ----- On Oct 16, 2018, at 2:30 PM, rostedt rostedt@goodmis.org wrote:
> 
> > On Wed, 10 Oct 2018 15:19:24 -0400
> > Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> >   
> >> + * vm_unmap_user_ram - unmap linear kernel address space set up by
> >> vm_map_user_ram
> >> + * @mem: the pointer returned by vm_map_user_ram
> >> + * @count: the count passed to that vm_map_user_ram call (cannot unmap partial)
> >> + */
> >> +void vm_unmap_user_ram(const void *mem, unsigned int count)
> >> +{
> >> +	unsigned long size = (unsigned long)count << PAGE_SHIFT;
> >> +	unsigned long addr = (unsigned long)mem;
> >> +	struct vmap_area *va;
> >> +
> >> +	might_sleep();
> >> +	BUG_ON(!addr);
> >> +	BUG_ON(addr < VMALLOC_START);
> >> +	BUG_ON(addr > VMALLOC_END);
> >> +	BUG_ON(!PAGE_ALIGNED(addr));
> >> +
> >> +	debug_check_no_locks_freed(mem, size);
> >> +	va = find_vmap_area(addr);
> >> +	BUG_ON(!va);
> >> +	free_unmap_vmap_area(va);
> >> +}
> >> +EXPORT_SYMBOL(vm_unmap_user_ram);
> >> +  
> > 
> > Noticing this from Sergey's question in another patch, why are you
> > using BUG_ON()? That's rather extreme and something we are trying to
> > avoid adding more of (I still need to remove the BUG_ON()s I've added
> > over ten years ago). I don't see why all these BUG_ON's can't be turned
> > into:
> > 
> >	if (WARN_ON(x))
> >		return;  
> 
> I borrowed the code from vm_unmap_ram(), which has the following checks:
> 
>         BUG_ON(!addr);
>         BUG_ON(addr < VMALLOC_START);
>         BUG_ON(addr > VMALLOC_END);
>         BUG_ON(!PAGE_ALIGNED(addr));
> [...]
>         va = find_vmap_area(addr);
>         BUG_ON(!va);
> 
> The expectation here is that inputs to vm_unmap_ram() should always come from
> vm_map_ram(), so an erroneous input is an internal kernel bug. I applied the
> same logic to vm_unmap_user_ram() and vm_map_user_ram().
> 
> Should we turn all those BUG_ON() into if (WARN_ON(x)) return; in vm_{map,unmap}_ram
> as well ?
> 
>

I would argue yes! That code was added in 2008 (which is also the same
year I added BUG_ON() to my code). Back then it wasn't such an issue,
but today we are finding (and Linus has been complaining) that BUG_ON
really shouldn't be necessary. Especially if you can get out of the
function with a simple return.

-- Steve
