From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: [PATCH v2 selftests 6/6] selftests: breakpoint: Actually build it
Date: Mon, 2 Nov 2015 12:22:29 +0000
Message-ID: <20151102122229.GG17015@decadent.org.uk>
References: <20151102122048.GA17015@decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="OFj+1YLvsEfSXdCH"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151102122048.GA17015-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--OFj+1YLvsEfSXdCH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Fixes: 9fae100cbd10 ("selftests: breakpoints: fix installing error on ...")
Signed-off-by: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
---
 tools/testing/selftests/breakpoints/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/breakpoints/Makefile b/tools/testing/s=
elftests/breakpoints/Makefile
index d27108b..c0d9570 100644
--- a/tools/testing/selftests/breakpoints/Makefile
+++ b/tools/testing/selftests/breakpoints/Makefile
@@ -6,7 +6,7 @@ ifeq ($(ARCH),x86)
 TEST_PROGS :=3D breakpoint_test
 endif
=20
-all:
+all: $(TEST_PROGS)
=20
 include ../lib.mk
=20

--OFj+1YLvsEfSXdCH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVjdVhOe/yOyVhhEJAQqX2g/9EAsYuoMWZOxskf9st/XI04CGTYL9smJF
7jAdXVbclAMMN1DYeqzW6wG8dghRxotlHGmotWDAA68GuTpq72MNSkmL2jqe/VDR
2YKp1X5OeNVpeVOr0BmupnuXjWkglseXsgNRk35bPblChqALhghiJ53GmBG0jaKz
R9LUgRhU6SflJX6I84T0HJWCopejm1XlYQmjS2JAKv3QADw2fI0gj7bAMSWS6qdC
mDqtSf8GscdpAlSHjNGfjiDHxUtzjSypzfMu9Qs9Dy/c9Juwgv+0/32HF/NdL0gp
sBoOpnbmZIpVLyqvzCryT69wiOP3akVbmNPin9jNLe16/nxt/qoX94NAF1eBjUtc
a+zYmAd/co96BkwLS4h87/QzSbg3SE31klemveewgjHIaYYA1QK6/xdzZUx2b+xV
nJT+rkSYIDH94kQNguePbgboV6X61y0X21WNelfWOhICj7AVHQQeFCjeFblR6pzC
9K688yClALg02VImRwWyKNRBLjzLUVW0lDWjjaQKoUOemHX0CH0XQcFV2G5Cuxbs
8ChQK13YP090S5vBoyVUPtF3DUOyvslmZuT3UTru0HFh6f6Oc8YgxoD0jp+5QmKw
mnQSXXTotbvDbmYBLkOAxz38F3wRZWurRmUFWEOqmhX94Kf/Ju/pEDf2aWQE91xc
uVl/l53oCxw=
=3EFm
-----END PGP SIGNATURE-----

--OFj+1YLvsEfSXdCH--
