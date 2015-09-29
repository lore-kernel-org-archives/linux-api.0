From: Wang Long <long.wanglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] kselftest: replace rm -f command with $(RM)
Date: Tue, 29 Sep 2015 11:21:35 +0000
Message-ID: <1443525695-172066-1-git-send-email-long.wanglong@huawei.com>
References: <1443520665.11041.1.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443520665.11041.1.camel-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org
Cc: john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, long.wanglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tyler.baker-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, gkurz-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, sam.bobroff-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.orgwanglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, peifeiyue-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Some test's Makefile using "$(RM)" while the other's
using "rm -f". It is better to use one of them in all
tests.

"$(RM)" is clearly defined as a Makefile implicit variable
which defaults to "rm -f".
Ref. https://www.gnu.org/software/make/manual/html_node/Implicit-Variables.html

Signed-off-by: Wang Long <long.wanglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 tools/testing/selftests/breakpoints/Makefile           | 2 +-
 tools/testing/selftests/efivarfs/Makefile              | 2 +-
 tools/testing/selftests/futex/functional/Makefile      | 2 +-
 tools/testing/selftests/ipc/Makefile                   | 2 +-
 tools/testing/selftests/mount/Makefile                 | 2 +-
 tools/testing/selftests/mqueue/Makefile                | 2 +-
 tools/testing/selftests/powerpc/Makefile               | 2 +-
 tools/testing/selftests/powerpc/copyloops/Makefile     | 2 +-
 tools/testing/selftests/powerpc/dscr/Makefile          | 2 +-
 tools/testing/selftests/powerpc/mm/Makefile            | 2 +-
 tools/testing/selftests/powerpc/pmu/Makefile           | 2 +-
 tools/testing/selftests/powerpc/pmu/ebb/Makefile       | 2 +-
 tools/testing/selftests/powerpc/primitives/Makefile    | 2 +-
 tools/testing/selftests/powerpc/stringloops/Makefile   | 2 +-
 tools/testing/selftests/powerpc/switch_endian/Makefile | 2 +-
 tools/testing/selftests/powerpc/tm/Makefile            | 2 +-
 tools/testing/selftests/powerpc/vphn/Makefile          | 2 +-
 tools/testing/selftests/ptrace/Makefile                | 2 +-
 tools/testing/selftests/timers/Makefile                | 2 +-
 19 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/breakpoints/Makefile b/tools/testing/selftests/breakpoints/Makefile
index d27108b..731bd31 100644
--- a/tools/testing/selftests/breakpoints/Makefile
+++ b/tools/testing/selftests/breakpoints/Makefile
@@ -11,4 +11,4 @@ all:
 include ../lib.mk
 
 clean:
-	rm -fr breakpoint_test
+	$(RM) breakpoint_test
diff --git a/tools/testing/selftests/efivarfs/Makefile b/tools/testing/selftests/efivarfs/Makefile
index 736c3dd..4a1c629 100644
--- a/tools/testing/selftests/efivarfs/Makefile
+++ b/tools/testing/selftests/efivarfs/Makefile
@@ -10,4 +10,4 @@ TEST_FILES := $(test_objs)
 include ../lib.mk
 
 clean:
-	rm -f $(test_objs)
+	$(RM) $(test_objs)
diff --git a/tools/testing/selftests/futex/functional/Makefile b/tools/testing/selftests/futex/functional/Makefile
index 9d6b75e..391d328 100644
--- a/tools/testing/selftests/futex/functional/Makefile
+++ b/tools/testing/selftests/futex/functional/Makefile
@@ -22,4 +22,4 @@ $(TARGETS): $(HEADERS)
 include ../../lib.mk
 
 clean:
-	rm -f $(TARGETS)
+	$(RM) $(TARGETS)
diff --git a/tools/testing/selftests/ipc/Makefile b/tools/testing/selftests/ipc/Makefile
index 25d2e70..071a706 100644
--- a/tools/testing/selftests/ipc/Makefile
+++ b/tools/testing/selftests/ipc/Makefile
@@ -19,4 +19,4 @@ TEST_PROGS := msgque_test
 include ../lib.mk
 
 clean:
-	rm -fr ./msgque_test
+	$(RM) ./msgque_test
diff --git a/tools/testing/selftests/mount/Makefile b/tools/testing/selftests/mount/Makefile
index 5e35c9c..9629382 100644
--- a/tools/testing/selftests/mount/Makefile
+++ b/tools/testing/selftests/mount/Makefile
@@ -18,4 +18,4 @@ override RUN_TESTS := if [ -f /proc/self/uid_map ] ; \
 override EMIT_TESTS := echo "$(RUN_TESTS)"
 
 clean:
-	rm -f unprivileged-remount-test
+	$(RM) unprivileged-remount-test
diff --git a/tools/testing/selftests/mqueue/Makefile b/tools/testing/selftests/mqueue/Makefile
index eebac29..d61b987 100644
--- a/tools/testing/selftests/mqueue/Makefile
+++ b/tools/testing/selftests/mqueue/Makefile
@@ -17,4 +17,4 @@ override define EMIT_TESTS
 endef
 
 clean:
-	rm -f mq_open_tests mq_perf_tests
+	$(RM) mq_open_tests mq_perf_tests
diff --git a/tools/testing/selftests/powerpc/Makefile b/tools/testing/selftests/powerpc/Makefile
index 03ca2e6..91aa06d 100644
--- a/tools/testing/selftests/powerpc/Makefile
+++ b/tools/testing/selftests/powerpc/Makefile
@@ -45,7 +45,7 @@ clean:
 	@for TARGET in $(SUB_DIRS); do \
 		$(MAKE) -C $$TARGET clean; \
 	done;
-	rm -f tags
+	$(RM) tags
 
 tags:
 	find . -name '*.c' -o -name '*.h' | xargs ctags
diff --git a/tools/testing/selftests/powerpc/copyloops/Makefile b/tools/testing/selftests/powerpc/copyloops/Makefile
index 384843e..28d6d6c 100644
--- a/tools/testing/selftests/powerpc/copyloops/Makefile
+++ b/tools/testing/selftests/powerpc/copyloops/Makefile
@@ -22,4 +22,4 @@ $(TEST_PROGS): $(EXTRA_SOURCES)
 include ../../lib.mk
 
 clean:
-	rm -f $(TEST_PROGS) *.o
+	$(RM) $(TEST_PROGS) *.o
diff --git a/tools/testing/selftests/powerpc/dscr/Makefile b/tools/testing/selftests/powerpc/dscr/Makefile
index 49327ee..d32a66e 100644
--- a/tools/testing/selftests/powerpc/dscr/Makefile
+++ b/tools/testing/selftests/powerpc/dscr/Makefile
@@ -11,4 +11,4 @@ $(TEST_PROGS): ../harness.c
 include ../../lib.mk
 
 clean:
-	rm -f $(TEST_PROGS) *.o
+	$(RM) $(TEST_PROGS) *.o
diff --git a/tools/testing/selftests/powerpc/mm/Makefile b/tools/testing/selftests/powerpc/mm/Makefile
index ee179e2..7f63469 100644
--- a/tools/testing/selftests/powerpc/mm/Makefile
+++ b/tools/testing/selftests/powerpc/mm/Makefile
@@ -14,4 +14,4 @@ tempfile:
 	dd if=/dev/zero of=tempfile bs=64k count=1
 
 clean:
-	rm -f $(TEST_PROGS) tempfile
+	$(RM) $(TEST_PROGS) tempfile
diff --git a/tools/testing/selftests/powerpc/pmu/Makefile b/tools/testing/selftests/powerpc/pmu/Makefile
index a9099d9..170f3a6 100644
--- a/tools/testing/selftests/powerpc/pmu/Makefile
+++ b/tools/testing/selftests/powerpc/pmu/Makefile
@@ -33,7 +33,7 @@ override define INSTALL_RULE
 endef
 
 clean:
-	rm -f $(TEST_PROGS) loop.o
+	$(RM) $(TEST_PROGS) loop.o
 	$(MAKE) -C ebb clean
 
 ebb:
diff --git a/tools/testing/selftests/powerpc/pmu/ebb/Makefile b/tools/testing/selftests/powerpc/pmu/ebb/Makefile
index 5cdc9db..977875f 100644
--- a/tools/testing/selftests/powerpc/pmu/ebb/Makefile
+++ b/tools/testing/selftests/powerpc/pmu/ebb/Makefile
@@ -27,4 +27,4 @@ lost_exception_test: ../lib.c
 include ../../../lib.mk
 
 clean:
-	rm -f $(TEST_PROGS)
+	$(RM) $(TEST_PROGS)
diff --git a/tools/testing/selftests/powerpc/primitives/Makefile b/tools/testing/selftests/powerpc/primitives/Makefile
index b68c622..2261bd1 100644
--- a/tools/testing/selftests/powerpc/primitives/Makefile
+++ b/tools/testing/selftests/powerpc/primitives/Makefile
@@ -9,4 +9,4 @@ $(TEST_PROGS): ../harness.c
 include ../../lib.mk
 
 clean:
-	rm -f $(TEST_PROGS) *.o
+	$(RM) $(TEST_PROGS) *.o
diff --git a/tools/testing/selftests/powerpc/stringloops/Makefile b/tools/testing/selftests/powerpc/stringloops/Makefile
index 2a728f4..ea89afd 100644
--- a/tools/testing/selftests/powerpc/stringloops/Makefile
+++ b/tools/testing/selftests/powerpc/stringloops/Makefile
@@ -12,4 +12,4 @@ $(TEST_PROGS): $(EXTRA_SOURCES)
 include ../../lib.mk
 
 clean:
-	rm -f $(TEST_PROGS) *.o
+	$(RM) $(TEST_PROGS) *.o
diff --git a/tools/testing/selftests/powerpc/switch_endian/Makefile b/tools/testing/selftests/powerpc/switch_endian/Makefile
index e21d106..6cfe0f0 100644
--- a/tools/testing/selftests/powerpc/switch_endian/Makefile
+++ b/tools/testing/selftests/powerpc/switch_endian/Makefile
@@ -15,4 +15,4 @@ check-reversed.S: check-reversed.o
 include ../../lib.mk
 
 clean:
-	rm -f $(TEST_PROGS) *.o check-reversed.S
+	$(RM) $(TEST_PROGS) *.o check-reversed.S
diff --git a/tools/testing/selftests/powerpc/tm/Makefile b/tools/testing/selftests/powerpc/tm/Makefile
index 4bea62a..f04bd4b 100644
--- a/tools/testing/selftests/powerpc/tm/Makefile
+++ b/tools/testing/selftests/powerpc/tm/Makefile
@@ -10,4 +10,4 @@ tm-syscall: CFLAGS += -mhtm -I../../../../../usr/include
 include ../../lib.mk
 
 clean:
-	rm -f $(TEST_PROGS) *.o
+	$(RM) $(TEST_PROGS) *.o
diff --git a/tools/testing/selftests/powerpc/vphn/Makefile b/tools/testing/selftests/powerpc/vphn/Makefile
index a485f2e..d98f32c 100644
--- a/tools/testing/selftests/powerpc/vphn/Makefile
+++ b/tools/testing/selftests/powerpc/vphn/Makefile
@@ -9,4 +9,4 @@ $(TEST_PROGS): ../harness.c
 include ../../lib.mk
 
 clean:
-	rm -f $(TEST_PROGS)
+	$(RM) $(TEST_PROGS)
diff --git a/tools/testing/selftests/ptrace/Makefile b/tools/testing/selftests/ptrace/Makefile
index 453927f..ec5bf58 100644
--- a/tools/testing/selftests/ptrace/Makefile
+++ b/tools/testing/selftests/ptrace/Makefile
@@ -4,7 +4,7 @@ peeksiginfo: peeksiginfo.c
 all: peeksiginfo
 
 clean:
-	rm -f peeksiginfo
+	$(RM) peeksiginfo
 
 TEST_PROGS := peeksiginfo
 
diff --git a/tools/testing/selftests/timers/Makefile b/tools/testing/selftests/timers/Makefile
index 89a3f44..a5889e2 100644
--- a/tools/testing/selftests/timers/Makefile
+++ b/tools/testing/selftests/timers/Makefile
@@ -33,4 +33,4 @@ run_destructive_tests: run_tests
 	./set-2038
 
 clean:
-	rm -f ${bins}
+	$(RM) ${bins}
-- 
1.8.3.4
