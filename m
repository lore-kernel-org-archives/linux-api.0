From: Darren Hart <dvhart@linux.intel.com>
Subject: [PATCH 5/6] kselftest: Add exit code defines
Date: Tue, 12 May 2015 21:07:56 -0700
Message-ID: <374765e8ced4c1f225b251f6a620e0b279467f80.1431489408.git.dvhart@linux.intel.com>
References: <077301628833a25c85ee597cd8f4b8fcc3f30714.1431489408.git.dvhart@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <077301628833a25c85ee597cd8f4b8fcc3f30714.1431489408.git.dvhart@linux.intel.com>
In-Reply-To: <cover.1431489408.git.dvhart@linux.intel.com>
References: <cover.1431489408.git.dvhart@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: chrubis@suse.cz, Darren Hart <dvhart@linux.intel.com>, Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Davidlohr Bueso <dave@stgolabs.net>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
List-Id: linux-api@vger.kernel.org

Define the exit codes with KSFT_PASS and similar so tests can use these
directly if they choose. Also enable harnesses and other tooling to use
the defines instead of hardcoding the return codes.

Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-api@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Darren Hart <dvhart@linux.intel.com>
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
