From: Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 9/9] selftests/mount: Use implicit rules
Date: Tue,  3 Mar 2015 15:51:42 +1100
Message-ID: <1425358302-16680-9-git-send-email-mpe@ellerman.id.au>
References: <1425358302-16680-1-git-send-email-mpe@ellerman.id.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425358302-16680-1-git-send-email-mpe@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: shuahkh@osg.samsung.com, davej@codemonkey.org.uk, mmarek@suse.cz, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

There's no need to open-code the build rules, use the implicit ones.

This has the nice side effect of enabling cross compilation.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 tools/testing/selftests/mount/Makefile | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mount/Makefile b/tools/testing/selftests/mount/Makefile
index a5b367f032ba..a6c62bedb0d9 100644
--- a/tools/testing/selftests/mount/Makefile
+++ b/tools/testing/selftests/mount/Makefile
@@ -1,13 +1,13 @@
 # Makefile for mount selftests.
 
-all: unprivileged-remount-test
+TEST_PROGS := unprivileged-remount-test
+
+CFLAGS += -O2 -Wall
 
-unprivileged-remount-test: unprivileged-remount-test.c
-	gcc -Wall -O2 unprivileged-remount-test.c -o unprivileged-remount-test
+all: $(TEST_PROGS)
 
 include ../lib.mk
 
-TEST_PROGS := unprivileged-remount-test
 override RUN_TESTS := if [ -f /proc/self/uid_map ] ; then ./unprivileged-remount-test ; fi
 override EMIT_TESTS := echo "$(RUN_TESTS)"
 
-- 
2.1.0
