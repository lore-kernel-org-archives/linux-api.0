From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH v2 1/7] selftests: add kselftest framework for uniform test reporting
Date: Tue, 23 Sep 2014 15:32:54 -0600
Message-ID: <0b1961bd4d2104beafd2e8c1a17690f6efe14a61.1411506121.git.shuahkh@osg.samsung.com>
References: <cover.1411506121.git.shuahkh@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1411506121.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
In-Reply-To: <cover.1411506121.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
References: <cover.1411506121.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, dbueso-l3A5Bk7waGM@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, thierry-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Add kselftest framework for tests to use. This is a light
weight framework provides a set of interfaces to report test
results. Tests can use these interfaces to report pass, and
fail cases as well as when failure is due to configuration
problems such as missing modules, or when a test that is should
fail, fails as expected, and a test that should fail, passes.
The framework uses POSIX standard return codes for reporting
results to address the needs of users that want to run the kernel
selftests from their user-space test suites and want to know why a
test failed. In addition, the framework includes interfaces to use
to report test statistics on number of tests passed and failed.

Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
---
 tools/testing/selftests/kselftest.h | 41 +++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 tools/testing/selftests/kselftest.h

diff --git a/tools/testing/selftests/kselftest.h b/tools/testing/selftests/kselftest.h
new file mode 100644
index 0000000..c73fc2c
--- /dev/null
+++ b/tools/testing/selftests/kselftest.h
@@ -0,0 +1,41 @@
+/*
+ * kselftest.h: kselftest framework return codes to include from
+ *		 selftests.
+ *
+ * Copyright (c) 2014 Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *
+ * This file is released under the GPLv2.
+ */
+#ifndef __KSELFTEST_H
+#define __KSELFTEST_H
+
+#include <stdlib.h>
+#include <unistd.h>
+
+/* counters */
+static int ksft_pass;
+static int ksft_fail;
+static int ksft_xfail;
+static int ksft_xpass;
+static int ksft_xskip;
+
+static inline void ksft_inc_pass_cnt(void) { ksft_pass++; }
+static inline void ksft_inc_fail_cnt(void) { ksft_fail++; }
+static inline void ksft_inc_xfail_cnt(void) { ksft_xfail++; }
+static inline void ksft_inc_xpass_cnt(void) { ksft_xpass++; }
+static inline void ksft_inc_xskip_cnt(void) { ksft_xskip++; }
+
+static inline void ksft_print_cnts(void)
+{
+	printf("Pass: %d Fail: %d Xfail: %d Xpass: %d, Xskip: %d\n",
+		ksft_pass, ksft_fail, ksft_xfail, ksft_xpass, ksft_xskip);
+}
+
+static inline int ksft_exit_pass(void) { exit(0); }
+static inline int ksft_exit_fail(void) { exit(1); }
+static inline int ksft_exit_xfail(void) { exit(2); }
+static inline int ksft_exit_xpass(void) { exit(3); }
+static inline int ksft_exit_skip(void) { exit(4); }
+
+#endif /* __KSELFTEST_H */
-- 
1.9.1
