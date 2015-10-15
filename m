From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v4 53/79] include/uapi/linux/errqueue.h: include linux/time.h
Date: Thu, 15 Oct 2015 07:56:31 +0200
Message-ID: <1444888618-4506-54-git-send-email-mikko.rapeli@iki.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: mikko.rapeli@iki.fi, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Fixes userspace compilation error:

error: array type has incomplete element type
 struct timespec ts[3];

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/errqueue.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/errqueue.h b/include/uapi/linux/errqueue.h
index 07bdce1..6b1cdc6 100644
--- a/include/uapi/linux/errqueue.h
+++ b/include/uapi/linux/errqueue.h
@@ -2,6 +2,7 @@
 #define _UAPI_LINUX_ERRQUEUE_H
 
 #include <linux/types.h>
+#include <linux/time.h>
 
 struct sock_extended_err {
 	__u32	ee_errno;	
-- 
2.5.0
