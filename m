From: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
Subject: [PATCH 2/2] selftests: net: support KBUILD_OUTPUT for reuseport_bpf_numa
Date: Mon, 27 Mar 2017 05:46:01 +0000
Message-ID: <20170327054601.22415-3-bamvor.zhangjian@linaro.org>
References: <20170327054601.22415-1-bamvor.zhangjian@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170327054601.22415-1-bamvor.zhangjian@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: luto@amacapital.net, shuahkh@osg.samsung.com
Cc: mpe@ellerman.id.au, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, khilman@kernel.org, broonie@kernel.org, bamvor.zhangjian@huawei.com, bamvor.zhangjian@linaro.org
List-Id: linux-api@vger.kernel.org

reuseport_bpf_numa is not supported by KBUILD_OUTPUT machanism in net
subset. This patch fix this by adding $(OUTPUT) before the target.

Signed-off-by: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
---
 tools/testing/selftests/net/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index fbfe5d0..cc9425e 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -3,7 +3,7 @@
 CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g
 CFLAGS += -I../../../../usr/include/
 
-reuseport_bpf_numa: LDFLAGS += -lnuma
+$(OUTPUT)/reuseport_bpf_numa: LDFLAGS += -lnuma
 
 TEST_PROGS := run_netsocktests run_afpackettests test_bpf.sh
 TEST_GEN_FILES =  socket
-- 
1.9.1
