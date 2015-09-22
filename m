From: Andre Przywara <andre.przywara-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH] generic syscalls: wire up userfaultfd syscall
Date: Tue, 22 Sep 2015 11:52:19 +0100
Message-ID: <1442919139-18027-1-git-send-email-andre.przywara@arm.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org
List-Id: linux-api@vger.kernel.org

Enable the new userfaultfd syscall in the generic syscall table.
Briefly tested on arm64 with the selftest from the tools directory.

Signed-off-by: Andre Przywara <andre.przywara-5wv7dgnIgG8@public.gmane.org>
---
 include/uapi/asm-generic/unistd.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 8da542a..82c91bc 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -711,9 +711,11 @@ __SYSCALL(__NR_bpf, sys_bpf)
 __SC_COMP(__NR_execveat, sys_execveat, compat_sys_execveat)
 #define __NR_membarrier 282
 __SYSCALL(__NR_membarrier, sys_membarrier)
+#define __NR_userfaultfd 283
+__SYSCALL(__NR_userfaultfd, sys_userfaultfd)
 
 #undef __NR_syscalls
-#define __NR_syscalls 283
+#define __NR_syscalls 284
 
 /*
  * All syscalls below here should go away really,
-- 
2.5.1
