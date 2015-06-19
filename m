From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH] selftests: add quicktest support
Date: Fri, 19 Jun 2015 13:55:09 -0600
Message-ID: <1434743709-7146-1-git-send-email-shuahkh@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

Add quicktest support to enable users to choose to run
tests that complete in a short time. Choosing this option
excludes tests that take longer time complete e.g: timers.
User can specify quicktest option from kernel top level or
selftests directory.

Kernel top level directory:
make quicktest=1 kselftest

tools/testing/selftests directory:
make quicktest=1 run_tests

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 tools/testing/selftests/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 7474b7d9..24ae9e8 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -16,11 +16,15 @@ TARGETS += ptrace
 TARGETS += seccomp
 TARGETS += size
 TARGETS += sysctl
+ifneq (1, $(quicktest))
 TARGETS += timers
+endif
 TARGETS += user
 TARGETS += vm
 TARGETS += x86
 #Please keep the TARGETS list alphabetically sorted
+# Run "make quicktest=1 run_tests" or
+# "make quicktest=1 kselftest from top level Makefile
 
 TARGETS_HOTPLUG = cpu-hotplug
 TARGETS_HOTPLUG += memory-hotplug
-- 
2.1.4
