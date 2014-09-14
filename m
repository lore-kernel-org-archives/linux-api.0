From: =?ISO-8859-15?Q?Stephan_M=FCller?= <fruktopus-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] Change userspace MKDEV, MAJOR, MINOR-macros from 8+8 bit,
 to 12+20 bit layout
Date: Sun, 14 Sep 2014 19:35:28 +0200
Message-ID: <5415D1E0.3020905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Delete old userspace-only versions (8+8 bit). Instead expose the kernel-space
definitions (12+20 bit).

Signed-off-by: Stephan Mueller <fruktopus-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---

Browsing some code I found that user-space and kernel-space macros for (un-)packing major/minor device numbers differ. The user-space ones using still the old 16 bit scheme. There was no explaining comment around and most libraries have their own macros anyway so it should not be a problematic UAPI change. So IMHO we could win some coherence in abandon this discrepancy.
Please correct me if I am wrong.


 include/linux/kdev_t.h      |  7 -------
 include/uapi/linux/kdev_t.h | 16 +++++++---------
 2 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/include/linux/kdev_t.h b/include/linux/kdev_t.h
index c838abe..0b09c12 100644
--- a/include/linux/kdev_t.h
+++ b/include/linux/kdev_t.h
@@ -3,13 +3,6 @@
 
 #include <uapi/linux/kdev_t.h>
 
-#define MINORBITS	20
-#define MINORMASK	((1U << MINORBITS) - 1)
-
-#define MAJOR(dev)	((unsigned int) ((dev) >> MINORBITS))
-#define MINOR(dev)	((unsigned int) ((dev) & MINORMASK))
-#define MKDEV(ma,mi)	(((ma) << MINORBITS) | (mi))
-
 #define print_dev_t(buffer, dev)					\
 	sprintf((buffer), "%u:%u\n", MAJOR(dev), MINOR(dev))
 
diff --git a/include/uapi/linux/kdev_t.h b/include/uapi/linux/kdev_t.h
index 0d881fa..6a8356b 100644
--- a/include/uapi/linux/kdev_t.h
+++ b/include/uapi/linux/kdev_t.h
@@ -1,13 +1,11 @@
 #ifndef _UAPI_LINUX_KDEV_T_H
 #define _UAPI_LINUX_KDEV_T_H
-#ifndef __KERNEL__
 
-/*
-Some programs want their definitions of MAJOR and MINOR and MKDEV
-from the kernel sources. These must be the externally visible ones.
-*/
-#define MAJOR(dev)	((dev)>>8)
-#define MINOR(dev)	((dev) & 0xff)
-#define MKDEV(ma,mi)	((ma)<<8 | (mi))
-#endif /* __KERNEL__ */
+#define MINORBITS	20
+#define MINORMASK	((1U << MINORBITS) - 1)
+
+#define MAJOR(dev)	((unsigned int) ((dev) >> MINORBITS))
+#define MINOR(dev)	((unsigned int) ((dev) & MINORMASK))
+#define MKDEV(ma, mi)	(((ma) << MINORBITS) | (mi))
+
 #endif /* _UAPI_LINUX_KDEV_T_H */
-- 
1.9.3
