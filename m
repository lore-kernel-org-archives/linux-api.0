From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 2/7] vfs: vfs: Define new syscalls preadv2,pwritev2
Date: Mon, 22 Feb 2016 18:07:51 +0100
Message-ID: <1456160876-14560-3-git-send-email-hch@lst.de>
References: <1456160876-14560-1-git-send-email-hch@lst.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456160876-14560-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org
Cc: milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>

New syscalls that take an flag argument. This change does not add any
specific flags.

Signed-off-by: Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>
[hch: rebased on top of my kiocb changes]
Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/read_write.c          | 162 +++++++++++++++++++++++++++++++++++++----------
 include/linux/compat.h   |   6 ++
 include/linux/syscalls.h |   6 ++
 3 files changed, 139 insertions(+), 35 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 7d453c3..38b9afa 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -895,15 +895,15 @@ ssize_t vfs_writev(struct file *file, const struct iovec __user *vec,
 
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
@@ -915,15 +915,15 @@ SYSCALL_DEFINE3(readv, unsigned long, fd, const struct iovec __user *, vec,
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
@@ -941,10 +941,9 @@ static inline loff_t pos_from_hilo(unsigned long high, unsigned long low)
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
 
@@ -955,7 +954,7 @@ SYSCALL_DEFINE5(preadv, unsigned long, fd, const struct iovec __user *, vec,
 	if (f.file) {
 		ret = -ESPIPE;
 		if (f.file->f_mode & FMODE_PREAD)
-			ret = vfs_readv(f.file, vec, vlen, &pos, 0);
+			ret = vfs_readv(f.file, vec, vlen, &pos, flags);
 		fdput(f);
 	}
 
@@ -965,10 +964,9 @@ SYSCALL_DEFINE5(preadv, unsigned long, fd, const struct iovec __user *, vec,
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
 
@@ -979,7 +977,7 @@ SYSCALL_DEFINE5(pwritev, unsigned long, fd, const struct iovec __user *, vec,
 	if (f.file) {
 		ret = -ESPIPE;
 		if (f.file->f_mode & FMODE_PWRITE)
-			ret = vfs_writev(f.file, vec, vlen, &pos, 0);
+			ret = vfs_writev(f.file, vec, vlen, &pos, flags);
 		fdput(f);
 	}
 
@@ -989,6 +987,58 @@ SYSCALL_DEFINE5(pwritev, unsigned long, fd, const struct iovec __user *, vec,
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
@@ -1046,7 +1096,7 @@ out:
 
 static size_t compat_readv(struct file *file,
 			   const struct compat_iovec __user *vec,
-			   unsigned long vlen, loff_t *pos)
+			   unsigned long vlen, loff_t *pos, int flags)
 {
 	ssize_t ret = -EBADF;
 
@@ -1057,7 +1107,7 @@ static size_t compat_readv(struct file *file,
 	if (!(file->f_mode & FMODE_CAN_READ))
 		goto out;
 
-	ret = compat_do_readv_writev(READ, file, vec, vlen, pos, 0);
+	ret = compat_do_readv_writev(READ, file, vec, vlen, pos, flags);
 
 out:
 	if (ret > 0)
@@ -1066,9 +1116,9 @@ out:
 	return ret;
 }
 
-COMPAT_SYSCALL_DEFINE3(readv, compat_ulong_t, fd,
-		const struct compat_iovec __user *,vec,
-		compat_ulong_t, vlen)
+static size_t do_compat_readv(compat_ulong_t fd,
+				 const struct compat_iovec __user *vec,
+				 compat_ulong_t vlen, int flags)
 {
 	struct fd f = fdget_pos(fd);
 	ssize_t ret;
@@ -1077,16 +1127,24 @@ COMPAT_SYSCALL_DEFINE3(readv, compat_ulong_t, fd,
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
+	return do_compat_readv(fd, vec, vlen, 0);
 }
 
-static long __compat_sys_preadv64(unsigned long fd,
+static long do_compat_preadv64(unsigned long fd,
 				  const struct compat_iovec __user *vec,
-				  unsigned long vlen, loff_t pos)
+				  unsigned long vlen, loff_t pos, int flags)
 {
 	struct fd f;
 	ssize_t ret;
@@ -1098,7 +1156,7 @@ static long __compat_sys_preadv64(unsigned long fd,
 		return -EBADF;
 	ret = -ESPIPE;
 	if (f.file->f_mode & FMODE_PREAD)
-		ret = compat_readv(f.file, vec, vlen, &pos);
+		ret = compat_readv(f.file, vec, vlen, &pos, flags);
 	fdput(f);
 	return ret;
 }
@@ -1108,7 +1166,7 @@ COMPAT_SYSCALL_DEFINE4(preadv64, unsigned long, fd,
 		const struct compat_iovec __user *,vec,
 		unsigned long, vlen, loff_t, pos)
 {
-	return __compat_sys_preadv64(fd, vec, vlen, pos);
+	return do_compat_preadv64(fd, vec, vlen, pos, 0);
 }
 #endif
 
@@ -1118,12 +1176,25 @@ COMPAT_SYSCALL_DEFINE5(preadv, compat_ulong_t, fd,
 {
 	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
 
-	return __compat_sys_preadv64(fd, vec, vlen, pos);
+	return do_compat_preadv64(fd, vec, vlen, pos, 0);
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
+		return do_compat_readv(fd, vec, vlen, flags);
+
+	return do_compat_preadv64(fd, vec, vlen, pos, flags);
 }
 
 static size_t compat_writev(struct file *file,
 			    const struct compat_iovec __user *vec,
-			    unsigned long vlen, loff_t *pos)
+			    unsigned long vlen, loff_t *pos, int flags)
 {
 	ssize_t ret = -EBADF;
 
@@ -1143,9 +1214,9 @@ out:
 	return ret;
 }
 
-COMPAT_SYSCALL_DEFINE3(writev, compat_ulong_t, fd,
-		const struct compat_iovec __user *, vec,
-		compat_ulong_t, vlen)
+static size_t do_compat_writev(compat_ulong_t fd,
+				  const struct compat_iovec __user* vec,
+				  compat_ulong_t vlen, int flags)
 {
 	struct fd f = fdget_pos(fd);
 	ssize_t ret;
@@ -1154,28 +1225,36 @@ COMPAT_SYSCALL_DEFINE3(writev, compat_ulong_t, fd,
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
 
-static long __compat_sys_pwritev64(unsigned long fd,
+COMPAT_SYSCALL_DEFINE3(writev, compat_ulong_t, fd,
+		const struct compat_iovec __user *, vec,
+		compat_ulong_t, vlen)
+{
+	return do_compat_writev(fd, vec, vlen, 0);
+}
+
+static long do_compat_pwritev64(unsigned long fd,
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
@@ -1185,7 +1264,7 @@ COMPAT_SYSCALL_DEFINE4(pwritev64, unsigned long, fd,
 		const struct compat_iovec __user *,vec,
 		unsigned long, vlen, loff_t, pos)
 {
-	return __compat_sys_pwritev64(fd, vec, vlen, pos);
+	return do_compat_pwritev64(fd, vec, vlen, pos, 0);
 }
 #endif
 
@@ -1195,8 +1274,21 @@ COMPAT_SYSCALL_DEFINE5(pwritev, compat_ulong_t, fd,
 {
 	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
 
-	return __compat_sys_pwritev64(fd, vec, vlen, pos);
+	return do_compat_pwritev64(fd, vec, vlen, pos, 0);
+}
+
+COMPAT_SYSCALL_DEFINE6(pwritev2, compat_ulong_t, fd,
+		const struct compat_iovec __user *,vec,
+		compat_ulong_t, vlen, u32, pos_low, u32, pos_high, int, flags)
+{
+	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
+
+	if (pos == -1)
+		return do_compat_writev(fd, vec, vlen, flags);
+
+	return do_compat_pwritev64(fd, vec, vlen, pos, flags);
 }
+
 #endif
 
 static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
diff --git a/include/linux/compat.h b/include/linux/compat.h
index a76c917..fe4ccd0 100644
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
index 185815c..d795472 100644
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
-- 
2.1.4
