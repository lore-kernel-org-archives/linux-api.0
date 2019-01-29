From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 13/18] io_uring: add file set registration
Date: Tue, 29 Jan 2019 12:26:57 -0700
Message-ID: <20190129192702.3605-14-axboe@kernel.dk>
References: <20190129192702.3605-1-axboe@kernel.dk>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190129192702.3605-1-axboe@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, Jens Axboe <axboe@kernel.dk>
List-Id: linux-api@vger.kernel.org

We normally have to fget/fput for each IO we do on a file. Even with
the batching we do, the cost of the atomic inc/dec of the file usage
count adds up.

This adds IORING_REGISTER_FILES, and IORING_UNREGISTER_FILES opcodes
for the io_uring_register(2) system call. The arguments passed in must
be an array of __s32 holding file descriptors, and nr_args should hold
the number of file descriptors the application wishes to pin for the
duration of the io_uring context (or until IORING_UNREGISTER_FILES is
called).

When used, the application must set IOSQE_FIXED_FILE in the sqe->flags
member. Then, instead of setting sqe->fd to the real fd, it sets sqe->fd
to the index in the array passed in to IORING_REGISTER_FILES.

Files are automatically unregistered when the io_uring context is
torn down. An application need only unregister if it wishes to
register a new set of fds.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 138 +++++++++++++++++++++++++++++-----
 include/uapi/linux/io_uring.h |   9 ++-
 2 files changed, 127 insertions(+), 20 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 17c869f3ea2f..13c3f8212815 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -100,6 +100,14 @@ struct io_ring_ctx {
 		struct fasync_struct	*cq_fasync;
 	} ____cacheline_aligned_in_smp;
 
+	/*
+	 * If used, fixed file set. Writers must ensure that ->refs is dead,
+	 * readers must ensure that ->refs is alive as long as the file* is
+	 * used. Only updated through io_uring_register(2).
+	 */
+	struct file		**user_files;
+	unsigned		nr_user_files;
+
 	/* if used, fixed mapped user buffers */
 	unsigned		nr_user_bufs;
 	struct io_mapped_ubuf	*user_bufs;
@@ -136,6 +144,7 @@ struct io_kiocb {
 	unsigned int		flags;
 #define REQ_F_FORCE_NONBLOCK	1	/* inline submission attempt */
 #define REQ_F_IOPOLL_COMPLETED	2	/* polled IO has completed */
+#define REQ_F_FIXED_FILE	4	/* ctx owns file */
 	u64			user_data;
 	u64			error;
 
@@ -350,15 +359,17 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		 * Batched puts of the same file, to avoid dirtying the
 		 * file usage count multiple times, if avoidable.
 		 */
-		if (!file) {
-			file = req->rw.ki_filp;
-			file_count = 1;
-		} else if (file == req->rw.ki_filp) {
-			file_count++;
-		} else {
-			fput_many(file, file_count);
-			file = req->rw.ki_filp;
-			file_count = 1;
+		if (!(req->flags & REQ_F_FIXED_FILE)) {
+			if (!file) {
+				file = req->rw.ki_filp;
+				file_count = 1;
+			} else if (file == req->rw.ki_filp) {
+				file_count++;
+			} else {
+				fput_many(file, file_count);
+				file = req->rw.ki_filp;
+				file_count = 1;
+			}
 		}
 
 		if (to_free == ARRAY_SIZE(reqs))
@@ -491,13 +502,19 @@ static void kiocb_end_write(struct kiocb *kiocb)
 	}
 }
 
+static void io_fput(struct io_kiocb *req)
+{
+	if (!(req->flags & REQ_F_FIXED_FILE))
+		fput(req->rw.ki_filp);
+}
+
 static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw);
 
 	kiocb_end_write(kiocb);
 
-	fput(kiocb->ki_filp);
+	io_fput(req);
 	io_cqring_add_event(req->ctx, req->user_data, res, 0);
 	io_free_req(req);
 }
@@ -596,11 +613,22 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct kiocb *kiocb = &req->rw;
-	unsigned ioprio;
+	unsigned ioprio, flags;
 	int fd, ret;
 
+	flags = READ_ONCE(sqe->flags);
 	fd = READ_ONCE(sqe->fd);
-	kiocb->ki_filp = io_file_get(state, fd);
+
+	if (flags & IOSQE_FIXED_FILE) {
+		if (unlikely(!ctx->user_files ||
+		    (unsigned) fd >= ctx->nr_user_files))
+			return -EBADF;
+		kiocb->ki_filp = ctx->user_files[fd];
+		req->flags |= REQ_F_FIXED_FILE;
+	} else {
+		kiocb->ki_filp = io_file_get(state, fd);
+	}
+
 	if (unlikely(!kiocb->ki_filp))
 		return -EBADF;
 	kiocb->ki_pos = READ_ONCE(sqe->off);
@@ -641,7 +669,8 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	}
 	return 0;
 out_fput:
-	io_file_put(state, kiocb->ki_filp);
+	if (!(flags & IOSQE_FIXED_FILE))
+		io_file_put(state, kiocb->ki_filp);
 	return ret;
 }
 
@@ -765,7 +794,7 @@ static ssize_t io_read(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	kfree(iovec);
 out_fput:
 	if (unlikely(ret))
-		fput(file);
+		io_fput(req);
 	return ret;
 }
 
@@ -820,7 +849,7 @@ static ssize_t io_write(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	kfree(iovec);
 out_fput:
 	if (unlikely(ret))
-		fput(file);
+		io_fput(req);
 	return ret;
 }
 
@@ -846,7 +875,7 @@ static int io_fsync(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	loff_t sqe_off = READ_ONCE(sqe->off);
 	loff_t sqe_len = READ_ONCE(sqe->len);
 	loff_t end = sqe_off + sqe_len;
-	unsigned fsync_flags;
+	unsigned fsync_flags, flags;
 	struct file *file;
 	int ret, fd;
 
@@ -864,14 +893,23 @@ static int io_fsync(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		return -EINVAL;
 
 	fd = READ_ONCE(sqe->fd);
-	file = fget(fd);
+	flags = READ_ONCE(sqe->flags);
+
+	if (flags & IOSQE_FIXED_FILE) {
+		if (unlikely(!ctx->user_files || fd >= ctx->nr_user_files))
+			return -EBADF;
+		file = ctx->user_files[fd];
+	} else {
+		file = fget(fd);
+	}
 	if (unlikely(!file))
 		return -EBADF;
 
 	ret = vfs_fsync_range(file, sqe_off, end > 0 ? end : LLONG_MAX,
 				fsync_flags & IORING_FSYNC_DATASYNC);
 
-	fput(file);
+	if (!(flags & IOSQE_FIXED_FILE))
+		fput(file);
 	io_cqring_add_event(ctx, sqe->user_data, ret, 0);
 	io_free_req(req);
 	return 0;
@@ -1002,7 +1040,7 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, const struct sqe_submit *s,
 	ssize_t ret;
 
 	/* enforce forwards compatibility on users */
-	if (unlikely(s->sqe->flags))
+	if (unlikely(s->sqe->flags & ~IOSQE_FIXED_FILE))
 		return -EINVAL;
 
 	req = io_get_req(ctx, state);
@@ -1220,6 +1258,58 @@ static int __io_uring_enter(struct io_ring_ctx *ctx, unsigned to_submit,
 	return submitted ? submitted : ret;
 }
 
+static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
+{
+	int i;
+
+	if (!ctx->user_files)
+		return -ENXIO;
+
+	for (i = 0; i < ctx->nr_user_files; i++)
+		fput(ctx->user_files[i]);
+
+	kfree(ctx->user_files);
+	ctx->user_files = NULL;
+	ctx->nr_user_files = 0;
+	return 0;
+}
+
+static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
+				 unsigned nr_args)
+{
+	__s32 __user *fds = (__s32 __user *) arg;
+	int fd, ret = 0;
+	unsigned i;
+
+	if (ctx->user_files)
+		return -EBUSY;
+	if (!nr_args)
+		return -EINVAL;
+
+	ctx->user_files = kcalloc(nr_args, sizeof(struct file *), GFP_KERNEL);
+	if (!ctx->user_files)
+		return -ENOMEM;
+
+	for (i = 0; i < nr_args; i++) {
+		ret = -EFAULT;
+		if (copy_from_user(&fd, &fds[i], sizeof(fd)))
+			break;
+
+		ctx->user_files[i] = fget(fd);
+
+		ret = -EBADF;
+		if (!ctx->user_files[i])
+			break;
+		ctx->nr_user_files++;
+		ret = 0;
+	}
+
+	if (ret)
+		io_sqe_files_unregister(ctx);
+
+	return ret;
+}
+
 static int io_sq_offload_start(struct io_ring_ctx *ctx)
 {
 	int ret;
@@ -1509,6 +1599,7 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 
 	io_iopoll_reap_events(ctx);
 	io_sqe_buffer_unregister(ctx);
+	io_sqe_files_unregister(ctx);
 
 	io_mem_free(ctx->sq_ring);
 	io_mem_free(ctx->sq_sqes);
@@ -1806,6 +1897,15 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_sqe_buffer_unregister(ctx);
 		break;
+	case IORING_REGISTER_FILES:
+		ret = io_sqe_files_register(ctx, arg, nr_args);
+		break;
+	case IORING_UNREGISTER_FILES:
+		ret = -EINVAL;
+		if (arg || nr_args)
+			break;
+		ret = io_sqe_files_unregister(ctx);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 16c423d74f2e..3e79feb34a9c 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -16,7 +16,7 @@
  */
 struct io_uring_sqe {
 	__u8	opcode;		/* type of operation for this sqe */
-	__u8	flags;		/* as of now unused */
+	__u8	flags;		/* IOSQE_ flags */
 	__u16	ioprio;		/* ioprio for the request */
 	__s32	fd;		/* file descriptor to do IO on */
 	__u64	off;		/* offset into file */
@@ -33,6 +33,11 @@ struct io_uring_sqe {
 	};
 };
 
+/*
+ * sqe->flags
+ */
+#define IOSQE_FIXED_FILE	(1U << 0)	/* use fixed fileset */
+
 /*
  * io_uring_setup() flags
  */
@@ -112,5 +117,7 @@ struct io_uring_params {
  */
 #define IORING_REGISTER_BUFFERS		0
 #define IORING_UNREGISTER_BUFFERS	1
+#define IORING_REGISTER_FILES		2
+#define IORING_UNREGISTER_FILES		3
 
 #endif
-- 
2.17.1

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
