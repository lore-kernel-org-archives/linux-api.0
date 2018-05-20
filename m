From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 10/32] aio: implement IOCB_CMD_POLL
Date: Sun, 20 May 2018 06:32:25 +0100
Message-ID: <20180520053219.GZ30522@ZenIV.linux.org.uk>
References: <20180515194833.6906-1-hch@lst.de>
 <20180515194833.6906-11-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180515194833.6906-11-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, May 15, 2018 at 09:48:11PM +0200, Christoph Hellwig wrote:
> +static ssize_t aio_poll(struct aio_kiocb *aiocb, struct iocb *iocb)
> +{
> +	struct kioctx *ctx = aiocb->ki_ctx;
> +	struct poll_iocb *req = &aiocb->poll;
> +	unsigned long flags;
> +	__poll_t mask;
> +
> +	/* reject any unknown events outside the normal event mask. */
> +	if ((u16)iocb->aio_buf != iocb->aio_buf)
> +		return -EINVAL;
> +	/* reject fields that are not defined for poll */
> +	if (iocb->aio_offset || iocb->aio_nbytes || iocb->aio_rw_flags)
> +		return -EINVAL;
> +
> +	req->events = demangle_poll(iocb->aio_buf) | POLLERR | POLLHUP;
> +	req->file = fget(iocb->aio_fildes);
> +	if (unlikely(!req->file))
> +		return -EBADF;
> +	if (!file_has_poll_mask(req->file))
> +		goto out_fail;
> +
> +	req->head = req->file->f_op->get_poll_head(req->file, req->events);
> +	if (!req->head)
> +		goto out_fail;
> +	if (IS_ERR(req->head)) {
> +		mask = EPOLLERR;
> +		goto done;
> +	}
> +
> +	init_waitqueue_func_entry(&req->wait, aio_poll_wake);
> +	aiocb->ki_cancel = aio_poll_cancel;
> +
> +	spin_lock_irqsave(&ctx->ctx_lock, flags);
> +	list_add_tail(&aiocb->ki_list, &ctx->delayed_cancel_reqs);
> +	spin_unlock(&ctx->ctx_lock);

... and io_cancel(2) comes, finds it and inhume^Wcompletes it, leaving us to...

> +	spin_lock(&req->head->lock);

... get buggered on attempt to dereference a pointer fetched from freed and
reused object.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
