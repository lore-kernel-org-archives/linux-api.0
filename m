From: arnd@arndb.de
Subject: [RFC 02/17] asm-generic: rename signal.h to signal-defs.h
Date: Mon, 27 Apr 2009 17:01:16 +0200
Message-ID: <20090427150317.524552799@arndb.de>
References: <20090427142010.587518220@arndb.de>
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline; filename=0007-asm-generic-add-a-complete-signal.h.patch
Sender: linux-arch-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, monstr@monstr.eu, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, liqin.chen@sunplusct.com, Sam Ravnborg <sam@ravnborg.org>, Remis Lima Baima <remis.developer@googlemail.com>
List-Id: linux-api@vger.kernel.org

The existing asm-generic/signal.h is incomplete and included
by some architectures. New architectures should be able
to use a generic version, so rename the existing file and
change all users, which lets us add the new file.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
---
 arch/alpha/include/asm/signal.h      |    2 	1 +	1 -	0 !
 arch/arm/include/asm/signal.h        |    2 	1 +	1 -	0 !
 arch/avr32/include/asm/signal.h      |    2 	1 +	1 -	0 !
 arch/blackfin/include/asm/signal.h   |    2 	1 +	1 -	0 !
 arch/cris/include/asm/signal.h       |    2 	1 +	1 -	0 !
 arch/h8300/include/asm/signal.h      |    2 	1 +	1 -	0 !
 arch/ia64/include/asm/signal.h       |    2 	1 +	1 -	0 !
 arch/m32r/include/asm/signal.h       |    2 	1 +	1 -	0 !
 arch/m68k/include/asm/signal.h       |    2 	1 +	1 -	0 !
 arch/microblaze/include/asm/signal.h |    2 	1 +	1 -	0 !
 arch/mips/include/asm/signal.h       |    2 	1 +	1 -	0 !
 arch/mn10300/include/asm/signal.h    |    2 	1 +	1 -	0 !
 arch/powerpc/include/asm/signal.h    |    2 	1 +	1 -	0 !
 arch/s390/include/asm/signal.h       |    2 	1 +	1 -	0 !
 arch/sh/include/asm/signal.h         |    2 	1 +	1 -	0 !
 arch/sparc/include/asm/signal.h      |    2 	1 +	1 -	0 !
 arch/x86/include/asm/signal.h        |    2 	1 +	1 -	0 !
 include/asm-generic/Kbuild           |    2 	1 +	1 -	0 !
 include/asm-generic/signal-defs.h    |   28 	28 +	0 -	0 !
 include/asm-generic/signal.h         |   28 	0 +	28 -	0 !
 20 files changed, 46 insertions(+), 46 deletions(-)
 create mode 100644 include/asm-generic/signal-defs.h

Index: linux-2.6/arch/alpha/include/asm/signal.h
===================================================================
--- linux-2.6.orig/arch/alpha/include/asm/signal.h
+++ linux-2.6/arch/alpha/include/asm/signal.h
@@ -111,7 +111,7 @@ typedef unsigned long sigset_t;
 #define SIG_UNBLOCK        2	/* for unblocking signals */
 #define SIG_SETMASK        3	/* for setting the signal mask */
 
-#include <asm-generic/signal.h>
+#include <asm-generic/signal-defs.h>
 
 #ifdef __KERNEL__
 struct osf_sigaction {
Index: linux-2.6/arch/arm/include/asm/signal.h
===================================================================
--- linux-2.6.orig/arch/arm/include/asm/signal.h
+++ linux-2.6/arch/arm/include/asm/signal.h
@@ -111,7 +111,7 @@ typedef unsigned long sigset_t;
 #define MINSIGSTKSZ	2048
 #define SIGSTKSZ	8192
 
-#include <asm-generic/signal.h>
+#include <asm-generic/signal-defs.h>
 
 #ifdef __KERNEL__
 struct old_sigaction {
Index: linux-2.6/arch/avr32/include/asm/signal.h
===================================================================
--- linux-2.6.orig/arch/avr32/include/asm/signal.h
+++ linux-2.6/arch/avr32/include/asm/signal.h
@@ -112,7 +112,7 @@ typedef unsigned long sigset_t;
 #define MINSIGSTKSZ	2048
 #define SIGSTKSZ	8192
 
-#include <asm-generic/signal.h>
+#include <asm-generic/signal-defs.h>
 
 #ifdef __KERNEL__
 struct old_sigaction {
Index: linux-2.6/arch/blackfin/include/asm/signal.h
===================================================================
--- linux-2.6.orig/arch/blackfin/include/asm/signal.h
+++ linux-2.6/arch/blackfin/include/asm/signal.h
@@ -104,7 +104,7 @@ typedef unsigned long sigset_t;
 #define MINSIGSTKSZ	2048
 #define SIGSTKSZ	8192
 
-#include <asm-generic/signal.h>
+#include <asm-generic/signal-defs.h>
 
 #ifdef __KERNEL__
 struct old_sigaction {
Index: linux-2.6/arch/cris/include/asm/signal.h
===================================================================
--- linux-2.6.orig/arch/cris/include/asm/signal.h
+++ linux-2.6/arch/cris/include/asm/signal.h
@@ -106,7 +106,7 @@ typedef unsigned long sigset_t;
 #define MINSIGSTKSZ	2048
 #define SIGSTKSZ	8192
 
-#include <asm-generic/signal.h>
+#include <asm-generic/signal-defs.h>
 
 #ifdef __KERNEL__
 struct old_sigaction {
Index: linux-2.6/arch/h8300/include/asm/signal.h
===================================================================
--- linux-2.6.orig/arch/h8300/include/asm/signal.h
+++ linux-2.6/arch/h8300/include/asm/signal.h
@@ -105,7 +105,7 @@ typedef unsigned long sigset_t;
 #define MINSIGSTKSZ	2048
 #define SIGSTKSZ	8192
 
-#include <asm-generic/signal.h>
+#include <asm-generic/signal-defs.h>
 
 #ifdef __KERNEL__
 struct old_sigaction {
Index: linux-2.6/arch/ia64/include/asm/signal.h
===================================================================
--- linux-2.6.orig/arch/ia64/include/asm/signal.h
+++ linux-2.6/arch/ia64/include/asm/signal.h
@@ -114,7 +114,7 @@
 
 #endif /* __KERNEL__ */
 
-#include <asm-generic/signal.h>
+#include <asm-generic/signal-defs.h>
 
 # ifndef __ASSEMBLY__
 
Index: linux-2.6/arch/m68k/include/asm/signal.h
===================================================================
--- linux-2.6.orig/arch/m68k/include/asm/signal.h
+++ linux-2.6/arch/m68k/include/asm/signal.h
@@ -103,7 +103,7 @@ typedef unsigned long sigset_t;
 #define MINSIGSTKSZ	2048
 #define SIGSTKSZ	8192
 
-#include <asm-generic/signal.h>
+#include <asm-generic/signal-defs.h>
 
 #ifdef __KERNEL__
 struct old_sigaction {
Index: linux-2.6/arch/mips/include/asm/signal.h
===================================================================
--- linux-2.6.orig/arch/mips/include/asm/signal.h
+++ linux-2.6/arch/mips/include/asm/signal.h
@@ -109,7 +109,7 @@ typedef unsigned long old_sigset_t;		/* 
 #define SIG_UNBLOCK	2	/* for unblocking signals */
 #define SIG_SETMASK	3	/* for setting the signal mask */
 
-#include <asm-generic/signal.h>
+#include <asm-generic/signal-defs.h>
 
 struct sigaction {
 	unsigned int	sa_flags;
Index: linux-2.6/arch/mn10300/include/asm/signal.h
===================================================================
--- linux-2.6.orig/arch/mn10300/include/asm/signal.h
+++ linux-2.6/arch/mn10300/include/asm/signal.h
@@ -115,7 +115,7 @@ typedef unsigned long sigset_t;
 #define MINSIGSTKSZ	2048
 #define SIGSTKSZ	8192
 
-#include <asm-generic/signal.h>
+#include <asm-generic/signal-defs.h>
 
 #ifdef __KERNEL__
 struct old_sigaction {
Index: linux-2.6/arch/powerpc/include/asm/signal.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/signal.h
+++ linux-2.6/arch/powerpc/include/asm/signal.h
@@ -94,7 +94,7 @@ typedef struct {
 #define MINSIGSTKSZ	2048
 #define SIGSTKSZ	8192
 
-#include <asm-generic/signal.h>
+#include <asm-generic/signal-defs.h>
 
 struct old_sigaction {
 	__sighandler_t sa_handler;
Index: linux-2.6/arch/s390/include/asm/signal.h
===================================================================
--- linux-2.6.orig/arch/s390/include/asm/signal.h
+++ linux-2.6/arch/s390/include/asm/signal.h
@@ -115,7 +115,7 @@ typedef unsigned long sigset_t;
 #define MINSIGSTKSZ     2048
 #define SIGSTKSZ        8192
 
-#include <asm-generic/signal.h>
+#include <asm-generic/signal-defs.h>
 
 #ifdef __KERNEL__
 struct old_sigaction {
Index: linux-2.6/arch/sh/include/asm/signal.h
===================================================================
--- linux-2.6.orig/arch/sh/include/asm/signal.h
+++ linux-2.6/arch/sh/include/asm/signal.h
@@ -106,7 +106,7 @@ typedef unsigned long sigset_t;
 #define MINSIGSTKSZ	2048
 #define SIGSTKSZ	8192
 
-#include <asm-generic/signal.h>
+#include <asm-generic/signal-defs.h>
 
 #ifdef __KERNEL__
 struct old_sigaction {
Index: linux-2.6/arch/sparc/include/asm/signal.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/signal.h
+++ linux-2.6/arch/sparc/include/asm/signal.h
@@ -176,7 +176,7 @@ struct sigstack {
 #define SA_STATIC_ALLOC         0x8000
 #endif
 
-#include <asm-generic/signal.h>
+#include <asm-generic/signal-defs.h>
 
 struct __new_sigaction {
 	__sighandler_t		sa_handler;
Index: linux-2.6/arch/x86/include/asm/signal.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/signal.h
+++ linux-2.6/arch/x86/include/asm/signal.h
@@ -117,7 +117,7 @@ typedef unsigned long sigset_t;
 #define MINSIGSTKSZ	2048
 #define SIGSTKSZ	8192
 
-#include <asm-generic/signal.h>
+#include <asm-generic/signal-defs.h>
 
 #ifndef __ASSEMBLY__
 
Index: linux-2.6/include/asm-generic/signal-defs.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/signal-defs.h
@@ -0,0 +1,28 @@
+#ifndef __ASM_GENERIC_SIGNAL_DEFS_H
+#define __ASM_GENERIC_SIGNAL_DEFS_H
+
+#include <linux/compiler.h>
+
+#ifndef SIG_BLOCK
+#define SIG_BLOCK          0	/* for blocking signals */
+#endif
+#ifndef SIG_UNBLOCK
+#define SIG_UNBLOCK        1	/* for unblocking signals */
+#endif
+#ifndef SIG_SETMASK
+#define SIG_SETMASK        2	/* for setting the signal mask */
+#endif
+
+#ifndef __ASSEMBLY__
+typedef void __signalfn_t(int);
+typedef __signalfn_t __user *__sighandler_t;
+
+typedef void __restorefn_t(void);
+typedef __restorefn_t __user *__sigrestore_t;
+
+#define SIG_DFL	((__force __sighandler_t)0)	/* default signal handling */
+#define SIG_IGN	((__force __sighandler_t)1)	/* ignore signal */
+#define SIG_ERR	((__force __sighandler_t)-1)	/* error return from signal */
+#endif
+
+#endif /* __ASM_GENERIC_SIGNAL_DEFS_H */
Index: linux-2.6/include/asm-generic/signal.h
===================================================================
--- linux-2.6.orig/include/asm-generic/signal.h
+++ /dev/null
@@ -1,28 +0,0 @@
-#ifndef __ASM_GENERIC_SIGNAL_H
-#define __ASM_GENERIC_SIGNAL_H
-
-#include <linux/compiler.h>
-
-#ifndef SIG_BLOCK
-#define SIG_BLOCK          0	/* for blocking signals */
-#endif
-#ifndef SIG_UNBLOCK
-#define SIG_UNBLOCK        1	/* for unblocking signals */
-#endif
-#ifndef SIG_SETMASK
-#define SIG_SETMASK        2	/* for setting the signal mask */
-#endif
-
-#ifndef __ASSEMBLY__
-typedef void __signalfn_t(int);
-typedef __signalfn_t __user *__sighandler_t;
-
-typedef void __restorefn_t(void);
-typedef __restorefn_t __user *__sigrestore_t;
-
-#define SIG_DFL	((__force __sighandler_t)0)	/* default signal handling */
-#define SIG_IGN	((__force __sighandler_t)1)	/* ignore signal */
-#define SIG_ERR	((__force __sighandler_t)-1)	/* error return from signal */
-#endif
-
-#endif /* __ASM_GENERIC_SIGNAL_H */
Index: linux-2.6/arch/m32r/include/asm/signal.h
===================================================================
--- linux-2.6.orig/arch/m32r/include/asm/signal.h
+++ linux-2.6/arch/m32r/include/asm/signal.h
@@ -107,7 +107,7 @@ typedef unsigned long sigset_t;
 #define MINSIGSTKSZ	2048
 #define SIGSTKSZ	8192
 
-#include <asm-generic/signal.h>
+#include <asm-generic/signal-defs.h>
 
 #ifdef __KERNEL__
 struct old_sigaction {
Index: linux-2.6/arch/microblaze/include/asm/signal.h
===================================================================
--- linux-2.6.orig/arch/microblaze/include/asm/signal.h
+++ linux-2.6/arch/microblaze/include/asm/signal.h
@@ -90,7 +90,7 @@
 
 # ifndef __ASSEMBLY__
 # include <linux/types.h>
-# include <asm-generic/signal.h>
+# include <asm-generic/signal-defs.h>
 
 /* Avoid too many header ordering problems. */
 struct siginfo;
Index: linux-2.6/include/asm-generic/Kbuild
===================================================================
--- linux-2.6.orig/include/asm-generic/Kbuild
+++ linux-2.6/include/asm-generic/Kbuild
@@ -4,7 +4,7 @@ header-y += fcntl.h
 header-y += ioctl.h
 header-y += mman.h
 header-y += poll.h
-header-y += signal.h
+header-y += signal-defs.h
 header-y += statfs.h
 
 unifdef-y += int-l64.h

-- 
