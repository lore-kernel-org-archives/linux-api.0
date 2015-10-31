From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: [PATCH selftests 4/6] selftests: Make scripts executable
Date: Sat, 31 Oct 2015 23:37:41 +0000
Message-ID: <1446334661.2595.17.camel@decadent.org.uk>
References: <1446334510.2595.13.camel@decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-HdnzBosp23TrKRD1YdJA"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446334510.2595.13.camel-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--=-HdnzBosp23TrKRD1YdJA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Fixes: 87b2d44026e0 ("selftests: add memfd/sealing page-pinning tests")
Fixes: 2bf9e0ab08c6 ("locking/static_keys: Provide a selftest")
Signed-off-by: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
---
=C2=A0tools/testing/selftests/memfd/run_fuse_test.sh=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0| 0
=C2=A0tools/testing/selftests/static_keys/test_static_keys.sh | 0
=C2=A02 files changed, 0 insertions(+), 0 deletions(-)
=C2=A0mode change 100644 =3D> 100755 tools/testing/selftests/memfd/run_fuse=
_test.sh
=C2=A0mode change 100644 =3D> 100755 tools/testing/selftests/static_keys/te=
st_static_keys.sh

diff --git a/tools/testing/selftests/memfd/run_fuse_test.sh b/tools/testing=
/selftests/memfd/run_fuse_test.sh
old mode 100644
new mode 100755
diff --git a/tools/testing/selftests/static_keys/test_static_keys.sh b/tool=
s/testing/selftests/static_keys/test_static_keys.sh
old mode 100644
new mode 100755

--=20
Ben Hutchings
All extremists should be taken out and shot.
--=-HdnzBosp23TrKRD1YdJA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAVjVQxee/yOyVhhEJAQr/qxAA0BJYs+OmFLUbVCnQcwHKf+uxB0VNJieH
ikPyxsKMy+FwsllpILo7T8iNs8qedBAaannFCXO6aTtkwlp51shsAGNYbA3NajfT
og0ddqzoi80kDnR5uK0p5zmlsyostbLUpbjcNpv8w7cjXoaImipqH0iw3taLnEl+
Bz5hrMZk8XjXwLk/Mkm06Gl7NrSRC/NeL2C6rpcaph9ZhutqPrluzma5OyUiAxmh
4qa4qfWpZwSTjJvJVzrUXFSFHU7pMmLDUvlXaFvFDSNScyIBjI3ChVkBbwCprYn3
D4PWUCdvndLbCWZsVYtKXGt/6wVgOUwMn1fsHG2zF1n7JbxJbz687YvmvBRv3nYM
fRD950QKE6q3CLiGKVyIxq/epV0xnU5PAKIh26ajEVbqX4YNmDn5mpn0yM4rQoln
5VJ09e+UFqxHm16u6B/Vcijyqd9Y7r7o4Tt5w+o3V38dggx2tHY1d0rgxySJPNx+
FPKkvsTirBXmLpr3IwcFdq8woZjVCgU9vV4BWWprSZzYA/QjHqPTFviTWfDjtHSn
gxo1CWsrqclSb+OApLEi6JWi+6npoladIqkcMjpUQqdufEgt6JkddXRyY9Wpr2Wd
819E/mW07wJ2fsnzcvpgKt4JKfOefKX6uBVDxurRLRA3z7gbAe43D8csuxoT+IxR
XdkAyDtroXA=
=Gkm+
-----END PGP SIGNATURE-----

--=-HdnzBosp23TrKRD1YdJA--
