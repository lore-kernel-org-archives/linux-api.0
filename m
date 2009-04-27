From: arnd-r2nGTMty4D4@public.gmane.org
Subject: [RFC 07/17] asm-generic: make generic mman.h header generic
Date: Mon, 27 Apr 2009 17:01:21 +0200
Message-ID: <20090427150318.375817468@arndb.de>
References: <20090427142010.587518220@arndb.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=add-generic-mman-h.patch
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: john.williams-g5w7nrANp4BDPfheJLI6IQ@public.gmane.org, monstr-pSz03upnqPeHXe+LvDLADg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liqin.chen-+XGAvkf1AAHby3iVrkZq2A@public.gmane.org, Sam Ravnborg <sam-uyr5N9Q2VtJg9hUCZPvPmw@public.gmane.org>, Remis Lima Baima <remis.developer-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The existing asm-generic/mman.h file is missing some definitions
if you want to use it out of the box. This renames the old file
and adds a new one based on the x86 implementation that can be
used for most architectures that copied from x86.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Signed-off-by: Remis Lima Baima <remis.developer-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
---
---
 include/asm-generic/Kbuild |    1 	1 +	0 -	0 !
 include/asm-generic/mman.h |   18 	18 +	0 -	0 !
 2 files changed, 19 insertions(+)

Index: linux-2.6/include/asm-generic/mman.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/mman.h
@@ -0,0 +1,18 @@
+#ifndef __ASM_GENERIC_MMAN_H
+#define __ASM_GENERIC_MMAN_H
+
+#include <asm-generic/mman-common.h>
+
+#define MAP_GROWSDOWN	0x0100		/* stack-like segment */
+#define MAP_DENYWRITE	0x0800		/* ETXTBSY */
+#define MAP_EXECUTABLE	0x1000		/* mark it as an executable */
+#define MAP_LOCKED	0x2000		/* pages are locked */
+#define MAP_NORESERVE	0x4000		/* don't check for reservations */
+#define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
+#define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
+
+#define MCL_CURRENT	1		/* lock all current mappings */
+#define MCL_FUTURE	2		/* lock all future mappings */
+
+#endif /* __ASM_GENERIC_MMAN_H */
Index: linux-2.6/include/asm-generic/Kbuild
===================================================================
--- linux-2.6.orig/include/asm-generic/Kbuild
+++ linux-2.6/include/asm-generic/Kbuild
@@ -3,6 +3,7 @@ header-y += errno.h
 header-y += fcntl.h
 header-y += ioctl.h
 header-y += mman-common.h
+header-y += mman.h
 header-y += poll.h
 header-y += signal-defs.h
 header-y += signal.h

-- 

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
