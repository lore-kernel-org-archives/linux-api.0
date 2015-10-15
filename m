From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v4 65/79] include/uapi/linux/patchkey.h: change #error to #warning if file included directly
Date: Thu, 15 Oct 2015 07:56:43 +0200
Message-ID: <1444888618-4506-66-git-send-email-mikko.rapeli@iki.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: mikko.rapeli@iki.fi, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Would be nice to be able to compile all userspace header files also alone.

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
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
2.5.0
