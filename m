From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH 05/18] Add io_uring IO interface
Date: Mon, 28 Jan 2019 16:47:42 -0800
Message-ID: <CALCETrV30uN2qOUEf+kNGWdphBtps7K3rEk8_8+VAwdtPomRkQ@mail.gmail.com>
References: <20190123153536.7081-1-axboe@kernel.dk> <20190123153536.7081-6-axboe@kernel.dk>
 <20190128145700.GA9795@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190128145700.GA9795@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-aio@kvack.org, linux-block@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, Avi Kivity <avi@scylladb.com>, Linux API <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 28, 2019 at 6:57 AM Christoph Hellwig <hch@lst.de> wrote:
>
> [please make sure linux-api and linux-man are CCed on new syscalls
> so that we get API experts to review them]

> > +static int io_import_iovec(struct io_ring_ctx *ctx, int rw,
> > +                        const struct io_uring_sqe *sqe,
> > +                        struct iovec **iovec, struct iov_iter *iter)
> > +{
> > +     void __user *buf = u64_to_user_ptr(sqe->addr);
> > +
> > +#ifdef CONFIG_COMPAT
> > +     if (ctx->compat)
> > +             return compat_import_iovec(rw, buf, sqe->len, UIO_FASTIOV,
> > +                                             iovec, iter);
> > +#endif
>
> I think we can just check in_compat_syscall() here, which means we
> can kill the ->compat member, and the separate compat version of the
> setup syscall.
>

Since this whole API is new, I don't suppose you could introduce a
struct iovec64 or similar and just make the ABI be identical for
64-bit and 32-bit code?

--Andy

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
