From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: [PATCH selftests 1/6] selftests: Add missing #include directives
Date: Sat, 31 Oct 2015 23:36:43 +0000
Message-ID: <1446334603.2595.14.camel@decadent.org.uk>
References: <1446334510.2595.13.camel@decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-i0oOdxixJWnltpWmUb01"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446334510.2595.13.camel-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--=-i0oOdxixJWnltpWmUb01
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Several C programs fail to include the headers declaring all the
functions they call, resulting in warnings or errors.

After this, memfd_test.c is still missing some function declarations
but can't easily get them because of a conflict between
<linux/fcntl.h> and <sys/fcntl.h>.

Signed-off-by: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
---
=C2=A0tools/testing/selftests/memfd/memfd_test.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0| 1 +
=C2=A0tools/testing/selftests/mqueue/mq_open_tests.c | 1 +
=C2=A0tools/testing/selftests/mqueue/mq_perf_tests.c | 1 +
=C2=A0tools/testing/selftests/timers/nanosleep.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0| 1 +
=C2=A04 files changed, 4 insertions(+)

diff --git a/tools/testing/selftests/memfd/memfd_test.c b/tools/testing/sel=
ftests/memfd/memfd_test.c
index 0b9eafb..5347ef6 100644
--- a/tools/testing/selftests/memfd/memfd_test.c
+++ b/tools/testing/selftests/memfd/memfd_test.c
@@ -15,6 +15,7 @@
=C2=A0#include <sys/mman.h>
=C2=A0#include <sys/stat.h>
=C2=A0#include <sys/syscall.h>
+#include <sys/wait.h>
=C2=A0#include <unistd.h>
=C2=A0
=C2=A0#define MFD_DEF_SIZE 8192
diff --git a/tools/testing/selftests/mqueue/mq_open_tests.c b/tools/testing=
/selftests/mqueue/mq_open_tests.c
index 9c1a5d35..e0a74bd 100644
--- a/tools/testing/selftests/mqueue/mq_open_tests.c
+++ b/tools/testing/selftests/mqueue/mq_open_tests.c
@@ -31,6 +31,7 @@
=C2=A0#include <sys/resource.h>
=C2=A0#include <sys/stat.h>
=C2=A0#include <mqueue.h>
+#include <error.h>
=C2=A0
=C2=A0static char *usage =3D
=C2=A0"Usage:\n"
diff --git a/tools/testing/selftests/mqueue/mq_perf_tests.c b/tools/testing=
/selftests/mqueue/mq_perf_tests.c
index 8519e9e..8188f72 100644
--- a/tools/testing/selftests/mqueue/mq_perf_tests.c
+++ b/tools/testing/selftests/mqueue/mq_perf_tests.c
@@ -37,6 +37,7 @@
=C2=A0#include <sys/stat.h>
=C2=A0#include <mqueue.h>
=C2=A0#include <popt.h>
+#include <error.h>
=C2=A0
=C2=A0static char *usage =3D
=C2=A0"Usage:\n"
diff --git a/tools/testing/selftests/timers/nanosleep.c b/tools/testing/sel=
ftests/timers/nanosleep.c
index 8a3c29d..ff942ff 100644
--- a/tools/testing/selftests/timers/nanosleep.c
+++ b/tools/testing/selftests/timers/nanosleep.c
@@ -19,6 +19,7 @@
=C2=A0 *=C2=A0=C2=A0=C2=A0GNU General Public License for more details.
=C2=A0 */
=C2=A0
+#include <errno.h>
=C2=A0#include <stdio.h>
=C2=A0#include <stdlib.h>
=C2=A0#include <time.h>

--=20
Ben Hutchings
All extremists should be taken out and shot.
--=-i0oOdxixJWnltpWmUb01
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAVjVQi+e/yOyVhhEJAQp70xAAuR/06WmGVleqWoE+/jl05Mtlms3eZs/B
T9rJJUmnLdljzY012Uz++sWu/8kwVcTAW/sG0Toqy3HDdNn5jtzJn4/E7M3iqc2x
FPyR9AstfKfEmVOulrOJiDZQ+DURLlsuTnQRQc8QfSzRKV34luX5M9DVyp32uG0S
9G7VctxBrNeQp92YOZq3JeXITtAt8VuCBHGdfU3saoxkRKUHbO66CZQEpYRoYZLM
vrXXddrMH5agv9eBCYuG3TN7PhYH1xLJXaO4UkI5rZXcuX1E+cRQkNhHMABvm/YT
yxwpI8qDKHPGsovwZKxWdBTaJ5ZVQEmSsBjk8Lkj+SYDuQUHAKv6IhRj+5YnqeW/
4PV+6QfuaWSULyAJiexPF5hoOGysGANHEsTcMNxAC3P12uaOKpmLEVQdY25jpdqX
HjeQ6XJCBqMSZLLkCa75EXbRly96NhTk/JOxtky8usWO9rePV+xD/G940l2n2z/M
N8GTuHBdvkyCwk9NZLj0EH/nGOryE3nz6zJzJx4aHYMBCI9JpXnsZ4OEhlA7jx2g
HfUeKexhRg3k5fz/kcko/NmUubhQwG+Z+488BdoIYmF0WTnUQjX5XFWHL3D4IUHL
N22RDeOu7u4N8EqsbbsJXhE1Isy1JW/gLGuDwNkeOLOd8JnsakQUchJefIQZxcko
v3rj8o/0ivQ=
=a03d
-----END PGP SIGNATURE-----

--=-i0oOdxixJWnltpWmUb01--
