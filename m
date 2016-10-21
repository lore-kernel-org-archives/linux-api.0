From: <bamvor.zhangjian@huawei.com>
Subject: [PATCH RFC 2/6] selftests: remove useless TEST_DIRS
Date: Fri, 21 Oct 2016 19:01:30 +0800
Message-ID: <1477047694-24122-3-git-send-email-bamvor.zhangjian@huawei.com>
References: <1477047694-24122-1-git-send-email-bamvor.zhangjian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1477047694-24122-1-git-send-email-bamvor.zhangjian@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: shuahkh@osg.samsung.com
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, khilman@linaro.org, broonie@kernel.org, mpe@ellerman.id.au
List-Id: linux-api@vger.kernel.org

From: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>

The TEST_DIRS was introduced in Commit e8c1d7cdf137 ("selftests: copy
TEST_DIRS to INSTALL_PATH") for coping a whole directory in ftrace.

After rsync(with -a) is introduced by Commit 900d65ee11aa ("selftests:
change install command to rsync"). Rsync could handle the directory
without the definition of TEST_DIRS.

This patch simply replace TEST_DIRS with TEST_FILES in ftrace and remove
the TEST_DIRS in tools/testing/selftest/lib.mk

Signed-off-by: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
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
index 12edfb1f..8c0440d 100644
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
1.8.4.5
