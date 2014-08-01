From: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 2/5] raid: Require designated initialization of
 structures
Date: Fri, 1 Aug 2014 11:10:55 +1000
Message-ID: <20140801111055.59419950@notabene.brown>
References: <3130b0553b15518e3bef6d14c80280beed0f5ff9.1406850006.git.josh@joshtriplett.org>
	<1d468224409ef2bf46874f817d19389ac5d1b26d.1406850006.git.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/M7cuTxQ/DXhWJ+vQv/kDnyh"; protocol="application/pgp-signature"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1d468224409ef2bf46874f817d19389ac5d1b26d.1406850006.git.josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christopher Li <sparse-55XgFHCVCFZAfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kbuild-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sparse-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

--Sig_/M7cuTxQ/DXhWJ+vQv/kDnyh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 31 Jul 2014 16:47:35 -0700 Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
wrote:

> Mark raid6_calls and other structures containing function pointers with
> __designated_init.  Fix implementations in lib/raid6/ to use designated
> initializers; this also simplifies those initializers using the default
> initialization of fields to 0.
>=20
> Signed-off-by: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>

Looks like an excellent idea!
Feel free to forward this upstream on my behalf, or remind me once the first
patch is in -next, and I'll take this one myself - whichever you prefer.

 Acked-by: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>

Thanks,
NeilBrown

> ---
>  include/linux/raid/pq.h    |  4 ++--
>  include/linux/raid/xor.h   |  2 +-
>  include/linux/raid_class.h |  2 +-
>  lib/raid6/altivec.uc       |  7 +++----
>  lib/raid6/avx2.c           | 24 ++++++++++++------------
>  lib/raid6/int.uc           |  6 ++----
>  lib/raid6/mmx.c            | 14 ++++++--------
>  lib/raid6/neon.c           |  7 +++----
>  lib/raid6/sse1.c           | 16 ++++++++--------
>  lib/raid6/sse2.c           | 24 ++++++++++++------------
>  lib/raid6/tilegx.uc        |  6 ++----
>  11 files changed, 52 insertions(+), 60 deletions(-)
>=20
> diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
> index 73069cb..2147bff 100644
> --- a/include/linux/raid/pq.h
> +++ b/include/linux/raid/pq.h
> @@ -75,7 +75,7 @@ struct raid6_calls {
>  	int  (*valid)(void);	/* Returns 1 if this routine set is usable */
>  	const char *name;	/* Name of this routine set */
>  	int prefer;		/* Has special performance attribute */
> -};
> +} __designated_init;
> =20
>  /* Selected algorithm */
>  extern struct raid6_calls raid6_call;
> @@ -109,7 +109,7 @@ struct raid6_recov_calls {
>  	int  (*valid)(void);
>  	const char *name;
>  	int priority;
> -};
> +} __designated_init;
> =20
>  extern const struct raid6_recov_calls raid6_recov_intx1;
>  extern const struct raid6_recov_calls raid6_recov_ssse3;
> diff --git a/include/linux/raid/xor.h b/include/linux/raid/xor.h
> index 5a21095..c7df59f 100644
> --- a/include/linux/raid/xor.h
> +++ b/include/linux/raid/xor.h
> @@ -17,6 +17,6 @@ struct xor_block_template {
>  		     unsigned long *, unsigned long *);
>  	void (*do_5)(unsigned long, unsigned long *, unsigned long *,
>  		     unsigned long *, unsigned long *, unsigned long *);
> -};
> +} __designated_init;
> =20
>  #endif
> diff --git a/include/linux/raid_class.h b/include/linux/raid_class.h
> index 31e1ff6..603af94 100644
> --- a/include/linux/raid_class.h
> +++ b/include/linux/raid_class.h
> @@ -16,7 +16,7 @@ struct raid_function_template {
>  	int (*is_raid)(struct device *);
>  	void (*get_resync)(struct device *);
>  	void (*get_state)(struct device *);
> -};
> +} __designated_init;
> =20
>  enum raid_state {
>  	RAID_STATE_UNKNOWN =3D 0,
> diff --git a/lib/raid6/altivec.uc b/lib/raid6/altivec.uc
> index 7cc12b5..4ff138c 100644
> --- a/lib/raid6/altivec.uc
> +++ b/lib/raid6/altivec.uc
> @@ -118,10 +118,9 @@ int raid6_have_altivec(void)
>  #endif
> =20
>  const struct raid6_calls raid6_altivec$# =3D {
> -	raid6_altivec$#_gen_syndrome,
> -	raid6_have_altivec,
> -	"altivecx$#",
> -	0
> +	.gen_syndrome =3D raid6_altivec$#_gen_syndrome,
> +	.valid =3D raid6_have_altivec,
> +	.name =3D "altivecx$#",
>  };
> =20
>  #endif /* CONFIG_ALTIVEC */
> diff --git a/lib/raid6/avx2.c b/lib/raid6/avx2.c
> index bc3b1dd..e56fa06 100644
> --- a/lib/raid6/avx2.c
> +++ b/lib/raid6/avx2.c
> @@ -88,10 +88,10 @@ static void raid6_avx21_gen_syndrome(int disks, size_=
t bytes, void **ptrs)
>  }
> =20
>  const struct raid6_calls raid6_avx2x1 =3D {
> -	raid6_avx21_gen_syndrome,
> -	raid6_have_avx2,
> -	"avx2x1",
> -	1			/* Has cache hints */
> +	.gen_syndrome =3D raid6_avx21_gen_syndrome,
> +	.valid =3D raid6_have_avx2,
> +	.name =3D "avx2x1",
> +	.prefer =3D 1,		/* Has cache hints */
>  };
> =20
>  /*
> @@ -149,10 +149,10 @@ static void raid6_avx22_gen_syndrome(int disks, siz=
e_t bytes, void **ptrs)
>  }
> =20
>  const struct raid6_calls raid6_avx2x2 =3D {
> -	raid6_avx22_gen_syndrome,
> -	raid6_have_avx2,
> -	"avx2x2",
> -	1			/* Has cache hints */
> +	.gen_syndrome =3D raid6_avx22_gen_syndrome,
> +	.valid =3D raid6_have_avx2,
> +	.name =3D "avx2x2",
> +	.prefer =3D 1,		/* Has cache hints */
>  };
> =20
>  #ifdef CONFIG_X86_64
> @@ -241,10 +241,10 @@ static void raid6_avx24_gen_syndrome(int disks, siz=
e_t bytes, void **ptrs)
>  }
> =20
>  const struct raid6_calls raid6_avx2x4 =3D {
> -	raid6_avx24_gen_syndrome,
> -	raid6_have_avx2,
> -	"avx2x4",
> -	1			/* Has cache hints */
> +	.gen_syndrome =3D raid6_avx24_gen_syndrome,
> +	.valid =3D raid6_have_avx2,
> +	.name =3D "avx2x4",
> +	.prefer =3D 1,		/* Has cache hints */
>  };
>  #endif
> =20
> diff --git a/lib/raid6/int.uc b/lib/raid6/int.uc
> index 5b50f8d..35ad01a 100644
> --- a/lib/raid6/int.uc
> +++ b/lib/raid6/int.uc
> @@ -108,10 +108,8 @@ static void raid6_int$#_gen_syndrome(int disks, size=
_t bytes, void **ptrs)
>  }
> =20
>  const struct raid6_calls raid6_intx$# =3D {
> -	raid6_int$#_gen_syndrome,
> -	NULL,		/* always valid */
> -	"int" NSTRING "x$#",
> -	0
> +	.gen_syndrome =3D raid6_int$#_gen_syndrome,
> +	.name =3D "int" NSTRING "x$#",
>  };
> =20
>  #endif
> diff --git a/lib/raid6/mmx.c b/lib/raid6/mmx.c
> index 590c71c..cdd7d02 100644
> --- a/lib/raid6/mmx.c
> +++ b/lib/raid6/mmx.c
> @@ -75,10 +75,9 @@ static void raid6_mmx1_gen_syndrome(int disks, size_t =
bytes, void **ptrs)
>  }
> =20
>  const struct raid6_calls raid6_mmxx1 =3D {
> -	raid6_mmx1_gen_syndrome,
> -	raid6_have_mmx,
> -	"mmxx1",
> -	0
> +	.gen_syndrome =3D raid6_mmx1_gen_syndrome,
> +	.valid =3D raid6_have_mmx,
> +	.name =3D "mmxx1",
>  };
> =20
>  /*
> @@ -133,10 +132,9 @@ static void raid6_mmx2_gen_syndrome(int disks, size_=
t bytes, void **ptrs)
>  }
> =20
>  const struct raid6_calls raid6_mmxx2 =3D {
> -	raid6_mmx2_gen_syndrome,
> -	raid6_have_mmx,
> -	"mmxx2",
> -	0
> +	.gen_syndrome =3D raid6_mmx2_gen_syndrome,
> +	.valid =3D raid6_have_mmx,
> +	.name =3D "mmxx2",
>  };
> =20
>  #endif
> diff --git a/lib/raid6/neon.c b/lib/raid6/neon.c
> index 36ad470..99100dd 100644
> --- a/lib/raid6/neon.c
> +++ b/lib/raid6/neon.c
> @@ -41,10 +41,9 @@
>  		kernel_neon_end();					\
>  	}								\
>  	struct raid6_calls const raid6_neonx ## _n =3D {			\
> -		raid6_neon ## _n ## _gen_syndrome,			\
> -		raid6_have_neon,					\
> -		"neonx" #_n,						\
> -		0							\
> +		.gen_syndrome =3D raid6_neon ## _n ## _gen_syndrome,	\
> +		.valid =3D raid6_have_neon,				\
> +		.name =3D "neonx" #_n,					\
>  	}
> =20
>  static int raid6_have_neon(void)
> diff --git a/lib/raid6/sse1.c b/lib/raid6/sse1.c
> index f762971..a9de46e 100644
> --- a/lib/raid6/sse1.c
> +++ b/lib/raid6/sse1.c
> @@ -91,10 +91,10 @@ static void raid6_sse11_gen_syndrome(int disks, size_=
t bytes, void **ptrs)
>  }
> =20
>  const struct raid6_calls raid6_sse1x1 =3D {
> -	raid6_sse11_gen_syndrome,
> -	raid6_have_sse1_or_mmxext,
> -	"sse1x1",
> -	1			/* Has cache hints */
> +	.gen_syndrome =3D raid6_sse11_gen_syndrome,
> +	.valid =3D raid6_have_sse1_or_mmxext,
> +	.name =3D "sse1x1",
> +	.prefer =3D 1,		/* Has cache hints */
>  };
> =20
>  /*
> @@ -153,10 +153,10 @@ static void raid6_sse12_gen_syndrome(int disks, siz=
e_t bytes, void **ptrs)
>  }
> =20
>  const struct raid6_calls raid6_sse1x2 =3D {
> -	raid6_sse12_gen_syndrome,
> -	raid6_have_sse1_or_mmxext,
> -	"sse1x2",
> -	1			/* Has cache hints */
> +	.gen_syndrome =3D raid6_sse12_gen_syndrome,
> +	.valid =3D raid6_have_sse1_or_mmxext,
> +	.name =3D "sse1x2",
> +	.prefer =3D 1,		/* Has cache hints */
>  };
> =20
>  #endif
> diff --git a/lib/raid6/sse2.c b/lib/raid6/sse2.c
> index 85b82c8..cd262518aa 100644
> --- a/lib/raid6/sse2.c
> +++ b/lib/raid6/sse2.c
> @@ -89,10 +89,10 @@ static void raid6_sse21_gen_syndrome(int disks, size_=
t bytes, void **ptrs)
>  }
> =20
>  const struct raid6_calls raid6_sse2x1 =3D {
> -	raid6_sse21_gen_syndrome,
> -	raid6_have_sse2,
> -	"sse2x1",
> -	1			/* Has cache hints */
> +	.gen_syndrome =3D raid6_sse21_gen_syndrome,
> +	.valid =3D raid6_have_sse2,
> +	.name =3D "sse2x1",
> +	.prefer =3D 1,		/* Has cache hints */
>  };
> =20
>  /*
> @@ -151,10 +151,10 @@ static void raid6_sse22_gen_syndrome(int disks, siz=
e_t bytes, void **ptrs)
>  }
> =20
>  const struct raid6_calls raid6_sse2x2 =3D {
> -	raid6_sse22_gen_syndrome,
> -	raid6_have_sse2,
> -	"sse2x2",
> -	1			/* Has cache hints */
> +	.gen_syndrome =3D raid6_sse22_gen_syndrome,
> +	.valid =3D raid6_have_sse2,
> +	.name =3D "sse2x2",
> +	.prefer =3D 1,		/* Has cache hints */
>  };
> =20
>  #ifdef CONFIG_X86_64
> @@ -249,10 +249,10 @@ static void raid6_sse24_gen_syndrome(int disks, siz=
e_t bytes, void **ptrs)
>  }
> =20
>  const struct raid6_calls raid6_sse2x4 =3D {
> -	raid6_sse24_gen_syndrome,
> -	raid6_have_sse2,
> -	"sse2x4",
> -	1			/* Has cache hints */
> +	.gen_syndrome =3D raid6_sse24_gen_syndrome,
> +	.valid =3D raid6_have_sse2,
> +	.name =3D "sse2x4",
> +	.prefer =3D 1,		/* Has cache hints */
>  };
> =20
>  #endif /* CONFIG_X86_64 */
> diff --git a/lib/raid6/tilegx.uc b/lib/raid6/tilegx.uc
> index e7c2945..3077722 100644
> --- a/lib/raid6/tilegx.uc
> +++ b/lib/raid6/tilegx.uc
> @@ -79,8 +79,6 @@ void raid6_tilegx$#_gen_syndrome(int disks, size_t byte=
s, void **ptrs)
>  }
> =20
>  const struct raid6_calls raid6_tilegx$# =3D {
> -	raid6_tilegx$#_gen_syndrome,
> -	NULL,
> -	"tilegx$#",
> -	0
> +	.gen_syndrome =3D raid6_tilegx$#_gen_syndrome,
> +	.name =3D "tilegx$#",
>  };


--Sig_/M7cuTxQ/DXhWJ+vQv/kDnyh
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU9rpHznsnt1WYoG5AQKbPA/+OcPpQdH7YF9IW003H72axTgVavamvgQT
SvQCGc3EBeBlErW+49TBvvRadNe81X4Qz4SKhFZxcC5S2QJU/bETohcm/72Zm5HX
H79y1yWD2CIxYPOlPGCas0lLMY16w75vTQ/e7pTgk/ItNd5oRWaxvMNGoKhVk+e6
cmhtAO44uN1+J6pf5dsSnAi9tBXcE1PqvyOwodkguoY52SrY8hRPeICokrkPfInt
/2hB43PmTfKfYsGl6RwxIMGmQ31V8AzyZ6nkVzMzszw9DzKls+xDCYfteSp6KgtZ
5G04FeF7h/LKXo9llPgu/VwPcmR+5Si55N+KoQehyi+XuV4yTQYzE0LfhPf18PZg
5iBssYeGketzAWg54/aB9ZIpjfPmUA8diWjrIw0azUOoarutoKw9QUkA3pkJJndb
X4t+nwDZQy3xOcx/vPL7gWeHylapugyOSjZBHD9SE/Xa9ZsvRcI2RemFzoqdPsyK
6+GY+MP6zyEnXp85Y2Ry1paJkdy/cAf8XVPrcBi1GNziDeZHJxt6qYtQ5oMjkzZd
/Fb6Kx7xN+qoyMkcZijtsJgZWgQk/EzsoeoR+aD5Zqz29HIprQUfWmGBcZ1/aIpw
PJeWm8VI9l4DYXun/5j0oB7BZB8DQbM9KGFDZfpndWdeCrrAZe5Uu4K4uX/otG5N
N5qXmEZVyO0=
=XH/S
-----END PGP SIGNATURE-----

--Sig_/M7cuTxQ/DXhWJ+vQv/kDnyh--
