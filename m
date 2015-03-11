From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: [PATCH v4 8/9] selftests/mqueue: Use implicit rules
Date: Wed, 11 Mar 2015 15:06:04 +1100
Message-ID: <1426046765-19289-8-git-send-email-mpe@ellerman.id.au>
References: <1426046765-19289-1-git-send-email-mpe@ellerman.id.au>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426046765-19289-1-git-send-email-mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org, mmarek-AlSwsSmVLrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

There's no need to open-code the build rules, use the implicit ones.

This has the nice side effect of enabling cross compilation.

Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
---
 tools/testing/selftests/mqueue/Makefile | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/mqueue/Makefile b/tools/testing/selftests/mqueue/Makefile
index 6ca7261b55dc..ed85a1d7ee36 100644
--- a/tools/testing/selftests/mqueue/Makefile
+++ b/tools/testing/selftests/mqueue/Makefile
@@ -1,6 +1,11 @@
-all:
-	gcc -O2 mq_open_tests.c -o mq_open_tests -lrt
-	gcc -O2 -o mq_perf_tests mq_perf_tests.c -lrt -lpthread -lpopt
+TEST_PROGS := mq_open_tests mq_perf_tests
+
+CFLAGS += -O2
+LDLIBS += -lrt
+
+mq_perf_tests: LDLIBS += -lpthread -lpopt
+
+all: $(TEST_PROGS)
 
 include ../lib.mk
 
@@ -9,12 +14,10 @@ override define RUN_TESTS
 	@./mq_perf_tests || echo "selftests: mq_perf_tests [FAIL]"
 endef
 
-TEST_PROGS := mq_open_tests mq_perf_tests
-
 override define EMIT_TESTS
 	echo "./mq_open_tests /test1 || echo \"selftests: mq_open_tests [FAIL]\""
 	echo "./mq_perf_tests || echo \"selftests: mq_perf_tests [FAIL]\""
 endef
 
 clean:
-	rm -f mq_open_tests mq_perf_tests
+	rm -f $(TEST_PROGS)
-- 
2.1.0
