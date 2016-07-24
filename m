From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v7 7/7] Restartable sequences: self-tests
Date: Sun, 24 Jul 2016 03:09:37 +0000 (UTC)
Message-ID: <1590181502.79032.1469329777708.JavaMail.zimbra@efficios.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com> <1469135662-31512-8-git-send-email-mathieu.desnoyers@efficios.com> <CO1PR15MB09822FC140F84DCEEF2004CDDD0B0@CO1PR15MB0982.namprd15.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CO1PR15MB09822FC140F84DCEEF2004CDDD0B0-K8OqZrtvGWNkuEq+M2l22od3EbNNOtPMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Jul 23, 2016, at 5:26 PM, Dave Watson davejwatson-b10kYP2dOMg@public.gmane.org wrote:

> Hi Mathieu,

> > Implements two basic tests of RSEQ functionality, and one more
> > exhaustive parameterizable test.

> Thanks for beefing up the tests. I ran this set through our jemalloc
> tests using rseq, and everything looks good so far.

> +static inline __attribute__((always_inline))
> +bool rseq_finish(struct rseq_lock *rlock,
> + intptr_t *p, intptr_t to_write,
> + struct rseq_state start_value)
> +{
> + RSEQ_INJECT_C(9)
> +
> + if (unlikely(start_value.lock_state != RSEQ_LOCK_STATE_RESTART)) {
> + if (start_value.lock_state == RSEQ_LOCK_STATE_LOCK)
> + rseq_fallback_wait(rlock);
> + return false;
> + }
> +
> +#ifdef __x86_64__
> + /*
> + * The __rseq_table section can be used by debuggers to better
> + * handle single-stepping through the restartable critical
> + * sections.
> + */
> + __asm__ __volatile__ goto (
> + ".pushsection __rseq_table, \"aw\"\n\t"
> + ".balign 8\n\t"
> + "4:\n\t"
> + ".quad 1f, 2f, 3f\n\t"
> + ".popsection\n\t"

> Is there a reason we're also passing the start ip? It looks unused.
> I see the "for debuggers" comment, but it looks like all the debugger
> support is done in userspace.

> + "1:\n\t"
> + RSEQ_INJECT_ASM(1)
> + "movq $4b, (%[rseq_cs])\n\t"
> + RSEQ_INJECT_ASM(2)
> + "cmpl %[start_event_counter], %[current_event_counter]\n\t"
> + "jnz 3f\n\t"
> + RSEQ_INJECT_ASM(3)
> + "movq %[to_write], (%[target])\n\t"
> + "2:\n\t"
> + RSEQ_INJECT_ASM(4)
> + "movq $0, (%[rseq_cs])\n\t"
> + "jmp %l[succeed]\n\t"
> + "3: movq $0, (%[rseq_cs])\n\t"
> + : /* no outputs */
> + : [start_event_counter]"r"(start_value.event_counter),
> + [current_event_counter]"m"(start_value.rseqp->abi.u.e.event_counter),
> + [to_write]"r"(to_write),
> + [target]"r"(p),
> + [rseq_cs]"r"(&start_value.rseqp->abi.rseq_cs)
> + RSEQ_INJECT_INPUT
> + : "memory", "cc"
> + RSEQ_INJECT_CLOBBER
> + : succeed
> + );

> This ABI looks like it will work fine for our use case. I don't think it
> has been mentioned yet, but we may still need multiple asm blocks
> for differing numbers of writes. For example, an array-based freelist push:

> void push(void *obj) {
> if (index < maxlen) {
> freelist[index++] = obj;
> }
> }

> would be more efficiently implemented with a two-write rseq_finish:

> rseq_finish2(&freelist[index], obj, // first write
> &index, index + 1, // second write
> ...);

> where it is ok to abort between the two writes, but both need to happen
> on the same cpu.

(re-send without html formatting for the mailing lists)

Would pairing one rseq_start with two rseq_finish do the trick
there ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
