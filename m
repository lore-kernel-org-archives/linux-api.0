From: Manjeet Pawar <manjeet.p@samsung.com>
Subject: [PATCHv3] ARM64:Fix MINSIGSTKSZ and SIGSTKSZ
Date: Fri, 09 Oct 2015 15:59:40 +0530
Message-ID: <1444386580-10917-1-git-send-email-manjeet.p@samsung.com>
Return-path: <linux-arch-owner@vger.kernel.org>
Sender: linux-arch-owner@vger.kernel.org
To: catalin.marinas@arm.com, will.deacon@arm.com, arnd@arndb.de, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Cc: pankaj.m@samsung.com, Manjeet Pawar <manjeet.p@samsung.com>, Akhilesh Kumar <akhilesh.k@samsung.com>, Rohit Thapliyal <r.thapliyal@samsung.com>
List-Id: linux-api@vger.kernel.org

MINSIGSTKSZ and SIGSTKSZ for ARM64 are not correctly set in latest kernel.
This patch fixes this issue.

This issue is reported in LTP (testcase: sigaltstack02.c).
Testcase failed when sigaltstack() called with stack size "MINSIGSTKSZ - 1"
Since in Glibc-2.22, MINSIGSTKSZ is set to 5120 but in kernel
it is set to 2048 so testcase gets failed.

Testcase Output:
sigaltstack02 1  TPASS  :  stgaltstack() fails, Invalid Flag value,errno:22
sigaltstack02 2  TFAIL  :  sigaltstack() returned 0, expected -1,errno:12

Reported Issue in Glibc Bugzilla:
Bugfix in Glibc-2.22: [Bug 16850]
https://sourceware.org/bugzilla/show_bug.cgi?id=16850

Signed-off-by: Akhilesh Kumar <akhilesh.k@samsung.com>
Signed-off-by: Manjeet Pawar <manjeet.p@samsung.com>
Signed-off-by: Rohit Thapliyal <r.thapliyal@samsung.com>
---
v1 -> Changes in uapi overall header
v2 -> Changes done in arm64 headers
v3 -> Changes done in both uapi & arm64 headers

 arch/arm64/include/uapi/asm/signal.h |    3 +++
 include/uapi/asm-generic/signal.h    |    2 ++
 2 files changed, 5 insertions(+)

diff --git a/arch/arm64/include/uapi/asm/signal.h b/arch/arm64/include/uapi/asm/signal.h
index 8d1e723..991bf5d 100644
--- a/arch/arm64/include/uapi/asm/signal.h
+++ b/arch/arm64/include/uapi/asm/signal.h
@@ -19,6 +19,9 @@
 /* Required for AArch32 compatibility. */
 #define SA_RESTORER	0x04000000
 
+#define MINSIGSTKSZ 5120
+#define SIGSTKSZ    16384
+
 #include <asm-generic/signal.h>
 
 #endif
diff --git a/include/uapi/asm-generic/signal.h b/include/uapi/asm-generic/signal.h
index 9df61f1..b98b67b 100644
--- a/include/uapi/asm-generic/signal.h
+++ b/include/uapi/asm-generic/signal.h
@@ -80,8 +80,10 @@
  *	SA_RESTORER	0x04000000
  */
 
+#if !defined MINSIGSTKSZ || !defined SIGSTKSZ
 #define MINSIGSTKSZ	2048
 #define SIGSTKSZ	8192
+#endif
 
 #ifndef __ASSEMBLY__
 typedef struct {
-- 
1.7.9.5
