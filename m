From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 12/19] io_uring: add support for pre-mapped user IO buffers
Date: Fri, 8 Feb 2019 23:54:28 +0100
Message-ID: <CAG48ez0uH_muHobzpwFzdyBWCcWDxbnfpuxABntph6Te+tYxGg@mail.gmail.com>
References: <20190208173423.27014-1-axboe@kernel.dk> <20190208173423.27014-13-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190208173423.27014-13-axboe@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, Avi Kivity <avi@scylladb.com>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 8, 2019 at 6:35 PM Jens Axboe <axboe@kernel.dk> wrote:
> If we have fixed user buffers, we can map them into the kernel when we
> setup the io_uring. That avoids the need to do get_user_pages() for
> each and every IO.
>
> To utilize this feature, the application must call io_uring_register()
> after having setup an io_uring instance, passing in
> IORING_REGISTER_BUFFERS as the opcode. The argument must be a pointer to
> an iovec array, and the nr_args should contain how many iovecs the
> application wishes to map.
>
> If successful, these buffers are now mapped into the kernel, eligible
> for IO. To use these fixed buffers, the application must use the
> IORING_OP_READ_FIXED and IORING_OP_WRITE_FIXED opcodes, and then
> set sqe->index to the desired buffer index. sqe->addr..sqe->addr+seq->len
> must point to somewhere inside the indexed buffer.
>
> The application may register buffers throughout the lifetime of the
> io_uring instance. It can call io_uring_register() with
> IORING_UNREGISTER_BUFFERS as the opcode to unregister the current set of
> buffers, and then register a new set. The application need not
> unregister buffers explicitly before shutting down the io_uring
> instance.
>
> It's perfectly valid to setup a larger buffer, and then sometimes only
> use parts of it for an IO. As long as the range is within the originally
> mapped region, it will work just fine.
>
> For now, buffers must not be file backed. If file backed buffers are
> passed in, the registration will fail with -1/EOPNOTSUPP. This
> restriction may be relaxed in the future.
>
> RLIMIT_MEMLOCK is used to check how much memory we can pin. A somewhat
> arbitrary 1G per buffer size is also imposed.
[...]
>  static int io_import_iovec(struct io_ring_ctx *ctx, int rw,
>                            const struct sqe_submit *s, struct iovec **iovec,
>                            struct iov_iter *iter)
> @@ -711,6 +763,15 @@ static int io_import_iovec(struct io_ring_ctx *ctx, int rw,
>         const struct io_uring_sqe *sqe = s->sqe;
>         void __user *buf = u64_to_user_ptr(READ_ONCE(sqe->addr));
>         size_t sqe_len = READ_ONCE(sqe->len);
> +       u8 opcode;

(You could add a comment here if you want, something like "We're
reading ->opcode for the second time, but the first read doesn't care
whether it's _FIXED or not, so it doesn't matter whether ->opcode
changes concurrently. The first read does care about whether it is a
READ or a WRITE, so we don't trust this read for that purpose and
instead let the caller pass in the read/write flag.")

> +       opcode = READ_ONCE(sqe->opcode);
> +       if (opcode == IORING_OP_READ_FIXED ||
> +           opcode == IORING_OP_WRITE_FIXED) {
> +               ssize_t ret = io_import_fixed(ctx, rw, sqe, iter);
> +               *iovec = NULL;
> +               return ret;
> +       }
>
>         if (!s->has_user)
>                 return EFAULT;
[...]
> @@ -1242,6 +1334,187 @@ static unsigned long ring_pages(unsigned sq_entries, unsigned cq_entries)
>         return (bytes + PAGE_SIZE - 1) / PAGE_SIZE;
>  }
>
> +static int io_sqe_buffer_unregister(struct io_ring_ctx *ctx)
> +{
> +       int i, j;
> +
> +       if (!ctx->user_bufs)
> +               return -ENXIO;
> +
> +       for (i = 0; i < ctx->sq_entries; i++) {

->sq_entries? Shouldn't this be ->nr_user_bufs?

> +               struct io_mapped_ubuf *imu = &ctx->user_bufs[i];
> +
> +               for (j = 0; j < imu->nr_bvecs; j++)
> +                       put_page(imu->bvec[j].bv_page);
> +
> +               io_unaccount_mem(ctx->user, imu->nr_bvecs);
> +               kfree(imu->bvec);
> +               imu->nr_bvecs = 0;
> +       }
> +
> +       kfree(ctx->user_bufs);
> +       ctx->user_bufs = NULL;

(It isn't really necessary, but you could set nr_user_bufs=0 here.)

> +       return 0;
> +}
[...]
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
> +               if (!iov.iov_base || !iov.iov_len)
> +                       goto err;
> +
> +               /* arbitrary limit, but we need something */
> +               if (iov.iov_len > SZ_1G)
> +                       goto err;
> +
> +               ubuf = (unsigned long) iov.iov_base;
> +               end = (ubuf + iov.iov_len + PAGE_SIZE - 1) >> PAGE_SHIFT;
> +               start = ubuf >> PAGE_SHIFT;
> +               nr_pages = end - start;
> +
> +               ret = io_account_mem(ctx->user, nr_pages);

Technically, this accounting is probably a bit off; I think if you
pass in a vector of 4K areas from 1G hugepages, you're going to pin
factor 0x40000 more memory than you think you're pinning.
(get_user_pages() counts references against the head page of a
compound page; nothing in the kernel can tell afterwards which part of
the hugepage you're using.) I'm not sure how much of a problem that
is, but it should probably at least be documented. Unless I'm just
missing something?

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
> +                               ret = -ENOMEM;
> +                               io_unaccount_mem(ctx->user, nr_pages);
> +                               goto err;
> +                       }
> +                       got_pages = nr_pages;
> +               }
> +
> +               imu->bvec = kmalloc_array(nr_pages, sizeof(struct bio_vec),
> +                                               GFP_KERNEL);
> +               if (!imu->bvec) {
> +                       io_unaccount_mem(ctx->user, nr_pages);
> +                       goto err;
> +               }
> +
> +               down_write(&current->mm->mmap_sem);

Weren't you planning to make this down_read()?

> +               pret = get_user_pages_longterm(ubuf, nr_pages, FOLL_WRITE,
> +                                               pages, vmas);
> +               if (pret == nr_pages) {
> +                       /* don't support file backed memory */
> +                       for (j = 0; j < nr_pages; j++) {
> +                               struct vm_area_struct *vma = vmas[j];
> +
> +                               if (vma->vm_file &&
> +                                   !is_file_hugepages(vma->vm_file)) {
> +                                       ret = -EOPNOTSUPP;
> +                                       break;
> +                               }
> +                       }
> +               } else {
> +                       ret = pret < 0 ? pret : -EFAULT;
> +               }
> +               up_write(&current->mm->mmap_sem);
[...]
> +}
[...]
> diff --git a/include/linux/sched/user.h b/include/linux/sched/user.h
> index 39ad98c09c58..c7b5f86b91a1 100644
> --- a/include/linux/sched/user.h
> +++ b/include/linux/sched/user.h
> @@ -40,7 +40,7 @@ struct user_struct {
>         kuid_t uid;
>
>  #if defined(CONFIG_PERF_EVENTS) || defined(CONFIG_BPF_SYSCALL) || \
> -    defined(CONFIG_NET)
> +    defined(CONFIG_NET) || defined(CONFIG_IO_URING)
>         atomic_long_t locked_vm;
>  #endif

You're already using locked_vm in patch 5, right? I think that means
that from patch 5 up to this patch, some kernel configs will fail to
build.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
