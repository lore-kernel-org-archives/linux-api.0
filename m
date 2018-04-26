From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/7] aio: remove the extra get_file/fput pair in
 io_submit_one
Date: Thu, 26 Apr 2018 08:41:52 -0700
Message-ID: <20180426154152.GB26258@magnolia>
References: <20180415150108.1341-1-hch@lst.de>
 <20180415150108.1341-5-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180415150108.1341-5-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sun, Apr 15, 2018 at 05:01:05PM +0200, Christoph Hellwig wrote:
> If we release the lockdep write protection token before calling into
> ->write_iter and thus never access the file pointer after an -EIOCBQUEUED
> return from ->write_iter or ->read_iter we don't need this extra
> reference.

Hmm, subtleties lurk to this unfamiliar reader...

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/aio.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index 18507743757a..d7be32cdd1db 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1515,16 +1515,17 @@ static ssize_t aio_write(struct kiocb *req, struct iocb *iocb, bool vectored,
>  		return ret;
>  	ret = rw_verify_area(WRITE, file, &req->ki_pos, iov_iter_count(&iter));
>  	if (!ret) {
> -		req->ki_flags |= IOCB_WRITE;
> -		file_start_write(file);
> -		ret = aio_ret(req, call_write_iter(file, req, &iter));
>  		/*
>  		 * We release freeze protection in aio_complete().  Fool lockdep
>  		 * by telling it the lock got released so that it doesn't
>  		 * complain about held lock when we return to userspace.
>  		 */
> -		if (S_ISREG(file_inode(file)->i_mode))
> +		if (S_ISREG(file_inode(file)->i_mode)) {
> +			__sb_start_write(file_inode(file)->i_sb, SB_FREEZE_WRITE, true);

It took me a while to figure out that this ^^^ is the same as the
file_start_write call that you remove above, can you please update the
comment to note that we take freeze protection for the file before
screwing with lockdep? e.g.,

/*
 * Open-code file_start_write here to grab freeze protection, which will
 * be released by another thread in aio_complete().  Fool lockdep by
 * telling it the lock got released so that it doesn't complain about
 * held lock when we return to userspace.
 */

>  			__sb_writers_release(file_inode(file)->i_sb, SB_FREEZE_WRITE);
> +		}
> +		req->ki_flags |= IOCB_WRITE;
> +		ret = aio_ret(req, call_write_iter(file, req, &iter));
>  	}
>  	kfree(iovec);
>  	return ret;
> @@ -1599,7 +1600,6 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
>  	req->ki_user_iocb = user_iocb;
>  	req->ki_user_data = iocb->aio_data;
>  
> -	get_file(file);

Here we have a reference to *file, but...

>  	switch (iocb->aio_lio_opcode) {
>  	case IOCB_CMD_PREAD:
>  		ret = aio_read(&req->common, iocb, false, compat);
> @@ -1618,7 +1618,6 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
>  		ret = -EINVAL;
>  		break;
>  	}
> -	fput(file);

...by the time we get to here the reference may have gone away, but
you'd have to dig through aio_{read,write} -> call_{r,w}_iter ->
{r,w}_iter in order to figure out that the reference isn't valid
anymore on a EIOCBQUEUED return.

That's a little subtle, can you add a comment about that?

/*
 * If ret is EIOCBQUEUED here, the ->read_iter/->write_iter dropped the
 * reference on *file.  We don't ourselves ensure a reference to the
 * file, so we must be careful about that here and in the subfunctions.
 */

--D

>  
>  	if (ret && ret != -EIOCBQUEUED)
>  		goto out_put_req;
> -- 
> 2.17.0
> 

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
