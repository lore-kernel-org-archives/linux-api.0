From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v4 3/3] fs: Add aio iopriority support for block_dev
Date: Fri, 18 May 2018 09:14:07 -0600
Message-ID: <51cbf2e9-1ff9-b9e7-fb68-055a64d54da5@kernel.dk>
References: <20180517203803.2664-1-adam.manzanares@wdc.com>
 <20180517203803.2664-4-adam.manzanares@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180517203803.2664-4-adam.manzanares@wdc.com>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: adam.manzanares@wdc.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, bcrl@kvack.org
Cc: mingo@kernel.org, peterz@infradead.org, pombredanne@nexb.com, gregkh@linuxfoundation.org, bigeasy@linutronix.de, rgoldwyn@suse.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-aio@kvack.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 5/17/18 2:38 PM, adam.manzanares@wdc.com wrote:
> From: Adam Manzanares <adam.manzanares@wdc.com>
> 
> This is the per-I/O equivalent of the ioprio_set system call.
> 
> When IOCB_FLAG_IOPRIO is set on the iocb aio_flags field, then we set the
> newly added kiocb ki_ioprio field to the value in the iocb aio_reqprio field.
> 
> When a bio is created for an aio request by the block dev we set the priority
> value of the bio to the user supplied value.
> 
> This patch depends on block: add ioprio_check_cap function

Actually, one comment on this one:

> diff --git a/fs/aio.c b/fs/aio.c
> index f3eae5d5771b..ff3107aa82d5 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1451,6 +1451,22 @@ static int aio_prep_rw(struct kiocb *req, struct iocb *iocb)
>  	if (iocb->aio_flags & IOCB_FLAG_RESFD)
>  		req->ki_flags |= IOCB_EVENTFD;
>  	req->ki_hint = file_write_hint(req->ki_filp);
> +	if (iocb->aio_flags & IOCB_FLAG_IOPRIO) {
> +		/*
> +		 * If the IOCB_FLAG_IOPRIO flag of aio_flags is set, then
> +		 * aio_reqprio is interpreted as an I/O scheduling
> +		 * class and priority.
> +		 */
> +		ret = ioprio_check_cap(iocb->aio_reqprio);
> +		if (ret) {
> +			pr_debug("aio ioprio check cap error\n");
> +			return -EINVAL;
> +		}
> +
> +		req->ki_ioprio = iocb->aio_reqprio;
> +		req->ki_flags |= IOCB_IOPRIO;
> +	}

Do we really need IOCB_IOPRIO? All zeroes is no priority set anyway,
so we should be able to get by with just setting ->ki_ioprio to either
the priority, or 0.

> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 7ec920e27065..970bef79caa6 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -355,6 +355,8 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
>  		bio->bi_write_hint = iocb->ki_hint;
>  		bio->bi_private = dio;
>  		bio->bi_end_io = blkdev_bio_end_io;
> +		if (iocb->ki_flags & IOCB_IOPRIO)
> +			bio->bi_ioprio = iocb->ki_ioprio;

And then this assignment can just happen unconditionally.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
