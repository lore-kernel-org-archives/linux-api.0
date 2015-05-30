From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 89/98] include/uapi/linux/patchkey.h: change #error to #warning if file included directly
Date: Sat, 30 May 2015 17:39:21 +0200
Message-ID: <1433000370-19509-90-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Would be nice to be able to compile all userspace header files also alone.

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/patchkey.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/patchkey.h b/include/uapi/linux/patchkey.h
index 1bda0e5..cee195d 100644
--- a/include/uapi/linux/patchkey.h
+++ b/include/uapi/linux/patchkey.h
@@ -11,7 +11,7 @@
  */
 
 #ifndef _LINUX_PATCHKEY_H_INDIRECT
-#error "patchkey.h included directly"
+#warning "patchkey.h included directly"
 #endif
 
 #ifndef _UAPI_LINUX_PATCHKEY_H
-- 
2.1.4
