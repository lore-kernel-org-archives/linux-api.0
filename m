From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH v2] selftests: kcmp build fails when invoked from kselftest target
Date: Tue, 10 Mar 2015 18:08:32 -0600
Message-ID: <1426032512-10353-1-git-send-email-shuahkh@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tranmanphong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

kcmp Makefile doesn't have an explicit build rule. As a result,
kcmp build fails, when it is run from top level Makefile target
kselftest. Without the explicit rule, make works only when it is
run in the current directory or from selftests directory. Add an
explicit build rule to fix the problem. In addition, build fails
as it can't find kcmp.h. Fix it by passing CFLAGS.

Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
---
v2: Added deleted pre-requisite back in to address review
    comments.

 tools/testing/selftests/kcmp/Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kcmp/Makefile b/tools/testing/selftests/kcmp/Makefile
index ff0eefd..d615e9c 100644
--- a/tools/testing/selftests/kcmp/Makefile
+++ b/tools/testing/selftests/kcmp/Makefile
@@ -1,8 +1,11 @@
 CC := $(CROSS_COMPILE)$(CC)
-CFLAGS += -I../../../../usr/include/
+CFLAGS += -I../../../../include/uapi -I../../../../usr/include/
 
 all: kcmp_test
 
+kcmp_test:
+	$(CC) $(CFLAGS) kcmp_test.c -o kcmp_test
+
 run_tests: all
 	@./kcmp_test || echo "kcmp_test: [FAIL]"
 
-- 
2.1.0
