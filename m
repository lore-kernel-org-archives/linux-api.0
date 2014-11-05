From: Milosz Tanski <milosz@adfin.com>
Subject: [PATCH v5 5/7] xfs: add RWF_NONBLOCK support
Date: Wed,  5 Nov 2014 16:14:51 -0500
Message-ID: <23798acaf272aea30908e619ff40b2b173d6e57c.1415220890.git.milosz@adfin.com>
References: <cover.1415220890.git.milosz@adfin.com>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <cover.1415220890.git.milosz@adfin.com>
In-Reply-To: <cover.1415220890.git.milosz@adfin.com>
References: <cover.1415220890.git.milosz@adfin.com>
Sender: owner-linux-aio@kvack.org
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, linux-xfs@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Add support for non-blocking reads.  The guts are handled by the generic
code, the only addition is a non-blocking variant of xfs_rw_ilock.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index b1f6334..0655915 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -61,6 +61,25 @@ xfs_rw_ilock(
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
@@ -246,10 +265,6 @@ xfs_file_read_iter(
 
 	XFS_STATS_INC(xs_read_calls);
 
-	/* XXX: need a non-blocking iolock helper, shouldn't be too hard */
-	if (iocb->ki_rwflags & RWF_NONBLOCK)
-		return -EAGAIN;
-
 	if (unlikely(file->f_flags & O_DIRECT))
 		ioflags |= XFS_IO_ISDIRECT;
 	if (file->f_mode & FMODE_NOCMTIME)
@@ -287,7 +302,14 @@ xfs_file_read_iter(
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
