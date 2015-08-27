From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH v2] alpha: allocate sys_membarrier system call number
Date: Thu, 27 Aug 2015 15:07:43 -0400
Message-ID: <1440702463-9314-1-git-send-email-mathieu.desnoyers@efficios.com>
References: <CAEdQ38HvhvcbmV_zCi=hHBnx7OnuHgX_SvvhEFjs+-hYYaDa_w@mail.gmail.com>
Return-path: <linux-alpha-owner@vger.kernel.org>
In-Reply-To: <CAEdQ38HvhvcbmV_zCi=hHBnx7OnuHgX_SvvhEFjs+-hYYaDa_w@mail.gmail.com>
Sender: linux-alpha-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org
List-Id: linux-api@vger.kernel.org

[ Untested on this architecture. To try it out: fetch linux-next/akpm,
  apply this patch, build/run a membarrier-enabled kernel, and do make
  kselftest. ]

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: linux-api@vger.kernel.org
CC: Richard Henderson <rth@twiddle.net>
CC: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
CC: Matt Turner <mattst88@gmail.com>
CC: linux-alpha@vger.kernel.org
---
 arch/alpha/include/asm/unistd.h      | 2 +-
 arch/alpha/include/uapi/asm/unistd.h | 1 +
 arch/alpha/kernel/systbls.S          | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/alpha/include/asm/unistd.h b/arch/alpha/include/asm/unistd.h
index a56e608..07aa4ca 100644
--- a/arch/alpha/include/asm/unistd.h
+++ b/arch/alpha/include/asm/unistd.h
@@ -3,7 +3,7 @@
 
 #include <uapi/asm/unistd.h>
 
-#define NR_SYSCALLS			514
+#define NR_SYSCALLS			515
 
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_STAT64
diff --git a/arch/alpha/include/uapi/asm/unistd.h b/arch/alpha/include/uapi/asm/unistd.h
index aa33bf5..7725619 100644
--- a/arch/alpha/include/uapi/asm/unistd.h
+++ b/arch/alpha/include/uapi/asm/unistd.h
@@ -475,5 +475,6 @@
 #define __NR_getrandom			511
 #define __NR_memfd_create		512
 #define __NR_execveat			513
+#define __NR_membarrier			514
 
 #endif /* _UAPI_ALPHA_UNISTD_H */
diff --git a/arch/alpha/kernel/systbls.S b/arch/alpha/kernel/systbls.S
index 9b62e3f..1ea64f4 100644
--- a/arch/alpha/kernel/systbls.S
+++ b/arch/alpha/kernel/systbls.S
@@ -532,6 +532,7 @@ sys_call_table:
 	.quad sys_getrandom
 	.quad sys_memfd_create
 	.quad sys_execveat
+	.quad sys_membarrier
 
 	.size sys_call_table, . - sys_call_table
 	.type sys_call_table, @object
-- 
1.9.1

