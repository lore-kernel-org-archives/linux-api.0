From: <bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 2/6] selftests: remove useless TEST_DIRS
Date: Tue, 29 Nov 2016 19:55:48 +0800
Message-ID: <20161129115552.8148-3-bamvor.zhangjian@huawei.com>
References: <20161129115552.8148-1-bamvor.zhangjian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161129115552.8148-1-bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, khilman-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

The TEST_DIRS was introduced in Commit e8c1d7cdf137 ("selftests: copy
TEST_DIRS to INSTALL_PATH") for coping a whole directory in ftrace.

After rsync(with -a) is introduced by Commit 900d65ee11aa ("selftests:
change install command to rsync"). Rsync could handle the directory
without the definition of TEST_DIRS.

This patch simply replace TEST_DIRS with TEST_FILES in ftrace and remove
the TEST_DIRS in tools/testing/selftest/lib.mk

Acked-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Signed-off-by: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 tools/testing/selftests/ftrace/Makefile | 2 +-
 tools/testing/selftests/lib.mk          | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/ftrace/Makefile b/tools/testing/selftests/ftrace/Makefile
index 4e6ed13..a715300 100644
--- a/tools/testing/selftests/ftrace/Makefile
+++ b/tools/testing/selftests/ftrace/Makefile
@@ -1,7 +1,7 @@
 all:
 
 TEST_PROGS := ftracetest
-TEST_DIRS := test.d
+TEST_FILES := test.d
 
 include ../lib.mk
 
diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 9fddffd..5b8634c 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -14,8 +14,8 @@ run_tests: all
 define INSTALL_RULE
 	@if [ "X$(TEST_PROGS)$(TEST_PROGS_EXTENDED)$(TEST_FILES)" != "X" ]; then					\
 		mkdir -p ${INSTALL_PATH};										\
-		echo "rsync -a $(TEST_DIRS) $(TEST_PROGS) $(TEST_PROGS_EXTENDED) $(TEST_FILES) $(INSTALL_PATH)/";       \
-		rsync -a $(TEST_DIRS) $(TEST_PROGS) $(TEST_PROGS_EXTENDED) $(TEST_FILES) $(INSTALL_PATH)/;              \
+		echo "rsync -a $(TEST_PROGS) $(TEST_PROGS_EXTENDED) $(TEST_FILES) $(INSTALL_PATH)/";	\
+		rsync -a $(TEST_PROGS) $(TEST_PROGS_EXTENDED) $(TEST_FILES) $(INSTALL_PATH)/;		\
 	fi
 	@if [ "X$(TEST_GEN_PROGS)$(TEST_GEN_PROGS_EXTENDED)$(TEST_GEN_FILES)" != "X" ]; then					\
 		mkdir -p ${INSTALL_PATH};										\
-- 
2.10.0
