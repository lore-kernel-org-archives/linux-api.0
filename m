From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH 1/3] fs: pass READ/WRITE to kiocb_set_rw_flags()
Date: Fri, 20 Sep 2019 16:38:55 +0200
Message-ID: <20190920143855.GD25765@quack2.suse.cz>
References: <cover.1568875700.git.osandov@fb.com>
 <d23a40f0ad3fa0631fe6189b94811be473e7cc4a.1568875700.git.osandov@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d23a40f0ad3fa0631fe6189b94811be473e7cc4a.1568875700.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-api@vger.kernel.org, kernel-team@fb.com, Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>
List-Id: linux-api@vger.kernel.org

On Wed 18-09-19 23:53:44, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> A following change will want to check whether an IO is a read or write
> in kiocb_set_rw_flags(). Additionally, aio and io_uring currently set
> the IOCB_WRITE flag on a kiocb right before calling call_write_iter(),
> but we can move that into the common code.
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Omar Sandoval <osandov@fb.com>
...
> index ffe35d97afcb..75c4b7680385 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -3351,8 +3351,11 @@ static inline int iocb_flags(struct file *file)
>  	return res;
>  }
>  
> -static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags)
> +static inline int kiocb_set_rw_flags(int rw, struct kiocb *ki, rwf_t flags)
>  {
> +	if (rw == WRITE)
> +		ki->ki_flags |= IOCB_WRITE;
> +
>  	if (unlikely(flags & ~RWF_SUPPORTED))
>  		return -EOPNOTSUPP;

I'd find it more natural if the destination argument (i.e., kiocb) stayed
to be the first argument of the function. Otherwise the patch looks good to
me.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
