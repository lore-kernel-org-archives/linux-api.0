From: Shawn Landden <shawn@git.icu>
Subject: [PATCH] new flag COPY_FILE_RANGE_FILESIZE for copy_file_range()
Date: Sat, 13 Apr 2019 15:54:39 -0500
Message-ID: <20190413205439.9623-1-shawn@git.icu>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Shawn Landden <shawn@git.icu>
List-Id: linux-api@vger.kernel.org

If flags includes COPY_FILE_RANGE_FILESIZE then the length
copied is the length of the file. off_in and off_out are
ignored. len must be 0 or the file size.

This implementation saves a call to stat() in the common case
of copying files. It does not fix any race conditions, but that
is possible in the future with this interface.

EAGAIN: If COPY_FILE_RANGE_FILESIZE was passed and len is not 0
or the file size.

Signed-off-by: Shawn Landden <shawn@git.icu>
CC: <linux-api@vger.kernel.org>
---
 fs/read_write.c           | 14 +++++++++++++-
 include/uapi/linux/stat.h |  4 ++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 61b43ad7608e..6d06361f0856 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1557,7 +1557,7 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	struct inode *inode_out = file_inode(file_out);
 	ssize_t ret;
 
-	if (flags != 0)
+	if ((flags & ~COPY_FILE_RANGE_FILESIZE) != 0)
 		return -EINVAL;
 
 	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
@@ -1565,6 +1565,18 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
 		return -EINVAL;
 
+	if (flags & COPY_FILE_RANGE_FILESIZE) {
+		struct kstat stat;
+		int error;
+		error = vfs_getattr(&file_in->f_path, &stat,
+				    STATX_SIZE, 0);
+		if (error < 0)
+			return error;
+		if (!(len == 0 || len == stat.size))
+			return -EAGAIN;
+		len = stat.size;
+	}
+
 	ret = rw_verify_area(READ, file_in, &pos_in, len);
 	if (unlikely(ret))
 		return ret;
diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
index 7b35e98d3c58..1075aa4666ef 100644
--- a/include/uapi/linux/stat.h
+++ b/include/uapi/linux/stat.h
@@ -170,5 +170,9 @@ struct statx {
 
 #define STATX_ATTR_AUTOMOUNT		0x00001000 /* Dir: Automount trigger */
 
+/*
+ * Flags for copy_file_range()
+ */
+#define COPY_FILE_RANGE_FILESIZE	0x00000001 /* Copy the full length of the input file */
 
 #endif /* _UAPI_LINUX_STAT_H */
-- 
2.20.1
