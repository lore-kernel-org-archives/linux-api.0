From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC PATCH v11 for 4.15 01/24] Restartable sequences system call
Date: Thu, 16 Nov 2017 21:46:04 +0100
Message-ID: <20171116204604.52m63ngws7zmyuac@hirez.programming.kicks-ass.net>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com>
 <20171114200414.2188-2-mathieu.desnoyers@efficios.com>
 <20171116191448.rmds347hwsyibipm@hirez.programming.kicks-ass.net>
 <1083699948.16848.1510864678185.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1083699948.16848.1510864678185.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 16, 2017 at 08:37:58PM +0000, Mathieu Desnoyers wrote:
> I usually never space-align with open parenthesis "(". Is it a coding
> style requirement of the kernel for multi-line if () conditions ?

Not sure, but it is the predominant pattern in most of the code.

> Would the following replatement code be ok ?
> 
>         if (unlikely(flags & RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL)) {
>                 if ((flags & (RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE
>                                 | RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT)) !=
>                                 (RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE
>                                 | RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT))
>                         return -EINVAL;

I really prefer the operator at the end,

git grep "&&$" | wc -l
40708

git grep "^[[:space:]]*&&" | wc -l
3901
