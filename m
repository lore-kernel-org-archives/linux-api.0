From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 34/45] include/uapi/asm-generic/signal.h: hide sigset_t definition in userspace
Date: Tue, 17 Feb 2015 00:05:37 +0100
Message-ID: <1424127948-22484-35-git-send-email-mikko.rapeli@iki.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

It is already defined by libc headers in
/usr/include/i386-linux-gnu/sys/select.h

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/asm-generic/signal.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/asm-generic/signal.h b/include/uapi/asm-generic/signal.h
index 8a341a2..af4d83a 100644
--- a/include/uapi/asm-generic/signal.h
+++ b/include/uapi/asm-generic/signal.h
@@ -88,9 +88,12 @@
 #define SIGSTKSZ	8192
 
 #ifndef __ASSEMBLY__
+#ifdef __KERNEL__
+/* already defined in userspace via stdlib.h */
 typedef struct {
 	unsigned long sig[_NSIG_WORDS];
 } sigset_t;
+#endif /* __KERNEL__ */
 
 /* not actually used, but required for linux/syscalls.h */
 typedef unsigned long old_sigset_t;
-- 
2.1.4
