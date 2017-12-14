From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC PATCH for 4.16 02/21] rseq: Introduce restartable sequences
 system call (v12)
Date: Thu, 14 Dec 2017 22:20:23 +0100
Message-ID: <20171214212023.GJ3326@worktop>
References: <20171214161403.30643-1-mathieu.desnoyers@efficios.com>
 <20171214161403.30643-3-mathieu.desnoyers@efficios.com>
 <alpine.DEB.2.20.1712141033100.6249@nuc-kabylake>
 <12046460.34426.1513275177081.JavaMail.zimbra@efficios.com>
 <alpine.DEB.2.20.1712141238180.8340@nuc-kabylake>
 <1537392285.34532.1513279478488.JavaMail.zimbra@efficios.com>
 <alpine.DEB.2.20.1712141512360.8945@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1712141512360.8945@nuc-kabylake>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas@arm.c>
List-Id: linux-api@vger.kernel.org

On Thu, Dec 14, 2017 at 03:14:00PM -0600, Christopher Lameter wrote:
> On Thu, 14 Dec 2017, Mathieu Desnoyers wrote:
> 
> > If we port this concept to kernel-space (as I start to understand
> > would be your wish), then a simple pointer store to the current
> > task_struct would suffice.
> 
> Certainly such a port would be beneficial for non x86 archs.
> 
> But my company has extensive user space code that maintains a lot of
> counters and does other tricks to get full performance out of the
> hardware. Such a mechanism would also be good from user space. Why keep
> the good stuff only inside the kernel?

Mathieu's proposal is for userspace, _only_ userspace.
