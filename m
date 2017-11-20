From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [RFC PATCH v3 for 4.15 08/24] Provide cpu_opv system call
Date: Mon, 20 Nov 2017 20:44:18 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1711202037280.2348@nanos>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com> <20171114200414.2188-9-mathieu.desnoyers@efficios.com> <alpine.DEB.2.20.1711162215100.2109@nanos> <1766414702.18278.1511194398489.JavaMail.zimbra@efficios.com> <alpine.DEB.2.20.1711201831490.1734@nanos>
 <204285712.18480.1511203151076.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <204285712.18480.1511203151076.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <wil>
List-Id: linux-api@vger.kernel.org

On Mon, 20 Nov 2017, Mathieu Desnoyers wrote:
> ----- On Nov 20, 2017, at 12:48 PM, Thomas Gleixner tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org wrote:
> The use-case for 4k memcpy operation is a per-cpu ring buffer where
> the rseq fast-path does the following:
> 
> - ring buffer push: in the rseq asm instruction sequence, a memcpy of a
>   given structure (limited to 4k in size) into a ring buffer,
>   followed by the final commit instruction which increments the current
>   position offset by the number of bytes pushed.
> 
> - ring buffer pop: in the rseq asm instruction sequence, a memcpy of
>   a given structure (up to 4k) from the ring buffer, at "position" offset.
>   The final commit instruction decrements the current position offset by
>   the number of bytes pop'd.
> 
> Having cpu_opv do a 4k memcpy allow it to handle scenarios where
> rseq fails to progress.

I'm still confused. Before you talked about the sequence:

    1) Reserve

    2) Commit

and both use rseq, but obviously you cannot do two "atomic" operation in
one section.

So now you talk about push. Is that what you described earlier as commit?

Assumed that it is, I still have no idea why the memcpy needs to happen in
that preempt disabled region.

If you have space reserved, then the copy does not have any dependencies
neither on the cpu it runs on nor on anything else. So the only
interresting operation is the final commit instruction which tells the
consumer that its ready.

So what is the part I am missing here aside of having difficulties to map
the constantly changing names of this stuff?

Thanks,

	tglx
