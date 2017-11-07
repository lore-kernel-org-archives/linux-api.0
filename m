From: Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [RFC PATCH v10 for 4.15 01/14] Restartable sequences system call
Date: Tue, 7 Nov 2017 09:24:24 +0800
Message-ID: <20171107012424.GB6280@tardis>
References: <20171106205644.29386-1-mathieu.desnoyers@efficios.com>
 <20171106205644.29386-2-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Fba/0zbH8Xs+Fj9o"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171106205644.29386-2-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org


--Fba/0zbH8Xs+Fj9o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 06, 2017 at 03:56:31PM -0500, Mathieu Desnoyers wrote:
[...]
> +
> +/*
> + * struct rseq is aligned on 4 * 8 bytes to ensure it is always
> + * contained within a single cache-line.
> + *
> + * A single struct rseq per thread is allowed.
> + */
> +struct rseq {
> +	/*
> +	 * Restartable sequences cpu_id_start field. Updated by the
> +	 * kernel, and read by user-space with single-copy atomicity
> +	 * semantics. Aligned on 32-bit. Always contain a value in the
> +	 * range of possible CPUs, although the value may not be the
> +	 * actual current CPU (e.g. if rseq is not initialized). This
> +	 * CPU number value should always be confirmed against the value
> +	 * of the cpu_id field.
> +	 */
> +	uint32_t cpu_id_start;
> +	/*
> +	 * Restartable sequences cpu_id field. Updated by the kernel,
> +	 * and read by user-space with single-copy atomicity semantics.
> +	 * Aligned on 32-bit. Values -1U and -2U have a special
> +	 * semantic: -1U means "rseq uninitialized", and -2U means "rseq
> +	 * initialization failed".
> +	 */
> +	uint32_t cpu_id;
> +	/*
> +	 * Restartable sequences rseq_cs field.
> +	 *
> +	 * Contains NULL when no critical section is active for the current
> +	 * thread, or holds a pointer to the currently active struct rseq_cs.
> +	 *
> +	 * Updated by user-space at the beginning of assembly instruction
> +	 * sequence block, and by the kernel when it restarts an assembly
> +	 * instruction sequence block, and when the kernel detects that it
> +	 * is preempting or delivering a signal outside of the range
> +	 * targeted by the rseq_cs. Also needs to be cleared by user-space
> +	 * before reclaiming memory that contains the targeted struct
> +	 * rseq_cs.
> +	 *
> +	 * Read and set by the kernel with single-copy atomicity semantics.
> +	 * Aligned on 64-bit.
> +	 */
> +	RSEQ_FIELD_u32_u64(rseq_cs);
> +	/*
> +	 * - RSEQ_DISABLE flag:
> +	 *
> +	 * Fallback fast-track flag for single-stepping.
> +	 * Set by user-space if lack of progress is detected.
> +	 * Cleared by user-space after rseq finish.
> +	 * Read by the kernel.
> +	 * - RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT
> +	 *     Inhibit instruction sequence block restart and event
> +	 *     counter increment on preemption for this thread.

Nit: "event counter" has been removed entirely ;-)

> +	 * - RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL
> +	 *     Inhibit instruction sequence block restart and event
> +	 *     counter increment on signal delivery for this thread.
> +	 * - RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE
> +	 *     Inhibit instruction sequence block restart and event
> +	 *     counter increment on migration for this thread.
> +	 */
> +	uint32_t flags;
> +} __attribute__((aligned(4 * sizeof(uint64_t))));
> +
> +#endif /* _UAPI_LINUX_RSEQ_H */
[...]
> +	} else {
> +		/*
> +		 * If there was no rseq previously registered,
> +		 * we need to ensure the provided rseq is
> +		 * properly aligned and valid.
> +		 */
> +		if (!IS_ALIGNED((unsigned long)rseq, __alignof__(*rseq))
> +				|| rseq_len != sizeof(*rseq))
> +			return -EINVAL;
> +		if (!access_ok(VERIFY_WRITE, rseq, rseq_len))
> +			return -EFAULT;
> +		current->rseq = rseq;
> +		current->rseq_len = rseq_len;
> +		current->rseq_sig = sig;
> +		/*
> +		 * If rseq was previously inactive, and has just
> +		 * been registered, ensure the cpu_id and
> +		 * event_counter fields are updated before

s/event_counter/cpu_start_id/ ?

Regards,
Boqun

> +		 * returning to user-space.
> +		 */
> +		rseq_set_notify_resume(current);
> +	}
> +
> +	return 0;
> +}
[...]

--Fba/0zbH8Xs+Fj9o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEj5IosQTPz8XU1wRHSXnow7UH+rgFAloBCzAACgkQSXnow7UH
+rh5kgf8DdscO+BkvEsWLYd8FuiBt/DjH9XFZ5iIorgkJvhlYcIHbosUFgbAsnu8
ZG8Fj0/DUW6Av51/29qu/9SzZ0e0MWRQ2L6sRLH9k9mTrq0YZ+xEEdLMCUMSiovG
9tbizablJHA1DzahbYk/U7o2keEv9ov3zuFL73X+7AW4p7IAAPa5/a10CYki3nV/
ppO2L8gb/FkPIExOtgB59X9jmwnWTcMoLx5z+eg6ioIa4TfWWdkGriOr/3ddn3Vv
gwRqyKsbdDsZ329WYlJfINP0bezH9vgQz6hKTzlPcOER6pURG+Ji7qiQpuiRJeHi
1kBH4GC4ap92TrSThcA8yLQdqgc55Q==
=rM6n
-----END PGP SIGNATURE-----

--Fba/0zbH8Xs+Fj9o--
