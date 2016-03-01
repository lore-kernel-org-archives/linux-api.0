From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v4 1/5] getcpu_cache system call: cache CPU number of
 running thread
Date: Tue, 1 Mar 2016 22:32:02 +0100
Message-ID: <20160301213202.GY6357@twins.programming.kicks-ass.net>
References: <1456270120-7560-1-git-send-email-mathieu.desnoyers@efficios.com>
 <CA+55aFysWipEagSdgeXbLx+Au4vomvyttdNFJtM+HffmBECQiA@mail.gmail.com>
 <1401667361.10273.1456617236327.JavaMail.zimbra@efficios.com>
 <CA+55aFwcgwRxvVBz5kk_3O8dESXAGJ4KHBkf=pSXjiS7Xh4NwA@mail.gmail.com>
 <1082926946.10326.1456619994590.JavaMail.zimbra@efficios.com>
 <CA+55aFwZY1BR5NdjAP-rytd29hE2EZEXgcaBKjepWFFj+oR1SA@mail.gmail.com>
 <1538518747.10504.1456669948568.JavaMail.zimbra@efficios.com>
 <20160229103506.GJ6356@twins.programming.kicks-ass.net>
 <676569856.13488.1456863792603.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <676569856.13488.1456863792603.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 01, 2016 at 08:23:12PM +0000, Mathieu Desnoyers wrote:
> I think it's important that user-space fast-paths can quickly
> detect whether the feature is enabled without having to rely on
> always reading a separate cache-line. I've put together an ABI
> proposal that take into account the feedback received so far.

Nah, adding detectoring code to fast paths is silly, makes them less
fast. Doesn't userspace have self modifying code? I know that at least
glibc does linker trickery to call different functions depending on
runtime context.

> struct thread_local_abi {
>         /*
>          * Thread-local ABI cpu_id field.
>          * Updated by the kernel, and read by user-space with
>          * single-copy atomicity semantics. Aligned on 32-bit.
>          * Values:
>          * >= 0: CPU number of running thread.
>          * -1 (initial value): means the cpu_id feature is inactive.
>          * -2: cpu_id feature is not available.
>          */
>         int32_t cpu_id;
> 
>         /*
>          * Thread-local ABI rseq_seqnum field.
>          * Updated by the kernel, and read by user-space with
>          * single-copy atomicity semantics. Aligned on 32-bit.
>          * Values:
>          * >= 0: current seqnum for this thread (feature is active).
>          * -1 (initial value): means the rseq feature is inactive.
>          * -2: rseq feature is not available.
>          */
>         int32_t rseq_seqnum;

So I really hate that, that makes we have to check for these special
values whenever we increment the seq count and cannot have it wrap
naturally.
