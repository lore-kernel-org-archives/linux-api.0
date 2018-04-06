From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 08/32] aio: replace kiocb_set_cancel_fn with a
 cancel_kiocb file operation
Date: Fri, 6 Apr 2018 03:15:53 +0100
Message-ID: <20180406021553.GS30522@ZenIV.linux.org.uk>
References: <20180330150809.28094-1-hch@lst.de>
 <20180330150809.28094-9-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180330150809.28094-9-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Mar 30, 2018 at 05:07:45PM +0200, Christoph Hellwig wrote:
> The current kiocb_set_cancel_fn implementation assumes the kiocb is
> embedded into an aio_kiocb, which is fundamentally unsafe as it might
> have been submitted by non-aio callers.  Instead add a cancel_kiocb
> file operation that replaced the ki_cancel function pointer set by
> kiocb_set_cancel_fn, and only adds iocbs to the active list when
> the read/write_iter methods return -EIOCBQUEUED and the file has
> a cancel_kiocb method.

> @@ -1440,6 +1423,16 @@ static inline ssize_t aio_rw_ret(struct kiocb *req, ssize_t ret)
>  {
>  	switch (ret) {
>  	case -EIOCBQUEUED:
> +		if (req->ki_filp->f_op->cancel_kiocb) {

... and by that point req might've been already freed by IO completion on
another CPU.
> +			struct aio_kiocb *iocb =
> +				container_of(req, struct aio_kiocb, rw);
> +			struct kioctx *ctx = iocb->ki_ctx;
> +			unsigned long flags;
> +
> +			spin_lock_irqsave(&ctx->ctx_lock, flags);
> +			list_add_tail(&iocb->ki_list, &ctx->active_reqs);

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
