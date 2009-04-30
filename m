From: Arnd Bergmann <arnd@arndb.de>
Subject: diff between asm-generic and x86 headers
Date: Thu, 30 Apr 2009 16:07:19 +0200
Message-ID: <200904301607.20684.arnd@arndb.de>
References: <20090427142010.587518220@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20090427142010.587518220@arndb.de>
Content-Disposition: inline
Sender: linux-arch-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, monstr@monstr.eu, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, liqin.chen@sunplusct.com, Sam Ravnborg <sam@ravnborg.org>, Remis Lima Baima <remis.developer@googlemail.com>
List-Id: linux-api@vger.kernel.org

Since I haven't received any feedback on the contents of my
proposed generic header files, here is a diff relative to the
existing x86 headers, to make it easier to review.

I tried to use either the most sensible or the most common
implementation for each part of the ABI, in some cases
(e.g. unistd.h) rewriting the file from scratch.

	Arnd <><

--- arch/x86/include/asm/auxvec.h	2009-03-31 15:28:48.000000000 +0200
+++ include/asm-generic/auxvec.h	2009-04-29 23:09:11.000000000 +0200
@@ -1,12 +1,8 @@
-#ifndef _ASM_X86_AUXVEC_H
-#define _ASM_X86_AUXVEC_H
+#ifndef __ASM_GENERIC_AUXVEC_H
+#define __ASM_GENERIC_AUXVEC_H
 /*
- * Architecture-neutral AT_ values in 0-17, leave some room
- * for more of them, start the x86-specific ones at 32.
+ * Not all architectures need their own auxvec.h, the most
+ * common definitions are already in linux/auxvec.h.
  */
-#ifdef __i386__
-#define AT_SYSINFO		32
-#endif
-#define AT_SYSINFO_EHDR		33
 
-#endif /* _ASM_X86_AUXVEC_H */
+#endif /* __ASM_GENERIC_AUXVEC_H */
--- arch/x86/include/asm/bitsperlong.h	2009-04-29 23:09:11.000000000 +0200
+++ include/asm-generic/bitsperlong.h	2009-04-29 23:09:11.000000000 +0200
@@ -1,13 +1,32 @@
-#ifndef __ASM_X86_BITSPERLONG_H
-#define __ASM_X86_BITSPERLONG_H
+#ifndef __ASM_GENERIC_BITS_PER_LONG
+#define __ASM_GENERIC_BITS_PER_LONG
 
-#ifdef __x86_64__
-# define __BITS_PER_LONG 64
-#else
-# define __BITS_PER_LONG 32
+/*
+ * There seems to be no way of detecting this automatically from user
+ * space, so 64 bit architectures should override this in their
+ * bitsperlong.h. In particular, an architecture that supports
+ * both 32 and 64 bit user space must not rely on CONFIG_64BIT
+ * to decide it, but rather check a compiler provided macro.
+ */
+#ifndef __BITS_PER_LONG
+#define __BITS_PER_LONG 32
 #endif
 
-#include <asm-generic/bitsperlong.h>
+#ifdef __KERNEL__
+
+#ifdef CONFIG_64BIT
+#define BITS_PER_LONG 64
+#else
+#define BITS_PER_LONG 32
+#endif /* CONFIG_64BIT */
 
-#endif /* __ASM_X86_BITSPERLONG_H */
+/*
+ * FIXME: The check currently breaks x86-64 build, so it's
+ * temporarily disabled. Please fix x86-64 and reenable
+ */
+#if 0 && BITS_PER_LONG != __BITS_PER_LONG
+#error Inconsistent word size. Check asm/bitsperlong.h
+#endif
 
+#endif /* __KERNEL__ */
+#endif /* __ASM_GENERIC_BITS_PER_LONG */
--- arch/x86/include/asm/ioctls.h	2009-03-31 15:28:48.000000000 +0200
+++ include/asm-generic/ioctls.h	2009-04-29 23:09:11.000000000 +0200
@@ -1,12 +1,23 @@
-#ifndef _ASM_X86_IOCTLS_H
-#define _ASM_X86_IOCTLS_H
+#ifndef __ASM_GENERIC_IOCTLS_H
+#define __ASM_GENERIC_IOCTLS_H
 
-#include <asm/ioctl.h>
+#include <linux/ioctl.h>
+
+/*
+ * These are the most common definitions for tty ioctl numbers.
+ * Most of them do not use the recommended _IOC(), but there is
+ * probably some source code out there hardcoding the number,
+ * so we might as well use them for all new platforms.
+ *
+ * The architectures that use different values here typically
+ * try to be compatible with some Unix variants for the same
+ * architecture.
+ */
 
 /* 0x54 is just a magic number to make these relatively unique ('T') */
 
 #define TCGETS		0x5401
-#define TCSETS		0x5402 /* Clashes with SNDCTL_TMR_START sound ioctl */
+#define TCSETS		0x5402
 #define TCSETSW		0x5403
 #define TCSETSF		0x5404
 #define TCGETA		0x5405
@@ -43,7 +54,6 @@
 #define TIOCSETD	0x5423
 #define TIOCGETD	0x5424
 #define TCSBRKP		0x5425	/* Needed for POSIX tcsendbreak() */
-/* #define TIOCTTYGSTRUCT 0x5426 - Former debugging-only ioctl */
 #define TIOCSBRK	0x5427  /* BSD compatibility */
 #define TIOCCBRK	0x5428  /* BSD compatibility */
 #define TIOCGSID	0x5429  /* Return the session ID of FD */
@@ -53,8 +63,7 @@
 #define TCSETSF2	_IOW('T', 0x2D, struct termios2)
 #define TIOCGRS485	0x542E
 #define TIOCSRS485	0x542F
-#define TIOCGPTN	_IOR('T', 0x30, unsigned int)
-				/* Get Pty Number (of pty-mux device) */
+#define TIOCGPTN	_IOR('T', 0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T', 0x31, int)  /* Lock/unlock Pty */
 #define TCGETX		0x5432 /* SYS5 TCGETX compatibility */
 #define TCSETX		0x5433
@@ -76,9 +85,16 @@
 
 #define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
 #define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
-#define TIOCGHAYESESP   0x545E  /* Get Hayes ESP configuration */
-#define TIOCSHAYESESP   0x545F  /* Set Hayes ESP configuration */
-#define FIOQSIZE	0x5460
+
+/*
+ * some architectures define FIOQSIZE as 0x545E, which is used for
+ * TIOCGHAYESESP on others
+ */
+#ifndef FIOQSIZE
+# define TIOCGHAYESESP	0x545E  /* Get Hayes ESP configuration */
+# define TIOCSHAYESESP	0x545F  /* Set Hayes ESP configuration */
+# define FIOQSIZE	0x5460
+#endif
 
 /* Used for packet mode */
 #define TIOCPKT_DATA		 0
@@ -91,4 +107,4 @@
 
 #define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
 
-#endif /* _ASM_X86_IOCTLS_H */
+#endif /* __ASM_GENERIC_IOCTLS_H */
--- arch/x86/include/asm/ipcbuf.h	2009-03-31 15:28:48.000000000 +0200
+++ include/asm-generic/ipcbuf.h	2009-04-29 23:09:11.000000000 +0200
@@ -1,13 +1,18 @@
-#ifndef _ASM_X86_IPCBUF_H
-#define _ASM_X86_IPCBUF_H
+#ifndef __ASM_GENERIC_IPCBUF_H
+#define __ASM_GENERIC_IPCBUF_H
 
 /*
- * The ipc64_perm structure for x86 architecture.
+ * The generic ipc64_perm structure:
  * Note extra padding because this structure is passed back and forth
  * between kernel and user space.
  *
+ * ipc64_perm was originally meant to be architecture specific, but
+ * everyone just ended up making identical copies without specific
+ * optimizations, so we may just as well all use the same one.
+ *
  * Pad space is left for:
- * - 32-bit mode_t and seq
+ * - 32-bit mode_t on architectures that only had 16 bit
+ * - 32-bit seq
  * - 2 miscellaneous 32-bit values
  */
 
@@ -25,4 +30,4 @@
 	unsigned long		__unused2;
 };
 
-#endif /* _ASM_X86_IPCBUF_H */
+#endif /* __ASM_GENERIC_IPCBUF_H */
--- arch/x86/include/asm/mman.h	2009-04-29 23:09:11.000000000 +0200
+++ include/asm-generic/mman.h	2009-04-29 23:09:11.000000000 +0200
@@ -1,10 +1,8 @@
-#ifndef _ASM_X86_MMAN_H
-#define _ASM_X86_MMAN_H
+#ifndef __ASM_GENERIC_MMAN_H
+#define __ASM_GENERIC_MMAN_H
 
 #include <asm-generic/mman-common.h>
 
-#define MAP_32BIT	0x40		/* only give out 32bit addresses */
-
 #define MAP_GROWSDOWN	0x0100		/* stack-like segment */
 #define MAP_DENYWRITE	0x0800		/* ETXTBSY */
 #define MAP_EXECUTABLE	0x1000		/* mark it as an executable */
@@ -17,4 +15,4 @@
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
 
-#endif /* _ASM_X86_MMAN_H */
+#endif /* __ASM_GENERIC_MMAN_H */
--- arch/x86/include/asm/msgbuf.h	2009-03-31 15:28:48.000000000 +0200
+++ include/asm-generic/msgbuf.h	2009-04-29 23:09:11.000000000 +0200
@@ -1,30 +1,38 @@
-#ifndef _ASM_X86_MSGBUF_H
-#define _ASM_X86_MSGBUF_H
+#ifndef __ASM_GENERIC_MSGBUF_H
+#define __ASM_GENERIC_MSGBUF_H
 
+#include <asm/bitsperlong.h>
 /*
- * The msqid64_ds structure for i386 architecture.
+ * generic msqid64_ds structure.
+ *
  * Note extra padding because this structure is passed back and forth
  * between kernel and user space.
  *
- * Pad space on i386 is left for:
+ * msqid64_ds was originally meant to be architecture specific, but
+ * everyone just ended up making identical copies without specific
+ * optimizations, so we may just as well all use the same one.
+ *
+ * 64 bit architectures typically define a 64 bit __kernel_time_t,
+ * so they do not need the first three padding words.
+ * On big-endian systems, the padding is in the wrong place.
+ *
+ * Pad space is left for:
  * - 64-bit time_t to solve y2038 problem
  * - 2 miscellaneous 32-bit values
- *
- * Pad space on x8664 is left for:
- * - 2 miscellaneous 64-bit values
  */
+
 struct msqid64_ds {
 	struct ipc64_perm msg_perm;
 	__kernel_time_t msg_stime;	/* last msgsnd time */
-#ifdef __i386__
+#if __BITS_PER_LONG != 64
 	unsigned long	__unused1;
 #endif
 	__kernel_time_t msg_rtime;	/* last msgrcv time */
-#ifdef __i386__
+#if __BITS_PER_LONG != 64
 	unsigned long	__unused2;
 #endif
 	__kernel_time_t msg_ctime;	/* last change time */
-#ifdef __i386__
+#if __BITS_PER_LONG != 64
 	unsigned long	__unused3;
 #endif
 	unsigned long  msg_cbytes;	/* current number of bytes on queue */
@@ -36,4 +44,4 @@
 	unsigned long  __unused5;
 };
 
-#endif /* _ASM_X86_MSGBUF_H */
+#endif /* __ASM_GENERIC_MSGBUF_H */
--- arch/x86/include/asm/param.h	2009-03-31 15:28:48.000000000 +0200
+++ include/asm-generic/param.h	2009-04-29 23:09:11.000000000 +0200
@@ -1,5 +1,5 @@
-#ifndef _ASM_X86_PARAM_H
-#define _ASM_X86_PARAM_H
+#ifndef __ASM_GENERIC_PARAM_H
+#define __ASM_GENERIC_PARAM_H
 
 #ifdef __KERNEL__
 # define HZ		CONFIG_HZ	/* Internal kernel timer frequency */
@@ -11,7 +11,9 @@
 #define HZ 100
 #endif
 
+#ifndef EXEC_PAGESIZE
 #define EXEC_PAGESIZE	4096
+#endif
 
 #ifndef NOGROUP
 #define NOGROUP		(-1)
@@ -19,4 +21,4 @@
 
 #define MAXHOSTNAMELEN	64	/* max length of hostname */
 
-#endif /* _ASM_X86_PARAM_H */
+#endif /* __ASM_GENERIC_PARAM_H */
--- arch/x86/include/asm/posix_types_64.h	2009-03-31 15:28:48.000000000 +0200
+++ include/asm-generic/posix_types.h	2009-04-29 23:09:11.000000000 +0200
@@ -1,119 +1,166 @@
-#ifndef _ASM_X86_POSIX_TYPES_64_H
-#define _ASM_X86_POSIX_TYPES_64_H
+#ifndef __ASM_GENERIC_POSIX_TYPES_H
+#define __ASM_GENERIC_POSIX_TYPES_H
+
+#include <linux/types.h>
 
 /*
  * This file is generally used by user-level software, so you need to
- * be a little careful about namespace pollution etc.  Also, we cannot
- * assume GCC is being used.
+ * be a little careful about namespace pollution etc.
+ *
+ * First the types that are often defined in different ways across
+ * architectures, so that you can override them.
  */
 
+#ifndef __kernel_ino_t
 typedef unsigned long	__kernel_ino_t;
+#endif
+
+#ifndef __kernel_mode_t
 typedef unsigned int	__kernel_mode_t;
+#endif
+
+#ifndef __kernel_nlink_t
 typedef unsigned long	__kernel_nlink_t;
-typedef long		__kernel_off_t;
+#endif
+
+#ifndef __kernel_pid_t
 typedef int		__kernel_pid_t;
+#endif
+
+#ifndef __kernel_ipc_pid_t
 typedef int		__kernel_ipc_pid_t;
+#endif
+
+#ifndef __kernel_uid_t
 typedef unsigned int	__kernel_uid_t;
 typedef unsigned int	__kernel_gid_t;
+#endif
+
+#ifndef __kernel_suseconds_t
+typedef long		__kernel_suseconds_t;
+#endif
+
+#ifndef __kernel_daddr_t
+typedef int		__kernel_daddr_t;
+#endif
+
+#ifndef __kernel_uid32_t
+typedef __kernel_uid_t	__kernel_uid32_t;
+typedef __kernel_gid_t	__kernel_gid32_t;
+#endif
+
+#ifndef __kernel_old_uid_t
+typedef __kernel_uid_t	__kernel_old_uid_t;
+typedef __kernel_gid_t	__kernel_old_gid_t;
+#endif
+
+#ifndef __kernel_old_dev_t
+typedef unsigned int	__kernel_old_dev_t;
+#endif
+
+/*
+ * Most 32 bit architectures use "unsigned int" size_t,
+ * and all 64 bit architectures use "unsigned long" size_t.
+ */
+#ifndef __kernel_size_t
+#if __BITS_PER_LONG != 64
+typedef unsigned int	__kernel_size_t;
+typedef int		__kernel_ssize_t;
+typedef int		__kernel_ptrdiff_t;
+#else
 typedef unsigned long	__kernel_size_t;
 typedef long		__kernel_ssize_t;
 typedef long		__kernel_ptrdiff_t;
+#endif
+#endif
+
+/*
+ * anything below here should be completely generic
+ */
+typedef long		__kernel_off_t;
+typedef long long	__kernel_loff_t;
 typedef long		__kernel_time_t;
-typedef long		__kernel_suseconds_t;
 typedef long		__kernel_clock_t;
 typedef int		__kernel_timer_t;
 typedef int		__kernel_clockid_t;
-typedef int		__kernel_daddr_t;
 typedef char *		__kernel_caddr_t;
 typedef unsigned short	__kernel_uid16_t;
 typedef unsigned short	__kernel_gid16_t;
 
-#ifdef __GNUC__
-typedef long long	__kernel_loff_t;
-#endif
-
 typedef struct {
 	int	val[2];
 } __kernel_fsid_t;
 
-typedef unsigned short __kernel_old_uid_t;
-typedef unsigned short __kernel_old_gid_t;
-typedef __kernel_uid_t __kernel_uid32_t;
-typedef __kernel_gid_t __kernel_gid32_t;
-
-typedef unsigned long	__kernel_old_dev_t;
-
 #ifdef __KERNEL__
 
 #undef __FD_SET
-static inline void __FD_SET(unsigned long fd, __kernel_fd_set *fdsetp)
+static inline void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
 {
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	fdsetp->fds_bits[_tmp] |= (1UL<<_rem);
+	unsigned long __tmp = __fd / __NFDBITS;
+	unsigned long __rem = __fd % __NFDBITS;
+	__fdsetp->fds_bits[__tmp] |= (1UL<<__rem);
 }
 
 #undef __FD_CLR
-static inline void __FD_CLR(unsigned long fd, __kernel_fd_set *fdsetp)
+static inline void __FD_CLR(unsigned long __fd, __kernel_fd_set *__fdsetp)
 {
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	fdsetp->fds_bits[_tmp] &= ~(1UL<<_rem);
+	unsigned long __tmp = __fd / __NFDBITS;
+	unsigned long __rem = __fd % __NFDBITS;
+	__fdsetp->fds_bits[__tmp] &= ~(1UL<<__rem);
 }
 
 #undef __FD_ISSET
-static inline int __FD_ISSET(unsigned long fd, __const__ __kernel_fd_set *p)
+static inline int __FD_ISSET(unsigned long __fd, const __kernel_fd_set *__p)
 {
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	return (p->fds_bits[_tmp] & (1UL<<_rem)) != 0;
+	unsigned long __tmp = __fd / __NFDBITS;
+	unsigned long __rem = __fd % __NFDBITS;
+	return (__p->fds_bits[__tmp] & (1UL<<__rem)) != 0;
 }
 
 /*
- * This will unroll the loop for the normal constant cases (8 or 32 longs,
- * for 256 and 1024-bit fd_sets respectively)
+ * This will unroll the loop for the normal constant case (8 ints,
+ * for a 256-bit fd_set)
  */
 #undef __FD_ZERO
-static inline void __FD_ZERO(__kernel_fd_set *p)
+static inline void __FD_ZERO(__kernel_fd_set *__p)
 {
-	unsigned long *tmp = p->fds_bits;
-	int i;
+	unsigned long *__tmp = __p->fds_bits;
+	int __i;
 
 	if (__builtin_constant_p(__FDSET_LONGS)) {
 		switch (__FDSET_LONGS) {
-		case 32:
-			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
-			tmp[ 8] = 0; tmp[ 9] = 0; tmp[10] = 0; tmp[11] = 0;
-			tmp[12] = 0; tmp[13] = 0; tmp[14] = 0; tmp[15] = 0;
-			tmp[16] = 0; tmp[17] = 0; tmp[18] = 0; tmp[19] = 0;
-			tmp[20] = 0; tmp[21] = 0; tmp[22] = 0; tmp[23] = 0;
-			tmp[24] = 0; tmp[25] = 0; tmp[26] = 0; tmp[27] = 0;
-			tmp[28] = 0; tmp[29] = 0; tmp[30] = 0; tmp[31] = 0;
-			return;
 		case 16:
-			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
-			tmp[ 8] = 0; tmp[ 9] = 0; tmp[10] = 0; tmp[11] = 0;
-			tmp[12] = 0; tmp[13] = 0; tmp[14] = 0; tmp[15] = 0;
+			__tmp[ 0] = 0; __tmp[ 1] = 0;
+			__tmp[ 2] = 0; __tmp[ 3] = 0;
+			__tmp[ 4] = 0; __tmp[ 5] = 0;
+			__tmp[ 6] = 0; __tmp[ 7] = 0;
+			__tmp[ 8] = 0; __tmp[ 9] = 0;
+			__tmp[10] = 0; __tmp[11] = 0;
+			__tmp[12] = 0; __tmp[13] = 0;
+			__tmp[14] = 0; __tmp[15] = 0;
 			return;
+
 		case 8:
-			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
+			__tmp[ 0] = 0; __tmp[ 1] = 0;
+			__tmp[ 2] = 0; __tmp[ 3] = 0;
+			__tmp[ 4] = 0; __tmp[ 5] = 0;
+			__tmp[ 6] = 0; __tmp[ 7] = 0;
 			return;
+
 		case 4:
-			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
+			__tmp[ 0] = 0; __tmp[ 1] = 0;
+			__tmp[ 2] = 0; __tmp[ 3] = 0;
 			return;
 		}
 	}
-	i = __FDSET_LONGS;
-	while (i) {
-		i--;
-		*tmp = 0;
-		tmp++;
+	__i = __FDSET_LONGS;
+	while (__i) {
+		__i--;
+		*__tmp = 0;
+		__tmp++;
 	}
 }
 
-#endif /* defined(__KERNEL__) */
+#endif /* __KERNEL__ */
 
-#endif /* _ASM_X86_POSIX_TYPES_64_H */
+#endif /* __ASM_GENERIC_POSIX_TYPES_H */
--- arch/x86/include/asm/sembuf.h	2009-03-31 15:28:48.000000000 +0200
+++ include/asm-generic/sembuf.h	2009-04-29 23:09:11.000000000 +0200
@@ -1,11 +1,21 @@
-#ifndef _ASM_X86_SEMBUF_H
-#define _ASM_X86_SEMBUF_H
+#ifndef __ASM_GENERIC_SEMBUF_H
+#define __ASM_GENERIC_SEMBUF_H
+
+#include <asm/bitsperlong.h>
 
 /*
  * The semid64_ds structure for x86 architecture.
  * Note extra padding because this structure is passed back and forth
  * between kernel and user space.
  *
+ * semid64_ds was originally meant to be architecture specific, but
+ * everyone just ended up making identical copies without specific
+ * optimizations, so we may just as well all use the same one.
+ *
+ * 64 bit architectures typically define a 64 bit __kernel_time_t,
+ * so they do not need the first two padding words.
+ * On big-endian systems, the padding is in the wrong place.
+ *
  * Pad space is left for:
  * - 64-bit time_t to solve y2038 problem
  * - 2 miscellaneous 32-bit values
@@ -13,12 +23,16 @@
 struct semid64_ds {
 	struct ipc64_perm sem_perm;	/* permissions .. see ipc.h */
 	__kernel_time_t	sem_otime;	/* last semop time */
+#if __BITS_PER_LONG != 64
 	unsigned long	__unused1;
+#endif
 	__kernel_time_t	sem_ctime;	/* last change time */
+#if __BITS_PER_LONG != 64
 	unsigned long	__unused2;
+#endif
 	unsigned long	sem_nsems;	/* no. of semaphores in array */
 	unsigned long	__unused3;
 	unsigned long	__unused4;
 };
 
-#endif /* _ASM_X86_SEMBUF_H */
+#endif /* __ASM_GENERIC_SEMBUF_H */
--- arch/x86/include/asm/setup.h	2009-04-01 15:20:40.000000000 +0200
+++ include/asm-generic/setup.h	2009-04-29 23:09:11.000000000 +0200
@@ -1,151 +1,6 @@
-#ifndef _ASM_X86_SETUP_H
-#define _ASM_X86_SETUP_H
+#ifndef __ASM_GENERIC_SETUP_H
+#define __ASM_GENERIC_SETUP_H
 
-#ifdef __KERNEL__
+#define COMMAND_LINE_SIZE	512
 
-#define COMMAND_LINE_SIZE 2048
-
-#ifndef __ASSEMBLY__
-
-/*
- * Any setup quirks to be performed?
- */
-struct mpc_cpu;
-struct mpc_bus;
-struct mpc_oemtable;
-
-struct x86_quirks {
-	int (*arch_pre_time_init)(void);
-	int (*arch_time_init)(void);
-	int (*arch_pre_intr_init)(void);
-	int (*arch_intr_init)(void);
-	int (*arch_trap_init)(void);
-	char * (*arch_memory_setup)(void);
-	int (*mach_get_smp_config)(unsigned int early);
-	int (*mach_find_smp_config)(unsigned int reserve);
-
-	int *mpc_record;
-	int (*mpc_apic_id)(struct mpc_cpu *m);
-	void (*mpc_oem_bus_info)(struct mpc_bus *m, char *name);
-	void (*mpc_oem_pci_bus)(struct mpc_bus *m);
-	void (*smp_read_mpc_oem)(struct mpc_oemtable *oemtable,
-				unsigned short oemsize);
-	int (*setup_ioapic_ids)(void);
-};
-
-extern void x86_quirk_pre_intr_init(void);
-extern void x86_quirk_intr_init(void);
-
-extern void x86_quirk_trap_init(void);
-
-extern void x86_quirk_pre_time_init(void);
-extern void x86_quirk_time_init(void);
-
-#endif /* __ASSEMBLY__ */
-
-#ifdef __i386__
-
-#include <linux/pfn.h>
-/*
- * Reserved space for vmalloc and iomap - defined in asm/page.h
- */
-#define MAXMEM_PFN	PFN_DOWN(MAXMEM)
-#define MAX_NONPAE_PFN	(1 << 20)
-
-#endif /* __i386__ */
-
-#define PARAM_SIZE 4096		/* sizeof(struct boot_params) */
-
-#define OLD_CL_MAGIC		0xA33F
-#define OLD_CL_ADDRESS		0x020	/* Relative to real mode data */
-#define NEW_CL_POINTER		0x228	/* Relative to real mode data */
-
-#ifndef __ASSEMBLY__
-#include <asm/bootparam.h>
-
-/* Interrupt control for vSMPowered x86_64 systems */
-#ifdef CONFIG_X86_64
-void vsmp_init(void);
-#else
-static inline void vsmp_init(void) { }
-#endif
-
-void setup_bios_corruption_check(void);
-
-#ifdef CONFIG_X86_VISWS
-extern void visws_early_detect(void);
-extern int is_visws_box(void);
-#else
-static inline void visws_early_detect(void) { }
-static inline int is_visws_box(void) { return 0; }
-#endif
-
-extern struct x86_quirks *x86_quirks;
-extern unsigned long saved_video_mode;
-
-#ifndef CONFIG_PARAVIRT
-#define paravirt_post_allocator_init()	do {} while (0)
-#endif
-
-#ifndef _SETUP
-
-/*
- * This is set up by the setup-routine at boot-time
- */
-extern struct boot_params boot_params;
-
-/*
- * Do NOT EVER look at the BIOS memory size location.
- * It does not work on many machines.
- */
-#define LOWMEMSIZE()	(0x9f000)
-
-/* exceedingly early brk-like allocator */
-extern unsigned long _brk_end;
-void *extend_brk(size_t size, size_t align);
-
-/*
- * Reserve space in the brk section.  The name must be unique within
- * the file, and somewhat descriptive.  The size is in bytes.  Must be
- * used at file scope.
- *
- * (This uses a temp function to wrap the asm so we can pass it the
- * size parameter; otherwise we wouldn't be able to.  We can't use a
- * "section" attribute on a normal variable because it always ends up
- * being @progbits, which ends up allocating space in the vmlinux
- * executable.)
- */
-#define RESERVE_BRK(name,sz)						\
-	static void __section(.discard) __used				\
-	__brk_reservation_fn_##name##__(void) {				\
-		asm volatile (						\
-			".pushsection .brk_reservation,\"aw\",@nobits;" \
-			".brk." #name ":"				\
-			" 1:.skip %c0;"					\
-			" .size .brk." #name ", . - 1b;"		\
-			" .popsection"					\
-			: : "i" (sz));					\
-	}
-
-#ifdef __i386__
-
-void __init i386_start_kernel(void);
-extern void probe_roms(void);
-
-#else
-void __init x86_64_start_kernel(char *real_mode);
-void __init x86_64_start_reservations(char *real_mode_data);
-
-#endif /* __i386__ */
-#endif /* _SETUP */
-#else
-#define RESERVE_BRK(name,sz)				\
-	.pushsection .brk_reservation,"aw",@nobits;	\
-.brk.name:						\
-1:	.skip sz;					\
-	.size .brk.name,.-1b;				\
-	.popsection
-#endif /* __ASSEMBLY__ */
-#endif  /*  __KERNEL__  */
-
-#endif /* _ASM_X86_SETUP_H */
+#endif	/* __ASM_GENERIC_SETUP_H */
--- arch/x86/include/asm/shmbuf.h	2009-03-31 15:28:48.000000000 +0200
+++ include/asm-generic/shmbuf.h	2009-04-29 23:09:11.000000000 +0200
@@ -1,32 +1,40 @@
-#ifndef _ASM_X86_SHMBUF_H
-#define _ASM_X86_SHMBUF_H
+#ifndef __ASM_GENERIC_SHMBUF_H
+#define __ASM_GENERIC_SHMBUF_H
+
+#include <asm/bitsperlong.h>
 
 /*
  * The shmid64_ds structure for x86 architecture.
  * Note extra padding because this structure is passed back and forth
  * between kernel and user space.
  *
- * Pad space on 32 bit is left for:
+ * shmid64_ds was originally meant to be architecture specific, but
+ * everyone just ended up making identical copies without specific
+ * optimizations, so we may just as well all use the same one.
+ *
+ * 64 bit architectures typically define a 64 bit __kernel_time_t,
+ * so they do not need the first two padding words.
+ * On big-endian systems, the padding is in the wrong place.
+ *
+ *
+ * Pad space is left for:
  * - 64-bit time_t to solve y2038 problem
  * - 2 miscellaneous 32-bit values
- *
- * Pad space on 64 bit is left for:
- * - 2 miscellaneous 64-bit values
  */
 
 struct shmid64_ds {
 	struct ipc64_perm	shm_perm;	/* operation perms */
 	size_t			shm_segsz;	/* size of segment (bytes) */
 	__kernel_time_t		shm_atime;	/* last attach time */
-#ifdef __i386__
+#if __BITS_PER_LONG != 64
 	unsigned long		__unused1;
 #endif
 	__kernel_time_t		shm_dtime;	/* last detach time */
-#ifdef __i386__
+#if __BITS_PER_LONG != 64
 	unsigned long		__unused2;
 #endif
 	__kernel_time_t		shm_ctime;	/* last change time */
-#ifdef __i386__
+#if __BITS_PER_LONG != 64
 	unsigned long		__unused3;
 #endif
 	__kernel_pid_t		shm_cpid;	/* pid of creator */
@@ -48,4 +56,4 @@
 	unsigned long	__unused4;
 };
 
-#endif /* _ASM_X86_SHMBUF_H */
+#endif /* __ASM_GENERIC_SHMBUF_H */
--- arch/x86/include/asm/shmparam.h	2009-03-31 15:28:48.000000000 +0200
+++ include/asm-generic/shmparam.h	2009-04-29 23:09:11.000000000 +0200
@@ -1,6 +1,6 @@
-#ifndef _ASM_X86_SHMPARAM_H
-#define _ASM_X86_SHMPARAM_H
+#ifndef __ASM_GENERIC_SHMPARAM_H
+#define __ASM_GENERIC_SHMPARAM_H
 
 #define SHMLBA PAGE_SIZE	 /* attach addr a multiple of this */
 
-#endif /* _ASM_X86_SHMPARAM_H */
+#endif /* _ASM_GENERIC_SHMPARAM_H */
--- arch/x86/include/asm/signal.h	2009-04-29 23:09:11.000000000 +0200
+++ include/asm-generic/signal.h	2009-04-29 23:09:11.000000000 +0200
@@ -1,45 +1,12 @@
-#ifndef _ASM_X86_SIGNAL_H
-#define _ASM_X86_SIGNAL_H
+#ifndef __ASM_GENERIC_SIGNAL_H
+#define __ASM_GENERIC_SIGNAL_H
 
-#ifndef __ASSEMBLY__
 #include <linux/types.h>
-#include <linux/time.h>
-#include <linux/compiler.h>
-
-/* Avoid too many header ordering problems.  */
-struct siginfo;
-
-#ifdef __KERNEL__
-#include <linux/linkage.h>
-
-/* Most things should be clean enough to redefine this at will, if care
-   is taken to make libc match.  */
 
 #define _NSIG		64
-
-#ifdef __i386__
-# define _NSIG_BPW	32
-#else
-# define _NSIG_BPW	64
-#endif
-
+#define _NSIG_BPW	__BITS_PER_LONG
 #define _NSIG_WORDS	(_NSIG / _NSIG_BPW)
 
-typedef unsigned long old_sigset_t;		/* at least 32 bits */
-
-typedef struct {
-	unsigned long sig[_NSIG_WORDS];
-} sigset_t;
-
-#else
-/* Here we must cater to libcs that poke about in kernel headers.  */
-
-#define NSIG		32
-typedef unsigned long sigset_t;
-
-#endif /* __KERNEL__ */
-#endif /* __ASSEMBLY__ */
-
 #define SIGHUP		 1
 #define SIGINT		 2
 #define SIGQUIT		 3
@@ -80,7 +47,9 @@
 
 /* These should not be considered constants from userland.  */
 #define SIGRTMIN	32
+#ifndef SIGRTMAX
 #define SIGRTMAX	_NSIG
+#endif
 
 /*
  * SA_FLAGS values:
@@ -95,18 +64,21 @@
  * SA_ONESHOT and SA_NOMASK are the historical Linux names for the Single
  * Unix names RESETHAND and NODEFER respectively.
  */
-#define SA_NOCLDSTOP	0x00000001u
-#define SA_NOCLDWAIT	0x00000002u
-#define SA_SIGINFO	0x00000004u
-#define SA_ONSTACK	0x08000000u
-#define SA_RESTART	0x10000000u
-#define SA_NODEFER	0x40000000u
-#define SA_RESETHAND	0x80000000u
+#define SA_NOCLDSTOP	0x00000001
+#define SA_NOCLDWAIT	0x00000002
+#define SA_SIGINFO	0x00000004
+#define SA_ONSTACK	0x08000000
+#define SA_RESTART	0x10000000
+#define SA_NODEFER	0x40000000
+#define SA_RESETHAND	0x80000000
 
 #define SA_NOMASK	SA_NODEFER
 #define SA_ONESHOT	SA_RESETHAND
 
-#define SA_RESTORER	0x04000000
+/*
+ * New architectures should not define the obsolete
+ *	SA_RESTORER	0x04000000
+ */
 
 /*
  * sigaltstack controls
@@ -117,57 +89,22 @@
 #define MINSIGSTKSZ	2048
 #define SIGSTKSZ	8192
 
-#include <asm-generic/signal-defs.h>
-
 #ifndef __ASSEMBLY__
+typedef struct {
+	unsigned long sig[_NSIG_WORDS];
+} sigset_t;
 
-# ifdef __KERNEL__
-extern void do_notify_resume(struct pt_regs *, void *, __u32);
-# endif /* __KERNEL__ */
-
-#ifdef __i386__
-# ifdef __KERNEL__
-struct old_sigaction {
-	__sighandler_t sa_handler;
-	old_sigset_t sa_mask;
-	unsigned long sa_flags;
-	__sigrestore_t sa_restorer;
-};
-
-struct sigaction {
-	__sighandler_t sa_handler;
-	unsigned long sa_flags;
-	__sigrestore_t sa_restorer;
-	sigset_t sa_mask;		/* mask last for extensibility */
-};
-
-struct k_sigaction {
-	struct sigaction sa;
-};
-
-# else /* __KERNEL__ */
-/* Here we must cater to libcs that poke about in kernel headers.  */
-
-struct sigaction {
-	union {
-	  __sighandler_t _sa_handler;
-	  void (*_sa_sigaction)(int, struct siginfo *, void *);
-	} _u;
-	sigset_t sa_mask;
-	unsigned long sa_flags;
-	void (*sa_restorer)(void);
-};
-
-#define sa_handler	_u._sa_handler
-#define sa_sigaction	_u._sa_sigaction
+/* not actually used, but required for linux/syscalls.h */
+typedef unsigned long old_sigset_t;
 
-# endif /* ! __KERNEL__ */
-#else /* __i386__ */
+#include <asm-generic/signal-defs.h>
 
 struct sigaction {
 	__sighandler_t sa_handler;
 	unsigned long sa_flags;
+#ifdef SA_RESTORER
 	__sigrestore_t sa_restorer;
+#endif
 	sigset_t sa_mask;		/* mask last for extensibility */
 };
 
@@ -175,8 +112,6 @@
 	struct sigaction sa;
 };
 
-#endif /* !__i386__ */
-
 typedef struct sigaltstack {
 	void __user *ss_sp;
 	int ss_flags;
@@ -184,81 +119,13 @@
 } stack_t;
 
 #ifdef __KERNEL__
-#include <asm/sigcontext.h>
-
-#ifdef __i386__
-
-#define __HAVE_ARCH_SIG_BITOPS
-
-#define sigaddset(set,sig)		    \
-	(__builtin_constant_p(sig)	    \
-	 ? __const_sigaddset((set), (sig))  \
-	 : __gen_sigaddset((set), (sig)))
-
-static inline void __gen_sigaddset(sigset_t *set, int _sig)
-{
-	asm("btsl %1,%0" : "+m"(*set) : "Ir"(_sig - 1) : "cc");
-}
-
-static inline void __const_sigaddset(sigset_t *set, int _sig)
-{
-	unsigned long sig = _sig - 1;
-	set->sig[sig / _NSIG_BPW] |= 1 << (sig % _NSIG_BPW);
-}
-
-#define sigdelset(set, sig)		    \
-	(__builtin_constant_p(sig)	    \
-	 ? __const_sigdelset((set), (sig))  \
-	 : __gen_sigdelset((set), (sig)))
-
-
-static inline void __gen_sigdelset(sigset_t *set, int _sig)
-{
-	asm("btrl %1,%0" : "+m"(*set) : "Ir"(_sig - 1) : "cc");
-}
-
-static inline void __const_sigdelset(sigset_t *set, int _sig)
-{
-	unsigned long sig = _sig - 1;
-	set->sig[sig / _NSIG_BPW] &= ~(1 << (sig % _NSIG_BPW));
-}
-
-static inline int __const_sigismember(sigset_t *set, int _sig)
-{
-	unsigned long sig = _sig - 1;
-	return 1 & (set->sig[sig / _NSIG_BPW] >> (sig % _NSIG_BPW));
-}
-
-static inline int __gen_sigismember(sigset_t *set, int _sig)
-{
-	int ret;
-	asm("btl %2,%1\n\tsbbl %0,%0"
-	    : "=r"(ret) : "m"(*set), "Ir"(_sig-1) : "cc");
-	return ret;
-}
-
-#define sigismember(set, sig)			\
-	(__builtin_constant_p(sig)		\
-	 ? __const_sigismember((set), (sig))	\
-	 : __gen_sigismember((set), (sig)))
-
-static inline int sigfindinword(unsigned long word)
-{
-	asm("bsfl %1,%0" : "=r"(word) : "rm"(word) : "cc");
-	return word;
-}
-
-struct pt_regs;
-
-#else /* __i386__ */
 
+#include <asm/sigcontext.h>
 #undef __HAVE_ARCH_SIG_BITOPS
 
-#endif /* !__i386__ */
-
 #define ptrace_signal_deliver(regs, cookie) do { } while (0)
 
 #endif /* __KERNEL__ */
 #endif /* __ASSEMBLY__ */
 
-#endif /* _ASM_X86_SIGNAL_H */
+#endif /* _ASM_GENERIC_SIGNAL_H */
--- arch/x86/include/asm/socket.h	2009-04-01 15:20:40.000000000 +0200
+++ include/asm-generic/socket.h	2009-04-29 23:09:11.000000000 +0200
@@ -1,5 +1,5 @@
-#ifndef _ASM_X86_SOCKET_H
-#define _ASM_X86_SOCKET_H
+#ifndef __ASM_GENERIC_SOCKET_H
+#define __ASM_GENERIC_SOCKET_H
 
 #include <asm/sockios.h>
 
@@ -57,4 +57,4 @@
 #define SO_TIMESTAMPING		37
 #define SCM_TIMESTAMPING	SO_TIMESTAMPING
 
-#endif /* _ASM_X86_SOCKET_H */
+#endif /* __ASM_GENERIC_SOCKET_H */
--- arch/x86/include/asm/sockios.h	2009-03-31 15:28:48.000000000 +0200
+++ include/asm-generic/sockios.h	2009-04-29 23:09:11.000000000 +0200
@@ -1,5 +1,5 @@
-#ifndef _ASM_X86_SOCKIOS_H
-#define _ASM_X86_SOCKIOS_H
+#ifndef __ASM_GENERIC_SOCKIOS_H
+#define __ASM_GENERIC_SOCKIOS_H
 
 /* Socket-level I/O control calls. */
 #define FIOSETOWN	0x8901
@@ -10,4 +10,4 @@
 #define SIOCGSTAMP	0x8906		/* Get stamp (timeval) */
 #define SIOCGSTAMPNS	0x8907		/* Get stamp (timespec) */
 
-#endif /* _ASM_X86_SOCKIOS_H */
+#endif /* __ASM_GENERIC_SOCKIOS_H */
--- arch/x86/include/asm/stat.h	2009-03-31 15:28:48.000000000 +0200
+++ include/asm-generic/stat.h	2009-04-29 23:09:11.000000000 +0200
@@ -1,114 +1,72 @@
-#ifndef _ASM_X86_STAT_H
-#define _ASM_X86_STAT_H
+#ifndef __ASM_GENERIC_STAT_H
+#define __ASM_GENERIC_STAT_H
 
-#define STAT_HAVE_NSEC 1
-
-#ifdef __i386__
-struct stat {
-	unsigned long  st_dev;
-	unsigned long  st_ino;
-	unsigned short st_mode;
-	unsigned short st_nlink;
-	unsigned short st_uid;
-	unsigned short st_gid;
-	unsigned long  st_rdev;
-	unsigned long  st_size;
-	unsigned long  st_blksize;
-	unsigned long  st_blocks;
-	unsigned long  st_atime;
-	unsigned long  st_atime_nsec;
-	unsigned long  st_mtime;
-	unsigned long  st_mtime_nsec;
-	unsigned long  st_ctime;
-	unsigned long  st_ctime_nsec;
-	unsigned long  __unused4;
-	unsigned long  __unused5;
-};
-
-#define STAT64_HAS_BROKEN_ST_INO	1
-
-/* This matches struct stat64 in glibc2.1, hence the absolutely
- * insane amounts of padding around dev_t's.
+/*
+ * Everybody gets this wrong and has to stick with it for all
+ * eternity. Hopefully, this version gets used by new architectures
+ * so they don't fall into the same traps.
+ *
+ * stat64 is copied from powerpc64, with explicit padding added.
+ * stat is the same structure layout on 64-bit, without the 'long long'
+ * types.
+ *
+ * By convention, 64 bit architectures use the stat interface, while
+ * 32 bit architectures use the stat64 interface. Note that we don't
+ * provide an __old_kernel_stat here, which new architecture should
+ * not have to start with.
  */
-struct stat64 {
-	unsigned long long	st_dev;
-	unsigned char	__pad0[4];
-
-	unsigned long	__st_ino;
-
-	unsigned int	st_mode;
-	unsigned int	st_nlink;
-
-	unsigned long	st_uid;
-	unsigned long	st_gid;
-
-	unsigned long long	st_rdev;
-	unsigned char	__pad3[4];
-
-	long long	st_size;
-	unsigned long	st_blksize;
-
-	/* Number 512-byte blocks allocated. */
-	unsigned long long	st_blocks;
 
-	unsigned long	st_atime;
-	unsigned long	st_atime_nsec;
+#include <asm/bitsperlong.h>
 
-	unsigned long	st_mtime;
-	unsigned int	st_mtime_nsec;
-
-	unsigned long	st_ctime;
-	unsigned long	st_ctime_nsec;
-
-	unsigned long long	st_ino;
-};
-
-#else /* __i386__ */
+#define STAT_HAVE_NSEC 1
 
 struct stat {
-	unsigned long	st_dev;
-	unsigned long	st_ino;
-	unsigned long	st_nlink;
-
-	unsigned int	st_mode;
-	unsigned int	st_uid;
-	unsigned int	st_gid;
-	unsigned int	__pad0;
-	unsigned long	st_rdev;
-	long		st_size;
-	long		st_blksize;
+	unsigned long	st_dev;		/* Device.  */
+	unsigned long	st_ino;		/* File serial number.  */
+	unsigned int	st_mode;	/* File mode.  */
+	unsigned int	st_nlink;	/* Link count.  */
+	unsigned int	st_uid;		/* User ID of the file's owner.  */
+	unsigned int	st_gid;		/* Group ID of the file's group. */
+	unsigned long	st_rdev;	/* Device number, if device.  */
+	unsigned long	__pad1;
+	long		st_size;	/* Size of file, in bytes.  */
+	int		st_blksize;	/* Optimal block size for I/O.  */
+	int		__pad2;
 	long		st_blocks;	/* Number 512-byte blocks allocated. */
-
-	unsigned long	st_atime;
-	unsigned long	st_atime_nsec;
-	unsigned long	st_mtime;
-	unsigned long	st_mtime_nsec;
-	unsigned long	st_ctime;
-	unsigned long   st_ctime_nsec;
-	long		__unused[3];
+	int		st_atime;	/* Time of last access.  */
+	unsigned int	st_atime_nsec;
+	int		st_mtime;	/* Time of last modification.  */
+	unsigned int	st_mtime_nsec;
+	int		st_ctime;	/* Time of last status change.  */
+	unsigned int	st_ctime_nsec;
+	unsigned int	__unused4;
+	unsigned int	__unused5;
 };
-#endif
 
-/* for 32bit emulation and 32 bit kernels */
-struct __old_kernel_stat {
-	unsigned short st_dev;
-	unsigned short st_ino;
-	unsigned short st_mode;
-	unsigned short st_nlink;
-	unsigned short st_uid;
-	unsigned short st_gid;
-	unsigned short st_rdev;
-#ifdef __i386__
-	unsigned long  st_size;
-	unsigned long  st_atime;
-	unsigned long  st_mtime;
-	unsigned long  st_ctime;
-#else
-	unsigned int  st_size;
-	unsigned int  st_atime;
-	unsigned int  st_mtime;
-	unsigned int  st_ctime;
-#endif
+#if __BITS_PER_LONG != 64
+/* This matches struct stat64 in glibc2.1. Only used for 32 bit. */
+struct stat64 {
+	unsigned long long st_dev;	/* Device.  */
+	unsigned long long st_ino;	/* File serial number.  */
+	unsigned int	st_mode;	/* File mode.  */
+	unsigned int	st_nlink;	/* Link count.  */
+	unsigned int	st_uid;		/* User ID of the file's owner.  */
+	unsigned int	st_gid;		/* Group ID of the file's group. */
+	unsigned long long st_rdev;	/* Device number, if device.  */
+	unsigned long long __pad1;
+	long long	st_size;	/* Size of file, in bytes.  */
+	int		st_blksize;	/* Optimal block size for I/O.  */
+	int		__pad2;
+	long long	st_blocks;	/* Number 512-byte blocks allocated. */
+	int		st_atime;	/* Time of last access.  */
+	unsigned int	st_atime_nsec;
+	int		st_mtime;	/* Time of last modification.  */
+	unsigned int	st_mtime_nsec;
+	int		st_ctime;	/* Time of last status change.  */
+	unsigned int	st_ctime_nsec;
+	unsigned int	__unused4;
+	unsigned int	__unused5;
 };
+#endif
 
-#endif /* _ASM_X86_STAT_H */
+#endif /* __ASM_GENERIC_STAT_H */
--- arch/x86/include/asm/swab.h	2009-03-31 20:24:11.000000000 +0200
+++ include/asm-generic/swab.h	2009-04-29 23:09:11.000000000 +0200
@@ -1,61 +1,18 @@
-#ifndef _ASM_X86_SWAB_H
-#define _ASM_X86_SWAB_H
+#ifndef _ASM_GENERIC_SWAB_H
+#define _ASM_GENERIC_SWAB_H
 
-#include <linux/types.h>
-#include <linux/compiler.h>
+#include <asm/bitsperlong.h>
 
-static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
-{
-#ifdef __i386__
-# ifdef CONFIG_X86_BSWAP
-	asm("bswap %0" : "=r" (val) : "0" (val));
-# else
-	asm("xchgb %b0,%h0\n\t"	/* swap lower bytes	*/
-	    "rorl $16,%0\n\t"	/* swap words		*/
-	    "xchgb %b0,%h0"	/* swap higher bytes	*/
-	    : "=q" (val)
-	    : "0" (val));
-# endif
+/*
+ * 32 bit architectures typically (but not always) want to
+ * set __SWAB_64_THRU_32__. In user space, this is only
+ * valid if the compiler supports 64 bit data types.
+ */
 
-#else /* __i386__ */
-	asm("bswapl %0"
-	    : "=r" (val)
-	    : "0" (val));
+#if __BITS_PER_LONG == 32
+#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
+#define __SWAB_64_THRU_32__
 #endif
-	return val;
-}
-#define __arch_swab32 __arch_swab32
-
-static inline __attribute_const__ __u64 __arch_swab64(__u64 val)
-{
-#ifdef __i386__
-	union {
-		struct {
-			__u32 a;
-			__u32 b;
-		} s;
-		__u64 u;
-	} v;
-	v.u = val;
-# ifdef CONFIG_X86_BSWAP
-	asm("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
-	    : "=r" (v.s.a), "=r" (v.s.b)
-	    : "0" (v.s.a), "1" (v.s.b));
-# else
-	v.s.a = __arch_swab32(v.s.a);
-	v.s.b = __arch_swab32(v.s.b);
-	asm("xchgl %0,%1"
-	    : "=r" (v.s.a), "=r" (v.s.b)
-	    : "0" (v.s.a), "1" (v.s.b));
-# endif
-	return v.u;
-#else /* __i386__ */
-	asm("bswapq %0"
-	    : "=r" (val)
-	    : "0" (val));
-	return val;
 #endif
-}
-#define __arch_swab64 __arch_swab64
 
-#endif /* _ASM_X86_SWAB_H */
+#endif /* _ASM_GENERIC_SWAB_H */
--- arch/x86/include/asm/termbits.h	2009-03-31 15:28:48.000000000 +0200
+++ include/asm-generic/termbits.h	2009-04-29 23:09:11.000000000 +0200
@@ -1,5 +1,5 @@
-#ifndef _ASM_X86_TERMBITS_H
-#define _ASM_X86_TERMBITS_H
+#ifndef __ASM_GENERIC_TERMBITS_H
+#define __ASM_GENERIC_TERMBITS_H
 
 #include <linux/posix_types.h>
 
@@ -140,7 +140,7 @@
 #define HUPCL	0002000
 #define CLOCAL	0004000
 #define CBAUDEX 0010000
-#define	   BOTHER 0010000		/* non standard rate */
+#define    BOTHER 0010000
 #define    B57600 0010001
 #define   B115200 0010002
 #define   B230400 0010003
@@ -195,4 +195,4 @@
 #define	TCSADRAIN	1
 #define	TCSAFLUSH	2
 
-#endif /* _ASM_X86_TERMBITS_H */
+#endif /* __ASM_GENERIC_TERMBITS_H */
--- arch/x86/include/asm/termios.h	2009-03-31 15:28:48.000000000 +0200
+++ include/asm-generic/termios.h	2009-04-29 23:09:11.000000000 +0200
@@ -1,5 +1,12 @@
-#ifndef _ASM_X86_TERMIOS_H
-#define _ASM_X86_TERMIOS_H
+#ifndef _ASM_GENERIC_TERMIOS_H
+#define _ASM_GENERIC_TERMIOS_H
+/*
+ * Most architectures have straight copies of the x86 code, with
+ * varying levels of bug fixes on top. Usually it's a good idea
+ * to use this generic version instead, but be careful to avoid
+ * ABI changes.
+ * New architectures should not provide their own version.
+ */
 
 #include <asm/termbits.h>
 #include <asm/ioctls.h>
@@ -54,20 +61,37 @@
 /*
  * Translate a "termio" structure into a "termios". Ugh.
  */
-#define SET_LOW_TERMIOS_BITS(termios, termio, x) { \
-	unsigned short __tmp; \
-	get_user(__tmp,&(termio)->x); \
-	*(unsigned short *) &(termios)->x = __tmp; \
-}
-
 static inline int user_termio_to_kernel_termios(struct ktermios *termios,
 						struct termio __user *termio)
 {
-	SET_LOW_TERMIOS_BITS(termios, termio, c_iflag);
-	SET_LOW_TERMIOS_BITS(termios, termio, c_oflag);
-	SET_LOW_TERMIOS_BITS(termios, termio, c_cflag);
-	SET_LOW_TERMIOS_BITS(termios, termio, c_lflag);
-	return copy_from_user(termios->c_cc, termio->c_cc, NCC);
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
 }
 
 /*
@@ -76,14 +100,18 @@
 static inline int kernel_termios_to_user_termio(struct termio __user *termio,
 					    struct ktermios *termios)
 {
-	put_user((termios)->c_iflag, &(termio)->c_iflag);
-	put_user((termios)->c_oflag, &(termio)->c_oflag);
-	put_user((termios)->c_cflag, &(termio)->c_cflag);
-	put_user((termios)->c_lflag, &(termio)->c_lflag);
-	put_user((termios)->c_line,  &(termio)->c_line);
-	return copy_to_user((termio)->c_cc, (termios)->c_cc, NCC);
+	if (put_user(termios->c_iflag, &termio->c_iflag) < 0 ||
+	    put_user(termios->c_oflag, &termio->c_oflag) < 0 ||
+	    put_user(termios->c_cflag, &termio->c_cflag) < 0 ||
+	    put_user(termios->c_lflag, &termio->c_lflag) < 0 ||
+	    put_user(termios->c_line,  &termio->c_line) < 0 ||
+	    copy_to_user(termio->c_cc, termios->c_cc, NCC) != 0)
+		return -EFAULT;
+
+	return 0;
 }
 
+#ifdef TCGETS2
 static inline int user_termios_to_kernel_termios(struct ktermios *k,
 						 struct termios2 __user *u)
 {
@@ -107,7 +135,20 @@
 {
 	return copy_to_user(u, k, sizeof(struct termios));
 }
+#else /* TCGETS2 */
+static inline int user_termios_to_kernel_termios(struct ktermios *k,
+						 struct termios __user *u)
+{
+	return copy_from_user(k, u, sizeof(struct termios));
+}
+
+static inline int kernel_termios_to_user_termios(struct termios __user *u,
+						 struct ktermios *k)
+{
+	return copy_to_user(u, k, sizeof(struct termios));
+}
+#endif /* TCGETS2 */
 
 #endif	/* __KERNEL__ */
 
-#endif /* _ASM_X86_TERMIOS_H */
+#endif /* _ASM_GENERIC_TERMIOS_H */
--- arch/x86/include/asm/types.h	2009-04-29 23:09:11.000000000 +0200
+++ include/asm-generic/types.h	2009-04-29 23:09:11.000000000 +0200
@@ -1,6 +1,9 @@
-#ifndef _ASM_X86_TYPES_H
-#define _ASM_X86_TYPES_H
-
+#ifndef _ASM_GENERIC_TYPES_H
+#define _ASM_GENERIC_TYPES_H
+/*
+ * int-ll64 is used practically everywhere now,
+ * so use it as a reasonable default.
+ */
 #include <asm-generic/int-ll64.h>
 
 #ifndef __ASSEMBLY__
@@ -13,18 +16,27 @@
  * These aren't exported outside the kernel to avoid name space clashes
  */
 #ifdef __KERNEL__
-
 #ifndef __ASSEMBLY__
-
-typedef u64 dma64_addr_t;
-#if defined(CONFIG_X86_64) || defined(CONFIG_HIGHMEM64G)
-/* DMA addresses come in 32-bit and 64-bit flavours. */
+/*
+ * DMA addresses may be very different from physical addresses
+ * and pointers. i386 and powerpc may have 64 bit DMA on 32 bit
+ * systems, while sparc64 uses 32 bit DMA addresses for 64 bit
+ * physical addresses.
+ * This default defines dma_addr_t to have the same size as
+ * phys_addr_t, which is the most common way.
+ * Do not define the dma64_addr_t type, which never really
+ * worked.
+ */
+#ifndef dma_addr_t
+#ifdef CONFIG_PHYS_ADDR_T_64BIT
 typedef u64 dma_addr_t;
 #else
 typedef u32 dma_addr_t;
-#endif
+#endif /* CONFIG_PHYS_ADDR_T_64BIT */
+#endif /* dma_addr_t */
 
 #endif /* __ASSEMBLY__ */
+
 #endif /* __KERNEL__ */
 
-#endif /* _ASM_X86_TYPES_H */
+#endif /* _ASM_GENERIC_TYPES_H */
--- arch/x86/include/asm/ucontext.h	2009-03-31 15:28:48.000000000 +0200
+++ include/asm-generic/ucontext.h	2009-04-29 23:09:11.000000000 +0200
@@ -1,11 +1,5 @@
-#ifndef _ASM_X86_UCONTEXT_H
-#define _ASM_X86_UCONTEXT_H
-
-#define UC_FP_XSTATE	0x1	/* indicates the presence of extended state
-				 * information in the memory layout pointed
-				 * by the fpstate pointer in the ucontext's
-				 * sigcontext struct (uc_mcontext).
-				 */
+#ifndef __ASM_GENERIC_UCONTEXT_H
+#define __ASM_GENERIC_UCONTEXT_H
 
 struct ucontext {
 	unsigned long	  uc_flags;
@@ -15,4 +9,4 @@
 	sigset_t	  uc_sigmask;	/* mask last for extensibility */
 };
 
-#endif /* _ASM_X86_UCONTEXT_H */
+#endif /* __ASM_GENERIC_UCONTEXT_H */
--- arch/x86/include/asm/unaligned.h	2009-03-31 15:28:48.000000000 +0200
+++ include/asm-generic/unaligned.h	2009-04-29 23:09:11.000000000 +0200
@@ -1,14 +1,30 @@
-#ifndef _ASM_X86_UNALIGNED_H
-#define _ASM_X86_UNALIGNED_H
+#ifndef __ASM_GENERIC_UNALIGNED_H
+#define __ASM_GENERIC_UNALIGNED_H
 
 /*
- * The x86 can do unaligned accesses itself.
+ * This is the most generic implementation of unaligned accesses
+ * and should work almost anywhere.
+ *
+ * If an architecture can handle unaligned accesses in hardware,
+ * it may want to use the linux/unaligned/access_ok.h implementation
+ * instead.
  */
+#include <asm/byteorder.h>
 
-#include <linux/unaligned/access_ok.h>
-#include <linux/unaligned/generic.h>
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
 
-#define get_unaligned __get_unaligned_le
-#define put_unaligned __put_unaligned_le
-
-#endif /* _ASM_X86_UNALIGNED_H */
+#endif /* __ASM_GENERIC_UNALIGNED_H */
--- arch/x86/include/asm/unistd_64.h	2009-04-29 23:09:11.000000000 +0200
+++ include/asm-generic/unistd.h	2009-04-29 23:09:11.000000000 +0200
@@ -1,697 +1,841 @@
-#ifndef _ASM_X86_UNISTD_64_H
-#define _ASM_X86_UNISTD_64_H
+#if !defined(_ASM_GENERIC_UNISTD_H) || defined(__SYSCALL)
+#define _ASM_GENERIC_UNISTD_H
 
-#ifndef __SYSCALL
-#define __SYSCALL(a, b)
-#endif
+#include <asm/bitsperlong.h>
 
 /*
- * This file contains the system call numbers.
+ * This file contains the system call numbers, based on the
+ * layout of the x86-64 architecture, which embeds the
+ * pointer to the syscall in the table.
  *
- * Note: holes are not allowed.
+ * As a basic principle, no duplication of functionality
+ * should be added, e.g. we don't use lseek when llseek
+ * is present. New architectures should use this file
+ * and implement the less feature-full calls in user space.
  */
 
-/* at least 8 syscall per cacheline */
-#define __NR_read				0
-__SYSCALL(__NR_read, sys_read)
-#define __NR_write				1
-__SYSCALL(__NR_write, sys_write)
-#define __NR_open				2
-__SYSCALL(__NR_open, sys_open)
-#define __NR_close				3
-__SYSCALL(__NR_close, sys_close)
-#define __NR_stat				4
-__SYSCALL(__NR_stat, sys_newstat)
-#define __NR_fstat				5
-__SYSCALL(__NR_fstat, sys_newfstat)
-#define __NR_lstat				6
-__SYSCALL(__NR_lstat, sys_newlstat)
-#define __NR_poll				7
-__SYSCALL(__NR_poll, sys_poll)
+#ifndef __SYSCALL
+#define __SYSCALL(x, y)
+#endif
 
-#define __NR_lseek				8
-__SYSCALL(__NR_lseek, sys_lseek)
-#define __NR_mmap				9
-__SYSCALL(__NR_mmap, sys_mmap)
-#define __NR_mprotect				10
-__SYSCALL(__NR_mprotect, sys_mprotect)
-#define __NR_munmap				11
-__SYSCALL(__NR_munmap, sys_munmap)
-#define __NR_brk				12
-__SYSCALL(__NR_brk, sys_brk)
-#define __NR_rt_sigaction			13
-__SYSCALL(__NR_rt_sigaction, sys_rt_sigaction)
-#define __NR_rt_sigprocmask			14
-__SYSCALL(__NR_rt_sigprocmask, sys_rt_sigprocmask)
-#define __NR_rt_sigreturn			15
-__SYSCALL(__NR_rt_sigreturn, stub_rt_sigreturn)
+#if __BITS_PER_LONG == 32
+#define __SC_3264(_nr, _32, _64) __SYSCALL(_nr, _32)
+#else
+#define __SC_3264(_nr, _32, _64) __SYSCALL(_nr, _64)
+#endif
 
-#define __NR_ioctl				16
-__SYSCALL(__NR_ioctl, sys_ioctl)
-#define __NR_pread64				17
-__SYSCALL(__NR_pread64, sys_pread64)
-#define __NR_pwrite64				18
-__SYSCALL(__NR_pwrite64, sys_pwrite64)
-#define __NR_readv				19
-__SYSCALL(__NR_readv, sys_readv)
-#define __NR_writev				20
-__SYSCALL(__NR_writev, sys_writev)
-#define __NR_access				21
-__SYSCALL(__NR_access, sys_access)
-#define __NR_pipe				22
-__SYSCALL(__NR_pipe, sys_pipe)
-#define __NR_select				23
-__SYSCALL(__NR_select, sys_select)
+#define __NR_io_setup 0
+__SYSCALL(__NR_io_setup, sys_io_setup)
+#define __NR_io_destroy 1
+__SYSCALL(__NR_io_destroy, sys_io_destroy)
+#define __NR_io_submit 2
+__SYSCALL(__NR_io_submit, sys_io_submit)
+#define __NR_io_cancel 3
+__SYSCALL(__NR_io_cancel, sys_io_cancel)
+#define __NR_io_getevents 4
+__SYSCALL(__NR_io_getevents, sys_io_getevents)
 
-#define __NR_sched_yield			24
-__SYSCALL(__NR_sched_yield, sys_sched_yield)
-#define __NR_mremap				25
-__SYSCALL(__NR_mremap, sys_mremap)
-#define __NR_msync				26
-__SYSCALL(__NR_msync, sys_msync)
-#define __NR_mincore				27
-__SYSCALL(__NR_mincore, sys_mincore)
-#define __NR_madvise				28
-__SYSCALL(__NR_madvise, sys_madvise)
-#define __NR_shmget				29
-__SYSCALL(__NR_shmget, sys_shmget)
-#define __NR_shmat				30
-__SYSCALL(__NR_shmat, sys_shmat)
-#define __NR_shmctl				31
-__SYSCALL(__NR_shmctl, sys_shmctl)
+/* fs/xattr.c */
+#define __NR_setxattr 5
+__SYSCALL(__NR_setxattr, sys_setxattr)
+#define __NR_lsetxattr 6
+__SYSCALL(__NR_lsetxattr, sys_lsetxattr)
+#define __NR_fsetxattr 7
+__SYSCALL(__NR_fsetxattr, sys_fsetxattr)
+#define __NR_getxattr 8
+__SYSCALL(__NR_getxattr, sys_getxattr)
+#define __NR_lgetxattr 9
+__SYSCALL(__NR_lgetxattr, sys_lgetxattr)
+#define __NR_fgetxattr 10
+__SYSCALL(__NR_fgetxattr, sys_fgetxattr)
+#define __NR_listxattr 11
+__SYSCALL(__NR_listxattr, sys_listxattr)
+#define __NR_llistxattr 12
+__SYSCALL(__NR_llistxattr, sys_llistxattr)
+#define __NR_flistxattr 13
+__SYSCALL(__NR_flistxattr, sys_flistxattr)
+#define __NR_removexattr 14
+__SYSCALL(__NR_removexattr, sys_removexattr)
+#define __NR_lremovexattr 15
+__SYSCALL(__NR_lremovexattr, sys_lremovexattr)
+#define __NR_fremovexattr 16
+__SYSCALL(__NR_fremovexattr, sys_fremovexattr)
 
-#define __NR_dup				32
-__SYSCALL(__NR_dup, sys_dup)
-#define __NR_dup2				33
-__SYSCALL(__NR_dup2, sys_dup2)
-#define __NR_pause				34
-__SYSCALL(__NR_pause, sys_pause)
-#define __NR_nanosleep				35
-__SYSCALL(__NR_nanosleep, sys_nanosleep)
-#define __NR_getitimer				36
-__SYSCALL(__NR_getitimer, sys_getitimer)
-#define __NR_alarm				37
-__SYSCALL(__NR_alarm, sys_alarm)
-#define __NR_setitimer				38
-__SYSCALL(__NR_setitimer, sys_setitimer)
-#define __NR_getpid				39
-__SYSCALL(__NR_getpid, sys_getpid)
+/* fs/dcache.c */
+#define __NR_getcwd 17
+__SYSCALL(__NR_getcwd, sys_getcwd)
 
-#define __NR_sendfile				40
-__SYSCALL(__NR_sendfile, sys_sendfile64)
-#define __NR_socket				41
-__SYSCALL(__NR_socket, sys_socket)
-#define __NR_connect				42
-__SYSCALL(__NR_connect, sys_connect)
-#define __NR_accept				43
-__SYSCALL(__NR_accept, sys_accept)
-#define __NR_sendto				44
-__SYSCALL(__NR_sendto, sys_sendto)
-#define __NR_recvfrom				45
-__SYSCALL(__NR_recvfrom, sys_recvfrom)
-#define __NR_sendmsg				46
-__SYSCALL(__NR_sendmsg, sys_sendmsg)
-#define __NR_recvmsg				47
-__SYSCALL(__NR_recvmsg, sys_recvmsg)
+/* fs/cookies.c */
+#define __NR_lookup_dcookie 18
+__SYSCALL(__NR_lookup_dcookie, sys_lookup_dcookie)
 
-#define __NR_shutdown				48
-__SYSCALL(__NR_shutdown, sys_shutdown)
-#define __NR_bind				49
-__SYSCALL(__NR_bind, sys_bind)
-#define __NR_listen				50
-__SYSCALL(__NR_listen, sys_listen)
-#define __NR_getsockname			51
-__SYSCALL(__NR_getsockname, sys_getsockname)
-#define __NR_getpeername			52
-__SYSCALL(__NR_getpeername, sys_getpeername)
-#define __NR_socketpair				53
-__SYSCALL(__NR_socketpair, sys_socketpair)
-#define __NR_setsockopt				54
-__SYSCALL(__NR_setsockopt, sys_setsockopt)
-#define __NR_getsockopt				55
-__SYSCALL(__NR_getsockopt, sys_getsockopt)
+/* fs/eventfd.c */
+#define __NR_eventfd2 19
+__SYSCALL(__NR_eventfd2, sys_eventfd2)
 
-#define __NR_clone				56
-__SYSCALL(__NR_clone, stub_clone)
-#define __NR_fork				57
-__SYSCALL(__NR_fork, stub_fork)
-#define __NR_vfork				58
-__SYSCALL(__NR_vfork, stub_vfork)
-#define __NR_execve				59
-__SYSCALL(__NR_execve, stub_execve)
-#define __NR_exit				60
-__SYSCALL(__NR_exit, sys_exit)
-#define __NR_wait4				61
-__SYSCALL(__NR_wait4, sys_wait4)
-#define __NR_kill				62
-__SYSCALL(__NR_kill, sys_kill)
-#define __NR_uname				63
-__SYSCALL(__NR_uname, sys_uname)
+/* fs/eventpoll.c */
+#define __NR_epoll_create1 20
+__SYSCALL(__NR_epoll_create1, sys_epoll_create1)
+#define __NR_epoll_ctl 21
+__SYSCALL(__NR_epoll_ctl, sys_epoll_ctl)
+#define __NR_epoll_pwait 22
+__SYSCALL(__NR_epoll_pwait, sys_epoll_pwait)
 
-#define __NR_semget				64
-__SYSCALL(__NR_semget, sys_semget)
-#define __NR_semop				65
-__SYSCALL(__NR_semop, sys_semop)
-#define __NR_semctl				66
-__SYSCALL(__NR_semctl, sys_semctl)
-#define __NR_shmdt				67
-__SYSCALL(__NR_shmdt, sys_shmdt)
-#define __NR_msgget				68
-__SYSCALL(__NR_msgget, sys_msgget)
-#define __NR_msgsnd				69
-__SYSCALL(__NR_msgsnd, sys_msgsnd)
-#define __NR_msgrcv				70
-__SYSCALL(__NR_msgrcv, sys_msgrcv)
-#define __NR_msgctl				71
-__SYSCALL(__NR_msgctl, sys_msgctl)
+/* fs/fcntl.c */
+#define __NR_dup 23
+__SYSCALL(__NR_dup, sys_dup)
+#define __NR_dup3 24
+__SYSCALL(__NR_dup3, sys_dup3)
+#define __NR3264_fcntl 25
+__SC_3264(__NR3264_fcntl, sys_fcntl64, sys_fcntl)
 
-#define __NR_fcntl				72
-__SYSCALL(__NR_fcntl, sys_fcntl)
-#define __NR_flock				73
-__SYSCALL(__NR_flock, sys_flock)
-#define __NR_fsync				74
-__SYSCALL(__NR_fsync, sys_fsync)
-#define __NR_fdatasync				75
-__SYSCALL(__NR_fdatasync, sys_fdatasync)
-#define __NR_truncate				76
-__SYSCALL(__NR_truncate, sys_truncate)
-#define __NR_ftruncate				77
-__SYSCALL(__NR_ftruncate, sys_ftruncate)
-#define __NR_getdents				78
-__SYSCALL(__NR_getdents, sys_getdents)
-#define __NR_getcwd				79
-__SYSCALL(__NR_getcwd, sys_getcwd)
+/* fs/inotify_user.c */
+#define __NR_inotify_init1 26
+__SYSCALL(__NR_inotify_init1, sys_inotify_init1)
+#define __NR_inotify_add_watch 27
+__SYSCALL(__NR_inotify_add_watch, sys_inotify_add_watch)
+#define __NR_inotify_rm_watch 28
+__SYSCALL(__NR_inotify_rm_watch, sys_inotify_rm_watch)
 
-#define __NR_chdir				80
-__SYSCALL(__NR_chdir, sys_chdir)
-#define __NR_fchdir				81
-__SYSCALL(__NR_fchdir, sys_fchdir)
-#define __NR_rename				82
-__SYSCALL(__NR_rename, sys_rename)
-#define __NR_mkdir				83
-__SYSCALL(__NR_mkdir, sys_mkdir)
-#define __NR_rmdir				84
-__SYSCALL(__NR_rmdir, sys_rmdir)
-#define __NR_creat				85
-__SYSCALL(__NR_creat, sys_creat)
-#define __NR_link				86
-__SYSCALL(__NR_link, sys_link)
-#define __NR_unlink				87
-__SYSCALL(__NR_unlink, sys_unlink)
+/* fs/ioctl.c */
+#define __NR_ioctl 29
+__SYSCALL(__NR_ioctl, sys_ioctl)
 
-#define __NR_symlink				88
-__SYSCALL(__NR_symlink, sys_symlink)
-#define __NR_readlink				89
-__SYSCALL(__NR_readlink, sys_readlink)
-#define __NR_chmod				90
-__SYSCALL(__NR_chmod, sys_chmod)
-#define __NR_fchmod				91
-__SYSCALL(__NR_fchmod, sys_fchmod)
-#define __NR_chown				92
-__SYSCALL(__NR_chown, sys_chown)
-#define __NR_fchown				93
-__SYSCALL(__NR_fchown, sys_fchown)
-#define __NR_lchown				94
-__SYSCALL(__NR_lchown, sys_lchown)
-#define __NR_umask				95
-__SYSCALL(__NR_umask, sys_umask)
+/* fs/ioprio.c */
+#define __NR_ioprio_set 30
+__SYSCALL(__NR_ioprio_set, sys_ioprio_set)
+#define __NR_ioprio_get 31
+__SYSCALL(__NR_ioprio_get, sys_ioprio_get)
 
-#define __NR_gettimeofday			96
-__SYSCALL(__NR_gettimeofday, sys_gettimeofday)
-#define __NR_getrlimit				97
-__SYSCALL(__NR_getrlimit, sys_getrlimit)
-#define __NR_getrusage				98
-__SYSCALL(__NR_getrusage, sys_getrusage)
-#define __NR_sysinfo				99
-__SYSCALL(__NR_sysinfo, sys_sysinfo)
-#define __NR_times				100
-__SYSCALL(__NR_times, sys_times)
-#define __NR_ptrace				101
-__SYSCALL(__NR_ptrace, sys_ptrace)
-#define __NR_getuid				102
-__SYSCALL(__NR_getuid, sys_getuid)
-#define __NR_syslog				103
-__SYSCALL(__NR_syslog, sys_syslog)
+/* fs/locks.c */
+#define __NR_flock 32
+__SYSCALL(__NR_flock, sys_flock)
 
-/* at the very end the stuff that never runs during the benchmarks */
-#define __NR_getgid				104
-__SYSCALL(__NR_getgid, sys_getgid)
-#define __NR_setuid				105
-__SYSCALL(__NR_setuid, sys_setuid)
-#define __NR_setgid				106
-__SYSCALL(__NR_setgid, sys_setgid)
-#define __NR_geteuid				107
-__SYSCALL(__NR_geteuid, sys_geteuid)
-#define __NR_getegid				108
-__SYSCALL(__NR_getegid, sys_getegid)
-#define __NR_setpgid				109
-__SYSCALL(__NR_setpgid, sys_setpgid)
-#define __NR_getppid				110
-__SYSCALL(__NR_getppid, sys_getppid)
-#define __NR_getpgrp				111
-__SYSCALL(__NR_getpgrp, sys_getpgrp)
+/* fs/namei.c */
+#define __NR_mknodat 33
+__SYSCALL(__NR_mknodat, sys_mknodat)
+#define __NR_mkdirat 34
+__SYSCALL(__NR_mkdirat, sys_mkdirat)
+#define __NR_unlinkat 35
+__SYSCALL(__NR_unlinkat, sys_unlinkat)
+#define __NR_symlinkat 36
+__SYSCALL(__NR_symlinkat, sys_symlinkat)
+#define __NR_linkat 37
+__SYSCALL(__NR_linkat, sys_linkat)
+#define __NR_renameat 38
+__SYSCALL(__NR_renameat, sys_renameat)
 
-#define __NR_setsid				112
-__SYSCALL(__NR_setsid, sys_setsid)
-#define __NR_setreuid				113
-__SYSCALL(__NR_setreuid, sys_setreuid)
-#define __NR_setregid				114
-__SYSCALL(__NR_setregid, sys_setregid)
-#define __NR_getgroups				115
-__SYSCALL(__NR_getgroups, sys_getgroups)
-#define __NR_setgroups				116
-__SYSCALL(__NR_setgroups, sys_setgroups)
-#define __NR_setresuid				117
-__SYSCALL(__NR_setresuid, sys_setresuid)
-#define __NR_getresuid				118
-__SYSCALL(__NR_getresuid, sys_getresuid)
-#define __NR_setresgid				119
-__SYSCALL(__NR_setresgid, sys_setresgid)
+/* fs/namespace.c */
+#define __NR_umount2 39
+__SYSCALL(__NR_umount2, sys_umount)
+#define __NR_mount 40
+__SYSCALL(__NR_mount, sys_mount)
+#define __NR_pivot_root 41
+__SYSCALL(__NR_pivot_root, sys_pivot_root)
 
-#define __NR_getresgid				120
-__SYSCALL(__NR_getresgid, sys_getresgid)
-#define __NR_getpgid				121
-__SYSCALL(__NR_getpgid, sys_getpgid)
-#define __NR_setfsuid				122
-__SYSCALL(__NR_setfsuid, sys_setfsuid)
-#define __NR_setfsgid				123
-__SYSCALL(__NR_setfsgid, sys_setfsgid)
-#define __NR_getsid				124
-__SYSCALL(__NR_getsid, sys_getsid)
-#define __NR_capget				125
-__SYSCALL(__NR_capget, sys_capget)
-#define __NR_capset				126
-__SYSCALL(__NR_capset, sys_capset)
+/* fs/nfsctl.c */
+#define __NR_nfsservctl 42
+__SYSCALL(__NR_nfsservctl, sys_nfsservctl)
 
-#define __NR_rt_sigpending			127
-__SYSCALL(__NR_rt_sigpending, sys_rt_sigpending)
-#define __NR_rt_sigtimedwait			128
-__SYSCALL(__NR_rt_sigtimedwait, sys_rt_sigtimedwait)
-#define __NR_rt_sigqueueinfo			129
-__SYSCALL(__NR_rt_sigqueueinfo, sys_rt_sigqueueinfo)
-#define __NR_rt_sigsuspend			130
-__SYSCALL(__NR_rt_sigsuspend, sys_rt_sigsuspend)
-#define __NR_sigaltstack			131
-__SYSCALL(__NR_sigaltstack, stub_sigaltstack)
-#define __NR_utime				132
-__SYSCALL(__NR_utime, sys_utime)
-#define __NR_mknod				133
-__SYSCALL(__NR_mknod, sys_mknod)
+/* fs/open.c */
+#define __NR3264_statfs 43
+__SC_3264(__NR3264_statfs, sys_statfs64, sys_statfs)
+#define __NR3264_fstatfs 44
+__SC_3264(__NR3264_fstatfs, sys_fstatfs64, sys_fstatfs)
+#define __NR3264_truncate 45
+__SC_3264(__NR3264_truncate, sys_truncate64, sys_truncate)
+#define __NR3264_ftruncate 46
+__SC_3264(__NR3264_ftruncate, sys_ftruncate64, sys_ftruncate)
 
-/* Only needed for a.out */
-#define __NR_uselib				134
-__SYSCALL(__NR_uselib, sys_ni_syscall)
-#define __NR_personality			135
-__SYSCALL(__NR_personality, sys_personality)
+#define __NR_fallocate 47
+__SYSCALL(__NR_fallocate, sys_fallocate)
+#define __NR_faccessat 48
+__SYSCALL(__NR_faccessat, sys_faccessat)
+#define __NR_chdir 49
+__SYSCALL(__NR_chdir, sys_chdir)
+#define __NR_fchdir 50
+__SYSCALL(__NR_fchdir, sys_fchdir)
+#define __NR_chroot 51
+__SYSCALL(__NR_chroot, sys_chroot)
+#define __NR_fchmod 52
+__SYSCALL(__NR_fchmod, sys_fchmod)
+#define __NR_fchmodat 53
+__SYSCALL(__NR_fchmodat, sys_fchmodat)
+#define __NR_fchownat 54
+__SYSCALL(__NR_fchownat, sys_fchownat)
+#define __NR_fchown 55
+__SYSCALL(__NR_fchown, sys_fchown)
+#define __NR_openat 56
+__SYSCALL(__NR_openat, sys_openat)
+#define __NR_close 57
+__SYSCALL(__NR_close, sys_close)
+#define __NR_vhangup 58
+__SYSCALL(__NR_vhangup, sys_vhangup)
 
-#define __NR_ustat				136
-__SYSCALL(__NR_ustat, sys_ustat)
-#define __NR_statfs				137
-__SYSCALL(__NR_statfs, sys_statfs)
-#define __NR_fstatfs				138
-__SYSCALL(__NR_fstatfs, sys_fstatfs)
-#define __NR_sysfs				139
-__SYSCALL(__NR_sysfs, sys_sysfs)
+/* fs/pipe.c */
+#define __NR_pipe2 59
+__SYSCALL(__NR_pipe2, sys_pipe2)
 
-#define __NR_getpriority			140
-__SYSCALL(__NR_getpriority, sys_getpriority)
-#define __NR_setpriority			141
-__SYSCALL(__NR_setpriority, sys_setpriority)
-#define __NR_sched_setparam			142
-__SYSCALL(__NR_sched_setparam, sys_sched_setparam)
-#define __NR_sched_getparam			143
-__SYSCALL(__NR_sched_getparam, sys_sched_getparam)
-#define __NR_sched_setscheduler			144
-__SYSCALL(__NR_sched_setscheduler, sys_sched_setscheduler)
-#define __NR_sched_getscheduler			145
-__SYSCALL(__NR_sched_getscheduler, sys_sched_getscheduler)
-#define __NR_sched_get_priority_max		146
-__SYSCALL(__NR_sched_get_priority_max, sys_sched_get_priority_max)
-#define __NR_sched_get_priority_min		147
-__SYSCALL(__NR_sched_get_priority_min, sys_sched_get_priority_min)
-#define __NR_sched_rr_get_interval		148
-__SYSCALL(__NR_sched_rr_get_interval, sys_sched_rr_get_interval)
+/* fs/quota.c */
+#define __NR_quotactl 60
+__SYSCALL(__NR_quotactl, sys_quotactl)
 
-#define __NR_mlock				149
-__SYSCALL(__NR_mlock, sys_mlock)
-#define __NR_munlock				150
-__SYSCALL(__NR_munlock, sys_munlock)
-#define __NR_mlockall				151
-__SYSCALL(__NR_mlockall, sys_mlockall)
-#define __NR_munlockall				152
-__SYSCALL(__NR_munlockall, sys_munlockall)
+/* fs/readdir.c */
+#define __NR_getdents64 61
+__SYSCALL(__NR_getdents64, sys_getdents64)
 
-#define __NR_vhangup				153
-__SYSCALL(__NR_vhangup, sys_vhangup)
+/* fs/read_write.c */
+#define __NR3264_lseek 62
+__SC_3264(__NR3264_lseek, sys_llseek, sys_lseek)
+#define __NR_read 63
+__SYSCALL(__NR_read, sys_read)
+#define __NR_write 64
+__SYSCALL(__NR_write, sys_write)
+#define __NR_readv 65
+__SYSCALL(__NR_readv, sys_readv)
+#define __NR_writev 66
+__SYSCALL(__NR_writev, sys_writev)
+#define __NR_pread64 67
+__SYSCALL(__NR_pread64, sys_pread64)
+#define __NR_pwrite64 68
+__SYSCALL(__NR_pwrite64, sys_pwrite64)
+#define __NR_preadv 69
+__SYSCALL(__NR_preadv, sys_preadv)
+#define __NR_pwritev 70
+__SYSCALL(__NR_pwritev, sys_pwritev)
 
-#define __NR_modify_ldt				154
-__SYSCALL(__NR_modify_ldt, sys_modify_ldt)
+/* fs/sendfile.c */
+#define __NR3264_sendfile 71
+__SC_3264(__NR3264_sendfile, sys_sendfile64, sys_sendfile)
 
-#define __NR_pivot_root				155
-__SYSCALL(__NR_pivot_root, sys_pivot_root)
+/* fs/select.c */
+#define __NR_pselect6 72
+__SYSCALL(__NR_pselect6, sys_pselect6)
+#define __NR_ppoll 73
+__SYSCALL(__NR_ppoll, sys_ppoll)
 
-#define __NR__sysctl				156
-__SYSCALL(__NR__sysctl, sys_sysctl)
+/* fs/signalfd.c */
+#define __NR_signalfd4 74
+__SYSCALL(__NR_signalfd4, sys_signalfd4)
 
-#define __NR_prctl				157
-__SYSCALL(__NR_prctl, sys_prctl)
-#define __NR_arch_prctl				158
-__SYSCALL(__NR_arch_prctl, sys_arch_prctl)
+/* fs/splice.c */
+#define __NR_vmsplice 75
+__SYSCALL(__NR_vmsplice, sys_vmsplice)
+#define __NR_splice 76
+__SYSCALL(__NR_splice, sys_splice)
+#define __NR_tee 77
+__SYSCALL(__NR_tee, sys_tee)
 
-#define __NR_adjtimex				159
-__SYSCALL(__NR_adjtimex, sys_adjtimex)
+/* fs/stat.c */
+#define __NR_readlinkat 78
+__SYSCALL(__NR_readlinkat, sys_readlinkat)
+#define __NR3264_fstatat 79
+__SC_3264(__NR3264_fstatat, sys_fstatat64, sys_newfstatat)
+#define __NR3264_fstat 80
+__SC_3264(__NR3264_fstat, sys_fstat64, sys_newfstat)
 
-#define __NR_setrlimit				160
-__SYSCALL(__NR_setrlimit, sys_setrlimit)
+/* fs/sync.c */
+#define __NR_sync 81
+__SYSCALL(__NR_sync, sys_sync)
+#define __NR_fsync 82
+__SYSCALL(__NR_fsync, sys_fsync)
+#define __NR_fdatasync 83
+__SYSCALL(__NR_fdatasync, sys_fdatasync)
+#define __NR_sync_file_range 84
+__SYSCALL(__NR_sync_file_range, sys_sync_file_range) /* .long sys_sync_file_range2, */
 
-#define __NR_chroot				161
-__SYSCALL(__NR_chroot, sys_chroot)
+/* fs/timerfd.c */
+#define __NR_timerfd_create 85
+__SYSCALL(__NR_timerfd_create, sys_timerfd_create)
+#define __NR_timerfd_settime 86
+__SYSCALL(__NR_timerfd_settime, sys_timerfd_settime)
+#define __NR_timerfd_gettime 87
+__SYSCALL(__NR_timerfd_gettime, sys_timerfd_gettime)
 
-#define __NR_sync				162
-__SYSCALL(__NR_sync, sys_sync)
+/* fs/utimes.c */
+#define __NR_utimensat 88
+__SYSCALL(__NR_utimensat, sys_utimensat)
 
-#define __NR_acct				163
+/* kernel/acct.c */
+#define __NR_acct 89
 __SYSCALL(__NR_acct, sys_acct)
 
-#define __NR_settimeofday			164
-__SYSCALL(__NR_settimeofday, sys_settimeofday)
-
-#define __NR_mount				165
-__SYSCALL(__NR_mount, sys_mount)
-#define __NR_umount2				166
-__SYSCALL(__NR_umount2, sys_umount)
+/* kernel/capability.c */
+#define __NR_capget 90
+__SYSCALL(__NR_capget, sys_capget)
+#define __NR_capset 91
+__SYSCALL(__NR_capset, sys_capset)
 
-#define __NR_swapon				167
-__SYSCALL(__NR_swapon, sys_swapon)
-#define __NR_swapoff				168
-__SYSCALL(__NR_swapoff, sys_swapoff)
+/* kernel/exec_domain.c */
+#define __NR_personality 92
+__SYSCALL(__NR_personality, sys_personality)
 
-#define __NR_reboot				169
-__SYSCALL(__NR_reboot, sys_reboot)
+/* kernel/exit.c */
+#define __NR_exit 93
+__SYSCALL(__NR_exit, sys_exit)
+#define __NR_exit_group 94
+__SYSCALL(__NR_exit_group, sys_exit_group)
+#define __NR_waitid 95
+__SYSCALL(__NR_waitid, sys_waitid)
 
-#define __NR_sethostname			170
-__SYSCALL(__NR_sethostname, sys_sethostname)
-#define __NR_setdomainname			171
-__SYSCALL(__NR_setdomainname, sys_setdomainname)
+/* kernel/fork.c */
+#define __NR_set_tid_address 96
+__SYSCALL(__NR_set_tid_address, sys_set_tid_address)
+#define __NR_unshare 97
+__SYSCALL(__NR_unshare, sys_unshare)
 
-#define __NR_iopl				172
-__SYSCALL(__NR_iopl, stub_iopl)
-#define __NR_ioperm				173
-__SYSCALL(__NR_ioperm, sys_ioperm)
-
-#define __NR_create_module			174
-__SYSCALL(__NR_create_module, sys_ni_syscall)
-#define __NR_init_module			175
-__SYSCALL(__NR_init_module, sys_init_module)
-#define __NR_delete_module			176
-__SYSCALL(__NR_delete_module, sys_delete_module)
-#define __NR_get_kernel_syms			177
-__SYSCALL(__NR_get_kernel_syms, sys_ni_syscall)
-#define __NR_query_module			178
-__SYSCALL(__NR_query_module, sys_ni_syscall)
+/* kernel/futex.c */
+#define __NR_futex 98
+__SYSCALL(__NR_futex, sys_futex)
+#define __NR_set_robust_list 99
+__SYSCALL(__NR_set_robust_list, sys_set_robust_list)
+#define __NR_get_robust_list 100
+__SYSCALL(__NR_get_robust_list, sys_get_robust_list)
 
-#define __NR_quotactl				179
-__SYSCALL(__NR_quotactl, sys_quotactl)
+/* kernel/hrtimer.c */
+#define __NR_nanosleep 101
+__SYSCALL(__NR_nanosleep, sys_nanosleep)
 
-#define __NR_nfsservctl				180
-__SYSCALL(__NR_nfsservctl, sys_nfsservctl)
-
-/* reserved for LiS/STREAMS */
-#define __NR_getpmsg				181
-__SYSCALL(__NR_getpmsg, sys_ni_syscall)
-#define __NR_putpmsg				182
-__SYSCALL(__NR_putpmsg, sys_ni_syscall)
-
-/* reserved for AFS */
-#define __NR_afs_syscall			183
-__SYSCALL(__NR_afs_syscall, sys_ni_syscall)
-
-/* reserved for tux */
-#define __NR_tuxcall				184
-__SYSCALL(__NR_tuxcall, sys_ni_syscall)
+/* kernel/itimer.c */
+#define __NR_getitimer 102
+__SYSCALL(__NR_getitimer, sys_getitimer)
+#define __NR_setitimer 103
+__SYSCALL(__NR_setitimer, sys_setitimer)
 
-#define __NR_security				185
-__SYSCALL(__NR_security, sys_ni_syscall)
+/* kernel/kexec.c */
+#define __NR_kexec_load 104
+__SYSCALL(__NR_kexec_load, sys_kexec_load)
 
-#define __NR_gettid				186
-__SYSCALL(__NR_gettid, sys_gettid)
+/* kernel/module.c */
+#define __NR_init_module 105
+__SYSCALL(__NR_init_module, sys_init_module)
+#define __NR_delete_module 106
+__SYSCALL(__NR_delete_module, sys_delete_module)
 
-#define __NR_readahead				187
-__SYSCALL(__NR_readahead, sys_readahead)
-#define __NR_setxattr				188
-__SYSCALL(__NR_setxattr, sys_setxattr)
-#define __NR_lsetxattr				189
-__SYSCALL(__NR_lsetxattr, sys_lsetxattr)
-#define __NR_fsetxattr				190
-__SYSCALL(__NR_fsetxattr, sys_fsetxattr)
-#define __NR_getxattr				191
-__SYSCALL(__NR_getxattr, sys_getxattr)
-#define __NR_lgetxattr				192
-__SYSCALL(__NR_lgetxattr, sys_lgetxattr)
-#define __NR_fgetxattr				193
-__SYSCALL(__NR_fgetxattr, sys_fgetxattr)
-#define __NR_listxattr				194
-__SYSCALL(__NR_listxattr, sys_listxattr)
-#define __NR_llistxattr				195
-__SYSCALL(__NR_llistxattr, sys_llistxattr)
-#define __NR_flistxattr				196
-__SYSCALL(__NR_flistxattr, sys_flistxattr)
-#define __NR_removexattr			197
-__SYSCALL(__NR_removexattr, sys_removexattr)
-#define __NR_lremovexattr			198
-__SYSCALL(__NR_lremovexattr, sys_lremovexattr)
-#define __NR_fremovexattr			199
-__SYSCALL(__NR_fremovexattr, sys_fremovexattr)
-#define __NR_tkill				200
-__SYSCALL(__NR_tkill, sys_tkill)
-#define __NR_time				201
-__SYSCALL(__NR_time, sys_time)
-#define __NR_futex				202
-__SYSCALL(__NR_futex, sys_futex)
-#define __NR_sched_setaffinity			203
-__SYSCALL(__NR_sched_setaffinity, sys_sched_setaffinity)
-#define __NR_sched_getaffinity			204
-__SYSCALL(__NR_sched_getaffinity, sys_sched_getaffinity)
-#define __NR_set_thread_area			205
-__SYSCALL(__NR_set_thread_area, sys_ni_syscall)	/* use arch_prctl */
-#define __NR_io_setup				206
-__SYSCALL(__NR_io_setup, sys_io_setup)
-#define __NR_io_destroy				207
-__SYSCALL(__NR_io_destroy, sys_io_destroy)
-#define __NR_io_getevents			208
-__SYSCALL(__NR_io_getevents, sys_io_getevents)
-#define __NR_io_submit				209
-__SYSCALL(__NR_io_submit, sys_io_submit)
-#define __NR_io_cancel				210
-__SYSCALL(__NR_io_cancel, sys_io_cancel)
-#define __NR_get_thread_area			211
-__SYSCALL(__NR_get_thread_area, sys_ni_syscall)	/* use arch_prctl */
-#define __NR_lookup_dcookie			212
-__SYSCALL(__NR_lookup_dcookie, sys_lookup_dcookie)
-#define __NR_epoll_create			213
-__SYSCALL(__NR_epoll_create, sys_epoll_create)
-#define __NR_epoll_ctl_old			214
-__SYSCALL(__NR_epoll_ctl_old, sys_ni_syscall)
-#define __NR_epoll_wait_old			215
-__SYSCALL(__NR_epoll_wait_old, sys_ni_syscall)
-#define __NR_remap_file_pages			216
-__SYSCALL(__NR_remap_file_pages, sys_remap_file_pages)
-#define __NR_getdents64				217
-__SYSCALL(__NR_getdents64, sys_getdents64)
-#define __NR_set_tid_address			218
-__SYSCALL(__NR_set_tid_address, sys_set_tid_address)
-#define __NR_restart_syscall			219
-__SYSCALL(__NR_restart_syscall, sys_restart_syscall)
-#define __NR_semtimedop				220
-__SYSCALL(__NR_semtimedop, sys_semtimedop)
-#define __NR_fadvise64				221
-__SYSCALL(__NR_fadvise64, sys_fadvise64)
-#define __NR_timer_create			222
+/* kernel/posix-timers.c */
+#define __NR_timer_create 107
 __SYSCALL(__NR_timer_create, sys_timer_create)
-#define __NR_timer_settime			223
-__SYSCALL(__NR_timer_settime, sys_timer_settime)
-#define __NR_timer_gettime			224
+#define __NR_timer_gettime 108
 __SYSCALL(__NR_timer_gettime, sys_timer_gettime)
-#define __NR_timer_getoverrun			225
+#define __NR_timer_getoverrun 109
 __SYSCALL(__NR_timer_getoverrun, sys_timer_getoverrun)
-#define __NR_timer_delete			226
+#define __NR_timer_settime 110
+__SYSCALL(__NR_timer_settime, sys_timer_settime)
+#define __NR_timer_delete 111
 __SYSCALL(__NR_timer_delete, sys_timer_delete)
-#define __NR_clock_settime			227
+#define __NR_clock_settime 112
 __SYSCALL(__NR_clock_settime, sys_clock_settime)
-#define __NR_clock_gettime			228
+#define __NR_clock_gettime 113
 __SYSCALL(__NR_clock_gettime, sys_clock_gettime)
-#define __NR_clock_getres			229
+#define __NR_clock_getres 114
 __SYSCALL(__NR_clock_getres, sys_clock_getres)
-#define __NR_clock_nanosleep			230
+#define __NR_clock_nanosleep 115
 __SYSCALL(__NR_clock_nanosleep, sys_clock_nanosleep)
-#define __NR_exit_group				231
-__SYSCALL(__NR_exit_group, sys_exit_group)
-#define __NR_epoll_wait				232
-__SYSCALL(__NR_epoll_wait, sys_epoll_wait)
-#define __NR_epoll_ctl				233
-__SYSCALL(__NR_epoll_ctl, sys_epoll_ctl)
-#define __NR_tgkill				234
+
+/* kernel/printk.c */
+#define __NR_syslog 116
+__SYSCALL(__NR_syslog, sys_syslog)
+
+/* kernel/ptrace.c */
+#define __NR_ptrace 117
+__SYSCALL(__NR_ptrace, sys_ptrace)
+
+/* kernel/sched.c */
+#define __NR_sched_setparam 118
+__SYSCALL(__NR_sched_setparam, sys_sched_setparam)
+#define __NR_sched_setscheduler 119
+__SYSCALL(__NR_sched_setscheduler, sys_sched_setscheduler)
+#define __NR_sched_getscheduler 120
+__SYSCALL(__NR_sched_getscheduler, sys_sched_getscheduler)
+#define __NR_sched_getparam 121
+__SYSCALL(__NR_sched_getparam, sys_sched_getparam)
+#define __NR_sched_setaffinity 122
+__SYSCALL(__NR_sched_setaffinity, sys_sched_setaffinity)
+#define __NR_sched_getaffinity 123
+__SYSCALL(__NR_sched_getaffinity, sys_sched_getaffinity)
+#define __NR_sched_yield 124
+__SYSCALL(__NR_sched_yield, sys_sched_yield)
+#define __NR_sched_get_priority_max 125
+__SYSCALL(__NR_sched_get_priority_max, sys_sched_get_priority_max)
+#define __NR_sched_get_priority_min 126
+__SYSCALL(__NR_sched_get_priority_min, sys_sched_get_priority_min)
+#define __NR_sched_rr_get_interval 127
+__SYSCALL(__NR_sched_rr_get_interval, sys_sched_rr_get_interval)
+
+/* kernel/signal.c */
+#define __NR_restart_syscall 128
+__SYSCALL(__NR_restart_syscall, sys_restart_syscall)
+#define __NR_kill 129
+__SYSCALL(__NR_kill, sys_kill)
+#define __NR_tkill 130
+__SYSCALL(__NR_tkill, sys_tkill)
+#define __NR_tgkill 131
 __SYSCALL(__NR_tgkill, sys_tgkill)
-#define __NR_utimes				235
-__SYSCALL(__NR_utimes, sys_utimes)
-#define __NR_vserver				236
-__SYSCALL(__NR_vserver, sys_ni_syscall)
-#define __NR_mbind				237
-__SYSCALL(__NR_mbind, sys_mbind)
-#define __NR_set_mempolicy			238
-__SYSCALL(__NR_set_mempolicy, sys_set_mempolicy)
-#define __NR_get_mempolicy			239
-__SYSCALL(__NR_get_mempolicy, sys_get_mempolicy)
-#define __NR_mq_open				240
+#define __NR_sigaltstack 132
+__SYSCALL(__NR_sigaltstack, sys_sigaltstack)
+#define __NR_rt_sigsuspend 133
+__SYSCALL(__NR_rt_sigsuspend, sys_rt_sigsuspend) /* __ARCH_WANT_SYS_RT_SIGSUSPEND */
+#define __NR_rt_sigaction 134
+__SYSCALL(__NR_rt_sigaction, sys_rt_sigaction) /* __ARCH_WANT_SYS_RT_SIGACTION */
+#define __NR_rt_sigprocmask 135
+__SYSCALL(__NR_rt_sigprocmask, sys_rt_sigprocmask)
+#define __NR_rt_sigpending 136
+__SYSCALL(__NR_rt_sigpending, sys_rt_sigpending)
+#define __NR_rt_sigtimedwait 137
+__SYSCALL(__NR_rt_sigtimedwait, sys_rt_sigtimedwait)
+#define __NR_rt_sigqueueinfo 138
+__SYSCALL(__NR_rt_sigqueueinfo, sys_rt_sigqueueinfo)
+#define __NR_rt_sigreturn 139
+__SYSCALL(__NR_rt_sigreturn, sys_rt_sigreturn) /* sys_rt_sigreturn_wrapper, */
+
+/* kernel/sys.c */
+#define __NR_setpriority 140
+__SYSCALL(__NR_setpriority, sys_setpriority)
+#define __NR_getpriority 141
+__SYSCALL(__NR_getpriority, sys_getpriority)
+#define __NR_reboot 142
+__SYSCALL(__NR_reboot, sys_reboot)
+#define __NR_setregid 143
+__SYSCALL(__NR_setregid, sys_setregid)
+#define __NR_setgid 144
+__SYSCALL(__NR_setgid, sys_setgid)
+#define __NR_setreuid 145
+__SYSCALL(__NR_setreuid, sys_setreuid)
+#define __NR_setuid 146
+__SYSCALL(__NR_setuid, sys_setuid)
+#define __NR_setresuid 147
+__SYSCALL(__NR_setresuid, sys_setresuid)
+#define __NR_getresuid 148
+__SYSCALL(__NR_getresuid, sys_getresuid)
+#define __NR_setresgid 149
+__SYSCALL(__NR_setresgid, sys_setresgid)
+#define __NR_getresgid 150
+__SYSCALL(__NR_getresgid, sys_getresgid)
+#define __NR_setfsuid 151
+__SYSCALL(__NR_setfsuid, sys_setfsuid)
+#define __NR_setfsgid 152
+__SYSCALL(__NR_setfsgid, sys_setfsgid)
+#define __NR_times 153
+__SYSCALL(__NR_times, sys_times)
+#define __NR_setpgid 154
+__SYSCALL(__NR_setpgid, sys_setpgid)
+#define __NR_getpgid 155
+__SYSCALL(__NR_getpgid, sys_getpgid)
+#define __NR_getsid 156
+__SYSCALL(__NR_getsid, sys_getsid)
+#define __NR_setsid 157
+__SYSCALL(__NR_setsid, sys_setsid)
+#define __NR_getgroups 158
+__SYSCALL(__NR_getgroups, sys_getgroups)
+#define __NR_setgroups 159
+__SYSCALL(__NR_setgroups, sys_setgroups)
+#define __NR_uname 160
+__SYSCALL(__NR_uname, sys_newuname)
+#define __NR_sethostname 161
+__SYSCALL(__NR_sethostname, sys_sethostname)
+#define __NR_setdomainname 162
+__SYSCALL(__NR_setdomainname, sys_setdomainname)
+#define __NR_getrlimit 163
+__SYSCALL(__NR_getrlimit, sys_getrlimit)
+#define __NR_setrlimit 164
+__SYSCALL(__NR_setrlimit, sys_setrlimit)
+#define __NR_getrusage 165
+__SYSCALL(__NR_getrusage, sys_getrusage)
+#define __NR_umask 166
+__SYSCALL(__NR_umask, sys_umask)
+#define __NR_prctl 167
+__SYSCALL(__NR_prctl, sys_prctl)
+#define __NR_getcpu 168
+__SYSCALL(__NR_getcpu, sys_getcpu)
+
+/* kernel/time.c */
+#define __NR_gettimeofday 169
+__SYSCALL(__NR_gettimeofday, sys_gettimeofday)
+#define __NR_settimeofday 170
+__SYSCALL(__NR_settimeofday, sys_settimeofday)
+#define __NR_adjtimex 171
+__SYSCALL(__NR_adjtimex, sys_adjtimex)
+
+/* kernel/timer.c */
+#define __NR_getpid 172
+__SYSCALL(__NR_getpid, sys_getpid)
+#define __NR_getppid 173
+__SYSCALL(__NR_getppid, sys_getppid)
+#define __NR_getuid 174
+__SYSCALL(__NR_getuid, sys_getuid)
+#define __NR_geteuid 175
+__SYSCALL(__NR_geteuid, sys_geteuid)
+#define __NR_getgid 176
+__SYSCALL(__NR_getgid, sys_getgid)
+#define __NR_getegid 177
+__SYSCALL(__NR_getegid, sys_getegid)
+#define __NR_gettid 178
+__SYSCALL(__NR_gettid, sys_gettid)
+#define __NR_sysinfo 179
+__SYSCALL(__NR_sysinfo, sys_sysinfo)
+
+/* ipc/mqueue.c */
+#define __NR_mq_open 180
 __SYSCALL(__NR_mq_open, sys_mq_open)
-#define __NR_mq_unlink				241
+#define __NR_mq_unlink 181
 __SYSCALL(__NR_mq_unlink, sys_mq_unlink)
-#define __NR_mq_timedsend			242
+#define __NR_mq_timedsend 182
 __SYSCALL(__NR_mq_timedsend, sys_mq_timedsend)
-#define __NR_mq_timedreceive			243
+#define __NR_mq_timedreceive 183
 __SYSCALL(__NR_mq_timedreceive, sys_mq_timedreceive)
-#define __NR_mq_notify				244
+#define __NR_mq_notify 184
 __SYSCALL(__NR_mq_notify, sys_mq_notify)
-#define __NR_mq_getsetattr			245
+#define __NR_mq_getsetattr 185
 __SYSCALL(__NR_mq_getsetattr, sys_mq_getsetattr)
-#define __NR_kexec_load				246
-__SYSCALL(__NR_kexec_load, sys_kexec_load)
-#define __NR_waitid				247
-__SYSCALL(__NR_waitid, sys_waitid)
-#define __NR_add_key				248
+
+/* ipc/msg.c */
+#define __NR_msgget 186
+__SYSCALL(__NR_msgget, sys_msgget)
+#define __NR_msgctl 187
+__SYSCALL(__NR_msgctl, sys_msgctl)
+#define __NR_msgrcv 188
+__SYSCALL(__NR_msgrcv, sys_msgrcv)
+#define __NR_msgsnd 189
+__SYSCALL(__NR_msgsnd, sys_msgsnd)
+
+/* ipc/sem.c */
+#define __NR_semget 190
+__SYSCALL(__NR_semget, sys_semget)
+#define __NR_semctl 191
+__SYSCALL(__NR_semctl, sys_semctl)
+#define __NR_semtimedop 192
+__SYSCALL(__NR_semtimedop, sys_semtimedop)
+#define __NR_semop 193
+__SYSCALL(__NR_semop, sys_semop)
+
+/* ipc/shm.c */
+#define __NR_shmget 194
+__SYSCALL(__NR_shmget, sys_shmget)
+#define __NR_shmctl 195
+__SYSCALL(__NR_shmctl, sys_shmctl)
+#define __NR_shmat 196
+__SYSCALL(__NR_shmat, sys_shmat)
+#define __NR_shmdt 197
+__SYSCALL(__NR_shmdt, sys_shmdt)
+
+/* net/socket.c */
+#define __NR_socket 198
+__SYSCALL(__NR_socket, sys_socket)
+#define __NR_socketpair 199
+__SYSCALL(__NR_socketpair, sys_socketpair)
+#define __NR_bind 200
+__SYSCALL(__NR_bind, sys_bind)
+#define __NR_listen 201
+__SYSCALL(__NR_listen, sys_listen)
+#define __NR_accept 202
+__SYSCALL(__NR_accept, sys_accept)
+#define __NR_connect 203
+__SYSCALL(__NR_connect, sys_connect)
+#define __NR_getsockname 204
+__SYSCALL(__NR_getsockname, sys_getsockname)
+#define __NR_getpeername 205
+__SYSCALL(__NR_getpeername, sys_getpeername)
+#define __NR_sendto 206
+__SYSCALL(__NR_sendto, sys_sendto)
+#define __NR_recvfrom 207
+__SYSCALL(__NR_recvfrom, sys_recvfrom)
+#define __NR_setsockopt 208
+__SYSCALL(__NR_setsockopt, sys_setsockopt)
+#define __NR_getsockopt 209
+__SYSCALL(__NR_getsockopt, sys_getsockopt)
+#define __NR_shutdown 210
+__SYSCALL(__NR_shutdown, sys_shutdown)
+#define __NR_sendmsg 211
+__SYSCALL(__NR_sendmsg, sys_sendmsg)
+#define __NR_recvmsg 212
+__SYSCALL(__NR_recvmsg, sys_recvmsg)
+
+/* mm/filemap.c */
+#define __NR_readahead 213
+__SYSCALL(__NR_readahead, sys_readahead)
+
+/* mm/nommu.c, also with MMU */
+#define __NR_brk 214
+__SYSCALL(__NR_brk, sys_brk)
+#define __NR_munmap 215
+__SYSCALL(__NR_munmap, sys_munmap)
+#define __NR_mremap 216
+__SYSCALL(__NR_mremap, sys_mremap)
+
+/* security/keys/keyctl.c */
+#define __NR_add_key 217
 __SYSCALL(__NR_add_key, sys_add_key)
-#define __NR_request_key			249
+#define __NR_request_key 218
 __SYSCALL(__NR_request_key, sys_request_key)
-#define __NR_keyctl				250
+#define __NR_keyctl 219
 __SYSCALL(__NR_keyctl, sys_keyctl)
-#define __NR_ioprio_set				251
-__SYSCALL(__NR_ioprio_set, sys_ioprio_set)
-#define __NR_ioprio_get				252
-__SYSCALL(__NR_ioprio_get, sys_ioprio_get)
-#define __NR_inotify_init			253
-__SYSCALL(__NR_inotify_init, sys_inotify_init)
-#define __NR_inotify_add_watch			254
-__SYSCALL(__NR_inotify_add_watch, sys_inotify_add_watch)
-#define __NR_inotify_rm_watch			255
-__SYSCALL(__NR_inotify_rm_watch, sys_inotify_rm_watch)
-#define __NR_migrate_pages			256
+
+/* arch/example/kernel/sys_example.c */
+#define __NR_clone 220
+__SYSCALL(__NR_clone, sys_clone)	/* .long sys_clone_wrapper */
+#define __NR_execve 221
+__SYSCALL(__NR_execve, sys_execve)	/* .long sys_execve_wrapper */
+
+#define __NR3264_mmap 222
+__SC_3264(__NR3264_mmap, sys_mmap2, sys_mmap)
+/* mm/fadvise.c */
+#define __NR3264_fadvise64 223
+__SC_3264(__NR3264_fadvise64, sys_fadvise64_64, sys_fadvise64)
+
+/* mm/, CONFIG_MMU only */
+#ifndef __ARCH_NOMMU
+#define __NR_swapon 224
+__SYSCALL(__NR_swapon, sys_swapon)
+#define __NR_swapoff 225
+__SYSCALL(__NR_swapoff, sys_swapoff)
+#define __NR_mprotect 226
+__SYSCALL(__NR_mprotect, sys_mprotect)
+#define __NR_msync 227
+__SYSCALL(__NR_msync, sys_msync)
+#define __NR_mlock 228
+__SYSCALL(__NR_mlock, sys_mlock)
+#define __NR_munlock 229
+__SYSCALL(__NR_munlock, sys_munlock)
+#define __NR_mlockall 230
+__SYSCALL(__NR_mlockall, sys_mlockall)
+#define __NR_munlockall 231
+__SYSCALL(__NR_munlockall, sys_munlockall)
+#define __NR_mincore 232
+__SYSCALL(__NR_mincore, sys_mincore)
+#define __NR_madvise 233
+__SYSCALL(__NR_madvise, sys_madvise)
+#define __NR_remap_file_pages 234
+__SYSCALL(__NR_remap_file_pages, sys_remap_file_pages)
+#define __NR_mbind 235
+__SYSCALL(__NR_mbind, sys_mbind)
+#define __NR_get_mempolicy 236
+__SYSCALL(__NR_get_mempolicy, sys_get_mempolicy)
+#define __NR_set_mempolicy 237
+__SYSCALL(__NR_set_mempolicy, sys_set_mempolicy)
+#define __NR_migrate_pages 238
 __SYSCALL(__NR_migrate_pages, sys_migrate_pages)
-#define __NR_openat				257
-__SYSCALL(__NR_openat, sys_openat)
-#define __NR_mkdirat				258
-__SYSCALL(__NR_mkdirat, sys_mkdirat)
-#define __NR_mknodat				259
-__SYSCALL(__NR_mknodat, sys_mknodat)
-#define __NR_fchownat				260
-__SYSCALL(__NR_fchownat, sys_fchownat)
-#define __NR_futimesat				261
-__SYSCALL(__NR_futimesat, sys_futimesat)
-#define __NR_newfstatat				262
-__SYSCALL(__NR_newfstatat, sys_newfstatat)
-#define __NR_unlinkat				263
-__SYSCALL(__NR_unlinkat, sys_unlinkat)
-#define __NR_renameat				264
-__SYSCALL(__NR_renameat, sys_renameat)
-#define __NR_linkat				265
-__SYSCALL(__NR_linkat, sys_linkat)
-#define __NR_symlinkat				266
-__SYSCALL(__NR_symlinkat, sys_symlinkat)
-#define __NR_readlinkat				267
-__SYSCALL(__NR_readlinkat, sys_readlinkat)
-#define __NR_fchmodat				268
-__SYSCALL(__NR_fchmodat, sys_fchmodat)
-#define __NR_faccessat				269
-__SYSCALL(__NR_faccessat, sys_faccessat)
-#define __NR_pselect6				270
-__SYSCALL(__NR_pselect6, sys_pselect6)
-#define __NR_ppoll				271
-__SYSCALL(__NR_ppoll,	sys_ppoll)
-#define __NR_unshare				272
-__SYSCALL(__NR_unshare,	sys_unshare)
-#define __NR_set_robust_list			273
-__SYSCALL(__NR_set_robust_list, sys_set_robust_list)
-#define __NR_get_robust_list			274
-__SYSCALL(__NR_get_robust_list, sys_get_robust_list)
-#define __NR_splice				275
-__SYSCALL(__NR_splice, sys_splice)
-#define __NR_tee				276
-__SYSCALL(__NR_tee, sys_tee)
-#define __NR_sync_file_range			277
-__SYSCALL(__NR_sync_file_range, sys_sync_file_range)
-#define __NR_vmsplice				278
-__SYSCALL(__NR_vmsplice, sys_vmsplice)
-#define __NR_move_pages				279
+#define __NR_move_pages 239
 __SYSCALL(__NR_move_pages, sys_move_pages)
-#define __NR_utimensat				280
-__SYSCALL(__NR_utimensat, sys_utimensat)
-#define __IGNORE_getcpu		/* implemented as a vsyscall */
-#define __NR_epoll_pwait			281
-__SYSCALL(__NR_epoll_pwait, sys_epoll_pwait)
-#define __NR_signalfd				282
-__SYSCALL(__NR_signalfd, sys_signalfd)
-#define __NR_timerfd_create			283
-__SYSCALL(__NR_timerfd_create, sys_timerfd_create)
-#define __NR_eventfd				284
+#endif
+
+#undef __NR_syscalls
+#define __NR_syscalls 240
+
+/*
+ * All syscalls below here should go away really,
+ * these are provided for both review and as a porting
+ * help for the C library version.
+*
+ * Last chance: are any of these important enought to
+ * enable by default?
+ */
+#ifdef __ARCH_WANT_SYSCALL_NO_AT
+#define __NR_open 1024
+__SYSCALL(__NR_open, sys_open)
+#define __NR_link 1025
+__SYSCALL(__NR_link, sys_link)
+#define __NR_unlink 1026
+__SYSCALL(__NR_unlink, sys_unlink)
+#define __NR_mknod 1027
+__SYSCALL(__NR_mknod, sys_mknod)
+#define __NR_chmod 1028
+__SYSCALL(__NR_chmod, sys_chmod)
+#define __NR_chown 1029
+__SYSCALL(__NR_chown, sys_chown)
+#define __NR_mkdir 1030
+__SYSCALL(__NR_mkdir, sys_mkdir)
+#define __NR_rmdir 1031
+__SYSCALL(__NR_rmdir, sys_rmdir)
+#define __NR_lchown 1032
+__SYSCALL(__NR_lchown, sys_lchown)
+#define __NR_access 1033
+__SYSCALL(__NR_access, sys_access)
+#define __NR_rename 1034
+__SYSCALL(__NR_rename, sys_rename)
+#define __NR_readlink 1035
+__SYSCALL(__NR_readlink, sys_readlink)
+#define __NR_symlink 1036
+__SYSCALL(__NR_symlink, sys_symlink)
+#define __NR_utimes 1037
+__SYSCALL(__NR_utimes, sys_utimes)
+#define __NR3264_stat 1038
+__SC_3264(__NR3264_stat, sys_stat64, sys_newstat)
+#define __NR3264_lstat 1039
+__SC_3264(__NR3264_lstat, sys_lstat64, sys_newlstat)
+
+#undef __NR_syscalls
+#define __NR_syscalls (__NR3264_lstat+1)
+#endif /* __ARCH_WANT_SYSCALL_NO_AT */
+
+#ifdef __ARCH_WANT_SYSCALL_NO_FLAGS
+#define __NR_pipe 1040
+__SYSCALL(__NR_pipe, sys_pipe)
+#define __NR_dup2 1041
+__SYSCALL(__NR_dup2, sys_dup2)
+#define __NR_epoll_create 1042
+__SYSCALL(__NR_epoll_create, sys_epoll_create)
+#define __NR_inotify_init 1043
+__SYSCALL(__NR_inotify_init, sys_inotify_init)
+#define __NR_eventfd 1044
 __SYSCALL(__NR_eventfd, sys_eventfd)
-#define __NR_fallocate				285
-__SYSCALL(__NR_fallocate, sys_fallocate)
-#define __NR_timerfd_settime			286
-__SYSCALL(__NR_timerfd_settime, sys_timerfd_settime)
-#define __NR_timerfd_gettime			287
-__SYSCALL(__NR_timerfd_gettime, sys_timerfd_gettime)
-#define __NR_accept4				288
-__SYSCALL(__NR_accept4, sys_accept4)
-#define __NR_signalfd4				289
-__SYSCALL(__NR_signalfd4, sys_signalfd4)
-#define __NR_eventfd2				290
-__SYSCALL(__NR_eventfd2, sys_eventfd2)
-#define __NR_epoll_create1			291
-__SYSCALL(__NR_epoll_create1, sys_epoll_create1)
-#define __NR_dup3				292
-__SYSCALL(__NR_dup3, sys_dup3)
-#define __NR_pipe2				293
-__SYSCALL(__NR_pipe2, sys_pipe2)
-#define __NR_inotify_init1			294
-__SYSCALL(__NR_inotify_init1, sys_inotify_init1)
-#define __NR_preadv				295
-__SYSCALL(__NR_preadv, sys_preadv)
-#define __NR_pwritev				296
-__SYSCALL(__NR_pwritev, sys_pwritev)
+#define __NR_signalfd 1045
+__SYSCALL(__NR_signalfd, sys_signalfd)
+
+#undef __NR_syscalls
+#define __NR_syscalls (__NR_signalfd+1)
+#endif /* __ARCH_WANT_SYSCALL_NO_FLAGS */
+
+#if __BITS_PER_LONG == 32 && defined(__ARCH_WANT_SYSCALL_OFF_T)
+#define __NR_sendfile 1046
+__SYSCALL(__NR_sendfile, sys_sendfile)
+#define __NR_ftruncate 1047
+__SYSCALL(__NR_ftruncate, sys_ftruncate)
+#define __NR_truncate 1048
+__SYSCALL(__NR_truncate, sys_truncate)
+#define __NR_stat 1049
+__SYSCALL(__NR_stat, sys_newstat)
+#define __NR_lstat 1050
+__SYSCALL(__NR_lstat, sys_newlstat)
+#define __NR_fstat 1051
+__SYSCALL(__NR_fstat, sys_newfstat)
+#define __NR_fcntl 1052
+__SYSCALL(__NR_fcntl, sys_fcntl)
+#define __NR_fadvise64 1053
+#define __ARCH_WANT_SYS_FADVISE64
+__SYSCALL(__NR_fadvise64, sys_fadvise64)
+#define __NR_newfstatat 1054
+#define __ARCH_WANT_SYS_NEWFSTATAT
+__SYSCALL(__NR_newfstatat, sys_newfstatat)
+#define __NR_fstatfs 1055
+__SYSCALL(__NR_fstatfs, sys_fstatfs)
+#define __NR_statfs 1056
+__SYSCALL(__NR_statfs, sys_statfs)
+#define __NR_lseek 1057
+__SYSCALL(__NR_lseek, sys_lseek)
+#define __NR_mmap 1058
+__SYSCALL(__NR_mmap, sys_mmap)
 
+#undef __NR_syscalls
+#define __NR_syscalls (__NR_mmap+1)
+#endif /* 32 bit off_t syscalls */
 
-#ifndef __NO_STUBS
-#define __ARCH_WANT_OLD_READDIR
-#define __ARCH_WANT_OLD_STAT
+#ifdef __ARCH_WANT_SYSCALL_DEPRECATED
+#define __NR_alarm 1059
 #define __ARCH_WANT_SYS_ALARM
-#define __ARCH_WANT_SYS_GETHOSTNAME
+__SYSCALL(__NR_alarm, sys_alarm)
+#define __NR_getpgrp 1060
+#define __ARCH_WANT_SYS_GETPGRP
+__SYSCALL(__NR_getpgrp, sys_getpgrp)
+#define __NR_pause 1061
 #define __ARCH_WANT_SYS_PAUSE
-#define __ARCH_WANT_SYS_SGETMASK
-#define __ARCH_WANT_SYS_SIGNAL
+__SYSCALL(__NR_pause, sys_pause)
+#define __NR_time 1062
+#define __ARCH_WANT_SYS_TIME
+__SYSCALL(__NR_time, sys_time)
+#define __NR_utime 1063
 #define __ARCH_WANT_SYS_UTIME
-#define __ARCH_WANT_SYS_WAITPID
-#define __ARCH_WANT_SYS_SOCKETCALL
-#define __ARCH_WANT_SYS_FADVISE64
-#define __ARCH_WANT_SYS_GETPGRP
+__SYSCALL(__NR_utime, sys_utime)
+
+#define __NR_creat 1064
+__SYSCALL(__NR_creat, sys_creat)
+#define __NR_getdents 1065
+#define __ARCH_WANT_SYS_GETDENTS
+__SYSCALL(__NR_getdents, sys_getdents)
+#define __NR_futimesat 1066
+__SYSCALL(__NR_futimesat, sys_futimesat)
+#define __NR_select 1067
+#define __ARCH_WANT_SYS_SELECT
+__SYSCALL(__NR_select, sys_select)
+#define __NR_poll 1068
+__SYSCALL(__NR_poll, sys_poll)
+#define __NR_epoll_wait 1069
+__SYSCALL(__NR_epoll_wait, sys_epoll_wait)
+#define __NR_ustat 1070
+__SYSCALL(__NR_ustat, sys_ustat)
+#define __NR_vfork 1071
+__SYSCALL(__NR_vfork, sys_vfork)
+#define __NR_wait4 1072
+__SYSCALL(__NR_wait4, sys_wait4)
+
+#define __NR_fork 1073
+#ifdef CONFIG_MMU
+__SYSCALL(__NR_fork, sys_fork)
+#else
+__SYSCALL(__NR_fork, sys_ni_syscall)
+#endif /* CONFIG_MMU */
+
+#undef __NR_syscalls
+#define __NR_syscalls (__NR_fork+1)
+
+#endif /* __ARCH_WANT_SYSCALL_DEPRECATED */
+
+/*
+ * 32 bit systems traditionally used different
+ * syscalls for off_t and loff_t arguments, while
+ * 64 bit systems only need the off_t version.
+ * For new 32 bit platforms, there is no need to
+ * implement the old 32 bit off_t syscalls, so
+ * they take different names.
+ * Here we map the numbers so that both versions
+ * use the same syscall table layout.
+ */
+#if __BITS_PER_LONG == 64
+#define __NR_fcntl __NR3264_fcntl
+#define __NR_statfs __NR3264_statfs
+#define __NR_fstatfs __NR3264_fstatfs
+#define __NR_truncate __NR3264_truncate
+#define __NR_ftruncate __NR3264_truncate
+#define __NR_lseek __NR3264_lseek
+#define __NR_sendfile __NR3264_sendfile
+#define __NR_newfstatat __NR3264_fstatat
+#define __NR_fstat __NR3264_fstat
+#define __NR_mmap __NR3264_mmap
+#define __NR_fadvise64 __NR3264_fadvise64
+#ifdef __NR3264_stat
+#define __NR_stat __NR3264_stat
+#define __NR_lstat __NR3264_lstat
+#endif
+#else
+#define __NR_fcntl64 __NR3264_fcntl
+#define __NR_statfs64 __NR3264_statfs
+#define __NR_fstatfs64 __NR3264_fstatfs
+#define __NR_truncate64 __NR3264_truncate
+#define __NR_ftruncate64 __NR3264_truncate
+#define __NR_llseek __NR3264_lseek
+#define __NR_sendfile64 __NR3264_sendfile
+#define __NR_fstatat64 __NR3264_fstatat
+#define __NR_fstat64 __NR3264_fstat
+#define __NR_mmap2 __NR3264_mmap
+#define __NR_fadvise64_64 __NR3264_fadvise64
+#ifdef __NR3264_stat
+#define __NR_stat64 __NR3264_stat
+#define __NR_lstat64 __NR3264_lstat
+#endif
+#endif
+
+#ifdef __KERNEL__
+
+/*
+ * These are required system calls, we should
+ * invert the logic eventually and let them
+ * be selected by default.
+ */
+#if __BITS_PER_LONG == 32
+#define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_LLSEEK
-#define __ARCH_WANT_SYS_NICE
-#define __ARCH_WANT_SYS_OLD_GETRLIMIT
-#define __ARCH_WANT_SYS_OLDUMOUNT
-#define __ARCH_WANT_SYS_SIGPENDING
-#define __ARCH_WANT_SYS_SIGPROCMASK
+#endif
 #define __ARCH_WANT_SYS_RT_SIGACTION
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
-#define __ARCH_WANT_SYS_TIME
-#define __ARCH_WANT_COMPAT_SYS_TIME
-#endif	/* __NO_STUBS */
 
-#ifdef __KERNEL__
 /*
  * "Conditional" syscalls
  *
  * What we want is __attribute__((weak,alias("sys_ni_syscall"))),
  * but it doesn't work on all toolchains, so we just do it by hand
  */
+#ifndef cond_syscall
 #define cond_syscall(x) asm(".weak\t" #x "\n\t.set\t" #x ",sys_ni_syscall")
-#endif	/* __KERNEL__ */
+#endif
 
-#endif /* _ASM_X86_UNISTD_64_H */
+#endif /* __KERNEL__ */
+#endif /* _ASM_GENERIC_UNISTD_H */
