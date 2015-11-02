From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: [PATCH v2 selftests 5/6] selftests: vm: Try harder to allocate huge
 pages
Date: Mon, 2 Nov 2015 12:22:22 +0000
Message-ID: <20151102122221.GF17015@decadent.org.uk>
References: <20151102122048.GA17015@decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="udcq9yAoWb9A4FsZ"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151102122048.GA17015-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--udcq9yAoWb9A4FsZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

If we need to increase the number of huge pages, drop caches first
to reduce fragmentation and then check that we actually allocated
as many as we wanted.  Retry once if that doesn't work.

Signed-off-by: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
---
 tools/testing/selftests/vm/run_vmtests | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vm/run_vmtests b/tools/testing/selftests/vm/run_vmtests
index 9179ce8..97ed1b2 100755
--- a/tools/testing/selftests/vm/run_vmtests
+++ b/tools/testing/selftests/vm/run_vmtests
@@ -20,13 +20,26 @@ done < /proc/meminfo
 if [ -n "$freepgs" ] && [ -n "$pgsize" ]; then
 	nr_hugepgs=`cat /proc/sys/vm/nr_hugepages`
 	needpgs=`expr $needmem / $pgsize`
-	if [ $freepgs -lt $needpgs ]; then
+	tries=2
+	while [ $tries -gt 0 ] && [ $freepgs -lt $needpgs ]; do
 		lackpgs=$(( $needpgs - $freepgs ))
+		echo 3 > /proc/sys/vm/drop_caches
 		echo $(( $lackpgs + $nr_hugepgs )) > /proc/sys/vm/nr_hugepages
 		if [ $? -ne 0 ]; then
 			echo "Please run this test as root"
 			exit 1
 		fi
+		while read name size unit; do
+			if [ "$name" = "HugePages_Free:" ]; then
+				freepgs=$size
+			fi
+		done < /proc/meminfo
+		tries=$((tries - 1))
+	done
+	if [ $freepgs -lt $needpgs ]; then
+		printf "Not enough huge pages available (%d < %d)\n" \
+		       $freepgs $needpgs
+		exit 1
 	fi
 else
 	echo "no hugetlbfs support in kernel?"


--udcq9yAoWb9A4FsZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVjdVfee/yOyVhhEJAQqhVA/+MzUyKmPQqW7YN/oHf7JWpu40JEmgVB8e
d1yPsdTnxO4O450Mdh+jZVKCvFX3cZU1vYpBM/cC/A+VP6ciKAd2WYnPzrjP3NI7
D1t0cZwFg/wPr1JZEA05N9lVg/UFmLuvYWgcEHo/kYTmosUoN3kZVRplvklf8fsH
F6THKnrxBX+dyp+Ad0HiPuEMTq2O8Ww9H09YgJ+HEfH42VK6BQy6KNCv4U3cGnFQ
rrbVwU/f9T9973LNEWOsr2LQ1HdnvLxCZJ+9gq0cMERUYfm5ecoaGDJuqzFEb2Mv
oFm1vUyzC+e9dKBMS8Ew+2/eBjWxESnHcj38Fbs7kpzKFp78bPjRIL4R7QRtc9ls
5YHjgNDFFd3jmPeGe7nD64wskD+n+FpsWFBN7AKzXQTCIUBnVe1VySOdHOddEI2t
6RhzMLH8zGRy4OcJ5JotckAAn3AkjHO/yCAKeXvvCMByHa15nBIUQkn7YSLeqox3
wugTF4jsLgmAqbgQWauHSxagVAOIR/gga1NGAnzOmKpjAu99itxzKjOfoRsYa8Kv
InqXdIh4BQvfIbkhTZvyUMxDl0xgOxP6yvU8R0OlvLLfb9IQKl8IUY1bmfsm4KmZ
QcfoNmVz93vBocPg7anWXf/ARMUF0r0FVw3gPtsiLs6jH9UvwCsSOpSG0MufcNj0
xJ9Wlu0+OdU=
=e8GB
-----END PGP SIGNATURE-----

--udcq9yAoWb9A4FsZ--
