From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 13/18] io_uring: add file set registration
Date: Thu,  7 Feb 2019 12:55:47 -0700
Message-ID: <20190207195552.22770-14-axboe@kernel.dk>
References: <20190207195552.22770-1-axboe@kernel.dk>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190207195552.22770-1-axboe@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk, Jens Axboe <axboe@kernel.dk>
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
 fs/io_uring.c                 | 207 +++++++++++++++++++++++++++++-----
 include/net/af_unix.h         |   1 +
 include/uapi/linux/io_uring.h |   9 +-
 net/unix/af_unix.c            |   2 +-
 4 files changed, 188 insertions(+), 31 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9d6233dc35ca..f2550efec60d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -29,6 +29,7 @@
 #include <linux/net.h>
 #include <net/sock.h>
 #include <net/af_unix.h>
+#include <net/scm.h>
 #include <linux/anon_inodes.h>
 #include <linux/sched/mm.h>
 #include <linux/uaccess.h>
@@ -101,6 +102,13 @@ struct io_ring_ctx {
 		struct fasync_struct	*cq_fasync;
 	} ____cacheline_aligned_in_smp;
 
+	/*
+	 * If used, fixed file set. Writers must ensure that ->refs is dead,
+	 * readers must ensure that ->refs is alive as long as the file* is
+	 * used. Only updated through io_uring_register(2).
+	 */
+	struct scm_fp_list	*user_files;
+
 	/* if used, fixed mapped user buffers */
 	unsigned		nr_user_bufs;
 	struct io_mapped_ubuf	*user_bufs;
@@ -148,6 +156,7 @@ struct io_kiocb {
 	unsigned int		flags;
 #define REQ_F_FORCE_NONBLOCK	1	/* inline submission attempt */
 #define REQ_F_IOPOLL_COMPLETED	2	/* polled IO has completed */
+#define REQ_F_FIXED_FILE	4	/* ctx owns file */
 	u64			user_data;
 	u64			error;
 
@@ -374,15 +383,17 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
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
@@ -514,13 +525,19 @@ static void kiocb_end_write(struct kiocb *kiocb)
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
@@ -636,19 +653,29 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct kiocb *kiocb = &req->rw;
-	unsigned ioprio;
+	unsigned ioprio, flags;
 	int fd, ret;
 
 	/* For -EAGAIN retry, everything is already prepped */
 	if (kiocb->ki_filp)
 		return 0;
 
+	flags = READ_ONCE(sqe->flags);
 	fd = READ_ONCE(sqe->fd);
-	kiocb->ki_filp = io_file_get(state, fd);
-	if (unlikely(!kiocb->ki_filp))
-		return -EBADF;
-	if (force_nonblock && !io_file_supports_async(kiocb->ki_filp))
-		force_nonblock = false;
+
+	if (flags & IOSQE_FIXED_FILE) {
+		if (unlikely(!ctx->user_files ||
+		    (unsigned) fd >= ctx->user_files->count))
+			return -EBADF;
+		kiocb->ki_filp = ctx->user_files->fp[fd];
+		req->flags |= REQ_F_FIXED_FILE;
+	} else {
+		kiocb->ki_filp = io_file_get(state, fd);
+		if (unlikely(!kiocb->ki_filp))
+			return -EBADF;
+		if (force_nonblock && !io_file_supports_async(kiocb->ki_filp))
+			force_nonblock = false;
+	}
 	kiocb->ki_pos = READ_ONCE(sqe->off);
 	kiocb->ki_flags = iocb_flags(kiocb->ki_filp);
 	kiocb->ki_hint = ki_hint_validate(file_write_hint(kiocb->ki_filp));
@@ -688,10 +715,14 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	}
 	return 0;
 out_fput:
-	/* in case of error, we didn't use this file reference. drop it. */
-	if (state)
-		state->used_refs--;
-	io_file_put(state, kiocb->ki_filp);
+	if (!(flags & IOSQE_FIXED_FILE)) {
+		/*
+		 * in case of error, we didn't use this file reference. drop it.
+		 */
+		if (state)
+			state->used_refs--;
+		io_file_put(state, kiocb->ki_filp);
+	}
 	return ret;
 }
 
@@ -823,7 +854,7 @@ static ssize_t io_read(struct io_kiocb *req, const struct sqe_submit *s,
 out_fput:
 	/* Hold on to the file for -EAGAIN */
 	if (unlikely(ret && ret != -EAGAIN))
-		fput(file);
+		io_fput(req);
 	return ret;
 }
 
@@ -877,7 +908,7 @@ static ssize_t io_write(struct io_kiocb *req, const struct sqe_submit *s,
 	kfree(iovec);
 out_fput:
 	if (unlikely(ret))
-		fput(file);
+		io_fput(req);
 	return ret;
 }
 
@@ -903,7 +934,7 @@ static int io_fsync(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	loff_t sqe_off = READ_ONCE(sqe->off);
 	loff_t sqe_len = READ_ONCE(sqe->len);
 	loff_t end = sqe_off + sqe_len;
-	unsigned fsync_flags;
+	unsigned fsync_flags, flags;
 	struct file *file;
 	int ret, fd;
 
@@ -921,14 +952,23 @@ static int io_fsync(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		return -EINVAL;
 
 	fd = READ_ONCE(sqe->fd);
-	file = fget(fd);
+	flags = READ_ONCE(sqe->flags);
+
+	if (flags & IOSQE_FIXED_FILE) {
+		if (unlikely(!ctx->user_files || fd >= ctx->user_files->count))
+			return -EBADF;
+		file = ctx->user_files->fp[fd];
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
@@ -1065,7 +1105,7 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, const struct sqe_submit *s,
 	ssize_t ret;
 
 	/* enforce forwards compatibility on users */
-	if (unlikely(s->sqe->flags))
+	if (unlikely(s->sqe->flags & ~IOSQE_FIXED_FILE))
 		return -EINVAL;
 
 	req = io_get_req(ctx, state);
@@ -1253,6 +1293,104 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	return ring->r.head == ring->r.tail ? ret : 0;
 }
 
+static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
+{
+#if defined(CONFIG_NET)
+	if (ctx->ring_sock) {
+		struct sock *sock = ctx->ring_sock->sk;
+		struct sk_buff *skb;
+
+		while ((skb = skb_dequeue(&sock->sk_receive_queue)) != NULL)
+			kfree_skb(skb);
+	}
+#else
+	int i;
+
+	for (i = 0; i < ctx->user_files->count; i++)
+		fput(ctx->user_files->fp[i]);
+
+	kfree(ctx->user_files);
+#endif
+}
+
+static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
+{
+	if (!ctx->user_files)
+		return -ENXIO;
+
+	__io_sqe_files_unregister(ctx);
+	ctx->user_files = NULL;
+	return 0;
+}
+
+static int io_sqe_files_scm(struct io_ring_ctx *ctx)
+{
+#if defined(CONFIG_NET)
+	struct scm_fp_list *fpl = ctx->user_files;
+	struct sk_buff *skb;
+	int i;
+
+	skb =  __alloc_skb(0, GFP_KERNEL, 0, NUMA_NO_NODE);
+	if (!skb)
+		return -ENOMEM;
+
+	skb->sk = ctx->ring_sock->sk;
+	skb->destructor = unix_destruct_scm;
+
+	fpl->user = get_uid(ctx->user);
+	for (i = 0; i < fpl->count; i++) {
+		get_file(fpl->fp[i]);
+		unix_inflight(fpl->user, fpl->fp[i]);
+		fput(fpl->fp[i]);
+	}
+
+	UNIXCB(skb).fp = fpl;
+	skb_queue_head(&ctx->ring_sock->sk->sk_receive_queue, skb);
+#endif
+	return 0;
+}
+
+static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
+				 unsigned nr_args)
+{
+	__s32 __user *fds = (__s32 __user *) arg;
+	struct scm_fp_list *fpl;
+	int fd, ret = 0;
+	unsigned i;
+
+	if (ctx->user_files)
+		return -EBUSY;
+	if (!nr_args || nr_args > SCM_MAX_FD)
+		return -EINVAL;
+
+	fpl = kzalloc(sizeof(*ctx->user_files), GFP_KERNEL);
+	if (!fpl)
+		return -ENOMEM;
+	fpl->max = nr_args;
+
+	for (i = 0; i < nr_args; i++) {
+		ret = -EFAULT;
+		if (copy_from_user(&fd, &fds[i], sizeof(fd)))
+			break;
+
+		fpl->fp[i] = fget(fd);
+
+		ret = -EBADF;
+		if (!fpl->fp[i])
+			break;
+		fpl->count++;
+		ret = 0;
+	}
+
+	ctx->user_files = fpl;
+	if (!ret)
+		ret = io_sqe_files_scm(ctx);
+	if (ret)
+		io_sqe_files_unregister(ctx);
+
+	return ret;
+}
+
 static int io_sq_offload_start(struct io_ring_ctx *ctx)
 {
 	int ret;
@@ -1520,14 +1658,16 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		destroy_workqueue(ctx->sqo_wq);
 	if (ctx->sqo_mm)
 		mmdrop(ctx->sqo_mm);
+
+	io_iopoll_reap_events(ctx);
+	io_sqe_buffer_unregister(ctx);
+	io_sqe_files_unregister(ctx);
+
 #if defined(CONFIG_NET)
 	if (ctx->ring_sock)
 		sock_release(ctx->ring_sock);
 #endif
 
-	io_iopoll_reap_events(ctx);
-	io_sqe_buffer_unregister(ctx);
-
 	io_mem_free(ctx->sq_ring);
 	io_mem_free(ctx->sq_sqes);
 	io_mem_free(ctx->cq_ring);
@@ -1885,6 +2025,15 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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
diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index ddbba838d048..3426d6dacc45 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -10,6 +10,7 @@
 
 void unix_inflight(struct user_struct *user, struct file *fp);
 void unix_notinflight(struct user_struct *user, struct file *fp);
+void unix_destruct_scm(struct sk_buff *skb);
 void unix_gc(void);
 void wait_for_unix_gc(void);
 struct sock *unix_get_socket(struct file *filp);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index cf28f7a11f12..6257478d55e9 100644
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
@@ -113,5 +118,7 @@ struct io_uring_params {
  */
 #define IORING_REGISTER_BUFFERS		0
 #define IORING_UNREGISTER_BUFFERS	1
+#define IORING_REGISTER_FILES		2
+#define IORING_UNREGISTER_FILES		3
 
 #endif
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 74d1eed7cbd4..9b1bbf74c4ea 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1497,7 +1497,7 @@ static void unix_detach_fds(struct scm_cookie *scm, struct sk_buff *skb)
 		unix_notinflight(scm->fp->user, scm->fp->fp[i]);
 }
 
-static void unix_destruct_scm(struct sk_buff *skb)
+void unix_destruct_scm(struct sk_buff *skb)
 {
 	struct scm_cookie scm;
 	memset(&scm, 0, sizeof(scm));
-- 
2.17.1

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
