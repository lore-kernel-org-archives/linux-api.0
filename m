From: Omar Sandoval <osandov@osandov.com>
Subject: [RFC PATCH 1/3] fs: pass READ/WRITE to kiocb_set_rw_flags()
Date: Wed, 18 Sep 2019 23:53:44 -0700
Message-ID: <d23a40f0ad3fa0631fe6189b94811be473e7cc4a.1568875700.git.osandov@fb.com>
References: <cover.1568875700.git.osandov@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1568875700.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>, linux-api@vger.kernel.org, kernel-team@fb.com, Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>
List-Id: linux-api@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

A following change will want to check whether an IO is a read or write
in kiocb_set_rw_flags(). Additionally, aio and io_uring currently set
the IOCB_WRITE flag on a kiocb right before calling call_write_iter(),
but we can move that into the common code.

Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/aio.c           | 9 ++++-----
 fs/io_uring.c      | 9 ++++-----
 fs/read_write.c    | 2 +-
 include/linux/fs.h | 5 ++++-
 4 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 01e0fb9ae45a..72195e182db2 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1442,7 +1442,7 @@ static void aio_complete_rw(struct kiocb *kiocb, long res, long res2)
 	iocb_put(iocb);
 }
 
-static int aio_prep_rw(struct kiocb *req, const struct iocb *iocb)
+static int aio_prep_rw(int rw, struct kiocb *req, const struct iocb *iocb)
 {
 	int ret;
 
@@ -1469,7 +1469,7 @@ static int aio_prep_rw(struct kiocb *req, const struct iocb *iocb)
 	} else
 		req->ki_ioprio = get_current_ioprio();
 
-	ret = kiocb_set_rw_flags(req, iocb->aio_rw_flags);
+	ret = kiocb_set_rw_flags(rw, req, iocb->aio_rw_flags);
 	if (unlikely(ret))
 		return ret;
 
@@ -1525,7 +1525,7 @@ static int aio_read(struct kiocb *req, const struct iocb *iocb,
 	struct file *file;
 	int ret;
 
-	ret = aio_prep_rw(req, iocb);
+	ret = aio_prep_rw(READ, req, iocb);
 	if (ret)
 		return ret;
 	file = req->ki_filp;
@@ -1553,7 +1553,7 @@ static int aio_write(struct kiocb *req, const struct iocb *iocb,
 	struct file *file;
 	int ret;
 
-	ret = aio_prep_rw(req, iocb);
+	ret = aio_prep_rw(WRITE, req, iocb);
 	if (ret)
 		return ret;
 	file = req->ki_filp;
@@ -1579,7 +1579,6 @@ static int aio_write(struct kiocb *req, const struct iocb *iocb,
 			__sb_start_write(file_inode(file)->i_sb, SB_FREEZE_WRITE, true);
 			__sb_writers_release(file_inode(file)->i_sb, SB_FREEZE_WRITE);
 		}
-		req->ki_flags |= IOCB_WRITE;
 		aio_rw_done(req, call_write_iter(file, req, &iter));
 	}
 	kfree(iovec);
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0dadbdbead0f..548525cb1699 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1002,7 +1002,7 @@ static bool io_file_supports_async(struct file *file)
 	return false;
 }
 
-static int io_prep_rw(struct io_kiocb *req, const struct sqe_submit *s,
+static int io_prep_rw(int rw, struct io_kiocb *req, const struct sqe_submit *s,
 		      bool force_nonblock)
 {
 	const struct io_uring_sqe *sqe = s->sqe;
@@ -1031,7 +1031,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct sqe_submit *s,
 	} else
 		kiocb->ki_ioprio = get_current_ioprio();
 
-	ret = kiocb_set_rw_flags(kiocb, READ_ONCE(sqe->rw_flags));
+	ret = kiocb_set_rw_flags(rw, kiocb, READ_ONCE(sqe->rw_flags));
 	if (unlikely(ret))
 		return ret;
 
@@ -1258,7 +1258,7 @@ static int io_read(struct io_kiocb *req, const struct sqe_submit *s,
 	size_t iov_count;
 	ssize_t read_size, ret;
 
-	ret = io_prep_rw(req, s, force_nonblock);
+	ret = io_prep_rw(READ, req, s, force_nonblock);
 	if (ret)
 		return ret;
 	file = kiocb->ki_filp;
@@ -1319,7 +1319,7 @@ static int io_write(struct io_kiocb *req, const struct sqe_submit *s,
 	size_t iov_count;
 	ssize_t ret;
 
-	ret = io_prep_rw(req, s, force_nonblock);
+	ret = io_prep_rw(WRITE, req, s, force_nonblock);
 	if (ret)
 		return ret;
 
@@ -1363,7 +1363,6 @@ static int io_write(struct io_kiocb *req, const struct sqe_submit *s,
 			__sb_writers_release(file_inode(file)->i_sb,
 						SB_FREEZE_WRITE);
 		}
-		kiocb->ki_flags |= IOCB_WRITE;
 
 		ret2 = call_write_iter(file, kiocb, &iter);
 		if (!force_nonblock || ret2 != -EAGAIN) {
diff --git a/fs/read_write.c b/fs/read_write.c
index 5bbf587f5bc1..a6548a9d965d 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -682,7 +682,7 @@ static ssize_t do_iter_readv_writev(struct file *filp, struct iov_iter *iter,
 	ssize_t ret;
 
 	init_sync_kiocb(&kiocb, filp);
-	ret = kiocb_set_rw_flags(&kiocb, flags);
+	ret = kiocb_set_rw_flags(type, &kiocb, flags);
 	if (ret)
 		return ret;
 	kiocb.ki_pos = (ppos ? *ppos : 0);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ffe35d97afcb..75c4b7680385 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3351,8 +3351,11 @@ static inline int iocb_flags(struct file *file)
 	return res;
 }
 
-static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags)
+static inline int kiocb_set_rw_flags(int rw, struct kiocb *ki, rwf_t flags)
 {
+	if (rw == WRITE)
+		ki->ki_flags |= IOCB_WRITE;
+
 	if (unlikely(flags & ~RWF_SUPPORTED))
 		return -EOPNOTSUPP;
 
-- 
2.23.0
