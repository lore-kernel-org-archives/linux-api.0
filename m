From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.21 06/16] cpu_opv: Provide cpu_opv system call
 (v8)
Date: Tue, 16 Oct 2018 15:17:37 -0400 (EDT)
Message-ID: <1984292897.263.1539717457933.JavaMail.zimbra@efficios.com>
References: <20181010191936.7495-1-mathieu.desnoyers@efficios.com> <20181010191936.7495-7-mathieu.desnoyers@efficios.com> <20181016081029.GA30363@jagdpanzerIV>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181016081029.GA30363@jagdpanzerIV>
Sender: linux-kernel-owner@vger.kernel.org
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will
List-Id: linux-api@vger.kernel.org

----- On Oct 16, 2018, at 4:10 AM, Sergey Senozhatsky sergey.senozhatsky.work@gmail.com wrote:

> Hi Mathieu,
> 
> On (10/10/18 15:19), Mathieu Desnoyers wrote:
> [..]
>> +SYSCALL_DEFINE4(cpu_opv, struct cpu_op __user *, ucpuopv, int, cpuopcnt,
>> +		int, cpu, int, flags)
>> +{
> [..]
>> +again:
>> +	ret = cpu_opv_pin_pages(cpuopv, cpuopcnt, &vaddr_ptrs);
>> +	if (ret)
>> +		goto end;
>> +	ret = do_cpu_opv(cpuopv, cpuopcnt, &vaddr_ptrs, cpu);
>> +	if (ret == -EAGAIN)
>> +		retry = true;
>> +end:
>> +	for (i = 0; i < vaddr_ptrs.nr_vaddr; i++) {
>> +		struct vaddr *vaddr = &vaddr_ptrs.addr[i];
>> +		int j;
>> +
>> +		vm_unmap_user_ram((void *)vaddr->mem, vaddr->nr_pages);
> 
> A dumb question.
> 
> Both vm_unmap_user_ram() and vm_map_user_ram() can BUG_ON().
> So this is
>   userspace -> syscall -> cpu_opv() -> vm_unmap_user_ram() -> BUG_ON()
> 
> Any chance someone can exploit it?

Hi Sergey,

Let's look at vm_unmap_user_ram() and vm_map_user_ram() separately.

If we look at the input from vm_unmap_user_ram, it's called with the
following parameters by the cpu_opv system call:

        for (i = 0; i < vaddr_ptrs.nr_vaddr; i++) {
                struct vaddr *vaddr = &vaddr_ptrs.addr[i];
                int j;

                vm_unmap_user_ram((void *)vaddr->mem, vaddr->nr_pages);
[...]
        }

The vaddr_ptrs array content is filled by the call to cpu_opv_pin_pages above:

        ret = cpu_opv_pin_pages(cpuopv, cpuopcnt, &vaddr_ptrs);
        if (ret)
                goto end;

by passing the array to cpu_op_pin_pages(), which appends a virtual address at
the end of the array (on success) and increments nr_vaddr. Those virtual
addresses are returned by vm_map_user_ram(), so they are not user-controlled.

Therefore, only an internal kernel bug between vm_map_user_ram() and
vm_unmap_user_ram() should trigger the BUG_ON(). No user input is passed
to vm_unmap_user_ram().

Now, let's look at vm_map_user_ram(). It calls alloc_vmap_area(), which returns
a vmap_area. Then if vmap_page_range failed, vm_unmap_user_ram is called on the
memory that has just been returned by vm_map_user_ram. Again, only an internal
bug between map/unmap can trigger the BUG_ON() in vm_unmap_user_ram.

Is there another scenario I missed ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
