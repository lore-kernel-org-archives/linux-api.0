From: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 5/5] kselftest: Add exit code defines
Date: Fri,  8 May 2015 15:09:47 -0700
Message-ID: <b52845012054c45a0dd40d58f16bc54b6cb31ff5.1431121818.git.dvhart@linux.intel.com>
References: <57d921b1c30e8258ca4b2f55637424527317e92f.1431121818.git.dvhart@linux.intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57d921b1c30e8258ca4b2f55637424527317e92f.1431121818.git.dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
In-Reply-To: <cover.1431121818.git.dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
References: <cover.1431121818.git.dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Define the exit codes with KSFT_PASS and similar so tests can use these
directly if they choose. Also enable harnesses and other tooling to use
the defines instead of hardcoding the return codes.

Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Cc: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Signed-off-by: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 tools/testing/selftests/kselftest.h | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kselftest.h b/tools/testing/selftests/kselftest.h
index 572c888..ef1c80d 100644
--- a/tools/testing/selftests/kselftest.h
+++ b/tools/testing/selftests/kselftest.h
@@ -13,6 +13,13 @@
 #include <stdlib.h>
 #include <unistd.h>
 
+/* define kselftest exit codes */
+#define KSFT_PASS  0
+#define KSFT_FAIL  1
+#define KSFT_XFAIL 2
+#define KSFT_XPASS 3
+#define KSFT_SKIP  4
+
 /* counters */
 struct ksft_count {
 	unsigned int ksft_pass;
@@ -40,23 +47,23 @@ static inline void ksft_print_cnts(void)
 
 static inline int ksft_exit_pass(void)
 {
-	exit(0);
+	exit(KSFT_PASS);
 }
 static inline int ksft_exit_fail(void)
 {
-	exit(1);
+	exit(KSFT_FAIL);
 }
 static inline int ksft_exit_xfail(void)
 {
-	exit(2);
+	exit(KSFT_XFAIL);
 }
 static inline int ksft_exit_xpass(void)
 {
-	exit(3);
+	exit(KSFT_XPASS);
 }
 static inline int ksft_exit_skip(void)
 {
-	exit(4);
+	exit(KSFT_SKIP);
 }
 
 #endif /* __KSELFTEST_H */
-- 
2.1.4
