From: arnd@arndb.de
Subject: [RFC 12/17] asm-generic: add generic unaligned.h
Date: Mon, 27 Apr 2009 17:01:26 +0200
Message-ID: <20090427150319.222669102@arndb.de>
References: <20090427142010.587518220@arndb.de>
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline; filename=0009-asm-generic-add-generic-unaligned.h.patch
Sender: linux-arch-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, monstr@monstr.eu, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, liqin.chen@sunplusct.com, Sam Ravnborg <sam@ravnborg.org>, Remis Lima Baima <remis.developer@googlemail.com>, Harvey Harrison <harvey.harrison@gmail.com>
List-Id: linux-api@vger.kernel.org

This implementation can be used by any architecture as a generic
way to provide the unaligned helpers. Many architectures can
override this by using linux/unaligned/access_ok.h.

Cc: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
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
