From: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
Subject: Re: [RFC PATCH 1/2] thread_local_abi system call: caching current
 CPU number (x86)
Date: Sun, 13 Dec 2015 21:18:41 +0100
Message-ID: <20151213201841.GW15533@two.firstfloor.org>
References: <1449761990-23525-1-git-send-email-mathieu.desnoyers@efficios.com>
 <20151213181527.GV15533@two.firstfloor.org>
 <450134747.239045.1450036728930.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <450134747.239045.1450036728930.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

> In the context of restartable sequences [1] [2], the goal is to turn
> atomic operations on per-cpu data into a sequence of simple load/store
> operations. Therefore, improving getcpu from 12ns to 0.3ns will have a

I don't think LSL is 12ns. It's a few cycles.

> Moreover, AFAIU, restartable sequences cannot do the function call
> required by the  vdso while within the c.s.: those need to entirely fit
> within an inline assembly. So this CPU number caching actually enables
> restartable sequences, whereas the vdso approach cannot be used in that
> context.

You can use the LSL directly though. In practice people already rely
on it (and it's very cheap on the kernel side), so it's a defacto ABI
and could be documented.

So it's not function call vs load, but LSL vs load.

> 
> Finally, even if overall this new system call is not deemed sufficiently
> interesting on x86, other popular architectures such as ARM32 don't have
> any vDSO for getcpu at the moment, mainly because they don't have similar
> segment selector tricks, and I'm not aware of other solutions than caching

Has that been confirmed by architecture experts? Maybe there is some
trick there too.

> I suspect that most of the difference between the vDSO approach and
> CPU number caching is simply the function call required for the vDSO.
> I doubt there is much to be done on this front.

Not sure about that. Basic function calls are not that expensive. Right
now there is some baggage but that could be optimized. The only
unavoidable overhead would be the ABI register clobbering.

-Andi
