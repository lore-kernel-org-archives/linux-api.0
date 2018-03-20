From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/36] fs: cleanup do_pollfd
Date: Mon, 19 Mar 2018 19:14:27 -0700
Message-ID: <20180320021427.GG7282@magnolia>
References: <20180305212743.16664-1-hch@lst.de>
 <20180305212743.16664-11-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180305212743.16664-11-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Mar 05, 2018 at 01:27:17PM -0800, Christoph Hellwig wrote:
> Use straigline code with failure handling gotos instead of a lot
> of nested conditionals.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/select.c | 48 +++++++++++++++++++++++-------------------------
>  1 file changed, 23 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/select.c b/fs/select.c
> index 686de7b3a1db..c6c504a814f9 100644
> --- a/fs/select.c
> +++ b/fs/select.c
> @@ -806,34 +806,32 @@ static inline __poll_t do_pollfd(struct pollfd *pollfd, poll_table *pwait,
>  				     bool *can_busy_poll,
>  				     __poll_t busy_flag)
>  {
> -	__poll_t mask;
> -	int fd;
> -
> -	mask = 0;
> -	fd = pollfd->fd;
> -	if (fd >= 0) {
> -		struct fd f = fdget(fd);
> -		mask = EPOLLNVAL;
> -		if (f.file) {
> -			/* userland u16 ->events contains POLL... bitmap */
> -			__poll_t filter = demangle_poll(pollfd->events) |
> -						EPOLLERR | EPOLLHUP;
> -			mask = DEFAULT_POLLMASK;
> -			if (f.file->f_op->poll) {
> -				pwait->_key = filter;
> -				pwait->_key |= busy_flag;
> -				mask = f.file->f_op->poll(f.file, pwait);
> -				if (mask & busy_flag)
> -					*can_busy_poll = true;
> -			}
> -			/* Mask out unneeded events. */
> -			mask &= filter;
> -			fdput(f);
> -		}
> +	int fd = pollfd->fd;
> +	__poll_t mask = 0, filter;
> +	struct fd f;
> +
> +	if (fd < 0)
> +		goto out;
> +	mask = EPOLLNVAL;
> +	f = fdget(fd);
> +	if (!f.file)
> +		goto out;
> +
> +	/* userland u16 ->events contains POLL... bitmap */
> +	filter = demangle_poll(pollfd->events) | EPOLLERR | EPOLLHUP;
> +	mask = DEFAULT_POLLMASK;
> +	if (f.file->f_op->poll) {
> +		pwait->_key = filter | busy_flag;
> +		mask = f.file->f_op->poll(f.file, pwait);
> +		if (mask & busy_flag)
> +			*can_busy_poll = true;
>  	}
> +	mask &= filter;		/* Mask out unneeded events. */
> +	fdput(f);
> +
> +out:
>  	/* ... and so does ->revents */
>  	pollfd->revents = mangle_poll(mask);
> -
>  	return mask;
>  }
>  
> -- 
> 2.14.2
> 

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
