From: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/3] selftests/capabilities: align the usage of CFLAGS with others
Date: Sat, 14 Nov 2015 14:01:52 +0800
Message-ID: <1447480914-14834-2-git-send-email-bamvor.zhangjian@linaro.org>
References: <1447480914-14834-1-git-send-email-bamvor.zhangjian@linaro.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447480914-14834-1-git-send-email-bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tyler.baker-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

User need to provide cap-ng.h and libcap-ng.so for cross compiling
which could be done by pass extra cflags to EXTRA_CLAGS. But other
testcases pass CFLAGS instead.

Change CLAGS ':=' to CLAGS '+=' to align with others. Delete useless
EXTRA_CLAGS at the same time.

Signed-off-by: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 tools/testing/selftests/capabilities/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/capabilities/Makefile b/tools/testing/selftests/capabilities/Makefile
index 8c8f0c1..47337fb 100644
--- a/tools/testing/selftests/capabilities/Makefile
+++ b/tools/testing/selftests/capabilities/Makefile
@@ -7,7 +7,7 @@ include ../lib.mk
 TARGETS := validate_cap test_execve
 TEST_PROGS := test_execve
 
-CFLAGS := -O2 -g -std=gnu99 -Wall -lcap-ng
+CFLAGS += -O2 -g -std=gnu99 -Wall -lcap-ng
 
 all: $(TARGETS)
 
@@ -15,4 +15,4 @@ clean:
 	$(RM) $(TARGETS)
 
 $(TARGETS): %: %.c
-	$(CC) -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl
+	$(CC) -o $@ $(CFLAGS) $^ -lrt -ldl
-- 
2.1.4
