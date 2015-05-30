From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 21/98] include/uapi/linux/hsi/cs-protocol.h: include linux/time.h
Date: Sat, 30 May 2015 17:38:13 +0200
Message-ID: <1433000370-19509-22-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Fixes userspace compilation errors due to missing timespec definition.

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/hsi/cs-protocol.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/hsi/cs-protocol.h b/include/uapi/linux/hsi/cs-protocol.h
index 4957bba..05460ef 100644
--- a/include/uapi/linux/hsi/cs-protocol.h
+++ b/include/uapi/linux/hsi/cs-protocol.h
@@ -26,6 +26,7 @@
 
 #include <linux/types.h>
 #include <linux/ioctl.h>
+#include <linux/time.h>
 
 /* chardev parameters */
 #define CS_DEV_FILE_NAME		"/dev/cmt_speech"
-- 
2.1.4
