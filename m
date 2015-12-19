From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 4/9] vfs: Add vfs_copy_file_range() support for pagecache
 copies
Date: Sat, 19 Dec 2015 00:55:32 -0800
Message-ID: <20151219085532.12478.20947.stgit@birch.djwong.org>
References: <20151219085505.12478.71157.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20151219085505.12478.71157.stgit@birch.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-api@vger.kernel.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, Padraig Brady <P@draigBrady.com>, Anna Schumaker <Anna.Schumaker@Netapp.com>
List-Id: linux-api@vger.kernel.org

>From : Anna Schumaker <Anna.Schumaker@Netapp.com>

This allows us to have an in-kernel copy mechanism that avoids frequent
switches between kernel and user space.  This is especially useful so
NFSD can support server-side copies.

The default (flags=0) means to first attempt copy acceleration, but use
the pagecache if that fails.

I moved the rw_verify_area() calls into the fallback code since some
filesystems can handle reflinking a large range.

Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Padraig Brady <P@draigBrady.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/read_write.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)


diff --git a/fs/read_write.c b/fs/read_write.c
index 97c15ca..6f73af1 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1354,8 +1354,7 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 
 	if (!(file_in->f_mode & FMODE_READ) ||
 	    !(file_out->f_mode & FMODE_WRITE) ||
-	    (file_out->f_flags & O_APPEND) ||
-	    !file_out->f_op->copy_file_range)
+	    (file_out->f_flags & O_APPEND))
 		return -EBADF;
 
 	/* this could be relaxed once a method supports cross-fs copies */
@@ -1369,8 +1368,14 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	if (ret)
 		return ret;
 
-	ret = file_out->f_op->copy_file_range(file_in, pos_in, file_out, pos_out,
-					      len, flags);
+	ret = -EOPNOTSUPP;
+	if (file_out->f_op->copy_file_range)
+		ret = file_out->f_op->copy_file_range(file_in, pos_in, file_out,
+						      pos_out, len, flags);
+	if (ret == -EOPNOTSUPP)
+		ret = do_splice_direct(file_in, &pos_in, file_out, &pos_out,
+				len > MAX_RW_COUNT ? MAX_RW_COUNT : len, 0);
+
 	if (ret > 0) {
 		fsnotify_access(file_in);
 		add_rchar(current, ret);

