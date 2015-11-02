From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: [PATCH v2 selftests 1/6] selftests: Add missing #include directives
Date: Mon, 2 Nov 2015 12:21:46 +0000
Message-ID: <20151102122146.GB17015@decadent.org.uk>
References: <20151102122048.GA17015@decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="kXdP64Ggrk/fb43R"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151102122048.GA17015-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--kXdP64Ggrk/fb43R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Several C programs fail to include the headers declaring all the
functions they call, resulting in warnings or errors.

After this, memfd_test.c is still missing some function declarations
but can't easily get them because of a conflict between
<linux/fcntl.h> and <sys/fcntl.h>.

Signed-off-by: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
---
 tools/testing/selftests/memfd/memfd_test.c     | 1 +
 tools/testing/selftests/mqueue/mq_open_tests.c | 1 +
 tools/testing/selftests/mqueue/mq_perf_tests.c | 1 +
 tools/testing/selftests/timers/nanosleep.c     | 1 +
 4 files changed, 4 insertions(+)

diff --git a/tools/testing/selftests/memfd/memfd_test.c b/tools/testing/sel=
ftests/memfd/memfd_test.c
index 0b9eafb..5347ef6 100644
--- a/tools/testing/selftests/memfd/memfd_test.c
+++ b/tools/testing/selftests/memfd/memfd_test.c
@@ -15,6 +15,7 @@
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <sys/syscall.h>
+#include <sys/wait.h>
 #include <unistd.h>
=20
 #define MFD_DEF_SIZE 8192
diff --git a/tools/testing/selftests/mqueue/mq_open_tests.c b/tools/testing=
/selftests/mqueue/mq_open_tests.c
index 9c1a5d35..e0a74bd 100644
--- a/tools/testing/selftests/mqueue/mq_open_tests.c
+++ b/tools/testing/selftests/mqueue/mq_open_tests.c
@@ -31,6 +31,7 @@
 #include <sys/resource.h>
 #include <sys/stat.h>
 #include <mqueue.h>
+#include <error.h>
=20
 static char *usage =3D
 "Usage:\n"
diff --git a/tools/testing/selftests/mqueue/mq_perf_tests.c b/tools/testing=
/selftests/mqueue/mq_perf_tests.c
index 8519e9e..8188f72 100644
--- a/tools/testing/selftests/mqueue/mq_perf_tests.c
+++ b/tools/testing/selftests/mqueue/mq_perf_tests.c
@@ -37,6 +37,7 @@
 #include <sys/stat.h>
 #include <mqueue.h>
 #include <popt.h>
+#include <error.h>
=20
 static char *usage =3D
 "Usage:\n"
diff --git a/tools/testing/selftests/timers/nanosleep.c b/tools/testing/sel=
ftests/timers/nanosleep.c
index 8a3c29d..ff942ff 100644
--- a/tools/testing/selftests/timers/nanosleep.c
+++ b/tools/testing/selftests/timers/nanosleep.c
@@ -19,6 +19,7 @@
  *   GNU General Public License for more details.
  */
=20
+#include <errno.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <time.h>


--kXdP64Ggrk/fb43R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVjdVWue/yOyVhhEJAQoFPw//Sfbdgplzon+p8mFX1062CU+JQWdEd0J+
7SFkyFtd9xfk7FZvurqIajIlrgy0VV7K0JmZqELpF90r7Dz8I93FmHyQ3WPNjXA2
Y+JZPFZlFO7/6bYp9RenJKYCWqrSwswZOTOB4A6tj9obel9/PpbEs6LLXMg3BsCv
40wBhkhsIQvRRyfWzEfZMyMhKXM1xI31y/IS0vxU72IPQ/u4M8NEE1/w1+eh7NYU
4ueEyGCyg9Tt/uyTUw0phrE7awh4xebf2niJ2RF+n1W32c33SXprbDF78PmVPN/R
6nEVYa4gqDBA7OGs/yij4kTyW2PgRIAjt0DFrfloedre+fW82/tgQ9PB9riLDX2F
ldOqLVAQl/Kkq2bc5OYH+S3kmeNNJMP76Hlch6lmzIkjIT8YHQPvvCq0VRx8Eqbn
c1pKUZ3WTDfjK9cI78o5KJEYUK2E2rNKXuIHlokRmL7dRoW9TLabeEzQarBtM2Hc
9VooSmhW9nXwSoxMRYcs4m68SF8oiRYubMMee6qyW2V41Ep5BN2KbgNIdDDh7wqy
QjXpXZCgx0HZJB0DGMOPOe6W48Y+z0rzhalHajuLd3RI5IFF9MTL1499JjpGaofL
/Dbq/sX6oUmB/3IHMMnyguPuF+wAGvKJF4TLi7zxjBG4Miw7thRrx2yfpUw+FsYT
TQJD101hmhY=
=rlXZ
-----END PGP SIGNATURE-----

--kXdP64Ggrk/fb43R--
