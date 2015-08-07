From: Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH 2/4] selftests: vm: Ensure the mlock2 syscall number can be found
Date: Fri,  7 Aug 2015 15:44:13 +0200
Message-ID: <1438955055-587-2-git-send-email-thierry.reding@gmail.com>
References: <1438955055-587-1-git-send-email-thierry.reding@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438955055-587-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Eric B Munson <emunson@akamai.com>, Andrea Arcangeli <aarcange@redhat.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Include the syscall.h header to ensure that the mlock2 syscall number is
available. Otherwise the test program will always return ENOSYS from the
mlock2() implementation.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 tools/testing/selftests/vm/mlock2-tests.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/vm/mlock2-tests.c b/tools/testing/selftests/vm/mlock2-tests.c
index 11c38e96f336..2949fd949973 100644
--- a/tools/testing/selftests/vm/mlock2-tests.c
+++ b/tools/testing/selftests/vm/mlock2-tests.c
@@ -6,6 +6,7 @@
 #include <string.h>
 #include <sys/time.h>
 #include <sys/resource.h>
+#include <syscall.h>
 #include <errno.h>
 #include <stdbool.h>
 
-- 
2.4.5
