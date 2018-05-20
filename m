From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 08/32] aio: replace kiocb_set_cancel_fn with a
 cancel_kiocb file operation
Date: Sun, 20 May 2018 06:27:27 +0100
Message-ID: <20180520052720.GY30522@ZenIV.linux.org.uk>
References: <20180515194833.6906-1-hch@lst.de>
 <20180515194833.6906-9-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180515194833.6906-9-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, May 15, 2018 at 09:48:09PM +0200, Christoph Hellwig wrote:

>  	case -EIOCBQUEUED:
> +		if (req->ki_filp->f_op->cancel_kiocb) {
> +			struct aio_kiocb *iocb =
> +				container_of(req, struct aio_kiocb, rw);
> +			struct kioctx *ctx = iocb->ki_ctx;
> +			unsigned long flags;
> +
> +			spin_lock_irqsave(&ctx->ctx_lock, flags);
> +			list_add_tail(&iocb->ki_list, &ctx->active_reqs);

Use after free - that list insertion used to be done by drivers and doing
so before any ->ki_complete() calls might've happened used to be their
responsibility.  Now you've taken that to the point after ->read_iter()
(or ->write_iter()) return, so there's no way in hell to guarantee it's
not been completed (and freed) by that point.

Incidentally, none of the callers gives a damn about the difference between
0 and -EIOCBQUEUED now, so aio_rw_ret() might as well had been made void...

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
