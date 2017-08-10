From: Andrei Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] [RFC] vm: add a syscall to map a process memory into a pipe
Date: Thu, 10 Aug 2017 11:46:16 -0700
Message-ID: <20170810184616.22726-1-avagin@openvz.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Andrei Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

It is a hybrid of process_vm_readv() and vmsplice().

vmsplice can map memory from a current address space into a pipe.
process_vm_readv can read memory of another process.

A new system call can map memory of another process into a pipe.

ssize_t process_vmsplice(pid_t pid, int fd, const struct iovec *iov,
                        unsigned long nr_segs, unsigned int flags)

All arguments are identical with vmsplice except pid which specifies a
target process.

Currently if we want to dump a process memory to a file or to a socket,
we can use process_vm_readv() + write(), but it works slow, because data
are copied into a temporary user-space buffer.

A second way is to use vmsplice() + splice(). It is more effective,
because data are not copied into a temporary buffer, but here is another
problem. vmsplice works with the currect address space, so it can be
used only if we inject our code into a target process.

The second way suffers from a few other issues:
* a process has to be stopped to run a parasite code
* a number of pipes is limited, so it may be impossible to dump all
  memory in one iteration, and we have to stop process and inject our
  code a few times.
* pages in pipes are unreclaimable, so it isn't good to hold a lot of
  memory in pipes.

The introduced syscall allows to use a second way without injecting any
code into a target process.

My experiments shows that process_vmsplice() + splice() works two time
faster than process_vm_readv() + write().

It is particularly useful on a pre-dump stage. On this stage we enable a
memory tracker, and then we are dumping  a process memory while a
process continues work. On the first iteration we are dumping all
memory, and then we are dumpung only modified memory from a previous
iteration.  After a few pre-dump operations, a process is stopped and
dumped finally. The pre-dump operations allow to significantly decrease
a process downtime, when a process is migrated to another host.

Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Signed-off-by: Andrei Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 fs/splice.c                       | 219 ++++++++++++++++++++++++++++++++++++++
 include/linux/compat.h            |   3 +
 include/linux/syscalls.h          |   4 +
 include/uapi/asm-generic/unistd.h |   5 +-
 4 files changed, 230 insertions(+), 1 deletion(-)

diff --git a/fs/splice.c b/fs/splice.c
index ae41201..4b050a4 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -34,6 +34,7 @@
 #include <linux/socket.h>
 #include <linux/compat.h>
 #include <linux/sched/signal.h>
+#include <linux/sched/mm.h>
 
 #include "internal.h"
 
@@ -1374,6 +1375,201 @@ SYSCALL_DEFINE4(vmsplice, int, fd, const struct iovec __user *, iov,
 	return error;
 }
 
+/*
+ * Map pages from a specified task into a pipe
+ */
+static int remote_single_vec_to_pipe(struct task_struct *task,
+			struct mm_struct *mm,
+			const struct iovec *rvec,
+			struct pipe_inode_info *pipe,
+			unsigned int flags,
+			size_t *total)
+{
+	struct pipe_buffer buf = {
+		.ops = &user_page_pipe_buf_ops,
+		.flags = flags
+	};
+	unsigned long addr = (unsigned long) rvec->iov_base;
+	unsigned long pa = addr & PAGE_MASK;
+	unsigned long start_offset = addr - pa;
+	unsigned long nr_pages;
+	ssize_t len = rvec->iov_len;
+	struct page *process_pages[16];
+	bool failed = false;
+	int ret = 0;
+
+	nr_pages = (addr + len - 1) / PAGE_SIZE - addr / PAGE_SIZE + 1;
+	while (nr_pages) {
+		long pages = min(nr_pages, 16UL);
+		int locked = 1, n;
+		ssize_t copied;
+
+		/*
+		 * Get the pages we're interested in.  We must
+		 * access remotely because task/mm might not
+		 * current/current->mm
+		 */
+		down_read(&mm->mmap_sem);
+		pages = get_user_pages_remote(task, mm, pa, pages, flags,
+					      process_pages, NULL, &locked);
+		if (locked)
+			up_read(&mm->mmap_sem);
+		if (pages <= 0) {
+			failed = true;
+			ret = -EFAULT;
+			break;
+		}
+
+		copied = pages * PAGE_SIZE - start_offset;
+		if (copied > len)
+			copied = len;
+		len -= copied;
+
+		for (n = 0; copied; n++, start_offset = 0) {
+			int size = min_t(int, copied, PAGE_SIZE - start_offset);
+
+			if (!failed) {
+				buf.page = process_pages[n];
+				buf.offset = start_offset;
+				buf.len = size;
+				ret = add_to_pipe(pipe, &buf);
+				if (unlikely(ret < 0))
+					failed = true;
+				else
+					*total += ret;
+			} else {
+				put_page(process_pages[n]);
+			}
+			copied -= size;
+		}
+		if (failed)
+			break;
+		start_offset = 0;
+		nr_pages -= pages;
+		pa += pages * PAGE_SIZE;
+	}
+	return ret < 0 ? ret : 0;
+}
+
+static ssize_t remote_iovec_to_pipe(struct task_struct *task,
+			struct mm_struct *mm,
+			const struct iovec *rvec,
+			unsigned long riovcnt,
+			struct pipe_inode_info *pipe,
+			unsigned int flags)
+{
+	size_t total = 0;
+	int ret = 0, i;
+
+	for (i = 0; i < riovcnt; i++) {
+		/* Work out address and page range required */
+		if (rvec[i].iov_len == 0)
+			continue;
+
+		ret = remote_single_vec_to_pipe(
+				task, mm, &rvec[i], pipe, flags, &total);
+		if (ret < 0)
+			break;
+	}
+	return total ? total : ret;
+}
+
+static long process_vmsplice_to_pipe(struct task_struct *task,
+				struct mm_struct *mm, struct file *file,
+				const struct iovec __user *uiov,
+				unsigned long nr_segs, unsigned int flags)
+{
+	struct pipe_inode_info *pipe;
+	struct iovec iovstack[UIO_FASTIOV];
+	struct iovec *iov = iovstack;
+	unsigned int buf_flag = 0;
+	long ret;
+
+	if (flags & SPLICE_F_GIFT)
+		buf_flag = PIPE_BUF_FLAG_GIFT;
+
+	pipe = get_pipe_info(file);
+	if (!pipe)
+		return -EBADF;
+
+	ret = rw_copy_check_uvector(CHECK_IOVEC_ONLY, uiov, nr_segs,
+					UIO_FASTIOV, iovstack, &iov);
+	if (ret < 0)
+		return ret;
+
+	pipe_lock(pipe);
+	ret = wait_for_space(pipe, flags);
+	if (!ret)
+		ret = remote_iovec_to_pipe(task, mm, iov,
+						nr_segs, pipe, buf_flag);
+	pipe_unlock(pipe);
+	if (ret > 0)
+		wakeup_pipe_readers(pipe);
+
+	if (iov != iovstack)
+		kfree(iov);
+	return ret;
+}
+
+/* process_vmsplice splices a process address range into a pipe. */
+SYSCALL_DEFINE5(process_vmsplice, int, pid, int, fd,
+		const struct iovec __user *, iov,
+		unsigned long, nr_segs, unsigned int, flags)
+{
+	struct task_struct *task;
+	struct mm_struct *mm;
+	struct fd f;
+	long ret;
+
+	if (unlikely(flags & ~SPLICE_F_ALL))
+		return -EINVAL;
+	if (unlikely(nr_segs > UIO_MAXIOV))
+		return -EINVAL;
+	else if (unlikely(!nr_segs))
+		return 0;
+
+	f = fdget(fd);
+	if (!f.file)
+		return -EBADF;
+
+	/* Get process information */
+	rcu_read_lock();
+	task = find_task_by_vpid(pid);
+	if (task)
+		get_task_struct(task);
+	rcu_read_unlock();
+	if (!task) {
+		ret = -ESRCH;
+		goto out_fput;
+	}
+
+	mm = mm_access(task, PTRACE_MODE_ATTACH_REALCREDS);
+	if (!mm || IS_ERR(mm)) {
+		ret = IS_ERR(mm) ? PTR_ERR(mm) : -ESRCH;
+		/*
+		 * Explicitly map EACCES to EPERM as EPERM is a more a
+		 * appropriate error code for process_vw_readv/writev
+		 */
+		if (ret == -EACCES)
+			ret = -EPERM;
+		goto put_task_struct;
+	}
+
+	ret = -EBADF;
+	if (f.file->f_mode & FMODE_WRITE)
+		ret = process_vmsplice_to_pipe(task, mm, f.file,
+						iov, nr_segs, flags);
+	mmput(mm);
+
+put_task_struct:
+	put_task_struct(task);
+
+out_fput:
+	fdput(f);
+
+	return ret;
+}
+
 #ifdef CONFIG_COMPAT
 COMPAT_SYSCALL_DEFINE4(vmsplice, int, fd, const struct compat_iovec __user *, iov32,
 		    unsigned int, nr_segs, unsigned int, flags)
@@ -1393,6 +1589,29 @@ COMPAT_SYSCALL_DEFINE4(vmsplice, int, fd, const struct compat_iovec __user *, io
 	}
 	return sys_vmsplice(fd, iov, nr_segs, flags);
 }
+
+COMPAT_SYSCALL_DEFINE5(process_vmsplice, pid_t, pid, int, fd,
+			const struct compat_iovec __user *, iov32,
+			unsigned int, nr_segs, unsigned int, flags)
+{
+	struct iovec __user *iov;
+	unsigned int i;
+
+	if (nr_segs > UIO_MAXIOV)
+		return -EINVAL;
+
+	iov = compat_alloc_user_space(nr_segs * sizeof(struct iovec));
+	for (i = 0; i < nr_segs; i++) {
+		struct compat_iovec v;
+
+		if (get_user(v.iov_base, &iov32[i].iov_base) ||
+		    get_user(v.iov_len, &iov32[i].iov_len) ||
+		    put_user(compat_ptr(v.iov_base), &iov[i].iov_base) ||
+		    put_user(v.iov_len, &iov[i].iov_len))
+			return -EFAULT;
+	}
+	return sys_process_vmsplice(pid, fd, iov, nr_segs, flags);
+}
 #endif
 
 SYSCALL_DEFINE6(splice, int, fd_in, loff_t __user *, off_in,
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 5a6a109..3590cc7 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -550,6 +550,9 @@ asmlinkage long compat_sys_getdents(unsigned int fd,
 				    unsigned int count);
 asmlinkage long compat_sys_vmsplice(int fd, const struct compat_iovec __user *,
 				    unsigned int nr_segs, unsigned int flags);
+asmlinkage long compat_sys_process_vmsplice(pid_t pid, int fd,
+				    const struct compat_iovec __user *,
+				    unsigned int nr_segs, unsigned int flags);
 asmlinkage long compat_sys_open(const char __user *filename, int flags,
 				umode_t mode);
 asmlinkage long compat_sys_openat(int dfd, const char __user *filename,
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 3cb15ea..49bdf96 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -906,4 +906,8 @@ asmlinkage long sys_pkey_free(int pkey);
 asmlinkage long sys_statx(int dfd, const char __user *path, unsigned flags,
 			  unsigned mask, struct statx __user *buffer);
 
+asmlinkage long sys_process_vmsplice(pid_t pid,
+			int fd, const struct iovec __user *iov,
+			unsigned long nr_segs, unsigned int flags);
+
 #endif
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 061185a..d18019d 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -731,9 +731,12 @@ __SYSCALL(__NR_pkey_alloc,    sys_pkey_alloc)
 __SYSCALL(__NR_pkey_free,     sys_pkey_free)
 #define __NR_statx 291
 __SYSCALL(__NR_statx,     sys_statx)
+#define __NR_process_vmsplice 292
+__SC_COMP(__NR_process_vmsplice, sys_process_vmsplice,
+	  compat_sys_process_vmsplice)
 
 #undef __NR_syscalls
-#define __NR_syscalls 292
+#define __NR_syscalls 293
 
 /*
  * All syscalls below here should go away really,
-- 
2.9.4
