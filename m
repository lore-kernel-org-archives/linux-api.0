From: <arnd-r2nGTMty4D4@public.gmane.org>
Subject: (unknown)
Date: Mon, 27 Apr 2009 10:41:22 -0400
Message-ID: <20090427143738.347089506@arndb.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

>From arnd-r2nGTMty4D4@public.gmane.org Mon Apr 27 16:28:40 2009
References: <20090427142010.587518220-r2nGTMty4D4@public.gmane.org>
User-Agent: quilt/0.46-1
Date: Mon, 27 Apr 2009 16:20:20 +0200
From: arnd-r2nGTMty4D4@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: john.williams-g5w7nrANp4BDPfheJLI6IQ@public.gmane.org,
 monstr-pSz03upnqPeHXe+LvDLADg@public.gmane.org,
 linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 liqin.chen-+XGAvkf1AAHby3iVrkZq2A@public.gmane.org,
 Sam Ravnborg <sam-uyr5N9Q2VtJg9hUCZPvPmw@public.gmane.org>,
 Remis Lima Baima <remis.developer-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: [RFC 10/17] asm-generic: provide generic ABI headers
Content-Disposition: inline; filename=0006-asm-generic-provide-generic-ABI-headers.patch
X-Provags-ID: V01U2FsdGVkX18PSRZiW4+EZJqFTk5r5Yj5Zxoc6HvEGkxOKBW
 xlKIlQY3tbNzgAR5oFFoT/CjQ4ViOXH1L5gfF0VuPgx0Nm4EGZ
 zBYvx/PVahU2VUh4yHWog==

These header files are typically copied from an existing architecture
into any new one, slightly modified and then remain untouched until
the end of time in the name of ABI stability.

To make it easier for future architectures, provide a sane generic
version here. In cases where multiple architectures already use
identical code, I used the most common version. In cases like
stat.h that are more or less broken everywhere, I provide a
version that is meant to be ideal for new architectures.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Signed-off-by: Remis Lima Baima <remis.developer-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
---
 include/asm-generic/Kbuild        |   12 	12 +	0 -	0 !
 include/asm-generic/auxvec.h      |    8 	8 +	0 -	0 !
 include/asm-generic/ioctls.h      |  110 	110 +	0 -	0 !
 include/asm-generic/param.h       |   24 	24 +	0 -	0 !
 include/asm-generic/posix_types.h |  166 	166 +	0 -	0 !
 include/asm-generic/setup.h       |    6 	6 +	0 -	0 !
 include/asm-generic/socket.h      |   60 	60 +	0 -	0 !
 include/asm-generic/sockios.h     |   13 	13 +	0 -	0 !
 include/asm-generic/stat.h        |   72 	72 +	0 -	0 !
 include/asm-generic/swab.h        |   18 	18 +	0 -	0 !
 include/asm-generic/termbits.h    |  198 	198 +	0 -	0 !
 include/asm-generic/ucontext.h    |   12 	12 +	0 -	0 !
 12 files changed, 699 insertions(+)
 create mode 100644 include/asm-generic/auxvec.h
 create mode 100644 include/asm-generic/ioctls.h
 create mode 100644 include/asm-generic/param.h
 create mode 100644 include/asm-generic/posix_types.h
 create mode 100644 include/asm-generic/setup.h
 create mode 100644 include/asm-generic/socket.h
 create mode 100644 include/asm-generic/sockios.h
 create mode 100644 include/asm-generic/stat.h
 create mode 100644 include/asm-generic/termbits.h
 create mode 100644 include/asm-generic/ucontext.h

Index: linux-2.6/include/asm-generic/Kbuild
===================================================================
--- linux-2.6.orig/include/asm-generic/Kbuild
+++ linux-2.6/include/asm-generic/Kbuild
@@ -1,20 +1,32 @@
+header-y += auxvec.h
+header-y += byteorder.h
 header-y += errno-base.h
 header-y += errno.h
 header-y += fcntl.h
 header-y += ioctl.h
+header-y += ioctls.h
 header-y += ipcbuf.h
 header-y += mman-common.h
 header-y += mman.h
 header-y += msgbuf.h
+header-y += param.h
 header-y += poll.h
+header-y += posix_types.h
 header-y += sembuf.h
+header-y += setup.h
 header-y += shmbuf.h
 header-y += shmparam.h
 header-y += signal-defs.h
 header-y += signal.h
+header-y += socket.h
+header-y += sockios.h
+header-y += stat.h
 header-y += statfs.h
+header-y += swab.h
+header-y += termbits.h
 header-y += termios.h
 header-y += types.h
+header-y += ucontext.h
 
 unifdef-y += int-l64.h
 unifdef-y += int-ll64.h
Index: linux-2.6/include/asm-generic/auxvec.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/auxvec.h
@@ -0,0 +1,8 @@
+#ifndef __ASM_GENERIC_AUXVEC_H
+#define __ASM_GENERIC_AUXVEC_H
+/*
+ * Not all architectures need their own auxvec.h, the most
+ * common definitions are already in linux/auxvec.h.
+ */
+
+#endif /* __ASM_GENERIC_AUXVEC_H */
Index: linux-2.6/include/asm-generic/ioctls.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/ioctls.h
@@ -0,0 +1,110 @@
+#ifndef __ASM_GENERIC_IOCTLS_H
+#define __ASM_GENERIC_IOCTLS_H
+
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
+
+/* 0x54 is just a magic number to make these relatively unique ('T') */
+
+#define TCGETS		0x5401
+#define TCSETS		0x5402
+#define TCSETSW		0x5403
+#define TCSETSF		0x5404
+#define TCGETA		0x5405
+#define TCSETA		0x5406
+#define TCSETAW		0x5407
+#define TCSETAF		0x5408
+#define TCSBRK		0x5409
+#define TCXONC		0x540A
+#define TCFLSH		0x540B
+#define TIOCEXCL	0x540C
+#define TIOCNXCL	0x540D
+#define TIOCSCTTY	0x540E
+#define TIOCGPGRP	0x540F
+#define TIOCSPGRP	0x5410
+#define TIOCOUTQ	0x5411
+#define TIOCSTI		0x5412
+#define TIOCGWINSZ	0x5413
+#define TIOCSWINSZ	0x5414
+#define TIOCMGET	0x5415
+#define TIOCMBIS	0x5416
+#define TIOCMBIC	0x5417
+#define TIOCMSET	0x5418
+#define TIOCGSOFTCAR	0x5419
+#define TIOCSSOFTCAR	0x541A
+#define FIONREAD	0x541B
+#define TIOCINQ		FIONREAD
+#define TIOCLINUX	0x541C
+#define TIOCCONS	0x541D
+#define TIOCGSERIAL	0x541E
+#define TIOCSSERIAL	0x541F
+#define TIOCPKT		0x5420
+#define FIONBIO		0x5421
+#define TIOCNOTTY	0x5422
+#define TIOCSETD	0x5423
+#define TIOCGETD	0x5424
+#define TCSBRKP		0x5425	/* Needed for POSIX tcsendbreak() */
+#define TIOCSBRK	0x5427  /* BSD compatibility */
+#define TIOCCBRK	0x5428  /* BSD compatibility */
+#define TIOCGSID	0x5429  /* Return the session ID of FD */
+#define TCGETS2		_IOR('T', 0x2A, struct termios2)
+#define TCSETS2		_IOW('T', 0x2B, struct termios2)
+#define TCSETSW2	_IOW('T', 0x2C, struct termios2)
+#define TCSETSF2	_IOW('T', 0x2D, struct termios2)
+#define TIOCGRS485	0x542E
+#define TIOCSRS485	0x542F
+#define TIOCGPTN	_IOR('T', 0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
+#define TIOCSPTLCK	_IOW('T', 0x31, int)  /* Lock/unlock Pty */
+#define TCGETX		0x5432 /* SYS5 TCGETX compatibility */
+#define TCSETX		0x5433
+#define TCSETXF		0x5434
+#define TCSETXW		0x5435
+
+#define FIONCLEX	0x5450
+#define FIOCLEX		0x5451
+#define FIOASYNC	0x5452
+#define TIOCSERCONFIG	0x5453
+#define TIOCSERGWILD	0x5454
+#define TIOCSERSWILD	0x5455
+#define TIOCGLCKTRMIOS	0x5456
+#define TIOCSLCKTRMIOS	0x5457
+#define TIOCSERGSTRUCT	0x5458 /* For debugging only */
+#define TIOCSERGETLSR   0x5459 /* Get line status register */
+#define TIOCSERGETMULTI 0x545A /* Get multiport config  */
+#define TIOCSERSETMULTI 0x545B /* Set multiport config */
+
+#define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
+#define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
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
+
+/* Used for packet mode */
+#define TIOCPKT_DATA		 0
+#define TIOCPKT_FLUSHREAD	 1
+#define TIOCPKT_FLUSHWRITE	 2
+#define TIOCPKT_STOP		 4
+#define TIOCPKT_START		 8
+#define TIOCPKT_NOSTOP		16
+#define TIOCPKT_DOSTOP		32
+
+#define TIOCSER_TEMT	0x01	/* Transmitter physically empty */
+
+#endif /* __ASM_GENERIC_IOCTLS_H */
Index: linux-2.6/include/asm-generic/param.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/param.h
@@ -0,0 +1,24 @@
+#ifndef __ASM_GENERIC_PARAM_H
+#define __ASM_GENERIC_PARAM_H
+
+#ifdef __KERNEL__
+# define HZ		CONFIG_HZ	/* Internal kernel timer frequency */
+# define USER_HZ	100		/* some user interfaces are */
+# define CLOCKS_PER_SEC	(USER_HZ)       /* in "ticks" like times() */
+#endif
+
+#ifndef HZ
+#define HZ 100
+#endif
+
+#ifndef EXEC_PAGESIZE
+#define EXEC_PAGESIZE	4096
+#endif
+
+#ifndef NOGROUP
+#define NOGROUP		(-1)
+#endif
+
+#define MAXHOSTNAMELEN	64	/* max length of hostname */
+
+#endif /* __ASM_GENERIC_PARAM_H */
Index: linux-2.6/include/asm-generic/posix_types.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/posix_types.h
@@ -0,0 +1,166 @@
+#ifndef __ASM_GENERIC_POSIX_TYPES_H
+#define __ASM_GENERIC_POSIX_TYPES_H
+
+#include <linux/types.h>
+
+/*
+ * This file is generally used by user-level software, so you need to
+ * be a little careful about namespace pollution etc.
+ *
+ * First the types that are often defined in different ways across
+ * architectures, so that you can override them.
+ */
+
+#ifndef __kernel_ino_t
+typedef unsigned long	__kernel_ino_t;
+#endif
+
+#ifndef __kernel_mode_t
+typedef unsigned int	__kernel_mode_t;
+#endif
+
+#ifndef __kernel_nlink_t
+typedef unsigned long	__kernel_nlink_t;
+#endif
+
+#ifndef __kernel_pid_t
+typedef int		__kernel_pid_t;
+#endif
+
+#ifndef __kernel_ipc_pid_t
+typedef int		__kernel_ipc_pid_t;
+#endif
+
+#ifndef __kernel_uid_t
+typedef unsigned int	__kernel_uid_t;
+typedef unsigned int	__kernel_gid_t;
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
+typedef unsigned long	__kernel_size_t;
+typedef long		__kernel_ssize_t;
+typedef long		__kernel_ptrdiff_t;
+#endif
+#endif
+
+/*
+ * anything below here should be completely generic
+ */
+typedef long		__kernel_off_t;
+typedef long long	__kernel_loff_t;
+typedef long		__kernel_time_t;
+typedef long		__kernel_clock_t;
+typedef int		__kernel_timer_t;
+typedef int		__kernel_clockid_t;
+typedef char *		__kernel_caddr_t;
+typedef unsigned short	__kernel_uid16_t;
+typedef unsigned short	__kernel_gid16_t;
+
+typedef struct {
+	int	val[2];
+} __kernel_fsid_t;
+
+#ifdef __KERNEL__
+
+#undef __FD_SET
+static inline void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
+{
+	unsigned long __tmp = __fd / __NFDBITS;
+	unsigned long __rem = __fd % __NFDBITS;
+	__fdsetp->fds_bits[__tmp] |= (1UL<<__rem);
+}
+
+#undef __FD_CLR
+static inline void __FD_CLR(unsigned long __fd, __kernel_fd_set *__fdsetp)
+{
+	unsigned long __tmp = __fd / __NFDBITS;
+	unsigned long __rem = __fd % __NFDBITS;
+	__fdsetp->fds_bits[__tmp] &= ~(1UL<<__rem);
+}
+
+#undef __FD_ISSET
+static inline int __FD_ISSET(unsigned long __fd, const __kernel_fd_set *__p)
+{
+	unsigned long __tmp = __fd / __NFDBITS;
+	unsigned long __rem = __fd % __NFDBITS;
+	return (__p->fds_bits[__tmp] & (1UL<<__rem)) != 0;
+}
+
+/*
+ * This will unroll the loop for the normal constant case (8 ints,
+ * for a 256-bit fd_set)
+ */
+#undef __FD_ZERO
+static inline void __FD_ZERO(__kernel_fd_set *__p)
+{
+	unsigned long *__tmp = __p->fds_bits;
+	int __i;
+
+	if (__builtin_constant_p(__FDSET_LONGS)) {
+		switch (__FDSET_LONGS) {
+		case 16:
+			__tmp[ 0] = 0; __tmp[ 1] = 0;
+			__tmp[ 2] = 0; __tmp[ 3] = 0;
+			__tmp[ 4] = 0; __tmp[ 5] = 0;
+			__tmp[ 6] = 0; __tmp[ 7] = 0;
+			__tmp[ 8] = 0; __tmp[ 9] = 0;
+			__tmp[10] = 0; __tmp[11] = 0;
+			__tmp[12] = 0; __tmp[13] = 0;
+			__tmp[14] = 0; __tmp[15] = 0;
+			return;
+
+		case 8:
+			__tmp[ 0] = 0; __tmp[ 1] = 0;
+			__tmp[ 2] = 0; __tmp[ 3] = 0;
+			__tmp[ 4] = 0; __tmp[ 5] = 0;
+			__tmp[ 6] = 0; __tmp[ 7] = 0;
+			return;
+
+		case 4:
+			__tmp[ 0] = 0; __tmp[ 1] = 0;
+			__tmp[ 2] = 0; __tmp[ 3] = 0;
+			return;
+		}
+	}
+	__i = __FDSET_LONGS;
+	while (__i) {
+		__i--;
+		*__tmp = 0;
+		__tmp++;
+	}
+}
+
+#endif /* __KERNEL__ */
+
+#endif /* __ASM_GENERIC_POSIX_TYPES_H */
Index: linux-2.6/include/asm-generic/setup.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/setup.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_GENERIC_SETUP_H
+#define __ASM_GENERIC_SETUP_H
+
+#define COMMAND_LINE_SIZE	512
+
+#endif	/* __ASM_GENERIC_SETUP_H */
Index: linux-2.6/include/asm-generic/socket.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/socket.h
@@ -0,0 +1,60 @@
+#ifndef __ASM_GENERIC_SOCKET_H
+#define __ASM_GENERIC_SOCKET_H
+
+#include <asm/sockios.h>
+
+/* For setsockopt(2) */
+#define SOL_SOCKET	1
+
+#define SO_DEBUG	1
+#define SO_REUSEADDR	2
+#define SO_TYPE		3
+#define SO_ERROR	4
+#define SO_DONTROUTE	5
+#define SO_BROADCAST	6
+#define SO_SNDBUF	7
+#define SO_RCVBUF	8
+#define SO_SNDBUFFORCE	32
+#define SO_RCVBUFFORCE	33
+#define SO_KEEPALIVE	9
+#define SO_OOBINLINE	10
+#define SO_NO_CHECK	11
+#define SO_PRIORITY	12
+#define SO_LINGER	13
+#define SO_BSDCOMPAT	14
+/* To add :#define SO_REUSEPORT 15 */
+#define SO_PASSCRED	16
+#define SO_PEERCRED	17
+#define SO_RCVLOWAT	18
+#define SO_SNDLOWAT	19
+#define SO_RCVTIMEO	20
+#define SO_SNDTIMEO	21
+
+/* Security levels - as per NRL IPv6 - don't actually do anything */
+#define SO_SECURITY_AUTHENTICATION		22
+#define SO_SECURITY_ENCRYPTION_TRANSPORT	23
+#define SO_SECURITY_ENCRYPTION_NETWORK		24
+
+#define SO_BINDTODEVICE	25
+
+/* Socket filtering */
+#define SO_ATTACH_FILTER	26
+#define SO_DETACH_FILTER	27
+
+#define SO_PEERNAME		28
+#define SO_TIMESTAMP		29
+#define SCM_TIMESTAMP		SO_TIMESTAMP
+
+#define SO_ACCEPTCONN		30
+
+#define SO_PEERSEC		31
+#define SO_PASSSEC		34
+#define SO_TIMESTAMPNS		35
+#define SCM_TIMESTAMPNS		SO_TIMESTAMPNS
+
+#define SO_MARK			36
+
+#define SO_TIMESTAMPING		37
+#define SCM_TIMESTAMPING	SO_TIMESTAMPING
+
+#endif /* __ASM_GENERIC_SOCKET_H */
Index: linux-2.6/include/asm-generic/sockios.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/sockios.h
@@ -0,0 +1,13 @@
+#ifndef __ASM_GENERIC_SOCKIOS_H
+#define __ASM_GENERIC_SOCKIOS_H
+
+/* Socket-level I/O control calls. */
+#define FIOSETOWN	0x8901
+#define SIOCSPGRP	0x8902
+#define FIOGETOWN	0x8903
+#define SIOCGPGRP	0x8904
+#define SIOCATMARK	0x8905
+#define SIOCGSTAMP	0x8906		/* Get stamp (timeval) */
+#define SIOCGSTAMPNS	0x8907		/* Get stamp (timespec) */
+
+#endif /* __ASM_GENERIC_SOCKIOS_H */
Index: linux-2.6/include/asm-generic/stat.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/stat.h
@@ -0,0 +1,72 @@
+#ifndef __ASM_GENERIC_STAT_H
+#define __ASM_GENERIC_STAT_H
+
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
+ */
+
+#include <asm/bitsperlong.h>
+
+#define STAT_HAVE_NSEC 1
+
+struct stat {
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
+	long		st_blocks;	/* Number 512-byte blocks allocated. */
+	int		st_atime;	/* Time of last access.  */
+	unsigned int	st_atime_nsec;
+	int		st_mtime;	/* Time of last modification.  */
+	unsigned int	st_mtime_nsec;
+	int		st_ctime;	/* Time of last status change.  */
+	unsigned int	st_ctime_nsec;
+	unsigned int	__unused4;
+	unsigned int	__unused5;
+};
+
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
+};
+#endif
+
+#endif /* __ASM_GENERIC_STAT_H */
Index: linux-2.6/include/asm-generic/termbits.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/termbits.h
@@ -0,0 +1,198 @@
+#ifndef __ASM_GENERIC_TERMBITS_H
+#define __ASM_GENERIC_TERMBITS_H
+
+#include <linux/posix_types.h>
+
+typedef unsigned char	cc_t;
+typedef unsigned int	speed_t;
+typedef unsigned int	tcflag_t;
+
+#define NCCS 19
+struct termios {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+};
+
+struct termios2 {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
+struct ktermios {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
+/* c_cc characters */
+#define VINTR 0
+#define VQUIT 1
+#define VERASE 2
+#define VKILL 3
+#define VEOF 4
+#define VTIME 5
+#define VMIN 6
+#define VSWTC 7
+#define VSTART 8
+#define VSTOP 9
+#define VSUSP 10
+#define VEOL 11
+#define VREPRINT 12
+#define VDISCARD 13
+#define VWERASE 14
+#define VLNEXT 15
+#define VEOL2 16
+
+/* c_iflag bits */
+#define IGNBRK	0000001
+#define BRKINT	0000002
+#define IGNPAR	0000004
+#define PARMRK	0000010
+#define INPCK	0000020
+#define ISTRIP	0000040
+#define INLCR	0000100
+#define IGNCR	0000200
+#define ICRNL	0000400
+#define IUCLC	0001000
+#define IXON	0002000
+#define IXANY	0004000
+#define IXOFF	0010000
+#define IMAXBEL	0020000
+#define IUTF8	0040000
+
+/* c_oflag bits */
+#define OPOST	0000001
+#define OLCUC	0000002
+#define ONLCR	0000004
+#define OCRNL	0000010
+#define ONOCR	0000020
+#define ONLRET	0000040
+#define OFILL	0000100
+#define OFDEL	0000200
+#define NLDLY	0000400
+#define   NL0	0000000
+#define   NL1	0000400
+#define CRDLY	0003000
+#define   CR0	0000000
+#define   CR1	0001000
+#define   CR2	0002000
+#define   CR3	0003000
+#define TABDLY	0014000
+#define   TAB0	0000000
+#define   TAB1	0004000
+#define   TAB2	0010000
+#define   TAB3	0014000
+#define   XTABS	0014000
+#define BSDLY	0020000
+#define   BS0	0000000
+#define   BS1	0020000
+#define VTDLY	0040000
+#define   VT0	0000000
+#define   VT1	0040000
+#define FFDLY	0100000
+#define   FF0	0000000
+#define   FF1	0100000
+
+/* c_cflag bit meaning */
+#define CBAUD	0010017
+#define  B0	0000000		/* hang up */
+#define  B50	0000001
+#define  B75	0000002
+#define  B110	0000003
+#define  B134	0000004
+#define  B150	0000005
+#define  B200	0000006
+#define  B300	0000007
+#define  B600	0000010
+#define  B1200	0000011
+#define  B1800	0000012
+#define  B2400	0000013
+#define  B4800	0000014
+#define  B9600	0000015
+#define  B19200	0000016
+#define  B38400	0000017
+#define EXTA B19200
+#define EXTB B38400
+#define CSIZE	0000060
+#define   CS5	0000000
+#define   CS6	0000020
+#define   CS7	0000040
+#define   CS8	0000060
+#define CSTOPB	0000100
+#define CREAD	0000200
+#define PARENB	0000400
+#define PARODD	0001000
+#define HUPCL	0002000
+#define CLOCAL	0004000
+#define CBAUDEX 0010000
+#define    BOTHER 0010000
+#define    B57600 0010001
+#define   B115200 0010002
+#define   B230400 0010003
+#define   B460800 0010004
+#define   B500000 0010005
+#define   B576000 0010006
+#define   B921600 0010007
+#define  B1000000 0010010
+#define  B1152000 0010011
+#define  B1500000 0010012
+#define  B2000000 0010013
+#define  B2500000 0010014
+#define  B3000000 0010015
+#define  B3500000 0010016
+#define  B4000000 0010017
+#define CIBAUD	  002003600000	/* input baud rate */
+#define CMSPAR	  010000000000	/* mark or space (stick) parity */
+#define CRTSCTS	  020000000000	/* flow control */
+
+#define IBSHIFT	  16		/* Shift from CBAUD to CIBAUD */
+
+/* c_lflag bits */
+#define ISIG	0000001
+#define ICANON	0000002
+#define XCASE	0000004
+#define ECHO	0000010
+#define ECHOE	0000020
+#define ECHOK	0000040
+#define ECHONL	0000100
+#define NOFLSH	0000200
+#define TOSTOP	0000400
+#define ECHOCTL	0001000
+#define ECHOPRT	0002000
+#define ECHOKE	0004000
+#define FLUSHO	0010000
+#define PENDIN	0040000
+#define IEXTEN	0100000
+
+/* tcflow() and TCXONC use these */
+#define	TCOOFF		0
+#define	TCOON		1
+#define	TCIOFF		2
+#define	TCION		3
+
+/* tcflush() and TCFLSH use these */
+#define	TCIFLUSH	0
+#define	TCOFLUSH	1
+#define	TCIOFLUSH	2
+
+/* tcsetattr uses these */
+#define	TCSANOW		0
+#define	TCSADRAIN	1
+#define	TCSAFLUSH	2
+
+#endif /* __ASM_GENERIC_TERMBITS_H */
Index: linux-2.6/include/asm-generic/ucontext.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/ucontext.h
@@ -0,0 +1,12 @@
+#ifndef __ASM_GENERIC_UCONTEXT_H
+#define __ASM_GENERIC_UCONTEXT_H
+
+struct ucontext {
+	unsigned long	  uc_flags;
+	struct ucontext  *uc_link;
+	stack_t		  uc_stack;
+	struct sigcontext uc_mcontext;
+	sigset_t	  uc_sigmask;	/* mask last for extensibility */
+};
+
+#endif /* __ASM_GENERIC_UCONTEXT_H */
Index: linux-2.6/include/asm-generic/swab.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/swab.h
@@ -0,0 +1,18 @@
+#ifndef _ASM_GENERIC_SWAB_H
+#define _ASM_GENERIC_SWAB_H
+
+#include <asm/bitsperlong.h>
+
+/*
+ * 32 bit architectures typically (but not always) want to
+ * set __SWAB_64_THRU_32__. In user space, this is only
+ * valid if the compiler supports 64 bit data types.
+ */
+
+#if __BITS_PER_LONG == 32
+#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
+#define __SWAB_64_THRU_32__
+#endif
+#endif
+
+#endif /* _ASM_GENERIC_SWAB_H */

-- 

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
