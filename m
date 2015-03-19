From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: [PATCH v2] selftests/timers: Use shared logic to run and install tests
Date: Thu, 19 Mar 2015 11:20:40 +1100
Message-ID: <1426724440-12439-1-git-send-email-mpe@ellerman.id.au>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Change the timers Makefile to make use of shared run and install logic
in lib.mk. Destructive tests are installed but not run by default.

Add a new variable, TEST_PROGS_EXTENDED, which is a list of extra
programs to install, but which are not run by the default run_tests
logic.

Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
---

v2: Add and use TEST_PROGS_EXTENDED.
    Just use the standard run_tests/install/emit_tests, this relies on the
    patch from John to change the defaults for threadtest.

 tools/testing/selftests/lib.mk          |  2 +-
 tools/testing/selftests/timers/Makefile | 27 ++++++++++++---------------
 2 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 7bd3dabe2846..0baf7d32a67d 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -9,7 +9,7 @@ run_tests: all
 
 define INSTALL_RULE
 	mkdir -p $(INSTALL_PATH)
-	install -t $(INSTALL_PATH) $(TEST_PROGS) $(TEST_FILES)
+	install -t $(INSTALL_PATH) $(TEST_PROGS) $(TEST_PROGS_EXTENDED) $(TEST_FILES)
 endef
 
 install: all
diff --git a/tools/testing/selftests/timers/Makefile b/tools/testing/selftests/timers/Makefile
index 9da3498987c8..670aebdb4a99 100644
--- a/tools/testing/selftests/timers/Makefile
+++ b/tools/testing/selftests/timers/Makefile
@@ -2,24 +2,21 @@ CC = $(CROSS_COMPILE)gcc
 BUILD_FLAGS = -DKTEST
 CFLAGS += -O3 -Wl,-no-as-needed -Wall $(BUILD_FLAGS)
 LDFLAGS += -lrt -lpthread
-bins = posix_timers nanosleep inconsistency-check nsleep-lat raw_skew \
-	set-timer-lat threadtest mqueue-lat valid-adjtimex \
-	alarmtimer-suspend change_skew skew_consistency clocksource-switch \
-	leap-a-day leapcrash set-tai set-2038
-
-all: ${bins}
 
 # these are all "safe" tests that don't modify
 # system time or require escalated privledges
-run_tests: all
-	./posix_timers
-	./nanosleep
-	./nsleep-lat
-	./set-timer-lat
-	./mqueue-lat
-	./inconsistency-check
-	./raw_skew
-	./threadtest -t 30 -n 8
+TEST_PROGS = posix_timers nanosleep nsleep-lat set-timer-lat mqueue-lat \
+	     inconsistency-check raw_skew threadtest
+
+TEST_PROGS_EXTENDED = alarmtimer-suspend valid-adjtimex change_skew \
+		      skew_consistency clocksource-switch leap-a-day \
+		      leapcrash set-tai set-2038
+
+bins = $(TEST_PROGS) $(TEST_PROGS_EXTENDED)
+
+all: ${bins}
+
+include ../lib.mk
 
 # these tests require escalated privledges
 # and may modify the system time or trigger
-- 
2.1.0
