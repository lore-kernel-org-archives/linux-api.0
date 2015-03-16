From: Milosz Tanski <milosz@adfin.com>
Subject: [PATCH v7 4/5] vfs: RWF_NONBLOCK flag for preadv2
Date: Mon, 16 Mar 2015 14:27:14 -0400
Message-ID: <e6e21cc748178023c463cb9c2ca246ed91c0ac51.1426528417.git.milosz@adfin.com>
References: <cover.1426528417.git.milosz@adfin.com>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <cover.1426528417.git.milosz@adfin.com>
In-Reply-To: <cover.1426528417.git.milosz@adfin.com>
References: <cover.1426528417.git.milosz@adfin.com>
Sender: owner-linux-aio@kvack.org
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

generic_file_read_iter() supports a new flag RWF_NONBLOCK which says that we
only want to read the data if it's already in the page cache.

Additionally, there are a few filesystems that we have to specifically
bail early if RWF_NONBLOCK because the op would block. Christoph Hellwig
contributed this code.

Signed-off-by: Milosz Tanski <milosz@adfin.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Acked-by: Sage Weil <sage@redhat.com>
---
 fs/ceph/file.c     |  2 ++
 fs/cifs/file.c     |  6 ++++++
 fs/nfs/file.c      |  5 ++++-
 fs/ocfs2/file.c    |  6 ++++++
 fs/pipe.c          |  3 ++-
 fs/read_write.c    | 44 ++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_file.c  |  4 ++++
 include/linux/fs.h |  2 ++
 mm/filemap.c       | 18 ++++++++++++++++++
 mm/shmem.c         |  4 ++++
 10 files changed, 78 insertions(+), 16 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index d533075..78bdde3 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -831,6 +831,8 @@ again:
 	if ((got & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) == 0 ||
 	    (iocb->ki_filp->f_flags & O_DIRECT) ||
 	    (fi->flags & CEPH_F_SYNC)) {
+		if (iocb->ki_rwflags & O_NONBLOCK)
+			return -EAGAIN;
 
 		dout("aio_sync_read %p %llx.%llx %llu~%u got cap refs on %s\n",
 		     inode, ceph_vinop(inode), iocb->ki_pos, (unsigned)len,
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index a94b3e6..1d16b5a 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3003,6 +3003,9 @@ ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to)
 	struct cifs_readdata *rdata, *tmp;
 	struct list_head rdata_list;
 
+	if (iocb->ki_rwflags & RWF_NONBLOCK)
+		return -EAGAIN;
+
 	len = iov_iter_count(to);
 	if (!len)
 		return 0;
@@ -3121,6 +3124,9 @@ cifs_strict_readv(struct kiocb *iocb, struct iov_iter *to)
 	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
 		return generic_file_read_iter(iocb, to);
 
+	if (iocb->ki_rwflags & RWF_NONBLOCK)
+		return -EAGAIN;
+
 	/*
 	 * We need to hold the sem to be sure nobody modifies lock list
 	 * with a brlock that prevents reading.
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index e679d24..58c21d7 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -171,8 +171,11 @@ nfs_file_read(struct kiocb *iocb, struct iov_iter *to)
 	struct inode *inode = file_inode(iocb->ki_filp);
 	ssize_t result;
 
-	if (iocb->ki_filp->f_flags & O_DIRECT)
+	if (iocb->ki_filp->f_flags & O_DIRECT) {
+		if (iocb->ki_rwflags & O_NONBLOCK)
+			return -EAGAIN;
 		return nfs_file_direct_read(iocb, to, iocb->ki_pos);
+	}
 
 	dprintk("NFS: read(%pD2, %zu@%lu)\n",
 		iocb->ki_filp,
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 46e0d4e..c155752 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2536,6 +2536,12 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
 			filp->f_path.dentry->d_name.name,
 			to->nr_segs);	/* GRRRRR */
 
+	/*
+	 * No non-blocking reads for ocfs2 for now.  Might be doable with
+	 * non-blocking cluster lock helpers.
+	 */
+	if (iocb->ki_rwflags & RWF_NONBLOCK)
+		return -EAGAIN;
 
 	if (!inode) {
 		ret = -EINVAL;
diff --git a/fs/pipe.c b/fs/pipe.c
index 21981e5..212bf68 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -302,7 +302,8 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
 			 */
 			if (ret)
 				break;
-			if (filp->f_flags & O_NONBLOCK) {
+			if ((filp->f_flags & O_NONBLOCK) ||
+			    (iocb->ki_rwflags & RWF_NONBLOCK)) {
 				ret = -EAGAIN;
 				break;
 			}
diff --git a/fs/read_write.c b/fs/read_write.c
index e91f46e..339477b 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -893,14 +893,19 @@ static ssize_t do_readv_writev(int type, struct file *file,
 		file_start_write(file);
 	}
 
-	if (iter_fn)
+	if (iter_fn) {
 		ret = do_iter_readv_writev(file, type, iov, nr_segs, tot_len,
 						pos, iter_fn, flags);
-	else if (fnv)
-		ret = do_sync_readv_writev(file, iov, nr_segs, tot_len,
-						pos, fnv);
-	else
-		ret = do_loop_readv_writev(file, iov, nr_segs, pos, fn);
+	} else {
+		if (type == READ && (flags & RWF_NONBLOCK))
+			return -EAGAIN;
+
+		if (fnv)
+			ret = do_sync_readv_writev(file, iov, nr_segs, tot_len,
+							pos, fnv);
+		else
+			ret = do_loop_readv_writev(file, iov, nr_segs, pos, fn);
+	}
 
 	if (type != READ)
 		file_end_write(file);
@@ -924,8 +929,10 @@ ssize_t vfs_readv(struct file *file, const struct iovec __user *vec,
 		return -EBADF;
 	if (!(file->f_mode & FMODE_CAN_READ))
 		return -EINVAL;
-	if (flags & ~0)
+	if (flags & ~RWF_NONBLOCK)
 		return -EINVAL;
+	if ((file->f_flags & O_DIRECT) && (flags & RWF_NONBLOCK))
+		return -EAGAIN;
 
 	return do_readv_writev(READ, file, vec, vlen, pos, flags);
 }
@@ -1127,14 +1134,19 @@ static ssize_t compat_do_readv_writev(int type, struct file *file,
 		file_start_write(file);
 	}
 
-	if (iter_fn)
+	if (iter_fn) {
 		ret = do_iter_readv_writev(file, type, iov, nr_segs, tot_len,
 						pos, iter_fn, flags);
-	else if (fnv)
-		ret = do_sync_readv_writev(file, iov, nr_segs, tot_len,
-						pos, fnv);
-	else
-		ret = do_loop_readv_writev(file, iov, nr_segs, pos, fn);
+	} else {
+		if (type == READ && (flags & RWF_NONBLOCK))
+			return -EAGAIN;
+
+		if (fnv)
+			ret = do_sync_readv_writev(file, iov, nr_segs, tot_len,
+							pos, fnv);
+		else
+			ret = do_loop_readv_writev(file, iov, nr_segs, pos, fn);
+	}
 
 	if (type != READ)
 		file_end_write(file);
@@ -1163,7 +1175,11 @@ static size_t compat_readv(struct file *file,
 	ret = -EINVAL;
 	if (!(file->f_mode & FMODE_CAN_READ))
 		goto out;
-	if (flags & ~0)
+	if (flags & ~RWF_NONBLOCK)
+		goto out;
+
+	ret = -EAGAIN;
+	if ((file->f_flags & O_DIRECT) && (flags & RWF_NONBLOCK))
 		goto out;
 
 	ret = compat_do_readv_writev(READ, file, vec, vlen, pos, flags);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index a2e1cb8..a38ddc1 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -280,6 +280,10 @@ xfs_file_read_iter(
 
 	XFS_STATS_INC(xs_read_calls);
 
+	/* XXX: need a non-blocking iolock helper, shouldn't be too hard */
+	if (iocb->ki_rwflags & RWF_NONBLOCK)
+		return -EAGAIN;
+
 	if (unlikely(file->f_flags & O_DIRECT))
 		ioflags |= XFS_IO_ISDIRECT;
 	if (file->f_mode & FMODE_NOCMTIME)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c018335..fb2de58 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1531,6 +1531,8 @@ struct block_device_operations;
 #define NOMMU_VMFLAGS \
 	(NOMMU_MAP_READ | NOMMU_MAP_WRITE | NOMMU_MAP_EXEC)
 
+/* These flags are used for the readv/writev syscalls with flags. */
+#define RWF_NONBLOCK 0x00000001
 
 struct iov_iter;
 
diff --git a/mm/filemap.c b/mm/filemap.c
index 7865f64..ad789e0 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1490,6 +1490,8 @@ static ssize_t do_generic_file_read(struct file *filp, loff_t *ppos,
 find_page:
 		page = find_get_page(mapping, index);
 		if (!page) {
+			if (flags & RWF_NONBLOCK)
+				goto would_block;
 			page_cache_sync_readahead(mapping,
 					ra, filp,
 					index, last_index - index);
@@ -1581,6 +1583,11 @@ page_ok:
 		continue;
 
 page_not_up_to_date:
+		if (flags & RWF_NONBLOCK) {
+			page_cache_release(page);
+			goto would_block;
+		}
+
 		/* Get exclusive access to the page ... */
 		error = lock_page_killable(page);
 		if (unlikely(error))
@@ -1600,6 +1607,12 @@ page_not_up_to_date_locked:
 			goto page_ok;
 		}
 
+		if (flags & RWF_NONBLOCK) {
+			unlock_page(page);
+			page_cache_release(page);
+			goto would_block;
+		}
+
 readpage:
 		/*
 		 * A previous I/O error may have been due to temporary
@@ -1670,6 +1683,8 @@ no_cached_page:
 		goto readpage;
 	}
 
+would_block:
+	error = -EAGAIN;
 out:
 	ra->prev_pos = prev_index;
 	ra->prev_pos <<= PAGE_CACHE_SHIFT;
@@ -1702,6 +1717,9 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 		size_t count = iov_iter_count(iter);
 		loff_t size;
 
+		if (iocb->ki_rwflags & RWF_NONBLOCK)
+			return -EAGAIN;
+
 		if (!count)
 			goto out; /* skip atime */
 		size = i_size_read(inode);
diff --git a/mm/shmem.c b/mm/shmem.c
index cf2d0ca..c5b78f8 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1528,6 +1528,10 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	ssize_t retval = 0;
 	loff_t *ppos = &iocb->ki_pos;
 
+	/* XXX: should be easily supportable */
+	if (iocb->ki_rwflags & RWF_NONBLOCK)
+		return -EAGAIN;
+
 	/*
 	 * Might this read be for a stacking filesystem?  Then when reading
 	 * holes of a sparse file, we actually need to allocate those pages,
-- 
1.9.1

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
