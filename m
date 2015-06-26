From: Vinson Lee <vlee-xCSkyg8dI+0RB7SZvlqPiA@public.gmane.org>
Subject: [PATCH v2] selftests/exec: Fix build on older distros.
Date: Fri, 26 Jun 2015 16:11:27 -0700
Message-ID: <1435360289-22531-1-git-send-email-vlee@twopensource.com>
References: <CAHse=S817frpt-SGVQCWf5Fq3jV3mHdYEkU4XFhu48jkT6CKog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHse=S817frpt-SGVQCWf5Fq3jV3mHdYEkU4XFhu48jkT6CKog-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
 tools/testing/selftests/exec/execveat.c | 34 +++++++++++++++++++++++++=
++++++++
 1 file changed, 34 insertions(+)

diff --git a/tools/testing/selftests/exec/execveat.c b/tools/testing/se=
lftests/exec/execveat.c
index 8d5d1d2..30d2555 100644
--- a/tools/testing/selftests/exec/execveat.c
+++ b/tools/testing/selftests/exec/execveat.c
@@ -20,6 +20,40 @@
 #include <string.h>
 #include <unistd.h>
=20
+#if defined( __alpha__)
+# ifndef O_CLOEXEC
+#  define O_CLOEXEC	010000000
+# endif
+# ifndef O_PATH
+#  define O_PATH	040000000
+# endif
+#elif defined(__hppa__)
+# ifndef O_CLOEXEC
+#  define O_CLOEXEC	010000000
+# endif
+# ifndef O_PATH
+#  define O_PATH	020000000
+# endif
+#elif defined(__sparc__)
+# ifndef O_CLOEXEC
+#  define O_CLOEXEC	0x400000
+# endif
+# ifndef O_PATH
+#  define O_PATH 	0x1000000
+# endif
+#else
+# ifndef O_CLOEXEC
+#  define O_CLOEXEC	02000000
+# endif
+# ifndef O_PATH
+#  define O_PATH	010000000
+# endif
+#endif
+
+#ifndef AT_EMPTY_PATH
+# define AT_EMPTY_PATH	0x1000
+#endif
+
 static char longpath[2 * PATH_MAX] =3D "";
 static char *envp[] =3D { "IN_TEST=3Dyes", NULL, NULL };
 static char *argv[] =3D { "execveat", "99", NULL };
--=20
1.8.2.1
