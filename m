From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: [PATCH selftests 6/6] selftests: breakpoint: Actually build it
Date: Sat, 31 Oct 2015 23:39:20 +0000
Message-ID: <1446334760.2595.20.camel@decadent.org.uk>
References: <1446334510.2595.13.camel@decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Tzrm9gEDRSHZ8rKtZXU/"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446334510.2595.13.camel-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--=-Tzrm9gEDRSHZ8rKtZXU/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Fixes: 9fae100cbd10 ("selftests: breakpoints: fix installing error on ...")
Signed-off-by: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
---
=C2=A0tools/testing/selftests/breakpoints/Makefile | 2 +-
=C2=A01 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/breakpoints/Makefile b/tools/testing/s=
elftests/breakpoints/Makefile
index d27108b..c0d9570 100644
--- a/tools/testing/selftests/breakpoints/Makefile
+++ b/tools/testing/selftests/breakpoints/Makefile
@@ -6,7 +6,7 @@ ifeq ($(ARCH),x86)
=C2=A0TEST_PROGS :=3D breakpoint_test
=C2=A0endif
=C2=A0
-all:
+all: $(TEST_PROGS)
=C2=A0
=C2=A0include ../lib.mk
=C2=A0
--=20
Ben Hutchings
All extremists should be taken out and shot.
--=-Tzrm9gEDRSHZ8rKtZXU/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAVjVRKOe/yOyVhhEJAQotcxAAqmGcsDn5xzSSoHwqSOvR4fkjq4BCwwvp
hqtI6iGBDF1E74L2WeEgs3EoyG0HbkuT6a6B3YO9+XUGWWpfPyXwMBoN2JB6GQN5
3DYIxFDmT3nV6ZT+69kjYEMBzK93vHouoU6BFuA1tADpK5cG+JRMXVAp0RGk9BO5
bH8J7ntTbVBUq2dD00AQ4O9ukRwxlU5uhaaXAn55Rbu6i9o2g7lgXMiZIba2keJX
pBoH5Rw96RRuxMGd4r9uyx2q7jFgrbP/qYey5a/K/7cg7kSVvnRURvcE3vtoLAVR
9McEuymBTCherTm3XoUaUdnck1/qwwksV1GPjokAEzsgM47KXItW/27xqJtcKPcZ
0WdgKbYoyWfsn0g7C7+VkPSVBq5uBx2OoLWw8U3RTPxF/ZUJPrEc38lIDB3l1qIt
b3MPqT3mLoRcmH9nRZ70UoG2mTQEbrx+LHlYXRVgA0oPnkw4SvQJaEQYm2FlOTYV
WjrkdETtOxr/X8EBS8pXjbNykTKx1dBpeiOmajCDgH0hwitz733F5PdMm8KZYcMJ
83t9JL1fuRGqJcCSUoycR+QKZZINZPINzqcoMIN3pR6ZDUAQm4oQ4QAKF/sNVmdg
zp/yXp5/0/G/Rkxxup1GCJ4yZxkySnuzuTUi8Ol2zDuAJCvxYcAOAhnSO9nQxJYt
7Bc50OBPQTM=
=pxnY
-----END PGP SIGNATURE-----

--=-Tzrm9gEDRSHZ8rKtZXU/--
