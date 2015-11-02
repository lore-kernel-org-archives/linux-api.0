From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: [PATCH v2 selftests 4/6] selftests: Make scripts executable
Date: Mon, 2 Nov 2015 12:22:14 +0000
Message-ID: <20151102122214.GE17015@decadent.org.uk>
References: <20151102122048.GA17015@decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="KlAEzMkarCnErv5Q"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151102122048.GA17015-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--KlAEzMkarCnErv5Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Fixes: 87b2d44026e0 ("selftests: add memfd/sealing page-pinning tests")
Fixes: 2bf9e0ab08c6 ("locking/static_keys: Provide a selftest")
Signed-off-by: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
---
 tools/testing/selftests/memfd/run_fuse_test.sh          | 0
 tools/testing/selftests/static_keys/test_static_keys.sh | 0
 2 files changed, 0 insertions(+), 0 deletions(-)
 mode change 100644 => 100755 tools/testing/selftests/memfd/run_fuse_test.sh
 mode change 100644 => 100755 tools/testing/selftests/static_keys/test_static_keys.sh

diff --git a/tools/testing/selftests/memfd/run_fuse_test.sh b/tools/testing/selftests/memfd/run_fuse_test.sh
old mode 100644
new mode 100755
diff --git a/tools/testing/selftests/static_keys/test_static_keys.sh b/tools/testing/selftests/static_keys/test_static_keys.sh
old mode 100644
new mode 100755


--KlAEzMkarCnErv5Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVjdVdue/yOyVhhEJAQr5nBAAktaQXR7D0Vokb36uYbh2nMl8GuJiSqfS
Fs5Xu/3SkuzojOdlrxzCzxXHHfCqjtNhaqj+rQN8RD976YHmY+xiLQvq4rd/I5qR
bW+OmrVNMV5Qw1ELx/PYlPfGmXhJ/+JRudO0o24PHRjUJVCxPVf5Q9Qbyr5I+4Uy
3COZF8mfW/Tf4/5Jt8iubhcYVxq/S09hfTK9kgLcI/OitvHPrDd5DDnoxf5N1QT6
QHFPmiDTGPmNcdfcyphf//oINGl+0sPMnLTaxtDKzp0CkaxERom9Sczy58dVsOza
cDbTKqYiTFPS+oFofOqjznBCu2YVRl04q1RzawPvufqoVvQK+81UUgNIkHSaGqru
GMc/9mUYh9DAIBUGfP3RWCUR4a7e/huSZzsp237cgksjPMUXFY8qLYb4aHt1j/mO
JD4lvWyqPD4E8of1U7e9d+lc3rn+aQJo3KGH1BBVJAVP/FyJppLFS2V4URGzvrca
mJ9hUdEA5rPbi0OXRaTVYGwqlR1Qbs107hjiJWGGjbIO+1EVzX60Sun4d/25+Kwe
MveG75GpV0PBkgW78CcDzsYswBcPkCQTT5wFiFUy2+IurdYUBmh1p/Qv487gWDsa
nBWZVxOTCvLJUIYwI4bqF8s0AVuYq2g/tiaUcT3WbURRWgVfWfCqwTePG6MCpvDI
Oggagjmfey4=
=vg+z
-----END PGP SIGNATURE-----

--KlAEzMkarCnErv5Q--
