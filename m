From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: [PATCH v2 selftests 2/6] selftests: memfd: Stop unnecessary rebuilds
Date: Mon, 2 Nov 2015 12:21:57 +0000
Message-ID: <20151102122157.GC17015@decadent.org.uk>
References: <20151102122048.GA17015@decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="8X7/QrJGcKSMr1RN"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151102122048.GA17015-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--8X7/QrJGcKSMr1RN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Instead of explicitly running the compiler, add dependencies and take
advantage of implicit rules to build only as necessary.

Signed-off-by: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
---
 tools/testing/selftests/memfd/Makefile | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/memfd/Makefile b/tools/testing/selftes=
ts/memfd/Makefile
index 3e7eb79..fd396ac 100644
--- a/tools/testing/selftests/memfd/Makefile
+++ b/tools/testing/selftests/memfd/Makefile
@@ -4,16 +4,16 @@ CFLAGS +=3D -I../../../../include/uapi/
 CFLAGS +=3D -I../../../../include/
 CFLAGS +=3D -I../../../../usr/include/
=20
-all:
-	$(CC) $(CFLAGS) memfd_test.c -o memfd_test
-
 TEST_PROGS :=3D memfd_test
=20
+all: $(TEST_PROGS)
+
 include ../lib.mk
=20
-build_fuse:
-	$(CC) $(CFLAGS) fuse_mnt.c `pkg-config fuse --cflags --libs` -o fuse_mnt
-	$(CC) $(CFLAGS) fuse_test.c -o fuse_test
+build_fuse: fuse_mnt fuse_test
+
+fuse_mnt.o: CFLAGS +=3D $(shell pkg-config fuse --cflags)
+fuse_mnt: LDFLAGS +=3D $(shell pkg-config fuse --libs)
=20
 run_fuse: build_fuse
 	@./run_fuse_test.sh || echo "fuse_test: [FAIL]"


--8X7/QrJGcKSMr1RN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVjdVZee/yOyVhhEJAQq6xRAArIs8jreOGn1YvE4IJDWtuTtxBU6+Wh3J
RzLv+l8uX5MM2vZx+xSUTV/+fkK3UFPxIHt9ylOu3k+hiyuX59a6s3CRhEG0/vGA
Kayisc7lvAkibcqwa40+j7toMaNMDKk36peQaHT3y11WVa+89nmQDaJ3iyBeGyq+
9LoRSeW10CFPZQnnKB1mMLKGA7RSKiEnBr0QA2xlcSLOaqGhWI87EnfEhHGD2/8C
MnB7qHQonAWKIuJFNngKOL8IriZFr2mZIuPnjwnNqFQYo+F97UuvsPPoEfRFGM+C
0BaTh5YRQcVCEoMO9SwEtWZQo4BSgRxRWxqRrFV1NjU0taYEuVUyMzuYNN3VJ+CA
gW950NwPACn6gCY/99GoG5W7oKZxzhsDN8MNL09fEI8Fb0WrP7W5mJ67wCXopYpj
dThLN3YsuvEQOBxhnBfV6r6ny5Phpr0ja+JvOxz7t4Sr/DhGAZpSmy/05h6ij6u0
2LMvFcbvnoTpBAC1A037nV1EWkE99TI63emrAVNtv9cT+wz+z2SRV2TofzJjOOZh
3l7G17j46LqjOpXy5srucjeJfV2UYTQNiJawvCkgOBxYA88ZskqtzF8t2Gmdjv3y
DcLGdDc+OKqQyxCD2ojJiUmVdlQBbBsQ3EOlsdeIZDFmIgqOsf4Zr+NVexzw2sv9
p0nMV9F+9z0=
=npF3
-----END PGP SIGNATURE-----

--8X7/QrJGcKSMr1RN--
