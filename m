From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v7 7/7] Restartable sequences: self-tests
Date: Mon, 25 Jul 2016 16:43:29 +0000 (UTC)
Message-ID: <1031089010.81455.1469465009989.JavaMail.zimbra@efficios.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com> <1469135662-31512-8-git-send-email-mathieu.desnoyers@efficios.com> <CO1PR15MB09822FC140F84DCEEF2004CDDD0B0@CO1PR15MB0982.namprd15.prod.outlook.com> <1590181502.79032.1469329777708.JavaMail.zimbra@efficios.com> <CO1PR15MB09825505EBF36E0C56AA037ADD0C0@CO1PR15MB0982.namprd15.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CO1PR15MB09825505EBF36E0C56AA037ADD0C0-K8OqZrtvGWNkuEq+M2l22od3EbNNOtPMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Jul 24, 2016, at 2:01 PM, Dave Watson davejwatson-b10kYP2dOMg@public.gmane.org wrote:

>>> +static inline __attribute__((always_inline))
>>> +bool rseq_finish(struct rseq_lock *rlock,
>>> + intptr_t *p, intptr_t to_write,
>>> + struct rseq_state start_value)
> 
>>> This ABI looks like it will work fine for our use case. I don't think it
>>> has been mentioned yet, but we may still need multiple asm blocks
>>> for differing numbers of writes. For example, an array-based freelist push:
> 
>>> void push(void *obj) {
>>> if (index < maxlen) {
>>> freelist[index++] = obj;
>>> }
>>> }
> 
>>> would be more efficiently implemented with a two-write rseq_finish:
> 
>>> rseq_finish2(&freelist[index], obj, // first write
>>> &index, index + 1, // second write
>>> ...);
> 
>> Would pairing one rseq_start with two rseq_finish do the trick
>> there ?
> 
> Yes, two rseq_finish works, as long as the extra rseq management overhead
> is not substantial.

The different is actually not negligible. On x86-64
Intel(R) Xeon(R) CPU E5-2630 v3 @ 2.40GHz:
(counter increment benchmark (single-thread))

* Single store per increment:                                  3.6 ns
* Two rseq_finish() per increment:                             5.2 ns
* rseq_finish2() with two mov instructions per rseq_finish2(): 4.0 ns

And I expect the difference to be even larger on non-x86 architectures.

I'll try to figure out a way to do rseq_finish() and rseq_finish2()
without duplicating the code. Perhaps macros will be helpful there.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
