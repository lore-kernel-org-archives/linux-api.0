From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 08/10] ext4: nowait aio support
Date: Thu, 15 Jun 2017 11:00:00 -0500
Message-ID: <20170615160002.17233-9-rgoldwyn@suse.de>
References: <20170615160002.17233-1-rgoldwyn@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170615160002.17233-1-rgoldwyn@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, axboe@kernel.dk, linux-api@vger.kernel.org, viro@zeniv.linux.org.uk, akpm@linux-foundation.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-api@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Return EAGAIN if any of the following checks fail for direct I/O:
  + i_rwsem is lockable
  + Writing beyond end of file (will trigger allocation)
  + Blocks are not allocated at the write location

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/file.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 02ce7e7bbdf5..cfb4770657fc 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -216,7 +216,13 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		return ext4_dax_write_iter(iocb, from);
 #endif
 
-	inode_lock(inode);
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		if (!inode_trylock(inode))
+			return -EAGAIN;
+	} else {
+		inode_lock(inode);
+	}
+
 	ret = ext4_write_checks(iocb, from);
 	if (ret <= 0)
 		goto out;
@@ -235,9 +241,15 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 	iocb->private = &overwrite;
 	/* Check whether we do a DIO overwrite or not */
-	if (o_direct && ext4_should_dioread_nolock(inode) && !unaligned_aio &&
-	    ext4_overwrite_io(inode, iocb->ki_pos, iov_iter_count(from)))
-		overwrite = 1;
+	if (o_direct && !unaligned_aio) {
+		if (ext4_overwrite_io(inode, iocb->ki_pos, iov_iter_count(from))) {
+			if (ext4_should_dioread_nolock(inode))
+				overwrite = 1;
+		} else if (iocb->ki_flags & IOCB_NOWAIT) {
+			ret = -EAGAIN;
+			goto out;
+		}
+	}
 
 	ret = __generic_file_write_iter(iocb, from);
 	inode_unlock(inode);
@@ -435,6 +447,10 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
 		if (ret < 0)
 			return ret;
 	}
+
+	/* Set the flags to support nowait AIO */
+	filp->f_mode |= FMODE_NOWAIT_AIO;
+
 	return dquot_file_open(inode, filp);
 }
 
-- 
2.12.0
