From: akpm@linux-foundation.org
Subject: + preadv-pwritev-add-preadv-and-pwritev-system-calls.patch added to -mm tree
Date: Mon, 02 Feb 2009 13:35:36 -0800
Message-ID: <200902022135.n12LZa1a010673@imap1.linux-foundation.org>
Return-path: <linux-arch-owner@vger.kernel.org>
Sender: linux-arch-owner@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kraxel@redhat.com, arnd@arndb.de, hpa@zytor.com, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, mingo@elte.hu, ralf@linux-mips.org, tglx@linutronix.de, viro@zeniv.linux.org.uk
List-Id: linux-api@vger.kernel.org


The patch titled
     preadv/pwritev: Add preadv and pwritev system calls.
has been added to the -mm tree.  Its filename is
     preadv-pwritev-add-preadv-and-pwritev-system-calls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: preadv/pwritev: Add preadv and pwritev system calls.
From: Gerd Hoffmann <kraxel@redhat.com>

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

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <linux-api@vger.kernel.org>
Cc: <linux-arch@vger.kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
@@ -826,4 +826,6 @@ ia32_sys_call_table:
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
@@ -1204,6 +1204,24 @@ compat_sys_readv(unsigned long fd, const
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
@@ -1241,6 +1259,24 @@ compat_sys_writev(unsigned long fd, cons
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
@@ -183,6 +183,12 @@ asmlinkage ssize_t compat_sys_readv(unsi
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

Patches currently in -mm which might be from kraxel@redhat.com are

linux-next.patch
preadv-pwritev-create-compat_readv.patch
preadv-pwritev-create-compat_writev.patch
preadv-pwritev-add-preadv-and-pwritev-system-calls.patch
preadv-pwritev-mips-add-preadv2-and-pwritev2-syscalls.patch
preadv-pwritev-switch-compat-readv-preadv-writev-pwritev-from-fget-to-fget_light.patch
