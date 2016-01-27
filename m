From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [RFC PATCH v2 1/3] getcpu_cache system call: cache CPU number of
 running thread
Date: Wed, 27 Jan 2016 09:20:44 -0800
Message-ID: <20160127172044.GA7514@cloud>
References: <1453913683-28915-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1453913683-28915-2-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1453913683-28915-2-git-send-email-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 27, 2016 at 11:54:41AM -0500, Mathieu Desnoyers wrote:
> Expose a new system call allowing threads to register one userspace
> memory area where to store the CPU number on which the calling thread is
> running. Scheduler migration sets the TIF_NOTIFY_RESUME flag on the
> current thread. Upon return to user-space, a notify-resume handler
> updates the current CPU value within each registered user-space memory
> area. User-space can then read the current CPU number directly from
> memory.
> 
> This getcpu cache is an improvement over current mechanisms available to
> read the current CPU number, which has the following benefits:
> 
> - 44x speedup on ARM vs system call through glibc,
> - 14x speedup on x86 compared to calling glibc, which calls vdso
>   executing a "lsl" instruction,
> - 11x speedup on x86 compared to inlined "lsl" instruction,
> - Unlike vdso approaches, this cached value can be read from an inline
>   assembly, which makes it a useful building block for restartable
>   sequences.
> - The getcpu cache approach is portable (e.g. ARM), which is not the
>   case for the lsl-based x86 vdso.
> 
> On x86, yet another possible approach would be to use the gs segment
> selector to point to user-space per-cpu data. This approach performs
> similarly to the getcpu cache, but it has two disadvantages: it is
> not portable, and it is incompatible with existing applications already
> using the gs segment selector for other purposes.
> 
> This approach is inspired by Paul Turner and Andrew Hunter's work
> on percpu atomics, which lets the kernel handle restart of critical
> sections:
> Ref.:
> * https://lkml.org/lkml/2015/10/27/1095
> * https://lkml.org/lkml/2015/6/24/665
> * https://lwn.net/Articles/650333/
> * http://www.linuxplumbersconf.org/2013/ocw/system/presentations/1695/original/LPC%20-%20PerCpu%20Atomics.pdf
> 
> Benchmarking various approaches for reading the current CPU number:
> 
> ARMv7 Processor rev 10 (v7l)
> Machine model: Wandboard i.MX6 Quad Board
> - Baseline (empty loop):               10.1 ns
> - Read CPU from getcpu cache:          10.1 ns
> - glibc 2.19-0ubuntu6.6 getcpu:       445.6 ns
> - getcpu system call:                 322.2 ns
> 
> x86-64 Intel(R) Xeon(R) CPU E5-2630 v3 @ 2.40GHz:
> - Baseline (empty loop):                1.0 ns
> - Read CPU from getcpu cache:           1.0 ns
> - Read using gs segment selector:       1.0 ns
> - "lsl" inline assembly:               11.2 ns
> - glibc 2.19-0ubuntu6.6 getcpu:        14.3 ns
> - getcpu system call:                  51.0 ns
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
> CC: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> CC: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> CC: Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> CC: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> CC: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
> CC: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
> CC: Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
> CC: Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
> CC: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> CC: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>
> CC: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
> CC: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> CC: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
> CC: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> CC: Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
> CC: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
> CC: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
> CC: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
> 
> Changes since v1:
> 
> - Return -1, errno=EINVAL if cpu_cache pointer is not aligned on
>   sizeof(int32_t).
> - Update man page to describe the pointer alignement requirements and
>   update atomicity guarantees.
> - Add MAINTAINERS file GETCPU_CACHE entry.
> - Remove dynamic memory allocation: go back to having a single
>   getcpu_cache entry per thread. Update documentation accordingly.
> - Rebased on Linux 4.4.

With the dynamic allocation removed, this seems sensible to me.  One
minor nit: s/int32_t/uint32_t/g, since a location intended to hold a CPU
number should never need to hold a negative number.
