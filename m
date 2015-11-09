From: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] selftests/mlock2: Build warning fixes on Debian/m68k
 4.0
Date: Mon, 9 Nov 2015 10:48:36 -0500
Message-ID: <20151109154836.GA28486@akamai.com>
References: <1447064069-21469-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447064069-21469-1-git-send-email-geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Cc: Thierry Reding <treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 09 Nov 2015, Geert Uytterhoeven wrote:

> 	Hi,
>=20
> The following 2 patches are needed to fix build warnings on Debian/m68k
> 4.0.
>=20
> However, after wiring up the mlock2 syscall, the test fails with:
>=20
> # ./mlock2-tests
> fread kpageflags: Success
> #=20
>=20
> as the fread() call returns 0, not 1.

This would fail is the index into the kpageflags file is not being
calculated properly.  This tests works on x86_64 (I am in the process of
testing x86 incase this is a 32bit issue).  I am fairly sure that I
tested it on x86, but it has been a while.

>=20
> The original commit description for the test said "Note that the limit
> test needs to be run a normal user.". But running it as a non-root user
> also fails:

The original commit says that the on-fault-limit test needs to be run as
a regular user becuase it relies on enforcing memory limits.
mlock2-tests has to be run as root to get access to the various files
under /proc it needs to verify things are working.

>=20
> $ ./mlock2-tests=20
> fopen kpageflags: Permission denied
> $ ls -l /proc/kpageflags=20
> -r-------- 1 root root 0 Nov  9 11:05 /proc/kpageflags
> $
>=20
> What am I missing?
>=20
> Thanks!
>=20
> Geert Uytterhoeven (2):
>   selftests/mlock2: Add missing #define _GNU_SOURCE
>   selftests/mlock2: Add ULL prefix to 64-bit constants
>=20
>  tools/testing/selftests/vm/mlock2-tests.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> --=20
> 1.9.1
>=20
> Gr{oetje,eeting}s,
>=20
> 						Geert
>=20
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m6=
8k.org
>=20
> In personal conversations with technical people, I call myself a hacker. =
But
> when I'm talking to journalists I just say "programmer" or something like=
 that.
> 							    -- Linus Torvalds

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWQMBUAAoJELbVsDOpoOa9fiMQANfL6jeYqFIqCyAGa2gct0/j
qq/RatnE49sdp45EiGxaEvLr0k0a2QM8bkI7lvhA3hvYoRL5euA/7HU51RSqFJ8b
fg/9xeCb43g8zEMARK/B9C5oehL5ODfPWT+VnC13s1BjUQmnDkjwijJ+v9nSEM5z
jlM3WQjonwQmXPrxLLlcfHB6kfs99ebXhSQJbH/l7bQxP2ed/uqwDQ6ZPxON60e/
EP6DgrM957hYHy2DSFEbHuy5iNpsvmN3v2vTDUAWUASrZTYrQ4ZMQFmPPAqiEjc8
XR/CHHjC86y1H1Kdl90zozLnhvTQnMfWw5omo5uyhLx4accSi/5RYkzWJwpmsVAu
lvVVSFQTQr/oF+xX+VveHbjBHWHUvxWrLWAIlWkXSMThqNXId/TFYP0DQBug59Ho
sk1o8Lsnvzb9TtJ7j9wwGqdLZdhtkuO+Fq8K5StsK7vHmBXj6byn3fJ1ULQ3GpLS
CRxcSXPGLeMh2l3mxXwY6YWI/QUOubdVEtvJO6xJIZJl3q5J6BXYis1kUNvb9jcA
Vk+euwyF2JatgpiOc/4LpjAPUKvKO5fuSCl6XG/kEkAjVEc+k2vk7vtOUk8z3KcC
ObTuec2hlDCD2GJofWVM8gRCnbWvffqo8aELqU8WPwj18Ju1Xgt89+JV1EfBRBin
f2Ix04pFWivb6W9vcQ5u
=Iq/E
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
