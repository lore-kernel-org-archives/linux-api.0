From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v10 for 4.15 01/14] Restartable sequences system
 call
Date: Tue, 7 Nov 2017 02:20:31 +0000 (UTC)
Message-ID: <1057691675.6149.1510021231078.JavaMail.zimbra@efficios.com>
References: <20171106205644.29386-1-mathieu.desnoyers@efficios.com> <20171106205644.29386-2-mathieu.desnoyers@efficios.com> <20171107012424.GB6280@tardis>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171107012424.GB6280@tardis>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Nov 6, 2017, at 8:24 PM, Boqun Feng boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> On Mon, Nov 06, 2017 at 03:56:31PM -0500, Mathieu Desnoyers wrote:
> [...]
>> +
>> +/*
>> + * struct rseq is aligned on 4 * 8 bytes to ensure it is always
>> + * contained within a single cache-line.
>> + *
>> + * A single struct rseq per thread is allowed.
>> + */
>> +struct rseq {
>> +	/*
>> +	 * Restartable sequences cpu_id_start field. Updated by the
>> +	 * kernel, and read by user-space with single-copy atomicity
>> +	 * semantics. Aligned on 32-bit. Always contain a value in the
>> +	 * range of possible CPUs, although the value may not be the
>> +	 * actual current CPU (e.g. if rseq is not initialized). This
>> +	 * CPU number value should always be confirmed against the value
>> +	 * of the cpu_id field.
>> +	 */
>> +	uint32_t cpu_id_start;
>> +	/*
>> +	 * Restartable sequences cpu_id field. Updated by the kernel,
>> +	 * and read by user-space with single-copy atomicity semantics.
>> +	 * Aligned on 32-bit. Values -1U and -2U have a special
>> +	 * semantic: -1U means "rseq uninitialized", and -2U means "rseq
>> +	 * initialization failed".
>> +	 */
>> +	uint32_t cpu_id;
>> +	/*
>> +	 * Restartable sequences rseq_cs field.
>> +	 *
>> +	 * Contains NULL when no critical section is active for the current
>> +	 * thread, or holds a pointer to the currently active struct rseq_cs.
>> +	 *
>> +	 * Updated by user-space at the beginning of assembly instruction
>> +	 * sequence block, and by the kernel when it restarts an assembly
>> +	 * instruction sequence block, and when the kernel detects that it
>> +	 * is preempting or delivering a signal outside of the range
>> +	 * targeted by the rseq_cs. Also needs to be cleared by user-space
>> +	 * before reclaiming memory that contains the targeted struct
>> +	 * rseq_cs.
>> +	 *
>> +	 * Read and set by the kernel with single-copy atomicity semantics.
>> +	 * Aligned on 64-bit.
>> +	 */
>> +	RSEQ_FIELD_u32_u64(rseq_cs);
>> +	/*
>> +	 * - RSEQ_DISABLE flag:
>> +	 *
>> +	 * Fallback fast-track flag for single-stepping.
>> +	 * Set by user-space if lack of progress is detected.
>> +	 * Cleared by user-space after rseq finish.
>> +	 * Read by the kernel.
>> +	 * - RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT
>> +	 *     Inhibit instruction sequence block restart and event
>> +	 *     counter increment on preemption for this thread.
> 
> Nit: "event counter" has been removed entirely ;-)
> 
>> +	 * - RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL
>> +	 *     Inhibit instruction sequence block restart and event
>> +	 *     counter increment on signal delivery for this thread.
>> +	 * - RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE
>> +	 *     Inhibit instruction sequence block restart and event
>> +	 *     counter increment on migration for this thread.
>> +	 */
>> +	uint32_t flags;
>> +} __attribute__((aligned(4 * sizeof(uint64_t))));
>> +
>> +#endif /* _UAPI_LINUX_RSEQ_H */
> [...]
>> +	} else {
>> +		/*
>> +		 * If there was no rseq previously registered,
>> +		 * we need to ensure the provided rseq is
>> +		 * properly aligned and valid.
>> +		 */
>> +		if (!IS_ALIGNED((unsigned long)rseq, __alignof__(*rseq))
>> +				|| rseq_len != sizeof(*rseq))
>> +			return -EINVAL;
>> +		if (!access_ok(VERIFY_WRITE, rseq, rseq_len))
>> +			return -EFAULT;
>> +		current->rseq = rseq;
>> +		current->rseq_len = rseq_len;
>> +		current->rseq_sig = sig;
>> +		/*
>> +		 * If rseq was previously inactive, and has just
>> +		 * been registered, ensure the cpu_id and
>> +		 * event_counter fields are updated before
> 
> s/event_counter/cpu_start_id/ ?

I guess you mean "cpu_id_start".

Good point. v11 will include that fix. Meanwhile, it is available
at https://git.kernel.org/pub/scm/linux/kernel/git/rseq/linux-rseq.git/log/?h=rseq/dev

Thanks,

Mathieu

> 
> Regards,
> Boqun
> 
>> +		 * returning to user-space.
>> +		 */
>> +		rseq_set_notify_resume(current);
>> +	}
>> +
>> +	return 0;
>> +}
> [...]

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
