From: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] selftests/mlock2: Build warning fixes on Debian/m68k
 4.0
Date: Mon, 9 Nov 2015 11:16:58 -0500
Message-ID: <20151109161658.GD28486@akamai.com>
References: <1447064069-21469-1-git-send-email-geert@linux-m68k.org>
 <20151109154836.GA28486@akamai.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J5MfuwkIyy7RmF4Q"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151109154836.GA28486-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Cc: Thierry Reding <treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--J5MfuwkIyy7RmF4Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 09 Nov 2015, Eric B Munson wrote:

> On Mon, 09 Nov 2015, Geert Uytterhoeven wrote:
>=20
> > 	Hi,
> >=20
> > The following 2 patches are needed to fix build warnings on Debian/m68k
> > 4.0.
> >=20
> > However, after wiring up the mlock2 syscall, the test fails with:
> >=20
> > # ./mlock2-tests
> > fread kpageflags: Success
> > #=20
> >=20
> > as the fread() call returns 0, not 1.
>=20
> This would fail is the index into the kpageflags file is not being
> calculated properly.  This tests works on x86_64 (I am in the process of
> testing x86 incase this is a 32bit issue).  I am fairly sure that I
> tested it on x86, but it has been a while.

I can confirm that this test works on x86 as well as x86_64.
Unfortunately, I do not have access to m68k hardware to help debug this.

>=20
> >=20
> > The original commit description for the test said "Note that the limit
> > test needs to be run a normal user.". But running it as a non-root user
> > also fails:
>=20
> The original commit says that the on-fault-limit test needs to be run as
> a regular user becuase it relies on enforcing memory limits.
> mlock2-tests has to be run as root to get access to the various files
> under /proc it needs to verify things are working.
>=20
> >=20
> > $ ./mlock2-tests=20
> > fopen kpageflags: Permission denied
> > $ ls -l /proc/kpageflags=20
> > -r-------- 1 root root 0 Nov  9 11:05 /proc/kpageflags
> > $
> >=20
> > What am I missing?
> >=20
> > Thanks!
> >=20
> > Geert Uytterhoeven (2):
> >   selftests/mlock2: Add missing #define _GNU_SOURCE
> >   selftests/mlock2: Add ULL prefix to 64-bit constants
> >=20
> >  tools/testing/selftests/vm/mlock2-tests.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >=20
> > --=20
> > 1.9.1
> >=20
> > Gr{oetje,eeting}s,
> >=20
> > 						Geert
> >=20
> > --
> > Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-=
m68k.org
> >=20
> > In personal conversations with technical people, I call myself a hacker=
=2E But
> > when I'm talking to journalists I just say "programmer" or something li=
ke that.
> > 							    -- Linus Torvalds



--J5MfuwkIyy7RmF4Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWQMb6AAoJELbVsDOpoOa9tZ0QAKdrSWYQflNqMIZjQZIoQdoZ
yrKXUZNfcAt3CXr2QCK0kRDz3O7YfwgNpG+u4EQ+Uj8QIKgkXVOYbqOXB5+i+o0R
DmdX1WAXUpgEM9i6NlXOAzmQWjBv80siUbvX0puVaXPHzuT0HREHm/HwUzfCrole
Ne48oJbRG0+CoKVMJzV87XRun3HPa+CSpppfa0ljxlX+2HNHQUrhNK57284lmAQ/
CIPBS946Ckxm39YtXKq44I4LJGzCD/kR4DKGRL1sa1GbNib+7prSvpBj2wEbtZNs
TKfZIPVmza9wjK8saxixhQDIcSsgQ2iG0Nsb6bS/gSDqvVEK7TZmM8A4GFqK3EYj
bx2e7uU+mClLGrj5on/Dr6xle4UT/FTC1lOVDQaxRSf5flvBiEjjwkftTwVJX+IK
a/yNWNbMxkd3r8JUa7fLDgOnFVjO4cg42Z6073z66zVnzu/y1ussbbibhNl8Ux/7
3iD937SZUM2oNJA2oz1Rbx82CGswytdX9FQxBDxnI9KUDqbFejtp3UXD2SVH6xej
TrahLpHCx10+62J05BfPlScFHBHXb0mu5dVNpCe2uDDjg8gmVMaQtcT3nUTMePE2
izXHX7YcgVIFdXqY0iWPMaXeSHscZRGqLi5ATfQwyhYPDPT3oj3Wgq+YOSoMn8et
JORNPZoLfRLrvMm1Tnrk
=52S5
-----END PGP SIGNATURE-----

--J5MfuwkIyy7RmF4Q--
