From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH v4 70/79] include/uapi/mtd/mtd-user.h: remove stdint.h include
Date: Thu, 15 Oct 2015 07:56:48 +0200
Message-ID: <1444888618-4506-71-git-send-email-mikko.rapeli@iki.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444888618-4506-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mikko.rapeli-X3B1VOXEql0@public.gmane.org, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Kernel headers should use linux/types.h instead.

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/mtd/mtd-user.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/uapi/mtd/mtd-user.h b/include/uapi/mtd/mtd-user.h
index 83327c8..e71d555 100644
--- a/include/uapi/mtd/mtd-user.h
+++ b/include/uapi/mtd/mtd-user.h
@@ -20,8 +20,6 @@
 #ifndef __MTD_USER_H__
 #define __MTD_USER_H__
 
-#include <stdint.h>
-
 /* This file is blessed for inclusion by userspace */
 #include <mtd/mtd-abi.h>
 
-- 
2.5.0
