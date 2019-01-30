From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 05/18] Add io_uring IO interface
Date: Wed, 30 Jan 2019 14:55:27 -0700
Message-ID: <20190130215540.20871-6-axboe@kernel.dk>
References: <20190130215540.20871-1-axboe@kernel.dk>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190130215540.20871-1-axboe@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, Jens Axboe <axboe@kernel.dk>
List-Id: linux-api@vger.kernel.org

The submission queue (SQ) and completion queue (CQ) rings are shared
between the application and the kernel. This eliminates the need to
copy data back and forth to submit and complete IO.

IO submissions use the io_uring_sqe data structure, and completions
are generated in the form of io_uring_sqe data structures. The SQ
ring is an index into the io_uring_sqe array, which makes it possible
to submit a batch of IOs without them being contiguous in the ring.
The CQ ring is always contiguous, as completion events are inherently
unordered, and hence any io_uring_cqe entry can point back to an
arbitrary submission.

Two new system calls are added for this:

io_uring_setup(entries, params)
	Sets up a context for doing async IO. On success, returns a file
	descriptor that the application can mmap to gain access to the
	SQ ring, CQ ring, and io_uring_sqes.

io_uring_enter(fd, to_submit, min_complete, flags, sigset, sigsetsize)
	Initiates IO against the rings mapped to this fd, or waits for
	them to complete, or both. The behavior is controlled by the
	parameters passed in. If 'to_submit' is non-zero, then we'll
	try and submit new IO. If IORING_ENTER_GETEVENTS is set, the
	kernel will wait for 'min_complete' events, if they aren't
	already available. It's valid to set IORING_ENTER_GETEVENTS
	and 'min_complete' == 0 at the same time, this allows the
	kernel to return already completed events without waiting
	for them. This is useful only for polling, as for IRQ
	driven IO, the application can just check the CQ ring
	without entering the kernel.

With this setup, it's possible to do async IO with a single system
call. Future developments will enable polled IO with this interface,
and polled submission as well. The latter will enable an application
to do IO without doing ANY system calls at all.

For IRQ driven IO, an application only needs to enter the kernel for
completions if it wants to wait for them to occur.

Each io_uring is backed by a workqueue, to support buffered async IO
as well. We will only punt to an async context if the command would
need to wait for IO on the device side. Any data that can be accessed
directly in the page cache is done inline. This avoids the slowness
issue of usual threadpools, since cached data is accessed as quickly
as a sync interface.

Sample application: http://git.kernel.dk/cgit/fio/plain/t/io_uring.c

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 arch/x86/entry/syscalls/syscall_32.tbl |    2 +
 arch/x86/entry/syscalls/syscall_64.tbl |    2 +
 fs/Makefile                            |    1 +
 fs/io_uring.c                          | 1122 ++++++++++++++++++++++++
 include/linux/syscalls.h               |    6 +
 include/uapi/asm-generic/unistd.h      |    6 +-
 include/uapi/linux/io_uring.h          |   94 ++
 init/Kconfig                           |    9 +
 kernel/sys_ni.c                        |    2 +
 9 files changed, 1243 insertions(+), 1 deletion(-)
 create mode 100644 fs/io_uring.c
 create mode 100644 include/uapi/linux/io_uring.h

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 3cf7b533b3d1..481c126259e9 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -398,3 +398,5 @@
 384	i386	arch_prctl		sys_arch_prctl			__ia32_compat_sys_arch_prctl
 385	i386	io_pgetevents		sys_io_pgetevents		__ia32_compat_sys_io_pgetevents
 386	i386	rseq			sys_rseq			__ia32_sys_rseq
+425	i386	io_uring_setup		sys_io_uring_setup		__ia32_sys_io_uring_setup
+426	i386	io_uring_enter		sys_io_uring_enter		__ia32_sys_io_uring_enter
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index f0b1709a5ffb..6a32a430c8e0 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -343,6 +343,8 @@
 332	common	statx			__x64_sys_statx
 333	common	io_pgetevents		__x64_sys_io_pgetevents
 334	common	rseq			__x64_sys_rseq
+425	common	io_uring_setup		__x64_sys_io_uring_setup
+426	common	io_uring_enter		__x64_sys_io_uring_enter
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/fs/Makefile b/fs/Makefile
index 293733f61594..8e15d6fc4340 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_TIMERFD)		+= timerfd.o
 obj-$(CONFIG_EVENTFD)		+= eventfd.o
 obj-$(CONFIG_USERFAULTFD)	+= userfaultfd.o
 obj-$(CONFIG_AIO)               += aio.o
+obj-$(CONFIG_IO_URING)		+= io_uring.o
 obj-$(CONFIG_FS_DAX)		+= dax.o
 obj-$(CONFIG_FS_ENCRYPTION)	+= crypto/
 obj-$(CONFIG_FILE_LOCKING)      += locks.o
diff --git a/fs/io_uring.c b/fs/io_uring.c
new file mode 100644
index 000000000000..356a697ee21c
--- /dev/null
+++ b/fs/io_uring.c
@@ -0,0 +1,1122 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Shared application/kernel submission and completion ring pairs, for
+ * supporting fast/efficient IO.
+ *
+ * Copyright (C) 2018-2019 Jens Axboe
+ */
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/syscalls.h>
+#include <linux/compat.h>
+#include <linux/refcount.h>
+#include <linux/uio.h>
+
+#include <linux/sched/signal.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+#include <linux/fdtable.h>
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/mmu_context.h>
+#include <linux/percpu.h>
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+#include <linux/blkdev.h>
+#include <linux/anon_inodes.h>
+#include <linux/sched/mm.h>
+#include <linux/uaccess.h>
+#include <linux/nospec.h>
+
+#include <uapi/linux/io_uring.h>
+
+#include "internal.h"
+
+#define IORING_MAX_ENTRIES	4096
+
+struct io_uring {
+	u32 head ____cacheline_aligned_in_smp;
+	u32 tail ____cacheline_aligned_in_smp;
+};
+
+struct io_sq_ring {
+	struct io_uring		r;
+	u32			ring_mask;
+	u32			ring_entries;
+	u32			dropped;
+	u32			flags;
+	u32			array[];
+};
+
+struct io_cq_ring {
+	struct io_uring		r;
+	u32			ring_mask;
+	u32			ring_entries;
+	u32			overflow;
+	struct io_uring_cqe	cqes[];
+};
+
+struct io_ring_ctx {
+	struct {
+		struct percpu_ref	refs;
+	} ____cacheline_aligned_in_smp;
+
+	struct {
+		unsigned int		flags;
+		bool			compat;
+
+		/* SQ ring */
+		struct io_sq_ring	*sq_ring;
+		unsigned		cached_sq_head;
+		unsigned		sq_entries;
+		unsigned		sq_mask;
+		unsigned		sq_thread_cpu;
+		struct io_uring_sqe	*sq_sqes;
+	} ____cacheline_aligned_in_smp;
+
+	/* IO offload */
+	struct workqueue_struct	*sqo_wq;
+	struct mm_struct	*sqo_mm;
+	struct files_struct	*sqo_files;
+
+	struct {
+		/* CQ ring */
+		struct io_cq_ring	*cq_ring;
+		unsigned		cached_cq_tail;
+		unsigned		cq_entries;
+		unsigned		cq_mask;
+		struct wait_queue_head	cq_wait;
+		struct fasync_struct	*cq_fasync;
+	} ____cacheline_aligned_in_smp;
+
+	struct user_struct	*user;
+
+	struct completion	ctx_done;
+
+	struct {
+		struct mutex		uring_lock;
+		wait_queue_head_t	wait;
+	} ____cacheline_aligned_in_smp;
+
+	struct {
+		spinlock_t		completion_lock;
+	} ____cacheline_aligned_in_smp;
+};
+
+struct sqe_submit {
+	const struct io_uring_sqe	*sqe;
+	unsigned short			index;
+	bool				has_user;
+};
+
+struct io_kiocb {
+	struct kiocb		rw;
+
+	struct sqe_submit	submit;
+
+	struct io_ring_ctx	*ctx;
+	struct list_head	list;
+	unsigned int		flags;
+#define REQ_F_FORCE_NONBLOCK	1	/* inline submission attempt */
+	u64			user_data;
+
+	struct work_struct	work;
+};
+
+#define IO_PLUG_THRESHOLD		2
+
+static struct kmem_cache *req_cachep;
+
+static const struct file_operations io_uring_fops;
+
+static void io_ring_ctx_ref_free(struct percpu_ref *ref)
+{
+	struct io_ring_ctx *ctx = container_of(ref, struct io_ring_ctx, refs);
+
+	complete(&ctx->ctx_done);
+}
+
+static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
+{
+	struct io_ring_ctx *ctx;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return NULL;
+
+	if (percpu_ref_init(&ctx->refs, io_ring_ctx_ref_free, 0, GFP_KERNEL)) {
+		kfree(ctx);
+		return NULL;
+	}
+
+	ctx->flags = p->flags;
+	init_waitqueue_head(&ctx->cq_wait);
+	init_completion(&ctx->ctx_done);
+	mutex_init(&ctx->uring_lock);
+	init_waitqueue_head(&ctx->wait);
+	spin_lock_init(&ctx->completion_lock);
+	return ctx;
+}
+
+static void io_commit_cqring(struct io_ring_ctx *ctx)
+{
+	struct io_cq_ring *ring = ctx->cq_ring;
+
+	if (ctx->cached_cq_tail != ring->r.tail) {
+		/* order cqe stores with ring update */
+		smp_wmb();
+		WRITE_ONCE(ring->r.tail, ctx->cached_cq_tail);
+		/* write side barrier of tail update, app has read side */
+		smp_wmb();
+
+		if (wq_has_sleeper(&ctx->cq_wait)) {
+			wake_up_interruptible(&ctx->cq_wait);
+			kill_fasync(&ctx->cq_fasync, SIGIO, POLL_IN);
+		}
+	}
+}
+
+static struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx)
+{
+	struct io_cq_ring *ring = ctx->cq_ring;
+	unsigned tail;
+
+	tail = ctx->cached_cq_tail;
+	smp_rmb();
+	if (tail + 1 == READ_ONCE(ring->r.head))
+		return NULL;
+
+	ctx->cached_cq_tail++;
+	return &ring->cqes[tail & ctx->cq_mask];
+}
+
+static void io_cqring_fill_event(struct io_ring_ctx *ctx, u64 ki_user_data,
+				 long res, unsigned ev_flags)
+{
+	struct io_uring_cqe *cqe;
+
+	/*
+	 * If we can't get a cq entry, userspace overflowed the
+	 * submission (by quite a lot). Increment the overflow count in
+	 * the ring.
+	 */
+	cqe = io_get_cqring(ctx);
+	if (cqe) {
+		cqe->user_data = ki_user_data;
+		cqe->res = res;
+		cqe->flags = ev_flags;
+	} else
+		ctx->cq_ring->overflow++;
+}
+
+static void io_cqring_add_event(struct io_ring_ctx *ctx, u64 ki_user_data,
+				long res, unsigned ev_flags)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->completion_lock, flags);
+	io_cqring_fill_event(ctx, ki_user_data, res, ev_flags);
+	io_commit_cqring(ctx);
+	spin_unlock_irqrestore(&ctx->completion_lock, flags);
+
+	if (waitqueue_active(&ctx->wait))
+		wake_up(&ctx->wait);
+}
+
+static void io_ring_drop_ctx_refs(struct io_ring_ctx *ctx, unsigned refs)
+{
+	percpu_ref_put_many(&ctx->refs, refs);
+
+	if (waitqueue_active(&ctx->wait))
+		wake_up(&ctx->wait);
+}
+
+static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx)
+{
+	struct io_kiocb *req;
+
+	if (!percpu_ref_tryget(&ctx->refs))
+		return NULL;
+
+	req = kmem_cache_alloc(req_cachep, __GFP_NOWARN);
+	if (req) {
+		req->ctx = ctx;
+		req->flags = 0;
+		return req;
+	}
+
+	io_ring_drop_ctx_refs(ctx, 1);
+	return NULL;
+}
+
+static void io_free_req(struct io_kiocb *req)
+{
+	io_ring_drop_ctx_refs(req->ctx, 1);
+	kmem_cache_free(req_cachep, req);
+}
+
+static void kiocb_end_write(struct kiocb *kiocb)
+{
+	if (kiocb->ki_flags & IOCB_WRITE) {
+		struct inode *inode = file_inode(kiocb->ki_filp);
+
+		/*
+		 * Tell lockdep we inherited freeze protection from submission
+		 * thread.
+		 */
+		if (S_ISREG(inode->i_mode))
+			__sb_writers_acquired(inode->i_sb, SB_FREEZE_WRITE);
+		file_end_write(kiocb->ki_filp);
+	}
+}
+
+static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
+{
+	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw);
+
+	kiocb_end_write(kiocb);
+
+	fput(kiocb->ki_filp);
+	io_cqring_add_event(req->ctx, req->user_data, res, 0);
+	io_free_req(req);
+}
+
+static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+		      bool force_nonblock)
+{
+	struct kiocb *kiocb = &req->rw;
+	unsigned ioprio;
+	int fd, ret;
+
+	fd = READ_ONCE(sqe->fd);
+	kiocb->ki_filp = fget(fd);
+	if (unlikely(!kiocb->ki_filp))
+		return -EBADF;
+	kiocb->ki_pos = READ_ONCE(sqe->off);
+	kiocb->ki_flags = iocb_flags(kiocb->ki_filp);
+	kiocb->ki_hint = ki_hint_validate(file_write_hint(kiocb->ki_filp));
+
+	ioprio = READ_ONCE(sqe->ioprio);
+	if (ioprio) {
+		ret = ioprio_check_cap(ioprio);
+		if (ret)
+			goto out_fput;
+
+		kiocb->ki_ioprio = ioprio;
+	} else
+		kiocb->ki_ioprio = get_current_ioprio();
+
+	ret = kiocb_set_rw_flags(kiocb, READ_ONCE(sqe->rw_flags));
+	if (unlikely(ret))
+		goto out_fput;
+	if (force_nonblock) {
+		kiocb->ki_flags |= IOCB_NOWAIT;
+		req->flags |= REQ_F_FORCE_NONBLOCK;
+	}
+	if (kiocb->ki_flags & IOCB_HIPRI) {
+		ret = -EINVAL;
+		goto out_fput;
+	}
+
+	kiocb->ki_complete = io_complete_rw;
+	return 0;
+out_fput:
+	fput(kiocb->ki_filp);
+	return ret;
+}
+
+static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
+{
+	switch (ret) {
+	case -EIOCBQUEUED:
+		break;
+	case -ERESTARTSYS:
+	case -ERESTARTNOINTR:
+	case -ERESTARTNOHAND:
+	case -ERESTART_RESTARTBLOCK:
+		/*
+		 * We can't just restart the syscall, since previously
+		 * submitted sqes may already be in progress. Just fail this
+		 * IO with EINTR.
+		 */
+		ret = -EINTR;
+		/* fall through */
+	default:
+		kiocb->ki_complete(kiocb, ret, 0);
+	}
+}
+
+static int io_import_iovec(struct io_ring_ctx *ctx, int rw,
+			   const struct sqe_submit *s, struct iovec **iovec,
+			   struct iov_iter *iter)
+{
+	const struct io_uring_sqe *sqe = s->sqe;
+	void __user *buf = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	size_t sqe_len = READ_ONCE(sqe->len);
+
+	if (!s->has_user)
+		return EFAULT;
+
+#ifdef CONFIG_COMPAT
+	if (ctx->compat)
+		return compat_import_iovec(rw, buf, sqe_len, UIO_FASTIOV,
+						iovec, iter);
+#endif
+
+	return import_iovec(rw, buf, sqe_len, UIO_FASTIOV, iovec, iter);
+}
+
+static ssize_t io_read(struct io_kiocb *req, const struct sqe_submit *s,
+		       bool force_nonblock)
+{
+	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
+	struct kiocb *kiocb = &req->rw;
+	struct iov_iter iter;
+	struct file *file;
+	ssize_t ret;
+
+	ret = io_prep_rw(req, s->sqe, force_nonblock);
+	if (ret)
+		return ret;
+	file = kiocb->ki_filp;
+
+	ret = -EBADF;
+	if (unlikely(!(file->f_mode & FMODE_READ)))
+		goto out_fput;
+	ret = -EINVAL;
+	if (unlikely(!file->f_op->read_iter))
+		goto out_fput;
+
+	ret = io_import_iovec(req->ctx, READ, s, &iovec, &iter);
+	if (ret)
+		goto out_fput;
+
+	ret = rw_verify_area(READ, file, &kiocb->ki_pos, iov_iter_count(&iter));
+	if (!ret) {
+		ssize_t ret2;
+
+		/* Catch -EAGAIN return for forced non-blocking submission */
+		ret2 = call_read_iter(file, kiocb, &iter);
+		if (!force_nonblock || ret2 != -EAGAIN)
+			io_rw_done(kiocb, ret2);
+		else
+			ret = -EAGAIN;
+	}
+	kfree(iovec);
+out_fput:
+	if (unlikely(ret))
+		fput(file);
+	return ret;
+}
+
+static ssize_t io_write(struct io_kiocb *req, const struct sqe_submit *s,
+			bool force_nonblock)
+{
+	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
+	struct kiocb *kiocb = &req->rw;
+	struct iov_iter iter;
+	struct file *file;
+	ssize_t ret;
+
+	ret = io_prep_rw(req, s->sqe, force_nonblock);
+	if (ret)
+		return ret;
+	file = kiocb->ki_filp;
+
+	ret = -EAGAIN;
+	if (force_nonblock && !(kiocb->ki_flags & IOCB_DIRECT))
+		goto out_fput;
+
+	ret = -EBADF;
+	if (unlikely(!(file->f_mode & FMODE_WRITE)))
+		goto out_fput;
+	ret = -EINVAL;
+	if (unlikely(!file->f_op->write_iter))
+		goto out_fput;
+
+	ret = io_import_iovec(req->ctx, WRITE, s, &iovec, &iter);
+	if (ret)
+		goto out_fput;
+
+	ret = rw_verify_area(WRITE, file, &kiocb->ki_pos,
+				iov_iter_count(&iter));
+	if (!ret) {
+		/*
+		 * Open-code file_start_write here to grab freeze protection,
+		 * which will be released by another thread in
+		 * io_complete_rw().  Fool lockdep by telling it the lock got
+		 * released so that it doesn't complain about the held lock when
+		 * we return to userspace.
+		 */
+		if (S_ISREG(file_inode(file)->i_mode)) {
+			__sb_start_write(file_inode(file)->i_sb,
+						SB_FREEZE_WRITE, true);
+			__sb_writers_release(file_inode(file)->i_sb,
+						SB_FREEZE_WRITE);
+		}
+		kiocb->ki_flags |= IOCB_WRITE;
+		io_rw_done(kiocb, call_write_iter(file, kiocb, &iter));
+	}
+	kfree(iovec);
+out_fput:
+	if (unlikely(ret))
+		fput(file);
+	return ret;
+}
+
+/*
+ * IORING_OP_NOP just posts a completion event, nothing else.
+ */
+static int io_nop(struct io_kiocb *req, u64 user_data)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	io_cqring_add_event(ctx, user_data, 0, 0);
+	io_free_req(req);
+	return 0;
+}
+
+static int __io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
+			   const struct sqe_submit *s, bool force_nonblock)
+{
+	ssize_t ret;
+	int opcode;
+
+	if (unlikely(s->index >= ctx->sq_entries))
+		return -EINVAL;
+	req->user_data = READ_ONCE(s->sqe->user_data);
+
+	opcode = READ_ONCE(s->sqe->opcode);
+	switch (opcode) {
+	case IORING_OP_NOP:
+		ret = io_nop(req, req->user_data);
+		break;
+	case IORING_OP_READV:
+		ret = io_read(req, s, force_nonblock);
+		break;
+	case IORING_OP_WRITEV:
+		ret = io_write(req, s, force_nonblock);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static void io_sq_wq_submit_work(struct work_struct *work)
+{
+	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+	struct sqe_submit *s = &req->submit;
+	u64 user_data = READ_ONCE(s->sqe->user_data);
+	struct io_ring_ctx *ctx = req->ctx;
+	mm_segment_t old_fs = get_fs();
+	struct files_struct *old_files;
+	int ret;
+
+	 /* Ensure we clear previously set forced non-block flag */
+	req->flags &= ~REQ_F_FORCE_NONBLOCK;
+
+	task_lock(current);
+	old_files = current->files;
+	current->files = ctx->sqo_files;
+	task_unlock(current);
+
+	if (!mmget_not_zero(ctx->sqo_mm)) {
+		ret = -EFAULT;
+		goto err;
+	}
+
+	use_mm(ctx->sqo_mm);
+	set_fs(USER_DS);
+
+	ret = __io_submit_sqe(ctx, req, s, false);
+
+	set_fs(old_fs);
+	unuse_mm(ctx->sqo_mm);
+	mmput(ctx->sqo_mm);
+err:
+	if (ret) {
+		io_cqring_add_event(ctx, user_data, ret, 0);
+		io_free_req(req);
+	}
+
+	task_lock(current);
+	current->files = old_files;
+	task_unlock(current);
+}
+
+static int io_submit_sqe(struct io_ring_ctx *ctx, const struct sqe_submit *s)
+{
+	struct io_kiocb *req;
+	ssize_t ret;
+
+	/* enforce forwards compatibility on users */
+	if (unlikely(s->sqe->flags))
+		return -EINVAL;
+
+	req = io_get_req(ctx);
+	if (unlikely(!req))
+		return -EAGAIN;
+
+	ret = __io_submit_sqe(ctx, req, s, true);
+	if (ret == -EAGAIN) {
+		memcpy(&req->submit, s, sizeof(*s));
+		INIT_WORK(&req->work, io_sq_wq_submit_work);
+		queue_work(ctx->sqo_wq, &req->work);
+		ret = 0;
+	}
+	if (ret)
+		io_free_req(req);
+
+	return ret;
+}
+
+static void io_commit_sqring(struct io_ring_ctx *ctx)
+{
+	struct io_sq_ring *ring = ctx->sq_ring;
+
+	if (ctx->cached_sq_head != ring->r.head) {
+		WRITE_ONCE(ring->r.head, ctx->cached_sq_head);
+		/* write side barrier of head update, app has read side */
+		smp_wmb();
+	}
+}
+
+/*
+ * Undo last io_get_sqring()
+ */
+static void io_drop_sqring(struct io_ring_ctx *ctx)
+{
+	ctx->cached_sq_head--;
+}
+
+/*
+ * Fetch an sqe, if one is available. Note that s->sqe will point to memory
+ * that is mapped by userspace. This means that care needs to be taken to
+ * ensure that reads are stable, as we cannot rely on userspace always
+ * being a good citizen. If members of the sqe are validated and then later
+ * used, it's important that those reads are done through READ_ONCE() to
+ * prevent a re-load down the line.
+ */
+static bool io_get_sqring(struct io_ring_ctx *ctx, struct sqe_submit *s)
+{
+	struct io_sq_ring *ring = ctx->sq_ring;
+	unsigned head;
+
+	/*
+	 * The cached sq head (or cq tail) serves two purposes:
+	 *
+	 * 1) allows us to batch the cost of updating the user visible
+	 *    head updates.
+	 * 2) allows the kernel side to track the head on its own, even
+	 *    though the application is the one updating it.
+	 */
+	head = ctx->cached_sq_head;
+	smp_rmb();
+	if (head == READ_ONCE(ring->r.tail))
+		return false;
+
+	head = READ_ONCE(ring->array[head & ctx->sq_mask]);
+	if (head < ctx->sq_entries) {
+		s->index = head;
+		s->sqe = &ctx->sq_sqes[head];
+		ctx->cached_sq_head++;
+		return true;
+	}
+
+	/* drop invalid entries */
+	ctx->cached_sq_head++;
+	ring->dropped++;
+	smp_wmb();
+	return false;
+}
+
+static int io_ring_submit(struct io_ring_ctx *ctx, unsigned int to_submit)
+{
+	int i, ret = 0, submit = 0;
+	struct blk_plug plug;
+
+	if (to_submit > IO_PLUG_THRESHOLD)
+		blk_start_plug(&plug);
+
+	for (i = 0; i < to_submit; i++) {
+		struct sqe_submit s;
+
+		if (!io_get_sqring(ctx, &s))
+			break;
+
+		s.has_user = true;
+		ret = io_submit_sqe(ctx, &s);
+		if (ret) {
+			io_drop_sqring(ctx);
+			break;
+		}
+
+		submit++;
+	}
+	io_commit_sqring(ctx);
+
+	if (to_submit > IO_PLUG_THRESHOLD)
+		blk_finish_plug(&plug);
+
+	return submit ? submit : ret;
+}
+
+/*
+ * Wait until events become available, if we don't already have some. The
+ * application must reap them itself, as they reside on the shared cq ring.
+ */
+static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
+			  const sigset_t __user *sig, size_t sigsz)
+{
+	struct io_cq_ring *ring = ctx->cq_ring;
+	sigset_t ksigmask, sigsaved;
+	DEFINE_WAIT(wait);
+	int ret = 0;
+
+	smp_rmb();
+	if (ring->r.head != ring->r.tail)
+		return 0;
+	if (!min_events)
+		return 0;
+
+	if (sig) {
+		ret = set_user_sigmask(sig, &ksigmask, &sigsaved, sigsz);
+		if (ret)
+			return ret;
+	}
+
+	do {
+		prepare_to_wait(&ctx->wait, &wait, TASK_INTERRUPTIBLE);
+
+		ret = 0;
+		smp_rmb();
+		if (ring->r.head != ring->r.tail)
+			break;
+
+		schedule();
+
+		ret = -EINTR;
+		if (signal_pending(current))
+			break;
+	} while (1);
+
+	finish_wait(&ctx->wait, &wait);
+
+	if (sig)
+		restore_user_sigmask(sig, &sigsaved);
+
+	return ring->r.head == ring->r.tail ? ret : 0;
+}
+
+static int __io_uring_enter(struct io_ring_ctx *ctx, unsigned to_submit,
+			    unsigned min_complete, unsigned flags,
+			    const sigset_t __user *sig, size_t sigsz)
+{
+	int submitted, ret;
+
+	submitted = ret = 0;
+	if (to_submit) {
+		to_submit = min(to_submit, ctx->sq_entries);
+
+		submitted = io_ring_submit(ctx, to_submit);
+		if (submitted < 0)
+			return submitted;
+	}
+	if (flags & IORING_ENTER_GETEVENTS) {
+		/*
+		 * The application could have included the 'to_submit' count
+		 * in how many events it wanted to wait for. If we failed to
+		 * submit the desired count, we may need to adjust the number
+		 * of events to poll/wait for.
+		 */
+		if (submitted < to_submit)
+			min_complete = min_t(unsigned, submitted, min_complete);
+
+		ret = io_cqring_wait(ctx, min_complete, sig, sigsz);
+	}
+
+	return submitted ? submitted : ret;
+}
+
+static int io_sq_offload_start(struct io_ring_ctx *ctx)
+{
+	int ret;
+
+	mmgrab(current->mm);
+	ctx->sqo_mm = current->mm;
+
+	ret = -EBADF;
+	ctx->sqo_files = get_files_struct(current);
+	if (!ctx->sqo_files)
+		goto err;
+
+	/* Do QD, or 2 * CPUS, whatever is smallest */
+	ctx->sqo_wq = alloc_workqueue("io_ring-wq", WQ_UNBOUND | WQ_FREEZABLE,
+			min(ctx->sq_entries - 1, 2 * num_online_cpus()));
+	if (!ctx->sqo_wq) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	return 0;
+err:
+	if (ctx->sqo_files) {
+		put_files_struct(ctx->sqo_files);
+		ctx->sqo_files = NULL;
+	}
+	mmdrop(ctx->sqo_mm);
+	ctx->sqo_mm = NULL;
+	return ret;
+}
+
+static void __io_unaccount_mem(struct user_struct *user, unsigned long nr_pages)
+{
+	atomic_long_sub(nr_pages, &user->locked_vm);
+}
+
+static void io_unaccount_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
+{
+	if (ctx->user)
+		__io_unaccount_mem(ctx->user, nr_pages);
+}
+
+static int __io_account_mem(struct user_struct *user, unsigned long nr_pages)
+{
+	unsigned long page_limit, cur_pages, new_pages;
+
+	/* Don't allow more pages than we can safely lock */
+	page_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+
+	do {
+		cur_pages = atomic_long_read(&user->locked_vm);
+		new_pages = cur_pages + nr_pages;
+		if (new_pages > page_limit)
+			return -ENOMEM;
+	} while (atomic_long_cmpxchg(&user->locked_vm, cur_pages,
+					new_pages) != cur_pages);
+
+	return 0;
+}
+
+static void io_mem_free(void *ptr)
+{
+	struct page *page = virt_to_head_page(ptr);
+
+	if (put_page_testzero(page))
+		free_compound_page(page);
+}
+
+static void *io_mem_alloc(size_t size)
+{
+	gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP |
+				__GFP_NORETRY;
+
+	return (void *) __get_free_pages(gfp_flags, get_order(size));
+}
+
+static unsigned long ring_pages(unsigned sq_entries, unsigned cq_entries)
+{
+	struct io_sq_ring *sq_ring;
+	struct io_cq_ring *cq_ring;
+	size_t bytes;
+
+	bytes = struct_size(sq_ring, array, sq_entries);
+	bytes += array_size(sizeof(struct io_uring_sqe), sq_entries);
+	bytes += struct_size(cq_ring, cqes, cq_entries);
+
+	return (bytes + PAGE_SIZE - 1) / PAGE_SIZE;
+}
+
+static void io_ring_ctx_free(struct io_ring_ctx *ctx)
+{
+	destroy_workqueue(ctx->sqo_wq);
+	mmdrop(ctx->sqo_mm);
+	put_files_struct(ctx->sqo_files);
+
+	io_mem_free(ctx->sq_ring);
+	io_mem_free(ctx->sq_sqes);
+	io_mem_free(ctx->cq_ring);
+
+	percpu_ref_exit(&ctx->refs);
+	io_unaccount_mem(ctx, ring_pages(ctx->sq_entries, ctx->cq_entries));
+	kfree(ctx);
+}
+
+static __poll_t io_uring_poll(struct file *file, poll_table *wait)
+{
+	struct io_ring_ctx *ctx = file->private_data;
+	__poll_t mask = 0;
+
+	poll_wait(file, &ctx->cq_wait, wait);
+	smp_rmb();
+	if (ctx->sq_ring->r.tail + 1 != ctx->cached_sq_head)
+		mask |= EPOLLOUT | EPOLLWRNORM;
+	if (ctx->cq_ring->r.head != ctx->cached_cq_tail)
+		mask |= EPOLLIN | EPOLLRDNORM;
+
+	return mask;
+}
+
+static int io_uring_fasync(int fd, struct file *file, int on)
+{
+	struct io_ring_ctx *ctx = file->private_data;
+
+	return fasync_helper(fd, file, on, &ctx->cq_fasync);
+}
+
+static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
+{
+	mutex_lock(&ctx->uring_lock);
+	percpu_ref_kill(&ctx->refs);
+	mutex_unlock(&ctx->uring_lock);
+
+	wait_for_completion(&ctx->ctx_done);
+	io_ring_ctx_free(ctx);
+}
+
+static int io_uring_release(struct inode *inode, struct file *file)
+{
+	struct io_ring_ctx *ctx = file->private_data;
+
+	file->private_data = NULL;
+	io_ring_ctx_wait_and_kill(ctx);
+	return 0;
+}
+
+static int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	loff_t offset = (loff_t) vma->vm_pgoff << PAGE_SHIFT;
+	unsigned long sz = vma->vm_end - vma->vm_start;
+	struct io_ring_ctx *ctx = file->private_data;
+	unsigned long pfn;
+	struct page *page;
+	void *ptr;
+
+	switch (offset) {
+	case IORING_OFF_SQ_RING:
+		ptr = ctx->sq_ring;
+		break;
+	case IORING_OFF_SQES:
+		ptr = ctx->sq_sqes;
+		break;
+	case IORING_OFF_CQ_RING:
+		ptr = ctx->cq_ring;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	page = virt_to_head_page(ptr);
+	if (sz > (PAGE_SIZE << compound_order(page)))
+		return -EINVAL;
+
+	pfn = virt_to_phys(ptr) >> PAGE_SHIFT;
+	return remap_pfn_range(vma, vma->vm_start, pfn, sz, vma->vm_page_prot);
+}
+
+SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
+		u32, min_complete, u32, flags, const sigset_t __user *, sig,
+		size_t, sigsz)
+{
+	struct io_ring_ctx *ctx;
+	long ret = -EBADF;
+	struct fd f;
+
+	if (flags & ~IORING_ENTER_GETEVENTS)
+		return -EINVAL;
+
+	f = fdget(fd);
+	if (!f.file)
+		return -EBADF;
+
+	ret = -EOPNOTSUPP;
+	if (f.file->f_op != &io_uring_fops)
+		goto out_fput;
+
+	ret = -ENXIO;
+	ctx = f.file->private_data;
+	if (!percpu_ref_tryget(&ctx->refs))
+		goto out_fput;
+
+	ret = -EBUSY;
+	if (!mutex_trylock(&ctx->uring_lock))
+		goto out_ctx;
+
+	ret = __io_uring_enter(ctx, to_submit, min_complete, flags, sig, sigsz);
+	mutex_unlock(&ctx->uring_lock);
+out_ctx:
+	io_ring_drop_ctx_refs(ctx, 1);
+out_fput:
+	fdput(f);
+	return ret;
+}
+
+static const struct file_operations io_uring_fops = {
+	.release	= io_uring_release,
+	.mmap		= io_uring_mmap,
+	.poll		= io_uring_poll,
+	.fasync		= io_uring_fasync,
+};
+
+static int io_allocate_scq_urings(struct io_ring_ctx *ctx,
+				  struct io_uring_params *p)
+{
+	struct io_sq_ring *sq_ring;
+	struct io_cq_ring *cq_ring;
+	size_t size;
+
+	sq_ring = io_mem_alloc(struct_size(sq_ring, array, p->sq_entries));
+	if (!sq_ring)
+		return -ENOMEM;
+
+	ctx->sq_ring = sq_ring;
+	sq_ring->ring_mask = p->sq_entries - 1;
+	sq_ring->ring_entries = p->sq_entries;
+	ctx->sq_mask = sq_ring->ring_mask;
+	ctx->sq_entries = sq_ring->ring_entries;
+
+	size = array_size(sizeof(struct io_uring_sqe), p->sq_entries);
+	if (size == SIZE_MAX)
+		return -EOVERFLOW;
+
+	ctx->sq_sqes = io_mem_alloc(size);
+	if (!ctx->sq_sqes) {
+		io_mem_free(ctx->sq_ring);
+		return -ENOMEM;
+	}
+
+	cq_ring = io_mem_alloc(struct_size(cq_ring, cqes, p->cq_entries));
+	if (!cq_ring) {
+		io_mem_free(ctx->sq_ring);
+		io_mem_free(ctx->sq_sqes);
+		return -ENOMEM;
+	}
+
+	ctx->cq_ring = cq_ring;
+	cq_ring->ring_mask = p->cq_entries - 1;
+	cq_ring->ring_entries = p->cq_entries;
+	ctx->cq_mask = cq_ring->ring_mask;
+	ctx->cq_entries = cq_ring->ring_entries;
+	return 0;
+}
+
+static int io_uring_create(unsigned entries, struct io_uring_params *p)
+{
+	struct user_struct *user = NULL;
+	struct io_ring_ctx *ctx;
+	int ret;
+
+	if (!entries || entries > IORING_MAX_ENTRIES)
+		return -EINVAL;
+
+	/*
+	 * Use twice as many entries for the CQ ring. It's possible for the
+	 * application to drive a higher depth than the size of the SQ ring,
+	 * since the sqes are only used at submission time. This allows for
+	 * some flexibility in overcommitting a bit.
+	 */
+	p->sq_entries = roundup_pow_of_two(entries);
+	p->cq_entries = 2 * p->sq_entries;
+
+	if (!capable(CAP_IPC_LOCK)) {
+		user = get_uid(current_user());
+		ret = __io_account_mem(user, ring_pages(p->sq_entries,
+							p->cq_entries));
+		if (ret) {
+			free_uid(user);
+			return ret;
+		}
+	}
+
+	ctx = io_ring_ctx_alloc(p);
+	if (!ctx) {
+		__io_unaccount_mem(user, ring_pages(p->sq_entries,
+							p->cq_entries));
+		free_uid(user);
+		return -ENOMEM;
+	}
+	ctx->compat = in_compat_syscall();
+	ctx->user = user;
+
+	ret = io_allocate_scq_urings(ctx, p);
+	if (ret)
+		goto err;
+
+	ret = io_sq_offload_start(ctx);
+	if (ret)
+		goto err;
+
+	ret = anon_inode_getfd("[io_uring]", &io_uring_fops, ctx,
+				O_RDWR | O_CLOEXEC);
+	if (ret < 0)
+		goto err;
+
+	memset(&p->sq_off, 0, sizeof(p->sq_off));
+	p->sq_off.head = offsetof(struct io_sq_ring, r.head);
+	p->sq_off.tail = offsetof(struct io_sq_ring, r.tail);
+	p->sq_off.ring_mask = offsetof(struct io_sq_ring, ring_mask);
+	p->sq_off.ring_entries = offsetof(struct io_sq_ring, ring_entries);
+	p->sq_off.flags = offsetof(struct io_sq_ring, flags);
+	p->sq_off.dropped = offsetof(struct io_sq_ring, dropped);
+	p->sq_off.array = offsetof(struct io_sq_ring, array);
+
+	memset(&p->cq_off, 0, sizeof(p->cq_off));
+	p->cq_off.head = offsetof(struct io_cq_ring, r.head);
+	p->cq_off.tail = offsetof(struct io_cq_ring, r.tail);
+	p->cq_off.ring_mask = offsetof(struct io_cq_ring, ring_mask);
+	p->cq_off.ring_entries = offsetof(struct io_cq_ring, ring_entries);
+	p->cq_off.overflow = offsetof(struct io_cq_ring, overflow);
+	p->cq_off.cqes = offsetof(struct io_cq_ring, cqes);
+	return ret;
+err:
+	io_ring_ctx_wait_and_kill(ctx);
+	return ret;
+}
+
+/*
+ * Sets up an aio uring context, and returns the fd. Applications asks for a
+ * ring size, we return the actual sq/cq ring sizes (among other things) in the
+ * params structure passed in.
+ */
+static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
+{
+	struct io_uring_params p;
+	long ret;
+	int i;
+
+	if (copy_from_user(&p, params, sizeof(p)))
+		return -EFAULT;
+	for (i = 0; i < ARRAY_SIZE(p.resv); i++) {
+		if (p.resv[i])
+			return -EINVAL;
+	}
+
+	if (p.flags)
+		return -EINVAL;
+
+	ret = io_uring_create(entries, &p);
+	if (ret < 0)
+		return ret;
+
+	if (copy_to_user(params, &p, sizeof(p)))
+		return -EFAULT;
+
+	return ret;
+}
+
+SYSCALL_DEFINE2(io_uring_setup, u32, entries,
+		struct io_uring_params __user *, params)
+{
+	return io_uring_setup(entries, params);
+}
+
+static int __init io_uring_init(void)
+{
+	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC);
+	return 0;
+};
+__initcall(io_uring_init);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 257cccba3062..3072dbaa7869 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -69,6 +69,7 @@ struct file_handle;
 struct sigaltstack;
 struct rseq;
 union bpf_attr;
+struct io_uring_params;
 
 #include <linux/types.h>
 #include <linux/aio_abi.h>
@@ -309,6 +310,11 @@ asmlinkage long sys_io_pgetevents_time32(aio_context_t ctx_id,
 				struct io_event __user *events,
 				struct old_timespec32 __user *timeout,
 				const struct __aio_sigset *sig);
+asmlinkage long sys_io_uring_setup(u32 entries,
+				struct io_uring_params __user *p);
+asmlinkage long sys_io_uring_enter(unsigned int fd, u32 to_submit,
+				u32 min_complete, u32 flags,
+				const sigset_t __user *sig, size_t sigsz);
 
 /* fs/xattr.c */
 asmlinkage long sys_setxattr(const char __user *path, const char __user *name,
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index d90127298f12..87871e7b7ea7 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -740,9 +740,13 @@ __SC_COMP(__NR_io_pgetevents, sys_io_pgetevents, compat_sys_io_pgetevents)
 __SYSCALL(__NR_rseq, sys_rseq)
 #define __NR_kexec_file_load 294
 __SYSCALL(__NR_kexec_file_load,     sys_kexec_file_load)
+#define __NR_io_uring_setup 425
+__SYSCALL(__NR_io_uring_setup, sys_io_uring_setup)
+#define __NR_io_uring_enter 426
+__SYSCALL(__NR_io_uring_enter, sys_io_uring_enter)
 
 #undef __NR_syscalls
-#define __NR_syscalls 295
+#define __NR_syscalls 427
 
 /*
  * 32 bit systems traditionally used different
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
new file mode 100644
index 000000000000..bd47e86701ea
--- /dev/null
+++ b/include/uapi/linux/io_uring.h
@@ -0,0 +1,94 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Header file for the io_uring interface.
+ *
+ * Copyright (C) 2019 Jens Axboe
+ * Copyright (C) 2019 Christoph Hellwig
+ */
+#ifndef LINUX_IO_URING_H
+#define LINUX_IO_URING_H
+
+#include <linux/fs.h>
+#include <linux/types.h>
+
+/*
+ * IO submission data structure (Submission Queue Entry)
+ */
+struct io_uring_sqe {
+	__u8	opcode;		/* type of operation for this sqe */
+	__u8	flags;		/* as of now unused */
+	__u16	ioprio;		/* ioprio for the request */
+	__s32	fd;		/* file descriptor to do IO on */
+	__u64	off;		/* offset into file */
+	__u64	addr;		/* pointer to buffer or iovecs */
+	__u32	len;		/* buffer size or number of iovecs */
+	union {
+		__kernel_rwf_t	rw_flags;
+		__u32		__resv;
+	};
+	__u64	user_data;	/* data to be passed back at completion time */
+	__u64	__pad2[3];
+};
+
+#define IORING_OP_NOP		0
+#define IORING_OP_READV		1
+#define IORING_OP_WRITEV	2
+
+/*
+ * IO completion data structure (Completion Queue Entry)
+ */
+struct io_uring_cqe {
+	__u64	user_data;	/* sqe->data submission passed back */
+	__s32	res;		/* result code for this event */
+	__u32	flags;
+};
+
+/*
+ * Magic offsets for the application to mmap the data it needs
+ */
+#define IORING_OFF_SQ_RING		0ULL
+#define IORING_OFF_CQ_RING		0x8000000ULL
+#define IORING_OFF_SQES			0x10000000ULL
+
+/*
+ * Filled with the offset for mmap(2)
+ */
+struct io_sqring_offsets {
+	__u32 head;
+	__u32 tail;
+	__u32 ring_mask;
+	__u32 ring_entries;
+	__u32 flags;
+	__u32 dropped;
+	__u32 array;
+	__u32 resv[3];
+};
+
+struct io_cqring_offsets {
+	__u32 head;
+	__u32 tail;
+	__u32 ring_mask;
+	__u32 ring_entries;
+	__u32 overflow;
+	__u32 cqes;
+	__u32 resv[4];
+};
+
+/*
+ * io_uring_enter(2) flags
+ */
+#define IORING_ENTER_GETEVENTS	(1U << 0)
+
+/*
+ * Passed in for io_uring_setup(2). Copied back with updated info on success
+ */
+struct io_uring_params {
+	__u32 sq_entries;
+	__u32 cq_entries;
+	__u32 flags;
+	__u32 resv[7];
+	struct io_sqring_offsets sq_off;
+	struct io_cqring_offsets cq_off;
+};
+
+#endif
diff --git a/init/Kconfig b/init/Kconfig
index 513fa544a134..0cf723867e69 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1403,6 +1403,15 @@ config AIO
 	  by some high performance threaded applications. Disabling
 	  this option saves about 7k.
 
+config IO_URING
+	bool "Enable IO uring support" if EXPERT
+	select ANON_INODES
+	default y
+	help
+	  This option enables support for the io_uring interface, enabling
+	  applications to submit and completion IO through submission and
+	  completion rings that are shared between the kernel and application.
+
 config ADVISE_SYSCALLS
 	bool "Enable madvise/fadvise syscalls" if EXPERT
 	default y
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index ab9d0e3c6d50..ee5e523564bb 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -46,6 +46,8 @@ COND_SYSCALL(io_getevents);
 COND_SYSCALL(io_pgetevents);
 COND_SYSCALL_COMPAT(io_getevents);
 COND_SYSCALL_COMPAT(io_pgetevents);
+COND_SYSCALL(io_uring_setup);
+COND_SYSCALL(io_uring_enter);
 
 /* fs/xattr.c */
 
-- 
2.17.1

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
