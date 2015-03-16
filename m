From: Milosz Tanski <milosz@adfin.com>
Subject: [PATCH v7 5/5] xfs: add RWF_NONBLOCK support
Date: Mon, 16 Mar 2015 14:27:15 -0400
Message-ID: <0a6f2c2297bfbfd7220e3c4d6bce34fc42bc22fb.1426528417.git.milosz@adfin.com>
References: <cover.1426528417.git.milosz@adfin.com>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <cover.1426528417.git.milosz@adfin.com>
In-Reply-To: <cover.1426528417.git.milosz@adfin.com>
References: <cover.1426528417.git.milosz@adfin.com>
Sender: owner-linux-aio@kvack.org
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Add support for non-blocking reads.  The guts are handled by the generic
code, the only addition is a non-blocking variant of xfs_rw_ilock.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index a38ddc1..69333a7 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -59,6 +59,25 @@ xfs_rw_ilock(
 	xfs_ilock(ip, type);
 }
 
+static inline bool
+xfs_rw_ilock_nowait(
+	struct xfs_inode	*ip,
+	int			type)
+{
+	if (type & XFS_IOLOCK_EXCL) {
+		if (!mutex_trylock(&VFS_I(ip)->i_mutex))
+			return false;
+		if (!xfs_ilock_nowait(ip, type)) {
+			mutex_unlock(&VFS_I(ip)->i_mutex);
+			return false;
+		}
+	} else {
+		if (!xfs_ilock_nowait(ip, type))
+			return false;
+	}
+	return true;
+}
+
 static inline void
 xfs_rw_iunlock(
 	struct xfs_inode	*ip,
@@ -280,10 +299,6 @@ xfs_file_read_iter(
 
 	XFS_STATS_INC(xs_read_calls);
 
-	/* XXX: need a non-blocking iolock helper, shouldn't be too hard */
-	if (iocb->ki_rwflags & RWF_NONBLOCK)
-		return -EAGAIN;
-
 	if (unlikely(file->f_flags & O_DIRECT))
 		ioflags |= XFS_IO_ISDIRECT;
 	if (file->f_mode & FMODE_NOCMTIME)
@@ -321,7 +336,14 @@ xfs_file_read_iter(
 	 * This allows the normal direct IO case of no page cache pages to
 	 * proceeed concurrently without serialisation.
 	 */
-	xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
+	if (iocb->ki_rwflags & RWF_NONBLOCK) {
+		if (ioflags & XFS_IO_ISDIRECT)
+			return -EAGAIN;
+		if (!xfs_rw_ilock_nowait(ip, XFS_IOLOCK_SHARED))
+			return -EAGAIN;
+	} else {
+		xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
+	}
 	if ((ioflags & XFS_IO_ISDIRECT) && inode->i_mapping->nrpages) {
 		xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
 		xfs_rw_ilock(ip, XFS_IOLOCK_EXCL);
-- 
1.9.1

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
