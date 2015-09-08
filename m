From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v3] Cleanup: membarrier selftest
Date: Tue,  8 Sep 2015 16:58:10 -0400
Message-ID: <1441745890-25852-1-git-send-email-mathieu.desnoyers@efficios.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pranith Kumar <bobby.prani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

We don't need to specify an explicit rule in the Makefile, the implicit
one will do the same. The "__EXPORTED_HEADERS__" define is not needed,
because we build the test against the installed kernel headers, not the
in-tree kernel headers. Re-use "$(TEST_PROGS)" in the clean target
rather than spelling the executable name twice. Include <unistd.h>
rather than the rather specific <asm-generic/unistd.h>. Include
<syscall.h> rather than <sys/syscall.h>. In both cases, the former
header is located in a standard location and includes the latter.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
CC: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: Pranith Kumar <bobby.prani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
--
Changes since v2:
- Refine Changelog, removing references to comments, taking care
  of comments from Shuah Khan.
Changes since v1:
- Add Changelog.
Changes since RFC:
- Take care of comments from Michael Ellerman.
---
 tools/testing/selftests/membarrier/Makefile          | 7 +++----
 tools/testing/selftests/membarrier/membarrier_test.c | 5 +----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/membarrier/Makefile b/tools/testing/selftests/membarrier/Makefile
index 877a503..a1a9708 100644
--- a/tools/testing/selftests/membarrier/Makefile
+++ b/tools/testing/selftests/membarrier/Makefile
@@ -1,11 +1,10 @@
 CFLAGS += -g -I../../../../usr/include/
 
-all:
-	$(CC) $(CFLAGS) membarrier_test.c -o membarrier_test
-
 TEST_PROGS := membarrier_test
 
+all: $(TEST_PROGS)
+
 include ../lib.mk
 
 clean:
-	$(RM) membarrier_test
+	$(RM) $(TEST_PROGS)
diff --git a/tools/testing/selftests/membarrier/membarrier_test.c b/tools/testing/selftests/membarrier/membarrier_test.c
index dde3125..535f0fe 100644
--- a/tools/testing/selftests/membarrier/membarrier_test.c
+++ b/tools/testing/selftests/membarrier/membarrier_test.c
@@ -1,9 +1,6 @@
 #define _GNU_SOURCE
-#define __EXPORTED_HEADERS__
-
 #include <linux/membarrier.h>
-#include <asm-generic/unistd.h>
-#include <sys/syscall.h>
+#include <syscall.h>
 #include <stdio.h>
 #include <errno.h>
 #include <string.h>
-- 
1.9.1
