From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v4 78/79] include/uapi/linux/errqueue.h: include time.h in userspace
Date: Thu, 15 Oct 2015 07:56:56 +0200
Message-ID: <1444888618-4506-79-git-send-email-mikko.rapeli@iki.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: mikko.rapeli@iki.fi, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

linux/time.h conflicts with userspace header time.h. Try to be compatible
for kernel and userspace.

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/errqueue.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/linux/errqueue.h b/include/uapi/linux/errqueue.h
index 6b1cdc6..b310b2c 100644
--- a/include/uapi/linux/errqueue.h
+++ b/include/uapi/linux/errqueue.h
@@ -2,7 +2,12 @@
 #define _UAPI_LINUX_ERRQUEUE_H
 
 #include <linux/types.h>
+
+#ifdef __KERNEL__
 #include <linux/time.h>
+#else
+#include <time.h>
+#endif /* __KERNEL__ */
 
 struct sock_extended_err {
 	__u32	ee_errno;	
-- 
2.5.0
