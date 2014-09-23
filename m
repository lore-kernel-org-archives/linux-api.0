From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH v2 5/7] selftests/mount: change test to use ksft framework
Date: Tue, 23 Sep 2014 15:32:58 -0600
Message-ID: <969f0780734a04763f2b54063603b93380244d0c.1411506121.git.shuahkh@osg.samsung.com>
References: <cover.1411506121.git.shuahkh@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1411506121.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
In-Reply-To: <cover.1411506121.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
References: <cover.1411506121.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, dbueso-l3A5Bk7waGM@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, thierry-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Change mount test to use kselftest framework to report
test results.

Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
---
 tools/testing/selftests/mount/unprivileged-remount-test.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mount/unprivileged-remount-test.c b/tools/testing/selftests/mount/unprivileged-remount-test.c
index 1b3ff2f..c64d442 100644
--- a/tools/testing/selftests/mount/unprivileged-remount-test.c
+++ b/tools/testing/selftests/mount/unprivileged-remount-test.c
@@ -13,6 +13,8 @@
 #include <stdbool.h>
 #include <stdarg.h>
 
+#include "../kselftest.h"
+
 #ifndef CLONE_NEWNS
 # define CLONE_NEWNS 0x00020000
 #endif
@@ -45,7 +47,7 @@ static void die(char *fmt, ...)
 	va_start(ap, fmt);
 	vfprintf(stderr, fmt, ap);
 	va_end(ap);
-	exit(EXIT_FAILURE);
+	ksft_exit_fail();
 }
 
 static void write_file(char *filename, char *fmt, ...)
@@ -176,7 +178,7 @@ bool test_unpriv_remount(int mount_flags, int remount_flags, int invalid_flags)
 		die("remount of /tmp with invalid flags "
 		    "succeeded unexpectedly\n");
 	}
-	exit(EXIT_SUCCESS);
+	return ksft_exit_pass();
 }
 
 static bool test_unpriv_remount_simple(int mount_flags)
@@ -238,5 +240,5 @@ int main(int argc, char **argv)
 	{
 		die("Default atime malfunctions\n");
 	}
-	return EXIT_SUCCESS;
+	return ksft_exit_pass();
 }
-- 
1.9.1
