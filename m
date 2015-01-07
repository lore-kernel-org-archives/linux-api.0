From: Andrey Skvortsov <andrej.skvortzov@gmail.com>
Subject: Re: [PATCH] selftests/vm: fix link error for transhuge-stress test
Date: Wed, 7 Jan 2015 23:10:45 +0300
Message-ID: <20150107201045.GA5704@yulia-desktop>
References: <1420655754-10076-1-git-send-email-Andrej.Skvortzov@gmail.com>
 <54AD872E.9060802@osg.samsung.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54AD872E.9060802@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Konstantin Khlebnikov <koct9i@gmail.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 07, 2015 at 12:21:18PM -0700, Shuah Khan wrote:
> On 01/07/2015 11:35 AM, Andrey Skvortsov wrote:
> > add -lrt to fix undefined reference to `clock_gettime'
> >=20
> > Signed-off-by: Andrey Skvortsov <andrej.skvortzov@gmail.com>
> > ---
> >  tools/testing/selftests/vm/Makefile |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selfte=
sts/vm/Makefile
> > index 4c4b1f6..077828c 100644
> > --- a/tools/testing/selftests/vm/Makefile
> > +++ b/tools/testing/selftests/vm/Makefile
> > @@ -7,7 +7,7 @@ BINARIES +=3D transhuge-stress
> > =20
> >  all: $(BINARIES)
> >  %: %.c
> > -	$(CC) $(CFLAGS) -o $@ $^
> > +	$(CC) $(CFLAGS) -o $@ $^ -lrt
> > =20
> >  run_tests: all
> >  	@/bin/sh ./run_vmtests || (echo "vmtests: [FAIL]"; exit 1)
> >=20
>=20
> Andrey,
>=20
> I don't see any undefined references when I build. Curious if it is
> specific to your env??
>=20
> Please include the warning in the change log
> when you fix warnings in the future.
>=20

thanks for the comment.=20

Here is what I get without a patch:

linux-next/tools/testing/selftests/vm $ make
gcc -Wall -o hugepage-mmap hugepage-mmap.c
gcc -Wall -o hugepage-shm hugepage-shm.c
gcc -Wall -o map_hugetlb map_hugetlb.c
gcc -Wall -o thuge-gen thuge-gen.c
gcc -Wall -o hugetlbfstest hugetlbfstest.c
gcc -Wall -o transhuge-stress transhuge-stress.c
/tmp/ccpWoqkG.o: In function `main':
transhuge-stress.c:(.text+0x3a3): undefined reference to
`clock_gettime'
transhuge-stress.c:(.text+0x4dc): undefined reference to
`clock_gettime'
collect2: ld returned 1 exit status
make: *** [transhuge-stress] Error 1


$ gcc --version
gcc (Ubuntu/Linaro 4.6.4-1ubuntu1~12.04) 4.6.4.
The same error I get on my other Debian system.

man page for clock_gettime says 'Link with -lrt'. So I think the error
message is correct.

--=20
Best regards,
Andrey Skvortsov

Secure e-mail with gnupg: See http://www.gnupg.org/
PGP Key ID: 0x57A3AEAD



--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJUrZLFAAoJEAF8y6L1SLCt200P/33rCLSp3P9scxETIOrv6nAy
zwAFw4dm2q3xitTRI+ON1o4otHPUenddiZlzQyQajLBF1esapOqka+ncLR+qMpck
m/XKgdiDgHrCeEs+2eT+nHIAiTRGfNXShb55VRIjWmHVsyJlYNlTdrJlVJARl/o2
1XNLX1TdkmaVJcS1p3Oqif2VjgLJ9mNUHsMmySLE1K5ctk4WUOwRKHS5lpHvhIrd
btT5Ef1OeI0Ts6po8Wi3WLP5Ux7LOvRXH57HkpXVxJynE+A2Yh1o3hbrrxGZK2nX
QfOvfj6ARkOUnwjS9PTSIzBQyLQz0dk91+Px3tXFfiSufA+ycuIlEUKRCZW7AcWB
q75oxwiLcfez9rpTnkdhM84tjhg4k+iDuyU0uT5l9IBGSvOYfge1H53j1+gRVxNm
EqBkzsHzxAJA3sH5PzqRWIWeGplAgQds1zQjDJUQjjeaJQ1+Zdv3T+dmjr71TZl4
prUPFkUO2K9fUL2uj/IxnSIjJPzCb7TVCXccXJp8NBRVhcJJ+TNggvVsu9x/JBkd
TW3a9UQt2Q316UMPoSy+GAYS8S1MtaR629KS/oUYqlEpnXv570pImVgdhIUluVGt
OZx52ytFj1O6Tckl59JIqVTPRILeWiSUy/KIyh3/QXkNcC9WlxLxnJGjrPGf17qV
crRLI+BbesqcX/OAj1Om
=RAVD
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
