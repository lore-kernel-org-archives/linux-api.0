From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 05/18] Add io_uring IO interface
Date: Tue, 29 Jan 2019 02:29:22 +0100
Message-ID: <CAG48ez2gvgBUKNihnjEWeBv1WZiXWwfxcA2Wf90n8GHLket2Mg@mail.gmail.com>
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
> +static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx)
> +{
> +       struct io_kiocb *req;
> +
> +       /* safe to use the non tryget, as we're inside ring ref already */
> +       percpu_ref_get(&ctx->refs);

Is that true? In the path io_sq_thread() -> io_submit_sqes() ->
io_submit_sqe() -> io_get_req(), I don't see anything that's already
holding a reference for you. Is the worker thread holding a reference
somewhere that I'm missing?

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
