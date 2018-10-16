From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [RFC PATCH for 4.21 06/16] cpu_opv: Provide cpu_opv system call
 (v8)
Date: Tue, 16 Oct 2018 17:10:29 +0900
Message-ID: <20181016081029.GA30363@jagdpanzerIV>
References: <20181010191936.7495-1-mathieu.desnoyers@efficios.com>
 <20181010191936.7495-7-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181010191936.7495-7-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm>
List-Id: linux-api@vger.kernel.org

Hi Mathieu,

On (10/10/18 15:19), Mathieu Desnoyers wrote:
[..]
> +SYSCALL_DEFINE4(cpu_opv, struct cpu_op __user *, ucpuopv, int, cpuopcnt,
> +		int, cpu, int, flags)
> +{
[..]
> +again:
> +	ret = cpu_opv_pin_pages(cpuopv, cpuopcnt, &vaddr_ptrs);
> +	if (ret)
> +		goto end;
> +	ret = do_cpu_opv(cpuopv, cpuopcnt, &vaddr_ptrs, cpu);
> +	if (ret == -EAGAIN)
> +		retry = true;
> +end:
> +	for (i = 0; i < vaddr_ptrs.nr_vaddr; i++) {
> +		struct vaddr *vaddr = &vaddr_ptrs.addr[i];
> +		int j;
> +
> +		vm_unmap_user_ram((void *)vaddr->mem, vaddr->nr_pages);

A dumb question.

Both vm_unmap_user_ram() and vm_map_user_ram() can BUG_ON().
So this is
   userspace -> syscall -> cpu_opv() -> vm_unmap_user_ram() -> BUG_ON()

Any chance someone can exploit it?

	-ss
