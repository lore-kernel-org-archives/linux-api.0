From: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v2 for 4.15 08/14] Provide cpu_opv system call
Date: Tue, 7 Nov 2017 10:07:11 +0800
Message-ID: <20171107020711.GA6095@tardis>
References: <20171106205644.29386-1-mathieu.desnoyers@efficios.com>
 <20171106205644.29386-9-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171106205644.29386-9-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 06, 2017 at 03:56:38PM -0500, Mathieu Desnoyers wrote:
[...]
> +static int cpu_op_pin_pages(unsigned long addr, unsigned long len,
> +		struct page ***pinned_pages_ptr, size_t *nr_pinned,
> +		int write)
> +{
> +	struct page *pages[2];
> +	int ret, nr_pages;
> +
> +	if (!len)
> +		return 0;
> +	nr_pages = cpu_op_range_nr_pages(addr, len);
> +	BUG_ON(nr_pages > 2);
> +	if (*nr_pinned + nr_pages > NR_PINNED_PAGES_ON_STACK) {

Is this a bug? Seems you will kzalloc() every time if *nr_pinned is
bigger than NR_PINNED_PAGES_ON_STACK, which will result in memory
leaking.

I think the logic here is complex enough for us to introduce a
structure, like:

	struct cpu_opv_page_pinner {
		int nr_pinned;
		bool is_kmalloc;
		struct page **pinned_pages;
	};

Thoughts?

Regards,
Boqun

> +		struct page **pinned_pages =
> +			kzalloc(CPU_OP_VEC_LEN_MAX * CPU_OP_MAX_PAGES
> +				* sizeof(struct page *), GFP_KERNEL);
> +		if (!pinned_pages)
> +			return -ENOMEM;
> +		memcpy(pinned_pages, *pinned_pages_ptr,
> +			*nr_pinned * sizeof(struct page *));
> +		*pinned_pages_ptr = pinned_pages;
> +	}
> +again:
> +	ret = get_user_pages_fast(addr, nr_pages, write, pages);
> +	if (ret < nr_pages) {
> +		if (ret > 0)
> +			put_page(pages[0]);
> +		return -EFAULT;
> +	}
> +	/*
> +	 * Refuse device pages, the zero page, pages in the gate area,
> +	 * and special mappings.
> +	 */
> +	ret = cpu_op_check_pages(pages, nr_pages);
> +	if (ret == -EAGAIN) {
> +		put_page(pages[0]);
> +		if (nr_pages > 1)
> +			put_page(pages[1]);
> +		goto again;
> +	}
> +	if (ret)
> +		goto error;
> +	(*pinned_pages_ptr)[(*nr_pinned)++] = pages[0];
> +	if (nr_pages > 1)
> +		(*pinned_pages_ptr)[(*nr_pinned)++] = pages[1];
> +	return 0;
> +
> +error:
> +	put_page(pages[0]);
> +	if (nr_pages > 1)
> +		put_page(pages[1]);
> +	return -EFAULT;
> +}
> +
> +static int cpu_opv_pin_pages(struct cpu_op *cpuop, int cpuopcnt,
> +		struct page ***pinned_pages_ptr, size_t *nr_pinned)
> +{
> +	int ret, i;
> +	bool expect_fault = false;
> +
> +	/* Check access, pin pages. */
> +	for (i = 0; i < cpuopcnt; i++) {
> +		struct cpu_op *op = &cpuop[i];
> +
> +		switch (op->op) {
> +		case CPU_COMPARE_EQ_OP:
> +		case CPU_COMPARE_NE_OP:
> +			ret = -EFAULT;
> +			expect_fault = op->u.compare_op.expect_fault_a;
> +			if (!access_ok(VERIFY_READ, op->u.compare_op.a,
> +					op->len))
> +				goto error;
> +			ret = cpu_op_pin_pages(
> +					(unsigned long)op->u.compare_op.a,
> +					op->len, pinned_pages_ptr, nr_pinned, 0);
> +			if (ret)
> +				goto error;
> +			ret = -EFAULT;
> +			expect_fault = op->u.compare_op.expect_fault_b;
> +			if (!access_ok(VERIFY_READ, op->u.compare_op.b,
> +					op->len))
> +				goto error;
> +			ret = cpu_op_pin_pages(
> +					(unsigned long)op->u.compare_op.b,
> +					op->len, pinned_pages_ptr, nr_pinned, 0);
> +			if (ret)
> +				goto error;
> +			break;
> +		case CPU_MEMCPY_OP:
> +			ret = -EFAULT;
> +			expect_fault = op->u.memcpy_op.expect_fault_dst;
> +			if (!access_ok(VERIFY_WRITE, op->u.memcpy_op.dst,
> +					op->len))
> +				goto error;
> +			ret = cpu_op_pin_pages(
> +					(unsigned long)op->u.memcpy_op.dst,
> +					op->len, pinned_pages_ptr, nr_pinned, 1);
> +			if (ret)
> +				goto error;
> +			ret = -EFAULT;
> +			expect_fault = op->u.memcpy_op.expect_fault_src;
> +			if (!access_ok(VERIFY_READ, op->u.memcpy_op.src,
> +					op->len))
> +				goto error;
> +			ret = cpu_op_pin_pages(
> +					(unsigned long)op->u.memcpy_op.src,
> +					op->len, pinned_pages_ptr, nr_pinned, 0);
> +			if (ret)
> +				goto error;
> +			break;
> +		case CPU_ADD_OP:
> +			ret = -EFAULT;
> +			expect_fault = op->u.arithmetic_op.expect_fault_p;
> +			if (!access_ok(VERIFY_WRITE, op->u.arithmetic_op.p,
> +					op->len))
> +				goto error;
> +			ret = cpu_op_pin_pages(
> +					(unsigned long)op->u.arithmetic_op.p,
> +					op->len, pinned_pages_ptr, nr_pinned, 1);
> +			if (ret)
> +				goto error;
> +			break;
> +		case CPU_OR_OP:
> +		case CPU_AND_OP:
> +		case CPU_XOR_OP:
> +			ret = -EFAULT;
> +			expect_fault = op->u.bitwise_op.expect_fault_p;
> +			if (!access_ok(VERIFY_WRITE, op->u.bitwise_op.p,
> +					op->len))
> +				goto error;
> +			ret = cpu_op_pin_pages(
> +					(unsigned long)op->u.bitwise_op.p,
> +					op->len, pinned_pages_ptr, nr_pinned, 1);
> +			if (ret)
> +				goto error;
> +			break;
> +		case CPU_LSHIFT_OP:
> +		case CPU_RSHIFT_OP:
> +			ret = -EFAULT;
> +			expect_fault = op->u.shift_op.expect_fault_p;
> +			if (!access_ok(VERIFY_WRITE, op->u.shift_op.p,
> +					op->len))
> +				goto error;
> +			ret = cpu_op_pin_pages(
> +					(unsigned long)op->u.shift_op.p,
> +					op->len, pinned_pages_ptr, nr_pinned, 1);
> +			if (ret)
> +				goto error;
> +			break;
> +		case CPU_MB_OP:
> +			break;
> +		default:
> +			return -EINVAL;
> +		}
> +	}
> +	return 0;
> +
> +error:
> +	for (i = 0; i < *nr_pinned; i++)
> +		put_page((*pinned_pages_ptr)[i]);
> +	*nr_pinned = 0;
> +	/*
> +	 * If faulting access is expected, return EAGAIN to user-space.
> +	 * It allows user-space to distinguish between a fault caused by
> +	 * an access which is expect to fault (e.g. due to concurrent
> +	 * unmapping of underlying memory) from an unexpected fault from
> +	 * which a retry would not recover.
> +	 */
> +	if (ret == -EFAULT && expect_fault)
> +		return -EAGAIN;
> +	return ret;
> +}
[...]

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEj5IosQTPz8XU1wRHSXnow7UH+rgFAloBFUwACgkQSXnow7UH
+rizbQf/YrHwtP/maCz0HCu1aAAE3fdR3JRW3fFS11wwENDR8mkNt3IHcdTDotij
rc9g7866GZRUZUNpK4b6K2h0pkcIhVwCdbAk+YZGDQ2ZBM4N39C/0TtLP9e72xXB
5U5fdg44R5iasw2S4fAigSi/H7wzv1zBC2khRhUOyvnbvyRdNGe4NOjpmBASGs6q
IWA16UlxjKUInNdGCt0nn5tgC8bPOUGR40g2DVInwoYU1LNvvGEwWM0nKEmn4/0J
X7870nAYPtwQ7J4AWu5Yf2vz7mGUZC/D0fakM3MmFhdFlFYFsUih+PQ0rSQc49Wu
rDd1G+ma4wTRuSNtILmcp5bdBVvKsQ==
=o9va
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
