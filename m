From: Omar Sandoval <osandov@osandov.com>
Subject: [RFC PATCH 2/3] fs: add RWF_ENCODED for writing compressed data
Date: Wed, 18 Sep 2019 23:53:46 -0700
Message-ID: <230a76e65372a8fb3ec62ce167d9322e5e342810.1568875700.git.osandov@fb.com>
References: <cover.1568875700.git.osandov@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1568875700.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>, linux-api@vger.kernel.org, kernel-team@fb.com
List-Id: linux-api@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

Btrfs can transparently compress data written by the user. However, we'd
like to add an interface to write pre-compressed data directly to the
filesystem. This adds support for so-called "encoded writes" via
pwritev2().

A new RWF_ENCODED flags indicates that a write is "encoded". If this
flag is set, iov[0].iov_base points to a struct encoded_iov which
contains metadata about the write: namely, the compression algorithm and
the unencoded (i.e., decompressed) length of the extent. iov[0].iov_len
must be set to sizeof(struct encoded_iov), which can be used to extend
the interface in the future. The remaining iovecs contain the encoded
extent.

A similar interface for reading encoded data can be added to preadv2()
in the future.

Filesystems must indicate that they support encoded writes by setting
FMODE_ENCODED_IO in ->file_open().

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 include/linux/fs.h      | 13 +++++++
 include/uapi/linux/fs.h | 24 ++++++++++++-
 mm/filemap.c            | 75 ++++++++++++++++++++++++++++++++++-------
 3 files changed, 99 insertions(+), 13 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 75c4b7680385..ae3ac0312674 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -175,6 +175,9 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 /* File does not contribute to nr_files count */
 #define FMODE_NOACCOUNT		((__force fmode_t)0x20000000)
 
+/* File supports encoded IO */
+#define FMODE_ENCODED_IO	((__force fmode_t)0x40000000)
+
 /*
  * Flag for rw_copy_check_uvector and compat_rw_copy_check_uvector
  * that indicates that they should check the contents of the iovec are
@@ -314,6 +317,7 @@ enum rw_hint {
 #define IOCB_SYNC		(1 << 5)
 #define IOCB_WRITE		(1 << 6)
 #define IOCB_NOWAIT		(1 << 7)
+#define IOCB_ENCODED		(1 << 8)
 
 struct kiocb {
 	struct file		*ki_filp;
@@ -3046,6 +3050,10 @@ extern int sb_min_blocksize(struct super_block *, int);
 extern int generic_file_mmap(struct file *, struct vm_area_struct *);
 extern int generic_file_readonly_mmap(struct file *, struct vm_area_struct *);
 extern ssize_t generic_write_checks(struct kiocb *, struct iov_iter *);
+struct encoded_iov;
+extern int generic_encoded_write_checks(struct kiocb *, struct encoded_iov *);
+extern int import_encoded_write(struct kiocb *, struct encoded_iov *,
+				struct iov_iter *);
 extern int generic_remap_checks(struct file *file_in, loff_t pos_in,
 				struct file *file_out, loff_t pos_out,
 				loff_t *count, unsigned int remap_flags);
@@ -3364,6 +3372,11 @@ static inline int kiocb_set_rw_flags(int rw, struct kiocb *ki, rwf_t flags)
 			return -EOPNOTSUPP;
 		ki->ki_flags |= IOCB_NOWAIT;
 	}
+	if (flags & RWF_ENCODED) {
+		if (rw != WRITE || !(ki->ki_filp->f_mode & FMODE_ENCODED_IO))
+			return -EOPNOTSUPP;
+		ki->ki_flags |= IOCB_ENCODED;
+	}
 	if (flags & RWF_HIPRI)
 		ki->ki_flags |= IOCB_HIPRI;
 	if (flags & RWF_DSYNC)
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index aad225b05be7..b775d9aea978 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -283,6 +283,25 @@ struct fsxattr {
 
 typedef int __bitwise __kernel_rwf_t;
 
+enum {
+	ENCODED_IOV_COMPRESSION_NONE,
+	ENCODED_IOV_COMPRESSION_ZLIB,
+	ENCODED_IOV_COMPRESSION_LZO,
+	ENCODED_IOV_COMPRESSION_ZSTD,
+	ENCODED_IOV_COMPRESSION_TYPES = ENCODED_IOV_COMPRESSION_ZSTD,
+};
+
+enum {
+	ENCODED_IOV_ENCRYPTION_NONE,
+	ENCODED_IOV_ENCRYPTION_TYPES = ENCODED_IOV_ENCRYPTION_NONE,
+};
+
+struct encoded_iov {
+	__u64 unencoded_len;
+	__u32 compression;
+	__u32 encryption;
+};
+
 /* high priority request, poll if possible */
 #define RWF_HIPRI	((__force __kernel_rwf_t)0x00000001)
 
@@ -298,8 +317,11 @@ typedef int __bitwise __kernel_rwf_t;
 /* per-IO O_APPEND */
 #define RWF_APPEND	((__force __kernel_rwf_t)0x00000010)
 
+/* encoded (e.g., compressed or encrypted) IO */
+#define RWF_ENCODED	((__force __kernel_rwf_t)0x00000020)
+
 /* mask of flags supported by the kernel */
 #define RWF_SUPPORTED	(RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT |\
-			 RWF_APPEND)
+			 RWF_APPEND | RWF_ENCODED)
 
 #endif /* _UAPI_LINUX_FS_H */
diff --git a/mm/filemap.c b/mm/filemap.c
index 40667c2f3383..3d2555364432 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2974,24 +2974,16 @@ static int generic_write_check_limits(struct file *file, loff_t pos,
 	return 0;
 }
 
-/*
- * Performs necessary checks before doing a write
- *
- * Can adjust writing position or amount of bytes to write.
- * Returns appropriate error code that caller should return or
- * zero in case that write should be allowed.
- */
-inline ssize_t generic_write_checks(struct kiocb *iocb, struct iov_iter *from)
+static int generic_write_checks_common(struct kiocb *iocb, loff_t *count)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
-	loff_t count;
 	int ret;
 
 	if (IS_SWAPFILE(inode))
 		return -ETXTBSY;
 
-	if (!iov_iter_count(from))
+	if (!*count)
 		return 0;
 
 	/* FIXME: this is for backwards compatibility with 2.4 */
@@ -3001,8 +2993,21 @@ inline ssize_t generic_write_checks(struct kiocb *iocb, struct iov_iter *from)
 	if ((iocb->ki_flags & IOCB_NOWAIT) && !(iocb->ki_flags & IOCB_DIRECT))
 		return -EINVAL;
 
-	count = iov_iter_count(from);
-	ret = generic_write_check_limits(file, iocb->ki_pos, &count);
+	return generic_write_check_limits(iocb->ki_filp, iocb->ki_pos, count);
+}
+
+/*
+ * Performs necessary checks before doing a write
+ *
+ * Can adjust writing position or amount of bytes to write.
+ * Returns a negative errno or the new number of bytes to write.
+ */
+inline ssize_t generic_write_checks(struct kiocb *iocb, struct iov_iter *from)
+{
+	loff_t count = iov_iter_count(from);
+	int ret;
+
+	ret = generic_write_checks_common(iocb, &count);
 	if (ret)
 		return ret;
 
@@ -3011,6 +3016,52 @@ inline ssize_t generic_write_checks(struct kiocb *iocb, struct iov_iter *from)
 }
 EXPORT_SYMBOL(generic_write_checks);
 
+int generic_encoded_write_checks(struct kiocb *iocb,
+				 struct encoded_iov *encoded)
+{
+	loff_t count = encoded->unencoded_len;
+	int ret;
+
+	ret = generic_write_checks_common(iocb, &count);
+	if (ret)
+		return ret;
+
+	if (count != encoded->unencoded_len) {
+		/*
+		 * The write got truncated by generic_write_checks(). We can't
+		 * do a partial encoded write.
+		 */
+		return -EFBIG;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(generic_encoded_write_checks);
+
+/*
+ * If no encoding is set, this clears IOCB_ENCODED and the write should be
+ * treated as a normal write.
+ */
+int import_encoded_write(struct kiocb *iocb, struct encoded_iov *encoded,
+			 struct iov_iter *from)
+{
+	if (iov_iter_single_seg_count(from) != sizeof(*encoded))
+		return -EINVAL;
+	if (copy_from_iter(encoded, sizeof(*encoded), from) != sizeof(*encoded))
+		return -EFAULT;
+	if (encoded->compression == ENCODED_IOV_COMPRESSION_NONE &&
+	    encoded->encryption == ENCODED_IOV_ENCRYPTION_NONE) {
+		iocb->ki_flags &= ~IOCB_ENCODED;
+		return 0;
+	}
+	if (encoded->compression > ENCODED_IOV_COMPRESSION_TYPES ||
+	    encoded->encryption > ENCODED_IOV_ENCRYPTION_TYPES)
+		return -EINVAL;
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	return 0;
+}
+EXPORT_SYMBOL(import_encoded_write);
+
 /*
  * Performs necessary checks before doing a clone.
  *
-- 
2.23.0
