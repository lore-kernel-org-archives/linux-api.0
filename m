From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 06/14] asm-generic: Move common compat types to asm-generic/compat.h
Date: Mon, 27 Aug 2018 21:45:23 +0200
Message-ID: <20180827194531.3796559-7-arnd@arndb.de>
References: <20180827194531.3796559-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180827194531.3796559-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de
Cc: y2038@lists.linaro.org, linux-api@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, deepa.kernel@gmail.com, linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

While converting compat system call handlers to work on 32-bit
architectures, I found a number of types used in those handlers
that are identical between all architectures.

Let's move all the identical ones into asm-generic/compat.h to avoid
having to add even more identical definitions of those types.

For unknown reasons, mips defines __compat_gid32_t, __compat_uid32_t
and compat_caddr_t as signed, while all others have them unsigned.
This seems to be a mistake, but I'm leaving it alone here. The other
types all differ by size or alignment on at least on architecture.

compat_aio_context_t is currently defined in linux/compat.h but
also needed for compat_sys_io_getevents(), so let's move it into
the same place.

While we still have not decided whether the 32-bit time handling
will always use the compat syscalls, or in which form, I think this
is a useful cleanup that we can merge regardless.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm64/include/asm/compat.h   | 20 ++------------------
 arch/mips/include/asm/compat.h    | 22 ++--------------------
 arch/parisc/include/asm/compat.h  | 18 ++----------------
 arch/powerpc/include/asm/compat.h | 18 ++----------------
 arch/s390/include/asm/compat.h    | 18 ++----------------
 arch/sparc/include/asm/compat.h   | 19 ++-----------------
 arch/x86/include/asm/compat.h     | 19 ++-----------------
 include/asm-generic/compat.h      | 24 +++++++++++++++++++++++-
 include/linux/compat.h            |  2 --
 9 files changed, 37 insertions(+), 123 deletions(-)

diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
index 4a89007db14a..ee689d8a026d 100644
--- a/arch/arm64/include/asm/compat.h
+++ b/arch/arm64/include/asm/compat.h
@@ -25,6 +25,8 @@
 #include <linux/sched.h>
 #include <linux/sched/task_stack.h>
 
+#include <asm-generic/compat.h>
+
 #define COMPAT_USER_HZ		100
 #ifdef __AARCH64EB__
 #define COMPAT_UTS_MACHINE	"armv8b\0\0"
@@ -32,10 +34,6 @@
 #define COMPAT_UTS_MACHINE	"armv8l\0\0"
 #endif
 
-typedef u32		compat_size_t;
-typedef s32		compat_ssize_t;
-typedef s32		compat_clock_t;
-typedef s32		compat_pid_t;
 typedef u16		__compat_uid_t;
 typedef u16		__compat_gid_t;
 typedef u16		__compat_uid16_t;
@@ -43,27 +41,13 @@ typedef u16		__compat_gid16_t;
 typedef u32		__compat_uid32_t;
 typedef u32		__compat_gid32_t;
 typedef u16		compat_mode_t;
-typedef u32		compat_ino_t;
 typedef u32		compat_dev_t;
-typedef s32		compat_off_t;
-typedef s64		compat_loff_t;
 typedef s32		compat_nlink_t;
 typedef u16		compat_ipc_pid_t;
-typedef s32		compat_daddr_t;
 typedef u32		compat_caddr_t;
 typedef __kernel_fsid_t	compat_fsid_t;
-typedef s32		compat_key_t;
-typedef s32		compat_timer_t;
-
-typedef s16		compat_short_t;
-typedef s32		compat_int_t;
-typedef s32		compat_long_t;
 typedef s64		compat_s64;
-typedef u16		compat_ushort_t;
-typedef u32		compat_uint_t;
-typedef u32		compat_ulong_t;
 typedef u64		compat_u64;
-typedef u32		compat_uptr_t;
 
 struct compat_stat {
 #ifdef __AARCH64EB__
diff --git a/arch/mips/include/asm/compat.h b/arch/mips/include/asm/compat.h
index 7dcbd855814e..c99166eadbde 100644
--- a/arch/mips/include/asm/compat.h
+++ b/arch/mips/include/asm/compat.h
@@ -9,43 +9,25 @@
 #include <asm/page.h>
 #include <asm/ptrace.h>
 
+#include <asm-generic/compat.h>
+
 #define COMPAT_USER_HZ		100
 #define COMPAT_UTS_MACHINE	"mips\0\0\0"
 
-typedef u32		compat_size_t;
-typedef s32		compat_ssize_t;
-typedef s32		compat_clock_t;
-typedef s32		compat_suseconds_t;
-
-typedef s32		compat_pid_t;
 typedef s32		__compat_uid_t;
 typedef s32		__compat_gid_t;
 typedef __compat_uid_t	__compat_uid32_t;
 typedef __compat_gid_t	__compat_gid32_t;
 typedef u32		compat_mode_t;
-typedef u32		compat_ino_t;
 typedef u32		compat_dev_t;
-typedef s32		compat_off_t;
-typedef s64		compat_loff_t;
 typedef u32		compat_nlink_t;
 typedef s32		compat_ipc_pid_t;
-typedef s32		compat_daddr_t;
 typedef s32		compat_caddr_t;
 typedef struct {
 	s32	val[2];
 } compat_fsid_t;
-typedef s32		compat_timer_t;
-typedef s32		compat_key_t;
-
-typedef s16		compat_short_t;
-typedef s32		compat_int_t;
-typedef s32		compat_long_t;
 typedef s64		compat_s64;
-typedef u16		compat_ushort_t;
-typedef u32		compat_uint_t;
-typedef u32		compat_ulong_t;
 typedef u64		compat_u64;
-typedef u32		compat_uptr_t;
 
 struct compat_stat {
 	compat_dev_t	st_dev;
diff --git a/arch/parisc/include/asm/compat.h b/arch/parisc/include/asm/compat.h
index 32dadaf2b534..e03e3c849f40 100644
--- a/arch/parisc/include/asm/compat.h
+++ b/arch/parisc/include/asm/compat.h
@@ -8,36 +8,22 @@
 #include <linux/sched.h>
 #include <linux/thread_info.h>
 
+#include <asm-generic/compat.h>
+
 #define COMPAT_USER_HZ 		100
 #define COMPAT_UTS_MACHINE	"parisc\0\0"
 
-typedef u32	compat_size_t;
-typedef s32	compat_ssize_t;
-typedef s32	compat_clock_t;
-typedef s32	compat_pid_t;
 typedef u32	__compat_uid_t;
 typedef u32	__compat_gid_t;
 typedef u32	__compat_uid32_t;
 typedef u32	__compat_gid32_t;
 typedef u16	compat_mode_t;
-typedef u32	compat_ino_t;
 typedef u32	compat_dev_t;
-typedef s32	compat_off_t;
-typedef s64	compat_loff_t;
 typedef u16	compat_nlink_t;
 typedef u16	compat_ipc_pid_t;
-typedef s32	compat_daddr_t;
 typedef u32	compat_caddr_t;
-typedef s32	compat_key_t;
-typedef s32	compat_timer_t;
-
-typedef s32	compat_int_t;
-typedef s32	compat_long_t;
 typedef s64	compat_s64;
-typedef u32	compat_uint_t;
-typedef u32	compat_ulong_t;
 typedef u64	compat_u64;
-typedef u32	compat_uptr_t;
 
 struct compat_stat {
 	compat_dev_t		st_dev;	/* dev_t is 32 bits on parisc */
diff --git a/arch/powerpc/include/asm/compat.h b/arch/powerpc/include/asm/compat.h
index 93f79d1a03c3..74d0db511099 100644
--- a/arch/powerpc/include/asm/compat.h
+++ b/arch/powerpc/include/asm/compat.h
@@ -8,6 +8,8 @@
 #include <linux/types.h>
 #include <linux/sched.h>
 
+#include <asm-generic/compat.h>
+
 #define COMPAT_USER_HZ		100
 #ifdef __BIG_ENDIAN__
 #define COMPAT_UTS_MACHINE	"ppc\0\0"
@@ -15,34 +17,18 @@
 #define COMPAT_UTS_MACHINE	"ppcle\0\0"
 #endif
 
-typedef u32		compat_size_t;
-typedef s32		compat_ssize_t;
-typedef s32		compat_clock_t;
-typedef s32		compat_pid_t;
 typedef u32		__compat_uid_t;
 typedef u32		__compat_gid_t;
 typedef u32		__compat_uid32_t;
 typedef u32		__compat_gid32_t;
 typedef u32		compat_mode_t;
-typedef u32		compat_ino_t;
 typedef u32		compat_dev_t;
-typedef s32		compat_off_t;
-typedef s64		compat_loff_t;
 typedef s16		compat_nlink_t;
 typedef u16		compat_ipc_pid_t;
-typedef s32		compat_daddr_t;
 typedef u32		compat_caddr_t;
 typedef __kernel_fsid_t	compat_fsid_t;
-typedef s32		compat_key_t;
-typedef s32		compat_timer_t;
-
-typedef s32		compat_int_t;
-typedef s32		compat_long_t;
 typedef s64		compat_s64;
-typedef u32		compat_uint_t;
-typedef u32		compat_ulong_t;
 typedef u64		compat_u64;
-typedef u32		compat_uptr_t;
 
 struct compat_stat {
 	compat_dev_t	st_dev;
diff --git a/arch/s390/include/asm/compat.h b/arch/s390/include/asm/compat.h
index 97db2fba546a..63b46e30b2c3 100644
--- a/arch/s390/include/asm/compat.h
+++ b/arch/s390/include/asm/compat.h
@@ -9,6 +9,8 @@
 #include <linux/sched/task_stack.h>
 #include <linux/thread_info.h>
 
+#include <asm-generic/compat.h>
+
 #define __TYPE_IS_PTR(t) (!__builtin_types_compatible_p( \
 				typeof(0?(__force t)0:0ULL), u64))
 
@@ -51,34 +53,18 @@
 #define COMPAT_USER_HZ		100
 #define COMPAT_UTS_MACHINE	"s390\0\0\0\0"
 
-typedef u32		compat_size_t;
-typedef s32		compat_ssize_t;
-typedef s32		compat_clock_t;
-typedef s32		compat_pid_t;
 typedef u16		__compat_uid_t;
 typedef u16		__compat_gid_t;
 typedef u32		__compat_uid32_t;
 typedef u32		__compat_gid32_t;
 typedef u16		compat_mode_t;
-typedef u32		compat_ino_t;
 typedef u16		compat_dev_t;
-typedef s32		compat_off_t;
-typedef s64		compat_loff_t;
 typedef u16		compat_nlink_t;
 typedef u16		compat_ipc_pid_t;
-typedef s32		compat_daddr_t;
 typedef u32		compat_caddr_t;
 typedef __kernel_fsid_t	compat_fsid_t;
-typedef s32		compat_key_t;
-typedef s32		compat_timer_t;
-
-typedef s32		compat_int_t;
-typedef s32		compat_long_t;
 typedef s64		compat_s64;
-typedef u32		compat_uint_t;
-typedef u32		compat_ulong_t;
 typedef u64		compat_u64;
-typedef u32		compat_uptr_t;
 
 typedef struct {
 	u32 mask;
diff --git a/arch/sparc/include/asm/compat.h b/arch/sparc/include/asm/compat.h
index 7018cb60beef..30b1763580b1 100644
--- a/arch/sparc/include/asm/compat.h
+++ b/arch/sparc/include/asm/compat.h
@@ -6,38 +6,23 @@
  */
 #include <linux/types.h>
 
+#include <asm-generic/compat.h>
+
 #define COMPAT_USER_HZ		100
 #define COMPAT_UTS_MACHINE	"sparc\0\0"
 
-typedef u32		compat_size_t;
-typedef s32		compat_ssize_t;
-typedef s32		compat_clock_t;
-typedef s32		compat_pid_t;
 typedef u16		__compat_uid_t;
 typedef u16		__compat_gid_t;
 typedef u32		__compat_uid32_t;
 typedef u32		__compat_gid32_t;
 typedef u16		compat_mode_t;
-typedef u32		compat_ino_t;
 typedef u16		compat_dev_t;
-typedef s32		compat_off_t;
-typedef s64		compat_loff_t;
 typedef s16		compat_nlink_t;
 typedef u16		compat_ipc_pid_t;
-typedef s32		compat_daddr_t;
 typedef u32		compat_caddr_t;
 typedef __kernel_fsid_t	compat_fsid_t;
-typedef s32		compat_key_t;
-typedef s32		compat_timer_t;
-
-typedef s32		compat_int_t;
-typedef s32		compat_long_t;
 typedef s64		compat_s64;
-typedef u32		compat_uint_t;
-typedef u32		compat_ulong_t;
 typedef u64		compat_u64;
-typedef u32		compat_uptr_t;
-
 struct compat_stat {
 	compat_dev_t	st_dev;
 	compat_ino_t	st_ino;
diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
index fb97cf7c4137..0ce6f452d334 100644
--- a/arch/x86/include/asm/compat.h
+++ b/arch/x86/include/asm/compat.h
@@ -12,38 +12,23 @@
 #include <asm/user32.h>
 #include <asm/unistd.h>
 
+#include <asm-generic/compat.h>
+
 #define COMPAT_USER_HZ		100
 #define COMPAT_UTS_MACHINE	"i686\0\0"
 
-typedef u32		compat_size_t;
-typedef s32		compat_ssize_t;
-typedef s32		compat_clock_t;
-typedef s32		compat_pid_t;
 typedef u16		__compat_uid_t;
 typedef u16		__compat_gid_t;
 typedef u32		__compat_uid32_t;
 typedef u32		__compat_gid32_t;
 typedef u16		compat_mode_t;
-typedef u32		compat_ino_t;
 typedef u16		compat_dev_t;
-typedef s32		compat_off_t;
-typedef s64		compat_loff_t;
 typedef u16		compat_nlink_t;
 typedef u16		compat_ipc_pid_t;
-typedef s32		compat_daddr_t;
 typedef u32		compat_caddr_t;
 typedef __kernel_fsid_t	compat_fsid_t;
-typedef s32		compat_timer_t;
-typedef s32		compat_key_t;
-
-typedef s32		compat_int_t;
-typedef s32		compat_long_t;
 typedef s64 __attribute__((aligned(4))) compat_s64;
-typedef u32		compat_uint_t;
-typedef u32		compat_ulong_t;
-typedef u32		compat_u32;
 typedef u64 __attribute__((aligned(4))) compat_u64;
-typedef u32		compat_uptr_t;
 
 struct compat_stat {
 	compat_dev_t	st_dev;
diff --git a/include/asm-generic/compat.h b/include/asm-generic/compat.h
index 28819451b6d1..a86f65bffab8 100644
--- a/include/asm-generic/compat.h
+++ b/include/asm-generic/compat.h
@@ -1,3 +1,25 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_GENERIC_COMPAT_H
+#define __ASM_GENERIC_COMPAT_H
 
-/* This is an empty stub for 32-bit-only architectures */
+/* These types are common across all compat ABIs */
+typedef u32 compat_size_t;
+typedef s32 compat_ssize_t;
+typedef s32 compat_clock_t;
+typedef s32 compat_pid_t;
+typedef u32 compat_ino_t;
+typedef s32 compat_off_t;
+typedef s64 compat_loff_t;
+typedef s32 compat_daddr_t;
+typedef s32 compat_timer_t;
+typedef s32 compat_key_t;
+typedef s16 compat_short_t;
+typedef s32 compat_int_t;
+typedef s32 compat_long_t;
+typedef u16 compat_ushort_t;
+typedef u32 compat_uint_t;
+typedef u32 compat_ulong_t;
+typedef u32 compat_uptr_t;
+typedef u32 compat_aio_context_t;
+
+#endif
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 0e058792ecf6..d376fa8be00d 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -110,8 +110,6 @@ typedef struct compat_sigaltstack {
 typedef __compat_uid32_t	compat_uid_t;
 typedef __compat_gid32_t	compat_gid_t;
 
-typedef	compat_ulong_t		compat_aio_context_t;
-
 struct compat_sel_arg_struct;
 struct rusage;
 
-- 
2.18.0
