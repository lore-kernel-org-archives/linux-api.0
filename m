From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 14/19] io_uring: add file set registration
Date: Fri, 8 Feb 2019 21:26:01 +0100
Message-ID: <CAG48ez2Fp10zQ4Y-x4RJh3Cu=vABu9w8ZrAJThvkh6pr74ZiQw@mail.gmail.com>
References: <20190208173423.27014-1-axboe@kernel.dk> <20190208173423.27014-15-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190208173423.27014-15-axboe@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, Avi Kivity <avi@scylladb.com>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 8, 2019 at 6:35 PM Jens Axboe <axboe@kernel.dk> wrote:
> We normally have to fget/fput for each IO we do on a file. Even with
> the batching we do, the cost of the atomic inc/dec of the file usage
> count adds up.
>
> This adds IORING_REGISTER_FILES, and IORING_UNREGISTER_FILES opcodes
> for the io_uring_register(2) system call. The arguments passed in must
> be an array of __s32 holding file descriptors, and nr_args should hold
> the number of file descriptors the application wishes to pin for the
> duration of the io_uring instance (or until IORING_UNREGISTER_FILES is
> called).
>
> When used, the application must set IOSQE_FIXED_FILE in the sqe->flags
> member. Then, instead of setting sqe->fd to the real fd, it sets sqe->fd
> to the index in the array passed in to IORING_REGISTER_FILES.
>
> Files are automatically unregistered when the io_uring instance is torn
> down. An application need only unregister if it wishes to register a new
> set of fds.

I think the overall concept here is still broken: You're giving the
user_files to the GC, and I think the GC can drop their refcounts, but
I don't see you actually getting feedback from the GC anywhere that
would let the GC break your references? E.g. in io_prep_rw() you grab
file pointers from ctx->user_files after simply checking
ctx->nr_user_files, and there is no path from the GC that touches
those fields. As far as I can tell, the GC is just going to go through
unix_destruct_scm() and drop references on your files, causing
use-after-free.

But the unix GC is complicated, and maybe I'm just missing something...

> +static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
> +{
> +#if defined(CONFIG_UNIX)
> +       if (ctx->ring_sock) {
> +               struct sock *sock = ctx->ring_sock->sk;
> +               struct sk_buff *skb;
> +
> +               while ((skb = skb_dequeue(&sock->sk_receive_queue)) != NULL)
> +                       kfree_skb(skb);
> +       }
> +#else
> +       int i;
> +
> +       for (i = 0; i < ctx->nr_user_files; i++)
> +               fput(ctx->user_files[i]);
> +#endif
> +}
> +
> +static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
> +{
> +       if (!ctx->user_files)
> +               return -ENXIO;
> +
> +       __io_sqe_files_unregister(ctx);
> +       kfree(ctx->user_files);
> +       ctx->user_files = NULL;
> +       return 0;
> +}
> +
> +#if defined(CONFIG_UNIX)
> +static int __io_sqe_files_scm(struct io_ring_ctx *ctx, int nr, int offset)
> +{
> +       struct scm_fp_list *fpl;
> +       struct sk_buff *skb;
> +       int i;
> +
> +       fpl = kzalloc(sizeof(*fpl), GFP_KERNEL);
> +       if (!fpl)
> +               return -ENOMEM;
> +
> +       skb = alloc_skb(0, GFP_KERNEL);
> +       if (!skb) {
> +               kfree(fpl);
> +               return -ENOMEM;
> +       }
> +
> +       skb->sk = ctx->ring_sock->sk;
> +       skb->destructor = unix_destruct_scm;
> +
> +       fpl->user = get_uid(ctx->user);
> +       for (i = 0; i < nr; i++) {
> +               fpl->fp[i] = get_file(ctx->user_files[i + offset]);
> +               unix_inflight(fpl->user, fpl->fp[i]);
> +               fput(fpl->fp[i]);

This pattern is almost always superfluous. You increment the file's
refcount, maybe insert the file into a list (essentially), and drop
the file's refcount back down. You're already holding a stable
reference, and you're not temporarily lending that to anyone else.

> +       }
> +
> +       fpl->max = fpl->count = nr;
> +       UNIXCB(skb).fp = fpl;
> +       skb_queue_head(&ctx->ring_sock->sk->sk_receive_queue, skb);
> +       return 0;
> +}
> +
> +/*
> + * If UNIX sockets are enabled, fd passing can cause a reference cycle which
> + * causes regular reference counting to break down. We rely on the UNIX
> + * garbage collection to take care of this problem for us.
> + */
> +static int io_sqe_files_scm(struct io_ring_ctx *ctx)
> +{
> +       unsigned left, total;
> +       int ret = 0;
> +
> +       total = 0;
> +       left = ctx->nr_user_files;
> +       while (left) {
> +               unsigned this_files = min_t(unsigned, left, SCM_MAX_FD);
> +               int ret;
> +
> +               ret = __io_sqe_files_scm(ctx, this_files, total);
> +               if (ret)
> +                       break;
> +               left -= this_files;
> +               total += this_files;
> +       }
> +
> +       return ret;
> +}
> +#else
> +static int io_sqe_files_scm(struct io_ring_ctx *ctx)
> +{
> +       return 0;
> +}
> +#endif
> +
> +static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
> +                                unsigned nr_args)
> +{
> +       __s32 __user *fds = (__s32 __user *) arg;
> +       int fd, ret = 0;
> +       unsigned i;
> +
> +       if (ctx->user_files)
> +               return -EBUSY;
> +       if (!nr_args)
> +               return -EINVAL;
> +       if (nr_args > IORING_MAX_FIXED_FILES)
> +               return -EMFILE;
> +
> +       ctx->user_files = kcalloc(nr_args, sizeof(struct file *), GFP_KERNEL);
> +       if (!ctx->user_files)
> +               return -ENOMEM;
> +
> +       for (i = 0; i < nr_args; i++) {
> +               ret = -EFAULT;
> +               if (copy_from_user(&fd, &fds[i], sizeof(fd)))
> +                       break;
> +
> +               ctx->user_files[i] = fget(fd);
> +
> +               ret = -EBADF;
> +               if (!ctx->user_files[i])
> +                       break;
> +               /*
> +                * Don't allow io_uring instances to be registered. If UNIX
> +                * isn't enabled, then this causes a reference cycle and this
> +                * instance can never get freed. If UNIX is enabled we'll
> +                * handle it just fine, but there's still no point in allowing
> +                * a ring fd as it doesn't suppor regular read/write anyway.

nit: support

> +                */
> +               if (ctx->user_files[i]->f_op == &io_uring_fops) {
> +                       fput(ctx->user_files[i]);
> +                       break;
> +               }
> +               ctx->nr_user_files++;
> +               ret = 0;
> +       }
> +
> +       if (!ret)
> +               ret = io_sqe_files_scm(ctx);
> +       if (ret)
> +               io_sqe_files_unregister(ctx);
> +
> +       return ret;
> +}
> +
>  static int io_sq_offload_start(struct io_ring_ctx *ctx)
>  {
>         int ret;
> @@ -1521,14 +1708,16 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
>                 destroy_workqueue(ctx->sqo_wq);
>         if (ctx->sqo_mm)
>                 mmdrop(ctx->sqo_mm);
> +
> +       io_iopoll_reap_events(ctx);
> +       io_sqe_buffer_unregister(ctx);
> +       io_sqe_files_unregister(ctx);
> +
>  #if defined(CONFIG_UNIX)
>         if (ctx->ring_sock)
>                 sock_release(ctx->ring_sock);
>  #endif
>
> -       io_iopoll_reap_events(ctx);
> -       io_sqe_buffer_unregister(ctx);

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
