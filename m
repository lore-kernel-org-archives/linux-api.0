From: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [char-misc-next 04/11 V2] uuid: extract macros for assigning raw arrays
Date: Wed, 27 May 2015 18:42:13 +0300
Message-ID: <1432741333-11889-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
Cc: arnd-r2nGTMty4D4@public.gmane.org, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

In order for mei client devices to use device id based on uuid we
have to use common types between user space (file2alias.c).
Similarly to vmbus,  mei  uses raw 16 byte array for that. 
To leverage on existing infrastructure around uuid_le type 
defined in uuid.h we add helper macros to handle conversions between
raw 16 byte array and uuid_{le,be} types.

Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org 
Signed-off-by: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
V2: be verbose in the commit message 
 include/uapi/linux/uuid.h | 41 ++++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 17 deletions(-)

diff --git a/include/uapi/linux/uuid.h b/include/uapi/linux/uuid.h
index 786f0773cc33..487f098c8517 100644
--- a/include/uapi/linux/uuid.h
+++ b/include/uapi/linux/uuid.h
@@ -32,27 +32,34 @@ typedef struct {
 	__u8 b[16];
 } uuid_be;
 
-#define UUID_LE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)		\
-((uuid_le)								\
-{{ (a) & 0xff, ((a) >> 8) & 0xff, ((a) >> 16) & 0xff, ((a) >> 24) & 0xff, \
-   (b) & 0xff, ((b) >> 8) & 0xff,					\
-   (c) & 0xff, ((c) >> 8) & 0xff,					\
-   (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
+#define __UUID_LE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)                     \
+	{(a) & 0xff, ((a) >> 8) & 0xff, ((a) >> 16) & 0xff, ((a) >> 24) & 0xff,\
+	  (b) & 0xff, ((b) >> 8) & 0xff,                                       \
+	  (c) & 0xff, ((c) >> 8) & 0xff,                                       \
+	  (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7)}
+
+#define UUID_LE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)	\
+	((uuid_le) {__UUID_LE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)})
+
+#define __UUID_BE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)                     \
+	{((a) >> 24) & 0xff, ((a) >> 16) & 0xff, ((a) >> 8) & 0xff, (a) & 0xff,\
+	  ((b) >> 8) & 0xff, (b) & 0xff,                                       \
+	  ((c) >> 8) & 0xff, (c) & 0xff,                                       \
+	  (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7)}
 
 #define UUID_BE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)		\
-((uuid_be)								\
-{{ ((a) >> 24) & 0xff, ((a) >> 16) & 0xff, ((a) >> 8) & 0xff, (a) & 0xff, \
-   ((b) >> 8) & 0xff, (b) & 0xff,					\
-   ((c) >> 8) & 0xff, (c) & 0xff,					\
-   (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
+	((uuid_be) {__UUID_BE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)})
+
+#define __NULL_UUID_LE							\
+	__UUID_LE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
+		  0x00, 0x00, 0x00, 0x00)
 
-#define NULL_UUID_LE							\
-	UUID_LE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
-		0x00, 0x00, 0x00, 0x00)
+#define NULL_UUID_LE ((uuid_le) {__NULL_UUID_LE})
 
-#define NULL_UUID_BE							\
-	UUID_BE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
-		0x00, 0x00, 0x00, 0x00)
+#define __NULL_UUID_BE							\
+	__UUID_BE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
+		  0x00, 0x00, 0x00, 0x00)
 
+#define NULL_UUID_BE ((uuid_be) {__NULL_UUID_BE})
 
 #endif /* _UAPI_LINUX_UUID_H_ */
-- 
2.1.0
