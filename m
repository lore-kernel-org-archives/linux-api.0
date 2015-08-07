From: Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH 4/4] selftests: vm: Pick up sanitized kernel headers
Date: Fri,  7 Aug 2015 15:44:15 +0200
Message-ID: <1438955055-587-4-git-send-email-thierry.reding@gmail.com>
References: <1438955055-587-1-git-send-email-thierry.reding@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438955055-587-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Eric B Munson <emunson@akamai.com>, Andrea Arcangeli <aarcange@redhat.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Add the usr/include subdirectory of the top-level tree to the include
path, and make sure to include headers without relative paths to make
sure the sanitized headers get picked up. Otherwise the compiler will
not be able to find the linux/compiler.h header included by the non-
sanitized include/uapi/linux/userfaultfd.h.

While at it, make sure to only hardcode the syscall numbers on x86 and
PowerPC if they haven't been properly picked up from the headers.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 tools/testing/selftests/vm/Makefile      | 2 +-
 tools/testing/selftests/vm/userfaultfd.c | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
index bb888c651bf2..1dacac81bb68 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -1,6 +1,6 @@
 # Makefile for vm selftests
 
-CFLAGS = -Wall
+CFLAGS = -Wall -I ../../../../usr/include $(EXTRA_CFLAGS)
 BINARIES = compaction_test
 BINARIES += hugepage-mmap
 BINARIES += hugepage-shm
diff --git a/tools/testing/selftests/vm/userfaultfd.c b/tools/testing/selftests/vm/userfaultfd.c
index 76071b14cb93..2bf1fc3f562b 100644
--- a/tools/testing/selftests/vm/userfaultfd.c
+++ b/tools/testing/selftests/vm/userfaultfd.c
@@ -64,8 +64,9 @@
 #include <sys/syscall.h>
 #include <sys/ioctl.h>
 #include <pthread.h>
-#include "../../../../include/uapi/linux/userfaultfd.h"
+#include <linux/userfaultfd.h>
 
+#ifndef __NR_userfaultfd
 #ifdef __x86_64__
 #define __NR_userfaultfd 323
 #elif defined(__i386__)
@@ -75,6 +76,7 @@
 #else
 #error "missing __NR_userfaultfd definition"
 #endif
+#endif
 
 static unsigned long nr_cpus, nr_pages, nr_pages_per_cpu, page_size;
 
-- 
2.4.5
