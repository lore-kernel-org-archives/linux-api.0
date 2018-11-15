From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: extending wait4(2) or waitid(2) linux syscall
Date: Thu, 15 Nov 2018 18:30:11 +0300
Message-ID: <20181115153008.GC2171@altlinux.org>
References: <20170420152051.568f2050.albert.aribaud@3adev.fr>
 <20181115140441.GA2171@altlinux.org>
 <CAK8P3a0Gsqa8WTbALOUchRyEA7E2f3P1f=XQ8nD2xQaemfPpcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="p2kqVDKq5asng8Dg"
Return-path: <libc-alpha-return-97261-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <CAK8P3a0Gsqa8WTbALOUchRyEA7E2f3P1f=XQ8nD2xQaemfPpcQ@mail.gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Albert ARIBAUD <albert.aribaud@3adev.fr>, "H. Peter Anvin" <hpa@zytor.com>, GNU C Library <libc-alpha@sourceware.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--p2kqVDKq5asng8Dg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 15, 2018 at 06:39:03AM -0800, Arnd Bergmann wrote:
> On Thu, Nov 15, 2018 at 6:05 AM Dmitry V. Levin wrote:
> > On Thu, Apr 20, 2017 at 03:20:51PM +0200, Albert ARIBAUD wrote:
[...]
> > > https://sourceware.org/glibc/wiki/Y2038ProofnessDesign?rev=3D146
> > Is there any rationale for marking wait4 as an obsolete API?
>=20
> In the *kernel* syscall API, wait4(2) is obsoleted by waitid(2), which is
> a strict superset of its functionality.
>=20
> In the libc API, this is different, as wait4() does not have a replacement
> that is exposed to user space directly. I expect glibc to implement
> wait4() on top of the kernel's waitid().
>=20
> There has not been a final decision on which variant of waitid() that wou=
ld
> be. The easiest option would be to not change it at all: new architectures
> (rv32, csky, nanomips/p32, ...) would keep exposing the traditional
> waitid() in Linux, with its 32-bit time_t based rusage structure, but dro=
p the
> wait4(). glibc then has to convert between the kernel's rusage and the
> user space rusage indefinitely.
>=20
> Alternatively, we can create a new version like waitid2() that uses
> 64-bit time_t in some form, either the exact same rusage that we
> use on 64-bit architectures and x32, or using a new set of arguments
> to include further improvements.

In strace, we have two use cases that require an extended version
of wait4(2) or waitid(2) syscall.  From your response I understand that
you'd recommend extending waitid(2) rather than wait4(2), is it correct?

These two use cases were mentioned in my talk yesterday at LPC 2018,
here is a brief summary.

1. strace needs a race-free invocation of wait4(2) or waitid(2)
with a different signal mask, this cannot be achieved without
an extended version of syscall, similar to pselect6(2) extension
over select(2) and ppoll(2) extension over poll(2).

Signal mask specification in linux requires two parameters:
"const sigset_t *sigmask" and "size_t sigsetsize".
Creating pwait6(2) as an extension of wait4(2) with two arguments
is straightforward.
Creating pwaitid(2) as an extension of waitid(2) that already has 5
arguments would require an indirection similar to pselect6(2).

2. The time precision provided by struct rusage returned by wait4(2) and
waitid(2) is too low for syscall time counting (strace -c) nowadays, this
can be observing by running in a row a simple command like "strace -c pwd".

The fix is to return a more appropriate structure than struct rusage
by the new pwait6(2)/pwaitid(2) syscall mentioned above, where
struct timeval is replaced with struct timespec or even struct timespec64.


--=20
ldv

--p2kqVDKq5asng8Dg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJb7ZEAAAoJEAVFT+BVnCUI93QQAKlgAkDizxINBLCWmelyRnKU
ZmLiSB9Z2+KQuDCRd43IxbUH1754+7kyf5hKTazbTZvbv0NnEPt8ZXIyPGBzs2MI
dNQd/UjSs+jhw1ItQErB4XNMnUWs9N7L5iDFlRQElV2sVqzGQpmhF2aiYqaqC5DY
4+E2AExU+rFC09j90vcXbFAZzaqBF6iqMvnmF6uogLpB6mHWJMgU7z1PynlNp8jL
2pOJksO9QjgXweg3p3dspCKnEiEovY2q0AddWLiGgznpzpDF6UkJzuHwf4om4gHC
2SIv8EhcGGphHR0GDs8/b/z3k3UHnu58wl0o72bZGJZvpo8smT5KL3ZLLgUZxzyQ
XBH81glExyc4SEzClpgmpEDaSGPgt6Km4GJsw9l5ATq9Y7I0f/cOH7RG7qFiIDLv
UYhCIMTEwPG2GeLcfXu+0Bb4JKC4AiV9VJr57xNMiD9gLGMtbs3UJ35jDPNgOH6k
6RyjMFm+7brEp4D2pUIbkypwbH6IhZKvCK3JBSkTRSgRZYaLgis7qdOlajztlcji
Df4f/9jY1MohYMxswurtfrsLgA0RZ82IPkOgK3NmGt2G23WspE6OkCClTW89T5Tk
PdSV254eu/80hVZB1w4/HWDbv43YYr+FJDLY5jfjWTHAADkG2q/wyI63L+kDVBaF
kB0UACHwjuAEobCdQL5m
=E+zd
-----END PGP SIGNATURE-----

--p2kqVDKq5asng8Dg--
