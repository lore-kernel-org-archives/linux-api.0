From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 1/6] vfs: pass a flags argument to vfs_readv/vfs_writev
Date: Thu,  3 Mar 2016 16:03:58 +0100
Message-ID: <1457017443-17662-2-git-send-email-hch@lst.de>
References: <1457017443-17662-1-git-send-email-hch@lst.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457017443-17662-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org
Cc: milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This way we can set kiocb flags also from the sync read/write path for
the read_iter/write_iter operations.  For now there is no way to pass
flags to plain read/write operations as there is no real need for that,
and all flags passed are explicitly rejected for these files.

Signed-off-by: Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>
[hch: rebased on top of my kiocb changes]
Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Stephen Bates <stephen.bates-PwyqCcigF0Q@public.gmane.org>
Tested-by: Stephen Bates <stephen.bates-PwyqCcigF0Q@public.gmane.org>
Acked-by: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/nfsd/vfs.c      |  4 ++--
 fs/read_write.c    | 44 ++++++++++++++++++++++++++------------------
 fs/splice.c        |  2 +-
 include/linux/fs.h |  4 ++--
 4 files changed, 31 insertions(+), 23 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 5d2a57e..d40010e 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -870,7 +870,7 @@ __be32 nfsd_readv(struct file *file, loff_t offset, struct kvec *vec, int vlen,
 
 	oldfs = get_fs();
 	set_fs(KERNEL_DS);
-	host_err = vfs_readv(file, (struct iovec __user *)vec, vlen, &offset);
+	host_err = vfs_readv(file, (struct iovec __user *)vec, vlen, &offset, 0);
 	set_fs(oldfs);
 	return nfsd_finish_read(file, count, host_err);
 }
@@ -957,7 +957,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file *file,
 
 	/* Write the data. */
 	oldfs = get_fs(); set_fs(KERNEL_DS);
-	host_err = vfs_writev(file, (struct iovec __user *)vec, vlen, &pos);
+	host_err = vfs_writev(file, (struct iovec __user *)vec, vlen, &pos, 0);
 	set_fs(oldfs);
 	if (host_err < 0)
 		goto out_nfserr;
diff --git a/fs/read_write.c b/fs/read_write.c
index dadf24e..3b7577d 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -693,11 +693,14 @@ unsigned long iov_shorten(struct iovec *iov, unsigned long nr_segs, size_t to)
 EXPORT_SYMBOL(iov_shorten);
 
 static ssize_t do_iter_readv_writev(struct file *filp, struct iov_iter *iter,
-		loff_t *ppos, iter_fn_t fn)
+		loff_t *ppos, iter_fn_t fn, int flags)
 {
 	struct kiocb kiocb;
 	ssize_t ret;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	init_sync_kiocb(&kiocb, filp);
 	kiocb.ki_pos = *ppos;
 
@@ -709,10 +712,13 @@ static ssize_t do_iter_readv_writev(struct file *filp, struct iov_iter *iter,
 
 /* Do it by hand, with file-ops */
 static ssize_t do_loop_readv_writev(struct file *filp, struct iov_iter *iter,
-		loff_t *ppos, io_fn_t fn)
+		loff_t *ppos, io_fn_t fn, int flags)
 {
 	ssize_t ret = 0;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	while (iov_iter_count(iter)) {
 		struct iovec iovec = iov_iter_iovec(iter);
 		ssize_t nr;
@@ -813,7 +819,8 @@ out:
 
 static ssize_t do_readv_writev(int type, struct file *file,
 			       const struct iovec __user * uvector,
-			       unsigned long nr_segs, loff_t *pos)
+			       unsigned long nr_segs, loff_t *pos,
+			       int flags)
 {
 	size_t tot_len;
 	struct iovec iovstack[UIO_FASTIOV];
@@ -845,9 +852,9 @@ static ssize_t do_readv_writev(int type, struct file *file,
 	}
 
 	if (iter_fn)
-		ret = do_iter_readv_writev(file, &iter, pos, iter_fn);
+		ret = do_iter_readv_writev(file, &iter, pos, iter_fn, flags);
 	else
-		ret = do_loop_readv_writev(file, &iter, pos, fn);
+		ret = do_loop_readv_writev(file, &iter, pos, fn, flags);
 
 	if (type != READ)
 		file_end_write(file);
@@ -864,27 +871,27 @@ out:
 }
 
 ssize_t vfs_readv(struct file *file, const struct iovec __user *vec,
-		  unsigned long vlen, loff_t *pos)
+		  unsigned long vlen, loff_t *pos, int flags)
 {
 	if (!(file->f_mode & FMODE_READ))
 		return -EBADF;
 	if (!(file->f_mode & FMODE_CAN_READ))
 		return -EINVAL;
 
-	return do_readv_writev(READ, file, vec, vlen, pos);
+	return do_readv_writev(READ, file, vec, vlen, pos, flags);
 }
 
 EXPORT_SYMBOL(vfs_readv);
 
 ssize_t vfs_writev(struct file *file, const struct iovec __user *vec,
-		   unsigned long vlen, loff_t *pos)
+		   unsigned long vlen, loff_t *pos, int flags)
 {
 	if (!(file->f_mode & FMODE_WRITE))
 		return -EBADF;
 	if (!(file->f_mode & FMODE_CAN_WRITE))
 		return -EINVAL;
 
-	return do_readv_writev(WRITE, file, vec, vlen, pos);
+	return do_readv_writev(WRITE, file, vec, vlen, pos, flags);
 }
 
 EXPORT_SYMBOL(vfs_writev);
@@ -897,7 +904,7 @@ SYSCALL_DEFINE3(readv, unsigned long, fd, const struct iovec __user *, vec,
 
 	if (f.file) {
 		loff_t pos = file_pos_read(f.file);
-		ret = vfs_readv(f.file, vec, vlen, &pos);
+		ret = vfs_readv(f.file, vec, vlen, &pos, 0);
 		if (ret >= 0)
 			file_pos_write(f.file, pos);
 		fdput_pos(f);
@@ -917,7 +924,7 @@ SYSCALL_DEFINE3(writev, unsigned long, fd, const struct iovec __user *, vec,
 
 	if (f.file) {
 		loff_t pos = file_pos_read(f.file);
-		ret = vfs_writev(f.file, vec, vlen, &pos);
+		ret = vfs_writev(f.file, vec, vlen, &pos, 0);
 		if (ret >= 0)
 			file_pos_write(f.file, pos);
 		fdput_pos(f);
@@ -949,7 +956,7 @@ SYSCALL_DEFINE5(preadv, unsigned long, fd, const struct iovec __user *, vec,
 	if (f.file) {
 		ret = -ESPIPE;
 		if (f.file->f_mode & FMODE_PREAD)
-			ret = vfs_readv(f.file, vec, vlen, &pos);
+			ret = vfs_readv(f.file, vec, vlen, &pos, 0);
 		fdput(f);
 	}
 
@@ -973,7 +980,7 @@ SYSCALL_DEFINE5(pwritev, unsigned long, fd, const struct iovec __user *, vec,
 	if (f.file) {
 		ret = -ESPIPE;
 		if (f.file->f_mode & FMODE_PWRITE)
-			ret = vfs_writev(f.file, vec, vlen, &pos);
+			ret = vfs_writev(f.file, vec, vlen, &pos, 0);
 		fdput(f);
 	}
 
@@ -987,7 +994,8 @@ SYSCALL_DEFINE5(pwritev, unsigned long, fd, const struct iovec __user *, vec,
 
 static ssize_t compat_do_readv_writev(int type, struct file *file,
 			       const struct compat_iovec __user *uvector,
-			       unsigned long nr_segs, loff_t *pos)
+			       unsigned long nr_segs, loff_t *pos,
+			       int flags)
 {
 	compat_ssize_t tot_len;
 	struct iovec iovstack[UIO_FASTIOV];
@@ -1019,9 +1027,9 @@ static ssize_t compat_do_readv_writev(int type, struct file *file,
 	}
 
 	if (iter_fn)
-		ret = do_iter_readv_writev(file, &iter, pos, iter_fn);
+		ret = do_iter_readv_writev(file, &iter, pos, iter_fn, flags);
 	else
-		ret = do_loop_readv_writev(file, &iter, pos, fn);
+		ret = do_loop_readv_writev(file, &iter, pos, fn, flags);
 
 	if (type != READ)
 		file_end_write(file);
@@ -1050,7 +1058,7 @@ static size_t compat_readv(struct file *file,
 	if (!(file->f_mode & FMODE_CAN_READ))
 		goto out;
 
-	ret = compat_do_readv_writev(READ, file, vec, vlen, pos);
+	ret = compat_do_readv_writev(READ, file, vec, vlen, pos, 0);
 
 out:
 	if (ret > 0)
@@ -1127,7 +1135,7 @@ static size_t compat_writev(struct file *file,
 	if (!(file->f_mode & FMODE_CAN_WRITE))
 		goto out;
 
-	ret = compat_do_readv_writev(WRITE, file, vec, vlen, pos);
+	ret = compat_do_readv_writev(WRITE, file, vec, vlen, pos, 0);
 
 out:
 	if (ret > 0)
diff --git a/fs/splice.c b/fs/splice.c
index 82bc0d6..3dc1426 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -577,7 +577,7 @@ static ssize_t kernel_readv(struct file *file, const struct iovec *vec,
 	old_fs = get_fs();
 	set_fs(get_ds());
 	/* The cast to a user pointer is valid due to the set_fs() */
-	res = vfs_readv(file, (const struct iovec __user *)vec, vlen, &pos);
+	res = vfs_readv(file, (const struct iovec __user *)vec, vlen, &pos, 0);
 	set_fs(old_fs);
 
 	return res;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ae68100..875277a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1709,9 +1709,9 @@ extern ssize_t __vfs_write(struct file *, const char __user *, size_t, loff_t *)
 extern ssize_t vfs_read(struct file *, char __user *, size_t, loff_t *);
 extern ssize_t vfs_write(struct file *, const char __user *, size_t, loff_t *);
 extern ssize_t vfs_readv(struct file *, const struct iovec __user *,
-		unsigned long, loff_t *);
+		unsigned long, loff_t *, int);
 extern ssize_t vfs_writev(struct file *, const struct iovec __user *,
-		unsigned long, loff_t *);
+		unsigned long, loff_t *, int);
 extern ssize_t vfs_copy_file_range(struct file *, loff_t , struct file *,
 				   loff_t, size_t, unsigned int);
 extern int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
-- 
2.1.4
