From: Milosz Tanski <milosz@adfin.com>
Subject: [PATCH v7 2/5] vfs: Define new syscalls preadv2,pwritev2
Date: Mon, 16 Mar 2015 14:27:12 -0400
Message-ID: <9ec42ddccc63044da8290bda93f798f86b869a7e.1426528417.git.milosz@adfin.com>
References: <cover.1426528417.git.milosz@adfin.com>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <cover.1426528417.git.milosz@adfin.com>
In-Reply-To: <cover.1426528417.git.milosz@adfin.com>
References: <cover.1426528417.git.milosz@adfin.com>
Sender: owner-linux-aio@kvack.org
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

New syscalls that take an flag argument. This change does not add any specific
flags.

Signed-off-by: Milosz Tanski <milosz@adfin.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/read_write.c                   | 172 ++++++++++++++++++++++++++++++--------
 include/linux/compat.h            |   6 ++
 include/linux/syscalls.h          |   6 ++
 include/uapi/asm-generic/unistd.h |   6 +-
 mm/filemap.c                      |   5 +-
 5 files changed, 156 insertions(+), 39 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index b53bb59..e91f46e 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -924,6 +924,8 @@ ssize_t vfs_readv(struct file *file, const struct iovec __user *vec,
 		return -EBADF;
 	if (!(file->f_mode & FMODE_CAN_READ))
 		return -EINVAL;
+	if (flags & ~0)
+		return -EINVAL;
 
 	return do_readv_writev(READ, file, vec, vlen, pos, flags);
 }
@@ -937,21 +939,23 @@ ssize_t vfs_writev(struct file *file, const struct iovec __user *vec,
 		return -EBADF;
 	if (!(file->f_mode & FMODE_CAN_WRITE))
 		return -EINVAL;
+	if (flags & ~0)
+		return -EINVAL;
 
 	return do_readv_writev(WRITE, file, vec, vlen, pos, flags);
 }
 
 EXPORT_SYMBOL(vfs_writev);
 
-SYSCALL_DEFINE3(readv, unsigned long, fd, const struct iovec __user *, vec,
-		unsigned long, vlen)
+static ssize_t do_readv(unsigned long fd, const struct iovec __user *vec,
+			unsigned long vlen, int flags)
 {
 	struct fd f = fdget_pos(fd);
 	ssize_t ret = -EBADF;
 
 	if (f.file) {
 		loff_t pos = file_pos_read(f.file);
-		ret = vfs_readv(f.file, vec, vlen, &pos, 0);
+		ret = vfs_readv(f.file, vec, vlen, &pos, flags);
 		if (ret >= 0)
 			file_pos_write(f.file, pos);
 		fdput_pos(f);
@@ -963,15 +967,15 @@ SYSCALL_DEFINE3(readv, unsigned long, fd, const struct iovec __user *, vec,
 	return ret;
 }
 
-SYSCALL_DEFINE3(writev, unsigned long, fd, const struct iovec __user *, vec,
-		unsigned long, vlen)
+static ssize_t do_writev(unsigned long fd, const struct iovec __user *vec,
+			 unsigned long vlen, int flags)
 {
 	struct fd f = fdget_pos(fd);
 	ssize_t ret = -EBADF;
 
 	if (f.file) {
 		loff_t pos = file_pos_read(f.file);
-		ret = vfs_writev(f.file, vec, vlen, &pos, 0);
+		ret = vfs_writev(f.file, vec, vlen, &pos, flags);
 		if (ret >= 0)
 			file_pos_write(f.file, pos);
 		fdput_pos(f);
@@ -989,10 +993,9 @@ static inline loff_t pos_from_hilo(unsigned long high, unsigned long low)
 	return (((loff_t)high << HALF_LONG_BITS) << HALF_LONG_BITS) | low;
 }
 
-SYSCALL_DEFINE5(preadv, unsigned long, fd, const struct iovec __user *, vec,
-		unsigned long, vlen, unsigned long, pos_l, unsigned long, pos_h)
+static ssize_t do_preadv(unsigned long fd, const struct iovec __user *vec,
+			 unsigned long vlen, loff_t pos, int flags)
 {
-	loff_t pos = pos_from_hilo(pos_h, pos_l);
 	struct fd f;
 	ssize_t ret = -EBADF;
 
@@ -1003,7 +1006,7 @@ SYSCALL_DEFINE5(preadv, unsigned long, fd, const struct iovec __user *, vec,
 	if (f.file) {
 		ret = -ESPIPE;
 		if (f.file->f_mode & FMODE_PREAD)
-			ret = vfs_readv(f.file, vec, vlen, &pos, 0);
+			ret = vfs_readv(f.file, vec, vlen, &pos, flags);
 		fdput(f);
 	}
 
@@ -1013,10 +1016,9 @@ SYSCALL_DEFINE5(preadv, unsigned long, fd, const struct iovec __user *, vec,
 	return ret;
 }
 
-SYSCALL_DEFINE5(pwritev, unsigned long, fd, const struct iovec __user *, vec,
-		unsigned long, vlen, unsigned long, pos_l, unsigned long, pos_h)
+static ssize_t do_pwritev(unsigned long fd, const struct iovec __user *vec,
+			  unsigned long vlen, loff_t pos, int flags)
 {
-	loff_t pos = pos_from_hilo(pos_h, pos_l);
 	struct fd f;
 	ssize_t ret = -EBADF;
 
@@ -1027,7 +1029,7 @@ SYSCALL_DEFINE5(pwritev, unsigned long, fd, const struct iovec __user *, vec,
 	if (f.file) {
 		ret = -ESPIPE;
 		if (f.file->f_mode & FMODE_PWRITE)
-			ret = vfs_writev(f.file, vec, vlen, &pos, 0);
+			ret = vfs_writev(f.file, vec, vlen, &pos, flags);
 		fdput(f);
 	}
 
@@ -1037,11 +1039,63 @@ SYSCALL_DEFINE5(pwritev, unsigned long, fd, const struct iovec __user *, vec,
 	return ret;
 }
 
+SYSCALL_DEFINE3(readv, unsigned long, fd, const struct iovec __user *, vec,
+		unsigned long, vlen)
+{
+	return do_readv(fd, vec, vlen, 0);
+}
+
+SYSCALL_DEFINE3(writev, unsigned long, fd, const struct iovec __user *, vec,
+		unsigned long, vlen)
+{
+	return do_writev(fd, vec, vlen, 0);
+}
+
+SYSCALL_DEFINE5(preadv, unsigned long, fd, const struct iovec __user *, vec,
+		unsigned long, vlen, unsigned long, pos_l, unsigned long, pos_h)
+{
+	loff_t pos = pos_from_hilo(pos_h, pos_l);
+
+	return do_preadv(fd, vec, vlen, pos, 0);
+}
+
+SYSCALL_DEFINE6(preadv2, unsigned long, fd, const struct iovec __user *, vec,
+		unsigned long, vlen, unsigned long, pos_l, unsigned long, pos_h,
+		int, flags)
+{
+	loff_t pos = pos_from_hilo(pos_h, pos_l);
+
+	if (pos == -1)
+		return do_readv(fd, vec, vlen, flags);
+
+	return do_preadv(fd, vec, vlen, pos, flags);
+}
+
+SYSCALL_DEFINE5(pwritev, unsigned long, fd, const struct iovec __user *, vec,
+		unsigned long, vlen, unsigned long, pos_l, unsigned long, pos_h)
+{
+	loff_t pos = pos_from_hilo(pos_h, pos_l);
+
+	return do_pwritev(fd, vec, vlen, pos, 0);
+}
+
+SYSCALL_DEFINE6(pwritev2, unsigned long, fd, const struct iovec __user *, vec,
+		unsigned long, vlen, unsigned long, pos_l, unsigned long, pos_h,
+		int, flags)
+{
+	loff_t pos = pos_from_hilo(pos_h, pos_l);
+
+	if (pos == -1)
+		return do_writev(fd, vec, vlen, flags);
+
+	return do_pwritev(fd, vec, vlen, pos, flags);
+}
+
 #ifdef CONFIG_COMPAT
 
 static ssize_t compat_do_readv_writev(int type, struct file *file,
 			       const struct compat_iovec __user *uvector,
-			       unsigned long nr_segs, loff_t *pos)
+			       unsigned long nr_segs, loff_t *pos, int flags)
 {
 	compat_ssize_t tot_len;
 	struct iovec iovstack[UIO_FASTIOV];
@@ -1075,7 +1129,7 @@ static ssize_t compat_do_readv_writev(int type, struct file *file,
 
 	if (iter_fn)
 		ret = do_iter_readv_writev(file, type, iov, nr_segs, tot_len,
-						pos, iter_fn, 0);
+						pos, iter_fn, flags);
 	else if (fnv)
 		ret = do_sync_readv_writev(file, iov, nr_segs, tot_len,
 						pos, fnv);
@@ -1099,7 +1153,7 @@ out:
 
 static size_t compat_readv(struct file *file,
 			   const struct compat_iovec __user *vec,
-			   unsigned long vlen, loff_t *pos)
+			   unsigned long vlen, loff_t *pos, int flags)
 {
 	ssize_t ret = -EBADF;
 
@@ -1109,8 +1163,10 @@ static size_t compat_readv(struct file *file,
 	ret = -EINVAL;
 	if (!(file->f_mode & FMODE_CAN_READ))
 		goto out;
+	if (flags & ~0)
+		goto out;
 
-	ret = compat_do_readv_writev(READ, file, vec, vlen, pos);
+	ret = compat_do_readv_writev(READ, file, vec, vlen, pos, flags);
 
 out:
 	if (ret > 0)
@@ -1119,9 +1175,9 @@ out:
 	return ret;
 }
 
-COMPAT_SYSCALL_DEFINE3(readv, compat_ulong_t, fd,
-		const struct compat_iovec __user *,vec,
-		compat_ulong_t, vlen)
+static size_t __compat_sys_readv(compat_ulong_t fd,
+				 const struct compat_iovec __user *vec,
+				 compat_ulong_t vlen, int flags)
 {
 	struct fd f = fdget_pos(fd);
 	ssize_t ret;
@@ -1130,16 +1186,24 @@ COMPAT_SYSCALL_DEFINE3(readv, compat_ulong_t, fd,
 	if (!f.file)
 		return -EBADF;
 	pos = f.file->f_pos;
-	ret = compat_readv(f.file, vec, vlen, &pos);
+	ret = compat_readv(f.file, vec, vlen, &pos, flags);
 	if (ret >= 0)
 		f.file->f_pos = pos;
 	fdput_pos(f);
 	return ret;
+
+}
+
+COMPAT_SYSCALL_DEFINE3(readv, compat_ulong_t, fd,
+		const struct compat_iovec __user *,vec,
+		compat_ulong_t, vlen)
+{
+	return __compat_sys_readv(fd, vec, vlen, 0);
 }
 
 static long __compat_sys_preadv64(unsigned long fd,
 				  const struct compat_iovec __user *vec,
-				  unsigned long vlen, loff_t pos)
+				  unsigned long vlen, loff_t pos, int flags)
 {
 	struct fd f;
 	ssize_t ret;
@@ -1151,7 +1215,7 @@ static long __compat_sys_preadv64(unsigned long fd,
 		return -EBADF;
 	ret = -ESPIPE;
 	if (f.file->f_mode & FMODE_PREAD)
-		ret = compat_readv(f.file, vec, vlen, &pos);
+		ret = compat_readv(f.file, vec, vlen, &pos, flags);
 	fdput(f);
 	return ret;
 }
@@ -1161,7 +1225,7 @@ COMPAT_SYSCALL_DEFINE4(preadv64, unsigned long, fd,
 		const struct compat_iovec __user *,vec,
 		unsigned long, vlen, loff_t, pos)
 {
-	return __compat_sys_preadv64(fd, vec, vlen, pos);
+	return __compat_sys_preadv64(fd, vec, vlen, pos, 0);
 }
 #endif
 
@@ -1171,12 +1235,25 @@ COMPAT_SYSCALL_DEFINE5(preadv, compat_ulong_t, fd,
 {
 	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
 
-	return __compat_sys_preadv64(fd, vec, vlen, pos);
+	return __compat_sys_preadv64(fd, vec, vlen, pos, 0);
+}
+
+COMPAT_SYSCALL_DEFINE6(preadv2, compat_ulong_t, fd,
+		const struct compat_iovec __user *,vec,
+		compat_ulong_t, vlen, u32, pos_low, u32, pos_high,
+		int, flags)
+{
+	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
+
+	if (pos == -1)
+		return __compat_sys_readv(fd, vec, vlen, flags);
+
+	return __compat_sys_preadv64(fd, vec, vlen, pos, flags);
 }
 
 static size_t compat_writev(struct file *file,
 			    const struct compat_iovec __user *vec,
-			    unsigned long vlen, loff_t *pos)
+			    unsigned long vlen, loff_t *pos, int flags)
 {
 	ssize_t ret = -EBADF;
 
@@ -1186,8 +1263,10 @@ static size_t compat_writev(struct file *file,
 	ret = -EINVAL;
 	if (!(file->f_mode & FMODE_CAN_WRITE))
 		goto out;
+	if (flags & ~0)
+		goto out;
 
-	ret = compat_do_readv_writev(WRITE, file, vec, vlen, pos);
+	ret = compat_do_readv_writev(WRITE, file, vec, vlen, pos, flags);
 
 out:
 	if (ret > 0)
@@ -1196,9 +1275,9 @@ out:
 	return ret;
 }
 
-COMPAT_SYSCALL_DEFINE3(writev, compat_ulong_t, fd,
-		const struct compat_iovec __user *, vec,
-		compat_ulong_t, vlen)
+static size_t __compat_sys_writev(compat_ulong_t fd,
+				  const struct compat_iovec __user* vec,
+				  compat_ulong_t vlen, int flags)
 {
 	struct fd f = fdget_pos(fd);
 	ssize_t ret;
@@ -1207,28 +1286,36 @@ COMPAT_SYSCALL_DEFINE3(writev, compat_ulong_t, fd,
 	if (!f.file)
 		return -EBADF;
 	pos = f.file->f_pos;
-	ret = compat_writev(f.file, vec, vlen, &pos);
+	ret = compat_writev(f.file, vec, vlen, &pos, flags);
 	if (ret >= 0)
 		f.file->f_pos = pos;
 	fdput_pos(f);
 	return ret;
 }
 
+COMPAT_SYSCALL_DEFINE3(writev, compat_ulong_t, fd,
+		const struct compat_iovec __user *, vec,
+		compat_ulong_t, vlen)
+{
+	return __compat_sys_writev(fd, vec, vlen, 0);
+}
+
 static long __compat_sys_pwritev64(unsigned long fd,
 				   const struct compat_iovec __user *vec,
-				   unsigned long vlen, loff_t pos)
+				   unsigned long vlen, loff_t pos, int flags)
 {
 	struct fd f;
 	ssize_t ret;
 
 	if (pos < 0)
 		return -EINVAL;
+
 	f = fdget(fd);
 	if (!f.file)
 		return -EBADF;
 	ret = -ESPIPE;
 	if (f.file->f_mode & FMODE_PWRITE)
-		ret = compat_writev(f.file, vec, vlen, &pos);
+		ret = compat_writev(f.file, vec, vlen, &pos, flags);
 	fdput(f);
 	return ret;
 }
@@ -1238,7 +1325,7 @@ COMPAT_SYSCALL_DEFINE4(pwritev64, unsigned long, fd,
 		const struct compat_iovec __user *,vec,
 		unsigned long, vlen, loff_t, pos)
 {
-	return __compat_sys_pwritev64(fd, vec, vlen, pos);
+	return __compat_sys_pwritev64(fd, vec, vlen, pos, 0);
 }
 #endif
 
@@ -1248,8 +1335,21 @@ COMPAT_SYSCALL_DEFINE5(pwritev, compat_ulong_t, fd,
 {
 	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
 
-	return __compat_sys_pwritev64(fd, vec, vlen, pos);
+	return __compat_sys_pwritev64(fd, vec, vlen, pos, 0);
+}
+
+COMPAT_SYSCALL_DEFINE6(pwritev2, compat_ulong_t, fd,
+		const struct compat_iovec __user *,vec,
+		compat_ulong_t, vlen, u32, pos_low, u32, pos_high, int, flags)
+{
+	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
+
+	if (pos == -1)
+		return __compat_sys_writev(fd, vec, vlen, flags);
+
+	return __compat_sys_pwritev64(fd, vec, vlen, pos, flags);
 }
+
 #endif
 
 static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
diff --git a/include/linux/compat.h b/include/linux/compat.h
index ab25814..6e4be9e 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -340,6 +340,12 @@ asmlinkage ssize_t compat_sys_preadv(compat_ulong_t fd,
 asmlinkage ssize_t compat_sys_pwritev(compat_ulong_t fd,
 		const struct compat_iovec __user *vec,
 		compat_ulong_t vlen, u32 pos_low, u32 pos_high);
+asmlinkage ssize_t compat_sys_preadv2(compat_ulong_t fd,
+		const struct compat_iovec __user *vec,
+		compat_ulong_t vlen, u32 pos_low, u32 pos_high, int flags);
+asmlinkage ssize_t compat_sys_pwritev2(compat_ulong_t fd,
+		const struct compat_iovec __user *vec,
+		compat_ulong_t vlen, u32 pos_low, u32 pos_high, int flags);
 
 #ifdef __ARCH_WANT_COMPAT_SYS_PREADV64
 asmlinkage long compat_sys_preadv64(unsigned long fd,
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 76d1e38..f25ed7b 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -575,8 +575,14 @@ asmlinkage long sys_pwrite64(unsigned int fd, const char __user *buf,
 			     size_t count, loff_t pos);
 asmlinkage long sys_preadv(unsigned long fd, const struct iovec __user *vec,
 			   unsigned long vlen, unsigned long pos_l, unsigned long pos_h);
+asmlinkage long sys_preadv2(unsigned long fd, const struct iovec __user *vec,
+			    unsigned long vlen, unsigned long pos_l, unsigned long pos_h,
+			    int flags);
 asmlinkage long sys_pwritev(unsigned long fd, const struct iovec __user *vec,
 			    unsigned long vlen, unsigned long pos_l, unsigned long pos_h);
+asmlinkage long sys_pwritev2(unsigned long fd, const struct iovec __user *vec,
+			    unsigned long vlen, unsigned long pos_l, unsigned long pos_h,
+			    int flags);
 asmlinkage long sys_getcwd(char __user *buf, unsigned long size);
 asmlinkage long sys_mkdir(const char __user *pathname, umode_t mode);
 asmlinkage long sys_chdir(const char __user *filename);
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index e016bd9..4d2c4c5 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -213,6 +213,10 @@ __SC_COMP(__NR_pwrite64, sys_pwrite64, compat_sys_pwrite64)
 __SC_COMP(__NR_preadv, sys_preadv, compat_sys_preadv)
 #define __NR_pwritev 70
 __SC_COMP(__NR_pwritev, sys_pwritev, compat_sys_pwritev)
+#define __NR_preadv2 282
+__SC_COMP(__NR_preadv2, sys_preadv2, compat_sys_preadv2)
+#define __NR_pwritev2 283
+__SC_COMP(__NR_pwritev2, sys_pwritev2, compat_sys_pwritev2)
 
 /* fs/sendfile.c */
 #define __NR3264_sendfile 71
@@ -711,7 +715,7 @@ __SYSCALL(__NR_bpf, sys_bpf)
 __SC_COMP(__NR_execveat, sys_execveat, compat_sys_execveat)
 
 #undef __NR_syscalls
-#define __NR_syscalls 282
+#define __NR_syscalls 284
 
 /*
  * All syscalls below here should go away really,
diff --git a/mm/filemap.c b/mm/filemap.c
index ad72420..7865f64 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1453,6 +1453,7 @@ static void shrink_readahead_size_eio(struct file *filp,
  * @ppos:	current file position
  * @iter:	data destination
  * @written:	already copied
+ * @flags:	optional flags
  *
  * This is a generic file read routine, and uses the
  * mapping->a_ops->readpage() function for the actual low-level stuff.
@@ -1461,7 +1462,7 @@ static void shrink_readahead_size_eio(struct file *filp,
  * of the logic when it comes to error handling etc.
  */
 static ssize_t do_generic_file_read(struct file *filp, loff_t *ppos,
-		struct iov_iter *iter, ssize_t written)
+		struct iov_iter *iter, ssize_t written, int flags)
 {
 	struct address_space *mapping = filp->f_mapping;
 	struct inode *inode = mapping->host;
@@ -1732,7 +1733,7 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 		}
 	}
 
-	retval = do_generic_file_read(file, ppos, iter, retval);
+	retval = do_generic_file_read(file, ppos, iter, retval, iocb->ki_rwflags);
 out:
 	return retval;
 }
-- 
1.9.1

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
