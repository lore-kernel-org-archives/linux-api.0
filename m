From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 13/18] io_uring: add file set registration
Date: Tue, 29 Jan 2019 17:36:45 +0100
Message-ID: <CAG48ez2tYBePMCkd-EOdAX1gfVwPJ-fTd-8XKu6J-QPyTXHN9g@mail.gmail.com>
References: <20190128213538.13486-1-axboe@kernel.dk> <20190128213538.13486-14-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190128213538.13486-14-axboe@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, Avi Kivity <avi@scylladb.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 28, 2019 at 10:36 PM Jens Axboe <axboe@kernel.dk> wrote:
> We normally have to fget/fput for each IO we do on a file. Even with
> the batching we do, the cost of the atomic inc/dec of the file usage
> count adds up.
>
> This adds IORING_REGISTER_FILES, and IORING_UNREGISTER_FILES opcodes
> for the io_uring_register(2) system call. The arguments passed in must
> be an array of __s32 holding file descriptors, and nr_args should hold
> the number of file descriptors the application wishes to pin for the
> duration of the io_uring context (or until IORING_UNREGISTER_FILES is
> called).
>
> When used, the application must set IOSQE_FIXED_FILE in the sqe->flags
> member. Then, instead of setting sqe->fd to the real fd, it sets sqe->fd
> to the index in the array passed in to IORING_REGISTER_FILES.
>
> Files are automatically unregistered when the io_uring context is
> torn down. An application need only unregister if it wishes to
> register a few set of fds.

s/few/new/ ?

> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io_uring.c                 | 125 +++++++++++++++++++++++++++++-----
>  include/uapi/linux/io_uring.h |   9 ++-
>  2 files changed, 116 insertions(+), 18 deletions(-)
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 682714d6f217..77993972879b 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -98,6 +98,10 @@ struct io_ring_ctx {
>                 struct fasync_struct    *cq_fasync;
>         } ____cacheline_aligned_in_smp;
>
> +       /* if used, fixed file set */
> +       struct file             **user_files;
> +       unsigned                nr_user_files;

It'd be nice if you could add a comment about locking rules here -
something like "writers must ensure that ->refs is dead, readers must
ensure that ->refs is alive as long as the file* is used".

[...]
> @@ -612,7 +625,14 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>         struct kiocb *kiocb = &req->rw;
>         int ret;
>
> -       kiocb->ki_filp = io_file_get(state, sqe->fd);
> +       if (sqe->flags & IOSQE_FIXED_FILE) {
> +               if (unlikely(!ctx->user_files || sqe->fd >= ctx->nr_user_files))
> +                       return -EBADF;
> +               kiocb->ki_filp = ctx->user_files[sqe->fd];

It doesn't really matter as long as ctx->nr_user_files<=INT_MAX, but
it'd be nice if you could explicitly cast sqe->fd to unsigned here.

> +               req->flags |= REQ_F_FIXED_FILE;
> +       } else {
> +               kiocb->ki_filp = io_file_get(state, sqe->fd);
> +       }
[...]
> +static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
> +                                unsigned nr_args)
> +{
> +       __s32 __user *fds = (__s32 __user *) arg;
> +       int fd, i, ret = 0;
> +
> +       if (ctx->user_files)
> +               return -EBUSY;
> +       if (!nr_args)
> +               return -EINVAL;
> +
> +       ctx->user_files = kcalloc(nr_args, sizeof(struct file *), GFP_KERNEL);
> +       if (!ctx->user_files)
> +               return -ENOMEM;
> +
> +       for (i = 0; i < nr_args; i++) {
> +               ret = -EFAULT;
> +               if (copy_from_user(&fd, &fds[i], sizeof(fd)))
> +                       break;

"i" is signed, but "nr_args" is unsigned. You can't get through that
kcalloc() call with nr_args>=0x80000000 on a normal kernel, someone
would have to set CONFIG_FORCE_MAX_ZONEORDER really high for that, but
still, in theory, if you reach this copy_to_user(..., &fds[i], ...)
with a negative "i", that'd be bad. You might want to make "i"
unsigned here and check that it's at least smaller than UINT_MAX...


> +               ctx->user_files[i] = fget(fd);
> +
> +               ret = -EBADF;
> +               if (!ctx->user_files[i])
> +                       break;
> +               ctx->nr_user_files++;
> +               ret = 0;
> +       }
> +
> +       if (ret)
> +               io_sqe_files_unregister(ctx);
> +
> +       return ret;
> +}
> +

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
