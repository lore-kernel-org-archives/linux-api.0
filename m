From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 05/18] Add io_uring IO interface
Date: Tue, 29 Jan 2019 16:35:54 +0100
Message-ID: <CAG48ez1ZM5KxjYGuDysZfNDQ_RjrrXWAM=vwyOfRi=oFdby1mQ@mail.gmail.com>
References: <20190128213538.13486-1-axboe@kernel.dk> <20190128213538.13486-6-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190128213538.13486-6-axboe@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, Avi Kivity <avi@scylladb.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 28, 2019 at 10:35 PM Jens Axboe <axboe@kernel.dk> wrote:
> The submission queue (SQ) and completion queue (CQ) rings are shared
> between the application and the kernel. This eliminates the need to
> copy data back and forth to submit and complete IO.
[...]
> +static int io_import_iovec(struct io_ring_ctx *ctx, int rw,
> +                          const struct io_uring_sqe *sqe,
> +                          struct iovec **iovec, struct iov_iter *iter)
> +{
> +       void __user *buf = u64_to_user_ptr(sqe->addr);
> +
> +#ifdef CONFIG_COMPAT
> +       if (in_compat_syscall())
> +               return compat_import_iovec(rw, buf, sqe->len, UIO_FASTIOV,
> +                                               iovec, iter);
> +#endif
> +
> +       return import_iovec(rw, buf, sqe->len, UIO_FASTIOV, iovec, iter);
> +}

This code can run in kthread context, right? I think
in_compat_syscall() might not work if this is a kthread launched by a
compat task; I don't see anything that propagates the compat flag to
the kthread.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
