From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 98/98] HACK include/uapi/linux/errqueue.h: include time.h in userspace
Date: Sat, 30 May 2015 17:39:30 +0200
Message-ID: <1433000370-19509-99-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Willem de Bruijn <willemb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

linux/time.h conflicts with userspace header time.h. Try to be compatible
for kernel and userspace.

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
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
2.1.4
