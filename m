From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v11 for 4.15 01/24] Restartable sequences system
 call
Date: Thu, 16 Nov 2017 16:27:07 +0000 (UTC)
Message-ID: <438349693.16595.1510849627973.JavaMail.zimbra@efficios.com>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com> <20171114200414.2188-2-mathieu.desnoyers@efficios.com> <20171116161815.dg4hi2z35rkh4u4s@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171116161815.dg4hi2z35rkh4u4s-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will>
List-Id: linux-api@vger.kernel.org

----- On Nov 16, 2017, at 11:18 AM, Peter Zijlstra peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org wrote:

> On Tue, Nov 14, 2017 at 03:03:51PM -0500, Mathieu Desnoyers wrote:
>> @@ -977,6 +978,13 @@ struct task_struct {
>>  	unsigned long			numa_pages_migrated;
>>  #endif /* CONFIG_NUMA_BALANCING */
>>  
>> +#ifdef CONFIG_RSEQ
>> +	struct rseq __user *rseq;
>> +	u32 rseq_len;
>> +	u32 rseq_sig;
>> +	bool rseq_preempt, rseq_signal, rseq_migrate;
> 
> No bool please. Use something that has a defined size in ILP32/LP64.
> _Bool makes it absolutely impossible to speculate on structure layout
> across architectures.

I should as well make all those a bitmask within a "u32 rseq_event_mask" then,
sounds fair ?

Thanks,

Mathieu

> 
>> +#endif
>> +
>>  	struct tlbflush_unmap_batch	tlb_ubc;
>>  
> >  	struct rcu_head			rcu;

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
