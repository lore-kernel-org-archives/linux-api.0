From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [RFC] asm-generic/{unistd,types,posix_types}.h for new arch
Date: Wed, 1 Apr 2009 16:11:52 +0200
Message-ID: <200904011611.53355.arnd@arndb.de>
References: <49D071A8.4010703@petalogix.com> <10f740e80903300741h387e6342veba0ccceea6714e9@mail.gmail.com> <200903301717.57184.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <200903301717.57184.arnd-r2nGTMty4D4@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Geert Uytterhoeven <geert.uytterhoeven-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: michal.simek-g5w7nrANp4BDPfheJLI6IQ@public.gmane.org, Linux Kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chen Liqin <liqin.chen-+XGAvkf1AAHby3iVrkZq2A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
List-Id: linux-api@vger.kernel.org

I've spent more time on my asm-generic patches and believe I now
have an unistd.h implementation that can be used by the new
architectures (score and microblaze) so they don't have to go
through the error-prone process of coming up with their own lists.

It would be good if more people could in particular look over the
system call lists. I have left the syscalls that I think should
be dropped in #ifdef __ARCH_WANT_SYSCALL_{DEPRECATED,NO_AT,NO_FLAGS,OFF_T}
so that it becomes easy to reenable them temporarily while porting
the libc, and to easily see which ones get left out.

I have also changed checksyscalls.sh to stop complaining when
the old syscalls are not present.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
 include/asm-generic/posix_types.h |  162 ++++++
 include/asm-generic/types.h       |   63 ++
 include/asm-generic/unistd.h      |  829 +++++++++++++++++++++++++++++
 kernel/Makefile                   |    1 +
 kernel/syscall_table.c            |   12 +
 scripts/checksyscalls.sh          |   93 +++-
 6 files changed, 1157 insertions(+), 3 deletions(-)


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
index 0000000..147b553
--- /dev/null
+++ b/include/asm-generic/types.h
@@ -0,0 +1,63 @@
+#ifndef _ASM_GENERIC_TYPES_H
+#define _ASM_GENERIC_TYPES_H
+
+/*
+ * int-ll64 is used practically everywhere now,
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
+typedef u64 dma_addr_t;
+#else
+typedef u32 dma_addr_t;
+#endif /* CONFIG_PHYS_ADDR_T_64BIT */
+#endif /* dma_addr_t */
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_GENERIC_TYPES_H */
diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
new file mode 100644
index 0000000..9c27fe0
--- /dev/null
+++ b/include/asm-generic/unistd.h
@@ -0,0 +1,829 @@
+#if !defined(_ASM_GENERIC_UNISTD_H) || defined(__SYSCALL)
+#define _ASM_GENERIC_UNISTD_H
+
+/* need types.h for __BITS_PER_LONG */
+#include <linux/types.h>
+
+/*
+ * This file contains the system call numbers, based on the
+ * layout of the x86-64 architecture, which embeds the
+ * pointer to the syscall in the table.
+ *
+ * As a basic principle, no duplication of functionality
+ * should be added, e.g. we don't use lseek when llseek
+ * is present. New architectures should use this file
+ * and implement the less feature-full calls in user space.
+ *
+ * This file version is for review only, once the set of
+ * syscalls that are required has been determined, the
+ * __LINE__ numbers will be replaced with contiguous
+ * numbers for the syscalls.
+ */
+
+#ifndef __SYSCALL
+#define __SYSCALL(x,y)
+#endif
+
+#if __BITS_PER_LONG == 32
+#define __SC_3264(_nr, _32, _64) __SYSCALL(_nr, _32)
+#else
+#define __SC_3264(_nr, _32, _64) __SYSCALL(_nr, _64)
+#endif
+
+#define __NR_io_setup __LINE__
+__SYSCALL(__NR_io_setup, sys_io_setup)
+#define __NR_io_destroy __LINE__
+__SYSCALL(__NR_io_destroy, sys_io_destroy)
+#define __NR_io_submit __LINE__
+__SYSCALL(__NR_io_submit, sys_io_submit)
+#define __NR_io_cancel __LINE__
+__SYSCALL(__NR_io_cancel, sys_io_cancel)
+#define __NR_io_getevents __LINE__
+__SYSCALL(__NR_io_getevents, sys_io_getevents)
+
+/* fs/xattr.c */
+#define __NR_setxattr __LINE__
+__SYSCALL(__NR_setxattr, sys_setxattr)
+#define __NR_lsetxattr __LINE__
+__SYSCALL(__NR_lsetxattr, sys_lsetxattr)
+#define __NR_fsetxattr __LINE__
+__SYSCALL(__NR_fsetxattr, sys_fsetxattr)
+#define __NR_getxattr __LINE__
+__SYSCALL(__NR_getxattr, sys_getxattr)
+#define __NR_lgetxattr __LINE__
+__SYSCALL(__NR_lgetxattr, sys_lgetxattr)
+#define __NR_fgetxattr __LINE__
+__SYSCALL(__NR_fgetxattr, sys_fgetxattr)
+#define __NR_listxattr __LINE__
+__SYSCALL(__NR_listxattr, sys_listxattr)
+#define __NR_llistxattr __LINE__
+__SYSCALL(__NR_llistxattr, sys_llistxattr)
+#define __NR_flistxattr __LINE__
+__SYSCALL(__NR_flistxattr, sys_flistxattr)
+#define __NR_removexattr __LINE__
+__SYSCALL(__NR_removexattr, sys_removexattr)
+#define __NR_lremovexattr __LINE__
+__SYSCALL(__NR_lremovexattr, sys_lremovexattr)
+#define __NR_fremovexattr __LINE__
+__SYSCALL(__NR_fremovexattr, sys_fremovexattr)
+
+/* fs/dcache.c */
+#define __NR_getcwd __LINE__
+__SYSCALL(__NR_getcwd, sys_getcwd)
+
+/* fs/cookies.c */
+#define __NR_lookup_dcookie __LINE__
+__SYSCALL(__NR_lookup_dcookie, sys_lookup_dcookie)
+
+/* fs/eventfd.c */
+#define __NR_eventfd2 __LINE__
+__SYSCALL(__NR_eventfd2, sys_eventfd2)
+
+/* fs/eventpoll.c */
+#define __NR_epoll_create1 __LINE__
+__SYSCALL(__NR_epoll_create1, sys_epoll_create1)
+#define __NR_epoll_ctl __LINE__
+__SYSCALL(__NR_epoll_ctl, sys_epoll_ctl)
+#define __NR_epoll_pwait __LINE__
+__SYSCALL(__NR_epoll_pwait, sys_epoll_pwait)
+
+/* fs/fcntl.c */
+#define __NR_dup __LINE__
+__SYSCALL(__NR_dup, sys_dup)
+#define __NR_dup3 __LINE__
+__SYSCALL(__NR_dup3, sys_dup3)
+#define __NR3264_fcntl __LINE__
+__SC_3264(__NR3264_fcntl, sys_fcntl64, sys_fcntl)
+
+/* fs/inotify_user.c */
+#define __NR_inotify_init1 __LINE__
+__SYSCALL(__NR_inotify_init1, sys_inotify_init1)
+#define __NR_inotify_add_watch __LINE__
+__SYSCALL(__NR_inotify_add_watch, sys_inotify_add_watch)
+#define __NR_inotify_rm_watch __LINE__
+__SYSCALL(__NR_inotify_rm_watch, sys_inotify_rm_watch)
+
+/* fs/ioctl.c */
+#define __NR_ioctl __LINE__
+__SYSCALL(__NR_ioctl, sys_ioctl)
+
+/* fs/ioprio.c */
+#define __NR_ioprio_set __LINE__
+__SYSCALL(__NR_ioprio_set, sys_ioprio_set)
+#define __NR_ioprio_get __LINE__
+__SYSCALL(__NR_ioprio_get, sys_ioprio_get)
+
+/* fs/locks.c */
+#define __NR_flock __LINE__
+__SYSCALL(__NR_flock, sys_flock)
+
+/* fs/namei.c */
+#define __NR_mknodat __LINE__
+__SYSCALL(__NR_mknodat, sys_mknodat)
+#define __NR_mkdirat __LINE__
+__SYSCALL(__NR_mkdirat, sys_mkdirat)
+#define __NR_unlinkat __LINE__
+__SYSCALL(__NR_unlinkat, sys_unlinkat)
+#define __NR_symlinkat __LINE__
+__SYSCALL(__NR_symlinkat, sys_symlinkat)
+#define __NR_linkat __LINE__
+__SYSCALL(__NR_linkat, sys_linkat)
+#define __NR_renameat __LINE__
+__SYSCALL(__NR_renameat, sys_renameat)
+
+/* fs/namespace.c */
+#define __NR_umount2 __LINE__
+__SYSCALL(__NR_umount2, sys_umount)
+#define __NR_mount __LINE__
+__SYSCALL(__NR_mount, sys_mount)
+#define __NR_pivot_root __LINE__
+__SYSCALL(__NR_pivot_root, sys_pivot_root)
+
+/* fs/nfsctl.c */
+#define __NR_nfsservctl __LINE__
+__SYSCALL(__NR_nfsservctl, sys_nfsservctl)
+
+/* fs/open.c */
+#define __NR3264_statfs __LINE__
+__SC_3264(__NR3264_statfs, sys_statfs64, sys_statfs)
+#define __NR3264_fstatfs __LINE__
+__SC_3264(__NR3264_fstatfs, sys_fstatfs64, sys_fstatfs)
+#define __NR3264_truncate __LINE__
+__SC_3264(__NR3264_truncate, sys_truncate64, sys_truncate)
+#define __NR3264_ftruncate __LINE__
+__SC_3264(__NR3264_ftruncate, sys_ftruncate64, sys_ftruncate)
+
+#define __NR_fallocate __LINE__
+__SYSCALL(__NR_fallocate, sys_fallocate)
+#define __NR_faccessat __LINE__
+__SYSCALL(__NR_faccessat, sys_faccessat)
+#define __NR_chdir __LINE__
+__SYSCALL(__NR_chdir, sys_chdir)
+#define __NR_fchdir __LINE__
+__SYSCALL(__NR_fchdir, sys_fchdir)
+#define __NR_chroot __LINE__
+__SYSCALL(__NR_chroot, sys_chroot)
+#define __NR_fchmod __LINE__
+__SYSCALL(__NR_fchmod, sys_fchmod)
+#define __NR_fchmodat __LINE__
+__SYSCALL(__NR_fchmodat, sys_fchmodat)
+#define __NR_fchownat __LINE__
+__SYSCALL(__NR_fchownat, sys_fchownat)
+#define __NR_fchown __LINE__
+__SYSCALL(__NR_fchown, sys_fchown)
+#define __NR_openat __LINE__
+__SYSCALL(__NR_openat, sys_openat)
+#define __NR_close __LINE__
+__SYSCALL(__NR_close, sys_close)
+#define __NR_vhangup __LINE__
+__SYSCALL(__NR_vhangup, sys_vhangup)
+
+/* fs/pipe.c */
+#define __NR_pipe2 __LINE__
+__SYSCALL(__NR_pipe2, sys_pipe2)
+
+/* fs/quota.c */
+#define __NR_quotactl __LINE__
+__SYSCALL(__NR_quotactl, sys_quotactl)
+
+/* fs/readdir.c */
+#define __NR3264_getdents __LINE__
+__SC_3264(__NR3264_getdents, sys_getdents64, sys_getdents)
+
+/* fs/read_write.c */
+#define __NR3264_lseek __LINE__
+__SC_3264(__NR3264_lseek, sys_llseek, sys_lseek)
+#define __NR_read __LINE__
+__SYSCALL(__NR_read, sys_read)
+#define __NR_readv __LINE__
+__SYSCALL(__NR_readv, sys_readv)
+#define __NR_write __LINE__
+__SYSCALL(__NR_write, sys_write)
+#define __NR_writev __LINE__
+__SYSCALL(__NR_writev, sys_writev)
+#define __NR_pread64 __LINE__
+__SYSCALL(__NR_pread64, sys_pread64)
+#define __NR_pwrite64 __LINE__
+__SYSCALL(__NR_pwrite64, sys_pwrite64)
+
+/* fs/sendfile.c */
+#define __NR3264_sendfile __LINE__
+__SC_3264(__NR3264_sendfile, sys_sendfile64, sys_sendfile)
+
+/* fs/select.c */
+#define __NR_pselect6 __LINE__
+__SYSCALL(__NR_pselect6, sys_pselect6)
+#define __NR_ppoll __LINE__
+__SYSCALL(__NR_ppoll, sys_ppoll)
+
+/* fs/signalfd.c */
+#define __NR_signalfd4 __LINE__
+__SYSCALL(__NR_signalfd4, sys_signalfd4)
+
+/* fs/splice.c */
+#define __NR_vmsplice __LINE__
+__SYSCALL(__NR_vmsplice, sys_vmsplice)
+#define __NR_splice __LINE__
+__SYSCALL(__NR_splice, sys_splice)
+#define __NR_tee __LINE__
+__SYSCALL(__NR_tee, sys_tee)
+
+/* fs/stat.c */
+#define __NR_readlinkat __LINE__
+__SYSCALL(__NR_readlinkat, sys_readlinkat)
+#define __NR3264_fstatat __LINE__
+__SC_3264(__NR3264_fstatat, sys_fstatat64, sys_newfstatat)
+#define __NR3264_fstat __LINE__
+__SC_3264(__NR3264_fstat, sys_fstat64, sys_newfstat)
+
+/* fs/sync.c */
+#define __NR_sync __LINE__
+__SYSCALL(__NR_sync, sys_sync)
+#define __NR_fsync __LINE__
+__SYSCALL(__NR_fsync, sys_fsync)
+#define __NR_fdatasync __LINE__
+__SYSCALL(__NR_fdatasync, sys_fdatasync)
+#define __NR_sync_file_range __LINE__
+__SYSCALL(__NR_sync_file_range, sys_sync_file_range) /* .long sys_sync_file_range2, */
+
+/* fs/timerfd.c */
+#define __NR_timerfd_create __LINE__
+__SYSCALL(__NR_timerfd_create, sys_timerfd_create)
+#define __NR_timerfd_settime __LINE__
+__SYSCALL(__NR_timerfd_settime, sys_timerfd_settime)
+#define __NR_timerfd_gettime __LINE__
+__SYSCALL(__NR_timerfd_gettime, sys_timerfd_gettime)
+
+/* fs/utimes.c */
+#define __NR_utimensat __LINE__
+__SYSCALL(__NR_utimensat, sys_utimensat)
+
+/* kernel/acct.c */
+#define __NR_acct __LINE__
+__SYSCALL(__NR_acct, sys_acct)
+
+/* kernel/capability.c */
+#define __NR_capget __LINE__
+__SYSCALL(__NR_capget, sys_capget)
+#define __NR_capset __LINE__
+__SYSCALL(__NR_capset, sys_capset)
+
+/* kernel/exec_domain.c */
+#define __NR_personality __LINE__
+__SYSCALL(__NR_personality, sys_personality)
+
+/* kernel/exit.c */
+#define __NR_exit __LINE__
+__SYSCALL(__NR_exit, sys_exit)
+#define __NR_exit_group __LINE__
+__SYSCALL(__NR_exit_group, sys_exit_group)
+#define __NR_waitid __LINE__
+__SYSCALL(__NR_waitid, sys_waitid)
+
+/* kernel/fork.c */
+#define __NR_set_tid_address __LINE__
+__SYSCALL(__NR_set_tid_address, sys_set_tid_address)
+#define __NR_unshare __LINE__
+__SYSCALL(__NR_unshare, sys_unshare)
+
+/* kernel/futex.c */
+#define __NR_futex __LINE__
+__SYSCALL(__NR_futex, sys_futex)
+#define __NR_set_robust_list __LINE__
+__SYSCALL(__NR_set_robust_list, sys_set_robust_list)
+#define __NR_get_robust_list __LINE__
+__SYSCALL(__NR_get_robust_list, sys_get_robust_list)
+
+/* kernel/hrtimer.c */
+#define __NR_nanosleep __LINE__
+__SYSCALL(__NR_nanosleep, sys_nanosleep)
+
+/* kernel/itimer.c */
+#define __NR_getitimer __LINE__
+__SYSCALL(__NR_getitimer, sys_getitimer)
+#define __NR_setitimer __LINE__
+__SYSCALL(__NR_setitimer, sys_setitimer)
+
+/* kernel/kexec.c */
+#define __NR_kexec_load __LINE__
+__SYSCALL(__NR_kexec_load, sys_kexec_load)
+
+/* kernel/module.c */
+#define __NR_init_module __LINE__
+__SYSCALL(__NR_init_module, sys_init_module)
+#define __NR_delete_module __LINE__
+__SYSCALL(__NR_delete_module, sys_delete_module)
+
+/* kernel/posix-timers.c */
+#define __NR_timer_create __LINE__
+__SYSCALL(__NR_timer_create, sys_timer_create)
+#define __NR_timer_gettime __LINE__
+__SYSCALL(__NR_timer_gettime, sys_timer_gettime)
+#define __NR_timer_getoverrun __LINE__
+__SYSCALL(__NR_timer_getoverrun, sys_timer_getoverrun)
+#define __NR_timer_settime __LINE__
+__SYSCALL(__NR_timer_settime, sys_timer_settime)
+#define __NR_timer_delete __LINE__
+__SYSCALL(__NR_timer_delete, sys_timer_delete)
+#define __NR_clock_settime __LINE__
+__SYSCALL(__NR_clock_settime, sys_clock_settime)
+#define __NR_clock_gettime __LINE__
+__SYSCALL(__NR_clock_gettime, sys_clock_gettime)
+#define __NR_clock_getres __LINE__
+__SYSCALL(__NR_clock_getres, sys_clock_getres)
+#define __NR_clock_nanosleep __LINE__
+__SYSCALL(__NR_clock_nanosleep, sys_clock_nanosleep)
+
+/* kernel/printk.c */
+#define __NR_syslog __LINE__
+__SYSCALL(__NR_syslog, sys_syslog)
+
+/* kernel/ptrace.c */
+#define __NR_ptrace __LINE__
+__SYSCALL(__NR_ptrace, sys_ptrace)
+
+/* kernel/sched.c */
+#define __NR_sched_setparam __LINE__
+__SYSCALL(__NR_sched_setparam, sys_sched_setparam)
+#define __NR_sched_setscheduler __LINE__
+__SYSCALL(__NR_sched_setscheduler, sys_sched_setscheduler)
+#define __NR_sched_getscheduler __LINE__
+__SYSCALL(__NR_sched_getscheduler, sys_sched_getscheduler)
+#define __NR_sched_getparam __LINE__
+__SYSCALL(__NR_sched_getparam, sys_sched_getparam)
+#define __NR_sched_setaffinity __LINE__
+__SYSCALL(__NR_sched_setaffinity, sys_sched_setaffinity)
+#define __NR_sched_getaffinity __LINE__
+__SYSCALL(__NR_sched_getaffinity, sys_sched_getaffinity)
+#define __NR_sched_yield __LINE__
+__SYSCALL(__NR_sched_yield, sys_sched_yield)
+#define __NR_sched_get_priority_max __LINE__
+__SYSCALL(__NR_sched_get_priority_max, sys_sched_get_priority_max)
+#define __NR_sched_get_priority_min __LINE__
+__SYSCALL(__NR_sched_get_priority_min, sys_sched_get_priority_min)
+#define __NR_sched_rr_get_interval __LINE__
+__SYSCALL(__NR_sched_rr_get_interval, sys_sched_rr_get_interval)
+
+/* kernel/signal.c */
+#define __NR_restart_syscall __LINE__
+__SYSCALL(__NR_restart_syscall, sys_restart_syscall)
+#define __NR_kill __LINE__
+__SYSCALL(__NR_kill, sys_kill)
+#define __NR_tkill __LINE__
+__SYSCALL(__NR_tkill, sys_tkill)
+#define __NR_tgkill __LINE__
+__SYSCALL(__NR_tgkill, sys_tgkill)
+#define __NR_sigaltstack __LINE__
+__SYSCALL(__NR_sigaltstack, sys_sigaltstack)
+#define __NR_rt_sigsuspend __LINE__
+__SYSCALL(__NR_rt_sigsuspend, sys_rt_sigsuspend) /* __ARCH_WANT_SYS_RT_SIGSUSPEND */
+#define __NR_rt_sigaction __LINE__
+__SYSCALL(__NR_rt_sigaction, sys_rt_sigaction) /* __ARCH_WANT_SYS_RT_SIGACTION */
+#define __NR_rt_sigprocmask __LINE__
+__SYSCALL(__NR_rt_sigprocmask, sys_rt_sigprocmask)
+#define __NR_rt_sigpending __LINE__
+__SYSCALL(__NR_rt_sigpending, sys_rt_sigpending)
+#define __NR_rt_sigtimedwait __LINE__
+__SYSCALL(__NR_rt_sigtimedwait, sys_rt_sigtimedwait)
+#define __NR_rt_sigqueueinfo __LINE__
+__SYSCALL(__NR_rt_sigqueueinfo, sys_rt_sigqueueinfo)
+#define __NR_rt_sigreturn __LINE__
+__SYSCALL(__NR_rt_sigreturn, sys_rt_sigreturn) /* sys_rt_sigreturn_wrapper, */
+
+/* kernel/sys.c */
+#define __NR_setpriority __LINE__
+__SYSCALL(__NR_setpriority, sys_setpriority)
+#define __NR_getpriority __LINE__
+__SYSCALL(__NR_getpriority, sys_getpriority)
+#define __NR_reboot __LINE__
+__SYSCALL(__NR_reboot, sys_reboot)
+#define __NR_setregid __LINE__
+__SYSCALL(__NR_setregid, sys_setregid)
+#define __NR_setgid __LINE__
+__SYSCALL(__NR_setgid, sys_setgid)
+#define __NR_setreuid __LINE__
+__SYSCALL(__NR_setreuid, sys_setreuid)
+#define __NR_setuid __LINE__
+__SYSCALL(__NR_setuid, sys_setuid)
+#define __NR_setresuid __LINE__
+__SYSCALL(__NR_setresuid, sys_setresuid)
+#define __NR_getresuid __LINE__
+__SYSCALL(__NR_getresuid, sys_getresuid)
+#define __NR_setresgid __LINE__
+__SYSCALL(__NR_setresgid, sys_setresgid)
+#define __NR_getresgid __LINE__
+__SYSCALL(__NR_getresgid, sys_getresgid)
+#define __NR_setfsuid __LINE__
+__SYSCALL(__NR_setfsuid, sys_setfsuid)
+#define __NR_setfsgid __LINE__
+__SYSCALL(__NR_setfsgid, sys_setfsgid)
+#define __NR_times __LINE__
+__SYSCALL(__NR_times, sys_times)
+#define __NR_setpgid __LINE__
+__SYSCALL(__NR_setpgid, sys_setpgid)
+#define __NR_getpgid __LINE__
+__SYSCALL(__NR_getpgid, sys_getpgid)
+#define __NR_getsid __LINE__
+__SYSCALL(__NR_getsid, sys_getsid)
+#define __NR_setsid __LINE__
+__SYSCALL(__NR_setsid, sys_setsid)
+#define __NR_getgroups __LINE__
+__SYSCALL(__NR_getgroups, sys_getgroups)
+#define __NR_setgroups __LINE__
+__SYSCALL(__NR_setgroups, sys_setgroups)
+#define __NR_uname __LINE__
+__SYSCALL(__NR_uname, sys_newuname)
+#define __NR_sethostname __LINE__
+__SYSCALL(__NR_sethostname, sys_sethostname)
+#define __NR_setdomainname __LINE__
+__SYSCALL(__NR_setdomainname, sys_setdomainname)
+#define __NR_getrlimit __LINE__
+__SYSCALL(__NR_getrlimit, sys_getrlimit)
+#define __NR_setrlimit __LINE__
+__SYSCALL(__NR_setrlimit, sys_setrlimit)
+#define __NR_getrusage __LINE__
+__SYSCALL(__NR_getrusage, sys_getrusage)
+#define __NR_umask __LINE__
+__SYSCALL(__NR_umask, sys_umask)
+#define __NR_prctl __LINE__
+__SYSCALL(__NR_prctl, sys_prctl)
+#define __NR_getcpu __LINE__
+__SYSCALL(__NR_getcpu, sys_getcpu)
+
+/* kernel/time.c */
+#define __NR_gettimeofday __LINE__
+__SYSCALL(__NR_gettimeofday, sys_gettimeofday)
+#define __NR_settimeofday __LINE__
+__SYSCALL(__NR_settimeofday, sys_settimeofday)
+#define __NR_adjtimex __LINE__
+__SYSCALL(__NR_adjtimex, sys_adjtimex)
+
+/* kernel/timer.c */
+#define __NR_getpid __LINE__
+__SYSCALL(__NR_getpid, sys_getpid)
+#define __NR_getppid __LINE__
+__SYSCALL(__NR_getppid, sys_getppid)
+#define __NR_getuid __LINE__
+__SYSCALL(__NR_getuid, sys_getuid)
+#define __NR_geteuid __LINE__
+__SYSCALL(__NR_geteuid, sys_geteuid)
+#define __NR_getgid __LINE__
+__SYSCALL(__NR_getgid, sys_getgid)
+#define __NR_getegid __LINE__
+__SYSCALL(__NR_getegid, sys_getegid)
+#define __NR_gettid __LINE__
+__SYSCALL(__NR_gettid, sys_gettid)
+#define __NR_sysinfo __LINE__
+__SYSCALL(__NR_sysinfo, sys_sysinfo)
+
+/* ipc/mqueue.c */
+#define __NR_mq_open __LINE__
+__SYSCALL(__NR_mq_open, sys_mq_open)
+#define __NR_mq_unlink __LINE__
+__SYSCALL(__NR_mq_unlink, sys_mq_unlink)
+#define __NR_mq_timedsend __LINE__
+__SYSCALL(__NR_mq_timedsend, sys_mq_timedsend)
+#define __NR_mq_timedreceive __LINE__
+__SYSCALL(__NR_mq_timedreceive, sys_mq_timedreceive)
+#define __NR_mq_notify __LINE__
+__SYSCALL(__NR_mq_notify, sys_mq_notify)
+#define __NR_mq_getsetattr __LINE__
+__SYSCALL(__NR_mq_getsetattr, sys_mq_getsetattr)
+
+/* ipc/msg.c */
+#define __NR_msgget __LINE__
+__SYSCALL(__NR_msgget, sys_msgget)
+#define __NR_msgctl __LINE__
+__SYSCALL(__NR_msgctl, sys_msgctl)
+#define __NR_msgrcv __LINE__
+__SYSCALL(__NR_msgrcv, sys_msgrcv)
+#define __NR_msgsnd __LINE__
+__SYSCALL(__NR_msgsnd, sys_msgsnd)
+
+/* ipc/sem.c */
+#define __NR_semget __LINE__
+__SYSCALL(__NR_semget, sys_semget)
+#define __NR_semctl __LINE__
+__SYSCALL(__NR_semctl, sys_semctl)
+#define __NR_semtimedop __LINE__
+__SYSCALL(__NR_semtimedop, sys_semtimedop)
+#define __NR_semop __LINE__
+__SYSCALL(__NR_semop, sys_semop)
+
+/* ipc/shm.c */
+#define __NR_shmget __LINE__
+__SYSCALL(__NR_shmget, sys_shmget)
+#define __NR_shmctl __LINE__
+__SYSCALL(__NR_shmctl, sys_shmctl)
+#define __NR_shmat __LINE__
+__SYSCALL(__NR_shmat, sys_shmat)
+#define __NR_shmdt __LINE__
+__SYSCALL(__NR_shmdt, sys_shmdt)
+
+/* net/socket.c */
+#define __NR_socket __LINE__
+__SYSCALL(__NR_socket, sys_socket)
+#define __NR_socketpair __LINE__
+__SYSCALL(__NR_socketpair, sys_socketpair)
+#define __NR_bind __LINE__
+__SYSCALL(__NR_bind, sys_bind)
+#define __NR_listen __LINE__
+__SYSCALL(__NR_listen, sys_listen)
+#define __NR_accept __LINE__
+__SYSCALL(__NR_accept, sys_accept)
+#define __NR_connect __LINE__
+__SYSCALL(__NR_connect, sys_connect)
+#define __NR_getsockname __LINE__
+__SYSCALL(__NR_getsockname, sys_getsockname)
+#define __NR_getpeername __LINE__
+__SYSCALL(__NR_getpeername, sys_getpeername)
+#define __NR_sendto __LINE__
+__SYSCALL(__NR_sendto, sys_sendto)
+#define __NR_recvfrom __LINE__
+__SYSCALL(__NR_recvfrom, sys_recvfrom)
+#define __NR_setsockopt __LINE__
+__SYSCALL(__NR_setsockopt, sys_setsockopt)
+#define __NR_getsockopt __LINE__
+__SYSCALL(__NR_getsockopt, sys_getsockopt)
+#define __NR_shutdown __LINE__
+__SYSCALL(__NR_shutdown, sys_shutdown)
+#define __NR_sendmsg __LINE__
+__SYSCALL(__NR_sendmsg, sys_sendmsg)
+#define __NR_recvmsg __LINE__
+__SYSCALL(__NR_recvmsg, sys_recvmsg)
+
+/* mm/filemap.c */
+#define __NR_readahead __LINE__
+__SYSCALL(__NR_readahead, sys_readahead)
+
+/* mm/nommu.c, also with MMU */
+#define __NR_brk __LINE__
+__SYSCALL(__NR_brk, sys_brk)
+#define __NR_munmap __LINE__
+__SYSCALL(__NR_munmap, sys_munmap)
+#define __NR_mremap __LINE__
+__SYSCALL(__NR_mremap, sys_mremap)
+
+/* security/keys/keyctl.c */
+#define __NR_add_key __LINE__
+__SYSCALL(__NR_add_key, sys_add_key)
+#define __NR_request_key __LINE__
+__SYSCALL(__NR_request_key, sys_request_key)
+#define __NR_keyctl __LINE__
+__SYSCALL(__NR_keyctl, sys_keyctl)
+
+/* arch/example/kernel/sys_example.c */
+#define __NR_clone __LINE__
+__SYSCALL(__NR_clone, sys_clone)	/* .long sys_clone_wrapper */
+#define __NR_execve __LINE__
+__SYSCALL(__NR_execve, sys_execve)	/* .long sys_execve_wrapper */
+
+#define __NR3264_mmap __LINE__
+__SC_3264(__NR3264_mmap, sys_mmap2, sys_mmap)
+/* mm/fadvise.c */
+#define __NR3264_fadvise64 __LINE__
+__SC_3264(__NR3264_fadvise64, sys_fadvise64_64, sys_fadvise64)
+
+/* mm/, CONFIG_MMU only */
+#ifndef __ARCH_NOMMU
+#define __NR_swapon __LINE__
+__SYSCALL(__NR_swapon, sys_swapon)
+#define __NR_swapoff __LINE__
+__SYSCALL(__NR_swapoff, sys_swapoff)
+#define __NR_mprotect __LINE__
+__SYSCALL(__NR_mprotect, sys_mprotect)
+#define __NR_msync __LINE__
+__SYSCALL(__NR_msync, sys_msync)
+#define __NR_mlock __LINE__
+__SYSCALL(__NR_mlock, sys_mlock)
+#define __NR_munlock __LINE__
+__SYSCALL(__NR_munlock, sys_munlock)
+#define __NR_mlockall __LINE__
+__SYSCALL(__NR_mlockall, sys_mlockall)
+#define __NR_munlockall __LINE__
+__SYSCALL(__NR_munlockall, sys_munlockall)
+#define __NR_mincore __LINE__
+__SYSCALL(__NR_mincore, sys_mincore)
+#define __NR_madvise __LINE__
+__SYSCALL(__NR_madvise, sys_madvise)
+#define __NR_remap_file_pages __LINE__
+__SYSCALL(__NR_remap_file_pages, sys_remap_file_pages)
+#define __NR_mbind __LINE__
+__SYSCALL(__NR_mbind, sys_mbind)
+#define __NR_get_mempolicy __LINE__
+__SYSCALL(__NR_get_mempolicy, sys_get_mempolicy)
+#define __NR_set_mempolicy __LINE__
+__SYSCALL(__NR_set_mempolicy, sys_set_mempolicy)
+#define __NR_migrate_pages __LINE__
+__SYSCALL(__NR_migrate_pages, sys_migrate_pages)
+#define __NR_move_pages __LINE__
+__SYSCALL(__NR_move_pages, sys_move_pages)
+#endif
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
+#define __NR_open __LINE__
+__SYSCALL(__NR_open, sys_open)
+#define __NR_link __LINE__
+__SYSCALL(__NR_link, sys_link)
+#define __NR_unlink __LINE__
+__SYSCALL(__NR_unlink, sys_unlink)
+#define __NR_mknod __LINE__
+__SYSCALL(__NR_mknod, sys_mknod)
+#define __NR_chmod __LINE__
+__SYSCALL(__NR_chmod, sys_chmod)
+#define __NR_chown __LINE__
+__SYSCALL(__NR_chown, sys_chown)
+#define __NR_mkdir __LINE__
+__SYSCALL(__NR_mkdir, sys_mkdir)
+#define __NR_rmdir __LINE__
+__SYSCALL(__NR_rmdir, sys_rmdir)
+#define __NR_lchown __LINE__
+__SYSCALL(__NR_lchown, sys_lchown)
+#define __NR_access __LINE__
+__SYSCALL(__NR_access, sys_access)
+#define __NR_rename __LINE__
+__SYSCALL(__NR_rename, sys_rename)
+#define __NR_readlink __LINE__
+__SYSCALL(__NR_readlink, sys_readlink)
+#define __NR_symlink __LINE__
+__SYSCALL(__NR_symlink, sys_symlink)
+#define __NR_utimes __LINE__
+__SYSCALL(__NR_utimes, sys_utimes)
+#define __NR3264_stat __LINE__
+__SC_3264(__NR3264_stat, sys_stat64, sys_newstat)
+#define __NR3264_lstat __LINE__
+__SC_3264(__NR3264_lstat, sys_lstat64, sys_newlstat)
+#endif /* __ARCH_WANT_SYSCALL_NO_AT */
+
+#ifdef __ARCH_WANT_SYSCALL_NO_FLAGS
+#define __NR_pipe __LINE__
+__SYSCALL(__NR_pipe, sys_pipe)
+#define __NR_dup2 __LINE__
+__SYSCALL(__NR_dup2, sys_dup2)
+#define __NR_epoll_create __LINE__
+__SYSCALL(__NR_epoll_create, sys_epoll_create)
+#define __NR_inotify_init __LINE__
+__SYSCALL(__NR_inotify_init, sys_inotify_init)
+#define __NR_eventfd __LINE__
+__SYSCALL(__NR_eventfd, sys_eventfd)
+#define __NR_signalfd __LINE__
+__SYSCALL(__NR_signalfd, sys_signalfd)
+#endif /* __ARCH_WANT_SYSCALL_NO_FLAGS */
+
+#if __BITS_PER_LONG == 32 && defined(__ARCH_WANT_SYSCALL_OFF_T)
+#define __NR_sendfile __LINE__
+__SYSCALL(__NR_sendfile, sys_sendfile)
+#define __NR_ftruncate __LINE__
+__SYSCALL(__NR_ftruncate, sys_ftruncate)
+#define __NR_truncate __LINE__
+__SYSCALL(__NR_truncate, sys_truncate)
+#define __NR_stat __LINE__
+__SYSCALL(__NR_stat, sys_newstat)
+#define __NR_lstat __LINE__
+__SYSCALL(__NR_lstat, sys_newlstat)
+#define __NR_fstat __LINE__
+__SYSCALL(__NR_fstat, sys_newfstat)
+#define __NR_fcntl __LINE__
+__SYSCALL(__NR_fcntl, sys_fcntl)
+#define __NR_fadvise64 __LINE__
+#define __ARCH_WANT_SYS_FADVISE64
+__SYSCALL(__NR_fadvise64, sys_fadvise64)
+#define __NR_newfstatat __LINE__
+#define __ARCH_WANT_SYS_NEWFSTATAT
+__SYSCALL(__NR_newfstatat, sys_newfstatat)
+#define __NR_fstatfs __LINE__
+__SYSCALL(__NR_fstatfs, sys_fstatfs)
+#define __NR_statfs __LINE__
+__SYSCALL(__NR_statfs, sys_statfs)
+#define __NR_getdents __LINE__
+__SYSCALL(__NR_getdents, sys_getdents)
+#define __NR_lseek __LINE__
+__SYSCALL(__NR_lseek, sys_lseek)
+#define __NR_mmap __LINE__
+__SYSCALL(__NR_mmap, sys_mmap)
+#endif /* 32 bit off_t syscalls */
+
+#ifdef __ARCH_WANT_SYSCALL_DEPRECATED
+#define __NR_alarm __LINE__
+#define __ARCH_WANT_SYS_ALARM
+__SYSCALL(__NR_alarm, sys_alarm)
+#define __NR_getpgrp __LINE__
+#define __ARCH_WANT_SYS_GETPGRP
+__SYSCALL(__NR_getpgrp, sys_getpgrp)
+#define __NR_pause __LINE__
+#define __ARCH_WANT_SYS_PAUSE
+__SYSCALL(__NR_pause, sys_pause)
+#define __NR_time __LINE__
+#define __ARCH_WANT_SYS_TIME
+__SYSCALL(__NR_time, sys_time)
+#define __NR_utime __LINE__
+#define __ARCH_WANT_SYS_UTIME
+__SYSCALL(__NR_utime, sys_utime)
+
+#define __NR_creat __LINE__
+__SYSCALL(__NR_creat, sys_creat)
+#define __NR_futimesat __LINE__
+__SYSCALL(__NR_futimesat, sys_futimesat)
+#define __NR_poll __LINE__
+__SYSCALL(__NR_poll, sys_poll)
+#define __NR_select __LINE__
+__SYSCALL(__NR_select, sys_select)
+#define __NR_epoll_wait __LINE__
+__SYSCALL(__NR_epoll_wait, sys_epoll_wait)
+#define __NR_ustat __LINE__
+__SYSCALL(__NR_ustat, sys_ustat)
+#define __NR_vfork __LINE__
+__SYSCALL(__NR_vfork, sys_vfork)
+#define __NR_wait4 __LINE__
+__SYSCALL(__NR_wait4, sys_wait4)
+
+#define __NR_fork __LINE__
+#ifdef CONFIG_MMU
+__SYSCALL(__NR_fork, sys_fork)
+#else
+__SYSCALL(__NR_fork, sys_ni_syscall)
+#endif /* CONFIG_MMU */
+#endif /* __ARCH_WANT_SYSCALL_DEPRECATED */
+
+#define __NR_syscalls __LINE__
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
+#define __NR_getdents __NR3264_getdents
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
+#define __NR_getdents64 __NR3264_getdents
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
+#define __ARCH_WANT_SYS_LLSEEK
+#endif
+#define __ARCH_WANT_SYS_RT_SIGACTION
+#define __ARCH_WANT_SYS_RT_SIGSUSPEND
+
+/*
+ * "Conditional" syscalls
+ *
+ * What we want is __attribute__((weak,alias("sys_ni_syscall"))),
+ * but it doesn't work on all toolchains, so we just do it by hand
+ */
+#ifndef cond_syscall
+#define cond_syscall(x) asm(".weak\t" #x "\n\t.set\t" #x ",sys_ni_syscall")
+#endif
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_GENERIC_UNISTD_H */
diff --git a/kernel/Makefile b/kernel/Makefile
index e4791b3..717761b 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -93,6 +93,7 @@ obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
+obj-$(CONFIG_GENERIC_SYSCALL_TABLE) += syscall_table.o
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan-HpYC8cTCicIJY7gZg3T8ig@public.gmane.org>, the -fno-omit-frame-pointer is
diff --git a/kernel/syscall_table.c b/kernel/syscall_table.c
new file mode 100644
index 0000000..a2da111
--- /dev/null
+++ b/kernel/syscall_table.c
@@ -0,0 +1,12 @@
+#include <linux/syscalls.h>
+#include <linux/signal.h>
+#include <linux/unistd.h>
+
+#include <asm/syscalls.h>
+
+#undef __SYSCALL
+#define __SYSCALL(nr, call) [nr] (call),
+
+void *sys_call_table[] = {
+#include <asm/unistd.h>
+};
diff --git a/scripts/checksyscalls.sh b/scripts/checksyscalls.sh
index 60d00d1..28b9e3e 100755
--- a/scripts/checksyscalls.sh
+++ b/scripts/checksyscalls.sh
@@ -14,6 +14,57 @@ cat << EOF
 #include <asm/types.h>
 #include <asm/unistd.h>
 
+/* *at */
+#define __IGNORE_open		/* openat */
+#define __IGNORE_link		/* linkat */
+#define __IGNORE_unlink		/* unlinkat */
+#define __IGNORE_mknod		/* mknodat */
+#define __IGNORE_chmod		/* fchmodat */
+#define __IGNORE_chown		/* fchownat */
+#define __IGNORE_mkdir		/* mkdirat */
+#define __IGNORE_rmdir		/* unlinkat */
+#define __IGNORE_lchown		/* fchownat */
+#define __IGNORE_access		/* faccessat */
+#define __IGNORE_rename		/* renameat */
+#define __IGNORE_readlink	/* readlinkat */
+#define __IGNORE_symlink	/* symlinkat */
+#define __IGNORE_utimes		/* futimesat */
+#if BITS_PER_LONG == 64
+#define __IGNORE_stat		/* fstatat */
+#define __IGNORE_lstat		/* fstatat */
+#else
+#define __IGNORE_stat64		/* fstatat64 */
+#define __IGNORE_lstat64	/* fstatat64 */
+#endif
+
+/* CLOEXEC flag */
+#define __IGNORE_pipe		/* pipe2 */
+#define __IGNORE_dup2		/* dup3 */
+#define __IGNORE_epoll_create	/* epoll_create1 */
+#define __IGNORE_inotify_init	/* inotify_init1 */
+#define __IGNORE_eventfd	/* eventfd2 */
+#define __IGNORE_signalfd	/* signalfd4 */
+
+/* MMU */
+#ifndef CONFIG_MMU
+#define __IGNORE_madvise
+#define __IGNORE_mbind
+#define __IGNORE_mincore
+#define __IGNORE_mlock
+#define __IGNORE_mlockall
+#define __IGNORE_munlock
+#define __IGNORE_munlockall
+#define __IGNORE_mprotect
+#define __IGNORE_msync
+#define __IGNORE_migrate_pages
+#define __IGNORE_move_pages
+#define __IGNORE_remap_file_pages
+#define __IGNORE_get_mempolicy
+#define __IGNORE_set_mempolicy
+#define __IGNORE_swapoff
+#define __IGNORE_swapon
+#endif
+
 /* System calls for 32-bit kernels only */
 #if BITS_PER_LONG == 64
 #define __IGNORE_sendfile64
@@ -27,6 +78,24 @@ cat << EOF
 #define __IGNORE_fstatat64
 #define __IGNORE_fstatfs64
 #define __IGNORE_statfs64
+#define __IGNORE_getdents64
+#define __IGNORE_llseek
+#define __IGNORE_mmap2
+#else
+#define __IGNORE_sendfile
+#define __IGNORE_ftruncate
+#define __IGNORE_truncate
+#define __IGNORE_stat
+#define __IGNORE_lstat
+#define __IGNORE_fstat
+#define __IGNORE_fcntl
+#define __IGNORE_fadvise64
+#define __IGNORE_newfstatat
+#define __IGNORE_fstatfs
+#define __IGNORE_statfs
+#define __IGNORE_getdents
+#define __IGNORE_lseek
+#define __IGNORE_mmap
 #endif
 
 /* i386-specific or historical system calls */
@@ -44,7 +113,6 @@ cat << EOF
 #define __IGNORE_idle
 #define __IGNORE_modify_ldt
 #define __IGNORE_ugetrlimit
-#define __IGNORE_mmap2
 #define __IGNORE_vm86
 #define __IGNORE_vm86old
 #define __IGNORE_set_thread_area
@@ -55,7 +123,6 @@ cat << EOF
 #define __IGNORE_oldlstat
 #define __IGNORE_oldolduname
 #define __IGNORE_olduname
-#define __IGNORE_umount2
 #define __IGNORE_umount
 #define __IGNORE_waitpid
 #define __IGNORE_stime
@@ -75,9 +142,12 @@ cat << EOF
 #define __IGNORE__llseek
 #define __IGNORE__newselect
 #define __IGNORE_create_module
-#define __IGNORE_delete_module
 #define __IGNORE_query_module
 #define __IGNORE_get_kernel_syms
+#define __IGNORE_sysfs
+#define __IGNORE_uselib
+#define __IGNORE__sysctl
+
 /* ... including the "new" 32-bit uid syscalls */
 #define __IGNORE_lchown32
 #define __IGNORE_getuid32
@@ -99,6 +169,23 @@ cat << EOF
 #define __IGNORE_setfsuid32
 #define __IGNORE_setfsgid32
 
+/* these can be expressed using other calls */
+#define __IGNORE_alarm		/* setitimer */
+#define __IGNORE_creat		/* open */
+#define __IGNORE_fork		/* clone */
+#define __IGNORE_futimesat	/* utimensat */
+#define __IGNORE_getpgrp	/* getpgid */
+#define __IGNORE_pause		/* sigsuspend */
+#define __IGNORE_poll		/* ppoll */
+#define __IGNORE_select		/* pselect6 */
+#define __IGNORE_epoll_wait	/* epoll_pwait */
+#define __IGNORE_time		/* gettimeofday */
+#define __IGNORE_uname		/* newuname */
+#define __IGNORE_ustat		/* statfs */
+#define __IGNORE_utime		/* utimes */
+#define __IGNORE_vfork		/* clone */
+#define __IGNORE_wait4		/* waitid */
+
 /* sync_file_range had a stupid ABI. Allow sync_file_range2 instead */
 #ifdef __NR_sync_file_range2
 #define __IGNORE_sync_file_range
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
