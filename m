From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH] selftests/memfd: fix mfd_fail_open() to pass in buf to printf
Date: Thu,  4 Sep 2014 09:07:22 -0600
Message-ID: <1409843242-6596-1-git-send-email-shuahkh@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, bobby.prani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

mfd_fail_open() doesn't pass in the buffer to printf resulting
in the following warning:

memfd_test.c: In function =E2=80=98mfd_fail_open=E2=80=99:
memfd_test.c:208:3: warning: format =E2=80=98%s=E2=80=99 expects a matc=
hing =E2=80=98char *=E2=80=99 argument [-Wformat=3D]
   printf("open(%s) didn't fail as expected\n");
   ^

This change fixes the problem.

Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
---
 tools/testing/selftests/memfd/memfd_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/memfd/memfd_test.c b/tools/testing=
/selftests/memfd/memfd_test.c
index cb5001b..0b9eafb 100644
--- a/tools/testing/selftests/memfd/memfd_test.c
+++ b/tools/testing/selftests/memfd/memfd_test.c
@@ -203,7 +203,7 @@ static void mfd_fail_open(int fd, int flags, mode_t=
 mode)
 	sprintf(buf, "/proc/self/fd/%d", fd);
 	r =3D open(buf, flags, mode);
 	if (r >=3D 0) {
-		printf("open(%s) didn't fail as expected\n");
+		printf("open(%s) didn't fail as expected\n", buf);
 		abort();
 	}
 }
--=20
1.9.1
