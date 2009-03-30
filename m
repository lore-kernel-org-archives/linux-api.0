From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: Removing __kernel_old_uid_t, git_t, dev_t
Date: Mon, 30 Mar 2009 15:58:09 +0200
Message-ID: <200903301558.10598.arnd@arndb.de>
References: <49D071A8.4010703@petalogix.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <49D071A8.4010703@petalogix.com>
Content-Disposition: inline
Sender: linux-arch-owner@vger.kernel.org
To: michal.simek@petalogix.com
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Monday 30 March 2009, Michal Simek wrote:

> on the base our discussion some month ago you recommend me to remove old
> kernel types.
> I did some tests and I found that first step must be to remove all
> references in linux kernel code because of compilation error.
> Just perform grep to include linux folder.
> 
> I think we should create this patch first and then I can remove them
> from MB posix_types.h.
> 
> Do you agree with me?

I've experimented with this in the meantime, and concluded that we can't
easily remove them, but should rather define them to the current
ones.

How does this look?
---
Provide generic asm/types.h and asm/posix_types.h

For new architectures, the base data types should always be
the same, so let's have a version in asm/generic that can be
used by all of them out of the box. Other architectures can
simplify their code by #including them after defining their
platform specific types.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/include/asm-generic/posix_types.h b/include/asm-generic/posix_types.h
new file mode 100644
index 0000000..4772f74
--- /dev/null
+++ b/include/asm-generic/posix_types.h
@@ -0,0 +1,162 @@
+#ifndef __ASM_GENERIC_POSIX_TYPES_H
+#define __ASM_GENERIC_POSIX_TYPES_H
+
+#include <asm/types.h>
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
diff --git a/include/asm-generic/types.h b/include/asm-generic/types.h
new file mode 100644
index 0000000..5841716
--- /dev/null
+++ b/include/asm-generic/types.h
@@ -0,0 +1,56 @@
+#ifndef __ASM_GENERIC_TYPES_H
+#define __ASM_GENERIC_TYPES_H
+
+/*
+ * int-ll64 is used on all 32 bit architectures and on x86-64,
+ * so use it as a reasonable default.
+ */
+#include <asm-generic/int-ll64.h>
+
+#ifndef __ASSEMBLY__
+
+typedef unsigned short umode_t;
+
+#endif /* __ASSEMBLY__ */
+
+/*
+ * There seems to be no way of detecting this automatically from user
+ * space, so 64 bit architectures should override this in their types.h.
+ */
+#ifndef __BITS_PER_LONG
+#define __BITS_PER_LONG 32
+#endif
+
+/*
+ * These aren't exported outside the kernel to avoid name space clashes
+ */
+#ifdef __KERNEL__
+
+#ifdef CONFIG_64BIT
+#define BITS_PER_LONG 64
+#else
+#define BITS_PER_LONG 32
+#endif /* CONFIG_64BIT */
+
+#if BITS_PER_LONG != __BITS_PER_LONG
+#error cannot determine word size
+#endif
+
+#ifndef __ASSEMBLY__
+
+/*
+ * DMA addresses may be larger than pointers, but not smaller.
+ * Do not define the dma64_addr_t type, which never really
+ * worked.
+ */
+#if defined(CONFIG_64BIT) || defined(CONFIG_PHYS_64BIT)
+typedef u64 dma_addr_t;
+#else
+typedef u32 dma_addr_t;
+#endif /* 64 bit DMA pointer */
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_GENERIC_TYPES_H */
