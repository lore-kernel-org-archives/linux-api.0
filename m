From: Bilel DRIRA <bilel.dr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] include/uapi/linux/swab.h: define a silent macro to avoid sparse error
Date: Sun, 14 Jun 2015 23:23:32 +0100
Message-ID: <1434320613-28700-1-git-send-email-bilel.dr@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bilel DRIRA <bilel.dr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

define a silent macro when _CHECKER_ is defined.
This change fixes the following sparse errors:

include/uapi/linux/swab.h:60:16: error: undefined identifier '__builtin_bswap32'
include/uapi/linux/swab.h:60:33: error: not a function <noident>
include/uapi/linux/swab.h:71:16: error: undefined identifier '__builtin_bswap64'
include/uapi/linux/swab.h:71:33: error: not a function <noident>
include/uapi/linux/swab.h:60:33: error: not a function <noident>

Signed-off-by: Bilel DRIRA <bilel.dr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 include/uapi/linux/swab.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/uapi/linux/swab.h b/include/uapi/linux/swab.h
index 0e011eb..c04de49 100644
--- a/include/uapi/linux/swab.h
+++ b/include/uapi/linux/swab.h
@@ -5,6 +5,18 @@
 #include <linux/compiler.h>
 #include <asm/swab.h>
 
+#ifdef __CHECKER__
+
+#ifdef __HAVE_BUILTIN_BSWAP64__
+#define __builtin_bswap64(val) (0)
+#endif
+
+#ifdef __HAVE_BUILTIN_BSWAP32__
+#define __builtin_bswap32(val) (0)
+#endif
+
+#endif	/* __CHECKER__ */
+
 /*
  * casts are necessary for constants, because we never know how for sure
  * how U/UL/ULL map to __u16, __u32, __u64. At least not in a portable way.
-- 
1.7.9.5
