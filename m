From: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v2 for 4.15 08/14] Provide cpu_opv system call
Date: Tue, 7 Nov 2017 11:03:55 +0800
Message-ID: <20171107030355.GB6095@tardis>
References: <20171106205644.29386-1-mathieu.desnoyers@efficios.com>
 <20171106205644.29386-9-mathieu.desnoyers@efficios.com>
 <20171107020711.GA6095@tardis>
 <444885121.6172.1510022437259.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LyciRD1jyfeSSjG0"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <444885121.6172.1510022437259.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--LyciRD1jyfeSSjG0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 07, 2017 at 02:40:37AM +0000, Mathieu Desnoyers wrote:
> ----- On Nov 6, 2017, at 9:07 PM, Boqun Feng boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>=20
> > On Mon, Nov 06, 2017 at 03:56:38PM -0500, Mathieu Desnoyers wrote:
> > [...]
> >> +static int cpu_op_pin_pages(unsigned long addr, unsigned long len,
> >> +		struct page ***pinned_pages_ptr, size_t *nr_pinned,
> >> +		int write)
> >> +{
> >> +	struct page *pages[2];
> >> +	int ret, nr_pages;
> >> +
> >> +	if (!len)
> >> +		return 0;
> >> +	nr_pages =3D cpu_op_range_nr_pages(addr, len);
> >> +	BUG_ON(nr_pages > 2);
> >> +	if (*nr_pinned + nr_pages > NR_PINNED_PAGES_ON_STACK) {
> >=20
> > Is this a bug? Seems you will kzalloc() every time if *nr_pinned is
> > bigger than NR_PINNED_PAGES_ON_STACK, which will result in memory
> > leaking.
> >=20
> > I think the logic here is complex enough for us to introduce a
> > structure, like:
> >=20
> >	struct cpu_opv_page_pinner {
> >		int nr_pinned;
> >		bool is_kmalloc;
> >		struct page **pinned_pages;
> >	};
> >=20
> > Thoughts?
>=20
> Good catch !
>=20
> How about the attached diff ? I'll fold it into the rseq/dev tree.
>=20

Looks good to me ;-)

Regards,
Boqun

> Thanks,
>=20
> Mathieu
>=20
> --=20
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com

> diff --git a/kernel/cpu_opv.c b/kernel/cpu_opv.c
> index 09754bbe6a4f..3d8fd66416a0 100644
> --- a/kernel/cpu_opv.c
> +++ b/kernel/cpu_opv.c
> @@ -46,6 +46,12 @@ union op_fn_data {
>  #endif
>  };
> =20
> +struct cpu_opv_pinned_pages {
> +	struct page **pages;
> +	size_t nr;
> +	bool is_kmalloc;
> +};
> +
>  typedef int (*op_fn_t)(union op_fn_data *data, uint64_t v, uint32_t len);
> =20
>  static DEFINE_MUTEX(cpu_opv_offline_lock);
> @@ -217,8 +223,7 @@ static int cpu_op_check_pages(struct page **pages,
>  }
> =20
>  static int cpu_op_pin_pages(unsigned long addr, unsigned long len,
> -		struct page ***pinned_pages_ptr, size_t *nr_pinned,
> -		int write)
> +		struct cpu_opv_pinned_pages *pin_pages, int write)
>  {
>  	struct page *pages[2];
>  	int ret, nr_pages;
> @@ -227,15 +232,17 @@ static int cpu_op_pin_pages(unsigned long addr, uns=
igned long len,
>  		return 0;
>  	nr_pages =3D cpu_op_range_nr_pages(addr, len);
>  	BUG_ON(nr_pages > 2);
> -	if (*nr_pinned + nr_pages > NR_PINNED_PAGES_ON_STACK) {
> +	if (!pin_pages->is_kmalloc && pin_pages->nr + nr_pages
> +			> NR_PINNED_PAGES_ON_STACK) {
>  		struct page **pinned_pages =3D
>  			kzalloc(CPU_OP_VEC_LEN_MAX * CPU_OP_MAX_PAGES
>  				* sizeof(struct page *), GFP_KERNEL);
>  		if (!pinned_pages)
>  			return -ENOMEM;
> -		memcpy(pinned_pages, *pinned_pages_ptr,
> -			*nr_pinned * sizeof(struct page *));
> -		*pinned_pages_ptr =3D pinned_pages;
> +		memcpy(pinned_pages, pin_pages->pages,
> +			pin_pages->nr * sizeof(struct page *));
> +		pin_pages->pages =3D pinned_pages;
> +		pin_pages->is_kmalloc =3D true;
>  	}
>  again:
>  	ret =3D get_user_pages_fast(addr, nr_pages, write, pages);
> @@ -257,9 +264,9 @@ static int cpu_op_pin_pages(unsigned long addr, unsig=
ned long len,
>  	}
>  	if (ret)
>  		goto error;
> -	(*pinned_pages_ptr)[(*nr_pinned)++] =3D pages[0];
> +	pin_pages->pages[pin_pages->nr++] =3D pages[0];
>  	if (nr_pages > 1)
> -		(*pinned_pages_ptr)[(*nr_pinned)++] =3D pages[1];
> +		pin_pages->pages[pin_pages->nr++] =3D pages[1];
>  	return 0;
> =20
>  error:
> @@ -270,7 +277,7 @@ static int cpu_op_pin_pages(unsigned long addr, unsig=
ned long len,
>  }
> =20
>  static int cpu_opv_pin_pages(struct cpu_op *cpuop, int cpuopcnt,
> -		struct page ***pinned_pages_ptr, size_t *nr_pinned)
> +		struct cpu_opv_pinned_pages *pin_pages)
>  {
>  	int ret, i;
>  	bool expect_fault =3D false;
> @@ -289,7 +296,7 @@ static int cpu_opv_pin_pages(struct cpu_op *cpuop, in=
t cpuopcnt,
>  				goto error;
>  			ret =3D cpu_op_pin_pages(
>  					(unsigned long)op->u.compare_op.a,
> -					op->len, pinned_pages_ptr, nr_pinned, 0);
> +					op->len, pin_pages, 0);
>  			if (ret)
>  				goto error;
>  			ret =3D -EFAULT;
> @@ -299,7 +306,7 @@ static int cpu_opv_pin_pages(struct cpu_op *cpuop, in=
t cpuopcnt,
>  				goto error;
>  			ret =3D cpu_op_pin_pages(
>  					(unsigned long)op->u.compare_op.b,
> -					op->len, pinned_pages_ptr, nr_pinned, 0);
> +					op->len, pin_pages, 0);
>  			if (ret)
>  				goto error;
>  			break;
> @@ -311,7 +318,7 @@ static int cpu_opv_pin_pages(struct cpu_op *cpuop, in=
t cpuopcnt,
>  				goto error;
>  			ret =3D cpu_op_pin_pages(
>  					(unsigned long)op->u.memcpy_op.dst,
> -					op->len, pinned_pages_ptr, nr_pinned, 1);
> +					op->len, pin_pages, 1);
>  			if (ret)
>  				goto error;
>  			ret =3D -EFAULT;
> @@ -321,7 +328,7 @@ static int cpu_opv_pin_pages(struct cpu_op *cpuop, in=
t cpuopcnt,
>  				goto error;
>  			ret =3D cpu_op_pin_pages(
>  					(unsigned long)op->u.memcpy_op.src,
> -					op->len, pinned_pages_ptr, nr_pinned, 0);
> +					op->len, pin_pages, 0);
>  			if (ret)
>  				goto error;
>  			break;
> @@ -333,7 +340,7 @@ static int cpu_opv_pin_pages(struct cpu_op *cpuop, in=
t cpuopcnt,
>  				goto error;
>  			ret =3D cpu_op_pin_pages(
>  					(unsigned long)op->u.arithmetic_op.p,
> -					op->len, pinned_pages_ptr, nr_pinned, 1);
> +					op->len, pin_pages, 1);
>  			if (ret)
>  				goto error;
>  			break;
> @@ -347,7 +354,7 @@ static int cpu_opv_pin_pages(struct cpu_op *cpuop, in=
t cpuopcnt,
>  				goto error;
>  			ret =3D cpu_op_pin_pages(
>  					(unsigned long)op->u.bitwise_op.p,
> -					op->len, pinned_pages_ptr, nr_pinned, 1);
> +					op->len, pin_pages, 1);
>  			if (ret)
>  				goto error;
>  			break;
> @@ -360,7 +367,7 @@ static int cpu_opv_pin_pages(struct cpu_op *cpuop, in=
t cpuopcnt,
>  				goto error;
>  			ret =3D cpu_op_pin_pages(
>  					(unsigned long)op->u.shift_op.p,
> -					op->len, pinned_pages_ptr, nr_pinned, 1);
> +					op->len, pin_pages, 1);
>  			if (ret)
>  				goto error;
>  			break;
> @@ -373,9 +380,9 @@ static int cpu_opv_pin_pages(struct cpu_op *cpuop, in=
t cpuopcnt,
>  	return 0;
> =20
>  error:
> -	for (i =3D 0; i < *nr_pinned; i++)
> -		put_page((*pinned_pages_ptr)[i]);
> -	*nr_pinned =3D 0;
> +	for (i =3D 0; i < pin_pages->nr; i++)
> +		put_page(pin_pages->pages[i]);
> +	pin_pages->nr =3D 0;
>  	/*
>  	 * If faulting access is expected, return EAGAIN to user-space.
>  	 * It allows user-space to distinguish between a fault caused by
> @@ -923,9 +930,12 @@ SYSCALL_DEFINE4(cpu_opv, struct cpu_op __user *, ucp=
uopv, int, cpuopcnt,
>  {
>  	struct cpu_op cpuopv[CPU_OP_VEC_LEN_MAX];
>  	struct page *pinned_pages_on_stack[NR_PINNED_PAGES_ON_STACK];
> -	struct page **pinned_pages =3D pinned_pages_on_stack;
> +	struct cpu_opv_pinned_pages pin_pages =3D {
> +		.pages =3D pinned_pages_on_stack,
> +		.nr =3D 0,
> +		.is_kmalloc =3D false,
> +	};
>  	int ret, i;
> -	size_t nr_pinned =3D 0;
> =20
>  	if (unlikely(flags))
>  		return -EINVAL;
> @@ -938,15 +948,14 @@ SYSCALL_DEFINE4(cpu_opv, struct cpu_op __user *, uc=
puopv, int, cpuopcnt,
>  	ret =3D cpu_opv_check(cpuopv, cpuopcnt);
>  	if (ret)
>  		return ret;
> -	ret =3D cpu_opv_pin_pages(cpuopv, cpuopcnt,
> -				&pinned_pages, &nr_pinned);
> +	ret =3D cpu_opv_pin_pages(cpuopv, cpuopcnt, &pin_pages);
>  	if (ret)
>  		goto end;
>  	ret =3D do_cpu_opv(cpuopv, cpuopcnt, cpu);
> -	for (i =3D 0; i < nr_pinned; i++)
> -		put_page(pinned_pages[i]);
> +	for (i =3D 0; i < pin_pages.nr; i++)
> +		put_page(pin_pages.pages[i]);
>  end:
> -	if (pinned_pages !=3D pinned_pages_on_stack)
> -		kfree(pinned_pages);
> +	if (pin_pages.is_kmalloc)
> +		kfree(pin_pages.pages);
>  	return ret;
>  }


--LyciRD1jyfeSSjG0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEj5IosQTPz8XU1wRHSXnow7UH+rgFAloBIpgACgkQSXnow7UH
+rg7Twf8D1o5/HIRgtW0OoxohYe9KaU3Ipo284ufuik6YnfT9EXyvtpxb85zm1mP
BOV+BXUWEKH0kQaxCWj0EeMGOa2GrNTv6oexWrNRzTHvVqchYQh8QliNHMqA6Z8A
JQK4XwY61nVa5dfdeXMlysK9yD5x7dc5NcM7WVqOktsK0zvyAhUe9g3ikV8rGWb5
mIsQk/cNjWQ/TAgxz2BnvpgEIUF4OKGAHSfttHq7KkIRaa++YA7BHKYg/GGnaVVF
sCgxYuE1wPQxGlNxRY0DmyQZsBNPkIDgGXeFyn7bNGVR8O6v0DAOOk81K+TJFtQY
qFYbVgbpChYx7LRMEtWsL3DZnpizVQ==
=6Hp+
-----END PGP SIGNATURE-----

--LyciRD1jyfeSSjG0--
