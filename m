From: Vinson Lee <vlee-xCSkyg8dI+0RB7SZvlqPiA@public.gmane.org>
Subject: [PATCH] selftests/exec: Fix build on older distros.
Date: Thu, 25 Jun 2015 16:29:08 -0700
Message-ID: <1435274950-17106-1-git-send-email-vlee@twopensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vinson Lee <vlee-1v8oiQdgUNlBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

=46rom: Vinson Lee <vlee-1v8oiQdgUNlBDgjK7y7TUQ@public.gmane.org>

This patch fixes this build error on CentOS 5.

execveat.c: In function =E2=80=98check_execveat_pathmax=E2=80=99:
execveat.c:185: error: =E2=80=98AT_EMPTY_PATH=E2=80=99 undeclared (firs=
t use in this function)
execveat.c:185: error: (Each undeclared identifier is reported only onc=
e
execveat.c:185: error: for each function it appears in.)
execveat.c: In function =E2=80=98run_tests=E2=80=99:
execveat.c:221: error: =E2=80=98O_PATH=E2=80=99 undeclared (first use i=
n this function)
execveat.c:222: error: =E2=80=98O_CLOEXEC=E2=80=99 undeclared (first us=
e in this function)
execveat.c:258: error: =E2=80=98AT_EMPTY_PATH=E2=80=99 undeclared (firs=
t use in this function)

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 3.19+
Signed-off-by: Vinson Lee <vlee-1v8oiQdgUNlBDgjK7y7TUQ@public.gmane.org>
---
 tools/testing/selftests/exec/execveat.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/exec/execveat.c b/tools/testing/se=
lftests/exec/execveat.c
index 8d5d1d2..170148d 100644
--- a/tools/testing/selftests/exec/execveat.c
+++ b/tools/testing/selftests/exec/execveat.c
@@ -20,6 +20,16 @@
 #include <string.h>
 #include <unistd.h>
=20
+#ifndef AT_EMPTY_PATH
+# define AT_EMPTY_PATH 0x1000
+#endif
+#ifndef O_PATH
+# define O_PATH 010000000
+#endif
+#ifndef O_CLOEXEC
+# define O_CLOEXEC 02000000
+#endif
+
 static char longpath[2 * PATH_MAX] =3D "";
 static char *envp[] =3D { "IN_TEST=3Dyes", NULL, NULL };
 static char *argv[] =3D { "execveat", "99", NULL };
--=20
1.8.2.1
