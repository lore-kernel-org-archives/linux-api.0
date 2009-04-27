From: arnd-r2nGTMty4D4@public.gmane.org
Subject: [RFC 01/17] asm-generic: rename termios.h to termios-base.h
Date: Mon, 27 Apr 2009 17:01:15 +0200
Message-ID: <20090427150317.357983125@arndb.de>
References: <20090427142010.587518220@arndb.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=0001-asm-generic-add-complete-termios.h.patch
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: john.williams-g5w7nrANp4BDPfheJLI6IQ@public.gmane.org, monstr-pSz03upnqPeHXe+LvDLADg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liqin.chen-+XGAvkf1AAHby3iVrkZq2A@public.gmane.org, Sam Ravnborg <sam-uyr5N9Q2VtJg9hUCZPvPmw@public.gmane.org>, Remis Lima Baima <remis.developer-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The existing asm-generic/termios.h file only contains a part
of the required termios.h contents. This renames it to termios-base.h
and changes all users, so we can add a full termios.h file for
new archtitectures.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Signed-off-by: Remis Lima Baima <remis.developer-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
---
 arch/avr32/include/asm/termios.h      |    2 	1 +	1 -	0 !
 arch/frv/include/asm/termios.h        |    2 	1 +	1 -	0 !
 arch/microblaze/include/asm/termios.h |    2 	1 +	1 -	0 !
 arch/powerpc/include/asm/termios.h    |    2 	1 +	1 -	0 !
 arch/s390/include/asm/termios.h       |    2 	1 +	1 -	0 !
 include/asm-generic/termios-base.h    |   77 	77 +	0 -	0 !
 include/asm-generic/termios.h         |   77 	0 +	77 -	0 !
 7 files changed, 82 insertions(+), 82 deletions(-)
 create mode 100644 include/asm-generic/termios-base.h

Index: linux-2.6/arch/avr32/include/asm/termios.h
===================================================================
--- linux-2.6.orig/arch/avr32/include/asm/termios.h
+++ linux-2.6/arch/avr32/include/asm/termios.h
@@ -55,7 +55,7 @@ struct termio {
 */
 #define INIT_C_CC "\003\034\177\025\004\0\1\0\021\023\032\0\022\017\027\026\0"
 
-#include <asm-generic/termios.h>
+#include <asm-generic/termios-base.h>
 
 #endif	/* __KERNEL__ */
 
Index: linux-2.6/arch/frv/include/asm/termios.h
===================================================================
--- linux-2.6.orig/arch/frv/include/asm/termios.h
+++ linux-2.6/arch/frv/include/asm/termios.h
@@ -52,7 +52,7 @@ struct termio {
 /* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
 
 #ifdef __KERNEL__
-#include <asm-generic/termios.h>
+#include <asm-generic/termios-base.h>
 #endif
 
 #endif /* _ASM_TERMIOS_H */
Index: linux-2.6/arch/powerpc/include/asm/termios.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/termios.h
+++ linux-2.6/arch/powerpc/include/asm/termios.h
@@ -78,7 +78,7 @@ struct termio {
 
 #ifdef __KERNEL__
 
-#include <asm-generic/termios.h>
+#include <asm-generic/termios-base.h>
 
 #endif	/* __KERNEL__ */
 
Index: linux-2.6/arch/s390/include/asm/termios.h
===================================================================
--- linux-2.6.orig/arch/s390/include/asm/termios.h
+++ linux-2.6/arch/s390/include/asm/termios.h
@@ -60,7 +60,7 @@ struct termio {
 #define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios2))
 #define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios2))
 
-#include <asm-generic/termios.h>
+#include <asm-generic/termios-base.h>
 
 #endif	/* __KERNEL__ */
 
Index: linux-2.6/include/asm-generic/termios-base.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/termios-base.h
@@ -0,0 +1,77 @@
+/* termios.h: generic termios/termio user copying/translation
+ */
+
+#ifndef _ASM_GENERIC_TERMIOS_BASE_H
+#define _ASM_GENERIC_TERMIOS_BASE_H
+
+#include <asm/uaccess.h>
+
+#ifndef __ARCH_TERMIO_GETPUT
+
+/*
+ * Translate a "termio" structure into a "termios". Ugh.
+ */
+static inline int user_termio_to_kernel_termios(struct ktermios *termios,
+						struct termio __user *termio)
+{
+	unsigned short tmp;
+
+	if (get_user(tmp, &termio->c_iflag) < 0)
+		goto fault;
+	termios->c_iflag = (0xffff0000 & termios->c_iflag) | tmp;
+
+	if (get_user(tmp, &termio->c_oflag) < 0)
+		goto fault;
+	termios->c_oflag = (0xffff0000 & termios->c_oflag) | tmp;
+
+	if (get_user(tmp, &termio->c_cflag) < 0)
+		goto fault;
+	termios->c_cflag = (0xffff0000 & termios->c_cflag) | tmp;
+
+	if (get_user(tmp, &termio->c_lflag) < 0)
+		goto fault;
+	termios->c_lflag = (0xffff0000 & termios->c_lflag) | tmp;
+
+	if (get_user(termios->c_line, &termio->c_line) < 0)
+		goto fault;
+
+	if (copy_from_user(termios->c_cc, termio->c_cc, NCC) != 0)
+		goto fault;
+
+	return 0;
+
+ fault:
+	return -EFAULT;
+}
+
+/*
+ * Translate a "termios" structure into a "termio". Ugh.
+ */
+static inline int kernel_termios_to_user_termio(struct termio __user *termio,
+						struct ktermios *termios)
+{
+	if (put_user(termios->c_iflag, &termio->c_iflag) < 0 ||
+	    put_user(termios->c_oflag, &termio->c_oflag) < 0 ||
+	    put_user(termios->c_cflag, &termio->c_cflag) < 0 ||
+	    put_user(termios->c_lflag, &termio->c_lflag) < 0 ||
+	    put_user(termios->c_line,  &termio->c_line) < 0 ||
+	    copy_to_user(termio->c_cc, termios->c_cc, NCC) != 0)
+		return -EFAULT;
+
+	return 0;
+}
+
+#ifndef user_termios_to_kernel_termios
+#define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios))
+#endif
+
+#ifndef kernel_termios_to_user_termios
+#define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios))
+#endif
+
+#define user_termios_to_kernel_termios_1(k, u) copy_from_user(k, u, sizeof(struct termios))
+#define kernel_termios_to_user_termios_1(u, k) copy_to_user(u, k, sizeof(struct termios))
+
+#endif	/* __ARCH_TERMIO_GETPUT */
+
+#endif /* _ASM_GENERIC_TERMIOS_BASE_H */
Index: linux-2.6/include/asm-generic/termios.h
===================================================================
--- linux-2.6.orig/include/asm-generic/termios.h
+++ /dev/null
@@ -1,77 +0,0 @@
-/* termios.h: generic termios/termio user copying/translation
- */
-
-#ifndef _ASM_GENERIC_TERMIOS_H
-#define _ASM_GENERIC_TERMIOS_H
-
-#include <asm/uaccess.h>
-
-#ifndef __ARCH_TERMIO_GETPUT
-
-/*
- * Translate a "termio" structure into a "termios". Ugh.
- */
-static inline int user_termio_to_kernel_termios(struct ktermios *termios,
-						struct termio __user *termio)
-{
-	unsigned short tmp;
-
-	if (get_user(tmp, &termio->c_iflag) < 0)
-		goto fault;
-	termios->c_iflag = (0xffff0000 & termios->c_iflag) | tmp;
-
-	if (get_user(tmp, &termio->c_oflag) < 0)
-		goto fault;
-	termios->c_oflag = (0xffff0000 & termios->c_oflag) | tmp;
-
-	if (get_user(tmp, &termio->c_cflag) < 0)
-		goto fault;
-	termios->c_cflag = (0xffff0000 & termios->c_cflag) | tmp;
-
-	if (get_user(tmp, &termio->c_lflag) < 0)
-		goto fault;
-	termios->c_lflag = (0xffff0000 & termios->c_lflag) | tmp;
-
-	if (get_user(termios->c_line, &termio->c_line) < 0)
-		goto fault;
-
-	if (copy_from_user(termios->c_cc, termio->c_cc, NCC) != 0)
-		goto fault;
-
-	return 0;
-
- fault:
-	return -EFAULT;
-}
-
-/*
- * Translate a "termios" structure into a "termio". Ugh.
- */
-static inline int kernel_termios_to_user_termio(struct termio __user *termio,
-						struct ktermios *termios)
-{
-	if (put_user(termios->c_iflag, &termio->c_iflag) < 0 ||
-	    put_user(termios->c_oflag, &termio->c_oflag) < 0 ||
-	    put_user(termios->c_cflag, &termio->c_cflag) < 0 ||
-	    put_user(termios->c_lflag, &termio->c_lflag) < 0 ||
-	    put_user(termios->c_line,  &termio->c_line) < 0 ||
-	    copy_to_user(termio->c_cc, termios->c_cc, NCC) != 0)
-		return -EFAULT;
-
-	return 0;
-}
-
-#ifndef user_termios_to_kernel_termios
-#define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios))
-#endif
-
-#ifndef kernel_termios_to_user_termios
-#define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios))
-#endif
-
-#define user_termios_to_kernel_termios_1(k, u) copy_from_user(k, u, sizeof(struct termios))
-#define kernel_termios_to_user_termios_1(u, k) copy_to_user(u, k, sizeof(struct termios))
-
-#endif	/* __ARCH_TERMIO_GETPUT */
-
-#endif /* _ASM_GENERIC_TERMIOS_H */
Index: linux-2.6/arch/microblaze/include/asm/termios.h
===================================================================
--- linux-2.6.orig/arch/microblaze/include/asm/termios.h
+++ linux-2.6/arch/microblaze/include/asm/termios.h
@@ -81,7 +81,7 @@ struct termio {
 
 #ifdef __KERNEL__
 
-#include <asm-generic/termios.h>
+#include <asm-generic/termios-base.h>
 
 #endif	/* __KERNEL__ */
 

-- 

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
