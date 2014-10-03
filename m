From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH v3 1/5] selftests: add kselftest framework for uniform test reporting
Date: Fri,  3 Oct 2014 09:36:16 -0600
Message-ID: <36720c03ad446262f3248be600a66035b9b8555b.1412349412.git.shuahkh@osg.samsung.com>
References: <cover.1412349412.git.shuahkh@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1412349412.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
In-Reply-To: <cover.1412349412.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
References: <cover.1412349412.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, dbueso-l3A5Bk7waGM@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org
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
 tools/testing/selftests/kselftest.h | 62 +++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)
 create mode 100644 tools/testing/selftests/kselftest.h

diff --git a/tools/testing/selftests/kselftest.h b/tools/testing/selftests/kselftest.h
new file mode 100644
index 0000000..572c888
--- /dev/null
+++ b/tools/testing/selftests/kselftest.h
@@ -0,0 +1,62 @@
+/*
+ * kselftest.h:	kselftest framework return codes to include from
+ *		selftests.
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
+struct ksft_count {
+	unsigned int ksft_pass;
+	unsigned int ksft_fail;
+	unsigned int ksft_xfail;
+	unsigned int ksft_xpass;
+	unsigned int ksft_xskip;
+};
+
+static struct ksft_count ksft_cnt;
+
+static inline void ksft_inc_pass_cnt(void) { ksft_cnt.ksft_pass++; }
+static inline void ksft_inc_fail_cnt(void) { ksft_cnt.ksft_fail++; }
+static inline void ksft_inc_xfail_cnt(void) { ksft_cnt.ksft_xfail++; }
+static inline void ksft_inc_xpass_cnt(void) { ksft_cnt.ksft_xpass++; }
+static inline void ksft_inc_xskip_cnt(void) { ksft_cnt.ksft_xskip++; }
+
+static inline void ksft_print_cnts(void)
+{
+	printf("Pass: %d Fail: %d Xfail: %d Xpass: %d, Xskip: %d\n",
+		ksft_cnt.ksft_pass, ksft_cnt.ksft_fail,
+		ksft_cnt.ksft_xfail, ksft_cnt.ksft_xpass,
+		ksft_cnt.ksft_xskip);
+}
+
+static inline int ksft_exit_pass(void)
+{
+	exit(0);
+}
+static inline int ksft_exit_fail(void)
+{
+	exit(1);
+}
+static inline int ksft_exit_xfail(void)
+{
+	exit(2);
+}
+static inline int ksft_exit_xpass(void)
+{
+	exit(3);
+}
+static inline int ksft_exit_skip(void)
+{
+	exit(4);
+}
+
+#endif /* __KSELFTEST_H */
-- 
1.9.1
