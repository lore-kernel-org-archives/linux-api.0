From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 14/19] io_uring: add file set registration
Date: Sat,  9 Feb 2019 14:13:41 -0700
Message-ID: <20190209211346.26060-15-axboe@kernel.dk>
References: <20190209211346.26060-1-axboe@kernel.dk>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190209211346.26060-1-axboe@kernel.dk>
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
duration of the io_uring instance (or until IORING_UNREGISTER_FILES is
called).

When used, the application must set IOSQE_FIXED_FILE in the sqe->flags
member. Then, instead of setting sqe->fd to the real fd, it sets sqe->fd
to the index in the array passed in to IORING_REGISTER_FILES.

Files are automatically unregistered when the io_uring instance is torn
down. An application need only unregister if it wishes to register a new
set of fds.

Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 269 ++++++++++++++++++++++++++++++----
 include/uapi/linux/io_uring.h |   9 +-
 2 files changed, 245 insertions(+), 33 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 09a3122b3b6c..c40a7ed2edd5 100644
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
@@ -41,6 +42,7 @@
 #include "internal.h"
 
 #define IORING_MAX_ENTRIES	4096
+#define IORING_MAX_FIXED_FILES	1024
 
 struct io_uring {
 	u32 head ____cacheline_aligned_in_smp;
@@ -103,6 +105,14 @@ struct io_ring_ctx {
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
@@ -150,6 +160,7 @@ struct io_kiocb {
 	unsigned int		flags;
 #define REQ_F_FORCE_NONBLOCK	1	/* inline submission attempt */
 #define REQ_F_IOPOLL_COMPLETED	2	/* polled IO has completed */
+#define REQ_F_FIXED_FILE	4	/* ctx owns file */
 	u64			user_data;
 	u64			error;
 
@@ -380,15 +391,17 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
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
@@ -520,13 +533,19 @@ static void kiocb_end_write(struct kiocb *kiocb)
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
@@ -642,19 +661,29 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
+		    (unsigned) fd >= ctx->nr_user_files))
+			return -EBADF;
+		kiocb->ki_filp = ctx->user_files[fd];
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
@@ -694,10 +723,14 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
 
@@ -837,7 +870,7 @@ static ssize_t io_read(struct io_kiocb *req, const struct sqe_submit *s,
 out_fput:
 	/* Hold on to the file for -EAGAIN */
 	if (unlikely(ret && ret != -EAGAIN))
-		fput(file);
+		io_fput(req);
 	return ret;
 }
 
@@ -891,7 +924,7 @@ static ssize_t io_write(struct io_kiocb *req, const struct sqe_submit *s,
 	kfree(iovec);
 out_fput:
 	if (unlikely(ret))
-		fput(file);
+		io_fput(req);
 	return ret;
 }
 
@@ -914,7 +947,8 @@ static int io_nop(struct io_kiocb *req, u64 user_data)
 	 */
 	if (req->rw.ki_filp) {
 		err = -EBADF;
-		fput(req->rw.ki_filp);
+		if (!(req->flags & REQ_F_FIXED_FILE))
+			fput(req->rw.ki_filp);
 	}
 	io_cqring_add_event(ctx, user_data, err, 0);
 	io_free_req(req);
@@ -923,21 +957,32 @@ static int io_nop(struct io_kiocb *req, u64 user_data)
 
 static int io_prep_fsync(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
+	struct io_ring_ctx *ctx = req->ctx;
+	unsigned flags;
 	int fd;
 
 	/* Prep already done */
 	if (req->rw.ki_filp)
 		return 0;
 
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index))
 		return -EINVAL;
 
 	fd = READ_ONCE(sqe->fd);
-	req->rw.ki_filp = fget(fd);
-	if (unlikely(!req->rw.ki_filp))
-		return -EBADF;
+	flags = READ_ONCE(sqe->flags);
+
+	if (flags & IOSQE_FIXED_FILE) {
+		if (unlikely(!ctx->user_files || fd >= ctx->nr_user_files))
+			return -EBADF;
+		req->rw.ki_filp = ctx->user_files[fd];
+		req->flags |= REQ_F_FIXED_FILE;
+	} else {
+		req->rw.ki_filp = fget(fd);
+		if (unlikely(!req->rw.ki_filp))
+			return -EBADF;
+	}
 
 	return 0;
 }
@@ -967,7 +1012,8 @@ static int io_fsync(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 				end > 0 ? end : LLONG_MAX,
 				fsync_flags & IORING_FSYNC_DATASYNC);
 
-	fput(req->rw.ki_filp);
+	if (!(req->flags & REQ_F_FIXED_FILE))
+		fput(req->rw.ki_filp);
 	io_cqring_add_event(req->ctx, sqe->user_data, ret, 0);
 	io_free_req(req);
 	return 0;
@@ -1104,7 +1150,7 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, const struct sqe_submit *s,
 	ssize_t ret;
 
 	/* enforce forwards compatibility on users */
-	if (unlikely(s->sqe->flags))
+	if (unlikely(s->sqe->flags & ~IOSQE_FIXED_FILE))
 		return -EINVAL;
 
 	req = io_get_req(ctx, state);
@@ -1292,6 +1338,154 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	return READ_ONCE(ring->r.head) == READ_ONCE(ring->r.tail) ? ret : 0;
 }
 
+static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
+{
+#if defined(CONFIG_UNIX)
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
+	for (i = 0; i < ctx->nr_user_files; i++)
+		fput(ctx->user_files[i]);
+#endif
+}
+
+static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
+{
+	if (!ctx->user_files)
+		return -ENXIO;
+
+	__io_sqe_files_unregister(ctx);
+	kfree(ctx->user_files);
+	ctx->user_files = NULL;
+	return 0;
+}
+
+#if defined(CONFIG_UNIX)
+static int __io_sqe_files_scm(struct io_ring_ctx *ctx, int nr, int offset)
+{
+	struct scm_fp_list *fpl;
+	struct sk_buff *skb;
+	int i;
+
+	fpl = kzalloc(sizeof(*fpl), GFP_KERNEL);
+	if (!fpl)
+		return -ENOMEM;
+
+	skb = alloc_skb(0, GFP_KERNEL);
+	if (!skb) {
+		kfree(fpl);
+		return -ENOMEM;
+	}
+
+	skb->sk = ctx->ring_sock->sk;
+	skb->destructor = unix_destruct_scm;
+
+	fpl->user = get_uid(ctx->user);
+	for (i = 0; i < nr; i++) {
+		fpl->fp[i] = get_file(ctx->user_files[i + offset]);
+		unix_inflight(fpl->user, fpl->fp[i]);
+	}
+
+	fpl->max = fpl->count = nr;
+	UNIXCB(skb).fp = fpl;
+	skb_queue_head(&ctx->ring_sock->sk->sk_receive_queue, skb);
+
+	for (i = 0; i < nr; i++)
+		fput(fpl->fp[i]);
+
+	return 0;
+}
+
+/*
+ * If UNIX sockets are enabled, fd passing can cause a reference cycle which
+ * causes regular reference counting to break down. We rely on the UNIX
+ * garbage collection to take care of this problem for us.
+ */
+static int io_sqe_files_scm(struct io_ring_ctx *ctx)
+{
+	unsigned left, total;
+	int ret = 0;
+
+	total = 0;
+	left = ctx->nr_user_files;
+	while (left) {
+		unsigned this_files = min_t(unsigned, left, SCM_MAX_FD);
+		int ret;
+
+		ret = __io_sqe_files_scm(ctx, this_files, total);
+		if (ret)
+			break;
+		left -= this_files;
+		total += this_files;
+	}
+
+	return ret;
+}
+#else
+static int io_sqe_files_scm(struct io_ring_ctx *ctx)
+{
+	return 0;
+}
+#endif
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
+	if (nr_args > IORING_MAX_FIXED_FILES)
+		return -EMFILE;
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
+		/*
+		 * Don't allow io_uring instances to be registered. If UNIX
+		 * isn't enabled, then this causes a reference cycle and this
+		 * instance can never get freed. If UNIX is enabled we'll
+		 * handle it just fine, but there's still no point in allowing
+		 * a ring fd as it doesn't support regular read/write anyway.
+		 */
+		if (ctx->user_files[i]->f_op == &io_uring_fops) {
+			fput(ctx->user_files[i]);
+			break;
+		}
+		ctx->nr_user_files++;
+		ret = 0;
+	}
+
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
@@ -1560,14 +1754,16 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		destroy_workqueue(ctx->sqo_wq);
 	if (ctx->sqo_mm)
 		mmdrop(ctx->sqo_mm);
+
+	io_iopoll_reap_events(ctx);
+	io_sqe_buffer_unregister(ctx);
+	io_sqe_files_unregister(ctx);
+
 #if defined(CONFIG_UNIX)
 	if (ctx->ring_sock)
 		sock_release(ctx->ring_sock);
 #endif
 
-	io_iopoll_reap_events(ctx);
-	io_sqe_buffer_unregister(ctx);
-
 	io_mem_free(ctx->sq_ring);
 	io_mem_free(ctx->sq_sqes);
 	io_mem_free(ctx->cq_ring);
@@ -1934,6 +2130,15 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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
-- 
2.17.1

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
