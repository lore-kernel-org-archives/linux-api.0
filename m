From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v7 7/7] Restartable sequences: self-tests
Date: Fri, 12 Aug 2016 19:36:13 +0000 (UTC)
Message-ID: <753387169.9345.1471030573282.JavaMail.zimbra@efficios.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com> <1469135662-31512-8-git-send-email-mathieu.desnoyers@efficios.com> <CO1PR15MB09822FC140F84DCEEF2004CDDD0B0@CO1PR15MB0982.namprd15.prod.outlook.com> <1590181502.79032.1469329777708.JavaMail.zimbra@efficios.com> <CO1PR15MB09825505EBF36E0C56AA037ADD0C0@CO1PR15MB0982.namprd15.prod.outlook.com> <374861479.8581.1470957990793.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <374861479.8581.1470957990793.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Aug 11, 2016, at 7:26 PM, Mathieu Desnoyers mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org wrote:

> ----- On Jul 24, 2016, at 2:01 PM, Dave Watson davejwatson-b10kYP2dOMg@public.gmane.org wrote:
> 
>>>> +static inline __attribute__((always_inline))
>>>> +bool rseq_finish(struct rseq_lock *rlock,
>>>> + intptr_t *p, intptr_t to_write,
>>>> + struct rseq_state start_value)
>> 
>>>> This ABI looks like it will work fine for our use case. I don't think it
>>>> has been mentioned yet, but we may still need multiple asm blocks
>>>> for differing numbers of writes. For example, an array-based freelist push:
>> 
>>>> void push(void *obj) {
>>>> if (index < maxlen) {
>>>> freelist[index++] = obj;
>>>> }
>>>> }
>> 
>>>> would be more efficiently implemented with a two-write rseq_finish:
>> 
>>>> rseq_finish2(&freelist[index], obj, // first write
>>>> &index, index + 1, // second write
>>>> ...);
>> 
>>> Would pairing one rseq_start with two rseq_finish do the trick
>>> there ?
>> 
>> Yes, two rseq_finish works, as long as the extra rseq management overhead
>> is not substantial.
> 
> I've added a commit implementing rseq_finish2() in my rseq volatile
> dev branch. You can fetch it at:
> 
> https://github.com/compudj/linux-percpu-dev/tree/rseq-fallback
> 
> I also have a separate test and benchmark tree in addition to the
> kernel selftests here:
> 
> https://github.com/compudj/rseq-test
> 
> I named the first write a "speculative" write, and the second write
> the "final" write.
> 
> Would you like to extend the test cases to cover your intended use-case ?
> 

Hi Dave!

I just pushed a rseq_finish2() test in my rseq-fallback branch. It implements
a per-cpu buffer holding pointers, and pushes/pops items to/from it.

To use it:

cd tools/testing/selftests/rseq
./param_test -T b

(see -h for advanced usage)

Let me know if I got it right!

Thanks,

Mathieu

> Thanks,
> 
> Mathieu
> 
> --
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
