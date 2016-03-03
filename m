From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/6] vfs: vfs: Define new syscalls preadv2,pwritev2
Date: Thu,  3 Mar 2016 16:03:59 +0100
Message-ID: <1457017443-17662-3-git-send-email-hch@lst.de>
References: <1457017443-17662-1-git-send-email-hch@lst.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1457017443-17662-1-git-send-email-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk, axboe@fb.com
Cc: milosz@adfin.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Milosz Tanski <milosz@adfin.com>

New syscalls that take an flag argument.   No flags are added yet in this
patch.

Signed-off-by: Milosz Tanski <milosz@adfin.com>
[hch: rebased on top of my kiocb changes]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Stephen Bates <stephen.bates@pmcs.com>
Tested-by: Stephen Bates <stephen.bates@pmcs.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
---
 fs/read_write.c          | 161 ++++++++++++++++++++++++++++++++++++-----------
 include/linux/compat.h   |   6 ++
 include/linux/syscalls.h |   6 ++
 3 files changed, 138 insertions(+), 35 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 3b7577d..799d25f 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -896,15 +896,15 @@ ssize_t vfs_writev(struct file *file, const struct iovec __user *vec,
 
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
@@ -916,15 +916,15 @@ SYSCALL_DEFINE3(readv, unsigned long, fd, const struct iovec __user *, vec,
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
@@ -942,10 +942,9 @@ static inline loff_t pos_from_hilo(unsigned long high, unsigned long low)
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
 
@@ -956,7 +955,7 @@ SYSCALL_DEFINE5(preadv, unsigned long, fd, const struct iovec __user *, vec,
 	if (f.file) {
 		ret = -ESPIPE;
 		if (f.file->f_mode & FMODE_PREAD)
-			ret = vfs_readv(f.file, vec, vlen, &pos, 0);
+			ret = vfs_readv(f.file, vec, vlen, &pos, flags);
 		fdput(f);
 	}
 
@@ -966,10 +965,9 @@ SYSCALL_DEFINE5(preadv, unsigned long, fd, const struct iovec __user *, vec,
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
 
@@ -980,7 +978,7 @@ SYSCALL_DEFINE5(pwritev, unsigned long, fd, const struct iovec __user *, vec,
 	if (f.file) {
 		ret = -ESPIPE;
 		if (f.file->f_mode & FMODE_PWRITE)
-			ret = vfs_writev(f.file, vec, vlen, &pos, 0);
+			ret = vfs_writev(f.file, vec, vlen, &pos, flags);
 		fdput(f);
 	}
 
@@ -990,6 +988,58 @@ SYSCALL_DEFINE5(pwritev, unsigned long, fd, const struct iovec __user *, vec,
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
@@ -1047,7 +1097,7 @@ out:
 
 static size_t compat_readv(struct file *file,
 			   const struct compat_iovec __user *vec,
-			   unsigned long vlen, loff_t *pos)
+			   unsigned long vlen, loff_t *pos, int flags)
 {
 	ssize_t ret = -EBADF;
 
@@ -1058,7 +1108,7 @@ static size_t compat_readv(struct file *file,
 	if (!(file->f_mode & FMODE_CAN_READ))
 		goto out;
 
-	ret = compat_do_readv_writev(READ, file, vec, vlen, pos, 0);
+	ret = compat_do_readv_writev(READ, file, vec, vlen, pos, flags);
 
 out:
 	if (ret > 0)
@@ -1067,9 +1117,9 @@ out:
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
@@ -1078,16 +1128,24 @@ COMPAT_SYSCALL_DEFINE3(readv, compat_ulong_t, fd,
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
 }
 
-static long __compat_sys_preadv64(unsigned long fd,
+COMPAT_SYSCALL_DEFINE3(readv, compat_ulong_t, fd,
+		const struct compat_iovec __user *,vec,
+		compat_ulong_t, vlen)
+{
+	return do_compat_readv(fd, vec, vlen, 0);
+}
+
+static long do_compat_preadv64(unsigned long fd,
 				  const struct compat_iovec __user *vec,
-				  unsigned long vlen, loff_t pos)
+				  unsigned long vlen, loff_t pos, int flags)
 {
 	struct fd f;
 	ssize_t ret;
@@ -1099,7 +1157,7 @@ static long __compat_sys_preadv64(unsigned long fd,
 		return -EBADF;
 	ret = -ESPIPE;
 	if (f.file->f_mode & FMODE_PREAD)
-		ret = compat_readv(f.file, vec, vlen, &pos);
+		ret = compat_readv(f.file, vec, vlen, &pos, flags);
 	fdput(f);
 	return ret;
 }
@@ -1109,7 +1167,7 @@ COMPAT_SYSCALL_DEFINE4(preadv64, unsigned long, fd,
 		const struct compat_iovec __user *,vec,
 		unsigned long, vlen, loff_t, pos)
 {
-	return __compat_sys_preadv64(fd, vec, vlen, pos);
+	return do_compat_preadv64(fd, vec, vlen, pos, 0);
 }
 #endif
 
@@ -1119,12 +1177,25 @@ COMPAT_SYSCALL_DEFINE5(preadv, compat_ulong_t, fd,
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
 
@@ -1144,9 +1215,9 @@ out:
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
@@ -1155,16 +1226,23 @@ COMPAT_SYSCALL_DEFINE3(writev, compat_ulong_t, fd,
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
@@ -1176,7 +1254,7 @@ static long __compat_sys_pwritev64(unsigned long fd,
 		return -EBADF;
 	ret = -ESPIPE;
 	if (f.file->f_mode & FMODE_PWRITE)
-		ret = compat_writev(f.file, vec, vlen, &pos);
+		ret = compat_writev(f.file, vec, vlen, &pos, flags);
 	fdput(f);
 	return ret;
 }
@@ -1186,7 +1264,7 @@ COMPAT_SYSCALL_DEFINE4(pwritev64, unsigned long, fd,
 		const struct compat_iovec __user *,vec,
 		unsigned long, vlen, loff_t, pos)
 {
-	return __compat_sys_pwritev64(fd, vec, vlen, pos);
+	return do_compat_pwritev64(fd, vec, vlen, pos, 0);
 }
 #endif
 
@@ -1196,8 +1274,21 @@ COMPAT_SYSCALL_DEFINE5(pwritev, compat_ulong_t, fd,
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

