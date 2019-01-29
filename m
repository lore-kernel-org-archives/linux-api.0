From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 12/18] io_uring: add support for pre-mapped user IO buffers
Date: Tue, 29 Jan 2019 23:44:52 +0100
Message-ID: <CAG48ez2VkeSEZA+9H4UAcg86uC77gU=UkTG8L1V58TuR9pDEqg@mail.gmail.com>
References: <20190129192702.3605-1-axboe@kernel.dk> <20190129192702.3605-13-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190129192702.3605-13-axboe@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, Avi Kivity <avi@scylladb.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 29, 2019 at 8:27 PM Jens Axboe <axboe@kernel.dk> wrote:
> If we have fixed user buffers, we can map them into the kernel when we
> setup the io_context. That avoids the need to do get_user_pages() for
> each and every IO.
>
> To utilize this feature, the application must call io_uring_register()
> after having setup an io_uring context, passing in
> IORING_REGISTER_BUFFERS as the opcode. The argument must be a pointer
> to an iovec array, and the nr_args should contain how many iovecs the
> application wishes to map.
>
> If successful, these buffers are now mapped into the kernel, eligible
> for IO. To use these fixed buffers, the application must use the
> IORING_OP_READ_FIXED and IORING_OP_WRITE_FIXED opcodes, and then
> set sqe->index to the desired buffer index. sqe->addr..sqe->addr+seq->len
> must point to somewhere inside the indexed buffer.
>
> The application may register buffers throughout the lifetime of the
> io_uring context. It can call io_uring_register() with
> IORING_UNREGISTER_BUFFERS as the opcode to unregister the current set of
> buffers, and then register a new set. The application need not
> unregister buffers explicitly before shutting down the io_uring context.
[...]
> +static int io_import_fixed(struct io_ring_ctx *ctx, int rw,
> +                          const struct io_uring_sqe *sqe,
> +                          struct iov_iter *iter)
> +{
> +       size_t len = READ_ONCE(sqe->len);
> +       struct io_mapped_ubuf *imu;
> +       int buf_index, index;
> +       size_t offset;
> +       u64 buf_addr;
> +
> +       /* attempt to use fixed buffers without having provided iovecs */
> +       if (unlikely(!ctx->user_bufs))
> +               return -EFAULT;
> +
> +       buf_index = READ_ONCE(sqe->buf_index);
> +       if (unlikely(buf_index >= ctx->nr_user_bufs))
> +               return -EFAULT;

Nit: If you make the local copy of buf_index unsigned, it is slightly
easier to see that this code is correct. (I know, it has to be
positive anyway because the value in shared memory is a u16.)

> +       index = array_index_nospec(buf_index, ctx->sq_entries);

This looks weird. Did you mean s/ctx->sq_entries/ctx->nr_user_bufs/?

> +       imu = &ctx->user_bufs[index];
> +       buf_addr = READ_ONCE(sqe->addr);
> +       if (buf_addr < imu->ubuf || buf_addr + len > imu->ubuf + imu->len)

This can wrap around if `buf_addr` or `len` is very big, right? Then
you e.g. get past the first check because `buf_addr` is sufficiently
big, and get past the second check because `buf_addr + len` wraps
around and becomes small.

> +               return -EFAULT;
> +
> +       /*
> +        * May not be a start of buffer, set size appropriately
> +        * and advance us to the beginning.
> +        */
> +       offset = buf_addr - imu->ubuf;
> +       iov_iter_bvec(iter, rw, imu->bvec, imu->nr_bvecs, offset + len);
> +       if (offset)
> +               iov_iter_advance(iter, offset);
> +       return 0;
> +}
> +
>  static int io_import_iovec(struct io_ring_ctx *ctx, int rw,
>                            const struct io_uring_sqe *sqe, struct iovec **iovec,
>                            struct iov_iter *iter)
>  {
>         void __user *buf = u64_to_user_ptr(READ_ONCE(sqe->addr));
>         size_t sqe_len = READ_ONCE(sqe->len);
> +       int opcode;
> +
> +       opcode = READ_ONCE(sqe->opcode);
> +       if (opcode == IORING_OP_READ_FIXED ||
> +           opcode == IORING_OP_WRITE_FIXED) {
> +               ssize_t ret = io_import_fixed(ctx, rw, sqe, iter);
> +               *iovec = NULL;
> +               return ret;
> +       }
[...]
>
> +static inline bool io_sqe_needs_user(const struct io_uring_sqe *sqe)
> +{
> +       return !(sqe->opcode == IORING_OP_READ_FIXED ||
> +                sqe->opcode == IORING_OP_WRITE_FIXED);
> +}

This still looks racy to me?

>  static void io_sq_wq_submit_work(struct work_struct *work)
>  {
[...]
> -       if (!mmget_not_zero(ctx->sqo_mm)) {
> -               ret = -EFAULT;
> -               goto err;
> +       /*
> +        * If we're doing IO to fixed buffers, we don't need to get/set
> +        * user context
> +        */
> +       needs_user = io_sqe_needs_user(&sqe);
> +       if (needs_user) {
> +               if (!mmget_not_zero(ctx->sqo_mm)) {
> +                       ret = -EFAULT;
> +                       goto err;
> +               }
> +               use_mm(ctx->sqo_mm);
> +               old_fs = get_fs();
> +               set_fs(USER_DS);
>         }
>
> -       use_mm(ctx->sqo_mm);
> -       set_fs(USER_DS);
> -
>         ret = __io_submit_sqe(ctx, req, s, false, NULL);
>
> -       set_fs(old_fs);
> -       unuse_mm(ctx->sqo_mm);
> -       mmput(ctx->sqo_mm);
> +       if (needs_user) {
> +               set_fs(old_fs);
> +               unuse_mm(ctx->sqo_mm);
> +               mmput(ctx->sqo_mm);
> +       }
>  err:
>         if (ret) {
> -               io_cqring_add_event(ctx, user_data, ret, 0);
> +               io_cqring_add_event(ctx, sqe.user_data, ret, 0);
>                 io_free_req(req);
>         }
[...]
> +static int io_copy_iov(struct io_ring_ctx *ctx, struct iovec *dst,
> +                      void __user *arg, unsigned index)
> +{

This function doesn't actually use the "ctx" parameter, right? You
might want to remove it.

> +       struct iovec __user *src;
> +
> +#ifdef CONFIG_COMPAT
> +       if (in_compat_syscall()) {
> +               struct compat_iovec __user *ciovs;
> +               struct compat_iovec ciov;
> +
> +               ciovs = (struct compat_iovec __user *) arg;
> +               if (copy_from_user(&ciov, &ciovs[index], sizeof(ciov)))
> +                       return -EFAULT;
> +
> +               dst->iov_base = (void __user *) (unsigned long) ciov.iov_base;
> +               dst->iov_len = ciov.iov_len;
> +               return 0;
> +       }
> +#endif
> +       src = (struct iovec __user *) arg;
> +       if (copy_from_user(dst, &src[index], sizeof(*dst)))
> +               return -EFAULT;
> +       return 0;
> +}
> +
> +static int io_sqe_buffer_register(struct io_ring_ctx *ctx, void __user *arg,
> +                                 unsigned nr_args)
> +{
> +       struct vm_area_struct **vmas = NULL;
> +       struct page **pages = NULL;
> +       int i, j, got_pages = 0;
> +       int ret = -EINVAL;
> +
> +       if (ctx->user_bufs)
> +               return -EBUSY;
> +       if (!nr_args || nr_args > UIO_MAXIOV)
> +               return -EINVAL;
> +
> +       ctx->user_bufs = kcalloc(nr_args, sizeof(struct io_mapped_ubuf),
> +                                       GFP_KERNEL);
> +       if (!ctx->user_bufs)
> +               return -ENOMEM;
> +
> +       if (!capable(CAP_IPC_LOCK))
> +               ctx->user = get_uid(current_user());
> +
> +       for (i = 0; i < nr_args; i++) {
> +               struct io_mapped_ubuf *imu = &ctx->user_bufs[i];
> +               unsigned long off, start, end, ubuf;
> +               int pret, nr_pages;
> +               struct iovec iov;
> +               size_t size;
> +
> +               ret = io_copy_iov(ctx, &iov, arg, i);
> +               if (ret)
> +                       break;
> +
> +               /*
> +                * Don't impose further limits on the size and buffer
> +                * constraints here, we'll -EINVAL later when IO is
> +                * submitted if they are wrong.
> +                */
> +               ret = -EFAULT;
> +               if (!iov.iov_base)
> +                       goto err;
> +
> +               /* arbitrary limit, but we need something */
> +               if (iov.iov_len > SZ_1G)
> +                       goto err;

You might also want to check for iov_len==0? Otherwise, if iov_base
isn't page-aligned, the following code might grab a reference to one
page even though the iov covers zero pages, that'd be kinda weird.

> +               ubuf = (unsigned long) iov.iov_base;
> +               end = (ubuf + iov.iov_len + PAGE_SIZE - 1) >> PAGE_SHIFT;
> +               start = ubuf >> PAGE_SHIFT;
> +               nr_pages = end - start;
> +
> +               ret = io_account_mem(ctx, nr_pages);
> +               if (ret)
> +                       goto err;
> +
> +               if (!pages || nr_pages > got_pages) {
> +                       kfree(vmas);
> +                       kfree(pages);
> +                       pages = kmalloc_array(nr_pages, sizeof(struct page *),
> +                                               GFP_KERNEL);
> +                       vmas = kmalloc_array(nr_pages,
> +                                       sizeof(struct vma_area_struct *),
> +                                       GFP_KERNEL);
> +                       if (!pages || !vmas) {
> +                               io_unaccount_mem(ctx, nr_pages);
> +                               goto err;
> +                       }
> +                       got_pages = nr_pages;
> +               }
> +
> +               imu->bvec = kmalloc_array(nr_pages, sizeof(struct bio_vec),
> +                                               GFP_KERNEL);
> +               if (!imu->bvec) {
> +                       io_unaccount_mem(ctx, nr_pages);
> +                       goto err;
> +               }
> +
> +               down_write(&current->mm->mmap_sem);

Is there a reason why you're using down_write() and not down_read()?
As far as I can tell, down_read() is all you need...

> +               pret = get_user_pages_longterm(ubuf, nr_pages, FOLL_WRITE,
> +                                               pages, vmas);
> +               if (pret == nr_pages) {
> +                       /* don't support file backed memory */
> +                       for (j = 0; j < nr_pages; j++) {
> +                               struct vm_area_struct *vma = vmas[j];
> +
> +                               if (vma->vm_file) {
> +                                       ret = -EOPNOTSUPP;
> +                                       break;
> +                               }
> +                       }

Are you intentionally doing the check for vma->vm_file instead of
calling GUP with FOLL_ANON, which would automatically verify
vma->vm_ops==NULL for you using vma_is_anonymous()? FOLL_ANON is what
procfs uses to avoid blocking on page faults when reading remote
process memory via /proc/*/{cmdline,environ}. I don't entirely
understand the motivation for this check, so I can't really tell
whether FOLL_ANON would do the job.

> +               } else {
> +                       ret = pret < 0 ? pret : -EFAULT;
> +               }
> +               up_write(&current->mm->mmap_sem);
> +               if (ret) {
> +                       /*
> +                        * if we did partial map, or found file backed vmas,
> +                        * release any pages we did get
> +                        */
> +                       if (pret > 0) {
> +                               for (j = 0; j < pret; j++)
> +                                       put_page(pages[j]);
> +                       }
> +                       io_unaccount_mem(ctx, nr_pages);
> +                       goto err;
> +               }
> +
> +               off = ubuf & ~PAGE_MASK;
> +               size = iov.iov_len;
> +               for (j = 0; j < nr_pages; j++) {
> +                       size_t vec_len;
> +
> +                       vec_len = min_t(size_t, size, PAGE_SIZE - off);
> +                       imu->bvec[j].bv_page = pages[j];
> +                       imu->bvec[j].bv_len = vec_len;
> +                       imu->bvec[j].bv_offset = off;
> +                       off = 0;
> +                       size -= vec_len;
> +               }
> +               /* store original address for later verification */
> +               imu->ubuf = ubuf;
> +               imu->len = iov.iov_len;
> +               imu->nr_bvecs = nr_pages;
> +       }
> +       kfree(pages);
> +       kfree(vmas);
> +       ctx->nr_user_bufs = nr_args;
> +       return 0;
> +err:
> +       kfree(pages);
> +       kfree(vmas);
> +       io_sqe_buffer_unregister(ctx);
> +       return ret;
> +}

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
