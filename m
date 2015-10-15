From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v4 20/79] include/uapi/linux/hsi/cs-protocol.h: include linux/time.h
Date: Thu, 15 Oct 2015 07:55:58 +0200
Message-ID: <1444888618-4506-21-git-send-email-mikko.rapeli@iki.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: mikko.rapeli@iki.fi, Sebastian Reichel <sre@kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Fixes userspace compilation errors due to missing timespec definition.

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/hsi/cs-protocol.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/hsi/cs-protocol.h b/include/uapi/linux/hsi/cs-protocol.h
index f153d6e..c8d9f08 100644
--- a/include/uapi/linux/hsi/cs-protocol.h
+++ b/include/uapi/linux/hsi/cs-protocol.h
@@ -26,6 +26,7 @@
 
 #include <linux/types.h>
 #include <linux/ioctl.h>
+#include <linux/time.h>
 
 /* chardev parameters */
 #define CS_DEV_FILE_NAME		"/dev/cmt_speech"
-- 
2.5.0
