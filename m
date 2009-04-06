From: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Subject: [merged] preadv-pwritev-add-preadv-and-pwritev-system-calls.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:37:59 -0700
Message-ID: <200904061937.n36JbxWg013191@imap1.linux-foundation.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
List-Id: linux-api@vger.kernel.org


The patch titled
     preadv/pwritev: Add preadv and pwritev system calls.
has been removed from the -mm tree.  Its filename was
     preadv-pwritev-add-preadv-and-pwritev-system-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: preadv/pwritev: Add preadv and pwritev system calls.
From: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

This patch adds preadv and pwritev system calls.  These syscalls are a
pretty straightforward combination of pread and readv (same for write). 
They are quite useful for doing vectored I/O in threaded applications. 
Using lseek+readv instead opens race windows you'll have to plug with
locking.

Other systems have such system calls too, for example NetBSD, check
here: http://www.daemon-systems.org/man/preadv.2.html

The application-visible interface provided by glibc should look like
this to be compatible to the existing implementations in the *BSD family:

  ssize_t preadv(int d, const struct iovec *iov, int iovcnt, off_t offset);
  ssize_t pwritev(int d, const struct iovec *iov, int iovcnt, off_t offset);

This prototype has one problem though: On 32bit archs is the (64bit)
offset argument unaligned, which the syscall ABI of several archs doesn't
allow to do.  At least s390 needs a wrapper in glibc to handle this.  As
we'll need a wrappers in glibc anyway I've decided to push problem to
glibc entriely and use a syscall prototype which works without
arch-specific wrappers inside the kernel: The offset argument is
explicitly splitted into two 32bit values.

The patch sports the actual system call implementation and the windup in
the x86 system call tables.  Other archs follow as separate patches.

Signed-off-by: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>
Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
---

 arch/x86/ia32/ia32entry.S          |    2 +
 arch/x86/include/asm/unistd_32.h   |    2 +
 arch/x86/include/asm/unistd_64.h   |    4 ++
 arch/x86/kernel/syscall_table_32.S |    2 +
 fs/compat.c                        |   36 +++++++++++++++++++
 fs/read_write.c                    |   50 +++++++++++++++++++++++++++
 include/linux/compat.h             |    6 +++
 include/linux/syscalls.h           |    4 ++
 8 files changed, 106 insertions(+)

diff -puN arch/x86/ia32/ia32entry.S~preadv-pwritev-add-preadv-and-pwritev-system-calls arch/x86/ia32/ia32entry.S
--- a/arch/x86/ia32/ia32entry.S~preadv-pwritev-add-preadv-and-pwritev-system-calls
+++ a/arch/x86/ia32/ia32entry.S
@@ -828,4 +828,6 @@ ia32_sys_call_table:
 	.quad sys_dup3			/* 330 */
 	.quad sys_pipe2
 	.quad sys_inotify_init1
+	.quad compat_sys_preadv
+	.quad compat_sys_pwritev
 ia32_syscall_end:
diff -puN arch/x86/include/asm/unistd_32.h~preadv-pwritev-add-preadv-and-pwritev-system-calls arch/x86/include/asm/unistd_32.h
--- a/arch/x86/include/asm/unistd_32.h~preadv-pwritev-add-preadv-and-pwritev-system-calls
+++ a/arch/x86/include/asm/unistd_32.h
@@ -338,6 +338,8 @@
 #define __NR_dup3		330
 #define __NR_pipe2		331
 #define __NR_inotify_init1	332
+#define __NR_preadv		333
+#define __NR_pwritev		334
 
 #ifdef __KERNEL__
 
diff -puN arch/x86/include/asm/unistd_64.h~preadv-pwritev-add-preadv-and-pwritev-system-calls arch/x86/include/asm/unistd_64.h
--- a/arch/x86/include/asm/unistd_64.h~preadv-pwritev-add-preadv-and-pwritev-system-calls
+++ a/arch/x86/include/asm/unistd_64.h
@@ -653,6 +653,10 @@ __SYSCALL(__NR_dup3, sys_dup3)
 __SYSCALL(__NR_pipe2, sys_pipe2)
 #define __NR_inotify_init1			294
 __SYSCALL(__NR_inotify_init1, sys_inotify_init1)
+#define __NR_preadv				295
+__SYSCALL(__NR_preadv, sys_preadv)
+#define __NR_pwritev				296
+__SYSCALL(__NR_pwritev, sys_pwritev)
 
 
 #ifndef __NO_STUBS
diff -puN arch/x86/kernel/syscall_table_32.S~preadv-pwritev-add-preadv-and-pwritev-system-calls arch/x86/kernel/syscall_table_32.S
--- a/arch/x86/kernel/syscall_table_32.S~preadv-pwritev-add-preadv-and-pwritev-system-calls
+++ a/arch/x86/kernel/syscall_table_32.S
@@ -332,3 +332,5 @@ ENTRY(sys_call_table)
 	.long sys_dup3			/* 330 */
 	.long sys_pipe2
 	.long sys_inotify_init1
+	.long sys_preadv
+	.long sys_pwritev
diff -puN fs/compat.c~preadv-pwritev-add-preadv-and-pwritev-system-calls fs/compat.c
--- a/fs/compat.c~preadv-pwritev-add-preadv-and-pwritev-system-calls
+++ a/fs/compat.c
@@ -1232,6 +1232,24 @@ compat_sys_readv(unsigned long fd, const
 	return ret;
 }
 
+asmlinkage ssize_t
+compat_sys_preadv(unsigned long fd, const struct compat_iovec __user *vec,
+		  unsigned long vlen, u32 pos_high, u32 pos_low)
+{
+	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
+	struct file *file;
+	ssize_t ret;
+
+	if (pos < 0)
+		return -EINVAL;
+	file = fget(fd);
+	if (!file)
+		return -EBADF;
+	ret = compat_readv(file, vec, vlen, &pos);
+	fput(file);
+	return ret;
+}
+
 static size_t compat_writev(struct file *file,
 			    const struct compat_iovec __user *vec,
 			    unsigned long vlen, loff_t *pos)
@@ -1269,6 +1287,24 @@ compat_sys_writev(unsigned long fd, cons
 	return ret;
 }
 
+asmlinkage ssize_t
+compat_sys_pwritev(unsigned long fd, const struct compat_iovec __user *vec,
+		   unsigned long vlen, u32 pos_high, u32 pos_low)
+{
+	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
+	struct file *file;
+	ssize_t ret;
+
+	if (pos < 0)
+		return -EINVAL;
+	file = fget(fd);
+	if (!file)
+		return -EBADF;
+	ret = compat_writev(file, vec, vlen, &pos);
+	fput(file);
+	return ret;
+}
+
 asmlinkage long
 compat_sys_vmsplice(int fd, const struct compat_iovec __user *iov32,
 		    unsigned int nr_segs, unsigned int flags)
diff -puN fs/read_write.c~preadv-pwritev-add-preadv-and-pwritev-system-calls fs/read_write.c
--- a/fs/read_write.c~preadv-pwritev-add-preadv-and-pwritev-system-calls
+++ a/fs/read_write.c
@@ -731,6 +731,56 @@ SYSCALL_DEFINE3(writev, unsigned long, f
 	return ret;
 }
 
+SYSCALL_DEFINE5(preadv, unsigned long, fd, const struct iovec __user *, vec,
+		unsigned long, vlen, u32, pos_high, u32, pos_low)
+{
+	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
+	struct file *file;
+	ssize_t ret = -EBADF;
+	int fput_needed;
+
+	if (pos < 0)
+		return -EINVAL;
+
+	file = fget_light(fd, &fput_needed);
+	if (file) {
+		ret = -ESPIPE;
+		if (file->f_mode & FMODE_PREAD)
+			ret = vfs_readv(file, vec, vlen, &pos);
+		fput_light(file, fput_needed);
+	}
+
+	if (ret > 0)
+		add_rchar(current, ret);
+	inc_syscr(current);
+	return ret;
+}
+
+SYSCALL_DEFINE5(pwritev, unsigned long, fd, const struct iovec __user *, vec,
+		unsigned long, vlen, u32, pos_high, u32, pos_low)
+{
+	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
+	struct file *file;
+	ssize_t ret = -EBADF;
+	int fput_needed;
+
+	if (pos < 0)
+		return -EINVAL;
+
+	file = fget_light(fd, &fput_needed);
+	if (file) {
+		ret = -ESPIPE;
+		if (file->f_mode & FMODE_PWRITE)
+			ret = vfs_writev(file, vec, vlen, &pos);
+		fput_light(file, fput_needed);
+	}
+
+	if (ret > 0)
+		add_wchar(current, ret);
+	inc_syscw(current);
+	return ret;
+}
+
 static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
 			   size_t count, loff_t max)
 {
diff -puN include/linux/compat.h~preadv-pwritev-add-preadv-and-pwritev-system-calls include/linux/compat.h
--- a/include/linux/compat.h~preadv-pwritev-add-preadv-and-pwritev-system-calls
+++ a/include/linux/compat.h
@@ -191,6 +191,12 @@ asmlinkage ssize_t compat_sys_readv(unsi
 		const struct compat_iovec __user *vec, unsigned long vlen);
 asmlinkage ssize_t compat_sys_writev(unsigned long fd,
 		const struct compat_iovec __user *vec, unsigned long vlen);
+asmlinkage ssize_t compat_sys_preadv(unsigned long fd,
+		const struct compat_iovec __user *vec,
+		unsigned long vlen, u32 pos_high, u32 pos_low);
+asmlinkage ssize_t compat_sys_pwritev(unsigned long fd,
+		const struct compat_iovec __user *vec,
+		unsigned long vlen, u32 pos_high, u32 pos_low);
 
 int compat_do_execve(char * filename, compat_uptr_t __user *argv,
 	        compat_uptr_t __user *envp, struct pt_regs * regs);
diff -puN include/linux/syscalls.h~preadv-pwritev-add-preadv-and-pwritev-system-calls include/linux/syscalls.h
--- a/include/linux/syscalls.h~preadv-pwritev-add-preadv-and-pwritev-system-calls
+++ a/include/linux/syscalls.h
@@ -461,6 +461,10 @@ asmlinkage long sys_pread64(unsigned int
 			    size_t count, loff_t pos);
 asmlinkage long sys_pwrite64(unsigned int fd, const char __user *buf,
 			     size_t count, loff_t pos);
+asmlinkage long sys_preadv(unsigned long fd, const struct iovec __user *vec,
+			   unsigned long vlen, u32 pos_high, u32 pos_low);
+asmlinkage long sys_pwritev(unsigned long fd, const struct iovec __user *vec,
+			    unsigned long vlen, u32 pos_high, u32 pos_low);
 asmlinkage long sys_getcwd(char __user *buf, unsigned long size);
 asmlinkage long sys_mkdir(const char __user *pathname, int mode);
 asmlinkage long sys_chdir(const char __user *filename);
_

Patches currently in -mm which might be from kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org are

origin.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
