From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/18] iomap: wire up the iopoll method
Date: Thu,  7 Feb 2019 12:55:38 -0700
Message-ID: <20190207195552.22770-5-axboe@kernel.dk>
References: <20190207195552.22770-1-axboe@kernel.dk>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190207195552.22770-1-axboe@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk, Jens Axboe <axboe@kernel.dk>
List-Id: linux-api@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Store the request queue the last bio was submitted to in the iocb
private data in addition to the cookie so that we find the right block
device.  Also refactor the common direct I/O bio submission code into a
nice little helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Modified to use bio_set_polled().

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/gfs2/file.c        |  2 ++
 fs/iomap.c            | 43 ++++++++++++++++++++++++++++---------------
 fs/xfs/xfs_file.c     |  1 +
 include/linux/iomap.h |  1 +
 4 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index a2dea5bc0427..58a768e59712 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -1280,6 +1280,7 @@ const struct file_operations gfs2_file_fops = {
 	.llseek		= gfs2_llseek,
 	.read_iter	= gfs2_file_read_iter,
 	.write_iter	= gfs2_file_write_iter,
+	.iopoll		= iomap_dio_iopoll,
 	.unlocked_ioctl	= gfs2_ioctl,
 	.mmap		= gfs2_mmap,
 	.open		= gfs2_open,
@@ -1310,6 +1311,7 @@ const struct file_operations gfs2_file_fops_nolock = {
 	.llseek		= gfs2_llseek,
 	.read_iter	= gfs2_file_read_iter,
 	.write_iter	= gfs2_file_write_iter,
+	.iopoll		= iomap_dio_iopoll,
 	.unlocked_ioctl	= gfs2_ioctl,
 	.mmap		= gfs2_mmap,
 	.open		= gfs2_open,
diff --git a/fs/iomap.c b/fs/iomap.c
index 897c60215dd1..2ac9eb746d44 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -1463,6 +1463,28 @@ struct iomap_dio {
 	};
 };
 
+int iomap_dio_iopoll(struct kiocb *kiocb, bool spin)
+{
+	struct request_queue *q = READ_ONCE(kiocb->private);
+
+	if (!q)
+		return 0;
+	return blk_poll(q, READ_ONCE(kiocb->ki_cookie), spin);
+}
+EXPORT_SYMBOL_GPL(iomap_dio_iopoll);
+
+static void iomap_dio_submit_bio(struct iomap_dio *dio, struct iomap *iomap,
+		struct bio *bio)
+{
+	atomic_inc(&dio->ref);
+
+	if (dio->iocb->ki_flags & IOCB_HIPRI)
+		bio_set_polled(bio, dio->iocb);
+
+	dio->submit.last_queue = bdev_get_queue(iomap->bdev);
+	dio->submit.cookie = submit_bio(bio);
+}
+
 static ssize_t iomap_dio_complete(struct iomap_dio *dio)
 {
 	struct kiocb *iocb = dio->iocb;
@@ -1575,7 +1597,7 @@ static void iomap_dio_bio_end_io(struct bio *bio)
 	}
 }
 
-static blk_qc_t
+static void
 iomap_dio_zero(struct iomap_dio *dio, struct iomap *iomap, loff_t pos,
 		unsigned len)
 {
@@ -1589,15 +1611,10 @@ iomap_dio_zero(struct iomap_dio *dio, struct iomap *iomap, loff_t pos,
 	bio->bi_private = dio;
 	bio->bi_end_io = iomap_dio_bio_end_io;
 
-	if (dio->iocb->ki_flags & IOCB_HIPRI)
-		flags |= REQ_HIPRI;
-
 	get_page(page);
 	__bio_add_page(bio, page, len, 0);
 	bio_set_op_attrs(bio, REQ_OP_WRITE, flags);
-
-	atomic_inc(&dio->ref);
-	return submit_bio(bio);
+	iomap_dio_submit_bio(dio, iomap, bio);
 }
 
 static loff_t
@@ -1700,9 +1717,6 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 				bio_set_pages_dirty(bio);
 		}
 
-		if (dio->iocb->ki_flags & IOCB_HIPRI)
-			bio->bi_opf |= REQ_HIPRI;
-
 		iov_iter_advance(dio->submit.iter, n);
 
 		dio->size += n;
@@ -1710,11 +1724,7 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 		copied += n;
 
 		nr_pages = iov_iter_npages(&iter, BIO_MAX_PAGES);
-
-		atomic_inc(&dio->ref);
-
-		dio->submit.last_queue = bdev_get_queue(iomap->bdev);
-		dio->submit.cookie = submit_bio(bio);
+		iomap_dio_submit_bio(dio, iomap, bio);
 	} while (nr_pages);
 
 	/*
@@ -1925,6 +1935,9 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (dio->flags & IOMAP_DIO_WRITE_FUA)
 		dio->flags &= ~IOMAP_DIO_NEED_SYNC;
 
+	WRITE_ONCE(iocb->ki_cookie, dio->submit.cookie);
+	WRITE_ONCE(iocb->private, dio->submit.last_queue);
+
 	/*
 	 * We are about to drop our additional submission reference, which
 	 * might be the last reference to the dio.  There are three three
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e47425071e65..60c2da41f0fc 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1203,6 +1203,7 @@ const struct file_operations xfs_file_operations = {
 	.write_iter	= xfs_file_write_iter,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= iter_file_splice_write,
+	.iopoll		= iomap_dio_iopoll,
 	.unlocked_ioctl	= xfs_file_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= xfs_file_compat_ioctl,
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 9a4258154b25..0fefb5455bda 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -162,6 +162,7 @@ typedef int (iomap_dio_end_io_t)(struct kiocb *iocb, ssize_t ret,
 		unsigned flags);
 ssize_t iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		const struct iomap_ops *ops, iomap_dio_end_io_t end_io);
+int iomap_dio_iopoll(struct kiocb *kiocb, bool spin);
 
 #ifdef CONFIG_SWAP
 struct file;
-- 
2.17.1

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
