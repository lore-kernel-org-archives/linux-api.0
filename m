From: Chen Gang <gang.chen.5i5j-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] arch: uapi: asm: mman.h: Let MADV_FREE have same value for
 all architectures
Date: Fri, 05 Dec 2014 06:58:29 +0800
Message-ID: <5480E715.3020900@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org" <rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org>, "ink-biIs/Y0ymYJMZLIVYojuPNP0rXTJTi09@public.gmane.org" <ink-biIs/Y0ymYJMZLIVYojuPNP0rXTJTi09@public.gmane.org>, "mattst88-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <mattst88-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, "jejb-6jwH94ZQLHl74goWV3ctuw@public.gmane.org" <jejb-6jwH94ZQLHl74goWV3ctuw@public.gmane.org>, "deller-Mmb7MZpHnFY@public.gmane.org" <deller-Mmb7MZpHnFY@public.gmane.org>, "chris-YvXeqwSYzG2sTnJN9+BGXg@public.gmane.org" <chris-YvXeqwSYzG2sTnJN9+BGXg@public.gmane.org>, "jcmvbkbc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <jcmvbkbc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

For uapi, need try to let all macros have same value, and MADV_FREE is
added into main branch recently, so need redefine MADV_FREE for it.

At present, '8' can be shared with all architectures, so redefine it to
'8'.

Signed-off-by: Chen Gang <gang.chen.5i5j-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 arch/alpha/include/uapi/asm/mman.h     | 2 +-
 arch/mips/include/uapi/asm/mman.h      | 2 +-
 arch/parisc/include/uapi/asm/mman.h    | 2 +-
 arch/xtensa/include/uapi/asm/mman.h    | 2 +-
 include/uapi/asm-generic/mman-common.h | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/alpha/include/uapi/asm/mman.h b/arch/alpha/include/uapi/asm/mman.h
index 836fbd4..0b8a5de 100644
--- a/arch/alpha/include/uapi/asm/mman.h
+++ b/arch/alpha/include/uapi/asm/mman.h
@@ -44,9 +44,9 @@
 #define MADV_WILLNEED	3		/* will need these pages */
 #define	MADV_SPACEAVAIL	5		/* ensure resources are available */
 #define MADV_DONTNEED	6		/* don't need these pages */
-#define MADV_FREE	7		/* free pages only if memory pressure */
 
 /* common/generic parameters */
+#define MADV_FREE	8		/* free pages only if memory pressure */
 #define MADV_REMOVE	9		/* remove these pages & resources */
 #define MADV_DONTFORK	10		/* don't inherit across fork */
 #define MADV_DOFORK	11		/* do inherit across fork */
diff --git a/arch/mips/include/uapi/asm/mman.h b/arch/mips/include/uapi/asm/mman.h
index 106e741..d247f54 100644
--- a/arch/mips/include/uapi/asm/mman.h
+++ b/arch/mips/include/uapi/asm/mman.h
@@ -67,9 +67,9 @@
 #define MADV_SEQUENTIAL 2		/* expect sequential page references */
 #define MADV_WILLNEED	3		/* will need these pages */
 #define MADV_DONTNEED	4		/* don't need these pages */
-#define MADV_FREE	5		/* free pages only if memory pressure */
 
 /* common parameters: try to keep these consistent across architectures */
+#define MADV_FREE	8		/* free pages only if memory pressure */
 #define MADV_REMOVE	9		/* remove these pages & resources */
 #define MADV_DONTFORK	10		/* don't inherit across fork */
 #define MADV_DOFORK	11		/* do inherit across fork */
diff --git a/arch/parisc/include/uapi/asm/mman.h b/arch/parisc/include/uapi/asm/mman.h
index 6cb8db7..700d83f 100644
--- a/arch/parisc/include/uapi/asm/mman.h
+++ b/arch/parisc/include/uapi/asm/mman.h
@@ -40,9 +40,9 @@
 #define MADV_SPACEAVAIL 5               /* insure that resources are reserved */
 #define MADV_VPS_PURGE  6               /* Purge pages from VM page cache */
 #define MADV_VPS_INHERIT 7              /* Inherit parents page size */
-#define MADV_FREE	8		/* free pages only if memory pressure */
 
 /* common/generic parameters */
+#define MADV_FREE	8		/* free pages only if memory pressure */
 #define MADV_REMOVE	9		/* remove these pages & resources */
 #define MADV_DONTFORK	10		/* don't inherit across fork */
 #define MADV_DOFORK	11		/* do inherit across fork */
diff --git a/arch/xtensa/include/uapi/asm/mman.h b/arch/xtensa/include/uapi/asm/mman.h
index 1b19f25..77eaca4 100644
--- a/arch/xtensa/include/uapi/asm/mman.h
+++ b/arch/xtensa/include/uapi/asm/mman.h
@@ -80,9 +80,9 @@
 #define MADV_SEQUENTIAL	2		/* expect sequential page references */
 #define MADV_WILLNEED	3		/* will need these pages */
 #define MADV_DONTNEED	4		/* don't need these pages */
-#define MADV_FREE	5		/* free pages only if memory pressure */
 
 /* common parameters: try to keep these consistent across architectures */
+#define MADV_FREE	8		/* free pages only if memory pressure */
 #define MADV_REMOVE	9		/* remove these pages & resources */
 #define MADV_DONTFORK	10		/* don't inherit across fork */
 #define MADV_DOFORK	11		/* do inherit across fork */
diff --git a/include/uapi/asm-generic/mman-common.h b/include/uapi/asm-generic/mman-common.h
index 7a94102..8695959 100644
--- a/include/uapi/asm-generic/mman-common.h
+++ b/include/uapi/asm-generic/mman-common.h
@@ -34,9 +34,9 @@
 #define MADV_SEQUENTIAL	2		/* expect sequential page references */
 #define MADV_WILLNEED	3		/* will need these pages */
 #define MADV_DONTNEED	4		/* don't need these pages */
-#define MADV_FREE	5		/* free pages only if memory pressure */
 
 /* common parameters: try to keep these consistent across architectures */
+#define MADV_FREE	8		/* free pages only if memory pressure */
 #define MADV_REMOVE	9		/* remove these pages & resources */
 #define MADV_DONTFORK	10		/* don't inherit across fork */
 #define MADV_DOFORK	11		/* do inherit across fork */
-- 
1.9.3
