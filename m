From: Darren Hart <dvhart@linux.intel.com>
Subject: [PATCH 2/5] selftest/futex: Update Makefile to use lib.mk
Date: Fri, 27 Mar 2015 15:17:42 -0700
Message-ID: <95d599bc531666252f8e3f4e467d5f94af2a7ad2.1427493640.git.dvhart@linux.intel.com>
References: <597c9eabcac5da9456d6cfd6de9117591d73385e.1427493640.git.dvhart@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <597c9eabcac5da9456d6cfd6de9117591d73385e.1427493640.git.dvhart@linux.intel.com>
In-Reply-To: <cover.1427493640.git.dvhart@linux.intel.com>
References: <cover.1427493640.git.dvhart@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>, Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Davidlohr Bueso <dave@stgolabs.net>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
List-Id: linux-api@vger.kernel.org

Adapt the futextest Makefiles to use lib.mk macros for RUN_TESTS and
EMIT_TESTS. For now, we reuse the run.sh mechanism provided by
futextest. This doesn't provide the standard selftests: [PASS|FAIL]
format, but the tests provide very similar output already.

This results in the run_kselftest.sh script for futexes including a
single line: ./run.sh

Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-api@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Darren Hart <dvhart@linux.intel.com>
---
 tools/testing/selftests/futex/Makefile            | 21 +++++++++++++++++++++
 tools/testing/selftests/futex/functional/Makefile |  4 ++++
 2 files changed, 25 insertions(+)

diff --git a/tools/testing/selftests/futex/Makefile b/tools/testing/selftests/futex/Makefile
index 8629187..6a17529 100644
--- a/tools/testing/selftests/futex/Makefile
+++ b/tools/testing/selftests/futex/Makefile
@@ -1,8 +1,29 @@
 SUBDIRS := functional
 
+TEST_PROGS := run.sh
+
 .PHONY: all clean
 all:
 	for DIR in $(SUBDIRS); do $(MAKE) -C $$DIR $@ ; done
 
+include ../lib.mk
+
+override define RUN_TESTS
+	./run.sh
+endef
+
+override define INSTALL_RULE
+	mkdir -p $(INSTALL_PATH)
+	install -t $(INSTALL_PATH) $(TEST_PROGS) $(TEST_PROGS_EXTENDED) $(TEST_FILES)
+
+	@for SUBDIR in $(SUBDIRS); do \
+		$(MAKE) -C $$SUBDIR INSTALL_PATH=$(INSTALL_PATH)/$$SUBDIR install; \
+	done;
+endef
+
+override define EMIT_TESTS
+	echo "./run.sh"
+endef
+
 clean:
 	for DIR in $(SUBDIRS); do $(MAKE) -C $$DIR $@ ; done
diff --git a/tools/testing/selftests/futex/functional/Makefile b/tools/testing/selftests/futex/functional/Makefile
index 6ecb42c..fb96927 100644
--- a/tools/testing/selftests/futex/functional/Makefile
+++ b/tools/testing/selftests/futex/functional/Makefile
@@ -12,10 +12,14 @@ TARGETS := \
 	futex_wait_uninitialized_heap \
 	futex_wait_private_mapped_file
 
+TEST_PROGS := $(TARGETS) run.sh
+
 .PHONY: all clean
 all: $(TARGETS)
 
 $(TARGETS): $(HEADERS)
 
+include ../../lib.mk
+
 clean:
 	rm -f $(TARGETS)
-- 
2.1.4
