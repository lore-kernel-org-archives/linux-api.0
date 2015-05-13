From: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 2/6] selftests/futex: Update Makefile to use lib.mk
Date: Tue, 12 May 2015 21:07:53 -0700
Message-ID: <1ef53157f7fd8fbae3b3c549c517cc3ae29d2bf0.1431489408.git.dvhart@linux.intel.com>
References: <077301628833a25c85ee597cd8f4b8fcc3f30714.1431489408.git.dvhart@linux.intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <077301628833a25c85ee597cd8f4b8fcc3f30714.1431489408.git.dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
In-Reply-To: <cover.1431489408.git.dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
References: <cover.1431489408.git.dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: chrubis-AlSwsSmVLrQ@public.gmane.org, Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Adapt the futextest Makefiles to use lib.mk macros for RUN_TESTS and
EMIT_TESTS. For now, we reuse the run.sh mechanism provided by
futextest. This doesn't provide the standard selftests: [PASS|FAIL]
format, but the tests provide very similar output already.

This results in the run_kselftest.sh script for futexes including a
single line: ./run.sh

Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Cc: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Signed-off-by: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 tools/testing/selftests/futex/Makefile            | 20 +++++++++++++++++++-
 tools/testing/selftests/futex/functional/Makefile |  5 +++--
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/futex/Makefile b/tools/testing/selftests/futex/Makefile
index 2c26d59..6a17529 100644
--- a/tools/testing/selftests/futex/Makefile
+++ b/tools/testing/selftests/futex/Makefile
@@ -1,11 +1,29 @@
 SUBDIRS := functional
 
+TEST_PROGS := run.sh
+
 .PHONY: all clean
 all:
 	for DIR in $(SUBDIRS); do $(MAKE) -C $$DIR $@ ; done
 
-run_tests: all
+include ../lib.mk
+
+override define RUN_TESTS
 	./run.sh
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
 
 clean:
 	for DIR in $(SUBDIRS); do $(MAKE) -C $$DIR $@ ; done
diff --git a/tools/testing/selftests/futex/functional/Makefile b/tools/testing/selftests/futex/functional/Makefile
index 720023e..4b018fe 100644
--- a/tools/testing/selftests/futex/functional/Makefile
+++ b/tools/testing/selftests/futex/functional/Makefile
@@ -12,13 +12,14 @@ TARGETS := \
 	futex_wait_uninitialized_heap \
 	futex_wait_private_mapped_file
 
+TEST_PROGS := $(TARGETS) run.sh
+
 .PHONY: all clean
 all: $(TARGETS)
 
 $(TARGETS): $(HEADERS)
 
-run_tests: all
-	./run.sh
+include ../../lib.mk
 
 clean:
 	rm -f $(TARGETS)
-- 
2.1.4
