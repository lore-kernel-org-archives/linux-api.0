From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH v2] selftests: Fix build failures when invoked from kselftest target
Date: Wed, 18 Mar 2015 12:05:42 -0600
Message-ID: <1426701942-25217-1-git-send-email-shuahkh@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

Several tests that rely on implicit build rules fail to build,
when invoked from the main Makefile kselftest target. These
failures are due to --no-builtin-rules and --no-builtin-variables
options set in the inherited MAKEFLAGS.

--no-builtin-rules eliminates the use of built-in implicit rules
and --no-builtin-variables is for not defining built-in variables.
These two options override the use of implicit rules resulting in
build failures. In addition, inherited LDFLAGS result in build
failures and there is no need to define LDFLAGS.  Clear LDFLAGS
and MAKEFLAG when make is invoked from the main Makefile kselftest
target. Fixing this at selftests Makefile avoids changing the main
Makefile and keeps this change self contained at selftests level.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 tools/testing/selftests/Makefile | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 4e51122..0db5713 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -22,6 +22,14 @@ TARGETS += vm
 TARGETS_HOTPLUG = cpu-hotplug
 TARGETS_HOTPLUG += memory-hotplug
 
+# Clear LDFLAGS and MAKEFLAGS if called from main
+# Makefile to avoid test build failures when test
+# Makefile doesn't have explicit build rules.
+ifeq (1,$(MAKELEVEL))
+undefine LDFLAGS
+override MAKEFLAGS =
+endif
+
 all:
 	for TARGET in $(TARGETS); do \
 		make -C $$TARGET; \
-- 
2.1.0
