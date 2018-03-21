From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 9/9] aio: implement IOCB_CMD_FSYNC and IOCB_CMD_FDSYNC
Date: Wed, 21 Mar 2018 10:27:13 +0100
Message-ID: <20180321092713.GR14085@kroah.com>
References: <20180321073232.13366-1-hch@lst.de>
 <20180321073232.13366-10-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180321073232.13366-10-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 21, 2018 at 08:32:32AM +0100, Christoph Hellwig wrote:
> Simple workqueue offload for now, but prepared for adding a real aio_fsync
> method if the need arises.  Based on an earlier patch from Dave Chinner.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/aio.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index da87cbf7c67a..79d3eb3d2dd9 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -156,9 +156,16 @@ struct kioctx {
>  	unsigned		id;
>  };
>  
> +struct fsync_iocb {
> +	struct work_struct	work;
> +	struct file		*file;
> +	bool			datasync;
> +};
> +
>  struct aio_kiocb {
>  	union {
>  		struct kiocb		rw;
> +		struct fsync_iocb	fsync;
>  	};
>  
>  	struct kioctx		*ki_ctx;
> @@ -1565,6 +1572,43 @@ static ssize_t aio_write(struct kiocb *req, struct iocb *iocb, bool vectored,
>  	return ret;
>  }
>  
> +static void aio_fsync_work(struct work_struct *work)
> +{
> +	struct fsync_iocb *req = container_of(work, struct fsync_iocb, work);
> +	int ret;
> +
> +	ret = vfs_fsync(req->file, req->datasync);
> +	fput(req->file);
> +	aio_complete(container_of(req, struct aio_kiocb, fsync), ret, 0);
> +}
> +
> +static int aio_fsync(struct fsync_iocb *req, struct iocb *iocb, bool datasync)

I hate the "bool" arguments to functions as you always need to go back
and look them up.  A "wrapper" of "aio_fsync_datasync()" and
"aio_fsync_nodatasync()" around this maybe?

Anyway, very tiny nit, not a big deal, it's your code, you can maintain
it as-is :)

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
