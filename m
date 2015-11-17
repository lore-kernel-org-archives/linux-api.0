From: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH V2 1/3] selftests/capabilities: clean up for Makefile
Date: Tue, 17 Nov 2015 22:35:41 +0800
Message-ID: <1447770943-10059-2-git-send-email-bamvor.zhangjian@linaro.org>
References: <1447770943-10059-1-git-send-email-bamvor.zhangjian@linaro.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447770943-10059-1-git-send-email-bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tyler.baker-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Clean up the following things:
1.  Avoid the broken when use TARGETS in the command line, eg:

 $ make -C tools/testing/selftests TARGETS=capabilities
 make[1]: *** No rule to make target 'capabilities', needed by 'all'.  Stop.

    Replace TARGETS with BINARIES.

2.  User need to provide cap-ng.h and libcap-ng.so for cross compiling.
    Replace ':=' with '+=' for CFLAGS and introduce LDLIBS to archieve
    it. Delete useless EXTRA_CLAGS at the same time.

3.  Delete the duplicated definition which is already defined by
    lib.mk.

Suggested-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Signed-off-by: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 tools/testing/selftests/capabilities/Makefile | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/capabilities/Makefile b/tools/testing/selftests/capabilities/Makefile
index 8c8f0c1..008602a 100644
--- a/tools/testing/selftests/capabilities/Makefile
+++ b/tools/testing/selftests/capabilities/Makefile
@@ -1,18 +1,15 @@
-all:
-
-include ../lib.mk
-
-.PHONY: all clean
-
-TARGETS := validate_cap test_execve
+TEST_FILES := validate_cap
 TEST_PROGS := test_execve
 
-CFLAGS := -O2 -g -std=gnu99 -Wall -lcap-ng
+BINARIES := $(TEST_FILES) $(TEST_PROGS)
 
-all: $(TARGETS)
+CFLAGS += -O2 -g -std=gnu99 -Wall
+LDLIBS += -lcap-ng -lrt -ldl
+
+all: $(BINARIES)
 
 clean:
-	$(RM) $(TARGETS)
+	$(RM) $(BINARIES)
+
+include ../lib.mk
 
-$(TARGETS): %: %.c
-	$(CC) -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl
-- 
1.8.4.5
