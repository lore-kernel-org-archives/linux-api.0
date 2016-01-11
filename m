From: Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>
Subject: [RFC PATCH] selftests: use INSTALL_HDR_PATH instead of relative paths
Date: Mon, 11 Jan 2016 14:22:52 +0000
Message-ID: <1452522172-16650-1-git-send-email-sudeep.holla@arm.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The selftests build fails or picks up wrong headers when cross-compiling
and build directory is different from source as the headers are referred
using the relative paths.

This patch use $INSTALL_HDR_PATH to fix the compilation. It also removes
installing the headers.

Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Signed-off-by: Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>
---
 tools/testing/selftests/membarrier/Makefile | 2 +-
 tools/testing/selftests/memfd/Makefile      | 2 +-
 tools/testing/selftests/net/Makefile        | 2 +-
 tools/testing/selftests/vm/Makefile         | 7 ++-----
 4 files changed, 5 insertions(+), 8 deletions(-)

Hi,

When I was cross-compiling these tests for arm{32,64}, I faced issues.
With limited knowledge I have on this build system, I came up with this
patch. Please treat this as bug report if this approach makes no-sense
and suggest on how to fix it.

Regards,
Sudeep

diff --git a/tools/testing/selftests/membarrier/Makefile b/tools/testing/selftests/membarrier/Makefile
index a1a97085847d..0a033d39cc10 100644
--- a/tools/testing/selftests/membarrier/Makefile
+++ b/tools/testing/selftests/membarrier/Makefile
@@ -1,4 +1,4 @@
-CFLAGS += -g -I../../../../usr/include/
+CFLAGS += -g -I$(INSTALL_HDR_PATH)/include/
 
 TEST_PROGS := membarrier_test
 
diff --git a/tools/testing/selftests/memfd/Makefile b/tools/testing/selftests/memfd/Makefile
index fd396ac811b6..704249ba24ea 100644
--- a/tools/testing/selftests/memfd/Makefile
+++ b/tools/testing/selftests/memfd/Makefile
@@ -2,7 +2,7 @@ CC = $(CROSS_COMPILE)gcc
 CFLAGS += -D_FILE_OFFSET_BITS=64
 CFLAGS += -I../../../../include/uapi/
 CFLAGS += -I../../../../include/
-CFLAGS += -I../../../../usr/include/
+CFLAGS += -I$(INSTALL_HDR_PATH)/include/
 
 TEST_PROGS := memfd_test
 
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index fac4782c51d8..40cf11375c15 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -2,7 +2,7 @@
 
 CFLAGS = -Wall -O2 -g
 
-CFLAGS += -I../../../../usr/include/
+CFLAGS += -I$(INSTALL_HDR_PATH)/include/
 
 NET_PROGS = socket psock_fanout psock_tpacket
 
diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
index e4bb1de1d526..ad343d00d131 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -1,6 +1,6 @@
 # Makefile for vm selftests
 
-CFLAGS = -Wall -I ../../../../usr/include $(EXTRA_CFLAGS)
+CFLAGS = -Wall -I $(INSTALL_HDR_PATH)/include $(EXTRA_CFLAGS)
 BINARIES = compaction_test
 BINARIES += hugepage-mmap
 BINARIES += hugepage-shm
@@ -14,12 +14,9 @@ BINARIES += userfaultfd
 all: $(BINARIES)
 %: %.c
 	$(CC) $(CFLAGS) -o $@ $^ -lrt
-userfaultfd: userfaultfd.c ../../../../usr/include/linux/kernel.h
+userfaultfd: userfaultfd.c $(INSTALL_HDR_PATH)/include/linux/kernel.h
 	$(CC) $(CFLAGS) -O2 -o $@ $< -lpthread
 
-../../../../usr/include/linux/kernel.h:
-	make -C ../../../.. headers_install
-
 TEST_PROGS := run_vmtests
 TEST_FILES := $(BINARIES)
 
-- 
1.9.1
