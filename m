From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 08/31] aio: implement IOCB_CMD_POLL
Date: Tue, 22 May 2018 23:05:24 +0100
Message-ID: <20180522220524.GE30522@ZenIV.linux.org.uk>
References: <20180522113108.25713-1-hch@lst.de>
 <20180522113108.25713-9-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180522113108.25713-9-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, May 22, 2018 at 01:30:45PM +0200, Christoph Hellwig wrote:

> +static inline void __aio_poll_complete(struct poll_iocb *req, __poll_t mask)
> +{
> +	struct aio_kiocb *iocb = container_of(req, struct aio_kiocb, poll);
> +
> +	fput(req->file);
> +	aio_complete(iocb, mangle_poll(mask), 0);
> +}

Careful.

> +static int aio_poll_cancel(struct kiocb *iocb)
> +{
> +	struct aio_kiocb *aiocb = container_of(iocb, struct aio_kiocb, rw);
> +	struct poll_iocb *req = &aiocb->poll;
> +	struct wait_queue_head *head = req->head;
> +	bool found = false;
> +
> +	spin_lock(&head->lock);
> +	found = __aio_poll_remove(req);
> +	spin_unlock(&head->lock);

What's to guarantee that req->head has not been freed by that point?
Look: wakeup finds ->ctx_lock held, so it leaves the sucker on the
list, removes it from queue and schedules the call of __aio_poll_complete().
Which gets executed just as we hit aio_poll_cancel(), starting with fput().

You really want to do aio_complete() before fput().  That way you know that
req->wait is alive and well at least until iocb gets removed from the list.

> +	req->events = demangle_poll(iocb->aio_buf) | POLLERR | POLLHUP;

EPOLLERR | EPOLLHUP, please.  The values are equal to POLLERR and POLLHUP on
all architectures, but let's avoid misannotations.

> +	spin_lock_irq(&ctx->ctx_lock);
> +	list_add_tail(&aiocb->ki_list, &ctx->active_reqs);
> +
> +	spin_lock(&req->head->lock);
> +	mask = req->file->f_op->poll_mask(req->file, req->events);
> +	if (!mask)
> +		__add_wait_queue(req->head, &req->wait);

ITYM
	if (!mask) {
		__add_wait_queue(req->head, &req->wait);
		list_add_tail(&aiocb->ki_list, &ctx->active_reqs);
	}
What's the point of exposing it to aio_poll_cancel() when it has
never been on waitqueue?

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
