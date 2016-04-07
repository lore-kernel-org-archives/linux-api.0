From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC PATCH 0/3] restartable sequences v2: fast user-space percpu
 critical sections
Date: Thu, 7 Apr 2016 22:11:56 +0200
Message-ID: <20160407201156.GC3448@twins.programming.kicks-ass.net>
References: <20151027235635.16059.11630.stgit@pjt-glaptop.roam.corp.google.com>
 <CALCETrW=3bZyC9d5tUoESEsNt-rc-uhNhZpgEgeSC8W4FAVYkg@mail.gmail.com>
 <20160407120254.GY3448@twins.programming.kicks-ass.net>
 <CALCETrV0vcYcnBrs0axykJD=_BM28wKWVMG6bMzK8zh8R3m5fg@mail.gmail.com>
 <20160407152432.GZ3448@twins.programming.kicks-ass.net>
 <CALCETrU5ZL6Jajc=9up-j86vY_Xtt-gTFjdQE0sB0d=d-CJZ6A@mail.gmail.com>
 <20160407155312.GA3448@twins.programming.kicks-ass.net>
 <CALCETrVGo1Di3qamxx1NAFUSN_o=-HnYRDpeVp7zrQEBwe5u-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVGo1Di3qamxx1NAFUSN_o=-HnYRDpeVp7zrQEBwe5u-g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Turner <commonly-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 07, 2016 at 09:43:33AM -0700, Andy Lutomirski wrote:
> More concretely, this looks like (using totally arbitrary register
> assingments -- probably far from ideal, especially given how GCC's
> constraints work):
> 
> enter the critical section:
> 1:
> movq %[cpu], %%r12
> movq {address of counter for our cpu}, %%r13
> movq {some fresh value}, (%%r13)
> cmpq %[cpu], %%r12
> jne 1b
> 
> ... do whatever setup or computation is needed...
> 
> movq $%l[failed], %%rcx
> movq $1f, %[commit_instr]
> cmpq {whatever counter we chose}, (%%r13)
> jne %l[failed]
> cmpq %[cpu], %%r12
> jne %l[failed]
> 
> <-- a signal in here that conflicts with us would clobber (%%r13), and
> the kernel would notice and send us to the failed label
> 
> movq %[to_write], (%[target])
> 1: movq $0, %[commit_instr]

And the kernel, for every thread that has had the syscall called and a
thingy registered, needs to (at preempt/signal-setup):

	if (get_user(post_commit_ip, current->post_commit_ip))
		return -EFAULT;

	if (likely(!post_commit_ip))
		return 0;

	if (regs->ip >= post_commit_ip)
		return 0;

	if (get_user(seq, (u32 __user *)regs->r13))
		return -EFAULT;

	if (regs->$(which one holds our chosen seq?) == seq) {
		/* nothing changed, do not cancel, proceed to commit. */
		return 0;
	}

	if (put_user(0UL, current->post_commit_ip))
		return -EFAULT;

	regs->ip = regs->rcx;


> In contrast to Paul's scheme, this has two additional (highly
> predictable) branches and requires generation of a seqcount in
> userspace.  In its favor, though, it doesnt need preemption hooks,

Without preemption hooks, how would one thread preempting another at the
above <-- clobber anything and cause the commit to fail?

> it's inherently debuggable, 

It is more debuggable, agreed.

> and it allows multiple independent
> rseq-protected things to coexist without forcing each other to abort.

And the kernel only needs to load the second cacheline if it lands in
the middle of a finish block, which should be manageable overhead I
suppose.

But the userspace chunk is lots slower as it needs to always touch
multiple lines, since the @cpu, @seq and @post_commit_ip all live in
separate lines (although I suppose @cpu and @post_commit_ip could live
in the same).

The finish thing needs 3 registers for:

 - fail ip
 - seq pointer
 - seq value

Which I suppose is possible even on register constrained architectures
like i386.
