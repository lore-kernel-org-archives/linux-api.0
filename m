From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v6 1/5] Thread-local ABI system call: cache CPU
 number of running thread
Date: Thu, 7 Apr 2016 20:55:41 +0000 (UTC)
Message-ID: <1353194988.49705.1460062541205.JavaMail.zimbra@efficios.com>
References: <1459789313-4917-1-git-send-email-mathieu.desnoyers@efficios.com> <20160407103158.GP3430@twins.programming.kicks-ass.net> <570638D9.7010108@redhat.com> <20160407111938.GR3430@twins.programming.kicks-ass.net> <CA+55aFxrWx5pFN3LseaKpUHtB6nqXtkgP84seU3pjys-kq7utQ@mail.gmail.com> <CA+55aFyB6CPNiMKGWoaV7vxFWWBTgqOTqG4u2aNnq6uq1cHWZA@mail.gmail.com> <1025228632.49344.1460054592801.JavaMail.zimbra@efficios.com> <20160407202232.GF9407@two.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160407202232.GF9407-1g7Xle2YJi4/4alezvVtWx2eb7JE58TQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Apr 7, 2016, at 4:22 PM, Andi Kleen andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org wrote:

>> One basic use of cpu id cache is to speed up the sched_getcpu(3)
>> implementation in glibc. This is why I'm proposing it as a stand-alone
> 
> I don't think rseq is needed for faster getcpu.

I agree that rseq is not needed for faster getcpu. This is why I was proposing
to make "cpu_id" feature configurable separately from the rseq feature.
E.g. a kernel configuration that don't want to take the hit of rseq handling
in signal delivery and preemption could just enable the cpu_id feature, and
thus only need to add work in the migration code path, and when returning to
userspace. Also, if a thread only registers the cpu_id feature, the kernel
can skip the rseq code quickly in signal delivery and preemption too.

> 
> User space has to be able handle stale return values anyways, as it
> has no way to lock itself to a cpu while it is using the return value.
> So it can be only a hint.
> 
> The original version of getcpu just had a jiffies based cache. The CPU
> value was valid up to a jiffie (the next time jiffie changes), and then it
> gets looked up again.
> 
> Processes are unlikely to switch CPUs more often than a jiffie, so it's
> good enough as a hint.

One example use-case where this would hurt: we use the CPU id heavily when
tracing to a ring buffer in user-space. Having one event written into the
wrong buffer once in a while is not a big deal, but tracing a whole burst
of events within a jiffy (e.g. 4ms at 250Hz) to the wrong cpu buffer
whenever the thread migrates is really an unwanted side-effect latency-wise.

> 
> This doesn't need any new kernel interfaces at all because jiffies is already
> exported to the vdso.

My understanding is that although your assumptions about availability of
those features in vdso are true for x86 32/64, but do not currently apply
to ARM32.

ARM32 is my main target architecture for the CPU id cache work. x86 32/64
simply also happen to benefit from that work too (see my benchmark numbers
in changelog of patch 1/5).

> It just needs a new entry point into the vdso that handles the jiffie
> check.

This would likely require to extend the ARM vdso page to expose the jiffies
counter to user-space, and update user-space libraries to use this counter
in sched_getcpu. But it would still be slower than the cpu_id cache I propose,
due to the required function call to sched_getcpu, unless you want to open-code
the jiffies check within all applications as an ABI. It would also be bad for
fast bursts of cpu id use (e.g. per-cpu ring buffers).

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
