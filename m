From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 5/6] aio: implement IOCB_CMD_FSYNC and IOCB_CMD_FDSYNC
Date: Fri, 6 Apr 2018 03:59:48 +0100
Message-ID: <20180406025948.GT30522@ZenIV.linux.org.uk>
References: <20180328072639.16885-1-hch@lst.de>
 <20180328072639.16885-6-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180328072639.16885-6-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 28, 2018 at 09:26:38AM +0200, Christoph Hellwig wrote:
> +static int aio_fsync(struct fsync_iocb *req, struct iocb *iocb, bool datasync)
> +{
> +	int ret;
> +
> +	if (iocb->aio_buf)
> +		return -EINVAL;
> +	if (iocb->aio_offset || iocb->aio_nbytes || iocb->aio_rw_flags)
> +		return -EINVAL;
> +
> +	req->file = fget(iocb->aio_fildes);
> +	if (unlikely(!req->file))
> +		return -EBADF;
> +
> +	ret = -EINVAL;
> +	if (!req->file->f_op->fsync)
> +		goto out_fput;
> +
> +	req->datasync = datasync;
> +	INIT_WORK(&req->work, aio_fsync_work);
> +	schedule_work(&req->work);
> +	return -EIOCBQUEUED;
> +out_fput:
> +	if (unlikely(ret && ret != -EIOCBQUEUED))

Really?  The only way to get there is if we got NULL ->f_op->fsync.
So this "if (unlikely(...))" is actually if (true) and I'm not
sure we want that separated anyway - simply

	if (unlikely(!req->file->f_op->fsync)) {
		fput(req->file);
		return -EINVAL;
	}

> +		fput(req->file);

> +	return ret;
> +}

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
