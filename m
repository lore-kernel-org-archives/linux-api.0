From: Chunyan Zhang <zhang.chunyan@linaro.org>
Subject: [PATCH] selftests: memfd_test: Revised STACK_SIZE to make it 16-byte aligned
Date: Thu,  1 Oct 2015 15:33:02 +0800
Message-ID: <1443684782-10898-1-git-send-email-zhang.chunyan@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: shuahkh@osg.samsung.com
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

There is a mandate of 16-byte aligned stack on AArch64 [1], so the
STACK_SIZE here should also be 16-byte aligned, otherwise we would
get an error when calling clone().

[1] http://lxr.free-electrons.com/source/arch/arm64/kernel/process.c#L265

Signed-off-by: Chunyan Zhang <zhang.chunyan@linaro.org>
---
 tools/testing/selftests/memfd/memfd_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/memfd/memfd_test.c b/tools/testing/selftests/memfd/memfd_test.c
index 0b9eafb..aa5d3eb 100644
--- a/tools/testing/selftests/memfd/memfd_test.c
+++ b/tools/testing/selftests/memfd/memfd_test.c
@@ -18,7 +18,7 @@
 #include <unistd.h>
 
 #define MFD_DEF_SIZE 8192
-#define STACK_SIZE 65535
+#define STACK_SIZE 65536
 
 static int sys_memfd_create(const char *name,
 			    unsigned int flags)
-- 
1.9.1
