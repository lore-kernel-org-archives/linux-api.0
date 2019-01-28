From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 12/18] io_uring: add support for pre-mapped user IO buffers
Date: Mon, 28 Jan 2019 14:35:32 -0700
Message-ID: <20190128213538.13486-13-axboe@kernel.dk>
References: <20190128213538.13486-1-axboe@kernel.dk>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190128213538.13486-1-axboe@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, Jens Axboe <axboe@kernel.dk>
List-Id: linux-api@vger.kernel.org

If we have fixed user buffers, we can map them into the kernel when we
setup the io_context. That avoids the need to do get_user_pages() for
each and every IO.

To utilize this feature, the application must call io_uring_register()
after having setup an io_uring context, passing in
IORING_REGISTER_BUFFERS as the opcode. The argument must be a pointer
to an iovec array, and the nr_args should contain how many iovecs the
application wishes to map.

If successful, these buffers are now mapped into the kernel, eligible
for IO. To use these fixed buffers, the application must use the
IORING_OP_READ_FIXED and IORING_OP_WRITE_FIXED opcodes, and then
set sqe->index to the desired buffer index. sqe->addr..sqe->addr+seq->len
must point to somewhere inside the indexed buffer.

The application may register buffers throughout the lifetime of the
io_uring context. It can call io_uring_register() with
IORING_UNREGISTER_BUFFERS as the opcode to unregister the current set of
buffers, and then register a new set. The application need not
unregister buffers explicitly before shutting down the io_uring context.

It's perfectly valid to setup a larger buffer, and then sometimes only
use parts of it for an IO. As long as the range is within the originally
mapped region, it will work just fine.

For now, buffers must not be file backed. If file backed buffers are
passed in, the registration will fail with -1/EOPNOTSUPP. This
restriction may be relaxed in the future.

RLIMIT_MEMLOCK is used to check how much memory we can pin. A somewhat
arbitrary 1G per buffer size is also imposed.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 arch/x86/entry/syscalls/syscall_32.tbl |   1 +
 arch/x86/entry/syscalls/syscall_64.tbl |   1 +
 fs/io_uring.c                          | 356 ++++++++++++++++++++++++-
 include/linux/sched/user.h             |   2 +-
 include/linux/syscalls.h               |   2 +
 include/uapi/asm-generic/unistd.h      |   4 +-
 include/uapi/linux/io_uring.h          |  13 +-
 kernel/sys_ni.c                        |   1 +
 8 files changed, 366 insertions(+), 14 deletions(-)

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 481c126259e9..2eefd2a7c1ce 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -400,3 +400,4 @@
 386	i386	rseq			sys_rseq			__ia32_sys_rseq
 425	i386	io_uring_setup		sys_io_uring_setup		__ia32_sys_io_uring_setup
 426	i386	io_uring_enter		sys_io_uring_enter		__ia32_sys_io_uring_enter
+427	i386	io_uring_register	sys_io_uring_register		__ia32_sys_io_uring_register
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 6a32a430c8e0..65c026185e61 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -345,6 +345,7 @@
 334	common	rseq			__x64_sys_rseq
 425	common	io_uring_setup		__x64_sys_io_uring_setup
 426	common	io_uring_enter		__x64_sys_io_uring_enter
+427	common	io_uring_register	__x64_sys_io_uring_register
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/fs/io_uring.c b/fs/io_uring.c
index a33f1b1709d0..682714d6f217 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -25,8 +25,10 @@
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 #include <linux/blkdev.h>
+#include <linux/bvec.h>
 #include <linux/anon_inodes.h>
 #include <linux/sched/mm.h>
+#include <linux/sizes.h>
 
 #include <linux/uaccess.h>
 #include <linux/nospec.h>
@@ -57,6 +59,13 @@ struct io_cq_ring {
 	struct io_uring_cqe	cqes[];
 };
 
+struct io_mapped_ubuf {
+	u64		ubuf;
+	size_t		len;
+	struct		bio_vec *bvec;
+	unsigned int	nr_bvecs;
+};
+
 struct io_ring_ctx {
 	struct {
 		struct percpu_ref	refs;
@@ -89,6 +98,10 @@ struct io_ring_ctx {
 		struct fasync_struct	*cq_fasync;
 	} ____cacheline_aligned_in_smp;
 
+	/* if used, fixed mapped user buffers */
+	unsigned		nr_user_bufs;
+	struct io_mapped_ubuf	*user_bufs;
+
 	struct user_struct	*user;
 
 	struct completion	ctx_done;
@@ -663,12 +676,51 @@ static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
 	}
 }
 
+static int io_import_fixed(struct io_ring_ctx *ctx, int rw,
+			   const struct io_uring_sqe *sqe,
+			   struct iov_iter *iter)
+{
+	struct io_mapped_ubuf *imu;
+	size_t len = sqe->len;
+	size_t offset;
+	int index;
+
+	/* attempt to use fixed buffers without having provided iovecs */
+	if (unlikely(!ctx->user_bufs))
+		return -EFAULT;
+	if (unlikely(sqe->buf_index >= ctx->nr_user_bufs))
+		return -EFAULT;
+
+	index = array_index_nospec(sqe->buf_index, ctx->sq_entries);
+	imu = &ctx->user_bufs[index];
+	if ((unsigned long) sqe->addr < imu->ubuf ||
+	    (unsigned long) sqe->addr + len > imu->ubuf + imu->len)
+		return -EFAULT;
+
+	/*
+	 * May not be a start of buffer, set size appropriately
+	 * and advance us to the beginning.
+	 */
+	offset = (unsigned long) sqe->addr - imu->ubuf;
+	iov_iter_bvec(iter, rw, imu->bvec, imu->nr_bvecs, offset + len);
+	if (offset)
+		iov_iter_advance(iter, offset);
+	return 0;
+}
+
 static int io_import_iovec(struct io_ring_ctx *ctx, int rw,
 			   const struct io_uring_sqe *sqe,
 			   struct iovec **iovec, struct iov_iter *iter)
 {
 	void __user *buf = u64_to_user_ptr(sqe->addr);
 
+	if (sqe->opcode == IORING_OP_READ_FIXED ||
+	    sqe->opcode == IORING_OP_WRITE_FIXED) {
+		ssize_t ret = io_import_fixed(ctx, rw, sqe, iter);
+		*iovec = NULL;
+		return ret;
+	}
+
 #ifdef CONFIG_COMPAT
 	if (in_compat_syscall())
 		return compat_import_iovec(rw, buf, sqe->len, UIO_FASTIOV,
@@ -805,7 +857,7 @@ static int io_fsync(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (unlikely(sqe->addr || sqe->ioprio))
+	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index))
 		return -EINVAL;
 	if (unlikely(sqe->fsync_flags & ~IORING_FSYNC_DATASYNC))
 		return -EINVAL;
@@ -840,9 +892,19 @@ static int __io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		ret = io_nop(req, sqe);
 		break;
 	case IORING_OP_READV:
+		if (unlikely(sqe->buf_index))
+			return -EINVAL;
 		ret = io_read(req, sqe, force_nonblock, state);
 		break;
 	case IORING_OP_WRITEV:
+		if (unlikely(sqe->buf_index))
+			return -EINVAL;
+		ret = io_write(req, sqe, force_nonblock, state);
+		break;
+	case IORING_OP_READ_FIXED:
+		ret = io_read(req, sqe, force_nonblock, state);
+		break;
+	case IORING_OP_WRITE_FIXED:
 		ret = io_write(req, sqe, force_nonblock, state);
 		break;
 	case IORING_OP_FSYNC:
@@ -865,14 +927,21 @@ static int __io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	return 0;
 }
 
+static inline bool io_sqe_needs_user(const struct io_uring_sqe *sqe)
+{
+	return !(sqe->opcode == IORING_OP_READ_FIXED ||
+		 sqe->opcode == IORING_OP_WRITE_FIXED);
+}
+
 static void io_sq_wq_submit_work(struct work_struct *work)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	struct sqe_submit *s = &req->submit;
 	u64 user_data = s->sqe->user_data;
 	struct io_ring_ctx *ctx = req->ctx;
-	mm_segment_t old_fs = get_fs();
 	struct files_struct *old_files;
+	mm_segment_t old_fs;
+	bool needs_user;
 	int ret;
 
 	 /* Ensure we clear previously set forced non-block flag */
@@ -881,19 +950,28 @@ static void io_sq_wq_submit_work(struct work_struct *work)
 	old_files = current->files;
 	current->files = ctx->sqo_files;
 
-	if (!mmget_not_zero(ctx->sqo_mm)) {
-		ret = -EFAULT;
-		goto err;
+	/*
+	 * If we're doing IO to fixed buffers, we don't need to get/set
+	 * user context
+	 */
+	needs_user = io_sqe_needs_user(s->sqe);
+	if (needs_user) {
+		if (!mmget_not_zero(ctx->sqo_mm)) {
+			ret = -EFAULT;
+			goto err;
+		}
+		use_mm(ctx->sqo_mm);
+		old_fs = get_fs();
+		set_fs(USER_DS);
 	}
 
-	use_mm(ctx->sqo_mm);
-	set_fs(USER_DS);
-
 	ret = __io_submit_sqe(ctx, req, s, false, NULL);
 
-	set_fs(old_fs);
-	unuse_mm(ctx->sqo_mm);
-	mmput(ctx->sqo_mm);
+	if (needs_user) {
+		set_fs(old_fs);
+		unuse_mm(ctx->sqo_mm);
+		mmput(ctx->sqo_mm);
+	}
 err:
 	if (ret) {
 		io_cqring_add_event(ctx, user_data, ret, 0);
@@ -1194,6 +1272,14 @@ static void *io_mem_alloc(size_t size)
 	return (void *) __get_free_pages(gfp_flags, get_order(size));
 }
 
+static int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
+{
+	if (ctx->user)
+		return __io_account_mem(ctx->user, nr_pages);
+
+	return 0;
+}
+
 static unsigned long ring_pages(unsigned sq_entries, unsigned cq_entries)
 {
 	struct io_sq_ring *sq_ring;
@@ -1207,10 +1293,195 @@ static unsigned long ring_pages(unsigned sq_entries, unsigned cq_entries)
 	return (bytes + PAGE_SIZE - 1) / PAGE_SIZE;
 }
 
+static int io_sqe_buffer_unregister(struct io_ring_ctx *ctx)
+{
+	int i, j;
+
+	if (!ctx->user_bufs)
+		return -ENXIO;
+
+	for (i = 0; i < ctx->sq_entries; i++) {
+		struct io_mapped_ubuf *imu = &ctx->user_bufs[i];
+
+		for (j = 0; j < imu->nr_bvecs; j++)
+			put_page(imu->bvec[j].bv_page);
+
+		io_unaccount_mem(ctx, imu->nr_bvecs);
+		kfree(imu->bvec);
+		imu->nr_bvecs = 0;
+	}
+
+	kfree(ctx->user_bufs);
+	ctx->user_bufs = NULL;
+	free_uid(ctx->user);
+	ctx->user = NULL;
+	return 0;
+}
+
+static int io_copy_iov(struct io_ring_ctx *ctx, struct iovec *dst,
+		       void __user *arg, unsigned index)
+{
+	struct iovec __user *src;
+
+#ifdef CONFIG_COMPAT
+	if (in_compat_syscall()) {
+		struct compat_iovec __user *ciovs;
+		struct compat_iovec ciov;
+
+		ciovs = (struct compat_iovec __user *) arg;
+		if (copy_from_user(&ciov, &ciovs[index], sizeof(ciov)))
+			return -EFAULT;
+
+		dst->iov_base = (void __user *) (unsigned long) ciov.iov_base;
+		dst->iov_len = ciov.iov_len;
+		return 0;
+	}
+#endif
+	src = (struct iovec __user *) arg;
+	if (copy_from_user(dst, &src[index], sizeof(*dst)))
+		return -EFAULT;
+	return 0;
+}
+
+static int io_sqe_buffer_register(struct io_ring_ctx *ctx, void __user *arg,
+				  unsigned nr_args)
+{
+	struct vm_area_struct **vmas = NULL;
+	struct page **pages = NULL;
+	int i, j, got_pages = 0;
+	int ret = -EINVAL;
+
+	if (ctx->user_bufs)
+		return -EBUSY;
+	if (!nr_args || nr_args > UIO_MAXIOV)
+		return -EINVAL;
+
+	ctx->user_bufs = kcalloc(nr_args, sizeof(struct io_mapped_ubuf),
+					GFP_KERNEL);
+	if (!ctx->user_bufs)
+		return -ENOMEM;
+
+	if (!capable(CAP_IPC_LOCK))
+		ctx->user = get_uid(current_user());
+
+	for (i = 0; i < nr_args; i++) {
+		struct io_mapped_ubuf *imu = &ctx->user_bufs[i];
+		unsigned long off, start, end, ubuf;
+		int pret, nr_pages;
+		struct iovec iov;
+		size_t size;
+
+		ret = io_copy_iov(ctx, &iov, arg, i);
+		if (ret)
+			break;
+
+		/*
+		 * Don't impose further limits on the size and buffer
+		 * constraints here, we'll -EINVAL later when IO is
+		 * submitted if they are wrong.
+		 */
+		ret = -EFAULT;
+		if (!iov.iov_base)
+			goto err;
+
+		/* arbitrary limit, but we need something */
+		if (iov.iov_len > SZ_1G)
+			goto err;
+
+		ubuf = (unsigned long) iov.iov_base;
+		end = (ubuf + iov.iov_len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		start = ubuf >> PAGE_SHIFT;
+		nr_pages = end - start;
+
+		ret = io_account_mem(ctx, nr_pages);
+		if (ret)
+			goto err;
+
+		if (!pages || nr_pages > got_pages) {
+			kfree(vmas);
+			kfree(pages);
+			pages = kmalloc_array(nr_pages, sizeof(struct page *),
+						GFP_KERNEL);
+			vmas = kmalloc_array(nr_pages,
+					sizeof(struct vma_area_struct *),
+					GFP_KERNEL);
+			if (!pages || !vmas) {
+				io_unaccount_mem(ctx, nr_pages);
+				goto err;
+			}
+			got_pages = nr_pages;
+		}
+
+		imu->bvec = kmalloc_array(nr_pages, sizeof(struct bio_vec),
+						GFP_KERNEL);
+		if (!imu->bvec) {
+			io_unaccount_mem(ctx, nr_pages);
+			goto err;
+		}
+
+		down_write(&current->mm->mmap_sem);
+		pret = get_user_pages_longterm(ubuf, nr_pages, FOLL_WRITE,
+						pages, vmas);
+		if (pret == nr_pages) {
+			/* don't support file backed memory */
+			for (j = 0; j < nr_pages; j++) {
+				struct vm_area_struct *vma = vmas[j];
+
+				if (vma->vm_file) {
+					ret = -EOPNOTSUPP;
+					break;
+				}
+			}
+		} else {
+			ret = pret < 0 ? pret : -EFAULT;
+		}
+		up_write(&current->mm->mmap_sem);
+		if (ret) {
+			/*
+			 * if we did partial map, or found file backed vmas,
+			 * release any pages we did get
+			 */
+			if (pret > 0) {
+				for (j = 0; j < pret; j++)
+					put_page(pages[j]);
+			}
+			io_unaccount_mem(ctx, nr_pages);
+			goto err;
+		}
+
+		off = ubuf & ~PAGE_MASK;
+		size = iov.iov_len;
+		for (j = 0; j < nr_pages; j++) {
+			size_t vec_len;
+
+			vec_len = min_t(size_t, size, PAGE_SIZE - off);
+			imu->bvec[j].bv_page = pages[j];
+			imu->bvec[j].bv_len = vec_len;
+			imu->bvec[j].bv_offset = off;
+			off = 0;
+			size -= vec_len;
+		}
+		/* store original address for later verification */
+		imu->ubuf = ubuf;
+		imu->len = iov.iov_len;
+		imu->nr_bvecs = nr_pages;
+	}
+	kfree(pages);
+	kfree(vmas);
+	ctx->nr_user_bufs = nr_args;
+	return 0;
+err:
+	kfree(pages);
+	kfree(vmas);
+	io_sqe_buffer_unregister(ctx);
+	return ret;
+}
+
 static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
 	destroy_workqueue(ctx->sqo_wq);
 	io_iopoll_reap_events(ctx);
+	io_sqe_buffer_unregister(ctx);
 
 	io_mem_free(ctx->sq_ring);
 	io_mem_free(ctx->sq_sqes);
@@ -1486,6 +1757,69 @@ SYSCALL_DEFINE2(io_uring_setup, u32, entries,
 	return io_uring_setup(entries, params);
 }
 
+static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
+			       void __user *arg, unsigned nr_args)
+{
+	int ret;
+
+	/* Drop our initial ref and wait for the ctx to be fully idle */
+	percpu_ref_put(&ctx->refs);
+	percpu_ref_kill(&ctx->refs);
+	wait_for_completion(&ctx->ctx_done);
+
+	switch (opcode) {
+	case IORING_REGISTER_BUFFERS:
+		ret = io_sqe_buffer_register(ctx, arg, nr_args);
+		break;
+	case IORING_UNREGISTER_BUFFERS:
+		ret = -EINVAL;
+		if (arg || nr_args)
+			break;
+		ret = io_sqe_buffer_unregister(ctx);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	/* bring the ctx back to life */
+	reinit_completion(&ctx->ctx_done);
+	percpu_ref_resurrect(&ctx->refs);
+	percpu_ref_get(&ctx->refs);
+	return ret;
+}
+
+SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
+		void __user *, arg, unsigned int, nr_args)
+{
+	struct io_ring_ctx *ctx;
+	long ret = -EBADF;
+	struct fd f;
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
+	if (mutex_trylock(&ctx->uring_lock)) {
+		ret = __io_uring_register(ctx, opcode, arg, nr_args);
+		mutex_unlock(&ctx->uring_lock);
+	}
+	io_ring_drop_ctx_refs(ctx, 1);
+out_fput:
+	fdput(f);
+	return ret;
+}
+
 static int __init io_uring_init(void)
 {
 	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC);
diff --git a/include/linux/sched/user.h b/include/linux/sched/user.h
index 39ad98c09c58..c7b5f86b91a1 100644
--- a/include/linux/sched/user.h
+++ b/include/linux/sched/user.h
@@ -40,7 +40,7 @@ struct user_struct {
 	kuid_t uid;
 
 #if defined(CONFIG_PERF_EVENTS) || defined(CONFIG_BPF_SYSCALL) || \
-    defined(CONFIG_NET)
+    defined(CONFIG_NET) || defined(CONFIG_IO_URING)
 	atomic_long_t locked_vm;
 #endif
 
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 3072dbaa7869..3681c05ac538 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -315,6 +315,8 @@ asmlinkage long sys_io_uring_setup(u32 entries,
 asmlinkage long sys_io_uring_enter(unsigned int fd, u32 to_submit,
 				u32 min_complete, u32 flags,
 				const sigset_t __user *sig, size_t sigsz);
+asmlinkage long sys_io_uring_register(unsigned int fd, unsigned int op,
+				void __user *arg, unsigned int nr_args);
 
 /* fs/xattr.c */
 asmlinkage long sys_setxattr(const char __user *path, const char __user *name,
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 87871e7b7ea7..d346229a1eb0 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -744,9 +744,11 @@ __SYSCALL(__NR_kexec_file_load,     sys_kexec_file_load)
 __SYSCALL(__NR_io_uring_setup, sys_io_uring_setup)
 #define __NR_io_uring_enter 426
 __SYSCALL(__NR_io_uring_enter, sys_io_uring_enter)
+#define __NR_io_uring_register 427
+__SYSCALL(__NR_io_uring_register, sys_io_uring_register)
 
 #undef __NR_syscalls
-#define __NR_syscalls 427
+#define __NR_syscalls 428
 
 /*
  * 32 bit systems traditionally used different
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 4fc5fbd07688..03ce7133c3b2 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -29,7 +29,10 @@ struct io_uring_sqe {
 		__u32		fsync_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
-	__u64	__pad2[3];
+	union {
+		__u16	buf_index;	/* index into fixed buffers, if used */
+		__u64	__pad2[3];
+	};
 };
 
 /*
@@ -41,6 +44,8 @@ struct io_uring_sqe {
 #define IORING_OP_READV		1
 #define IORING_OP_WRITEV	2
 #define IORING_OP_FSYNC		3
+#define IORING_OP_READ_FIXED	4
+#define IORING_OP_WRITE_FIXED	5
 
 /*
  * sqe->fsync_flags
@@ -104,4 +109,10 @@ struct io_uring_params {
 	struct io_cqring_offsets cq_off;
 };
 
+/*
+ * io_uring_register(2) opcodes and arguments
+ */
+#define IORING_REGISTER_BUFFERS		0
+#define IORING_UNREGISTER_BUFFERS	1
+
 #endif
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index ee5e523564bb..1bb6604dc19f 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -48,6 +48,7 @@ COND_SYSCALL_COMPAT(io_getevents);
 COND_SYSCALL_COMPAT(io_pgetevents);
 COND_SYSCALL(io_uring_setup);
 COND_SYSCALL(io_uring_enter);
+COND_SYSCALL(io_uring_register);
 
 /* fs/xattr.c */
 
-- 
2.17.1

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
