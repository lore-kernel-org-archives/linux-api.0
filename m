From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH 3/3] selftests: kcmp build fails when invoked from kselftest target
Date: Tue, 10 Mar 2015 16:00:59 -0600
Message-ID: <80f321919d8d1f804c4933acac9b044d4c6626eb.1426022048.git.shuahkh@osg.samsung.com>
References: <cover.1426022048.git.shuahkh@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1426022048.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1426022048.git.shuahkh@osg.samsung.com>
References: <cover.1426022048.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gorcunov@openvz.org, akpm@linux-foundation.org, tranmanphong@gmail.com, mpe@ellerman.id.au
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

kcmp Makefile doesn't have an explicit build rule. As a result,
kcmp build fails, when it is run from top level Makefile target
kselftest. Without the explicit rule, make works only when it is
run in the current directory or from selftests directory. Add an
explicit build rule to fix the problem. In addition, build fails
as it can't find kcmp.h. Fix it by passing CFLAGS.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 tools/testing/selftests/kcmp/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kcmp/Makefile b/tools/testing/selftests/kcmp/Makefile
index ff0eefd..83383eb 100644
--- a/tools/testing/selftests/kcmp/Makefile
+++ b/tools/testing/selftests/kcmp/Makefile
@@ -1,7 +1,8 @@
 CC := $(CROSS_COMPILE)$(CC)
-CFLAGS += -I../../../../usr/include/
+CFLAGS += -I../../../../include/uapi -I../../../../usr/include/
 
-all: kcmp_test
+all:
+	$(CC) $(CFLAGS) kcmp_test.c -o kcmp_test
 
 run_tests: all
 	@./kcmp_test || echo "kcmp_test: [FAIL]"
-- 
2.1.0
