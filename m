From: Darren Hart <dvhart@linux.intel.com>
Subject: [PATCH 3/5] selftest/futex: Increment ksft pass and fail counters
Date: Fri,  8 May 2015 15:09:45 -0700
Message-ID: <be4c2890d500b53609073052926fbf8c89905f4c.1431121818.git.dvhart@linux.intel.com>
References: <57d921b1c30e8258ca4b2f55637424527317e92f.1431121818.git.dvhart@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <57d921b1c30e8258ca4b2f55637424527317e92f.1431121818.git.dvhart@linux.intel.com>
In-Reply-To: <cover.1431121818.git.dvhart@linux.intel.com>
References: <cover.1431121818.git.dvhart@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>, Shuah Khan <shuahkh@osg.samsung.com>, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Davidlohr Bueso <dave@stgolabs.net>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
List-Id: linux-api@vger.kernel.org

Add kselftest.h to logging.h and increment the pass and fail counters as
part of the print_result routine which is called by all futex tests.

Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-api@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Darren Hart <dvhart@linux.intel.com>
---
 tools/testing/selftests/futex/functional/Makefile | 2 +-
 tools/testing/selftests/futex/include/logging.h   | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/futex/functional/Makefile b/tools/testing/selftests/futex/functional/Makefile
index fb96927..e64d43b 100644
--- a/tools/testing/selftests/futex/functional/Makefile
+++ b/tools/testing/selftests/futex/functional/Makefile
@@ -1,4 +1,4 @@
-INCLUDES := -I../include
+INCLUDES := -I../include -I../../
 CFLAGS := $(CFLAGS) -g -O2 -Wall -D_GNU_SOURCE $(INCLUDES)
 LDFLAGS := $(LDFLAGS) -lpthread -lrt
 
diff --git a/tools/testing/selftests/futex/include/logging.h b/tools/testing/selftests/futex/include/logging.h
index f6ed5c2..014aa01 100644
--- a/tools/testing/selftests/futex/include/logging.h
+++ b/tools/testing/selftests/futex/include/logging.h
@@ -24,6 +24,7 @@
 #include <string.h>
 #include <unistd.h>
 #include <linux/futex.h>
+#include "kselftest.h"
 
 /*
  * Define PASS, ERROR, and FAIL strings with and without color escape
@@ -111,12 +112,14 @@ void print_result(int ret)
 
 	switch (ret) {
 	case RET_PASS:
+		ksft_inc_pass_cnt();
 		result = PASS;
 		break;
 	case RET_ERROR:
 		result = ERROR;
 		break;
 	case RET_FAIL:
+		ksft_inc_fail_cnt();
 		result = FAIL;
 		break;
 	}
-- 
2.1.4
