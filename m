From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 06/19] io_uring: add fsync support
Date: Fri, 8 Feb 2019 23:36:32 +0100
Message-ID: <CAG48ez1zUf9GqZyoD3XEEYyeg2zrBSAO5uKT3MKHOPMk6eujDQ@mail.gmail.com>
References: <20190208173423.27014-1-axboe@kernel.dk> <20190208173423.27014-7-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190208173423.27014-7-axboe@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, Avi Kivity <avi@scylladb.com>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 8, 2019 at 6:34 PM Jens Axboe <axboe@kernel.dk> wrote:
> From: Christoph Hellwig <hch@lst.de>
>
> Add a new fsync opcode, which either syncs a range if one is passed,
> or the whole file if the offset and length fields are both cleared
> to zero.  A flag is provided to use fdatasync semantics, that is only
> force out metadata which is required to retrieve the file data, but
> not others like metadata.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
[...]
> +static int io_fsync(struct io_kiocb *req, const struct io_uring_sqe *sqe,
> +                   bool force_nonblock)
> +{
> +       struct io_ring_ctx *ctx = req->ctx;
> +       loff_t sqe_off = READ_ONCE(sqe->off);
> +       loff_t sqe_len = READ_ONCE(sqe->len);
> +       loff_t end = sqe_off + sqe_len;
> +       unsigned fsync_flags;
> +       struct file *file;
> +       int ret, fd;
> +
> +       /* fsync always requires a blocking context */
> +       if (force_nonblock)
> +               return -EAGAIN;
> +
> +       if (unlikely(sqe->addr || sqe->ioprio))
> +               return -EINVAL;
> +
> +       fsync_flags = READ_ONCE(sqe->fsync_flags);
> +       if (unlikely(fsync_flags & ~IORING_FSYNC_DATASYNC))
> +               return -EINVAL;
> +
> +       fd = READ_ONCE(sqe->fd);
> +       file = fget(fd);

This always runs on the workqueue, right? Is it possible to call
fget() on a workqueue?

> +       if (unlikely(!file))
> +               return -EBADF;
> +
> +       ret = vfs_fsync_range(file, sqe_off, end > 0 ? end : LLONG_MAX,
> +                               fsync_flags & IORING_FSYNC_DATASYNC);
> +
> +       fput(file);
> +       io_cqring_add_event(ctx, sqe->user_data, ret, 0);
> +       io_free_req(req);
> +       return 0;
> +}

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
