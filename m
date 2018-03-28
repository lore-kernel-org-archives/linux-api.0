From: Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [RFC PATCH for 4.17 02/21] rseq: Introduce restartable sequences
 system call (v12)
Date: Wed, 28 Mar 2018 14:47:54 +0800
Message-ID: <20180328064703.56hsuicmikejg7np@tardis>
References: <20180327160542.28457-1-mathieu.desnoyers@efficios.com>
 <20180327160542.28457-3-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yzsuj5wf7xcogpl6"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180327160542.28457-3-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org


--yzsuj5wf7xcogpl6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 27, 2018 at 12:05:23PM -0400, Mathieu Desnoyers wrote:
[...]
> Changes since v11:
>=20
> - Replace task struct rseq_preempt, rseq_signal, and rseq_migrate
>   bool by u32 rseq_event_mask.
[...]
> @@ -979,6 +980,17 @@ struct task_struct {
>  	unsigned long			numa_pages_migrated;
>  #endif /* CONFIG_NUMA_BALANCING */
> =20
> +#ifdef CONFIG_RSEQ
> +	struct rseq __user *rseq;
> +	u32 rseq_len;
> +	u32 rseq_sig;
> +	/*
> +	 * RmW on rseq_event_mask must be performed atomically
> +	 * with respect to preemption.
> +	 */
> +	unsigned long rseq_event_mask;

s/unsigned long/u32

> +#endif
> +
>  	struct tlbflush_unmap_batch	tlb_ubc;
> =20
>  	struct rcu_head			rcu;
> @@ -1688,4 +1700,110 @@ extern long sched_getaffinity(pid_t pid, struct c=
pumask *mask);
>  #define TASK_SIZE_OF(tsk)	TASK_SIZE
>  #endif
> =20

[...]

> +
> +static int rseq_ip_fixup(struct pt_regs *regs)
> +{
> +	unsigned long ip =3D instruction_pointer(regs), start_ip =3D 0,
> +		post_commit_offset =3D 0, abort_ip =3D 0;
> +	struct task_struct *t =3D current;
> +	uint32_t cs_flags =3D 0;
> +	bool in_rseq_cs =3D false;

This seems unnecessary? Because..

> +	int ret;
> +
> +	ret =3D rseq_get_rseq_cs(t, &start_ip, &post_commit_offset, &abort_ip,
> +			&cs_flags);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * Handle potentially not being within a critical section.
> +	 * Unsigned comparison will be true when
> +	 * ip >=3D start_ip, and when ip < start_ip + post_commit_offset.
> +	 */
> +	if (ip - start_ip < post_commit_offset)
> +		in_rseq_cs =3D true;
> +
> +	/*
> +	 * If not nested over a rseq critical section, restart is
> +	 * useless. Clear the rseq_cs pointer and return.
> +	 */
> +	if (!in_rseq_cs)
> +		return clear_rseq_cs(t);

we can write

	if (ip - start_ip >=3D post_commit_offset)
		return clear_rseq_cs(t);

Regards,
Boqun

> +	ret =3D rseq_need_restart(t, cs_flags);
> +	if (ret <=3D 0)
> +		return ret;
> +	ret =3D clear_rseq_cs(t);
> +	if (ret)
> +		return ret;
> +	trace_rseq_ip_fixup(ip, start_ip, post_commit_offset, abort_ip);
> +	instruction_pointer_set(regs, (unsigned long)abort_ip);
> +	return 0;
> +}
> +
[...]

--yzsuj5wf7xcogpl6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEj5IosQTPz8XU1wRHSXnow7UH+rgFAlq7OpYACgkQSXnow7UH
+rjwhQf+LeKpKOoiYs2E75v4BONhGBr6S9icQvXV25bXj3nlHUJSOW9yHPtN3wjq
GwR0eZQkCfKm5ir9BDyRe1L5nKYDWVz7qdj6IDN67yPr6fnAFPw1SNIM8RsOBvn2
d5bLKbPAEJIvv0JWH7VQedq4SlQYfCKPrv0ue45QReE1FsxlDXPt1Aq3El4BUMaw
yXEA4xMijOFqk8WOspEjgRkHn/k9jOCKpkVg/dCAu9OZ6Ivqsr4GKvaSpoo9RMfF
EqR0/az/GkdJNEh0QlApYNNhBxB+dHd49bMN1K4ql2G7j1St+g6Vdb/3i6KM9PWJ
alGOemjl4GXknHu6RE4U9ODYpGUBtQ==
=e8tt
-----END PGP SIGNATURE-----

--yzsuj5wf7xcogpl6--
