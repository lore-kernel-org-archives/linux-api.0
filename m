From: Elias Vanderstuyft <elias.vds@gmail.com>
Subject: [PATCH] Input: input.h: Fix EVIOCSFF macro inconsistency by using _IOW()
Date: Thu, 17 Sep 2015 19:26:36 +0200
Message-ID: <1442510796-3062-1-git-send-email-elias.vds@gmail.com>
Return-path: <linux-input-owner@vger.kernel.org>
Sender: linux-input-owner@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Elias Vanderstuyft <elias.vds@gmail.com>
List-Id: linux-api@vger.kernel.org

Just like the EVIOCSABS(abs) macro, use the more compact
_IOW(..., type) instead of _IOC(_IOC_WRITE, ..., sizeof(type))
for the EVIOCSFF macro.

Signed-off-by: Elias Vanderstuyft <elias.vds@gmail.com>
---
 include/uapi/linux/input.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/input.h b/include/uapi/linux/input.h
index 731417c..63915a7 100644
--- a/include/uapi/linux/input.h
+++ b/include/uapi/linux/input.h
@@ -147,7 +147,7 @@ struct input_keymap_entry {
 #define EVIOCGABS(abs)		_IOR('E', 0x40 + (abs), struct input_absinfo)	/* get abs value/limits */
 #define EVIOCSABS(abs)		_IOW('E', 0xc0 + (abs), struct input_absinfo)	/* set abs value/limits */
 
-#define EVIOCSFF		_IOC(_IOC_WRITE, 'E', 0x80, sizeof(struct ff_effect))	/* send a force effect to a force feedback device */
+#define EVIOCSFF		_IOW('E', 0x80, struct ff_effect)	/* send a force effect to a force feedback device */
 #define EVIOCRMFF		_IOW('E', 0x81, int)			/* Erase a force effect */
 #define EVIOCGEFFECTS		_IOR('E', 0x84, int)			/* Report number of effects playable at the same time */
 
-- 
1.9.3

