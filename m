From: Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4/5] i8k: uapi: Introduce define for new highest fan speed
Date: Sat, 21 Jun 2014 08:08:11 -0700
Message-ID: <1403363304-22358-4-git-send-email-linux@roeck-us.net>
References: <1403363304-22358-1-git-send-email-linux@roeck-us.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1403363304-22358-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Guenter Roeck <linux@roeck-us.net>
List-Id: linux-api@vger.kernel.org

Some Dell laptops support fan speeds of {0, 1, 2, 3} instead of {0, 1, 2}.
Add a define for it.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 include/uapi/linux/i8k.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/i8k.h b/include/uapi/linux/i8k.h
index 1c45ba5..133d02f 100644
--- a/include/uapi/linux/i8k.h
+++ b/include/uapi/linux/i8k.h
@@ -34,7 +34,8 @@
 #define I8K_FAN_OFF		0
 #define I8K_FAN_LOW		1
 #define I8K_FAN_HIGH		2
-#define I8K_FAN_MAX		I8K_FAN_HIGH
+#define I8K_FAN_TURBO		3
+#define I8K_FAN_MAX		I8K_FAN_TURBO
 
 #define I8K_VOL_UP		1
 #define I8K_VOL_DOWN		2
-- 
1.9.1
