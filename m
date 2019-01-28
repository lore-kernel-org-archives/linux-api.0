From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 12/18] io_uring: add support for pre-mapped user IO buffers
Date: Tue, 29 Jan 2019 00:35:50 +0100
Message-ID: <CAG48ez3cJS=RUqyP630du3pNw_wBdM82KOtbX=YY6U4LxfMBew@mail.gmail.com>
References: <20190128213538.13486-1-axboe@kernel.dk> <20190128213538.13486-13-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190128213538.13486-13-axboe@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, Avi Kivity <avi@scylladb.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 28, 2019 at 10:36 PM Jens Axboe <axboe@kernel.dk> wrote:
> If we have fixed user buffers, we can map them into the kernel when we
> setup the io_context. That avoids the need to do get_user_pages() for
> each and every IO.
[...]
> +static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
> +                              void __user *arg, unsigned nr_args)
> +{
> +       int ret;
> +
> +       /* Drop our initial ref and wait for the ctx to be fully idle */
> +       percpu_ref_put(&ctx->refs);

The line above drops a reference that you just got in the caller...

> +       percpu_ref_kill(&ctx->refs);
> +       wait_for_completion(&ctx->ctx_done);
> +
> +       switch (opcode) {
> +       case IORING_REGISTER_BUFFERS:
> +               ret = io_sqe_buffer_register(ctx, arg, nr_args);
> +               break;
> +       case IORING_UNREGISTER_BUFFERS:
> +               ret = -EINVAL;
> +               if (arg || nr_args)
> +                       break;
> +               ret = io_sqe_buffer_unregister(ctx);
> +               break;
> +       default:
> +               ret = -EINVAL;
> +               break;
> +       }
> +
> +       /* bring the ctx back to life */
> +       reinit_completion(&ctx->ctx_done);
> +       percpu_ref_resurrect(&ctx->refs);
> +       percpu_ref_get(&ctx->refs);

And then this line takes a reference that the caller will immediately
drop again? Why?

> +       return ret;
> +}
> +
> +SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
> +               void __user *, arg, unsigned int, nr_args)
> +{
> +       struct io_ring_ctx *ctx;
> +       long ret = -EBADF;
> +       struct fd f;
> +
> +       f = fdget(fd);
> +       if (!f.file)
> +               return -EBADF;
> +
> +       ret = -EOPNOTSUPP;
> +       if (f.file->f_op != &io_uring_fops)
> +               goto out_fput;
> +
> +       ret = -ENXIO;
> +       ctx = f.file->private_data;
> +       if (!percpu_ref_tryget(&ctx->refs))
> +               goto out_fput;

If you are holding the uring_lock of a ctx that can be accessed
through a file descriptor (which you do just after this point), you
know that the percpu_ref isn't zero, right? Why are you doing the
tryget here?

> +       ret = -EBUSY;
> +       if (mutex_trylock(&ctx->uring_lock)) {
> +               ret = __io_uring_register(ctx, opcode, arg, nr_args);
> +               mutex_unlock(&ctx->uring_lock);
> +       }
> +       io_ring_drop_ctx_refs(ctx, 1);
> +out_fput:
> +       fdput(f);
> +       return ret;
> +}

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
