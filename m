From: Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
Subject: [PATCH] timerfd: expose uapi header
Date: Mon,  5 Oct 2015 16:53:39 +0200
Message-ID: <1444056829-9118-1-git-send-email-gabriel@lse.epita.fr>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, stephen hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>, Nicolas Dichtel <nicolas.dichtel-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>, Masahiro Yamada <yamada.m-NAum8xwdG0+S7A1Ibl2khg@public.gmane.org>, Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

this patch expose the timerfd apis to the userland. It is already in
glibc header sys/timerfd.h but not synchronised, and missing the ioctl
number definition.

Signed-off-by: Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
---
 include/linux/timerfd.h      | 20 +-------------------
 include/uapi/linux/Kbuild    |  1 +
 include/uapi/linux/timerfd.h | 31 +++++++++++++++++++++++++++++++
 3 files changed, 33 insertions(+), 19 deletions(-)
 create mode 100644 include/uapi/linux/timerfd.h

diff --git a/include/linux/timerfd.h b/include/linux/timerfd.h
index bd36ce4..bab0b1a 100644
--- a/include/linux/timerfd.h
+++ b/include/linux/timerfd.h
@@ -8,23 +8,7 @@
 #ifndef _LINUX_TIMERFD_H
 #define _LINUX_TIMERFD_H
 
-/* For O_CLOEXEC and O_NONBLOCK */
-#include <linux/fcntl.h>
-
-/* For _IO helpers */
-#include <linux/ioctl.h>
-
-/*
- * CAREFUL: Check include/asm-generic/fcntl.h when defining
- * new flags, since they might collide with O_* ones. We want
- * to re-use O_* flags that couldn't possibly have a meaning
- * from eventfd, in order to leave a free define-space for
- * shared O_* flags.
- */
-#define TFD_TIMER_ABSTIME (1 << 0)
-#define TFD_TIMER_CANCEL_ON_SET (1 << 1)
-#define TFD_CLOEXEC O_CLOEXEC
-#define TFD_NONBLOCK O_NONBLOCK
+#include <uapi/linux/timerfd.h>
 
 #define TFD_SHARED_FCNTL_FLAGS (TFD_CLOEXEC | TFD_NONBLOCK)
 /* Flags for timerfd_create.  */
@@ -32,6 +16,4 @@
 /* Flags for timerfd_settime.  */
 #define TFD_SETTIME_FLAGS (TFD_TIMER_ABSTIME | TFD_TIMER_CANCEL_ON_SET)
 
-#define TFD_IOC_SET_TICKS	_IOW('T', 0, u64)
-
 #endif /* _LINUX_TIMERFD_H */
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index f7b2db4..874ac3f 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -395,6 +395,7 @@ header-y += tcp_metrics.h
 header-y += telephony.h
 header-y += termios.h
 header-y += thermal.h
+header-y += tiemrfd.h
 header-y += time.h
 header-y += times.h
 header-y += timex.h
diff --git a/include/uapi/linux/timerfd.h b/include/uapi/linux/timerfd.h
new file mode 100644
index 0000000..69a2f92
--- /dev/null
+++ b/include/uapi/linux/timerfd.h
@@ -0,0 +1,31 @@
+/*
+ *  include/uapi/linux/timerfd.h
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>
+ *
+ */
+
+#ifndef _UAPI_LINUX_TIMERFD_H
+#define _UAPI_LINUX_TIMERFD_H
+
+/* For O_CLOEXEC and O_NONBLOCK */
+#include <linux/fcntl.h>
+
+/* For _IO helpers */
+#include <linux/ioctl.h>
+
+/*
+ * CAREFUL: Check include/asm-generic/fcntl.h when defining
+ * new flags, since they might collide with O_* ones. We want
+ * to re-use O_* flags that couldn't possibly have a meaning
+ * from eventfd, in order to leave a free define-space for
+ * shared O_* flags.
+ */
+#define TFD_TIMER_ABSTIME (1 << 0)
+#define TFD_TIMER_CANCEL_ON_SET (1 << 1)
+#define TFD_CLOEXEC O_CLOEXEC
+#define TFD_NONBLOCK O_NONBLOCK
+
+#define TFD_IOC_SET_TICKS	_IOW('T', 0, u64)
+
+#endif /* _UAPI_LINUX_TIMERFD_H */
-- 
2.6.0
