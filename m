From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.21 04/16] mm: Introduce vm_map_user_ram,
 vm_unmap_user_ram
Date: Wed, 17 Oct 2018 11:00:01 -0400 (EDT)
Message-ID: <1051015468.759.1539788401096.JavaMail.zimbra@efficios.com>
References: <20181010191936.7495-1-mathieu.desnoyers@efficios.com> <20181010191936.7495-5-mathieu.desnoyers@efficios.com> <20181016143016.10da89bd@gandalf.local.home> <20181017002722.GA1068@jagdpanzerIV>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181017002722.GA1068@jagdpanzerIV>
Sender: linux-kernel-owner@vger.kernel.org
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will
List-Id: linux-api@vger.kernel.org

----- On Oct 16, 2018, at 8:27 PM, Sergey Senozhatsky sergey.senozhatsky.work@gmail.com wrote:

> On (10/16/18 14:30), Steven Rostedt wrote:
>> > +void vm_unmap_user_ram(const void *mem, unsigned int count)
>> > +{
>> > +	unsigned long size = (unsigned long)count << PAGE_SHIFT;
>> > +	unsigned long addr = (unsigned long)mem;
>> > +	struct vmap_area *va;
>> > +
>> > +	might_sleep();
>> > +	BUG_ON(!addr);
>> > +	BUG_ON(addr < VMALLOC_START);
>> > +	BUG_ON(addr > VMALLOC_END);
>> > +	BUG_ON(!PAGE_ALIGNED(addr));
>> > +
>> > +	debug_check_no_locks_freed(mem, size);
>> > +	va = find_vmap_area(addr);
>> > +	BUG_ON(!va);
>> > +	free_unmap_vmap_area(va);
>> > +}
>> > +EXPORT_SYMBOL(vm_unmap_user_ram);
>> > +
>> 
>> Noticing this from Sergey's question in another patch, why are you
>> using BUG_ON()? That's rather extreme and something we are trying to
>> avoid adding more of (I still need to remove the BUG_ON()s I've added
>> over ten years ago). I don't see why all these BUG_ON's can't be turned
>> into:
> 
> +1
> 
>> 	if (WARN_ON(x))
>> 		return;
> 
> Given that this somewhat MM-related, I'd may be say VM_WARN_ON().

Good point, will do!

So I'll do one cleanup patch for vm_unmap_ram(), and I'll modify the new vm_unmap_user_ram().

Thanks,

Mathieu

> 
> 	-ss

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
