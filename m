From: Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH v3 6/7] selftests/mqueue: Use implicit rules
Date: Wed,  4 Mar 2015 21:41:33 +1100
Message-ID: <1425465694-27095-6-git-send-email-mpe@ellerman.id.au>
References: <1425465694-27095-1-git-send-email-mpe@ellerman.id.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425465694-27095-1-git-send-email-mpe@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
To: shuahkh@osg.samsung.com
Cc: linux-kernel@vger.kernel.org, davej@codemonkey.org.uk, mmarek@suse.cz, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

There's no need to open-code the build rules, use the implicit ones.

This has the nice side effect of enabling cross compilation.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
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
