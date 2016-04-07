From: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
Subject: Re: [RFC PATCH v6 1/5] Thread-local ABI system call: cache CPU
 number of running thread
Date: Thu, 7 Apr 2016 13:22:32 -0700
Message-ID: <20160407202232.GF9407@two.firstfloor.org>
References: <1459789313-4917-1-git-send-email-mathieu.desnoyers@efficios.com>
 <20160405164722.GB3430@twins.programming.kicks-ass.net>
 <570621E5.7060306@redhat.com>
 <20160407103158.GP3430@twins.programming.kicks-ass.net>
 <570638D9.7010108@redhat.com>
 <20160407111938.GR3430@twins.programming.kicks-ass.net>
 <CA+55aFxrWx5pFN3LseaKpUHtB6nqXtkgP84seU3pjys-kq7utQ@mail.gmail.com>
 <CA+55aFyB6CPNiMKGWoaV7vxFWWBTgqOTqG4u2aNnq6uq1cHWZA@mail.gmail.com>
 <1025228632.49344.1460054592801.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1025228632.49344.1460054592801.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Bo
List-Id: linux-api@vger.kernel.org

> One basic use of cpu id cache is to speed up the sched_getcpu(3)
> implementation in glibc. This is why I'm proposing it as a stand-alone

I don't think rseq is needed for faster getcpu.

User space has to be able handle stale return values anyways, as it
has no way to lock itself to a cpu while it is using the return value.
So it can be only a hint.

The original version of getcpu just had a jiffies based cache. The CPU
value was valid up to a jiffie (the next time jiffie changes), and then it
gets looked up again.

Processes are unlikely to switch CPUs more often than a jiffie, so it's
good enough as a hint.
 
This doesn't need any new kernel interfaces at all because jiffies is already
exported to the vdso.

It just needs a new entry point into the vdso that handles the jiffie
check.

-Andi
