From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [PATCH 09/19] y2038: introduce struct __kernel_stat
Date: Wed,  6 May 2015 18:30:16 +0200
Message-ID: <1430929826-318934-10-git-send-email-arnd@arndb.de>
References: <1430929826-318934-1-git-send-email-arnd@arndb.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430929826-318934-1-git-send-email-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org
Cc: baolin.wang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, albert.aribaud-iEu9NFBzPZE@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The stat() family of system calls uses up to three different data
structures: 'struct __kernel_oldstat', 'struct stat', and 'struct
stat64', which were extended in various ways over time. Unfortunately,
on most 32-bit architectures and even some 64-bit machines (parisc),
all of them use 32-bit timestamps, which are already broken because
they cannot represent the range of times that can be stored on
typical file systems. When time_t overflows, things of course become
much worse.

This introduces a fourth data structure, 'struct __kernel_stat', which
is supposed to match the layout of 'struct stat' on 64-bit architectures,
so the compat handlers can be shared between native 64-bit and compat
32-bit syscalls. On architectures that are always 32-bit, the asm-generic
variant can be used.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
 arch/alpha/include/uapi/asm/stat.h     |  4 +++
 arch/arm/include/uapi/asm/stat.h       |  2 ++
 arch/avr32/include/uapi/asm/stat.h     |  2 ++
 arch/blackfin/include/uapi/asm/stat.h  |  2 ++
 arch/cris/include/uapi/asm/stat.h      |  2 ++
 arch/frv/include/uapi/asm/stat.h       |  2 ++
 arch/ia64/include/uapi/asm/stat.h      |  4 +++
 arch/m32r/include/uapi/asm/stat.h      |  1 +
 arch/m68k/include/uapi/asm/stat.h      |  2 ++
 arch/mips/include/uapi/asm/stat.h      |  1 +
 arch/mn10300/include/uapi/asm/stat.h   |  2 ++
 arch/parisc/include/uapi/asm/stat.h    |  1 +
 arch/powerpc/include/uapi/asm/stat.h   | 25 +++++++++++++++++
 arch/s390/include/uapi/asm/stat.h      | 24 +++++++++++++++++
 arch/sh/include/uapi/asm/stat.h        |  2 ++
 arch/sparc/include/uapi/asm/stat.h     | 28 +++++++++++++++++++
 arch/x86/include/uapi/asm/stat.h       | 49 ++++++++++++++++++++++++----------
 arch/xtensa/include/uapi/asm/stat.h    |  2 ++
 include/linux/syscalls.h               | 11 ++++----
 include/uapi/asm-generic/kernel_stat.h | 36 +++++++++++++++++++++++++
 include/uapi/asm-generic/stat.h        | 12 +++++----
 21 files changed, 189 insertions(+), 25 deletions(-)
 create mode 100644 include/uapi/asm-generic/kernel_stat.h

diff --git a/arch/alpha/include/uapi/asm/stat.h b/arch/alpha/include/uapi/asm/stat.h
index 07ad3e6b3f3e..ca566bc620f6 100644
--- a/arch/alpha/include/uapi/asm/stat.h
+++ b/arch/alpha/include/uapi/asm/stat.h
@@ -1,6 +1,10 @@
 #ifndef _ALPHA_STAT_H
 #define _ALPHA_STAT_H
 
+#ifndef __kernel_stat
+#define __kernel_stat stat
+#endif
+
 struct stat {
 	unsigned int	st_dev;
 	unsigned int	st_ino;
diff --git a/arch/arm/include/uapi/asm/stat.h b/arch/arm/include/uapi/asm/stat.h
index 42c0c13999d5..537a12553dd8 100644
--- a/arch/arm/include/uapi/asm/stat.h
+++ b/arch/arm/include/uapi/asm/stat.h
@@ -1,6 +1,8 @@
 #ifndef _ASMARM_STAT_H
 #define _ASMARM_STAT_H
 
+#include <asm-generic/kernel_stat.h>
+
 struct __old_kernel_stat {
 	unsigned short st_dev;
 	unsigned short st_ino;
diff --git a/arch/avr32/include/uapi/asm/stat.h b/arch/avr32/include/uapi/asm/stat.h
index c06acef7fce7..2b528ca17985 100644
--- a/arch/avr32/include/uapi/asm/stat.h
+++ b/arch/avr32/include/uapi/asm/stat.h
@@ -8,6 +8,8 @@
 #ifndef _UAPI__ASM_AVR32_STAT_H
 #define _UAPI__ASM_AVR32_STAT_H
 
+#include <asm-generic/kernel_stat.h>
+
 struct __old_kernel_stat {
         unsigned short st_dev;
         unsigned short st_ino;
diff --git a/arch/blackfin/include/uapi/asm/stat.h b/arch/blackfin/include/uapi/asm/stat.h
index d3068a750b94..99ee343aec23 100644
--- a/arch/blackfin/include/uapi/asm/stat.h
+++ b/arch/blackfin/include/uapi/asm/stat.h
@@ -7,6 +7,8 @@
 #ifndef _UAPI_BFIN_STAT_H
 #define _UAPI_BFIN_STAT_H
 
+#include <asm-generic/kernel_stat.h>
+
 struct stat {
 	unsigned short st_dev;
 	unsigned short __pad1;
diff --git a/arch/cris/include/uapi/asm/stat.h b/arch/cris/include/uapi/asm/stat.h
index 9e558cc3c43b..4837884cd2d3 100644
--- a/arch/cris/include/uapi/asm/stat.h
+++ b/arch/cris/include/uapi/asm/stat.h
@@ -1,6 +1,8 @@
 #ifndef _CRIS_STAT_H
 #define _CRIS_STAT_H
 
+#include <asm-generic/kernel_stat.h>
+
 /* Keep this a verbatim copy of i386 version; tweak CRIS-specific bits in
    the kernel if necessary.  */
 
diff --git a/arch/frv/include/uapi/asm/stat.h b/arch/frv/include/uapi/asm/stat.h
index ce56de9b37ba..5448b198fbb6 100644
--- a/arch/frv/include/uapi/asm/stat.h
+++ b/arch/frv/include/uapi/asm/stat.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_STAT_H
 #define _ASM_STAT_H
 
+#include <asm-generic/kernel_stat.h>
+
 struct __old_kernel_stat {
 	unsigned short st_dev;
 	unsigned short st_ino;
diff --git a/arch/ia64/include/uapi/asm/stat.h b/arch/ia64/include/uapi/asm/stat.h
index 367bb90cdffa..cde68a31e183 100644
--- a/arch/ia64/include/uapi/asm/stat.h
+++ b/arch/ia64/include/uapi/asm/stat.h
@@ -1,6 +1,10 @@
 #ifndef _ASM_IA64_STAT_H
 #define _ASM_IA64_STAT_H
 
+#ifndef __kernel_stat
+#define __kernel_stat stat
+#endif
+
 /*
  * Modified 1998, 1999
  *	David Mosberger-Tang <davidm-sDzT885Ts8HQT0dZR+AlfA@public.gmane.org>, Hewlett-Packard Co
diff --git a/arch/m32r/include/uapi/asm/stat.h b/arch/m32r/include/uapi/asm/stat.h
index 98470fe483b6..d0ffa70f73c0 100644
--- a/arch/m32r/include/uapi/asm/stat.h
+++ b/arch/m32r/include/uapi/asm/stat.h
@@ -2,6 +2,7 @@
 #define _ASM_M32R_STAT_H
 
 #include <asm/byteorder.h>
+#include <asm-generic/kernel_stat.h>
 
 struct __old_kernel_stat {
 	unsigned short st_dev;
diff --git a/arch/m68k/include/uapi/asm/stat.h b/arch/m68k/include/uapi/asm/stat.h
index dd38bc2e9f98..6f455db47b4e 100644
--- a/arch/m68k/include/uapi/asm/stat.h
+++ b/arch/m68k/include/uapi/asm/stat.h
@@ -1,6 +1,8 @@
 #ifndef _M68K_STAT_H
 #define _M68K_STAT_H
 
+#include <asm-generic/kernel_stat.h>
+
 struct __old_kernel_stat {
 	unsigned short st_dev;
 	unsigned short st_ino;
diff --git a/arch/mips/include/uapi/asm/stat.h b/arch/mips/include/uapi/asm/stat.h
index b47bc541bbc0..53e58fbd83fa 100644
--- a/arch/mips/include/uapi/asm/stat.h
+++ b/arch/mips/include/uapi/asm/stat.h
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 
 #include <asm/sgidefs.h>
+#include <asm-generic/kernel_stat.h>
 
 #if (_MIPS_SIM == _MIPS_SIM_ABI32) || (_MIPS_SIM == _MIPS_SIM_NABI32)
 
diff --git a/arch/mn10300/include/uapi/asm/stat.h b/arch/mn10300/include/uapi/asm/stat.h
index 63ff8371cf2c..af3b4d6b7b7a 100644
--- a/arch/mn10300/include/uapi/asm/stat.h
+++ b/arch/mn10300/include/uapi/asm/stat.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_STAT_H
 #define _ASM_STAT_H
 
+#include <asm-generic/kernel_stat.h>
+
 struct __old_kernel_stat {
 	unsigned short st_dev;
 	unsigned short st_ino;
diff --git a/arch/parisc/include/uapi/asm/stat.h b/arch/parisc/include/uapi/asm/stat.h
index b606b366d0a7..f06ce7ba0115 100644
--- a/arch/parisc/include/uapi/asm/stat.h
+++ b/arch/parisc/include/uapi/asm/stat.h
@@ -2,6 +2,7 @@
 #define _PARISC_STAT_H
 
 #include <linux/types.h>
+#include <asm-generic/kernel_stat.h>
 
 struct stat {
 	unsigned int	st_dev;		/* dev_t is 32 bits on parisc */
diff --git a/arch/powerpc/include/uapi/asm/stat.h b/arch/powerpc/include/uapi/asm/stat.h
index 84880b80cc1c..248d8072267f 100644
--- a/arch/powerpc/include/uapi/asm/stat.h
+++ b/arch/powerpc/include/uapi/asm/stat.h
@@ -78,4 +78,29 @@ struct stat64 {
 	unsigned int	__unused5;
 };
 
+#ifndef __kernel_stat
+/* this matches the powerpc64 'struct stat' for compat tasks */
+struct __kernel_stat {
+	unsigned long long	st_dev;
+	unsigned long long	st_ino;
+	unsigned long long	st_nlink;
+	unsigned int		st_mode;
+	unsigned int		st_uid;
+	unsigned int		st_gid;
+	unsigned long long	st_rdev;
+	unsigned long long	st_size;
+	unsigned long long	st_blksize;
+	unsigned long long	st_blocks;
+	unsigned long long	st_atime;
+	unsigned long long	st_atime_nsec;
+	unsigned long long	st_mtime;
+	unsigned long long	st_mtime_nsec;
+	unsigned long long	st_ctime;
+	unsigned long long	st_ctime_nsec;
+	unsigned long long	__unused4;
+	unsigned long long	__unused5;
+	unsigned long long	__unused6;
+};
+#endif
+
 #endif /* _ASM_POWERPC_STAT_H */
diff --git a/arch/s390/include/uapi/asm/stat.h b/arch/s390/include/uapi/asm/stat.h
index b4ca97d91466..d4c2711249dd 100644
--- a/arch/s390/include/uapi/asm/stat.h
+++ b/arch/s390/include/uapi/asm/stat.h
@@ -100,4 +100,28 @@ struct stat {
 
 #define STAT_HAVE_NSEC 1
 
+/* same layout as 'struct stat on s390x' for both 32-bit and 64-bit tasks */
+#ifndef __kernel_stat
+struct __kernel_stat {
+	unsigned long long st_dev;
+	unsigned long long st_ino;
+	unsigned long long st_nlink;
+	unsigned int	   st_mode;
+	unsigned int	   st_uid;
+	unsigned int	   st_gid;
+	unsigned int	   __pad1;
+	unsigned long long st_rdev;
+	unsigned long long st_size;
+	unsigned long long st_atime;
+	unsigned long long st_atime_nsec;
+	unsigned long long st_mtime;
+	unsigned long long st_mtime_nsec;
+	unsigned long long st_ctime;
+	unsigned long long st_ctime_nsec;
+	unsigned long long st_blksize;
+	long long	   st_blocks;
+	unsigned long long __unused[3];
+};
+#endif
+
 #endif
diff --git a/arch/sh/include/uapi/asm/stat.h b/arch/sh/include/uapi/asm/stat.h
index e1810cc6e3da..a13ffbcccd50 100644
--- a/arch/sh/include/uapi/asm/stat.h
+++ b/arch/sh/include/uapi/asm/stat.h
@@ -1,6 +1,8 @@
 #ifndef __ASM_SH_STAT_H
 #define __ASM_SH_STAT_H
 
+#include <asm-generic/kernel_stat.h>
+
 struct __old_kernel_stat {
 	unsigned short st_dev;
 	unsigned short st_ino;
diff --git a/arch/sparc/include/uapi/asm/stat.h b/arch/sparc/include/uapi/asm/stat.h
index a232e9e1f4e5..6d19c7bdc641 100644
--- a/arch/sparc/include/uapi/asm/stat.h
+++ b/arch/sparc/include/uapi/asm/stat.h
@@ -104,4 +104,32 @@ struct stat64 {
 	unsigned int	__unused5;
 };
 #endif /* defined(__sparc__) && defined(__arch64__) */
+
+#ifndef __kernel_stat
+/* This matches the sparc64 'struct stat64' in compat tasks */
+struct __kernel_stat {
+	unsigned long long	st_dev;
+	unsigned long long	st_ino;
+	unsigned long long	st_nlink;
+
+	unsigned int		st_mode;
+	unsigned int		st_uid;
+	unsigned int		st_gid;
+	unsigned int		__pad0;
+
+	unsigned long long	st_rdev;
+	long long		st_size;
+	long long		st_blksize;
+	long long		st_blocks;
+
+	unsigned long long	st_atime;
+	unsigned long long	st_atime_nsec;
+	unsigned long long	st_mtime;
+	unsigned long long	st_mtime_nsec;
+	unsigned long long	st_ctime;
+	unsigned long long	st_ctime_nsec;
+	long long		__unused[3];
+};
+#endif
+
 #endif /* __SPARC_STAT_H */
diff --git a/arch/x86/include/uapi/asm/stat.h b/arch/x86/include/uapi/asm/stat.h
index bc03eb5d6360..5d5754fc3d36 100644
--- a/arch/x86/include/uapi/asm/stat.h
+++ b/arch/x86/include/uapi/asm/stat.h
@@ -27,12 +27,6 @@ struct stat {
 	unsigned long  __unused5;
 };
 
-/* We don't need to memset the whole thing just to initialize the padding */
-#define INIT_STRUCT_STAT_PADDING(st) do {	\
-	st.__unused4 = 0;			\
-	st.__unused5 = 0;			\
-} while (0)
-
 #define STAT64_HAS_BROKEN_ST_INO	1
 
 /* This matches struct stat64 in glibc2.1, hence the absolutely
@@ -102,14 +96,6 @@ struct stat {
 	__kernel_long_t		__unused[3];
 };
 
-/* We don't need to memset the whole thing just to initialize the padding */
-#define INIT_STRUCT_STAT_PADDING(st) do {	\
-	st.__pad0 = 0;				\
-	st.__unused[0] = 0;			\
-	st.__unused[1] = 0;			\
-	st.__unused[2] = 0;			\
-} while (0)
-
 #endif
 
 /* for 32bit emulation and 32 bit kernels */
@@ -134,4 +120,39 @@ struct __old_kernel_stat {
 #endif
 };
 
+#ifndef __kernel_stat
+/* This matches the 64-bit version of 'struct stat' on i386 */
+struct __kernel_stat {
+	unsigned long long	st_dev;
+	unsigned long long	st_ino;
+	unsigned long long	st_nlink;
+
+	unsigned int		st_mode;
+	unsigned int		st_uid;
+	unsigned int		st_gid;
+	unsigned int		__pad0;
+	unsigned long long	st_rdev;
+	long long		st_size;
+	long long		st_blksize;
+	long long		st_blocks;	/* Number 512-byte blocks allocated. */
+
+	unsigned long long	st_atime;
+	unsigned long long	st_atime_nsec;
+	unsigned long long	st_mtime;
+	unsigned long long	st_mtime_nsec;
+	unsigned long long	st_ctime;
+	unsigned long long	st_ctime_nsec;
+	long long		__unused[3];
+};
+
+/* We don't need to memset the whole thing just to initialize the padding */
+#define INIT_STRUCT_STAT_PADDING(st) do {	\
+	st.__pad0 = 0;				\
+	st.__unused[0] = 0;			\
+	st.__unused[1] = 0;			\
+	st.__unused[2] = 0;			\
+} while (0)
+
+#endif
+
 #endif /* _ASM_X86_STAT_H */
diff --git a/arch/xtensa/include/uapi/asm/stat.h b/arch/xtensa/include/uapi/asm/stat.h
index c4992038cee0..8d9c1d9d82d0 100644
--- a/arch/xtensa/include/uapi/asm/stat.h
+++ b/arch/xtensa/include/uapi/asm/stat.h
@@ -11,6 +11,8 @@
 #ifndef _XTENSA_STAT_H
 #define _XTENSA_STAT_H
 
+#include <asm-generic/kernel_stat.h>
+
 #define STAT_HAVE_NSEC 1
 
 struct stat {
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 76d1e38aabe1..71b574b0365e 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -44,8 +44,6 @@ struct semaphore;
 struct sembuf;
 struct shmid_ds;
 struct sockaddr;
-struct stat;
-struct stat64;
 struct statfs;
 struct statfs64;
 struct __sysctl_args;
@@ -79,6 +77,7 @@ union bpf_attr;
 #include <linux/quota.h>
 #include <linux/key.h>
 #include <trace/syscall.h>
+#include <linux/stat.h>
 
 /*
  * __MAP - apply a macro to syscall arguments
@@ -405,10 +404,10 @@ asmlinkage long sys_lstat(const char __user *filename,
 asmlinkage long sys_fstat(unsigned int fd,
 			struct __old_kernel_stat __user *statbuf);
 asmlinkage long sys_newstat(const char __user *filename,
-				struct stat __user *statbuf);
+				struct __kernel_stat __user *statbuf);
 asmlinkage long sys_newlstat(const char __user *filename,
-				struct stat __user *statbuf);
-asmlinkage long sys_newfstat(unsigned int fd, struct stat __user *statbuf);
+				struct __kernel_stat __user *statbuf);
+asmlinkage long sys_newfstat(unsigned int fd, struct __kernel_stat __user *statbuf);
 asmlinkage long sys_ustat(unsigned dev, struct ustat __user *ubuf);
 #if defined(__ARCH_WANT_STAT64) || defined(__ARCH_WANT_COMPAT_STAT64)
 asmlinkage long sys_stat64(const char __user *filename,
@@ -774,7 +773,7 @@ asmlinkage long sys_fchownat(int dfd, const char __user *filename, uid_t user,
 asmlinkage long sys_openat(int dfd, const char __user *filename, int flags,
 			   umode_t mode);
 asmlinkage long sys_newfstatat(int dfd, const char __user *filename,
-			       struct stat __user *statbuf, int flag);
+			       struct __kernel_stat __user *statbuf, int flag);
 asmlinkage long sys_readlinkat(int dfd, const char __user *path, char __user *buf,
 			       int bufsiz);
 asmlinkage long sys_utimensat(int dfd, const char __user *filename,
diff --git a/include/uapi/asm-generic/kernel_stat.h b/include/uapi/asm-generic/kernel_stat.h
new file mode 100644
index 000000000000..d1db22583046
--- /dev/null
+++ b/include/uapi/asm-generic/kernel_stat.h
@@ -0,0 +1,36 @@
+#ifndef __ASM_GENERIC_KERNEL_STAT_H
+#define __ASM_GENERIC_KERNEL_STAT_H
+
+/*
+ * The new structure that works on both 32-bit and 64-bit and survives y2038
+ * The layout matches 'struct stat' from asm-generic/stat.h on 64-bit
+ * architecture, but is identical on 32-bit architectures and uses 64-bit
+ * st_?time members so we don't wrap around in 2038.
+ */
+
+#ifndef __kernel_stat
+struct __kernel_stat {
+	unsigned long long st_dev;	/* Device.  */
+	unsigned long long st_ino;	/* File serial number.  */
+	unsigned int	   st_mode;	/* File mode.  */
+	unsigned int	   st_nlink;	/* Link count.  */
+	unsigned int	   st_uid;	/* User ID of the file's owner.  */
+	unsigned int	   st_gid;	/* Group ID of the file's group. */
+	unsigned long long st_rdev;	/* Device number, if device.  */
+	unsigned long long __pad1;
+	long long	   st_size;	/* Size of file, in bytes.  */
+	int		   st_blksize;	/* Optimal block size for I/O.  */
+	int		   __pad2;
+	long long	   st_blocks;	/* Number 512-byte blocks allocated. */
+	long long	   st_atime;	/* Time of last access.  */
+	unsigned long long st_atime_nsec;
+	long long	   st_mtime;	/* Time of last modification.  */
+	unsigned long long st_mtime_nsec;
+	long long	   st_ctime;	/* Time of last status change.  */
+	unsigned long long st_ctime_nsec;
+	unsigned int	   __unused4;
+	unsigned int	   __unused5;
+};
+#endif
+
+#endif /* __ASM_GENERIC_KERNEL_STAT_H */
diff --git a/include/uapi/asm-generic/stat.h b/include/uapi/asm-generic/stat.h
index bd8cad21998e..64c32ba7c1a9 100644
--- a/include/uapi/asm-generic/stat.h
+++ b/include/uapi/asm-generic/stat.h
@@ -8,15 +8,17 @@
  *
  * stat64 is copied from powerpc64, with explicit padding added.
  * stat is the same structure layout on 64-bit, without the 'long long'
- * types.
+ * types. Unfortunately, we started out using '32-bit st_*time here,
+ * which was a huge mistake.
  *
- * By convention, 64 bit architectures use the stat interface, while
- * 32 bit architectures use the stat64 interface. Note that we don't
- * provide an __old_kernel_stat here, which new architecture should
- * not have to start with.
+ * New architectures use only the __kernel_stat interface with
+ * 'sys_newfstatat', everything else is provided for backwards
+ * compatibility. Note that we don't provide an __old_kernel_stat here,
+ * which new architecture should not have to start with.
  */
 
 #include <asm/bitsperlong.h>
+#include <asm-generic/kernel_stat.h>
 
 #define STAT_HAVE_NSEC 1
 
-- 
2.1.0.rc2
