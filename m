From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 12/18] io_uring: add support for pre-mapped user IO buffers
Date: Tue, 29 Jan 2019 01:36:44 +0100
Message-ID: <CAG48ez0JjCDtAwbYRKcEOjsMDWmEWKUYHo4nLEDbXmQ9N9Ca=w@mail.gmail.com>
References: <20190128213538.13486-1-axboe@kernel.dk> <20190128213538.13486-13-axboe@kernel.dk>
 <CAG48ez3cJS=RUqyP630du3pNw_wBdM82KOtbX=YY6U4LxfMBew@mail.gmail.com> <cb243bfc-0e3a-d5a4-3087-90af1a1824a0@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <cb243bfc-0e3a-d5a4-3087-90af1a1824a0@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, Avi Kivity <avi@scylladb.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 29, 2019 at 12:50 AM Jens Axboe <axboe@kernel.dk> wrote:
> On 1/28/19 4:35 PM, Jann Horn wrote:
> > On Mon, Jan 28, 2019 at 10:36 PM Jens Axboe <axboe@kernel.dk> wrote:
> >> If we have fixed user buffers, we can map them into the kernel when we
> >> setup the io_context. That avoids the need to do get_user_pages() for
> >> each and every IO.
> > [...]
> >> +static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
> >> +                              void __user *arg, unsigned nr_args)
> >> +{
> >> +       int ret;
> >> +
> >> +       /* Drop our initial ref and wait for the ctx to be fully idle */
> >> +       percpu_ref_put(&ctx->refs);
> >
> > The line above drops a reference that you just got in the caller...
>
> Right
>
> >> +       percpu_ref_kill(&ctx->refs);
> >> +       wait_for_completion(&ctx->ctx_done);
> >> +
> >> +       switch (opcode) {
> >> +       case IORING_REGISTER_BUFFERS:
> >> +               ret = io_sqe_buffer_register(ctx, arg, nr_args);
> >> +               break;
> >> +       case IORING_UNREGISTER_BUFFERS:
> >> +               ret = -EINVAL;
> >> +               if (arg || nr_args)
> >> +                       break;
> >> +               ret = io_sqe_buffer_unregister(ctx);
> >> +               break;
> >> +       default:
> >> +               ret = -EINVAL;
> >> +               break;
> >> +       }
> >> +
> >> +       /* bring the ctx back to life */
> >> +       reinit_completion(&ctx->ctx_done);
> >> +       percpu_ref_resurrect(&ctx->refs);
> >> +       percpu_ref_get(&ctx->refs);
> >
> > And then this line takes a reference that the caller will immediately
> > drop again? Why?
>
> Just want to keep it symmetric and avoid having weird "this function drops
> a reference" use cases.
>
> >
> >> +       return ret;
> >> +}
> >> +
> >> +SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
> >> +               void __user *, arg, unsigned int, nr_args)
> >> +{
> >> +       struct io_ring_ctx *ctx;
> >> +       long ret = -EBADF;
> >> +       struct fd f;
> >> +
> >> +       f = fdget(fd);
> >> +       if (!f.file)
> >> +               return -EBADF;
> >> +
> >> +       ret = -EOPNOTSUPP;
> >> +       if (f.file->f_op != &io_uring_fops)
> >> +               goto out_fput;
> >> +
> >> +       ret = -ENXIO;
> >> +       ctx = f.file->private_data;
> >> +       if (!percpu_ref_tryget(&ctx->refs))
> >> +               goto out_fput;
> >
> > If you are holding the uring_lock of a ctx that can be accessed
> > through a file descriptor (which you do just after this point), you
> > know that the percpu_ref isn't zero, right? Why are you doing the
> > tryget here?
>
> Not sure I follow... We don't hold the lock at this point. I guess your
> point is that since the descriptor is open (or we'd fail the above
> check), then there's no point doing the tryget variant here? That's
> strictly true, that could just be a get().

As far as I can tell, you could do the following without breaking anything:

========================
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6916dc3222cf..c2d82765eefe 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2485,7 +2485,6 @@ static int __io_uring_register(struct
io_ring_ctx *ctx, unsigned opcode,
        int ret;

        /* Drop our initial ref and wait for the ctx to be fully idle */
-       percpu_ref_put(&ctx->refs);
        percpu_ref_kill(&ctx->refs);
        wait_for_completion(&ctx->ctx_done);

@@ -2516,7 +2515,6 @@ static int __io_uring_register(struct
io_ring_ctx *ctx, unsigned opcode,
        /* bring the ctx back to life */
        reinit_completion(&ctx->ctx_done);
        percpu_ref_resurrect(&ctx->refs);
-       percpu_ref_get(&ctx->refs);
        return ret;
 }

@@ -2535,17 +2533,13 @@ SYSCALL_DEFINE4(io_uring_register, unsigned
int, fd, unsigned int, opcode,
        if (f.file->f_op != &io_uring_fops)
                goto out_fput;

-       ret = -ENXIO;
        ctx = f.file->private_data;
-       if (!percpu_ref_tryget(&ctx->refs))
-               goto out_fput;

        ret = -EBUSY;
        if (mutex_trylock(&ctx->uring_lock)) {
                ret = __io_uring_register(ctx, opcode, arg, nr_args);
                mutex_unlock(&ctx->uring_lock);
        }
-       io_ring_drop_ctx_refs(ctx, 1);
 out_fput:
        fdput(f);
        return ret;
========================

The two functions that can drop the initial ref of the percpu refcount are:

1. io_ring_ctx_wait_and_kill(); this is only used on ->release() or on
setup failure, meaning that as long as you have a reference to the
file from fget()/fdget(), io_ring_ctx_wait_and_kill() can't have been
called on your context
2. __io_uring_register(); this temporarily kills the percpu refcount
and resurrects it, all under ctx->uring_lock, meaning that as long as
you're holding ctx->uring_lock, __io_uring_register() can't have
killed the percpu refcount

Therefore, I think that as long as you're in sys_io_uring_register and
holding the ctx->uring_lock, you know that the percpu refcount is
alive, and bumping and dropping non-initial references has no effect.

Perhaps this makes more sense when you view the percpu refcount as a
read/write lock - percpu_ref_tryget() takes a read lock, the
percpu_ref_kill() dance takes a write lock.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
