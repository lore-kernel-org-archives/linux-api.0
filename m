From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: [PATCH selftests 2/6] selftests: memfd: Stop unnecessary rebuilds
Date: Sat, 31 Oct 2015 23:37:03 +0000
Message-ID: <1446334623.2595.15.camel@decadent.org.uk>
References: <1446334510.2595.13.camel@decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-FjXDvMEPdn5HV3bZjDtY"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446334510.2595.13.camel-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--=-FjXDvMEPdn5HV3bZjDtY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Instead of explicitly running the compiler, add dependencies and take
advantage of implicit rules to build only as necessary.

Signed-off-by: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
---
=C2=A0tools/testing/selftests/memfd/Makefile | 12 ++++++------
=C2=A01 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/memfd/Makefile b/tools/testing/selftes=
ts/memfd/Makefile
index 3e7eb79..fd396ac 100644
--- a/tools/testing/selftests/memfd/Makefile
+++ b/tools/testing/selftests/memfd/Makefile
@@ -4,16 +4,16 @@ CFLAGS +=3D -I../../../../include/uapi/
=C2=A0CFLAGS +=3D -I../../../../include/
=C2=A0CFLAGS +=3D -I../../../../usr/include/
=C2=A0
-all:
-	$(CC) $(CFLAGS) memfd_test.c -o memfd_test
-
=C2=A0TEST_PROGS :=3D memfd_test
=C2=A0
+all: $(TEST_PROGS)
+
=C2=A0include ../lib.mk
=C2=A0
-build_fuse:
-	$(CC) $(CFLAGS) fuse_mnt.c `pkg-config fuse --cflags --libs` -o fuse_mnt
-	$(CC) $(CFLAGS) fuse_test.c -o fuse_test
+build_fuse: fuse_mnt fuse_test
+
+fuse_mnt.o: CFLAGS +=3D $(shell pkg-config fuse --cflags)
+fuse_mnt: LDFLAGS +=3D $(shell pkg-config fuse --libs)
=C2=A0
=C2=A0run_fuse: build_fuse
=C2=A0	@./run_fuse_test.sh || echo "fuse_test: [FAIL]"

--=20
Ben Hutchings
All extremists should be taken out and shot.
--=-FjXDvMEPdn5HV3bZjDtY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAVjVQn+e/yOyVhhEJAQq9ehAArTIjmmyrjydSDq3FmtD+i2o6wp21YIIt
zM5tqKIe1bqvc9E3r3DoTZpDnXJnSFIky62fHuaTVJfEBA5xPRPo0aexJj8agOHE
eqxe/fEefMWweCtGsFdd2Ctk2RFdJs7ZpG9ilqvsvM3U8cqzJJUY0LuA+mwd0XQV
1fPtyHnfb8eZ3un3yOE13Es83HIr5qulgi9DHmQQccge8MUrOYdRvel+lILxFvoO
+QIf7OTQbh2wclP0Yg+MM2gDNoIvSxvjIykNtj/RgKODgHfXTEsITS4JUc9A2/5r
PTRxumT6s7ifkpsdgE/+u5J5NP1WtHHyFKN3eW2djr0ImT9mKmnxnCcAMB+mtOae
cmPnGTrgnFbcZ8zZv0jADZ04yYi0vvSCwQS8nvYBhGQtgCHyLdjfZwlArKDKGl35
WbzPhPCiwn+yCZ2O2FgvBlHUm6mLSvsK7xEv8S9uESK1NZQ64vLtCljv++GoIpTO
5/T/0j6RPHVrZxS0QKtbPCGEahRdWBhr6yZeEFBtreva0VGILfyo6kxWGW7+ALE1
0kOIlGw7+xz4eEj+tGHzAQ8U+MIVbWs2BLYrUMs+kYiF7XyfqThr+lXES8L2i2HA
tbfobo8RtiCtHzq5svQ/LQmf5jYRSa2yLEw0fyng32PHjyVgnhQNYl4NHmMxWMP+
KzjYLRUwdX0=
=TRrE
-----END PGP SIGNATURE-----

--=-FjXDvMEPdn5HV3bZjDtY--
