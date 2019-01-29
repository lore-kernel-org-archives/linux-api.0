From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 05/18] Add io_uring IO interface
Date: Tue, 29 Jan 2019 02:07:08 +0100
Message-ID: <CAG48ez1qxZLfJzK95kjh0RiQ6kvZLbQhr6Dr0EjBNQB6Fr7NXQ@mail.gmail.com>
References: <20190128213538.13486-1-axboe@kernel.dk> <20190128213538.13486-6-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190128213538.13486-6-axboe@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, Avi Kivity <avi@scylladb.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 28, 2019 at 10:35 PM Jens Axboe <axboe@kernel.dk> wrote:
> The submission queue (SQ) and completion queue (CQ) rings are shared
> between the application and the kernel. This eliminates the need to
> copy data back and forth to submit and complete IO.
[...]
> +static bool io_get_sqring(struct io_ring_ctx *ctx, struct sqe_submit *s)
> +{
> +       struct io_sq_ring *ring = ctx->sq_ring;
> +       unsigned head;
> +
> +       /*
> +        * The cached sq head (or cq tail) serves two purposes:
> +        *
> +        * 1) allows us to batch the cost of updating the user visible
> +        *    head updates.
> +        * 2) allows the kernel side to track the head on its own, even
> +        *    though the application is the one updating it.
> +        */
> +       head = ctx->cached_sq_head;
> +       smp_rmb();
> +       if (head == READ_ONCE(ring->r.tail))
> +               return false;
> +
> +       head = ring->array[head & ctx->sq_mask];
> +       if (head < ctx->sq_entries) {
> +               s->index = head;
> +               s->sqe = &ctx->sq_sqes[head];

ring->array can be mapped writable into userspace, right? If so: This
looks like a double-read issue; the compiler might assume that
ring->array is not modified concurrently and perform separate memory
accesses for the "if (head < ctx->sq_entries)" check and the
"&ctx->sq_sqes[head]" computation. Please use READ_ONCE()/WRITE_ONCE()
for all accesses to memory that userspace could concurrently modify in
a malicious way.

There have been some pretty severe security bugs caused by missing
READ_ONCE() annotations around accesses to shared memory; see, for
example, https://www.blackhat.com/docs/us-16/materials/us-16-Wilhelm-Xenpwn-Breaking-Paravirtualized-Devices.pdf
. Slides 35-48 show how the code "switch (op->cmd)", where "op" is a
pointer to shared memory, allowed an attacker to break out of a Xen
virtual machine because the compiler generated multiple memory
accesses.

> +               ctx->cached_sq_head++;
> +               return true;
> +       }
> +
> +       /* drop invalid entries */
> +       ctx->cached_sq_head++;
> +       ring->dropped++;
> +       smp_wmb();
> +       return false;
> +}
[...]
> +SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
> +               u32, min_complete, u32, flags, const sigset_t __user *, sig,
> +               size_t, sigsz)
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

Oh, by the way: If you feel like it, maybe you could add a helper
fdget_typed(int fd, struct file_operations *f_op), or something like
that, so that there is less boilerplate code for first doing fdget(),
then checking ->f_op, and then coding an extra bailout path for that?
But that doesn't really have much to do with your patchset, feel free
to ignore this comment.

[...]
> +out_fput:
> +       fdput(f);
> +       return ret;
> +}

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
