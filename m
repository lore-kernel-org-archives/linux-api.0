From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: [PATCH v3 4/7] selftests: Set CC using CROSS_COMPILE once in lib.mk
Date: Wed,  4 Mar 2015 21:41:31 +1100
Message-ID: <1425465694-27095-4-git-send-email-mpe@ellerman.id.au>
References: <1425465694-27095-1-git-send-email-mpe@ellerman.id.au>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1425465694-27095-1-git-send-email-mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org, mmarek-AlSwsSmVLrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This avoids repeating the logic in every Makefile. We mimic the
top-level Makefile and use $(CROSS_COMPILE)gcc.

Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
---
 tools/testing/selftests/efivarfs/Makefile | 1 -
 tools/testing/selftests/exec/Makefile     | 1 -
 tools/testing/selftests/kcmp/Makefile     | 1 -
 tools/testing/selftests/lib.mk            | 4 ++++
 tools/testing/selftests/net/Makefile      | 1 -
 tools/testing/selftests/powerpc/Makefile  | 3 +--
 tools/testing/selftests/size/Makefile     | 2 --
 tools/testing/selftests/vm/Makefile       | 1 -
 8 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/efivarfs/Makefile b/tools/testing/selftests/efivarfs/Makefile
index 3052d0bda24b..d683486a859b 100644
--- a/tools/testing/selftests/efivarfs/Makefile
+++ b/tools/testing/selftests/efivarfs/Makefile
@@ -1,4 +1,3 @@
-CC = $(CROSS_COMPILE)gcc
 CFLAGS = -Wall
 
 test_objs = open-unlink create-read
diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
index 886cabe307b1..4edb7d0da29b 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -1,4 +1,3 @@
-CC = $(CROSS_COMPILE)gcc
 CFLAGS = -Wall
 BINARIES = execveat
 DEPS = execveat.symlink execveat.denatured script subdir
diff --git a/tools/testing/selftests/kcmp/Makefile b/tools/testing/selftests/kcmp/Makefile
index 0eecd183058c..2ae7450a9a89 100644
--- a/tools/testing/selftests/kcmp/Makefile
+++ b/tools/testing/selftests/kcmp/Makefile
@@ -1,4 +1,3 @@
-CC := $(CROSS_COMPILE)$(CC)
 CFLAGS += -I../../../../usr/include/
 
 all: kcmp_test
diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 7bd3dabe2846..860906694a10 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -1,3 +1,7 @@
+# This mimics the top-level Makefile. We do it explicitly here so that this
+# Makefile can operate with or without the kbuild infrastructure.
+CC := $(CROSS_COMPILE)gcc
+
 define RUN_TESTS
 	@for TEST in $(TEST_PROGS); do \
 		(./$$TEST && echo "selftests: $$TEST [PASS]") || echo "selftests: $$TEST [FAIL]"; \
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 6ba2ac7bbb0d..fac4782c51d8 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -1,6 +1,5 @@
 # Makefile for net selftests
 
-CC = $(CROSS_COMPILE)gcc
 CFLAGS = -Wall -O2 -g
 
 CFLAGS += -I../../../../usr/include/
diff --git a/tools/testing/selftests/powerpc/Makefile b/tools/testing/selftests/powerpc/Makefile
index 22c4f8ffa422..2958fe9a74e9 100644
--- a/tools/testing/selftests/powerpc/Makefile
+++ b/tools/testing/selftests/powerpc/Makefile
@@ -8,10 +8,9 @@ ifeq ($(ARCH),powerpc)
 
 GIT_VERSION = $(shell git describe --always --long --dirty || echo "unknown")
 
-CC := $(CROSS_COMPILE)$(CC)
 CFLAGS := -Wall -O2 -flto -Wall -Werror -DGIT_VERSION='"$(GIT_VERSION)"' -I$(CURDIR) $(CFLAGS)
 
-export CC CFLAGS
+export CFLAGS
 
 TARGETS = pmu copyloops mm tm primitives stringloops
 
diff --git a/tools/testing/selftests/size/Makefile b/tools/testing/selftests/size/Makefile
index e4353d74ea6e..bbd0b5398b61 100644
--- a/tools/testing/selftests/size/Makefile
+++ b/tools/testing/selftests/size/Makefile
@@ -1,5 +1,3 @@
-CC = $(CROSS_COMPILE)gcc
-
 all: get_size
 
 get_size: get_size.c
diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
index 90e56090b0ed..cd1a55a279aa 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -1,6 +1,5 @@
 # Makefile for vm selftests
 
-CC = $(CROSS_COMPILE)gcc
 CFLAGS = -Wall
 BINARIES = hugepage-mmap hugepage-shm map_hugetlb thuge-gen hugetlbfstest
 BINARIES += transhuge-stress
-- 
2.1.0
