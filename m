From: Arnd Bergmann <arnd@arndb.de>
Subject: kernel/libc uapi changes for y2038
Date: Mon, 18 May 2015 11:53:56 +0200
Message-ID: <2664016.bYZKg6FQqR@wuerfel>
Reply-To: musl@lists.openwall.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <musl-return-7691-gllmg-musl=m.gmane.org@lists.openwall.com>
List-Post: <mailto:musl@lists.openwall.com>
List-Help: <mailto:musl-help@lists.openwall.com>
List-Unsubscribe: <mailto:musl-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:musl-subscribe@lists.openwall.com>
To: linux-api@vger.kernel.org
Cc: libc-alpha@sourceware.org, linux-kernel@vger.kernel.org, y2038@lists.linaro.org, musl@lists.openwall.com, klibc@zytor.com, cferris@google.com, enh@google.com, Rich Felker <dalias@libc.org>, "Joseph S. Myers" <joseph@codesourcery.com>
List-Id: linux-api@vger.kernel.org

In the patch series I posted recently [1], I introduce new system calls to deal
with modified data structures, but left the question open on how these should
be best accessed from libc. The patches introduce a new __kernel_time64_t type
and based on that five new data structured: struct __kernel_timespec,
struct __kernel_itimerspec, struct __kernel_stat, struct __kernel_rusage,
and struct __kernel_timex. This works fine for the case when all libc
implementations provide their own definitions to user space, but not for
the simplest case (e.g. klibc) where the user-visible structures come directly
from the kernel uapi headers.

I still don't know what model the various libc developers prefer, so here is
an alternative approach, as a patch on top of the previous series:

Now, we rename the original structures to struct __old_kernel_*, and use a
macro to define either the __old_kernel_* or the __kernel_* structure name
to the name we actually want in user space, based on a __KERNEL_TIME_BITS
macro that can be set to either 32 or 64 for 32-bit architectures by
the libc. Depending on that macro, the compiler will either see one
of these combinations (for each of the five structures):

a) __BITS_PER_LONG == 32 && __KERNEL_TIME_BITS == 32:

   struct timespec              based on 32-bit __kernel_time_t
   struct __kernel_timespec     based on 64-bit __kernel_time64_t

b) __BITS_PER_LONG == 64 && __KERNEL_TIME_BITS == 64:

   struct timespec              based on 64-bit __kernel_time_t
   struct __kernel_timespec     based on 64-bit __kernel_time64_t

c) __BITS_PER_LONG == 32 && __KERNEL_TIME_BITS == 64:

   struct __old_kernel_timespec based on 32-bit __kernel_time_t
   struct timespec              based on 64-bit __kernel_time64_t

Would this work for everyone?  Any alternative suggestions?

	Arnd

[1] http://git.kernel.org/cgit/linux/kernel/git/arnd/playground.git/log/?h=y2038-syscalls
    https://lwn.net/Articles/643407/

diff --git a/include/uapi/asm-generic/bitsperlong.h b/include/uapi/asm-generic/bitsperlong.h
index 23e6c416b85f..ecdaf4f77f35 100644
--- a/include/uapi/asm-generic/bitsperlong.h
+++ b/include/uapi/asm-generic/bitsperlong.h
@@ -12,4 +12,13 @@
 #define __BITS_PER_LONG 32
 #endif
 
+/*
+ * Traditionally we define defines 'time_t' as 'long', but we need to
+ * migrate to a 64-bit type until 2038. This one is designed to be
+ * overridden by user space if it's prepared to handle 64-bit time_t.
+ */
+#ifndef __KERNEL_TIME_BITS
+#define __KERNEL_TIME_BITS __BITS_PER_LONG
+#endif
+
 #endif /* _UAPI__ASM_GENERIC_BITS_PER_LONG */
diff --git a/include/uapi/asm-generic/kernel_stat.h b/include/uapi/asm-generic/kernel_stat.h
index d1db22583046..3693496c78aa 100644
--- a/include/uapi/asm-generic/kernel_stat.h
+++ b/include/uapi/asm-generic/kernel_stat.h
@@ -1,6 +1,14 @@
 #ifndef __ASM_GENERIC_KERNEL_STAT_H
 #define __ASM_GENERIC_KERNEL_STAT_H
 
+#include <asm/bitsperlong.h>
+
+#if __KERNEL_TIME_BITS == 32 || __BITS_PER_LONG == 64
+#define __old_kernel_stat2 stat
+#else
+#define __kernel_stat stat
+#endif
+
 /*
  * The new structure that works on both 32-bit and 64-bit and survives y2038
  * The layout matches 'struct stat' from asm-generic/stat.h on 64-bit
diff --git a/include/uapi/asm-generic/stat.h b/include/uapi/asm-generic/stat.h
index 64c32ba7c1a9..f66b28b96c8d 100644
--- a/include/uapi/asm-generic/stat.h
+++ b/include/uapi/asm-generic/stat.h
@@ -22,7 +22,7 @@
 
 #define STAT_HAVE_NSEC 1
 
-struct stat {
+struct __old_kernel_stat2 {
 	unsigned long	st_dev;		/* Device.  */
 	unsigned long	st_ino;		/* File serial number.  */
 	unsigned int	st_mode;	/* File mode.  */
diff --git a/include/uapi/linux/resource.h b/include/uapi/linux/resource.h
index c4f3ba44db00..9a3876cc4436 100644
--- a/include/uapi/linux/resource.h
+++ b/include/uapi/linux/resource.h
@@ -3,10 +3,16 @@
 
 #include <linux/time.h>
 #include <linux/types.h>
+#include <asm/bitsperlong.h>
 
 /*
  * Resource control/accounting header file for linux
  */
+#if __KERNEL_TIME_BITS == 32 || __BITS_PER_LONG == 64
+#define __old_kernel_rusage rusage
+#else
+#define __kernel_rusage rusage
+#endif
 
 /*
  * Definition of struct rusage taken from BSD 4.3 Reno
@@ -20,7 +26,7 @@
 #define RUSAGE_BOTH	(-2)		/* sys_wait4() uses this */
 #define	RUSAGE_THREAD	1		/* only the calling thread */
 
-struct	rusage {
+struct	__old_kernel_rusage {
 	struct timeval ru_utime;	/* user time used */
 	struct timeval ru_stime;	/* system time used */
 	__kernel_long_t	ru_maxrss;	/* maximum resident set size */
diff --git a/include/uapi/linux/time.h b/include/uapi/linux/time.h
index 72d894df3013..b3988606128f 100644
--- a/include/uapi/linux/time.h
+++ b/include/uapi/linux/time.h
@@ -6,11 +6,24 @@
 
 #ifndef _STRUCT_TIMESPEC
 #define _STRUCT_TIMESPEC
-struct timespec {
+
+#if __KERNEL_TIME_BITS == 32 || __BITS_PER_LONG == 64
+#define __old_kernel_timespec timespec
+#else
+#define __kernel_timespec timespec
+#endif
+#endif
+
+#if __KERNEL_TIME_BITS == 32 || __BITS_PER_LONG == 64
+#define __old_kernel_itimerspec itimerspec
+#else
+#define __kernel_itimerspec itimerspec
+#endif
+
+struct __old_kernel_timespec {
 	__kernel_time_t	tv_sec;			/* seconds */
 	long		tv_nsec;		/* nanoseconds */
 };
-#endif
 
 struct timeval {
 	__kernel_time_t		tv_sec;		/* seconds */
@@ -31,7 +44,7 @@ struct timezone {
 #define	ITIMER_VIRTUAL		1
 #define	ITIMER_PROF		2
 
-struct itimerspec {
+struct __old_kernel_itimerspec {
 	struct timespec it_interval;	/* timer period */
 	struct timespec it_value;	/* timer expiration */
 };
diff --git a/include/uapi/linux/timex.h b/include/uapi/linux/timex.h
index 9b131f107ada..3cfa50caa77d 100644
--- a/include/uapi/linux/timex.h
+++ b/include/uapi/linux/timex.h
@@ -54,14 +54,22 @@
 #define _UAPI_LINUX_TIMEX_H
 
 #include <linux/time.h>
+#include <asm/bitsperlong.h>
+
+#if __KERNEL_TIME_BITS == 32 || __BITS_PER_LONG == 64
+#define __old_kernel_timex timex
+#else
+#define __kernel_timex timex
+#endif
 
 #define NTP_API		4	/* NTP API version */
 
+
 /*
  * syscall interface - used (mainly by NTP daemon)
  * to discipline kernel clock oscillator
  */
-struct timex {
+struct __old_kernel_timex {
 	unsigned int modes;	/* mode selector */
 	__kernel_long_t offset;	/* time offset (usec) */
 	__kernel_long_t freq;	/* frequency offset (scaled ppm) */
diff --git a/arch/arm/include/uapi/asm/stat.h b/arch/arm/include/uapi/asm/stat.h
index 537a12553dd8..18ff0e2383ad 100644
--- a/arch/arm/include/uapi/asm/stat.h
+++ b/arch/arm/include/uapi/asm/stat.h
@@ -19,7 +19,7 @@ struct __old_kernel_stat {
 
 #define STAT_HAVE_NSEC 
 
-struct stat {
+struct __old_kernel_stat2 {
 #if defined(__ARMEB__)
 	unsigned short st_dev;
 	unsigned short __pad1;
diff --git a/arch/avr32/include/uapi/asm/stat.h b/arch/avr32/include/uapi/asm/stat.h
index 2b528ca17985..5df389890f8a 100644
--- a/arch/avr32/include/uapi/asm/stat.h
+++ b/arch/avr32/include/uapi/asm/stat.h
@@ -24,7 +24,7 @@ struct __old_kernel_stat {
         unsigned long  st_ctime;
 };
 
-struct stat {
+struct __old_kernel_stat2 {
         unsigned long st_dev;
         unsigned long st_ino;
         unsigned short st_mode;
diff --git a/arch/blackfin/include/uapi/asm/stat.h b/arch/blackfin/include/uapi/asm/stat.h
index 99ee343aec23..cd417baf51fc 100644
--- a/arch/blackfin/include/uapi/asm/stat.h
+++ b/arch/blackfin/include/uapi/asm/stat.h
@@ -9,7 +9,7 @@
 
 #include <asm-generic/kernel_stat.h>
 
-struct stat {
+struct __old_kernel_stat2 {
 	unsigned short st_dev;
 	unsigned short __pad1;
 	unsigned long st_ino;
diff --git a/arch/cris/include/uapi/asm/stat.h b/arch/cris/include/uapi/asm/stat.h
index 4837884cd2d3..38d1dba3ea6a 100644
--- a/arch/cris/include/uapi/asm/stat.h
+++ b/arch/cris/include/uapi/asm/stat.h
@@ -22,7 +22,7 @@ struct __old_kernel_stat {
 
 #define STAT_HAVE_NSEC 1
 
-struct stat {
+struct __old_kernel_stat2 {
 	unsigned long  st_dev;
 	unsigned long  st_ino;
 	unsigned short st_mode;
diff --git a/arch/frv/include/uapi/asm/stat.h b/arch/frv/include/uapi/asm/stat.h
index 5448b198fbb6..5ff15ccef6c3 100644
--- a/arch/frv/include/uapi/asm/stat.h
+++ b/arch/frv/include/uapi/asm/stat.h
@@ -18,7 +18,7 @@ struct __old_kernel_stat {
 };
 
 /* This matches struct stat in uClibc/glibc.  */
-struct stat {
+struct __old_kernel_stat2 {
 	unsigned char __pad1[6];
 	unsigned short st_dev;
 
diff --git a/arch/m32r/include/uapi/asm/stat.h b/arch/m32r/include/uapi/asm/stat.h
index d0ffa70f73c0..03531561b8cd 100644
--- a/arch/m32r/include/uapi/asm/stat.h
+++ b/arch/m32r/include/uapi/asm/stat.h
@@ -20,7 +20,7 @@ struct __old_kernel_stat {
 
 #define STAT_HAVE_NSEC	1
 
-struct stat {
+struct __old_kernel_stat2 {
 	unsigned short st_dev;
 	unsigned short __pad1;
 	unsigned long  st_ino;
diff --git a/arch/m68k/include/uapi/asm/stat.h b/arch/m68k/include/uapi/asm/stat.h
index 6f455db47b4e..f7936ed51c09 100644
--- a/arch/m68k/include/uapi/asm/stat.h
+++ b/arch/m68k/include/uapi/asm/stat.h
@@ -17,7 +17,7 @@ struct __old_kernel_stat {
 	unsigned long  st_ctime;
 };
 
-struct stat {
+struct __old_kernel_stat2 {
 	unsigned short st_dev;
 	unsigned short __pad1;
 	unsigned long  st_ino;
diff --git a/arch/mips/include/uapi/asm/stat.h b/arch/mips/include/uapi/asm/stat.h
index 53e58fbd83fa..c0b82a1ccf17 100644
--- a/arch/mips/include/uapi/asm/stat.h
+++ b/arch/mips/include/uapi/asm/stat.h
@@ -16,7 +16,7 @@
 
 #if (_MIPS_SIM == _MIPS_SIM_ABI32) || (_MIPS_SIM == _MIPS_SIM_NABI32)
 
-struct stat {
+struct __old_kernel_stat2 {
 	unsigned	st_dev;
 	long		st_pad1[3];		/* Reserved for network id */
 	ino_t		st_ino;
@@ -90,7 +90,7 @@ struct stat64 {
 #if _MIPS_SIM == _MIPS_SIM_ABI64
 
 /* The memory layout is the same as of struct stat64 of the 32-bit kernel.  */
-struct stat {
+struct __old_kernel_stat2 {
 	unsigned int		st_dev;
 	unsigned int		st_pad0[3]; /* Reserved for st_dev expansion */
 
diff --git a/arch/mn10300/include/uapi/asm/stat.h b/arch/mn10300/include/uapi/asm/stat.h
index af3b4d6b7b7a..ab507885dd05 100644
--- a/arch/mn10300/include/uapi/asm/stat.h
+++ b/arch/mn10300/include/uapi/asm/stat.h
@@ -17,7 +17,7 @@ struct __old_kernel_stat {
 	unsigned long  st_ctime;
 };
 
-struct stat {
+struct __old_kernel_stat2 {
 	unsigned long  st_dev;
 	unsigned long  st_ino;
 	unsigned short st_mode;
diff --git a/arch/parisc/include/uapi/asm/stat.h b/arch/parisc/include/uapi/asm/stat.h
index f06ce7ba0115..d632b5453628 100644
--- a/arch/parisc/include/uapi/asm/stat.h
+++ b/arch/parisc/include/uapi/asm/stat.h
@@ -4,7 +4,7 @@
 #include <linux/types.h>
 #include <asm-generic/kernel_stat.h>
 
-struct stat {
+struct __old_kernel_stat2 {
 	unsigned int	st_dev;		/* dev_t is 32 bits on parisc */
 	unsigned int	st_ino;		/* 32 bits */
 	unsigned short	st_mode;	/* 16 bits */
diff --git a/arch/powerpc/include/uapi/asm/stat.h b/arch/powerpc/include/uapi/asm/stat.h
index 248d8072267f..4b62b30ed12c 100644
--- a/arch/powerpc/include/uapi/asm/stat.h
+++ b/arch/powerpc/include/uapi/asm/stat.h
@@ -7,6 +7,13 @@
  * 2 of the License, or (at your option) any later version.
  */
 #include <linux/types.h>
+#include <asm/bitsperlong.h>
+
+#if __KERNEL_TIME_BITS == 32 || __BITS_PER_LONG == 64
+#define __old_kernel_stat2 stat
+#else
+#define __kernel_stat stat
+#endif
 
 #define STAT_HAVE_NSEC 1
 
@@ -26,7 +33,7 @@ struct __old_kernel_stat {
 };
 #endif /* !__powerpc64__ */
 
-struct stat {
+struct __old_kernel_stat2 {
 	unsigned long	st_dev;
 	ino_t		st_ino;
 #ifdef __powerpc64__
@@ -78,7 +85,7 @@ struct stat64 {
 	unsigned int	__unused5;
 };
 
-/* this matches the powerpc64 'struct stat' for compat tasks */
+/* this matches the powerpc64 'struct __old_kernel_stat2' for compat tasks */
 struct __kernel_stat {
 	unsigned long long	st_dev;
 	unsigned long long	st_ino;
@@ -101,6 +107,5 @@ struct __kernel_stat {
 	unsigned long long	__unused5;
 	unsigned long long	__unused6;
 };
 
 #endif /* _ASM_POWERPC_STAT_H */
diff --git a/arch/s390/include/uapi/asm/stat.h b/arch/s390/include/uapi/asm/stat.h
index d4c2711249dd..5f40f51ecdab 100644
--- a/arch/s390/include/uapi/asm/stat.h
+++ b/arch/s390/include/uapi/asm/stat.h
@@ -7,6 +7,14 @@
 #ifndef _S390_STAT_H
 #define _S390_STAT_H
 
+#include <asm/bitsperlong.h>
+
+#if __KERNEL_TIME_BITS == 32 || __BITS_PER_LONG == 64
+#define __old_kernel_stat2 stat
+#else
+#define __kernel_stat stat
+#endif
+
 #ifndef __s390x__
 struct __old_kernel_stat {
         unsigned short st_dev;
@@ -22,7 +30,7 @@ struct __old_kernel_stat {
         unsigned long  st_ctime;
 };
 
-struct stat {
+struct __old_kernel_stat2 {
         unsigned short st_dev;
         unsigned short __pad1;
         unsigned long  st_ino;
@@ -75,7 +83,7 @@ struct stat64 {
 
 #else /* __s390x__ */
 
-struct stat {
+struct __old_kernel_stat {
         unsigned long  st_dev;
         unsigned long  st_ino;
         unsigned long  st_nlink;
diff --git a/arch/sh/include/uapi/asm/stat.h b/arch/sh/include/uapi/asm/stat.h
index a13ffbcccd50..0d3358037558 100644
--- a/arch/sh/include/uapi/asm/stat.h
+++ b/arch/sh/include/uapi/asm/stat.h
@@ -18,7 +18,7 @@ struct __old_kernel_stat {
 };
 
 #if defined(__SH5__) || defined(CONFIG_CPU_SH5)
-struct stat {
+struct __old_kernel_stat2 {
 	unsigned short st_dev;
 	unsigned short __pad1;
 	unsigned long st_ino;
@@ -77,7 +77,7 @@ struct stat64 {
 	unsigned long	__unused2;
 };
 #else
-struct stat {
+struct __old_kernel_stat2 {
 	unsigned long  st_dev;
 	unsigned long  st_ino;
 	unsigned short st_mode;
diff --git a/arch/sparc/include/uapi/asm/stat.h b/arch/sparc/include/uapi/asm/stat.h
index 6d19c7bdc641..8ace4436a31f 100644
--- a/arch/sparc/include/uapi/asm/stat.h
+++ b/arch/sparc/include/uapi/asm/stat.h
@@ -2,6 +2,13 @@
 #define __SPARC_STAT_H
 
 #include <linux/types.h>
+#include <asm/bitsperlong.h>
+
+#if __KERNEL_TIME_BITS == 32 || __BITS_PER_LONG == 64
+#define __old_kernel_stat2 stat
+#else
+#define __kernel_stat stat
+#endif
 
 #if defined(__sparc__) && defined(__arch64__)
 /* 64 bit sparc */
@@ -48,7 +55,8 @@ struct stat64 {
 
 #else
 /* 32 bit sparc */
-struct stat {
+
+struct __old_kernel_stat2 {
 	unsigned short	st_dev;
 	ino_t		st_ino;
 	mode_t		st_mode;
diff --git a/arch/x86/include/uapi/asm/stat.h b/arch/x86/include/uapi/asm/stat.h
index 5d5754fc3d36..5fa5beeafd86 100644
--- a/arch/x86/include/uapi/asm/stat.h
+++ b/arch/x86/include/uapi/asm/stat.h
@@ -2,11 +2,18 @@
 #define _ASM_X86_STAT_H
 
 #include <asm/posix_types.h>
+#include <asm/bitsperlong.h>
 
 #define STAT_HAVE_NSEC 1
 
+#if __KERNEL_TIME_BITS == 32 || __BITS_PER_LONG == 64
+#define __old_kernel_stat2 stat
+#else
+#define __kernel_stat stat
+#endif
+
 #ifdef __i386__
-struct stat {
+struct __old_kernel_stat2 {
 	unsigned long  st_dev;
 	unsigned long  st_ino;
 	unsigned short st_mode;
@@ -73,7 +80,7 @@ struct stat64 {
 
 #else /* __i386__ */
 
-struct stat {
+struct __old_kernel_stat2 {
 	__kernel_ulong_t	st_dev;
 	__kernel_ulong_t	st_ino;
 	__kernel_ulong_t	st_nlink;
diff --git a/arch/xtensa/include/uapi/asm/stat.h b/arch/xtensa/include/uapi/asm/stat.h
index 8d9c1d9d82d0..94e40d22eb88 100644
--- a/arch/xtensa/include/uapi/asm/stat.h
+++ b/arch/xtensa/include/uapi/asm/stat.h
@@ -15,7 +15,7 @@
 
 #define STAT_HAVE_NSEC 1
 
-struct stat {
+struct __old_kernel_stat2 {
 	unsigned long	st_dev;
 	unsigned long	st_ino;
 	unsigned int	st_mode;
