From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC PATCH 0/3] restartable sequences v2: fast user-space percpu
 critical sections
Date: Thu, 7 Apr 2016 17:53:12 +0200
Message-ID: <20160407155312.GA3448@twins.programming.kicks-ass.net>
References: <20151027235635.16059.11630.stgit@pjt-glaptop.roam.corp.google.com>
 <CALCETrW=3bZyC9d5tUoESEsNt-rc-uhNhZpgEgeSC8W4FAVYkg@mail.gmail.com>
 <20160407120254.GY3448@twins.programming.kicks-ass.net>
 <CALCETrV0vcYcnBrs0axykJD=_BM28wKWVMG6bMzK8zh8R3m5fg@mail.gmail.com>
 <20160407152432.GZ3448@twins.programming.kicks-ass.net>
 <CALCETrU5ZL6Jajc=9up-j86vY_Xtt-gTFjdQE0sB0d=d-CJZ6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrU5ZL6Jajc=9up-j86vY_Xtt-gTFjdQE0sB0d=d-CJZ6A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Turner <commonly-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 07, 2016 at 08:44:38AM -0700, Andy Lutomirski wrote:
> On Thu, Apr 7, 2016 at 8:24 AM, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> > On Thu, Apr 07, 2016 at 07:35:26AM -0700, Andy Lutomirski wrote:
> >> What I meant was: rather than shoving individual values into the TLABI
> >> thing, shove in a pointer:
> >>
> >> struct commit_info {
> >>   u64 post_commit_rip;
> >>   u32 cpu;
> >>   u64 *event;
> >>   // whatever else;
> >> };
> >>
> >> and then put a commit_info* in TLABI.
> >>
> >> This would save some bytes in the TLABI structure.
> >
> > But would cost us extra indirections. The whole point was getting this
> > stuff at a constant offset from the TLS segment register.
> 
> I don't think the extra indirections would matter much.  The kernel
> would have to chase the pointer, but only in the very rare case where
> it resumes userspace during a commit or on the immediately following
> instruction.

Its about userspace finding these values, not the kernel.

> At the very least, post_commit_rip and the abort address (which I
> forgot about) could both live in a static structure,

Paul keeps the abort address in rcx.

> and shoving a
> pointer to *that* into TLABI space is one store instead of two.

> > Ah, so what happens if the signal happens before the commit but after
> > the load of the seqcount?
> >
> > Then, even if the signal motifies the count, we'll not observe.
> >
> 
> Where exactly?
> 
> In my scheme, nothing except the kernel ever loads the seqcount.  The
> user code generates a fresh value, writes it to memory, and then, just
> before commit, writes that same value to the TLABI area and then
> double-checks that the value it wrote at the beginning is still there.
> 
> If the signal modifies the count, then the user code won't directly
> notice, but prepare_exit_to_usermode on the way out of the signal will
> notice that the (restored) TLABI state doesn't match the counter that
> the signal handler changed and will just to the abort address.


OK, you lost me..  commit looks like:

+       __asm__ __volatile__ goto (
+                       "movq $%l[failed], %%rcx\n"
+                       "movq $1f, %[commit_instr]\n"
+                       "cmpq %[start_value], %[current_value]\n"

If we get preempted/signaled here without the preemption/signal entry
checking for the post_commit_instr, we'll fail hard.

+                       "jnz %l[failed]\n"
+                       "movq %[to_write], (%[target])\n"
+                       "1: movq $0, %[commit_instr]\n"
+         : /* no outputs */
+         : [start_value]"d"(start_value.storage),
+           [current_value]"m"(__rseq_state),
+           [to_write]"r"(to_write),
+           [target]"r"(p),
+           [commit_instr]"m"(__rseq_state.post_commit_instr)
+         : "rcx", "memory"
+         : failed
+       );
