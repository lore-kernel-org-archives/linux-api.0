From: <arnd-r2nGTMty4D4@public.gmane.org>
Subject: (unknown)
Date: Mon, 27 Apr 2009 10:42:05 -0400
Message-ID: <20090427143738.688526666__344.93279313228$1240843452$gmane$org@arndb.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

>From arnd-r2nGTMty4D4@public.gmane.org Mon Apr 27 16:28:40 2009
References: <20090427142010.587518220-r2nGTMty4D4@public.gmane.org>
User-Agent: quilt/0.46-1
Date: Mon, 27 Apr 2009 16:20:22 +0200
From: arnd-r2nGTMty4D4@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: john.williams-g5w7nrANp4BDPfheJLI6IQ@public.gmane.org,
 monstr-pSz03upnqPeHXe+LvDLADg@public.gmane.org,
 linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 liqin.chen-+XGAvkf1AAHby3iVrkZq2A@public.gmane.org,
 Sam Ravnborg <sam-uyr5N9Q2VtJg9hUCZPvPmw@public.gmane.org>,
 Harvey Harrison <harvey.harrison-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
 Remis Lima Baima <remis.developer-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: [RFC 12/17] asm-generic: add generic unaligned.h
Content-Disposition: inline; filename=0009-asm-generic-add-generic-unaligned.h.patch
X-Provags-ID: V01U2FsdGVkX180uRkKPtTR6NE5qs40yQi4ziqxITkI8KKYXbv
 ceZfZA4rNxQHTjaGg5pO05a3RFhyObTUvhsERRtOhJTrzruub3
 3XgHSsqqDkZJnfLEIfR2g==

This implementation can be used by any architecture as a generic
way to provide the unaligned helpers. Many architectures can
override this by using linux/unaligned/access_ok.h.

Cc: Harvey Harrison <harvey.harrison-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Signed-off-by: Remis Lima Baima <remis.developer-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
---
 include/asm-generic/unaligned.h |   30 	30 +	0 -	0 !
 1 file changed, 30 insertions(+)
 create mode 100644 include/asm-generic/unaligned.h

Index: linux-2.6/include/asm-generic/unaligned.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/unaligned.h
@@ -0,0 +1,30 @@
+#ifndef __ASM_GENERIC_UNALIGNED_H
+#define __ASM_GENERIC_UNALIGNED_H
+
+/*
+ * This is the most generic implementation of unaligned accesses
+ * and should work almost anywhere.
+ *
+ * If an architecture can handle unaligned accesses in hardware,
+ * it may want to use the linux/unaligned/access_ok.h implementation
+ * instead.
+ */
+#include <asm/byteorder.h>
+
+#if defined(__LITTLE_ENDIAN)
+# include <linux/unaligned/le_struct.h>
+# include <linux/unaligned/be_byteshift.h>
+# include <linux/unaligned/generic.h>
+# define get_unaligned	__get_unaligned_le
+# define put_unaligned	__put_unaligned_le
+#elif defined(__BIG_ENDIAN)
+# include <linux/unaligned/be_struct.h>
+# include <linux/unaligned/le_byteshift.h>
+# include <linux/unaligned/generic.h>
+# define get_unaligned	__get_unaligned_be
+# define put_unaligned	__put_unaligned_be
+#else
+# error need to define endianess
+#endif
+
+#endif /* __ASM_GENERIC_UNALIGNED_H */

-- 

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
