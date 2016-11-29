From: <bamvor.zhangjian@huawei.com>
Subject: [PATCH v2 4/6] selftests: remove CROSS_COMPILE in dedicated Makefile
Date: Tue, 29 Nov 2016 19:55:50 +0800
Message-ID: <20161129115552.8148-5-bamvor.zhangjian@huawei.com>
References: <20161129115552.8148-1-bamvor.zhangjian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161129115552.8148-1-bamvor.zhangjian@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: shuahkh@osg.samsung.com
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, khilman@kernel.org, broonie@kernel.org, mpe@ellerman.id.au
List-Id: linux-api@vger.kernel.org

From: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>

After previous clean up patches, memfd and timers could get
CROSS_COMPILE from tools/testing/selftest/lib.mk. There is no need to
preserve these definition. So, this patch remove them.

Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
---
 tools/testing/selftests/memfd/Makefile  | 1 -
 tools/testing/selftests/timers/Makefile | 1 -
 2 files changed, 2 deletions(-)

diff --git a/tools/testing/selftests/memfd/Makefile b/tools/testing/selftests/memfd/Makefile
index 2c87f23..79891d0 100644
--- a/tools/testing/selftests/memfd/Makefile
+++ b/tools/testing/selftests/memfd/Makefile
@@ -1,4 +1,3 @@
-CC = $(CROSS_COMPILE)gcc
 CFLAGS += -D_FILE_OFFSET_BITS=64
 CFLAGS += -I../../../../include/uapi/
 CFLAGS += -I../../../../include/
diff --git a/tools/testing/selftests/timers/Makefile b/tools/testing/selftests/timers/Makefile
index 4a3bffe..b90e50c 100644
--- a/tools/testing/selftests/timers/Makefile
+++ b/tools/testing/selftests/timers/Makefile
@@ -1,4 +1,3 @@
-CC = $(CROSS_COMPILE)gcc
 BUILD_FLAGS = -DKTEST
 CFLAGS += -O3 -Wl,-no-as-needed -Wall $(BUILD_FLAGS)
 LDFLAGS += -lrt -lpthread
-- 
2.10.0
