From: Pranith Kumar <bobby.prani@gmail.com>
Subject: [PATCH] selftests/memfd: Run test on all architectures
Date: Mon, 15 Sep 2014 18:59:42 -0400
Message-ID: <1410821984-11160-1-git-send-email-bobby.prani@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, David Herrmann <dh.herrmann@gmail.com>, Phong Tran <tranmanphong@gmail.com>, "open list:KERNEL SELFTEST F..." <linux-api@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Remove the dependence on x86 to run the memfd test. Verfied on 32-bit powerpc.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 tools/testing/selftests/memfd/Makefile | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/tools/testing/selftests/memfd/Makefile b/tools/testing/selftests/memfd/Makefile
index ad4ab01..b80cd10 100644
--- a/tools/testing/selftests/memfd/Makefile
+++ b/tools/testing/selftests/memfd/Makefile
@@ -1,38 +1,17 @@
-uname_M := $(shell uname -m 2>/dev/null || echo not)
-ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/)
-ifeq ($(ARCH),i386)
-	ARCH := x86
-endif
-ifeq ($(ARCH),x86_64)
-	ARCH := x86
-endif
-
 CFLAGS += -D_FILE_OFFSET_BITS=64
-CFLAGS += -I../../../../arch/x86/include/generated/uapi/
-CFLAGS += -I../../../../arch/x86/include/uapi/
 CFLAGS += -I../../../../include/uapi/
 CFLAGS += -I../../../../include/
 
 all:
-ifeq ($(ARCH),x86)
 	gcc $(CFLAGS) memfd_test.c -o memfd_test
-else
-	echo "Not an x86 target, can't build memfd selftest"
-endif
 
 run_tests: all
-ifeq ($(ARCH),x86)
 	gcc $(CFLAGS) memfd_test.c -o memfd_test
-endif
 	@./memfd_test || echo "memfd_test: [FAIL]"
 
 build_fuse:
-ifeq ($(ARCH),x86)
 	gcc $(CFLAGS) fuse_mnt.c `pkg-config fuse --cflags --libs` -o fuse_mnt
 	gcc $(CFLAGS) fuse_test.c -o fuse_test
-else
-	echo "Not an x86 target, can't build memfd selftest"
-endif
 
 run_fuse: build_fuse
 	@./run_fuse_test.sh || echo "fuse_test: [FAIL]"
-- 
2.1.0
