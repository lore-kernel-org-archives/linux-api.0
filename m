From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH] selftests: Fix kcmp build to not require headers install
Date: Fri, 13 Mar 2015 19:45:04 -0600
Message-ID: <1426297504-14432-2-git-send-email-shuahkh@osg.samsung.com>
References: <1426297504-14432-1-git-send-email-shuahkh@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426297504-14432-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gorcunov@openvz.org, tranmanphong@gmail.com, mpe@ellerman.id.au, akpm@linux-foundation.org
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Change CFLAGS to look in uapi to allow kcmp to be built without
requiring headers install. This will make it easier to run tests
without going through the headers install step.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 tools/testing/selftests/kcmp/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kcmp/Makefile b/tools/testing/selftests/kcmp/Makefile
index ff0eefd..d405ad4 100644
--- a/tools/testing/selftests/kcmp/Makefile
+++ b/tools/testing/selftests/kcmp/Makefile
@@ -1,5 +1,5 @@
 CC := $(CROSS_COMPILE)$(CC)
-CFLAGS += -I../../../../usr/include/
+CFLAGS += -I../../../../include/uapi -I../../../../usr/include/
 
 all: kcmp_test
 
-- 
2.1.0
